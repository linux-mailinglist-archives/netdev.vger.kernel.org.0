Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C2181FD7
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgCKRpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:45:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58856 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730624AbgCKRpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:45:14 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4D0258005C;
        Wed, 11 Mar 2020 17:45:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 11 Mar
 2020 17:45:05 +0000
Subject: Re: [PATCH net-next ct-offload v3 13/15] net/mlx5e: CT: Offload
 established flows
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <1583937238-21511-14-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d883b801-2325-f3b3-c60d-257484dbfff0@solarflare.com>
Date:   Wed, 11 Mar 2020 17:45:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583937238-21511-14-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25282.003
X-TM-AS-Result: No-7.539300-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9OHhqIXe4IzYda1Vk3RqxOGIA
        8SiylTuqMs6iQe2NGVBE+ltykukomC3jdsKQE+0xsFkCLeeufNsA+JHhu0IR5nCR0itW3xfVznl
        8rVYzW/fmldFhLn1YDi2Rxuw/iP4WWImJLGYhU2XM0ihsfYPMYeZM8S4DYUopwUqLhUY4dAIMBa
        mo6dtUXn5w5FSrjoDVufTWj9RlKu/lRxm3A2wKujl/1fD/GopdWQy9YC5qGvz6APa9i04WGCq2r
        l3dzGQ1VpkbFuCHESLAP+zQk3i0+jZNFrXYTa1pa3sYvHpc07qDJlVdoxnwypqWuOWlVrMHP3UY
        FRFiWr17OiUaWhSEnUvSIVYg19WL5r2bb10OJqUpq2pZSxIsaKon7YxrK51SxywZbTuLLdqGmIr
        CFl3b3UMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.539300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25282.003
X-MDID: 1583948713-pQd4onhZqy0I
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2020 14:33, Paul Blakey wrote:
> Register driver callbacks with the nf flow table platform.
> FT add/delete events will create/delete FTE in the CT/CT_NAT tables.
>
> Restoring the CT state on miss will be added in the following patch.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
<snip>
> +static int
> +mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
> +				   char *modact)
> +{
> +	u32 offset = act->mangle.offset, field;
> +
> +	switch (act->mangle.htype) {
> +	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
> +		MLX5_SET(set_action_in, modact, length, 0);
> +		field = offset == offsetof(struct iphdr, saddr) ?
> +			MLX5_ACTION_IN_FIELD_OUT_SIPV4 :
> +			MLX5_ACTION_IN_FIELD_OUT_DIPV4;
Won't this mishandle any mangle of a field other than src/dst addr?

> +		break;
> +
> +	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
> +		MLX5_SET(set_action_in, modact, length, 0);
> +		if (offset == offsetof(struct ipv6hdr, saddr))
> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0;
> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 8)
> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64;
> +		else if (offset == offsetof(struct ipv6hdr, saddr) + 12)
> +			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96;
> +		else if (offset == offsetof(struct ipv6hdr, daddr))
> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0;
> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 8)
> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64;
> +		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
> +			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96;
> +		else
> +			return -EOPNOTSUPP;
> +		break;
> +
> +	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
> +		MLX5_SET(set_action_in, modact, length, 16);
> +		field = offset == offsetof(struct tcphdr, source) ?
> +			MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT :
> +			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
Ditto.

> +		break;
> +
> +	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
> +		MLX5_SET(set_action_in, modact, length, 16);
> +		field = offset == offsetof(struct udphdr, source) ?
> +			MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT :
> +			MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT;
s/TCP/UDP/?

-ed
