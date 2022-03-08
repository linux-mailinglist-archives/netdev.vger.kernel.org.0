Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329F84D133E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345321AbiCHJWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiCHJWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:22:15 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E02841302;
        Tue,  8 Mar 2022 01:21:16 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id c7so14243580qka.7;
        Tue, 08 Mar 2022 01:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bxF5qXo3PL2f3UMZUvmZOWCOc9OEVRZt0CIdw9NTwnY=;
        b=XZlgJigaZrcG5WfAy1PQqtmWQHhdugo7W4UnRkViWCeVDWpEJeitIsQhTuV36atCUz
         GPubRUwp0iKBDG1RZj4nU7pUwKRx0/XS+lTY32i/x8qpNmA6X6doCG3GIMIUYaEiO3ZQ
         IDeLhYENyymW6tN19C9W889XfX6hjYl5bmsvfDfFTJtufRosk4/jkHbU/fiE1p1VJ9Ju
         e1paNKDDlW25fy9GPNNR1moe5WshlGlVq3BcYHoUo4n4ZJYmLO+y7bPqqyN73ieteHqM
         kzsikYuE51mW4u3qA2UIeDsNIcnPHJaS97mlPsYg1vmMbcl6JBEVwKecDEWDkByWnakS
         XyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bxF5qXo3PL2f3UMZUvmZOWCOc9OEVRZt0CIdw9NTwnY=;
        b=Qxdxzuxv8DQEKGja75l6B0vofY37DSwtFAO3rf6c28H+ywAwqgQGnzcTRE6K1G9AaG
         YdOvixFhS7O6UjZFeLHGSoNQXsqu7EC7gPr/G8f9Qi3PSmZBMH3Riz2U7dU4xM8lA72F
         X7nUtCfG80e6Q5sDwCsvJFGzkVERlzCBVeluJccq1gHGxaRbgP34S5UUOSVJwtLGseHk
         zsijplboWzWNqKQ1VNJigkO4lXZLLGaLA/mua3LpGRdzJH7JmDue2cYcnUpdGNdP5AZZ
         h7LTpWrT0ojWy2WdoDn5O2E2239PHmyHWpXtgG5Mus4mEURRmEXbx4agZ5FH4ByGeKXD
         BW2w==
X-Gm-Message-State: AOAM533cAaGdxLMDpnRg12hWuJmkIjrkmJvb2s8wJg8TrPlwg2kQZZOz
        gzkA3IX1HKWc/yXGDoTY8P0=
X-Google-Smtp-Source: ABdhPJxfLEre3EF4QwDd6W4gEERfFjoAzcLMznURjqmG55bqsk8/LjIT2At5cX6f7oeH+mNXcG+5EQ==
X-Received: by 2002:a05:620a:44c2:b0:67a:fd04:38e6 with SMTP id y2-20020a05620a44c200b0067afd0438e6mr8690883qkp.303.1646731275632;
        Tue, 08 Mar 2022 01:21:15 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v31-20020a05622a189f00b002e077568b77sm83798qtc.59.2022.03.08.01.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 01:21:15 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, wangqing@vivo.com, jgg@ziepe.ca, arnd@arndb.de,
        jiapeng.chong@linux.alibaba.com, gustavoars@kernel.org,
        christophe.jaillet@wanadoo.fr, deng.changcheng@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: sun: use min_t() to make code cleaner
Date:   Tue,  8 Mar 2022 09:21:06 +0000
Message-Id: <20220308092106.2079060-1-deng.changcheng@zte.com.cn>
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

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min_t() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/ethernet/sun/cassini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 153edc5eadad..b04a6a7bf566 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4664,7 +4664,7 @@ static void cas_set_msglevel(struct net_device *dev, u32 value)
 static int cas_get_regs_len(struct net_device *dev)
 {
 	struct cas *cp = netdev_priv(dev);
-	return cp->casreg_len < CAS_MAX_REGS ? cp->casreg_len: CAS_MAX_REGS;
+	return min_t(int, cp->casreg_len, CAS_MAX_REGS);
 }
 
 static void cas_get_regs(struct net_device *dev, struct ethtool_regs *regs,
-- 
2.25.1

