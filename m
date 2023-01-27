Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1F67EA3B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjA0QAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjA0QAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:15 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235AE87154
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:09 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id z9so4358651qtv.5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=plkvxr0E5bSGi+PYG79GHrxYLZ03VgUt6tGfa1wHB69PUp9EpFRENIrIhFRnCgxyFL
         2sbT8R4XpJluo94FcS0ACzppTHsNGsGjQi5rPyA+7jAjvW+09skgMGbtD+r9pKPOcKEp
         bH5SXcShVvJKhN2wMlK9yH3m0t/hjtUcZTIoYCV410glLxklKPxb/87VvjaOqxF+6mIb
         nJRmE/bTOtrD42xuBcEjUcgxfDx/sMdc8J7/lmJxYbnroF/bfysazidIJ5CbDmkcZUzj
         WnvpnsP5RdIakrS+H0ZVuN6510fZ1ds3F1Sim2do12h+SxnIpL7VmC1Fbp3KhWSZfryP
         l5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hbUyBh1zPDHGKtsmgkDKwqAxLhgAY3/Mg+p631es5Y=;
        b=v4gGsk+AeIIauNeqePGqAfSRZFGvgBqtKslJWd4YeAS/NY6jjHsHN86IzyKY3nseiE
         PkR0PSYRLCXjx986t6DwvHLQ6SyaM+5sZLTICv1Q89a0JKYoxSQ9vCuRjatml+g1M1B/
         rxhHdZruM8V1ucyU4wzOeXw4d+dVcfvIyVpUEjZgBqI8eJMoL0xnZFKhAO/fRUmTkQIQ
         apsjbSr8N9ClRwXPNRxMpYvwFrQcUzZRN0XU9dUzDvIRzz1s5zO42AtFXGwLGiu9EOzM
         O+Dgd/rUXy/3INK4IKpfzpj2DkUSNdOxxduyYX6/BQXNOMIGUlc8CDeBWTQMS6FCO85k
         6TOw==
X-Gm-Message-State: AFqh2koZuipawxhDGPSvYOct6pqFD/6pDLR1rYzZIRirkax91cwsAcAh
        sT/mVbBdY7DYOc67qQclQgoUs/YYoHY1Zg==
X-Google-Smtp-Source: AMrXdXtPNmdm1xJ4OmhLT0ehdPOn88hFn3wcj2wAjmTbVJx8MVRvwjh1Z633KzV5/2kvrrNwpsS/lQ==
X-Received: by 2002:ac8:7107:0:b0:3ab:d932:6c4e with SMTP id z7-20020ac87107000000b003abd9326c4emr50218998qto.18.1674835208025;
        Fri, 27 Jan 2023 08:00:08 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:07 -0800 (PST)
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
Subject: [PATCHv3 net-next 08/10] packet: add TP_STATUS_GSO_TCP for tp_status
Date:   Fri, 27 Jan 2023 10:59:54 -0500
Message-Id: <5107430f3d93d5e3fe21e269e5d30667b01daadd.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

