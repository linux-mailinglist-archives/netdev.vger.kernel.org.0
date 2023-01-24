Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A451678E2F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjAXCUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjAXCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:22 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DD73A840
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:17 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id j9so12059680qtv.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=oirVX+xXt35lRKgNz8f4BpNSuUHiYprTzNiCd3ioA+elXOn83BVT1l0yDdgGBYl1lM
         u8oJ/w3FerC/BF4LmxPQD5M8L2e6dCHgmrxxIHJhtopzJHHqvu5BqvWrPS7ufaNoUMc8
         DBKyqh/QcqoOxvwqdShvbgimv4iQB8VeBY8b/W47FT0GVsomXq/e/rGyY47TWQJCsDF6
         1JNHiaWdayMJI4M9bshWNWjFX8VpXjJcerAShGBmZqyvXw1EC90ug9ufH39fSVLAzjXO
         WfLjpv/SWZ1owY8LgnPpee6k+ZhILyqK2jcG5TUyj4RxQ2EjDsMHo/m9uDOf69MtLYpb
         1SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=1Vyaejz67MzECN1HKGPOAX3uKfsameHKwhQXp1kYx0ehmXZ1zPpVt40TaJ6IqfUR6w
         EZedndlHX4/B72e1PWLVzSaoq44RF5RCQtPcTTgfjvYP2I1nv1AZQX9XKNC+sKoWG77l
         x3XLLX8mgnd0mTCpwG00xxxSfE2zUdLdSZao39dCrZlVgKyz3+RDjmWIW9TjXMWwmEbv
         ZCstSk96xHDb3D8XjcE52j6lBsJFizic4ipWLoZIybRZCw87bjD8ynLIut1niPcn7Rdy
         5bDjdjxRirWmDvP9PIuVOEA0o5+ArBYpvYuyBK2wkNCpRk6G64fqEINCC0XrzvtqRd3N
         9OlA==
X-Gm-Message-State: AFqh2koWwcHI9IEQbCaSrfIoQ7GhI+t0l4u6d6up6BRFvXocIfIaoJw2
        DVnrpldY9r5Va4yw76cu2P+b4CzCkrnsSg==
X-Google-Smtp-Source: AMrXdXshEq3AzK4iLW4rVQlaHpyYLud+17NbOyAtXlOK8JBfDz4p9QlQKc0Oe/E//n1WBvleUBQSBw==
X-Received: by 2002:ac8:73c6:0:b0:3b6:6669:dd33 with SMTP id v6-20020ac873c6000000b003b66669dd33mr31879910qtp.41.1674526816357;
        Mon, 23 Jan 2023 18:20:16 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:16 -0800 (PST)
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
Subject: [PATCHv2 net-next 08/10] packet: add TP_STATUS_GSO_TCP for tp_status
Date:   Mon, 23 Jan 2023 21:20:02 -0500
Message-Id: <995ffc0f6636aa0cd4e4ae4c076b02a3e56a30ee.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
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

