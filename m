Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A366476E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjAJRan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjAJRam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:30:42 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB6F57929;
        Tue, 10 Jan 2023 09:30:41 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m6so19567628lfj.11;
        Tue, 10 Jan 2023 09:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J5rZ8/tNfpG3TEwcidbczu4hDRSvpGy5F76n5awGo8o=;
        b=T6GwdqnJLjArN3uFAv+O1gTybIISG2qQBlxbIafRhcmrJ/YLmI/XtaYMW9KKTZthqg
         w5hKNmGSWQRLWpmz+poUOycy3rVflWhVaghFVdbHWThjhOqcdnNQlfG3a2FUBruUUnrR
         FIhj6xOBSKSit0ng31l5Q0EQg8VqBEjeuBPxLH+l3R5mCsMb1FOlmQZYVXvnc18zjvQ8
         xZkvfmgeKgU/cOLfIlE0aAim9ZG1ZGPsO4G/2CclZox6n6nXDAOeqMXWyw4so5NKSDr5
         rXM9/HcTsGHlZ4NiXIeCt4Vz2WCNOqXJ9MajLGZtqQJ87e4ZYgT58R1VKbhbUUeGvmuc
         KhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5rZ8/tNfpG3TEwcidbczu4hDRSvpGy5F76n5awGo8o=;
        b=rgY3c1sQBqa8oIjh+Ebq9BrZJx4ki8tQKZGvfJV0FZFcnDrD0t/czuBrM81pkAkxOO
         w7IAn270dN1y0kNvqqdgDu1h2D7mrgrUzitvyXwu6xUvcFjlXg8hUhmysME0jutW9G2E
         mOhfBkQYT00cqbs6ubd0RvtI105aGE1c0gspyZrbvZDeV6acXW2I3MG33Fuo32pom34i
         ifUmSSurg82AOa3ynZTvhUebidemxp8PwR1PcCa55850/dLynOjt1S3/Y/4qugpsy6Z7
         oYoU3xTuJMPuiWWAGW/8OIRp2NKOvgKwnfOnF7kUKeAGpNZAlYfVhmYVRBe0W624N5Q+
         DdzQ==
X-Gm-Message-State: AFqh2krf8Cxhzkl1p9GCvOYmkFJ1oDFfnoQzA+11+dSwLzZDh1eSo83c
        /A3GzqPPTfmYx9bWGqZwJ9U=
X-Google-Smtp-Source: AMrXdXtrRuuwihn11CDfXbGo3Sb3ualVTvefUHOm5bJTCXH3EiMVo93xbvKu4nmxDPIqYgPq7PtqAQ==
X-Received: by 2002:ac2:5b41:0:b0:4a4:68b8:9c5b with SMTP id i1-20020ac25b41000000b004a468b89c5bmr19056278lfp.67.1673371839263;
        Tue, 10 Jan 2023 09:30:39 -0800 (PST)
Received: from localhost.localdomain (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.googlemail.com with ESMTPSA id p20-20020a056512235400b004cb430b5b38sm2264272lfu.185.2023.01.10.09.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:30:38 -0800 (PST)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     kvalo@kernel.org, jussi.kivilinna@iki.fi, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        szymon.heidrich@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rndis_wlan: Prevent buffer overflow in rndis_query_oid
Date:   Tue, 10 Jan 2023 18:30:07 +0100
Message-Id: <20230110173007.57110-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since resplen and respoffs are signed integers sufficiently
large values of unsigned int len and offset members of RNDIS
response will result in negative values of prior variables.
This may be utilized to bypass implemented security checks
to either extract memory contents by manipulating offset or
overflow the data buffer via memcpy by manipulating both
offset and len.

Additionally assure that sum of resplen and respoffs does not
overflow so buffer boundaries are kept.

Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/wireless/rndis_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 82a7458e0..d7fc05328 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -697,7 +697,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query_c	*get_c;
 	} u;
 	int ret, buflen;
-	int resplen, respoffs, copylen;
+	u32 resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -740,7 +740,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 			goto exit_unlock;
 		}
 
-		if ((resplen + respoffs) > buflen) {
+		if (resplen > (buflen - respoffs)) {
 			/* Device would have returned more data if buffer would
 			 * have been big enough. Copy just the bits that we got.
 			 */
-- 
2.38.2

