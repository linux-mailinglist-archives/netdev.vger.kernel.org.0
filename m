Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE6122D05E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 23:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXVO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 17:14:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:2641 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgGXVO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 17:14:26 -0400
IronPort-SDR: 0djh0dCjjpd5F+KtjQWdBV2uk3/gIMmff24yuAQk/zhTrEtLwByv7CsQYkALQNpkudtguEW737
 m2cNwOIMKYaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="215365018"
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="215365018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 14:14:26 -0700
IronPort-SDR: sATOhYz40y+cGfnFT7Xq9uZ7pU51qOr3ByTfyP0CDW+NLGVwYqP0LgB5G6AQIpMkH1P0K31VB3
 MXJNmRB4VsVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="289108474"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.52.44]) ([10.254.52.44])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2020 14:14:25 -0700
Subject: Re: [PATCH] netlink: add buffer boundary checking
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mark Salyzyn <salyzyn@android.com>,
        linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Thomas Graf <tgraf@suug.ch>
References: <20200723182136.2550163-1-salyzyn@android.com>
 <09cd1829-8e41-bef5-ba5e-1c446c166778@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8bd7695c-0012-83e9-8a5a-94a40d91d6f6@intel.com>
Date:   Fri, 24 Jul 2020 14:14:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <09cd1829-8e41-bef5-ba5e-1c446c166778@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2020 12:35 PM, Eric Dumazet wrote:
> On 7/23/20 11:21 AM, Mark Salyzyn wrote:
>> Many of the nla_get_* inlines fail to check attribute's length before
>> copying the content resulting in possible out-of-boundary accesses.
>> Adjust the inlines to perform nla_len checking, for the most part
>> using the nla_memcpy function to faciliate since these are not
>> necessarily performance critical and do not need a likely fast path.
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kernel-team@android.com
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Thomas Graf <tgraf@suug.ch>
>> Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
>> ---
>>  include/net/netlink.h | 66 +++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 54 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/net/netlink.h b/include/net/netlink.h
>> index c0411f14fb53..11c0f153be7c 100644
>> --- a/include/net/netlink.h
>> +++ b/include/net/netlink.h
>> @@ -1538,7 +1538,11 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
>>   */
>>  static inline u32 nla_get_u32(const struct nlattr *nla)
>>  {
>> -	return *(u32 *) nla_data(nla);
>> +	u32 tmp;
>> +
>> +	nla_memcpy(&tmp, nla, sizeof(tmp));
>> +
>> +	return tmp;
> 
> I believe this will hide bugs, that syzbot was able to catch.
> 
> Instead, you could perhaps introduce a CONFIG_DEBUG_NETLINK option,
> and add a WARN_ON_ONCE(nla_len(nla) < sizeof(u32)) so that we can detect bugs in callers.
> 
> 

I also think this is a better approach.
