Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7D66A8F6
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjANDbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjANDbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:41 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618338B769
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:40 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id a25so13544430qto.10
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=FcbFvrHrry3fMOV7ArGlilPSiV9zoDcUbQHNDXqwByHetT7S7FZ8KilAIVwQpepPeT
         AJIjSANwZ4L31Cq332AL4bBW++w7zw8pkvzPb5w/2n3fBn0ZWQArBRfstjwI1NIygmYH
         /KEtJoy+qkYed0C9mSzr9ESZBkGq+wWdK2oGMmSN4JRPohd74eFf0f0LEUw0lgTwZYjg
         MkwqhMO03ALxH4oVTDYnoon4Yl2/oqCHo30RYODUIJcshatcyYOj+12NfAdePNOHW/9v
         U3ZuV4DlDhyo5Vh/b45J6K2BC+z+yxfSs0WcSjTTod5m1EEnkJvg8jj44IACMeOUTr+u
         MIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=5swbBws0MTWuKTqpy6otJVDZfxvUHO0FgX1vzcWZr8icXUQIchXnR8nNPcAFBcyL+x
         f+LKyN9Z+rO1pD4HoubIO6un2PRW03msnzEfT9Gi4utPd4zFuL5Beew39Fsh2usxhnB4
         03Io/3sVeGixm8Chluv6v2T1xyyuNE+5ijLd1sXoOmpTRAJ+hCdmoqG81wGYT5/BK2XQ
         cgQSi15Nvf06NcWNm1ILNoMID9UfYZ9wL7ZyyxJnnWPxhtGBjpRW/cJPupah5BdnTcVD
         /zR9mCXdgfCmHILnvNqmeevKQbnDIa0H3H/zkEyoFiggeA7jU02x7MB4Ylcw+BYkJvLR
         n3CQ==
X-Gm-Message-State: AFqh2kq+BrlxZ2Weo34Brilp5+p+i4mPVglMvaNa3qes4ixQ/akEDEY9
        DVoc3ByKRunZnxB29PjJ06bN98edxQ0PVA==
X-Google-Smtp-Source: AMrXdXvx6Cx9AxDw4ZxuCSqrNbifiy7JDUXd2SWvKP1HOTgsRWug06ctmHlkLNl5+D6hu2DaWK3bjA==
X-Received: by 2002:ac8:5e90:0:b0:3a7:ea9b:5627 with SMTP id r16-20020ac85e90000000b003a7ea9b5627mr21899099qtx.13.1673667099360;
        Fri, 13 Jan 2023 19:31:39 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:39 -0800 (PST)
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
Subject: [PATCH net-next 02/10] bridge: use skb_ip_totlen in br netfilter
Date:   Fri, 13 Jan 2023 22:31:26 -0500
Message-Id: <ea90ec39ae356ab4184d4f4420284781ca9e4310.1673666803.git.lucien.xin@gmail.com>
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

These 3 places in bridge netfilter are called on RX path after GRO
and IPv4 TCP GSO packets may come through, so replace iph tot_len
accessing with skb_ip_totlen() in there.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_hooks.c            | 2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..b67c9c98effa 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -214,7 +214,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
 		goto csum_error;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < len) {
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 5c5dd437f1c2..71056ee84773 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -212,7 +212,7 @@ static int nf_ct_br_ip_check(const struct sk_buff *skb)
 	    iph->version != 4)
 		return -1;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < nhoff + len ||
 	    len < (iph->ihl * 4))
                 return -1;
@@ -256,7 +256,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 			return NF_ACCEPT;
 
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		if (pskb_trim_rcsum(skb, len))
 			return NF_ACCEPT;
 
-- 
2.31.1

