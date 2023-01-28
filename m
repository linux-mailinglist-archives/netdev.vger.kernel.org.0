Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D99567F95C
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbjA1P7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbjA1P7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:59:06 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B2E3402F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:51 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id v19so6548271qtq.13
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=LR9/RCa51DJ3fi+0XANMBS3usA2/zbWS7zR19Mbsca4WjMCfDUN/pZnH8GGRMF8Rsj
         fSnyomT51zEPZnnxbKNn/of1PscB0LJSnw6fgMnb8ysqDjSFibCVZvUAfqSw95Vgr9bo
         wkC+6NX8mcaSmiR6sexi+BhGhj/CFijQS0S4QTmnjjLKZmyFnjVSmgVRuPziPWTB8GDT
         k/cjmIs1WSVZEd5fS/KQrEAHaMrHP9BMTO2jYqDKEsN5w0ayfcZgPv4JqeYxjOr/9e9I
         t0bSbemMyUtm37B4NqOG0iidB6dGs3PC9LudLCVshYS/6yuzWxKSk+m30H75/0vUQSs5
         5Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=cbZXYfW1ShG4xnDiGKFufGyO0Zeey6GNFfFcr9NiOggDq7JeVbgPoxYZ+0z0hQe16L
         8hgUUls9fIH19+bDtcc8Ee5b8UBP4MZPyY1t96CmFKxGtOtsNFlUs77E6VyIjmD44dvB
         f0YAE5y3kU5JqOvoYuMoy8qKxp28tZQ+K7KVaOra4sVaTlU8OAJqK4dLAjcEMPr4wfdt
         i0JtyLrrjhNg1sdDxTZIYugAWhqpWqDaCol8ZgHvQ4Ga8PiAfIcUl1QqF2q9TkI/PN6G
         ImN3Syn+mdsEh6Ka25Lf7ObR7P4NUJEni/hoplSuYgpSkEs0MyfkT87NAMIvYAdL6Wrm
         oV5w==
X-Gm-Message-State: AO0yUKVUYVzcdLPgyGcGOnz8o9OR84whdBI/Y7VCFcf1W28D8KgufPOr
        PUVFBodgltHFYFXw0amoKKf2nlEaGSD9nw==
X-Google-Smtp-Source: AK7set9qW42KsgKcD0YT7m7+eu6b2xuqSwttn0WuZYlnEdbSKHXB2w63AjZF92GC4sskiJBvekzIyw==
X-Received: by 2002:ac8:5b89:0:b0:3a4:fddd:f8ef with SMTP id a9-20020ac85b89000000b003a4fdddf8efmr4176571qta.53.1674921530462;
        Sat, 28 Jan 2023 07:58:50 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:50 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv4 net-next 08/10] packet: add TP_STATUS_GSO_TCP for tp_status
Date:   Sat, 28 Jan 2023 10:58:37 -0500
Message-Id: <0436a569c630a93e7abeedaa7ceccfc369f73c39.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
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

Introduce TP_STATUS_GSO_TCP tp_status flag to tell the af_packet user
that this is a TCP GSO packet. When parsing IPv4 BIG TCP packets in
tcpdump/libpcap, it can use tp_len as the IPv4 packet len when this
flag is set, as iph tot_len is set to 0 for IPv4 BIG TCP packets.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/if_packet.h | 1 +
 net/packet/af_packet.c         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index a8516b3594a4..78c981d6a9d4 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -115,6 +115,7 @@ struct tpacket_auxdata {
 #define TP_STATUS_BLK_TMO		(1 << 5)
 #define TP_STATUS_VLAN_TPID_VALID	(1 << 6) /* auxdata has valid tp_vlan_tpid */
 #define TP_STATUS_CSUM_VALID		(1 << 7)
+#define TP_STATUS_GSO_TCP		(1 << 8)
 
 /* Tx ring - header status */
 #define TP_STATUS_AVAILABLE	      0
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b5ab98ca2511..8ffb19c643ab 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2296,6 +2296,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	else if (skb->pkt_type != PACKET_OUTGOING &&
 		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
+	if (skb_is_gso(skb) && skb_is_gso_tcp(skb))
+		status |= TP_STATUS_GSO_TCP;
 
 	if (snaplen > res)
 		snaplen = res;
@@ -3522,6 +3524,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		else if (skb->pkt_type != PACKET_OUTGOING &&
 			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
+		if (skb_is_gso(skb) && skb_is_gso_tcp(skb))
+			aux.tp_status |= TP_STATUS_GSO_TCP;
 
 		aux.tp_len = origlen;
 		aux.tp_snaplen = skb->len;
-- 
2.31.1

