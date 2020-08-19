Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1224967D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHSHHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgHSG45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10961C061342;
        Tue, 18 Aug 2020 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=phUspKV1itNiNvXugg0T8C3pQjZHOW2XoEjTWMMY+yw=; b=ND9slMe2/aRP+bBv3vIGmMV2TO
        XtbTE47g78mrXrybQ9SSzMSCLhGnJezIt2iHEwiztAjiOUHUhFd73GD1C5w56KtmQwj3JZg3c71uf
        ZYOehL5O9zHE3gPI4TRyavuGCoZPdyYLLTl+7AkEgZC39lCvQEB4CpxnMiLGldOEjjfV/uRQEneW9
        ioOb1GkjTu+aLuRBIhLUAl/A5qpuKikVciZELA+TkZtBAEO8KvEv7F0aREIMBJCfH3TgyTh0ZG5Qh
        Vlk4QPKK9gSLZnBkG0i3eLbtb8PvNTREAbgjxqryUqwwAZ/XlYC8LV4DfDOvf7n6kHAdRfZvd0P7y
        SVVJ2yFA==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I14-0008Mw-Qk; Wed, 19 Aug 2020 06:56:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 07/28] 53c700: improve non-coherent DMA handling
Date:   Wed, 19 Aug 2020 08:55:34 +0200
Message-Id: <20200819065555.1802761-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch the 53c700 driver to only use non-coherent descriptor memory if it
really has to because dma_alloc_coherent fails.  This doesn't matter for
any of the platforms it runs on currently, but that will change soon.

To help with this two new helpers to transfer ownership to and from the
device are added that abstract the syncing of the non-coherent memory.
The two current bidirectional cases are mapped to transfers to the
device, as that appears to what they are used for.  Note that for parisc,
which is the only architecture this driver needs to use non-coherent
memory on, the direction argument of dma_cache_sync is ignored, so this
will not change behavior in any way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/53c700.c | 113 +++++++++++++++++++++++-------------------
 drivers/scsi/53c700.h |   9 ++--
 2 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 461b3babb601ef..b197ed9399e2e0 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -269,6 +269,20 @@ NCR_700_get_SXFER(struct scsi_device *SDp)
 					      spi_period(SDp->sdev_target));
 }
 
+static inline void dma_sync_to_dev(struct NCR_700_Host_Parameters *h,
+		void *addr, size_t size)
+{
+	if (h->noncoherent)
+		dma_cache_sync(h->dev, addr, size, DMA_TO_DEVICE);
+}
+
+static inline void dma_sync_from_dev(struct NCR_700_Host_Parameters *h,
+		void *addr, size_t size)
+{
+	if (h->noncoherent)
+		dma_cache_sync(h->dev, addr, size, DMA_FROM_DEVICE);
+}
+
 struct Scsi_Host *
 NCR_700_detect(struct scsi_host_template *tpnt,
 	       struct NCR_700_Host_Parameters *hostdata, struct device *dev)
@@ -283,9 +297,13 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->sdev_attrs == NULL)
 		tpnt->sdev_attrs = NCR_700_dev_attrs;
 
-	memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
-				 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
-	if(memory == NULL) {
+	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
+	if (!memory) {
+		hostdata->noncoherent = 1;
+		memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
+					 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	}
+	if (!memory) {
 		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
 		return NULL;
 	}
@@ -339,11 +357,11 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	for (j = 0; j < PATCHES; j++)
 		script[LABELPATCHES[j]] = bS_to_host(pScript + SCRIPT[LABELPATCHES[j]]);
 	/* now patch up fixed addresses. */
-	script_patch_32(hostdata->dev, script, MessageLocation,
+	script_patch_32(hostdata, script, MessageLocation,
 			pScript + MSGOUT_OFFSET);
-	script_patch_32(hostdata->dev, script, StatusAddress,
+	script_patch_32(hostdata, script, StatusAddress,
 			pScript + STATUS_OFFSET);
-	script_patch_32(hostdata->dev, script, ReceiveMsgAddress,
+	script_patch_32(hostdata, script, ReceiveMsgAddress,
 			pScript + MSGIN_OFFSET);
 
 	hostdata->script = script;
@@ -395,8 +413,12 @@ NCR_700_release(struct Scsi_Host *host)
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
-	dma_free_attrs(hostdata->dev, TOTAL_MEM_SIZE, hostdata->script,
-		       hostdata->pScript, DMA_ATTR_NON_CONSISTENT);
+	if (hostdata->noncoherent)
+		dma_free_attrs(hostdata->dev, TOTAL_MEM_SIZE, hostdata->script,
+			       hostdata->pScript, DMA_ATTR_NON_CONSISTENT);
+	else
+		dma_free_coherent(hostdata->dev, TOTAL_MEM_SIZE,
+				  hostdata->script, hostdata->pScript);
 	return 1;
 }
 
@@ -804,8 +826,8 @@ process_extended_message(struct Scsi_Host *host,
 			shost_printk(KERN_WARNING, host,
 				"Unexpected SDTR msg\n");
 			hostdata->msgout[0] = A_REJECT_MSG;
-			dma_cache_sync(hostdata->dev, hostdata->msgout, 1, DMA_TO_DEVICE);
-			script_patch_16(hostdata->dev, hostdata->script,
+			dma_sync_to_dev(hostdata, hostdata->msgout, 1);
+			script_patch_16(hostdata, hostdata->script,
 			                MessageCount, 1);
 			/* SendMsgOut returns, so set up the return
 			 * address */
@@ -817,9 +839,8 @@ process_extended_message(struct Scsi_Host *host,
 		printk(KERN_INFO "scsi%d: (%d:%d), Unsolicited WDTR after CMD, Rejecting\n",
 		       host->host_no, pun, lun);
 		hostdata->msgout[0] = A_REJECT_MSG;
-		dma_cache_sync(hostdata->dev, hostdata->msgout, 1, DMA_TO_DEVICE);
-		script_patch_16(hostdata->dev, hostdata->script, MessageCount,
-		                1);
+		dma_sync_to_dev(hostdata, hostdata->msgout, 1);
+		script_patch_16(hostdata, hostdata->script, MessageCount, 1);
 		resume_offset = hostdata->pScript + Ent_SendMessageWithATN;
 
 		break;
@@ -832,9 +853,8 @@ process_extended_message(struct Scsi_Host *host,
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
-		dma_cache_sync(hostdata->dev, hostdata->msgout, 1, DMA_TO_DEVICE);
-		script_patch_16(hostdata->dev, hostdata->script, MessageCount,
-		                1);
+		dma_sync_to_dev(hostdata, hostdata->msgout, 1);
+		script_patch_16(hostdata, hostdata->script, MessageCount, 1);
 		/* SendMsgOut returns, so set up the return
 		 * address */
 		resume_offset = hostdata->pScript + Ent_SendMessageWithATN;
@@ -917,9 +937,8 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
-		dma_cache_sync(hostdata->dev, hostdata->msgout, 1, DMA_TO_DEVICE);
-		script_patch_16(hostdata->dev, hostdata->script, MessageCount,
-		                1);
+		dma_sync_to_dev(hostdata, hostdata->msgout, 1);
+		script_patch_16(hostdata, hostdata->script, MessageCount, 1);
 		/* SendMsgOut returns, so set up the return
 		 * address */
 		resume_offset = hostdata->pScript + Ent_SendMessageWithATN;
@@ -928,7 +947,7 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 	}
 	NCR_700_writel(temp, host, TEMP_REG);
 	/* set us up to receive another message */
-	dma_cache_sync(hostdata->dev, hostdata->msgin, MSG_ARRAY_SIZE, DMA_FROM_DEVICE);
+	dma_sync_from_dev(hostdata, hostdata->msgin, MSG_ARRAY_SIZE);
 	return resume_offset;
 }
 
@@ -1008,8 +1027,8 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				slot->SG[1].ins = bS_to_host(SCRIPT_RETURN);
 				slot->SG[1].pAddr = 0;
 				slot->resume_offset = hostdata->pScript;
-				dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG[0])*2, DMA_TO_DEVICE);
-				dma_cache_sync(hostdata->dev, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+				dma_sync_to_dev(hostdata, slot->SG, sizeof(slot->SG[0])*2);
+				dma_sync_from_dev(hostdata, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 
 				/* queue the command for reissue */
 				slot->state = NCR_700_SLOT_QUEUED;
@@ -1129,11 +1148,11 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 			hostdata->cmd = slot->cmnd;
 
 			/* re-patch for this command */
-			script_patch_32_abs(hostdata->dev, hostdata->script,
+			script_patch_32_abs(hostdata, hostdata->script,
 			                    CommandAddress, slot->pCmd);
-			script_patch_16(hostdata->dev, hostdata->script,
+			script_patch_16(hostdata, hostdata->script,
 					CommandCount, slot->cmnd->cmd_len);
-			script_patch_32_abs(hostdata->dev, hostdata->script,
+			script_patch_32_abs(hostdata, hostdata->script,
 			                    SGScriptStartAddress,
 					    to32bit(&slot->pSG[0].ins));
 
@@ -1144,14 +1163,14 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 			 * should therefore always clear ACK */
 			NCR_700_writeb(NCR_700_get_SXFER(hostdata->cmd->device),
 				       host, SXFER_REG);
-			dma_cache_sync(hostdata->dev, hostdata->msgin,
-				       MSG_ARRAY_SIZE, DMA_FROM_DEVICE);
-			dma_cache_sync(hostdata->dev, hostdata->msgout,
-				       MSG_ARRAY_SIZE, DMA_TO_DEVICE);
+			dma_sync_from_dev(hostdata, hostdata->msgin,
+				       MSG_ARRAY_SIZE);
+			dma_sync_to_dev(hostdata, hostdata->msgout,
+				       MSG_ARRAY_SIZE);
 			/* I'm just being paranoid here, the command should
 			 * already have been flushed from the cache */
-			dma_cache_sync(hostdata->dev, slot->cmnd->cmnd,
-				       slot->cmnd->cmd_len, DMA_TO_DEVICE);
+			dma_sync_to_dev(hostdata, slot->cmnd->cmnd,
+				       slot->cmnd->cmd_len);
 
 
 			
@@ -1214,8 +1233,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 		hostdata->reselection_id = reselection_id;
 		/* just in case we have a stale simple tag message, clear it */
 		hostdata->msgin[1] = 0;
-		dma_cache_sync(hostdata->dev, hostdata->msgin,
-			       MSG_ARRAY_SIZE, DMA_BIDIRECTIONAL);
+		dma_sync_to_dev(hostdata, hostdata->msgin, MSG_ARRAY_SIZE);
 		if(hostdata->tag_negotiated & (1<<reselection_id)) {
 			resume_offset = hostdata->pScript + Ent_GetReselectionWithTag;
 		} else {
@@ -1329,8 +1347,7 @@ process_selection(struct Scsi_Host *host, __u32 dsp)
 	hostdata->cmd = NULL;
 	/* clear any stale simple tag message */
 	hostdata->msgin[1] = 0;
-	dma_cache_sync(hostdata->dev, hostdata->msgin, MSG_ARRAY_SIZE,
-		       DMA_BIDIRECTIONAL);
+	dma_sync_to_dev(hostdata, hostdata->msgin, MSG_ARRAY_SIZE);
 
 	if(id == 0xff) {
 		/* Selected as target, Ignore */
@@ -1427,30 +1444,26 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 	}
 
-	script_patch_16(hostdata->dev, hostdata->script, MessageCount, count);
-
+	script_patch_16(hostdata, hostdata->script, MessageCount, count);
 
-	script_patch_ID(hostdata->dev, hostdata->script,
-			Device_ID, 1<<scmd_id(SCp));
+	script_patch_ID(hostdata, hostdata->script, Device_ID, 1<<scmd_id(SCp));
 
-	script_patch_32_abs(hostdata->dev, hostdata->script, CommandAddress,
+	script_patch_32_abs(hostdata, hostdata->script, CommandAddress,
 			    slot->pCmd);
-	script_patch_16(hostdata->dev, hostdata->script, CommandCount,
-	                SCp->cmd_len);
+	script_patch_16(hostdata, hostdata->script, CommandCount, SCp->cmd_len);
 	/* finally plumb the beginning of the SG list into the script
 	 * */
-	script_patch_32_abs(hostdata->dev, hostdata->script,
+	script_patch_32_abs(hostdata, hostdata->script,
 	                    SGScriptStartAddress, to32bit(&slot->pSG[0].ins));
 	NCR_700_clear_fifo(SCp->device->host);
 
 	if(slot->resume_offset == 0)
 		slot->resume_offset = hostdata->pScript;
 	/* now perform all the writebacks and invalidates */
-	dma_cache_sync(hostdata->dev, hostdata->msgout, count, DMA_TO_DEVICE);
-	dma_cache_sync(hostdata->dev, hostdata->msgin, MSG_ARRAY_SIZE,
-		       DMA_FROM_DEVICE);
-	dma_cache_sync(hostdata->dev, SCp->cmnd, SCp->cmd_len, DMA_TO_DEVICE);
-	dma_cache_sync(hostdata->dev, hostdata->status, 1, DMA_FROM_DEVICE);
+	dma_sync_to_dev(hostdata, hostdata->msgout, count);
+	dma_sync_from_dev(hostdata, hostdata->msgin, MSG_ARRAY_SIZE);
+	dma_sync_to_dev(hostdata, SCp->cmnd, SCp->cmd_len);
+	dma_sync_from_dev(hostdata, hostdata->status, 1);
 
 	/* set the synchronous period/offset */
 	NCR_700_writeb(NCR_700_get_SXFER(SCp->device),
@@ -1626,7 +1639,7 @@ NCR_700_intr(int irq, void *dev_id)
 					slot->SG[i].ins = bS_to_host(SCRIPT_NOP);
 					slot->SG[i].pAddr = 0;
 				}
-				dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG), DMA_TO_DEVICE);
+				dma_sync_to_dev(hostdata, slot->SG, sizeof(slot->SG));
 				/* and pretend we disconnected after
 				 * the command phase */
 				resume_offset = hostdata->pScript + Ent_MsgInDuringData;
@@ -1878,7 +1891,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 		}
 		slot->SG[i].ins = bS_to_host(SCRIPT_RETURN);
 		slot->SG[i].pAddr = 0;
-		dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG), DMA_TO_DEVICE);
+		dma_sync_to_dev(hostdata, slot->SG, sizeof(slot->SG));
 		DEBUG((" SETTING %p to %x\n",
 		       (&slot->pSG[i].ins),
 		       slot->SG[i].ins));
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index 05fe439b66afe5..0f545b05fe611d 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -209,6 +209,7 @@ struct NCR_700_Host_Parameters {
 #endif
 	__u32	chip710:1;	/* set if really a 710 not 700 */
 	__u32	burst_length:4;	/* set to 0 to disable 710 bursting */
+	__u32	noncoherent:1;	/* needs to use non-coherent DMA */
 
 	/* NOTHING BELOW HERE NEEDS ALTERING */
 	__u32	fast:1;		/* if we can alter the SCSI bus clock
@@ -429,7 +430,7 @@ struct NCR_700_Host_Parameters {
 	for(i=0; i< (sizeof(A_##symbol##_used) / sizeof(__u32)); i++) { \
 		__u32 val = bS_to_cpu((script)[A_##symbol##_used[i]]) + da; \
 		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
-		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
+		dma_sync_to_dev((dev), &(script)[A_##symbol##_used[i]], 4); \
 		DEBUG((" script, patching %s at %d to %pad\n", \
 		       #symbol, A_##symbol##_used[i], &da)); \
 	} \
@@ -441,7 +442,7 @@ struct NCR_700_Host_Parameters {
 	dma_addr_t da = value; \
 	for(i=0; i< (sizeof(A_##symbol##_used) / sizeof(__u32)); i++) { \
 		(script)[A_##symbol##_used[i]] = bS_to_host(da); \
-		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
+		dma_sync_to_dev((dev), &(script)[A_##symbol##_used[i]], 4); \
 		DEBUG((" script, patching %s at %d to %pad\n", \
 		       #symbol, A_##symbol##_used[i], &da)); \
 	} \
@@ -456,7 +457,7 @@ struct NCR_700_Host_Parameters {
 		val &= 0xff00ffff; \
 		val |= ((value) & 0xff) << 16; \
 		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
-		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
+		dma_sync_to_dev((dev), &(script)[A_##symbol##_used[i]], 4); \
 		DEBUG((" script, patching ID field %s at %d to 0x%x\n", \
 		       #symbol, A_##symbol##_used[i], val)); \
 	} \
@@ -470,7 +471,7 @@ struct NCR_700_Host_Parameters {
 		val &= 0xffff0000; \
 		val |= ((value) & 0xffff); \
 		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
-		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
+		dma_sync_to_dev((dev), &(script)[A_##symbol##_used[i]], 4); \
 		DEBUG((" script, patching short field %s at %d to 0x%x\n", \
 		       #symbol, A_##symbol##_used[i], val)); \
 	} \
-- 
2.28.0

