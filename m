Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB7522AC03
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgGWKAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 06:00:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728224AbgGWKAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 06:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595498398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O/LqmY9ryCOwjYYuheS4VUlb9xhQlPFp+vHDmf9KXGo=;
        b=bkI1jEzShasJXwAMjsG2GkkDux2ZNB9wa63UbnDkR77OZWNm2E1YFSLRv6Il8jDy+JxK/5
        RQNQvdcXnc+AA/Pl+l8oyoULLN4vSTHDMLIQzZaXB/wWzczywEiZ25s0KqtjmM6h2hK/U2
        PYPl5LaboXVUbEJFNmN40DLMrET4Zkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-KnszgqgHN-yD3ML3VtpJ8g-1; Thu, 23 Jul 2020 05:59:56 -0400
X-MC-Unique: KnszgqgHN-yD3ML3VtpJ8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA2518C63C0;
        Thu, 23 Jul 2020 09:59:54 +0000 (UTC)
Received: from [10.36.112.205] (ovpn-112-205.ams2.redhat.com [10.36.112.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE2E5D9D3;
        Thu, 23 Jul 2020 09:59:53 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Florian Westphal" <fw@strlen.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 2/2] net: openvswitch: make masks cache size
 configurable
Date:   Thu, 23 Jul 2020 11:59:51 +0200
Message-ID: <F147B9A7-3CD7-4F62-9BF4-389FD0FC36BC@redhat.com>
In-Reply-To: <20200722192252.GC23458@breakpoint.cc>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
 <159540647223.619787.13052866492035799125.stgit@ebuild>
 <20200722192252.GC23458@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jul 2020, at 21:22, Florian Westphal wrote:

> Eelco Chaudron <echaudro@redhat.com> wrote:
>> This patch makes the masks cache size configurable, or with
>> a size of 0, disable it.
>>
>> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  include/uapi/linux/openvswitch.h |    1
>>  net/openvswitch/datapath.c       |   11 +++++
>>  net/openvswitch/flow_table.c     |   86 
>> ++++++++++++++++++++++++++++++++++----
>>  net/openvswitch/flow_table.h     |   10 ++++
>>  4 files changed, 98 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/uapi/linux/openvswitch.h 
>> b/include/uapi/linux/openvswitch.h
>> index 7cb76e5ca7cf..8300cc29dec8 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -86,6 +86,7 @@ enum ovs_datapath_attr {
>>  	OVS_DP_ATTR_MEGAFLOW_STATS,	/* struct ovs_dp_megaflow_stats */
>>  	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
>>  	OVS_DP_ATTR_PAD,
>> +	OVS_DP_ATTR_MASKS_CACHE_SIZE,
>
> This new attr should probably get an entry in
> datapath.c datapath_policy[].

Yes, I should have, will fix in v2.

>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -1535,6 +1535,10 @@ static int ovs_dp_cmd_fill_info(struct 
>> datapath *dp, struct sk_buff *skb,
>>  	if (nla_put_u32(skb, OVS_DP_ATTR_USER_FEATURES, dp->user_features))
>>  		goto nla_put_failure;
>>
>> +	if (nla_put_u32(skb, OVS_DP_ATTR_MASKS_CACHE_SIZE,
>> +			ovs_flow_tbl_masks_cache_size(&dp->table)))
>> +		goto nla_put_failure;
>> +
>>  	genlmsg_end(skb, ovs_header);
>>  	return 0;
>
>
> ovs_dp_cmd_msg_size() should add another nla_total_size(sizeof(u32))
> to make sure there is enough space.

Same as above

>> +	if (a[OVS_DP_ATTR_MASKS_CACHE_SIZE]) {
>> +		u32 cache_size;
>> +
>> +		cache_size = nla_get_u32(a[OVS_DP_ATTR_MASKS_CACHE_SIZE]);
>> +		ovs_flow_tbl_masks_cache_resize(&dp->table, cache_size);
>> +	}
>
> I see a 0 cache size is legal (turns it off) and that the allocation
> path has a few sanity checks as well.
>
> Would it make sense to add min/max policy to datapath_policy[] for 
> this
> as well?

Yes I could add the following:

@@ -1906,7 +1906,8 @@ static const struct nla_policy 
datapath_policy[OVS_DP_ATTR_MAX + 1] = {
         [OVS_DP_ATTR_NAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ 
- 1 },
         [OVS_DP_ATTR_UPCALL_PID] = { .type = NLA_U32 },
         [OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
+       [OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
+               PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
  };

Let me know your thoughts

