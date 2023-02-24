Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BA06A20F6
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjBXR6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBXR6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:58:04 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D604415547
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:58:03 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id bh19-20020a056830381300b00690bf2011b2so78921otb.6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5g2adKCK1THnL0e+k/Rx4KaBDlFLe4mIcVu6AyWwGIM=;
        b=VzfHlsNummo9thbxHQSvrnG0vDdtxEv197A8cB0LlN3dIWEKMUOjK/1oXYEUDmkjiK
         gBF3xJx0umXa4JDERj3T0Igbr+hBCiArQ/3esTuLcVCvQqylX8MBs0JeZ/YSfVbWOocu
         IRXJ08Toaalg+UWFp+8GLqybelXwDwyM1B5/1nhsh4c+KIdeZAhg6TltfVARTuAMc2do
         zB27JNBEYC3Pe7zNkyRWAoNBzZM8fZGXGvj58nsSYgW0hyNv6wED8yTxEfEhObDP6vtD
         3aoO+ZlAD3PBfJH8Nj7ORpkCA5QB7Spfw1lthOB5OIDimHvXFy0+r7v5Ff4gAkI+AQy3
         S79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5g2adKCK1THnL0e+k/Rx4KaBDlFLe4mIcVu6AyWwGIM=;
        b=DCkvv8aQ1S9obiQaROMNGz/wk1vptWD+B4+7SlwfA3e0N57ZQ+H6L6IFK6X2pPhyZE
         hBqxod8cYdhjuSJtK9ufUN1dTnz6qC6kuAlg5UL8Gm0U3x/U1g5HcLhM35ZXQlG6z1It
         WawDpsrIDSxE49vLYZFOAXAQEodPn21uBOALOUW/yAtJmTNHt7u1X+kmRumzQiCv+hIl
         fiQWYsg9BP5fm01F6FrVCuFR1rX5uAtpbhkIADEZcBZybwNNlXSrTrqEu74JV+NYmXmW
         6QfY8c51vwf7ehkg0lu98iN0eZResUhLllD/XQ+yOScLM0k9xB9QppSz+gnk/8LN+7HN
         KsLg==
X-Gm-Message-State: AO0yUKWRGLW9D1CmVR5nDsMrClc8tPRrUy+B6PgCWKEU682AW2anzk1R
        G5ljfQh4FkmCBrDcQyxPiDM6JjTGCmp8lXXT
X-Google-Smtp-Source: AK7set/U0mJE6OYbKyVSQswWl4q80WwcF9idTww9DRwTJdFiCwlNWBdYyFuRVeE7W0yZ4KvB37dtlQ==
X-Received: by 2002:a05:6830:3106:b0:68b:d34d:8ac1 with SMTP id b6-20020a056830310600b0068bd34d8ac1mr6070942ots.23.1677261483017;
        Fri, 24 Feb 2023 09:58:03 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id q8-20020a05683031a800b0068bb3a9e2b9sm3607353ots.77.2023.02.24.09.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:58:02 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, liuhangbin@gmail.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG
Date:   Fri, 24 Feb 2023 14:57:56 -0300
Message-Id: <20230224175756.180480-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should sit within the TCA_ACT_TAB hierarchy, otherwise the access to
tb is out of bounds:
./tc action ls action csum
total acts 1

        action order 0: csum (?empty) action pass
        index 1 ref 1 bind 0
        not_in_hw
Segmentation fault (core dumped)

Fixes: 60359956 ("tc: add new attr TCA_EXT_WARN_MSG")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tc/m_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index 0400132c..6c91af2c 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -586,7 +586,7 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
-	print_ext_msg(tb);
+	print_ext_msg(&tb[TCA_ACT_TAB]);
 	close_json_object();
 
 	return 0;
-- 
2.34.1

