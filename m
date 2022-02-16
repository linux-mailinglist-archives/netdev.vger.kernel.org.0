Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D543E4B7FFD
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 06:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbiBPFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 00:21:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbiBPFVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 00:21:06 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B12FA22E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 21:20:55 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id q20so1092660qtw.8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 21:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FmcZ/fRePWq5s4y+7VM/SA3noeiad2xEykIaRju6z1M=;
        b=OPP3u+oDpJ91uB9Nnj3K80Q8UZn4RVDO094tcSsVBd9OEMyZ1yWkO0OmCalkoccgEH
         FaGUCyFfO6F4P+DIS6s3yceeTWC6tZm95asXMyq7lNn3FiRha0SZOpOIDv0XFZfREldr
         kAUX/jlBN8dys2YYKqC4SbNNtIN/Grq2C3p/SJLfskWVuJp7DqPQTwOuBqWXOYN7UOF0
         BHIMwupkqqKq4qzC+SjFDo/M9BeEXJsy0E5XJ0dPV4u1E3a2ZTiKqfkQiQAzQ5LbP6Kn
         duyaNarl1NC9nqZ3E19dozvIXd9dv5iGrme0VubwoBuEZVzkYXZZeX8v2r0ikhdSElXK
         UPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FmcZ/fRePWq5s4y+7VM/SA3noeiad2xEykIaRju6z1M=;
        b=V07KV4LYNrSjE29h/gS2cl6WnpXXvSKpctU5XRYEDPkZcQCrx3SRpBKbvqGWpypSM7
         skhgJuFIg18R8Q6yg95loajw7vlMVWSjUH0dal7ZaptTI4eWPf+yPU5KtEd7LlMs0NiZ
         DtUk3Nesxn4NR3LkvHA9Kr5BwaCs7ne0vZKotIbzUjURWEs8ZycOuMS+pNDJR2P4OyB+
         MzDod8ssJRXCumj89dQ1/7+oL1hwunnKXSs+MiJGKokBu28XD8W6eBLhwqEtP9NCl3Bv
         mm/olYzRzMsfiwS0aDGTGCOJ+IaplTmtmbT5QBD6bqCHRPXgdfSwy2kOaN6zi9+hrHhE
         dHrw==
X-Gm-Message-State: AOAM532G1teE1BSnX+vJaynYb+vpg/+lss7+o7SM5YB3vEMgo5K7Jmsi
        bbcQtfxvKPNzAuNvt0oFr8uF4MTIScczKg==
X-Google-Smtp-Source: ABdhPJwFV2S/DRyYJVR8KboVSq4Z2vvmOSzj+HfbVTpw3ZyvNpZA2wVsn2FWQM1sCNgcitBtxN9c0w==
X-Received: by 2002:a05:622a:60c:b0:2cf:a84f:eb47 with SMTP id z12-20020a05622a060c00b002cfa84feb47mr901897qta.419.1644988854325;
        Tue, 15 Feb 2022 21:20:54 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bk23sm18239988qkb.3.2022.02.15.21.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 21:20:53 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [PATCH net] ping: fix the dif and sdif check in ping_lookup
Date:   Wed, 16 Feb 2022 00:20:52 -0500
Message-Id: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

When 'ping' changes to use PING socket instead of RAW socket by:

   # sysctl -w net.ipv4.ping_group_range="0 100"

There is another regression caused when matching sk_bound_dev_if
and dif, RAW socket is using inet_iif() while PING socket lookup
is using skb->dev->ifindex, the cmd below fails due to this:

  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip addr add 192.168.111.1/24 dev dummy0
  # ping -I dummy0 192.168.111.1 -c1

The issue was also reported on:

  https://github.com/iputils/iputils/issues/104

But fixed in iputils in a wrong way by not binding to device when
destination IP is on device, and it will cause some of kselftests
to fail, as Jianlin noticed.

This patch is to use inet(6)_iif and inet(6)_sdif to get dif and
sdif for PING socket, and keep consistent with RAW socket.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ping.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index bcf7bc71cb56..3a5994b50571 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -172,16 +172,23 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 	struct sock *sk = NULL;
 	struct inet_sock *isk;
 	struct hlist_nulls_node *hnode;
-	int dif = skb->dev->ifindex;
+	int dif, sdif;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
+		dif = inet_iif(skb);
+		sdif = inet_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI4, dif = %d\n",
 			 (int)ident, &ip_hdr(skb)->daddr, dif);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		dif = inet6_iif(skb);
+		sdif = inet6_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI6c, dif = %d\n",
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
+	} else {
+		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
+		return NULL;
 	}
 
 	read_lock_bh(&ping_table.lock);
@@ -221,7 +228,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		}
 
 		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != inet_sdif(skb))
+		    sk->sk_bound_dev_if != sdif)
 			continue;
 
 		sock_hold(sk);
-- 
2.31.1

