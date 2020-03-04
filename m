Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2083B179ACE
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgCDVWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:22:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:15331 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDVWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 16:22:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 13:22:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244067159"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 13:22:47 -0800
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
 <20200304075926.GH4264@unicorn.suse.cz>
 <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2bc1c2ee-f777-1e46-5a7d-7b4b755e1d79@intel.com>
Date:   Wed, 4 Mar 2020 13:22:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/2020 10:00 AM, Jakub Kicinski wrote:
> On Wed, 4 Mar 2020 08:59:26 +0100 Michal Kubecek wrote:
>> Just an idea: perhaps we could use the fact that struct ethtool_coalesce
>> is de facto an array so that this block could be replaced by a loop like
>>
>> 	u32 supported_types = dev->ethtool_ops->coalesce_types;
>> 	const u32 *values = &coalesce->rx_coalesce_usecs;
>>
>> 	for (i = 0; i < __ETHTOOL_COALESCE_COUNT; i++)
>> 		if (values[i] && !(supported_types & BIT(i)))
>> 			return false;
>>
>> and to be sure, BUILD_BUG_ON() or static_assert() check that the offset
>> of ->rate_sample_interval matches ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL.
> 
> I kind of prefer the greppability over the saved 40 lines :(
> But I'm happy to change if we get more votes for the more concise
> version. Or perhaps the Intel version with the warnings printed.
> 

We could go the looped route, but I like being able to search the code
for references. Seems like the main point of the loop would be to
simplify catching new added parameters in the future.

I don't really have a strong preference.

Thanks,
Jake
