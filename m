Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759D62F5B94
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbhANHwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbhANHwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:52:01 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2865C061575;
        Wed, 13 Jan 2021 23:51:14 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w2so2848809pfc.13;
        Wed, 13 Jan 2021 23:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OdOYvLKaoSgVaZejaz21ew2EF1idBOpu4EgqrpcWnb4=;
        b=HhFwKGeoVFs0hdiatK077VZ4s6B/4MfW+deARy0QD5c0MMKl0X5NPTMoCcLxWesLJC
         I82426ijG3cvoS8mdIRVftoXwhuY3Y8KXn/RyuJwbDxoPEPJUrIuWClOqR5UbdRBAsh8
         qEJb/5kRlgSwWvXrb2dxwBDUrWwvv1zsKaXhZMMiCMhnJAwdAbOCiWELAwwhMCixvmf0
         aEe9IazlXyWoyDnTEAs9Wu0Cj9lPhhLG3dhJYDMjN73AmFDc07y9JtgkiL2CxGV3Q3Or
         W3AxWOJISUIpirdvnk1uzrWMGsNybumRuJekmfPoqe2a1dwIoGZ58tiTYaTivfLL4wd4
         ZQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OdOYvLKaoSgVaZejaz21ew2EF1idBOpu4EgqrpcWnb4=;
        b=PFuZL3Pz1bOySi7nxAyssJspLSuX5xsHYHQobcwZ/tF8GN2Qbw4N14teLoMYscPcHn
         9qSPI7d3t7tqb8JqMQonjxsB9E1Pwf1CTR8b7USKectnhLp2ESYW6aFPgzghnhG10dfv
         bQkg44uzEwAkFA3itPkwjvKhX8oNcarrgh1Ph8cWNQwj7rbPACdWhOc7JtwTQ1k8zrqi
         sDPat1OKuizblD0LA/5sJvg2csQEdpSMTHdYUOYkSXPwDleXxD4VoeqddEWw4gUqAiWX
         IdJV6yXADD1dJ0eA+idfL3GI/9VLOaAo/FqFFPLSie8fcEXZvtpf+Darqkcgnmcd+S06
         zkXA==
X-Gm-Message-State: AOAM532PpiJmB/TyrZm/wVxjVdKOmqOgAaY2uHHSu9NgJXEhTdR/hLtC
        v3X2vCm8EL6iLRR2LM9ALCU=
X-Google-Smtp-Source: ABdhPJwhk4WiAxKANeqB8opOzwRSzVUBxjOzi0j9376A1upXh4ljMis4eZ81VDG064gXEq1FIkUrPw==
X-Received: by 2002:aa7:8708:0:b029:19e:924:345a with SMTP id b8-20020aa787080000b029019e0924345amr6328401pfo.54.1610610674530;
        Wed, 13 Jan 2021 23:51:14 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id p8sm4580160pjo.21.2021.01.13.23.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 23:51:13 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: bridge: use eth_type_vlan in br_dev_queue_push_xmit
Date:   Wed, 13 Jan 2021 23:51:01 -0800
Message-Id: <20210114075101.6501-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace the check for ETH_P_8021Q and ETH_P_8021AD in
br_dev_queue_push_xmit with eth_type_vlan.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/bridge/br_forward.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index e28ffadd1371..6e9b049ae521 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -39,8 +39,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 	br_drop_fake_rtable(skb);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD))) {
+	    eth_type_vlan(skb->protocol)) {
 		int depth;
 
 		if (!__vlan_get_protocol(skb, skb->protocol, &depth))
-- 
2.25.1

