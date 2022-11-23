Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4568063684D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbiKWSHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbiKWSGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:06:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFEED1C08;
        Wed, 23 Nov 2022 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669226601; x=1700762601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w9RmeZjtCjYZDa05D70xUE4PGBJek3/Pk2HxVVisXRs=;
  b=IG+CcfHfK7x5gMwGCbIEHcV+Nn24sBi6sUCh6fHdY4FtwpTfGpuuSA2q
   aJJfmAwzvIXU+b66sTTZLz+ahoWVeqttnSqLOb50/dMIHSu7/wrv77MwR
   Hc0nI4+Dqlex/X6JhP2D7AabN6J/5GwizUVtFMx8/MgF/6Z9rlMOXCfJt
   bwXgSRSLvPBlxtQxoYEe/3GufMBHYN4HwdI0M1yJ/SGNYPa6hOFzbSorN
   Lu6FHe1SkCC3sww7sVaKmyoi5k9x4pLhQTuz0PTYqj9/zWtaaI+DrMgho
   Ww6Dc5yx89R4ZWYw8p7gWZf7sSk8zyRMpNMcKTWzfNrSz5lGSiB4H2jQn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="311764581"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311764581"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:03:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="816565091"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="816565091"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2022 10:03:10 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANI38Ug029972;
        Wed, 23 Nov 2022 18:03:09 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH V2] octeontx2-pf: Add support to filter packet based on IP fragment
Date:   Wed, 23 Nov 2022 19:02:49 +0100
Message-Id: <20221123180249.487977-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084038.2824345-1-sumang@marvell.com>
References: <20221123084038.2824345-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Ghosh <sumang@marvell.com>
Date: Wed, 23 Nov 2022 14:10:38 +0530

> 1. Added support to filter packets based on IP fragment.
> For IPv4 packets check for ip_flag == 0x20 (more fragment bit set).
> For IPv6 packets check for next_header == 0x2c (next_header set to
> 'fragment header for IPv6')
> 2. Added configuration support from both "ethtool ntuple" and "tc flower".
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
> Changes since v1:
> - Added extack change.
> - Added be32_to_cpu conversion for ip_flag mask also.
> 
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  4 +++
>  .../net/ethernet/marvell/octeontx2/af/npc.h   |  2 ++
>  .../marvell/octeontx2/af/rvu_debugfs.c        |  8 ++++++
>  .../marvell/octeontx2/af/rvu_npc_fs.c         |  8 ++++++
>  .../marvell/octeontx2/nic/otx2_flows.c        | 25 ++++++++++++++++---
>  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 25 +++++++++++++++++++
>  6 files changed, 68 insertions(+), 4 deletions(-)

[...]

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index 642e58a04da0..1cf026de5f1a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -2799,6 +2799,14 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
>  			seq_printf(s, "%pI6 ", rule->packet.ip6dst);
>  			seq_printf(s, "mask %pI6\n", rule->mask.ip6dst);
>  			break;
> +		case NPC_IPFRAG_IPV6:
> +			seq_printf(s, "%d ", rule->packet.next_header);
> +			seq_printf(s, "mask 0x%x\n", rule->mask.next_header);

Why the same field is printed as signed decimal in the first printf,
but as unsigned hex in the second? Could you please unify to `0x%x`?

> +			break;
> +		case NPC_IPFRAG_IPV4:
> +			seq_printf(s, "%d ", rule->packet.ip_flag);
> +			seq_printf(s, "mask 0x%x\n", rule->mask.ip_flag);

(same)

> +			break;
>  		case NPC_SPORT_TCP:
>  		case NPC_SPORT_UDP:
>  		case NPC_SPORT_SCTP:

[...]

> @@ -484,8 +486,10 @@ do {									       \
>  	 * Example: Source IP is 4 bytes and starts at 12th byte of IP header
>  	 */
>  	NPC_SCAN_HDR(NPC_TOS, NPC_LID_LC, NPC_LT_LC_IP, 1, 1);
> +	NPC_SCAN_HDR(NPC_IPFRAG_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 6, 1);

I know it's out of the patch's subject, but this macro has "hidden"
argument usage:

* lid;
* lt;
* hdr;
* nr_bytes;
* mcam;
* cfg;
* intf;
* ...

We try to avoid that.
Could you please (in a separate patch, it can be made later)
refactor that block? For example, you can create an onstack
structure, put all those variables there and then pass that struct
to the macro.

Also, you call that macro 20+ times and it's not so small itself, so
converting these 20 calls to an array of 20 const parameters and
then doing one loop over that array can significantly reduce code
size.

>  	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
>  	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
> +	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC, NPC_LT_LC_IP6_EXT, 6, 1);
>  	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
>  	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
>  	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
> @@ -899,6 +903,8 @@ do {									      \
>  	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
>  		       ntohs(mask->etype), 0);
>  	NPC_WRITE_FLOW(NPC_TOS, tos, pkt->tos, 0, mask->tos, 0);
> +	NPC_WRITE_FLOW(NPC_IPFRAG_IPV4, ip_flag, pkt->ip_flag, 0,
> +		       mask->ip_flag, 0);

Same for this function.

>  	NPC_WRITE_FLOW(NPC_SIP_IPV4, ip4src, ntohl(pkt->ip4src), 0,
>  		       ntohl(mask->ip4src), 0);
>  	NPC_WRITE_FLOW(NPC_DIP_IPV4, ip4dst, ntohl(pkt->ip4dst), 0,
> @@ -919,6 +925,8 @@ do {									      \
>  	NPC_WRITE_FLOW(NPC_OUTER_VID, vlan_tci, ntohs(pkt->vlan_tci), 0,
>  		       ntohs(mask->vlan_tci), 0);
>  
> +	NPC_WRITE_FLOW(NPC_IPFRAG_IPV6, next_header, pkt->next_header, 0,
> +		       mask->next_header, 0);
>  	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
>  	npc_update_vlan_features(rvu, entry, features, intf);

[...]

> -		/* Not Drop/Direct to queue but use action in default entry */
> -		if (fsp->m_ext.data[1] &&
> -		    fsp->h_ext.data[1] == cpu_to_be32(OTX2_DEFAULT_ACTION))
> -			req->op = NIX_RX_ACTION_DEFAULT;
> +		if (fsp->m_ext.data[1]) {
> +			if (flow_type == IP_USER_FLOW) {
> +				if (be32_to_cpu(fsp->h_ext.data[1]) != 0x20)

Define 0x20 as a macro to not search for it for long when it's
needed?

> +					return -EINVAL;
> +
> +				pkt->ip_flag = (u8)be32_to_cpu(fsp->h_ext.data[1]);
> +				pmask->ip_flag = (u8)be32_to_cpu(fsp->m_ext.data[1]);

These explicit casts are not needed unless I'm missing something?

> +				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
> +			} else if (fsp->h_ext.data[1] ==
> +					cpu_to_be32(OTX2_DEFAULT_ACTION)) {
> +				/* Not Drop/Direct to queue but use action
> +				 * in default entry
> +				 */
> +				req->op = NIX_RX_ACTION_DEFAULT;
> +			}
> +		}
>  	}
>  
>  	if (fsp->flow_type & FLOW_MAC_EXT &&
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> index e64318c110fd..93b36d2cf883 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> @@ -532,6 +532,31 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
>  			req->features |= BIT_ULL(NPC_IPPROTO_ICMP6);
>  	}
>  
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
> +		struct flow_match_control match;
> +
> +		flow_rule_match_control(rule, &match);
> +		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
> +			NL_SET_ERR_MSG_MOD(extack, "HW doesn't support frag first/later");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
> +			if (ntohs(flow_spec->etype) == ETH_P_IP) {
> +				flow_spec->ip_flag = 0x20;

0x20 again, see? One definition for both would make it clear.

> +				flow_mask->ip_flag = 0xff;
> +				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
> +			} else if (ntohs(flow_spec->etype) == ETH_P_IPV6) {
> +				flow_spec->next_header = IPPROTO_FRAGMENT;
> +				flow_mask->next_header = 0xff;
> +				req->features |= BIT_ULL(NPC_IPFRAG_IPV6);
> +			} else {
> +				NL_SET_ERR_MSG_MOD(extack, "flow-type should be either IPv4 and IPv6");
> +				return -EOPNOTSUPP;
> +			}
> +		}
> +	}

This block is big and the function is huge even before the patch.
Could you (it may be a separate patch as well) split it logically?

> +
>  	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
>  		struct flow_match_eth_addrs match;
>  
> -- 
> 2.25.1

Thanks,
Olek
