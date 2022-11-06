Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA961E5F0
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKFUea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 15:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiKFUe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 15:34:27 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1846A11444
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 12:34:26 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id k2so6187606qkk.7
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 12:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YaNOJM8jkX+x4IRM1cU8ASldVaWWDUSowx6SMgxA88=;
        b=Ug3MUHb0JJdn+BrH45Gu4GpWV011VTqAPpyZk1DgMjEptcMHYcYrAvr2QM7h2t7m+e
         buz+3tgFdnpiD5hGlzBESPFmYoeRAKSThETL/ceXM20yr5OnqITt1/yPzcdV6gAwFecL
         xKCyKQUgy9FCHBWNgUFRqalCThdqIxd7XF1NHmayYFL0i0llls3uL1ghlF7OG/dKHJji
         sBKh8BRSeRY74HMgvWlAN4yGtVH/Zswxvmqp6ee/rAxfDotFfeicXBKjsXvcIzKZPOHI
         Ff3YiDDj8WgedQSjbZjjFh5ZBSh3IO41IwCrSCelMDI4x3dxACDr4XANyvpz5G4Jruxe
         opfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YaNOJM8jkX+x4IRM1cU8ASldVaWWDUSowx6SMgxA88=;
        b=P0zY1Te7tyGRyMTWJrs3WAWgnprpS/1vcBUCYoC3i9xnv+HhNSov1aBSd1Jp545FsN
         dtaBkTMb5qVfSO8zRGb75jcDQSVTJ8uUoEwt4Jm9rTkpiQSXcc/4ryE2Dunaih1CcnCT
         A0YcbrsFJDnMMHAGZtHwvRulKqCBmwuolkFMhlKlb0j0wVT0cqP8ko7dR9YF7purUvRi
         53jWGX3SnXyVapMSeQh7B9ffCCmaPgkm1enb+RW+PrIzeH/MckF8pq8bVS80orOkq32R
         UnPT13eIn0SSNw2FpW14SuniGW6VVHKLrqdJyOVkNxiJNECMwr9C4OK4FmXcoRroQQm3
         EAAg==
X-Gm-Message-State: ACrzQf2gG/d3/rvG+invhNTy/zDZo5N93debI3D7bDwTjfMNQvFRqtRD
        bonGORd/awUK7D1xxTqPe7bLMvvMQQ1syA==
X-Google-Smtp-Source: AMsMyM6HjuuvIrnLLV4zTqjkdCRnLT+kC3KbvzJvvc0Br4IkZ1ansf2YhGN22ek9OrOkl5B3NduE0w==
X-Received: by 2002:a37:c202:0:b0:6fa:5762:d418 with SMTP id i2-20020a37c202000000b006fa5762d418mr19430265qkm.154.1667766864999;
        Sun, 06 Nov 2022 12:34:24 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t31-20020a05622a181f00b003a540320070sm4703551qtc.6.2022.11.06.12.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 12:34:24 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
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
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv4 net-next 2/4] net: move add ct helper function to nf_conntrack_helper for ovs and tc
Date:   Sun,  6 Nov 2022 15:34:15 -0500
Message-Id: <2a0b53c840afd1af4c12e424adc53fc4dd0b436a.1667766782.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667766782.git.lucien.xin@gmail.com>
References: <cover.1667766782.git.lucien.xin@gmail.com>
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

Move ovs_ct_add_helper from openvswitch to nf_conntrack_helper and
rename as nf_ct_add_helper, so that it can be used in TC act_ct in
the next patch.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  2 +
 net/netfilter/nf_conntrack_helper.c         | 31 +++++++++++++++
 net/openvswitch/conntrack.c                 | 44 +++------------------
 3 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index b6676249eeeb..f30b1694b690 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -117,6 +117,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo, u16 proto);
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp);
 
 void nf_ct_helper_destroy(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 88039eedadea..48ea6d0264b5 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -309,6 +309,37 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper);
 
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int ret = 0;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper)
+		return -EINVAL;
+
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (nat) {
+		ret = nf_nat_helper_try_module_get(name, family, proto);
+		if (ret) {
+			nf_conntrack_helper_put(helper);
+			return ret;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	*hp = helper;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_add_helper);
+
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 18f54fa38e8f..4348321856af 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1291,43 +1291,6 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 	return 0;
 }
 
-static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
-			     const struct sw_flow_key *key, bool log)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help;
-	int ret = 0;
-
-	helper = nf_conntrack_helper_try_module_get(name, info->family,
-						    key->ip.proto);
-	if (!helper) {
-		OVS_NLERR(log, "Unknown helper \"%s\"", name);
-		return -EINVAL;
-	}
-
-	help = nf_ct_helper_ext_add(info->ct, GFP_KERNEL);
-	if (!help) {
-		nf_conntrack_helper_put(helper);
-		return -ENOMEM;
-	}
-
-#if IS_ENABLED(CONFIG_NF_NAT)
-	if (info->nat) {
-		ret = nf_nat_helper_try_module_get(name, info->family,
-						   key->ip.proto);
-		if (ret) {
-			nf_conntrack_helper_put(helper);
-			OVS_NLERR(log, "Failed to load \"%s\" NAT helper, error: %d",
-				  name, ret);
-			return ret;
-		}
-	}
-#endif
-	rcu_assign_pointer(help->helper, helper);
-	info->helper = helper;
-	return ret;
-}
-
 #if IS_ENABLED(CONFIG_NF_NAT)
 static int parse_nat(const struct nlattr *attr,
 		     struct ovs_conntrack_info *info, bool log)
@@ -1661,9 +1624,12 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	}
 
 	if (helper) {
-		err = ovs_ct_add_helper(&ct_info, helper, key, log);
-		if (err)
+		err = nf_ct_add_helper(ct_info.ct, helper, ct_info.family,
+				       key->ip.proto, ct_info.nat, &ct_info.helper);
+		if (err) {
+			OVS_NLERR(log, "Failed to add %s helper %d", helper, err);
 			goto err_free_ct;
+		}
 	}
 
 	err = ovs_nla_add_action(sfa, OVS_ACTION_ATTR_CT, &ct_info,
-- 
2.31.1

