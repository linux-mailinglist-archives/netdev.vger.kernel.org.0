Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3E6598236
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbiHRL0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiHRL0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:26:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D25E337
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660822006; x=1692358006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h8zzJfgalAMCYll3xl6pLTDJKvBBbfcMiVbxYZwHML4=;
  b=chddtaJ3rWRP7n1uPIkeIUxi9V+CnH48ln7fY+F6epmrtoPlq0yq6I1v
   dwON0bhJUsF/bS6K5mEj6F0YDlonswqy0sNlR9Jttsa3IIGPgv0+yLD0r
   390tgoiPPq4KLspg6UzobHQrXGENQzkwneBIQf9y19taHanZ2G9/pvc+r
   /oyCWXc6YXdRMzlUtS/NIge2dmukEiX/nLXemKBwjrPPhp273ml1BK+CP
   8mFwiR19sQqknmYQZx7kTqh4Yei1+dsuhvCOrrpVfPtQUclns1y+b+qY5
   5ukjG6unI0nB4IHk0CefFZcg/Ul4aKh4SyF6ojwD+G9ucNn+dA9xzAkGw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="273125440"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="273125440"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:26:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668065101"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.122.200]) ([10.213.122.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:26:41 -0700
Message-ID: <6c9777ed-8514-6a34-02c7-b8d5af7018f6@linux.intel.com>
Date:   Thu, 18 Aug 2022 16:56:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     m.chetan.kumar@intel.com, Netdev <netdev@vger.kernel.org>,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
 <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
 <1bc73cf7-38d2-e30e-5d68-4a63a9186fd0@linux.intel.com>
 <6f1b242-bd6f-7517-d9d8-d0e7dbba63d0@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <6f1b242-bd6f-7517-d9d8-d0e7dbba63d0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/2022 4:21 PM, Ilpo Järvinen wrote:
> On Wed, 17 Aug 2022, Kumar, M Chetan wrote:
> 
>> On 8/17/2022 5:40 PM, Ilpo Järvinen wrote:
>>> On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:
>>>
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>
>> <skip>
>>
>>>> @@ -372,7 +435,8 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue
>>>> *queue, struct sk_buff *s
>>>>      	seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
>>>>    	port_conf = port->port_conf;
>>>> -	skb_pull(skb, sizeof(*ccci_h));
>>>> +	if (!port->port_conf->is_early_port)
>>>> +		skb_pull(skb, sizeof(*ccci_h));
>>>
>>> This seems to be the only user for is_early_port, wouldn't be more obvious
>>> to store the header size instead?
>>
>> Early port doesn't carry header.
>> If we change it to header size, skb_pull() operators on zero length.
> 
> Is that a problem?

Looking into the implementation details, feels like it should be OK.
But knowingly the len is zero thought to avoid.

> 
>> OR may need another such flag to bypass it.
> 
> You could use if (header_size) if you don't want to skb_pull with zero len
> so I don't know why another flag would be needed?

Ok. I will replace is_early_port with header_size & use it as check for 
skb_pull().

-- 
Chetan
