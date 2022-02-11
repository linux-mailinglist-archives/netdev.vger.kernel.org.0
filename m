Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55DE4B1D86
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 05:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244859AbiBKE4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 23:56:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiBKE4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 23:56:07 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F3126C9;
        Thu, 10 Feb 2022 20:56:05 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x15so11795281pfr.5;
        Thu, 10 Feb 2022 20:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PeOoM1eGyjv6OUHufvtzXFr0FZASb0jAQBCyKx+p7rc=;
        b=gYa9NFiW7QivIzAZvj+oIXc6qIZD3eaoR7VdhnKVHdykxA5+dG1ODIpkBE+kxws/Jo
         AD/p43h34g5vA8yVPPurumWXMhOYvkxXTEDXaPefOxQLVuG0hOF8XBB3Ai3b6inHLT0k
         5+gcpM82QN/xWKRSsbjAuoPYRP71lo3dtZ1F2OyAq8DkeMbqVbuMDNYvIJMaO540XGQa
         8FeWgiiZgb3MXvj35OFnmLD4H+sE4/xcdImocPcLd/Ovlnmpc6DxbKGD/E99p2CEHvAF
         55FOttHuNwAKVnQQ+KtEnisBoxgpNc4ZCjvLDgCQtWgMamq27EVMwHQI4uY8bPgscnLQ
         ClyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PeOoM1eGyjv6OUHufvtzXFr0FZASb0jAQBCyKx+p7rc=;
        b=WoCkERhwN4O2TDIX6FPM0EXUm+n15Q3/0c78Y/HZu6xAwsf5lL1gmuQpP6Qtq0soWs
         CO449iSyg/wrgT1j2pMlN2R9bcAZ4nwMW6qKcNIQoUeiR286xVYXe4FC8cCAUCJqqDW1
         zhroJv94ER2LDIZiN7E8NPOihBrCdbXErXBQyQPryBWrAqL5pzgzsTCBy9hCW4WD8FDn
         4czFSzXwgI/+c6dRm/GgLotFNy9mGjrAxpMzttRKwNJSs4UZ3xMpTQx2j8Eoa7gBn8dU
         WpTZUjsASiNFZq3/756SPYNwpLpimeGjMXC2WFsMhvvUae8zMJoBu1Ag5iGTseL15ksr
         Fpdw==
X-Gm-Message-State: AOAM5323nQ9byFPrCuGFzR/letiC5guthlDnfaqMwL+WHiHVmVXQ7tL0
        Mbus7Sh/JQJvx65Iff4YrfAGQu6B0PEJYzEM
X-Google-Smtp-Source: ABdhPJwvwOZ4lQAZCDqxrY5GHp7LJ/wgU4eYF+gl2hMpIjbmdfiwT4lTHNn0O+0Yhx05eTUHkScA3Q==
X-Received: by 2002:a65:6e0e:: with SMTP id bd14mr1286587pgb.325.1644555365359;
        Thu, 10 Feb 2022 20:56:05 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.52])
        by smtp.gmail.com with ESMTPSA id t3sm27270100pfg.28.2022.02.10.20.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 20:56:04 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] tipc: fix a bit overflow in tipc_crypto_key_rcv()
Date:   Fri, 11 Feb 2022 12:55:10 +0800
Message-Id: <20220211045510.18870-1-hbh25y@gmail.com>
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

msg_data_sz return a 32bit value, but size is 16bit. This may lead to a
bit overflow.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d293614d5fc6..b5074957e881 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2287,7 +2287,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
 	struct tipc_aead_key *skey = NULL;
 	u16 key_gen = msg_key_gen(hdr);
-	u16 size = msg_data_sz(hdr);
+	u32 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
 	unsigned int keylen;
 
-- 
2.25.1

