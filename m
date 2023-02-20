Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6569C551
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBTGUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjBTGUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:20:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB42F8A75;
        Sun, 19 Feb 2023 22:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l+6M2Hg2VWv7REExXj0y1+ocsKsaxPlFIc1mUwU0F2I=; b=OLNgiYt1OWea+X56z7nZmhL6k2
        nr+HZO5U9UV5o/ENalIFE3xdmB6Ydtd5xIaQRLNoD15tkAHOT/JRBogymNzYlYjC+UzHeNjCc/wDl
        v3Xof0xl1ClYS/ePR1PRx8ADBsT6WrClWeEhFQJ2Po8binIIoxu/y4FvsnLrqY1rnChijmp0YyRtK
        S9ZuSCE70YOVgsggNpzQD2rnyjfRIaaaowgW/DQM/ToNzxq3laL8Hl0nWWQG448y+l+nfCzXhlHWA
        IrzYZ/r9jvmqP6KqGVO7miQgbsKPhz2VPtL2DrvtYElutUMh+VmIxUjRq65Sy4YiffthV4rvNPO4Y
        gM9lD5QA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pTzWy-0038A2-Cy; Mon, 20 Feb 2023 06:20:08 +0000
Date:   Sun, 19 Feb 2023 22:20:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrew Waterman <waterman@eecs.berkeley.edu>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH 4/4] Move USE_WCACHING to drivers/block/pktcdvd.c
Message-ID: <Y/MRGCxfWpm73r79@infradead.org>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-5-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217202301.436895-5-thuth@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 09:23:01PM +0100, Thomas Huth wrote:
> From: Palmer Dabbelt <palmer@dabbelt.com>
> 
> I don't think this was ever intended to be exposed to userspace, but
> it did require an "#ifdef CONFIG_*".  Since the name is kind of
> generic and was only used in one place, I've moved the definition to
> the one user.

I'd just remove USE_WCACHING entirel with something like:

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2f1a92509271c4..5ae2a80db2c341 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1869,12 +1869,12 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 /*
  * enable/disable write caching on drive
  */
-static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
-						int set)
+static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd)
 {
 	struct packet_command cgc;
 	struct scsi_sense_hdr sshdr;
 	unsigned char buf[64];
+	bool set = IS_ENABLED(CONFIG_CDROM_PKTCDVD_WCACHE);
 	int ret;
 
 	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
@@ -1890,7 +1890,12 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 	if (ret)
 		return ret;
 
-	buf[pd->mode_offset + 10] |= (!!set << 2);
+	/*
+	 * use drive write caching -- we need deferred error handling to be
+	 * able to successfully recover with this option (drive will return good
+	 * status as soon as the cdb is validated).
+	 */
+	buf[pd->mode_offset + 10] |= (set << 2);
 
 	cgc.buflen = cgc.cmd[8] = 2 + ((buf[0] << 8) | (buf[1] & 0xff));
 	ret = pkt_mode_select(pd, &cgc);
@@ -2085,7 +2090,7 @@ static int pkt_open_write(struct pktcdvd_device *pd)
 		return -EIO;
 	}
 
-	pkt_write_caching(pd, USE_WCACHING);
+	pkt_write_caching(pd);
 
 	ret = pkt_get_max_speed(pd, &write_speed);
 	if (ret)
diff --git a/include/uapi/linux/pktcdvd.h b/include/uapi/linux/pktcdvd.h
index 9cbb55d21c94af..6a5552dfd6af4e 100644
--- a/include/uapi/linux/pktcdvd.h
+++ b/include/uapi/linux/pktcdvd.h
@@ -29,17 +29,6 @@
  */
 #define PACKET_WAIT_TIME	(HZ * 5 / 1000)
 
-/*
- * use drive write caching -- we need deferred error handling to be
- * able to successfully recover with this option (drive will return good
- * status as soon as the cdb is validated).
- */
-#if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
-#define USE_WCACHING		1
-#else
-#define USE_WCACHING		0
-#endif
-
 /*
  * No user-servicable parts beyond this point ->
  */
