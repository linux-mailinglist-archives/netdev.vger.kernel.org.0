Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B967D55F2F6
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 03:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiF2Btj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 21:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiF2Bth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 21:49:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181B27161
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 18:49:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m2so12693685plx.3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 18:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n0723N0wJnBqETOc3tu2IPC7PcA8SgueAQAhpus212M=;
        b=KMQiqG5pQ3PRsEWTfddRoI1ksKfhXidNfoLLp3l9fbWDRb3gNb3FGm+Y1TLOspCHs0
         JnI9FTBmZvpF8AdgtsOr4aZw5V9XeaKOod+XK3CcPWPgf1AG0xvhYGBuVRNo0ooLjmgm
         IdVJeOeA5xiwjZtH1CgSveJpQrpoMeoHJ5/LgWdDFNsmrFFqic4CMYC5ZpIgMXPI6m80
         qGLHkp2+hsgHkQulcRpl/NpiWUKezNkGXJgE3UVSFoLaTKCWevSlZE0f2FLjOaoF4Fc3
         ILrvKg/LjcGFMRJzOqaw0HEc/RSUjO27bwFgHLb4QEC/ODZ4xyWjbT6osit8r0D+iiqe
         z/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n0723N0wJnBqETOc3tu2IPC7PcA8SgueAQAhpus212M=;
        b=0zRcoPFU6V96MVIuqdNJw4CTvScV/0Tnl2Baz3pd9jy9yfK2Xv9Flpy7KCrQ8IRlAU
         uJMe1yvV+JyWqio/nO4Dbyt3IZk/NbFz3uIB/ZMiBu3/O6o5AYZLqnaPssWwhoW0g0B/
         2pNbqY0AKPyiRMAJo6T+/dEHkgGaAxfDQ2hVb/aw1apHuOQRzxfLlK46p3ktgi00lBAb
         Gw8XZAU2x2cDnsUADjZFO2gpxvKHI7fvre3WsH8o0GquxZi6jjymUfctd3upUjZ1mnz6
         TsKpmXdLQqapNOQ7Ks3uEVAiR2X69gZO0WSo7ecntQEl51++gjOddaJp0U2JSB9pfboH
         jM0Q==
X-Gm-Message-State: AJIora9gqP5Hvd8bW9AJaalOQ4YTitc2QUaP9QTbp4WN50i6fySTcLBS
        +JkTtKIxQMS2lw7Pb5QVW1WDlfSTVO0=
X-Google-Smtp-Source: AGRyM1srxq6cxUIjzzASlwEFrQSaDpvGdMHNxfxBuutALyaYg4Z65NKo0RRS7m14J4x2QG5u5lXywA==
X-Received: by 2002:a17:903:206:b0:16b:a02d:274a with SMTP id r6-20020a170903020600b0016ba02d274amr846025plh.9.1656467375645;
        Tue, 28 Jun 2022 18:49:35 -0700 (PDT)
Received: from tuc-a02.vmware.com.com (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id c16-20020a056a00009000b0051c1b445094sm10221273pfj.7.2022.06.28.18.49.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 18:49:35 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     doshir@vmware.com, jbrouer@redhat.com, lorenzo.bianconi@redhat.com,
        gyang@vmware.com
Subject: [RFC PATCH 2/2] vmxnet3: Add XDP_REDIRECT support.
Date:   Tue, 28 Jun 2022 18:49:27 -0700
Message-Id: <20220629014927.2123-2-u9012063@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220629014927.2123-1-u9012063@gmail.com>
References: <20220629014927.2123-1-u9012063@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds XDP_REDIRECT support for vmxnet3. A new page is allocated
if XDP_REDIRECT is needed, and the packet contents are copied into the new
page so that afterward, the original rx buffer can be unmapped/free without
any issue.

Tested the patch using two VMs, one runs dpdk pktgen, and another
runs:
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e pass
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -r ens160

Results:
XDP_DROP  385K pkt/s
XDP_PASS  351K pkt/s
TX	  21K  pkt/s (not sure if s.t is wrong here)

Need feedbacks:
a. I have to allocate a new page before calling xdp_do_redirect.
   Without doing so, I got several issues such as OOM, CPU soft lockup,
   invalid page acess. I'm still trying to fix it.
b. I don't know whether thse performance number makes sense or not.

Signed-off-by: William Tu <u9012063@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c     | 68 +++++++++++++++++++++++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  4 ++
 drivers/net/vmxnet3/vmxnet3_int.h     |  3 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 549e31a1d485..fa8bff86f55f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1402,6 +1402,46 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 		       struct sk_buff *skb,
 		       struct vmxnet3_tx_queue *tq);
 
+static int
+vmxnet3_xdp_xmit(struct net_device *dev,
+		 int n, struct xdp_frame **frames, u32 flags)
+{
+	struct vmxnet3_adapter *adapter;
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int i, err, cpu;
+	int tq_number;
+	int nxmit_byte = 0, nxmit = 0;
+
+	adapter = netdev_priv(dev);
+
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
+		return -ENETDOWN;
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
+		return -EINVAL;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	tq = &adapter->tx_queue[cpu % tq_number];
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, cpu);
+	for (i = 0; i < n; i++) {
+		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], NULL, tq);
+		if (err) {
+			tq->stats.xdp_xmit_err++;
+			break;
+		}
+		nxmit_byte += frames[i]->len;
+		nxmit++;
+	}
+
+	tq->stats.xdp_xmit += nxmit;
+	__netif_tx_unlock(nq);
+
+	return nxmit;
+}
+
 static int
 vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
 		      struct xdp_frame *xdpf,
@@ -1513,8 +1553,10 @@ vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct sk_buff *skb,
 	int headroom = XDP_PACKET_HEADROOM;
 	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
+	struct page *page;
 	void *orig_data;
 	void *buf_hard_start;
+	int err;
 	u32 act;
 
 	buf_hard_start = skb->data - headroom;
@@ -1557,13 +1599,30 @@ vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct sk_buff *skb,
 		ctx->skb = NULL;
 		break;
 	case XDP_ABORTED:
-		ctx->skb = NULL;
 		trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog, act);
 		rq->stats.xdp_aborted++;
+		ctx->skb = NULL;
 		break;
-	case XDP_REDIRECT: /* Not Supported. */
+	case XDP_REDIRECT:
+		page = alloc_page(GFP_ATOMIC);
+		if (!page) {
+			return XDP_DROP;
+		}
+		xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
+		xdp_prepare_buff(&xdp, page_address(page), headroom, skb->len, false);
+		memcpy(xdp.data, skb->data, skb->len);
+		err = xdp_do_redirect(rq->adapter->netdev, &xdp, rq->xdp_bpf_prog);
+		if (!err) {
+			rq->stats.xdp_redirects++;
+			dev_kfree_skb(ctx->skb);
+		} else {
+			__free_page(page);
+			dev_kfree_skb(ctx->skb);
+			rq->stats.xdp_drops++;
+		}
 		ctx->skb = NULL;
-		fallthrough;
+		*need_xdp_flush = true;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rq->adapter->netdev,
 					    rq->xdp_bpf_prog, act);
@@ -1943,6 +2002,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		vmxnet3_getRxComp(rcd,
 				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
 	}
+	if (need_xdp_flush)
+		xdp_do_flush_map();
 
 	return num_pkts;
 }
@@ -3937,6 +3998,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		.ndo_poll_controller = vmxnet3_netpoll,
 #endif
 		.ndo_bpf = vmxnet3_xdp,
+		.ndo_xdp_xmit = vmxnet3_xdp_xmit,
 	};
 	int err;
 	u32 ver;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 5574c18c0727..b93dab2056e2 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -76,6 +76,10 @@ vmxnet3_tq_driver_stats[] = {
 					 copy_skb_header) },
 	{ "  giant hdr",	offsetof(struct vmxnet3_tq_driver_stats,
 					 oversized_hdr) },
+	{ "  xdp xmit",		offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit) },
+	{ "  xdp xmit err",	offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit_err) },
 };
 
 /* per rq stats maintained by the device */
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 0f3b243302e4..9b8020f08e4c 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -219,6 +219,9 @@ struct vmxnet3_tq_driver_stats {
 	u64 linearized;         /* # of pkts linearized */
 	u64 copy_skb_header;    /* # of times we have to copy skb header */
 	u64 oversized_hdr;
+
+	u64 xdp_xmit;
+	u64 xdp_xmit_err;
 };
 
 struct vmxnet3_tx_ctx {
-- 
2.30.1 (Apple Git-130)

