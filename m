Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E0B4FA691
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 11:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiDIJnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 05:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241465AbiDIJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 05:42:50 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F210D3190CA;
        Sat,  9 Apr 2022 02:40:42 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id s11so12518732qtc.3;
        Sat, 09 Apr 2022 02:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9U4GDB/5qNyA0pzul/6LrYEStvTl+1UQVGV0Eru9IDU=;
        b=L1GdyGMpbqblwvye42NihtJPUbKwy1UJ9BfDQ83mc8VbJD3Cj0RQwEEQ+cNOdcDLQo
         Dq0jYRYHD1OUikkbBdd6oaxyqCkG9GWqckZqC3y7t/ya37ddESUl+cJGrSFi5U3jI6Od
         sVEuzYmIypLkixsgvwIv2nqQp4FAVDEJcN66m5XjMKwuixqPXds8aGbjYjvkyJVJOm8Y
         38pP4MaiuvqTnwJHuQyudu307ATkpToBmzexash+h16/lWEt7vAZAOEDGodV7srtdQai
         e23qD/M/LjgXozOGAs9eWhvn5OTnKQJnk4YBQoBBplZP/zBtsh7owWSMZu38vojsFQLU
         LJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9U4GDB/5qNyA0pzul/6LrYEStvTl+1UQVGV0Eru9IDU=;
        b=AQLr4fkKvB7nkImVyYeBUBdjhVzAanEfyUTon6WPifYVTT9It/E6nCExcPmGfClPbB
         o5QHc0HNU8+oCGM4JFtQb9UZ6J8w7zuuNT+H3LKhTJigxBNoPRVJ75trauaRWu8oj5Q3
         Y1gp7gZDfHKN1HJ4LcOkIqFZSSNUKVyzAJjko8V77YHuwWiCnkl/oSOsdbPSl3kC/hCX
         3REbkmFJZE6LnytfTnjo64IPP5sI4XFcdLUsN4tJWVJ/jEoYn/saGcz1pemTp8SUrEou
         eR/OzAcDRY9o6HoKCOgiQvSPzyj2J16C8ChCB++GyZJe0x1V7ngaIP3YmkjFrzDe4MCQ
         xosg==
X-Gm-Message-State: AOAM532wDQevFjwlXpDX3CLchoOBfasMoq27qN3EhOCXBcUkd9fju0rp
        h/D2fwq40JeobhH8HJQGtEl84uLqKdqlLQ==
X-Google-Smtp-Source: ABdhPJy5YxGzb92dzzooARkjw2SmoKSHZzokfLtm1C+VBYibp/was2EfNC61m44zkcNMFb1L5UHWPA==
X-Received: by 2002:a05:622a:1652:b0:2e1:d819:9928 with SMTP id y18-20020a05622a165200b002e1d8199928mr18852783qtj.511.1649497241791;
        Sat, 09 Apr 2022 02:40:41 -0700 (PDT)
Received: from andromeda.markmielke.com ([2607:fea8:c25f:8500::9195])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm20975669qtx.58.2022.04.09.02.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 02:40:41 -0700 (PDT)
From:   Mark Mielke <mark.mielke@gmail.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Mark Mielke <mark.mielke@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] openvswitch: Ensure nf_ct_put is not called with null pointer
Date:   Sat,  9 Apr 2022 05:40:36 -0400
Message-Id: <20220409094036.20051-1-mark.mielke@gmail.com>
X-Mailer: git-send-email 2.35.1
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

A recent commit replaced calls to nf_conntrack_put() with calls
to nf_ct_put(). nf_conntrack_put() permitted the caller to pass
null without side effects, while nf_ct_put() performs WARN_ON()
and proceeds to try and de-reference the pointer. ovs-vswitchd
triggers the warning on startup:

[   22.178881] WARNING: CPU: 69 PID: 2157 at include/net/netfilter/nf_conntrack.h:176 __ovs_ct_lookup+0x4e2/0x6a0 [openvswitch]
...
[   22.213573] Call Trace:
[   22.214318]  <TASK>
[   22.215064]  ovs_ct_execute+0x49c/0x7f0 [openvswitch]
...

Cc: stable@vger.kernel.org
Fixes: 408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
Signed-off-by: Mark Mielke <mark.mielke@gmail.com>
---
 net/openvswitch/conntrack.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4a947c13c813..69972f037d21 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -970,7 +970,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		/* Associate skb with specified zone. */
 		if (tmpl) {
 			ct = nf_ct_get(skb, &ctinfo);
-			nf_ct_put(ct);
+			if (ct)
+				nf_ct_put(ct);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
@@ -1339,8 +1340,8 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-
-	nf_ct_put(ct);
+	if (ct)
+		nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	ovs_ct_fill_key(skb, key, false);
 
-- 
2.35.1

