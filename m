Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69AC644FA0
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLFXbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFXbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:31:21 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171042F45
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:31:21 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id c14so11592271qvq.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuFGycqO6KGGXaG/l3CIzDYeGA82Mj83kPr3Jk7yWZs=;
        b=BMH5w5BfD1nBaTIEKmpxirKWOD+vY/2XK2AWpbv0omXearz3SVMCmOgYgEY1T3jcTM
         /3seYZmlQtnEQAnn00U80qdgVximRjaIjNtOtFrdRoXL/quWlATeuDgcigHcM8/Vhjok
         l5Zw/pqtNKTfOT5K+elbsqku05J4h4dI5ha/1tGzJ3uwhRd4/aIahiPIuyl09FWKW+M0
         fqeo9oRooqFf/hzHrl1fDO7GddMPdfoywvYAluhIfNVp7Q0GR9ant/ndrDhOwOwF+uTF
         09jM8fYc9QIIDKsY1LR9Tv95PaBfWWFQf7HQuhmQWFbswl7MWO3s2n8Q7yBgRQxCXP7b
         BiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuFGycqO6KGGXaG/l3CIzDYeGA82Mj83kPr3Jk7yWZs=;
        b=D7bAYsHAn0MUta4M7X0t09lU3YEXExEHpCB60jhcUrUPNBdxtfJTehfBoGZ45TjSHd
         lJHOkaa64QgEtWnsV6amegy9LOUquiibldSN67s3o922zkhnCvjvs5xDNigG6ZAeU/L9
         /IMnY5c8AdHrpbcnkbrgqGesCoolCguuTdG4wPZufpevdYhUW98qf90k14NaMebZ6KNr
         bBSrkcCKV8on5OrydHlNhW1yl3GhX4jJpBI1tW06cC8AAeFhcpC1HyLYmNAcxt0GtX2K
         B1n2b4WbTkMF9Z3/L20FISPu7/V81rgOn9Atu1N3gqgF5I6REOcMrSGtB73fr8EPoCj3
         9MGg==
X-Gm-Message-State: ANoB5pkZ9NZG/jIi18QN2rwAPiK5u6dySIH/yqG8S977ogFOpLURYPS7
        RwIhLO/LDZ0leO4S564XPqlMg9mjriyP9A==
X-Google-Smtp-Source: AA0mqf6S+R7ydqg8zMZEIONKRD071p3vSc9oNYYGXvWaqbplMm/KTrfaPlmv9OfbhkBn+4ecpof37A==
X-Received: by 2002:ad4:44b4:0:b0:4c6:d91c:441f with SMTP id n20-20020ad444b4000000b004c6d91c441fmr52909123qvt.118.1670369479731;
        Tue, 06 Dec 2022 15:31:19 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006f8665f483fsm16590231qko.85.2022.12.06.15.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:31:19 -0800 (PST)
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
Subject: [PATCHv3 net-next 1/5] openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
Date:   Tue,  6 Dec 2022 18:31:12 -0500
Message-Id: <9943e5a2456c613533174115680e67c8e6d9f181.1670369327.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670369327.git.lucien.xin@gmail.com>
References: <cover.1670369327.git.lucien.xin@gmail.com>
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

