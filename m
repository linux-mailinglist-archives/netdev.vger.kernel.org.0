Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E941C6C6C67
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjCWPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCWPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:38:42 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2119.outbound.protection.outlook.com [40.107.101.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5B1CDED
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StHLgUr7STX8TnyGPQIkzborf3DsPkIjcBRpzgSxYGBZsu2rFlEs52Lqi/7WWrE4hfEwGEsnuSO2KSmkslMZChPagokOB2HJpMef4bJjsJ/6bw68m7GF+r81mL2AIu8lSEbZqOBYdIsxQ4pPd4fhrBB1yFUKDpylbxbrxNqaWSa1XdC4qw1aONWTQCuGrlRLaDfZQ1hC/dk0xiHLsIBdUtJ1S85ec1ggxzfKKvhwIxmgPaKUIwUHA4drxvfqoyZpSa/EB14OHV8knGcgaeZOULQ44TqsTtNQxsJoeFDCDxHt34ndb45mI0xa0vIooanugtULBZ73vk1MsdbWrJXbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MspRaBSQ+pnL8M9nZfYpxkzPISAh3fdNPndT5zKrQc=;
 b=iQFSEllj6QR69k+bVBl4C7oswrzkPoW+fyns3ou/Xd+1B79MX7QRTBNmxmThXdLPIBR4dKrq0T21WiXy7GzILJ4/ElvMLuQzYHEw8QyzeJCQygN+zHUT4W0R2zARQ6YT4qFtE/dE+0mVXhxyuq6/A8sHuMgFUhXbW64Qgyd87+NX7USaiLwC5R/AeZU7VmcRiGEz37TgalMJS18LY8bHbzu11yu///henWZZw+lB58DkNDkLoad23pMcH5rZ3GWi78qwkCeSA3wgnOb9mSAs7m1Qa8JC8QmOqmRUTn+IBu2nx3IvOlr1Y9+yIhOW1R+TD5BsTdYwJTbb0lGOwdz3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MspRaBSQ+pnL8M9nZfYpxkzPISAh3fdNPndT5zKrQc=;
 b=PXYpQVtPZdFtzTVA7coqtfZL91a8JXDV/5bQDizjlMfPB2CjUEOd2KD8PQygID6UR3HTlAK3lXYCRTMrY2QoejKZxTRBE8SmWfgIqfQd8g5tgQQMF+YZJa5eviYxMOi0JQqGxays/4HSGRG4YK2bruwhfpaqwgV9pwJOrXpc42o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3864.namprd13.prod.outlook.com (2603:10b6:610:9d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 15:38:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 15:38:36 +0000
Date:   Thu, 23 Mar 2023 16:38:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org
Subject: Re: [PATCH net-next v5] vxlan: try to send a packet normally if
 local bypass fails
Message-ID: <ZBxycrxU93mhgkAT@corigine.com>
References: <20230323042608.17573-1-vladimir@nikishkin.pw>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323042608.17573-1-vladimir@nikishkin.pw>
X-ClientProxiedBy: AM3PR07CA0104.eurprd07.prod.outlook.com
 (2603:10a6:207:7::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3864:EE_
X-MS-Office365-Filtering-Correlation-Id: 0386f821-e70c-4e44-7b45-08db2bb4aaab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2yZUVUXYKNmRK200KaoZCIqVRW7qL+lYBQyDNv92UZYWerSjl1rczx6upOpWU/vQDbYx2LQWocK5hxTE+fTjo4+lXSPr15vJ7koECVnym0fkJYxxQssUwXR9g3SE9b9u4T5FrIzGs+WXnUMLsAcMsrWlZ6I5iKDnCZ8+8fkPkuA6ff4bSyCuyZHKgzAN1dCUxvg3UeXxrJo1lYKbVdCizB+KC+Pkdce1Dr0zvAqPVIMhLRpczSAX9cL9MvJGF1XAfXut3V6KA2k5sfjl+lTpEQrIpmjqfR/x5bqefZ1GHjjl8l17itPAzVWJLcCHN3IDFg8vnb9FqJvQcw9pcgZTTQY9lcF4ba/ZP4Z0LAHOp5XknLitWrLdLo3xpftjA/Ra1eLAkWkK+o2tkyus1+Jmwjuor7ShtG7/ROTowSqLCWVEvyBDdFRNiVevfsrLARjn71yIrK//R8FdZkyJHLtdt/5kUlyeNooUQTtQNfNc2zLY6JYjcs3/3Lcd2jPqraGymqUMUJUoCSgPWcYrme1s0OlKKVvjp5xON+dHcDPuLKW69OzJ4ozdH5+dKcXsEoX6qGHiDH11tVFSXEwbnmCNCh1XlhmHKGjNP6wz1guSFvATzJy86uUt7gb+sfLut7WxJCzmUCp4XSvYlO9xx/zMhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(39840400004)(346002)(451199018)(36756003)(4326008)(86362001)(8676002)(6916009)(66946007)(66476007)(66556008)(8936002)(41300700001)(478600001)(6486002)(316002)(44832011)(2906002)(5660300002)(38100700002)(6512007)(6506007)(6666004)(83380400001)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4sZOFvHVnSE92tcKiv4tQcPU0AhtxCT/XMLIa0L3Gt7DXFuP168SnyeGTl/?=
 =?us-ascii?Q?op7W5ncjOyJ09p4QE/Chse9g1qtnOeUSjvR+2113UUm+4eN9NhjYnC49lXCy?=
 =?us-ascii?Q?ZV/DxOAclcl+CmsIYUl6WW6RV8eespIEPPCxdS2BoIX+U6z3yM7RQuj+kzzM?=
 =?us-ascii?Q?Q99MSK99dFyKHsux0g47pF7Z0uMEoChQ7at3D5UlCicwcgnoMVmtr+MWvkJf?=
 =?us-ascii?Q?v8tJaFyqbImNz7HrMeyQBUASXVSc62kYXFEC/QjQiXQKSJvWSXbkSyBTpimt?=
 =?us-ascii?Q?GwlireZqv8NQ3qV48W8DzBDm77ZltVyzY7WUXW8bm3vhka5HkGryuurzfDjj?=
 =?us-ascii?Q?S4RNzJWoGyLhCIeGOv8I7zFMoFu6r3p5mpR8J6cYSynD2rnewFtUvbMR19om?=
 =?us-ascii?Q?AsDW9xo4IxRvgyEd84ONcZzO8SZhu24sw9KmQZTuVXs52P8A8q/XfN1S2dr+?=
 =?us-ascii?Q?eUzR2exXVAg+fnvbBRMWwpolCpaKw0JQKh4WqvyOz2igPa2cPLdbhjmiKXtd?=
 =?us-ascii?Q?8kky+7rR8/wNHmA9RVxRqEU5eejrZoV3W7qh/DLFWO+RZ9u1jHuoa8ZQ5dUn?=
 =?us-ascii?Q?zf+VGs0HFcMEmON85vb65A9NtXzyKTKqy/huRMI9VoSTRT0n8NSP6Pq86m/m?=
 =?us-ascii?Q?J5nq+vFwvFtu7OV7P1qlqwaCKLhXw2PDCecDvIkpLlOuAQPFBVm+Uy2HdlQa?=
 =?us-ascii?Q?1ZqDnRlrcOXV7a4VMGffRdTHvW5luZ0xNzv6M79MCycp75XzDifPhrX2jZKW?=
 =?us-ascii?Q?Nngd35iyYHhfWzpu15dnbKurfEs81tw0hG72xYrFhADrnGAfYUviEZdMkMwz?=
 =?us-ascii?Q?ZRGBVeXren7WDRrT6qfPQDAIvSa1e82FZHN60KznzZRarJz/Hv1ts8A3gBzD?=
 =?us-ascii?Q?OMDt59llWxzIEJ5mKKGsCiHo1qnOA6lqOtxTNN5eYc69Jadnse5KvB93K+bn?=
 =?us-ascii?Q?JS8smhNo8bak2bJ80k+R68Xveylyo0YUTTXrLRuez1hyTqkQ6KFOefYtOcY5?=
 =?us-ascii?Q?ilyKpGutjKJRd6yxjvuqUvHU+MN/B3PvuDpnUGgD66Sn5cOeJ0DGbF2spMng?=
 =?us-ascii?Q?vzynaGqMRJDUhw08R5xGo1BDj5q+KdMLB76/m2rxr4yBAITglGP4DArQqAM1?=
 =?us-ascii?Q?oPLwg8irnpO+mkbpTkaXDns0LrJeLvUrrP0oAnjZLj9FEf584dbEW2LRlWsb?=
 =?us-ascii?Q?pJRhZsB6nCFC9tfvr37BihWFkGrNVOD5o7euVFdApaCXhOkoCqJy0M9mqry7?=
 =?us-ascii?Q?N1NcfWXL3laWpIGbj04CePhTCP529MRW97Rr4u8J0B92ut4yUmiyYzDltB7E?=
 =?us-ascii?Q?t1m9ub/sYssNLZD8oPtWwEXpMjkp16lUtkHWmkjleIOjL4A2E+ncfiMb3A8n?=
 =?us-ascii?Q?xF0coBc9FbPxRmkLi2e08OG1CLPWkMxWry3LWZNiXPCj+GP0MVhM+5EWdW18?=
 =?us-ascii?Q?omYjTvvI7lSDtmOAHGKkL+mDlKAvFLskti26LmLlbQYDYw+jmWfVBXqny+dd?=
 =?us-ascii?Q?uVs8qrQhWaNc1sMSyhkdFVHOnM2qhz4a9Tp01VutQDdEApqh5O8ZVT9tWzZl?=
 =?us-ascii?Q?47pas01APySTfILD85MZwCEqLWcKOgqOWVNbrIDFyromS3J9bgeL1wOlmfhM?=
 =?us-ascii?Q?V14mx4h2mHyxiZmihLp1sqNTssejgGGEzeCyqR6D8YTxR8vKxsTpxBkKz0oh?=
 =?us-ascii?Q?nPhJJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0386f821-e70c-4e44-7b45-08db2bb4aaab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:38:36.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdvtkJg12nqrrOCGgWTBlg7YJq6auvHwz1Y23wizwjluaFaUYcMkLXuMig5XM7uRRIARPY5NQwce5RSmj1jjobTWXRb/RonFBCXFdW9bghk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3864
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 12:26:08PM +0800, Vladimir Nikishkin wrote:
> In vxlan_core, if an fdb entry is pointing to a local
> address with some port, the system tries to get the packet to
> deliver the packet to the vxlan directly, bypassing the network
> stack.
> 
> This patch makes it still try canonical delivery, if there is no
> linux kernel vxlan listening on this port. This will be useful
> for the cases when there is some userspace daemon expecting
> vxlan packets for post-processing, or some other implementation
> of vxlan.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
>  drivers/net/vxlan/vxlan_core.c     | 34 ++++++++++++++++++++++++------
>  include/net/vxlan.h                |  4 +++-
>  include/uapi/linux/if_link.h       |  1 +
>  tools/include/uapi/linux/if_link.h |  2 ++
>  4 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 561fe1b314f5..cef7a9aec24b 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2341,7 +2341,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
>  				 union vxlan_addr *daddr,
>  				 __be16 dst_port, int dst_ifindex, __be32 vni,
>  				 struct dst_entry *dst,
> -				 u32 rt_flags)
> +				 u32 rt_flags, bool localbypass)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
>  	/* IPv6 rt-flags are checked against RTF_LOCAL, but the value of
> @@ -2355,18 +2355,21 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
>  	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
>  		struct vxlan_dev *dst_vxlan;
>  
> -		dst_release(dst);
>  		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
>  					   daddr->sa.sa_family, dst_port,
>  					   vxlan->cfg.flags);
> -		if (!dst_vxlan) {
> +		if (!dst_vxlan && localbypass) {
> +			dst_release(dst);
>  			dev->stats.tx_errors++;
>  			vxlan_vnifilter_count(vxlan, vni, NULL,
>  					      VXLAN_VNI_STATS_TX_ERRORS, 0);
>  			kfree_skb(skb);
>  
>  			return -ENOENT;
> +		} else if (!dst_vxlan && !localbypass) {
> +			return 0;
>  		}

I'm a bit unsure about the logic around dst_release().
But assuming it is correct, perhaps this is a slightly
nicer way to express the same logic:

		if (!dst_vxlan) {
			if (!localbypass)
				return 0;

			dst_release(dst);
			dev->stats.tx_errors++;
			vxlan_vnifilter_count(vxlan, vni, NULL,
					      VXLAN_VNI_STATS_TX_ERRORS, 0);
			kfree_skb(skb);

			return -ENOENT;
		}

> +		dst_release(dst);
>  		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
>  		return 1;
>  	}
> @@ -2393,6 +2396,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  	int err;
>  	u32 flags = vxlan->cfg.flags;
>  	bool udp_sum = false;
> +	bool localbypass = true;

Is there a need to initialise this here?
Also, it would be good to move towards, rather than away from,
reverse xmas tree - longest line to shortest - for
local variable declarations.

>  	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
>  	__be32 vni = 0;
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -2494,9 +2498,11 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  
>  		if (!info) {
>  			/* Bypass encapsulation if the destination is local */
> +			localbypass =	!(flags & VXLAN_F_LOCALBYPASS);

Extra space after '='.
Also, the scope of localbypass could be reduced to this block.

>  			err = encap_bypass_if_local(skb, dev, vxlan, dst,
>  						    dst_port, ifindex, vni,
> -						    &rt->dst, rt->rt_flags);
> +						    &rt->dst, rt->rt_flags,
> +						    localbypass);
>  			if (err)
>  				goto out_unlock;
>  
> @@ -2568,10 +2574,10 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  
>  		if (!info) {
>  			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
> -
> +			localbypass =  !(flags & VXLAN_F_LOCALBYPASS);

Ditto.

>  			err = encap_bypass_if_local(skb, dev, vxlan, dst,
>  						    dst_port, ifindex, vni,
> -						    ndst, rt6i_flags);
> +						    ndst, rt6i_flags, localbypass);
>  			if (err)
>  				goto out_unlock;
>  		}
> @@ -3202,6 +3208,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
>  	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
>  	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
>  	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
> +	[IFLA_VXLAN_LOCALBYPASS]	= { .type = NLA_U8 },
>  };
>  
>  static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -4011,6 +4018,16 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
>  			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
>  	}
>  
> +	if (data[IFLA_VXLAN_LOCALBYPASS]) {
> +		if (changelink) {
> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_LOCALBYPASS],
> +					    "Cannot change LOCALBYPASS flag");
> +			return -EOPNOTSUPP;
> +		}
> +		if (!nla_get_u8(data[IFLA_VXLAN_LOCALBYPASS]))
> +			conf->flags |= VXLAN_F_LOCALBYPASS;
> +	}

Can vxlan_nl2flag() be used here?

> +
>  	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
>  				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
> @@ -4232,6 +4249,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
> +		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
>  		0;
>  }
>  
> @@ -4308,7 +4326,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
>  		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
>  	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
> -		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
> +		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
> +	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
> +		       !(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))

It seems that the sense of VXLAN_F_LOCALBYPASS is the opposite
of other flags. I think it would be good to reconcile that.

>  		goto nla_put_failure;
>  
>  	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index 20bd7d893e10..0be91ca78d3a 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -328,6 +328,7 @@ struct vxlan_dev {
>  #define VXLAN_F_TTL_INHERIT		0x10000
>  #define VXLAN_F_VNIFILTER               0x20000
>  #define VXLAN_F_MDB			0x40000
> +#define VXLAN_F_LOCALBYPASS		0x80000
>  
>  /* Flags that are used in the receive path. These flags must match in
>   * order for a socket to be shareable
> @@ -348,7 +349,8 @@ struct vxlan_dev {
>  					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
>  					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
>  					 VXLAN_F_COLLECT_METADATA  |	\
> -					 VXLAN_F_VNIFILTER)
> +					 VXLAN_F_VNIFILTER         |    \
> +					 VXLAN_F_LOCALBYPASS)
>  
>  struct net_device *vxlan_dev_create(struct net *net, const char *name,
>  				    u8 name_assign_type, struct vxlan_config *conf);
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 57ceb788250f..4e3a3d295056 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -826,6 +826,7 @@ enum {
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
>  	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index 901d98b865a1..3d9a1fd6f7e7 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -747,6 +747,8 @@ enum {
>  	IFLA_VXLAN_GPE,
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
> +	IFLA_VXLAN_VNIFILTER,
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> -- 
> 2.35.7
> 
> --
> Fastmail.
> 
