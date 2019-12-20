Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEB7128077
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLTQRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:17:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:24416 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfLTQRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 11:17:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 08:17:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,336,1571727600"; 
   d="scan'208";a="248733207"
Received: from mkavai-mobl.amr.corp.intel.com ([10.251.29.187])
  by fmsmga002.fm.intel.com with ESMTP; 20 Dec 2019 08:17:44 -0800
Date:   Fri, 20 Dec 2019 08:17:44 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mkavai-mobl.amr.corp.intel.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 07/11] tcp: coalesce/collapse must respect
 MPTCP extensions
In-Reply-To: <90c0c531-45e4-4937-552a-898aff733756@gmail.com>
Message-ID: <alpine.OSX.2.21.1912200741560.52347@mkavai-mobl.amr.corp.intel.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com> <20191219223434.19722-8-mathew.j.martineau@linux.intel.com> <90c0c531-45e4-4937-552a-898aff733756@gmail.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019, Eric Dumazet wrote:

>
>
> On 12/19/19 2:34 PM, Mat Martineau wrote:
>> Coalesce and collapse of packets carrying MPTCP extensions is allowed
>> when the newer packet has no extension or the extensions carried by both
>> packets are equal.
>>
>> This allows merging of TSO packet trains and even cross-TSO packets, and
>> does not require any additional action when moving data into existing
>> SKBs.
>>
>> v3 -> v4:
>>  - allow collapsing, under mptcp_skb_can_collapse() constraint
>>
>> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> ---
>>  include/net/mptcp.h   | 54 +++++++++++++++++++++++++++++++++++++++++++
>>  include/net/tcp.h     |  8 +++++++
>>  net/ipv4/tcp_input.c  | 11 ++++++---
>>  net/ipv4/tcp_output.c |  2 +-
>>  4 files changed, 71 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
>> index f9f668ac4339..8e27e33861ab 100644
>> --- a/include/net/mptcp.h
>> +++ b/include/net/mptcp.h
>> @@ -8,6 +8,7 @@
>>  #ifndef __NET_MPTCP_H
>>  #define __NET_MPTCP_H
>>
>> +#include <linux/skbuff.h>
>>  #include <linux/types.h>
>>
>>  /* MPTCP sk_buff extension data */
>> @@ -24,4 +25,57 @@ struct mptcp_ext {
>>  			__unused:2;
>>  };
>>
>> +#ifdef CONFIG_MPTCP
>> +
>> +/* move the skb extension owership, with the assumption that 'to' is
>> + * newly allocated
>> + */
>> +static inline void mptcp_skb_ext_move(struct sk_buff *to,
>> +				      struct sk_buff *from)
>> +{
>> +	if (!skb_ext_exist(from, SKB_EXT_MPTCP))
>> +		return;
>> +
>> +	if (WARN_ON_ONCE(to->active_extensions))
>> +		skb_ext_put(to);
>> +
>> +	to->active_extensions = from->active_extensions;
>> +	to->extensions = from->extensions;
>> +	from->active_extensions = 0;
>> +}
>> +
>> +static inline bool mptcp_ext_matches(const struct mptcp_ext *to_ext,
>> +				     const struct mptcp_ext *from_ext)
>> +{
>> +	return !from_ext ||
>> +	       (to_ext && from_ext &&
>> +	        !memcmp(from_ext, to_ext, sizeof(struct mptcp_ext)));
>
> There is a hole at the end of struct mptcp_ext
>
> How is it properly cleared/initialized so that the memcmp() wont
> spuriously fail ?
>

Hi Eric,

Yes, that's important - we have code in part 2 that initializes the full 
sizeof(struct mptcp_ext) for exactly this reason:

         mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
         if (!mpext)
                 return;

         memset(mpext, 0, sizeof(*mpext));

(reference: 
https://github.com/multipath-tcp/mptcp_net-next/commit/0796b4a779d0c2a87e552fdec801cb2596c23a1f 
)

Thank you very much for your review!

--
Mat Martineau
Intel
