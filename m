Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606E922FB5D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgG0V15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:27:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:47175 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgG0V15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:27:57 -0400
IronPort-SDR: KlTBkFNhmAvbDHNe+GoXZND+TgKvRXnTU3dRrNi7HFaTBoiN5mrMIy1HETM/Xu1npINnamEu+5
 F+JenIJfBmyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="139150811"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="139150811"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 14:27:57 -0700
IronPort-SDR: 4ob1N6QSG/FVcHzP4eDMclNXfSPWW+mcXcg4MgQ3geFiuuy7qthWO1fsuhi8ZA03+/PsgnlR0z
 qNrFKBh+RTKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="303607892"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 14:27:56 -0700
Subject: Re: Broken link partner advertised reporting in ethtool
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>, netdev@vger.kernel.org
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
 <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <035ed67a-9da1-7023-853f-d5e62bb3f41b@intel.com>
Date:   Mon, 27 Jul 2020 14:27:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 2:08 PM, Michal Kubecek wrote:
> On Mon, Jul 27, 2020 at 11:01:41PM +0200, Andrew Lunn wrote:
>>>   - the exact command you ran (including arguments)
>>>   - expected output (or at least the relevant part)
>>>   - actual output (or at least the relevant part)
>>>   - output with dump of netlink messages, you can get it by enabling
>>>     debugging flags, e.g. "ethtool --debug 0x12 eth0"
>>  
>> Hi Michal
>>
>> See if this helps.
>>
>> This is a Marvel Ethernet switch port using an Marvell PHY.
> 
> Thank you. I think I can see the problem. Can you try the patch below?
> 
> Michal
> 

I think the patch below fixes part of the issue, but isn't completely
correct, because NOMASK bitmaps can be sent in compact form as well.

Also, we'll need something to check the NOMASK flag and do the correct
thing in all of the dump functions.

Thanks,
Jake

> 
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 35ba2f5dd6d5..60523ad6edf5 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -280,6 +280,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  	const struct nlattr *bit;
>  	bool first = true;
>  	int prev = -2;
> +	bool nomask;
>  	int ret;
>  
>  	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
> @@ -338,6 +339,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  		goto after;
>  	}
>  
> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
>  	printf("\t%s", before);
>  	mnl_attr_for_each_nested(bit, bits) {
>  		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
> @@ -354,7 +356,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
>  		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
>  			goto err;
> -		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
> +		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
>  			continue;
>  
>  		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
> 
