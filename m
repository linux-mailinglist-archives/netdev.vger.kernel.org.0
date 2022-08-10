Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE6E58F0B0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiHJQqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbiHJQqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B8F192AE
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0356261198
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 16:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D92C433D6;
        Wed, 10 Aug 2022 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660149954;
        bh=HlHQepPPEVH9C1+8LnwDu46xw7Y/qGFiv3snUBjxBOE=;
        h=From:To:Cc:Subject:Date:From;
        b=SZpFVurOyotj4F1KrkUFMz8b3Uiar+HVV2CzPeqbMk3r92sb5xzgs5fYBSv73JQyA
         iJZVXTgKj5TsCvy+Bt6rHLMTp2On/btieWeFKWa7+VMv7iq+ocxmCThaSnHQERJ/Wd
         uYNA8auiQCXZVqFXaRg7n1pK34ov7Gzt1Vz6ck4WK7TaSVZPi1rM5nOBUjGewkDt9W
         cyMPik5R38EeMhqAvzM/A0jE8jt1zTz3UzM6UX15aB/+auAmRoL9SiPdeSNh8gDhya
         wPxUNzW88pA75gJ/Q9nOOjB6HYIMsanzkLFBTiKzZFLMsJh7YySbp/2XFqwHbgQwyk
         cUSvRGHeNTPuQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jirislaby@kernel.org, arnd@arndb.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: atm: bring back zatm uAPI
Date:   Wed, 10 Aug 2022 09:45:47 -0700
Message-Id: <20220810164547.484378-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri reports that linux-atm does not build without this header.
Bring it back. It's completely dead code but we can't break
the build for user space :(

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Fixes: 052e1f01bfae ("net: atm: remove support for ZeitNet ZN122x ATM devices")
Link: https://lore.kernel.org/all/8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/atm_zatm.h | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 include/uapi/linux/atm_zatm.h

diff --git a/include/uapi/linux/atm_zatm.h b/include/uapi/linux/atm_zatm.h
new file mode 100644
index 000000000000..5135027b93c1
--- /dev/null
+++ b/include/uapi/linux/atm_zatm.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* atm_zatm.h - Driver-specific declarations of the ZATM driver (for use by
+		driver-specific utilities) */
+
+/* Written 1995-1999 by Werner Almesberger, EPFL LRC/ICA */
+
+
+#ifndef LINUX_ATM_ZATM_H
+#define LINUX_ATM_ZATM_H
+
+/*
+ * Note: non-kernel programs including this file must also include
+ * sys/types.h for struct timeval
+ */
+
+#include <linux/atmapi.h>
+#include <linux/atmioc.h>
+
+#define ZATM_GETPOOL	_IOW('a',ATMIOC_SARPRV+1,struct atmif_sioc)
+						/* get pool statistics */
+#define ZATM_GETPOOLZ	_IOW('a',ATMIOC_SARPRV+2,struct atmif_sioc)
+						/* get statistics and zero */
+#define ZATM_SETPOOL	_IOW('a',ATMIOC_SARPRV+3,struct atmif_sioc)
+						/* set pool parameters */
+
+struct zatm_pool_info {
+	int ref_count;			/* free buffer pool usage counters */
+	int low_water,high_water;	/* refill parameters */
+	int rqa_count,rqu_count;	/* queue condition counters */
+	int offset,next_off;		/* alignment optimizations: offset */
+	int next_cnt,next_thres;	/* repetition counter and threshold */
+};
+
+struct zatm_pool_req {
+	int pool_num;			/* pool number */
+	struct zatm_pool_info info;	/* actual information */
+};
+
+#define ZATM_OAM_POOL		0	/* free buffer pool for OAM cells */
+#define ZATM_AAL0_POOL		1	/* free buffer pool for AAL0 cells */
+#define ZATM_AAL5_POOL_BASE	2	/* first AAL5 free buffer pool */
+#define ZATM_LAST_POOL	ZATM_AAL5_POOL_BASE+10 /* max. 64 kB */
+
+#define ZATM_TIMER_HISTORY_SIZE	16	/* number of timer adjustments to
+					   record; must be 2^n */
+
+#endif
-- 
2.37.1

