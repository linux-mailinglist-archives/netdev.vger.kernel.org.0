Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C786632D68B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 16:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhCDP0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 10:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhCDPZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 10:25:51 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42885C061756;
        Thu,  4 Mar 2021 07:25:11 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id q25so23608421lfc.8;
        Thu, 04 Mar 2021 07:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeN2LKdORXb0lZrwnrlpd8qrBTJtdHVZ+ffDq501Us8=;
        b=i+DknTjhTVuXq7MZUlypiuq2JeQK4/edGuiLVDG8YUHG3exXaY/yG8yLBtjp1r6zwu
         xBCfPXSbY5SpQFOAV5/at+WrDVti0dDvr/nmHTeoNuGKcqwQTb9WyzERXzyjKwjcl65l
         bTmQDbzaUFJFusDofGxg4vdMrRxa5XT2maO4+dFgSbuV8fXD9kp+tFctJm2jhtYsdp7W
         S8HGt333upLNPULnrmgk55nDQT+Ij37chqPpzuj2xfYsTNts9Ah1/lAAoP+MbP4uovbN
         BtesAzVJ/OW95zoaLiVJFxkR9KR5PuhF2TfQQ1sDbD9+wBteNpPr1N8wmkUkzBIOYP2f
         PcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeN2LKdORXb0lZrwnrlpd8qrBTJtdHVZ+ffDq501Us8=;
        b=KDS8v07OXXQ0s/HyfICTfv67Dec+R++3AFUSrhmcPFgFmAmwfgp0gA/93V2i7IYDCE
         BS9RbAlaO+d2/5RP+PdvkCGTRL+i/hl+lGI3NmjUfhYMSEppvEJOntZqzeO0gb4NYYZb
         lBrsOuRzCluPryJ4v3uvLUYMPRMDpOGQTFyhUCyxgcRpCr+vM+aQkgx8uSV0DHY0+hgs
         EWQyyUqj64/adoumDVSPtrcFsXPGCvk6X8pYvLwM6XSuzEwZhCS3fslkxziXX8QD5DiK
         ZGVRRK1DA7a1f1YdBHxpxCMvGTWMxNapcfxjGEFiO9nLSj1pxH6j8W8ukKM8S4YKZiF7
         ZKtQ==
X-Gm-Message-State: AOAM533QFicX6Hs3i8oh3nl4uIl+M9DcJLX8nDIsSt5SlQZ8gFaDmuiU
        39pwL41ZETDtZmRionxbLbv64X2gtMFJDNTVGak=
X-Google-Smtp-Source: ABdhPJwKMUQh9PtBYqbGI/8c5OxKmNVwr0F+4JArX5VTcw9L9vOFzh/5/DLlV1N2jv4ludGo8Dkv0w==
X-Received: by 2002:a05:6512:906:: with SMTP id e6mr2644644lft.224.1614871509714;
        Thu, 04 Mar 2021 07:25:09 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id d8sm467647ljc.129.2021.03.04.07.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 07:25:09 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Subject: [PATCH v2] net: mac802154: Fix general protection fault
Date:   Thu,  4 Mar 2021 18:21:25 +0300
Message-Id: <20210304152125.1052825-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
References: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found general protection fault in crypto_destroy_tfm()[1].
It was caused by wrong clean up loop in llsec_key_alloc().
If one of the tfm array members is in IS_ERR() range it will
cause general protection fault in clean up function [1].

Call Trace:
 crypto_free_aead include/crypto/aead.h:191 [inline] [1]
 llsec_key_alloc net/mac802154/llsec.c:156 [inline]
 mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
 ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
 rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
 nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Change-Id: I29f7ac641a039096d63d1e6070bb32cb5a3beb07
---
 net/mac802154/llsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 585d33144c33..55550ead2ced 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -152,7 +152,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 	crypto_free_sync_skcipher(key->tfm0);
 err_tfm:
 	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
-		if (key->tfm[i])
+		if (!IS_ERR_OR_NULL(key->tfm[i]))
 			crypto_free_aead(key->tfm[i]);
 
 	kfree_sensitive(key);
-- 
2.25.1

