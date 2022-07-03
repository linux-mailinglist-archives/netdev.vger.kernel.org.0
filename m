Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0A5649AA
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiGCUHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCUHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:07:05 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331A2BFA;
        Sun,  3 Jul 2022 13:07:03 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id n8so9347995eda.0;
        Sun, 03 Jul 2022 13:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=woQEtB66hiZnxZHdzVr4409LscRnNd++bG9SeCgzq/Q=;
        b=eDsTqTRHWw80oB4LevKPDn1UgtO0UOqxxoJ9G71TW7xMjbffetl2KamdToL6q0uaXk
         mjCenDRUPAe6uEf5/uJXgU+IyfMewLL8dVfnzXTCLooZkQ/E/2FdzDEyY5PHbi2c7xzA
         uOYbLCU6VSfauBjSS0W6B20Hm5bTqq/iLrK5pUZxv4tJAVlfPS4mejvhkIwlyDZEy+AP
         vNALRCg7j/185Viyrxb73T7Wq1lD/wM8epmWrbp9yMGiF6AFoZgOqW1A2nalc5CseX2k
         1dvmI9j1YKBt01mDB2PWZCBg3TrEA5LRIpzm20cdlSspOBBGIS94UxE/DM1gMbCDqqPJ
         IYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=woQEtB66hiZnxZHdzVr4409LscRnNd++bG9SeCgzq/Q=;
        b=iajbsW7QxOmPhBOJbmd2sa2NS2xF+VXuBbC53fBzj9CUCom91TeAiWYghGEnKoefbF
         QA/4pllUEkaU2RsaR19gqf8Xca/OXp6oIRoeQoSVSgvfan4CGjadDiXQ6HdLCmayLg2J
         xZHHhG+v4KIMGiXKnKQAZ4urI+1AhIvrd4+EhzBdTxuWl9mjn+rOF0p4Jpm6VjiWLjq5
         D0slrwL3MOfbZq3DCuU1jJkKVOzcp1XphzpWLJLfNkOtQpRFtjYWXHHrELKgHJPp8Xyt
         B1fF8Qlet8am0ZVpT5LTWNNz/ybbKJ6hUFhVHX/q6rtZ26guPrXAUadjEgL4bW7Z43q+
         OAXA==
X-Gm-Message-State: AJIora9UGPStGlmkRewGGx5qQlscMxjheSslskzwQLHANVIE4z//1b9y
        Vb3gMvzlqhHwTCya+ueIOrM=
X-Google-Smtp-Source: AGRyM1vHBie6XrxGT4ofVtKYcx7G+2RsSndjCQl0i0Fg7wkTdAGJyu0Frex0hPg7XHHarpcMUgeNEA==
X-Received: by 2002:a05:6402:695:b0:435:65f3:38c2 with SMTP id f21-20020a056402069500b0043565f338c2mr10121636edy.347.1656878822335;
        Sun, 03 Jul 2022 13:07:02 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:adb9:a498:761a:afd0])
        by smtp.gmail.com with ESMTPSA id q25-20020a17090676d900b0072ab06bf296sm1845680ejn.23.2022.07.03.13.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 13:07:01 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Shrink sock.sk_err sk_err_soft to u16 from int
Date:   Sun,  3 Jul 2022 23:06:43 +0300
Message-Id: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fields hold positive errno values which are limited by
ERRNO_MAX=4095 so 16 bits is more than enough.

They are also always positive; setting them to a negative errno value
can result in falsely reporting a successful read/write of incorrect
size.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I ran some relatively complex tests without noticing issues but some corner
case where this breaks might exist.

diff --git a/include/net/sock.h b/include/net/sock.h
index 0dd43c3df49b..acd85d1702d9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -480,11 +480,11 @@ struct sock {
 	u16			sk_protocol;
 	u16			sk_gso_max_segs;
 	unsigned long	        sk_lingertime;
 	struct proto		*sk_prot_creator;
 	rwlock_t		sk_callback_lock;
-	int			sk_err,
+	u16			sk_err,
 				sk_err_soft;
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
 	u8			sk_txrehash;
-- 
2.25.1

