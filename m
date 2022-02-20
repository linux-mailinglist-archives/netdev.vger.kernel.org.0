Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036704BD087
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 19:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiBTSFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 13:05:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238456AbiBTSFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 13:05:07 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36BD4527FA;
        Sun, 20 Feb 2022 10:04:41 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 204EB60212;
        Sun, 20 Feb 2022 19:03:47 +0100 (CET)
Date:   Sun, 20 Feb 2022 19:04:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net v2 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
Message-ID: <YhKCtlpgJlliT9Bc@salvia>
References: <20220220093226.15042-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Yv3p7b7MXYtnjMmu"
Content-Disposition: inline
In-Reply-To: <20220220093226.15042-1-paulb@nvidia.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Yv3p7b7MXYtnjMmu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Paul,

On Sun, Feb 20, 2022 at 11:32:26AM +0200, Paul Blakey wrote:
> After cited commit optimizted hw insertion, flow table entries are
> populated with ifindex information which was intended to only be used
> for HW offload. This tuple ifindex is hashed in the flow table key, so
> it must be filled for lookup to be successful. But tuple ifindex is only
> relevant for the netfilter flowtables (nft), so it's not filled in
> act_ct flow table lookup, resulting in lookup failure, and no SW
> offload and no offload teardown for TCP connection FIN/RST packets.
> 
> To fix this, remove ifindex from hash, and allow lookup without
> the ifindex. Act ct will lookup without the ifindex filled.

I think it is good to add FLOW_OFFLOAD_XMIT_TC (instead of relying on
FLOW_OFFLOAD_XMIT_UNSPEC), this allows for more tc specific fields in
the future.

See attached patch.

Thanks.

--Yv3p7b7MXYtnjMmu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..97bc24efe744 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -96,6 +96,7 @@ enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
+	FLOW_OFFLOAD_XMIT_TC,
 };
 
 #define NF_FLOW_TABLE_ENCAP_MAX		2
@@ -142,6 +143,9 @@ struct flow_offload_tuple {
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
+		struct {
+			u32		iifidx;
+		} tc;
 	};
 };
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..fc4265acd9c4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -110,7 +110,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
 
-	key->meta.ingress_ifindex = tuple->iifidx;
+	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_TC)
+		key->meta.ingress_ifindex = tuple->tc.iifidx;
+	else
+		key->meta.ingress_ifindex = tuple->iifidx;
+
 	mask->meta.ingress_ifindex = 0xffffffff;
 
 	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247fc6468..d6bbce68c957 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -361,6 +361,13 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 	}
 }
 
+static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
+				 struct nf_conn_act_ct_ext *act_ct_ext, u8 dir)
+{
+	entry->entry->tuplehash[dir].tuple->xmit_type = FLOW_OFFLOAD_XMIT_TC;
+	entry->tuplehash[dir].tuple.tc.iifidx = act_ct_ext->ifindex[dir];
+}
+
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
 				  bool tcp)
@@ -385,10 +392,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
-		entry->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_ORIGINAL];
-		entry->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_REPLY];
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_ORIGINAL);
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
 	}
 
 	err = flow_offload_add(&ct_ft->nf_ft, entry);

--Yv3p7b7MXYtnjMmu--
