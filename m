Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B06B5BF944
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIUIa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIUIaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:30:19 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DA33DF34
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:30:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bh13so5227823pgb.4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=AHS5jLPuQlU6rwa9/NJqfJCbG+8hdDQMUtoYsMchEdg=;
        b=ikO3/04GBrEGTXLslSkHYhWAck3KFH4yh9gNG/mQqssM3VDWLYowxIKPG9PJqPv1qO
         Nch7hV2uaXLPECWyrizWqKA37AKqF+qljLA0tuGidWFRVJXrvc5wzhEb3QRLyofm8AhJ
         aeNGwhFGr3/P+ZdHrB7hxSZPiTDZ1ab09ToboX180816lNHHP3z1ZVWWnzoE9bRNHE7V
         Ayr7oiemoy6PtP1XbAhKsGDAt/WofHvVSX3vPwjSgz89t4zxlvTbK98ZJg9S6Zmsrp5Z
         qjcCP7aYdXqxN/peE5MpbpUnKbTRcnQ4gHbSAZYa4PNAcOe18pX4SWsZt3sLzo2X7b7a
         2wUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=AHS5jLPuQlU6rwa9/NJqfJCbG+8hdDQMUtoYsMchEdg=;
        b=mElAJzBvpPWqo7s613lmxQet/fRV95ffBbupSCbNLzdDHefIRf2g00IvM/3olUZnYe
         DUerbTckAL63fWvRDlEfEqx1zXUmSRgnGQzzR0PjtJp3i0q/Ght+VvFRFJUT7BimxFE6
         XGdKMWI1ovQ9O0NoDIND8iyEzq9NX1ivtWJhw0BgLfC7koS7ON3M7NHSN2xjYoTwMgtG
         A7diW4hxMMV2h9mVoR/eombO8GyI7IRfovATWI2g8yb3IY3wIOU+IWgBDUQbYPVRUI86
         3bFrbeSFFQW/4QcQ3LlOV6NfXBSPbpMICCiNYFuLcb2U5wPIBaGEWceDMG+cPeod+YYG
         gFHw==
X-Gm-Message-State: ACrzQf2gAkOfIs8dndAk11dCdnOFcDolflztoITIQ5YLVCa8RuL8T0ek
        svfS27xMmUOVP1criJ0p5P7Nktr0Lho5bw==
X-Google-Smtp-Source: AMsMyM5nHCrpWz+vqZbNR1iVFkfbUtNri2hyG0QDpvSUvf3DpY7t0OJ/RRjeMBUa2S75pqPfQT/KvQ==
X-Received: by 2002:a05:6a00:24d4:b0:541:11bd:dd24 with SMTP id d20-20020a056a0024d400b0054111bddd24mr28217444pfv.66.1663749017652;
        Wed, 21 Sep 2022 01:30:17 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id 28-20020a17090a035c00b001fb1de10a4dsm1262912pjf.33.2022.09.21.01.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 01:30:16 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v2] net/ethtool/tunnels: check the return value of nla_nest_start()
Date:   Wed, 21 Sep 2022 01:30:04 -0700
Message-Id: <20220921083004.1612113-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of nla_nest_start(). When starting the entry
level nested attributes, if the tailroom of socket buffer is
insufficient to store the attribute header and payload, the return value
will be NULL and we should check it. If it is NULL, go to the
error_cancel_entry label to do error handling.

v2: error handling jump to error_cancel_entry, more details in commit 
meesage

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/ethtool/tunnels.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index efde33536687..67fb414ca859 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -136,6 +136,8 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 			goto err_cancel_table;
 
 		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+		if (!entry)
+			goto err_cancel_entry;
 
 		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
 				 htons(IANA_VXLAN_UDP_PORT)) ||
-- 
2.25.1

