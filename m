Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74094504B1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhKOMsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 07:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhKOMsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 07:48:24 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB234C061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 04:45:26 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id i13so11208093qvm.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 04:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0bR6S9IemDhVbzyC7oeXbEZsCr90h1u64hNJLpC1K0=;
        b=V2Pi3e2hJK152R7uiFZhYbfyI/dmYHlz6H9ILNXwEIGogKhNehLuq88YFH7vJIJ4yE
         fF6OOGzxdMDesxCHgc6e8JEtBLW+5A/TJq1CQ3qbrCxCUgXXMTm9rX9E0IhI/lRTTN3Z
         HtAwdvxUG9jyOEjCkpFbUZ1LJR9klejZdTkJsNoW6kcxatQGJ8fAd5Sq3rv3Iz4ik5xE
         6ROy4LiHJctrlD7ui3KPGamhSZKXm7XH/G4nlUCIdK8BIDT1eAcUcnqiGrpdeb/3uw4I
         gaHmvywICXWF6JAGJihX/VB3cxzXQfMzJA563SuYT++xtxnnrSLWlGHGF7us79RD63GZ
         bUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0bR6S9IemDhVbzyC7oeXbEZsCr90h1u64hNJLpC1K0=;
        b=xlYMsanikbh4Ymuf5xO6SgbTDPnGdeCYtvXSDQF62bYhuHymWRMzGHtvR7MSpU/Thw
         jOPfp9mUQNQfZs+KWFLacQogCOvxFD2fwKYyZEvPE+FEuN5bSLpiU/XQhM7WGrXOuN2r
         FKad/kJv7Wne80iW8olKKAvv2w3xM3aoReyNaCL0ZAJdQlQzDxFscI3niXs2k12fGQuC
         /SMOTfjl8MH0Zw1yUzwY+7O36cj9uNgfhnP8gyCnSjPcr+2Ksq1UnL503mgwLfV07Anh
         bQMBQSVyx5JqsdRpqg2quTTMg511O+yQ5TsjtcvZeyhS/9G7MmKgPjocaqhmI4Q4Hd7b
         z3FA==
X-Gm-Message-State: AOAM530K9umSRLmJ+fQny3yBlFiibLw+COAEAm+VUq0fBr+bi9JzcQeA
        v9c8LmQm4gc35YUb9aIPxhhrHYsMi1j59g==
X-Google-Smtp-Source: ABdhPJz1w2go5pl0qknuAuEKP+9enfd8Dw9ZyND0zQs2kkFg+9iVQu170EgDkp7HRlaLmZOne9OtyQ==
X-Received: by 2002:a05:6214:96e:: with SMTP id do14mr37101402qvb.39.1636980325820;
        Mon, 15 Nov 2021 04:45:25 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o17sm6876588qkp.89.2021.11.15.04.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 04:45:25 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>, davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net] tipc: only accept encrypted MSG_CRYPTO msgs
Date:   Mon, 15 Nov 2021 07:45:24 -0500
Message-Id: <127f576a209dfaa9a4ada59b298e575296f6bc10.1636980324.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MSG_CRYPTO msgs are always encrypted and sent to other nodes
for keys' deployment. But when receiving in peers, if those nodes
do not validate it and make sure it's encrypted, one could craft
a malicious MSG_CRYPTO msg to deploy its key with no need to know
other nodes' keys.

This patch is to do that by checking TIPC_SKB_CB(skb)->decrypted
and discard it if this packet never got decrypted.

Note that this is also a supplementary fix to CVE-2021-43267 that
can be triggered by an unencrypted malicious MSG_CRYPTO msg.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/link.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 1b7a487c8841..09ae8448f394 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1298,8 +1298,11 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 		return false;
 #ifdef CONFIG_TIPC_CRYPTO
 	case MSG_CRYPTO:
-		tipc_crypto_msg_rcv(l->net, skb);
-		return true;
+		if (TIPC_SKB_CB(skb)->decrypted) {
+			tipc_crypto_msg_rcv(l->net, skb);
+			return true;
+		}
+		fallthrough;
 #endif
 	default:
 		pr_warn("Dropping received illegal msg type\n");
-- 
2.27.0

