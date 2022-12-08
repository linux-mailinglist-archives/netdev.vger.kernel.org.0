Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756AE6474BC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiLHQ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiLHQ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:18 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F1B70BA8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:17 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id cg5so1492251qtb.12
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuFGycqO6KGGXaG/l3CIzDYeGA82Mj83kPr3Jk7yWZs=;
        b=Hhmmaf11TB/Ut5+CoSc7m1+DbfHtWTJEViBFU1PBJR6J7brPFfoX7yXkTkPI4tTfMC
         hOV0KCu52YykY32eItSue8d5fgNe1BwiCgoDbeTpxwBJ6m8nycdWZ6jb7G2xsApAJKeC
         pGbgnGzHK9r8lzkD8Vxy3maF7xREaLkzkOaSRo5QrZLipbUqCUJTk0At6jN6O088nZEW
         0rEzkaNhl8O5d0/+SJaAbSmmfdNyrXskcvaFA4XRsPchjoz3wcdrDFKGG+OjwINFK4GT
         pIhVAJAm9LqTtQK+r6Mdmk1tBzG7AZ5AUR541NtkIJI+OeEO/di2e9Oyiu0XJ79+Jcwu
         3JGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuFGycqO6KGGXaG/l3CIzDYeGA82Mj83kPr3Jk7yWZs=;
        b=TsCBAWm2EU0qppLhIwOfQ+m0fOPg+c9yKo/dLPH9pqdApdk6TfcApmHjxuji/3rDpG
         KfIDOJab+btR+WiCoClnqZ4eZh9G6rN/dQaEyw8/Y1nT291ZW2YvYkOIHMU5mf/2ZEGh
         ie7dZe66WABMcr1FRwC9HoCTaYAdrEz/BagkmkYkOTM8ByNrRasvIhQA8oilG/4CJYdK
         t6yddICcMT8vckbPCImvNnVoLtmUbHRjzyDYtCJep1lhsNkahXF2/QYMIQf1TSdPk+7V
         kUsVD7yk0X4VaPMs4LQW11ENYMhMFun88Qq0c7IZTK2hGFxRPMOJVhg/7dnMIFDpEiV/
         1GsQ==
X-Gm-Message-State: ANoB5pl6miajOiKXTumd/k6phnPbop0cBFgJ9swZMT4uFxDAb/emsJEp
        rUY+f92Qtzq3WuHjo4eLVmg100HHTBHPPQ==
X-Google-Smtp-Source: AA0mqf5r8t3a+n48CpYl0OL+os0EzfcTPho+uLnVFy8UCV4BEl/HTajaGGp7I4o0YoJylfJCkwLxqQ==
X-Received: by 2002:a05:622a:1818:b0:3a6:8da6:65bc with SMTP id t24-20020a05622a181800b003a68da665bcmr5332353qtc.13.1670518576603;
        Thu, 08 Dec 2022 08:56:16 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:16 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv4 net-next 1/5] openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
Date:   Thu,  8 Dec 2022 11:56:08 -0500
Message-Id: <4ec38bb580f849e40e2ca32291ab86fffd26ab55.1670518439.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
References: <cover.1670518439.git.lucien.xin@gmail.com>
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

The calls to ovs_ct_nat_execute() are as below:

  ovs_ct_execute()
    ovs_ct_lookup()
      __ovs_ct_lookup()
        ovs_ct_nat()
          ovs_ct_nat_execute()
    ovs_ct_commit()
      __ovs_ct_lookup()
        ovs_ct_nat()
          ovs_ct_nat_execute()

and since skb_pull_rcsum() and skb_push_rcsum() are already
called in ovs_ct_execute(), there's no need to do it again
in ovs_ct_nat_execute().

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index d78f0fc4337d..dff093a10d6d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -735,10 +735,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      const struct nf_nat_range2 *range,
 			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
 {
-	int hooknum, nh_off, err = NF_ACCEPT;
-
-	nh_off = skb_network_offset(skb);
-	skb_pull_rcsum(skb, nh_off);
+	int hooknum, err = NF_ACCEPT;
 
 	/* See HOOK2MANIP(). */
 	if (maniptype == NF_NAT_MANIP_SRC)
@@ -755,7 +752,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   hooknum))
 				err = NF_DROP;
-			goto push;
+			goto out;
 		} else if (IS_ENABLED(CONFIG_IPV6) &&
 			   skb->protocol == htons(ETH_P_IPV6)) {
 			__be16 frag_off;
@@ -770,7 +767,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 								     hooknum,
 								     hdrlen))
 					err = NF_DROP;
-				goto push;
+				goto out;
 			}
 		}
 		/* Non-ICMP, fall thru to initialize if needed. */
@@ -788,7 +785,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 				? nf_nat_setup_info(ct, range, maniptype)
 				: nf_nat_alloc_null_binding(ct, hooknum);
 			if (err != NF_ACCEPT)
-				goto push;
+				goto out;
 		}
 		break;
 
@@ -798,13 +795,11 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 
 	default:
 		err = NF_DROP;
-		goto push;
+		goto out;
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
-push:
-	skb_push_rcsum(skb, nh_off);
-
+out:
 	/* Update the flow key if NAT successful. */
 	if (err == NF_ACCEPT)
 		ovs_nat_update_key(key, skb, maniptype);
-- 
2.31.1

