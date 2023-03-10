Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9451B6B4D08
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCJQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCJQ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643DB862C
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678465527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uORM3Xhzjyx5pSXtVFHzrrBAkab8IB4YL2yYQbG2PCU=;
        b=ayE2vZVtzfK/so+rKY7YYDRLIeuNaqkHeBODKUiNiWOM5R42TMzYpzbEotXqQP32cEebmS
        s4dAoVrDYT8+qJLb3KoFicir2jzG6FfWm5cuZMdxaq5NtME0SAnEEHMhQMiNH+mMM5FbHQ
        McnmDBQBsDo6jplorFRQt7yZJ/z7S54=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-vhIr2a09NJ-Bi14QG2KogA-1; Fri, 10 Mar 2023 11:08:11 -0500
X-MC-Unique: vhIr2a09NJ-Bi14QG2KogA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00B1938041DD;
        Fri, 10 Mar 2023 16:08:11 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE54C492C3E;
        Fri, 10 Mar 2023 16:08:08 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 4/5] pktcdvd: Remove CONFIG_CDROM_PKTCDVD_WCACHE from uapi header
Date:   Fri, 10 Mar 2023 17:07:56 +0100
Message-Id: <20230310160757.199253-5-thuth@redhat.com>
In-Reply-To: <20230310160757.199253-1-thuth@redhat.com>
References: <20230310160757.199253-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_* switches should not be exposed in uapi headers, thus let's get
rid of the USE_WCACHING macro here (which was also named way to generic)
and integrate the logic directly in the only function that needs it.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/block/pktcdvd.c      | 13 +++++++++----
 include/uapi/linux/pktcdvd.h | 11 -----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2f1a92509271..5ae2a80db2c3 100644
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
index 9cbb55d21c94..6a5552dfd6af 100644
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
-- 
2.31.1

