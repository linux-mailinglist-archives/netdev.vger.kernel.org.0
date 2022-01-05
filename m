Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B67A4855E0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbiAEPbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:31:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:55196 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiAEPa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:30:56 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n58FW-0004R0-ES; Wed, 05 Jan 2022 16:30:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n58FW-000NQQ-2K; Wed, 05 Jan 2022 16:30:50 +0100
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        john.fastabend@gmail.com
References: <20220104082821.22487-1-paulb@nvidia.com>
 <776c2688-72db-4ad6-45e5-73bc08b78615@mojatatu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <72368c25-83c5-565f-0512-ca5d58315685@iogearbox.net>
Date:   Wed, 5 Jan 2022 16:30:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <776c2688-72db-4ad6-45e5-73bc08b78615@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26413/Wed Jan  5 10:23:50 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 3:57 PM, Jamal Hadi Salim wrote:
> On 2022-01-04 03:28, Paul Blakey wrote:
> [..]
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -287,7 +287,9 @@ struct tc_skb_ext {
>>       __u32 chain;
>>       __u16 mru;
>>       __u16 zone;
>> -    bool post_ct;
>> +    bool post_ct:1;
>> +    bool post_ct_snat:1;
>> +    bool post_ct_dnat:1;
>>   };
> 
> is skb_ext intended only for ovs? If yes, why does it belong
> in the core code? Ex: Looking at tcf_classify() which is such
> a core function in the fast path any packet going via tc, it
> is now encumbered with with checking presence of skb_ext.
> I know passing around metadata is a paramount requirement
> for programmability but this is getting messier with speacial
> use cases for ovs and/or offload...

Full ack on the bloat for corner cases like ovs offload, especially
given distros just enable most stuff anyway and therefore no light
fast path as with !CONFIG_NET_TC_SKB_EXT. :(

Could this somehow be hidden behind static key or such if offloads
are not used, so we can shrink it back to just calling into plain
__tcf_classify() for sw-only use cases (like BPF)?
