Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C976267F958
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbjA1P7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbjA1P64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:56 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E7230B3D
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:46 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id q15so6617006qtn.0
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=hNYBgbcN29Mi/UztiiRLWzxxkbaew/3tC57kEl+OZ7pK5theW0nRXW03ia6rzTj/Sb
         gWVQVGE+wDh152t5Bh3JKRv59mwl7r7AodCNMIwj8FQfqiCRF1NmmKwVBnYJfE7fiN/t
         9ZigKPfzHFPx+MScWoidxUCy29sEX3rh3KRle100ln7yhzKE0OmbnmsEpE1IdOB/+VFr
         xPemZR6NhaME0pG57IXPkp2g5bsVKLL8ZRtvh8FuAQSK4XbClXQKNSNXaUog6j4Ki3Vw
         CQngqKBOpyzCdE/r3VoeSg5jve11TgJOEfaQ7DLoF97IlSsvBSUz/M0fw4KSlVNf5904
         ksfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=M5LrqEGVwoSNnxzTSpJqBtnInZVXecc8Mx2Ap+KUNoGcI3nZ6SXvuTVahYaehGEI7J
         UGLGeeuJtjuYBSWXeKA5lWEVkUv0g7Bshz59xJd6a+R2cn33Jbz6/+Dlgvo8NZLabAQW
         dQp5HCxwzk1r0fbxMG4F6dYRAM6HH8pGaSYbSRsgDudfXVdONccYLUMttV2IHCAus7R8
         /wrBsm+CCNbJ8bNsg1Uc+UMozQtAdahc+lSJYwv0WDcQ7pyxrdej0a3YrOTv77GWeAAv
         e4AutAcMykjM3yYTTexD9ZuEjAUcJd8SHkph4oyOolDfR1NBecfH52J8ZURkPmjjcl7J
         LC3w==
X-Gm-Message-State: AO0yUKWysaBNHw6nAVVY/V+n1cvPf/ehXVfjGLXUldmVh/IX4+UmMRWY
        16smVT9i94dkKYcG6pNBdrh2+QpbkZayGQ==
X-Google-Smtp-Source: AK7set96arZ43OIUv82ZNjxl6eO+vnp+bknkXCBv04j2hL/ffJfMp0qllmBRma4rBCIYN3nRGCtOzA==
X-Received: by 2002:a05:622a:1352:b0:3b8:4729:8225 with SMTP id w18-20020a05622a135200b003b847298225mr2324334qtk.9.1674921525717;
        Sat, 28 Jan 2023 07:58:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:45 -0800 (PST)
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
Subject: [PATCHv4 net-next 04/10] net: sched: use skb_ip_totlen and iph_totlen
Date:   Sat, 28 Jan 2023 10:58:33 -0500
Message-Id: <0f06c043ca0b55cc1d3a848cf3013fb165a84bb2.1674921359.git.lucien.xin@gmail.com>
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

