Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0064466A8F8
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjANDby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjANDbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:44 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0960A8B753
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:43 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id bp44so20804581qtb.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=owAGItzRr0xbiFqWOitioFdmA5MU+xg4bgwmYefg1m/pFNWqmVyhpOG+LF41RsV6z/
         sw804CdhWdX5s8SBQkt5Pf72Ms46cnTxzdhrzbiq6qYEteOY1g8gJy1OopNGh/pxMIOQ
         Wua/3/lBcfY0mtNdH3ZlKNSxAbnPQmHDuOTcZg3FKK3Yw+YfljIA4UKXITWdeVYhsnAj
         bY5PN8jeo0zioLgcMSwoNLSzrWd3R4Rr59CTj+6r3cP7Z+zO3ZJzij9UKovT/Xpsmom7
         8aKUEFRIjz0aPK5JHQ2W82HJGtAqhPhPkMLntaQFbkTS5d62RAVwUN+VxN8+/qebHQte
         ZmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=fZQg2hztlq1d0M0CqQVzMopCj+WilQZg1vBafIbRaIe1b7ysyvLqrp1P/I3JtgApSG
         xIbtCSEIaVsFPp0qqLjdDa8gSiVz8v1eyWuQ9E7yIGu2JYvnjbDt+dcseG4bKKorZlCR
         YoUSNT2sjJATsxHfPiOkOPWrPak0rHENMYWEfAHcnrqDCi6RPjnzE5vZinlKzI7lCHX2
         RK6BONvCLG9sxnAvABuMIOr9dVDBmSNw25gAqLpX4Sw7LpD3hjM8iUP15ZfIPiGt8QC6
         42aWaBcEdXBcx2hACG8mUEbVlnMCb1UZ2Hp1EQ7u/slWpMZTqHPf5xtFz+OzdBlw4RtE
         dWCg==
X-Gm-Message-State: AFqh2kpeTihovGc4vxm6GMu7hEDvFBb4tGMM7ESoKPS6H5rx9af0JEUy
        mqm246xwBeiGKmb97YZl56CVviXkNsbuHA==
X-Google-Smtp-Source: AMrXdXvO3etL3CghVRkEgF8SbQFf/ss5milCk9VGbdT+iTkeu50BrF0NA3h+lUHk2125fwozjHaczQ==
X-Received: by 2002:ac8:4514:0:b0:3ab:6b9c:7285 with SMTP id q20-20020ac84514000000b003ab6b9c7285mr108651669qtn.44.1673667102052;
        Fri, 13 Jan 2023 19:31:42 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:41 -0800 (PST)
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
Subject: [PATCH net-next 04/10] net: sched: use skb_ip_totlen and iph_totlen
Date:   Fri, 13 Jan 2023 22:31:28 -0500
Message-Id: <d3ed825c4e3879f660aa8119b9fa746084e59aa5.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
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

There are 1 action and 1 qdisc that may process IPv4 TCP GSO packets
and access iph->tot_len, replace them with skb_ip_totlen() and
iph_totlen() accordingly.

Note that we don't need to replace the one in tcf_csum_ipv4(), as it
will return for TCP GSO packets in tcf_csum_ipv4_tcp().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c   | 2 +-
 net/sched/sch_cake.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..d68bb5dbf0dc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -707,7 +707,7 @@ static int tcf_ct_skb_network_trim(struct sk_buff *skb, int family)
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
 		len = sizeof(struct ipv6hdr)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 3ed0c3342189..7970217b565a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1209,7 +1209,7 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 			    iph_check->daddr != iph->daddr)
 				continue;
 
-			seglen = ntohs(iph_check->tot_len) -
+			seglen = iph_totlen(skb, iph_check) -
 				       (4 * iph_check->ihl);
 		} else if (iph_check->version == 6) {
 			ipv6h = (struct ipv6hdr *)iph;
-- 
2.31.1

