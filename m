Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD4E3390F7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhCLPPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:15:50 -0500
Received: from www62.your-server.de ([213.133.104.62]:50942 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbhCLPPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:15:30 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lKjVg-000Ceb-KZ; Fri, 12 Mar 2021 16:15:28 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lKjVg-000UQ0-Dx; Fri, 12 Mar 2021 16:15:28 +0100
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
 <20210312015617.GZ2900@Leo-laptop-t470s>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0b5c810b-5eec-c7b0-15fc-81c989494202@iogearbox.net>
Date:   Fri, 12 Mar 2021 16:15:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210312015617.GZ2900@Leo-laptop-t470s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26106/Fri Mar 12 13:03:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 2:56 AM, Hangbin Liu wrote:
> Hi David,
> 
> May I ask what's the status of this patch? From patchwork[1] the state is
> accepted. But I can't find the fix on net or net-next.

I think there may have been two confusions, i) that $subject says that this goes
via net tree instead of bpf tree, which might have caused auto-delegation to move
this into 'netdev' patchwork reviewer bucket, and ii) the kernel patchwork bot then
had a mismatch as you noticed when it checked net-next after tree merge and replied
to the wrong patch of yours which then placed this one into 'accepted' state. I just
delegated it to bpf and placed it back under review..

> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210309032214.2112438-1-liuhangbin@gmail.com/
> 
> Thanks
> Hangbin

> On Tue, Mar 09, 2021 at 11:22:14AM +0800, Hangbin Liu wrote:
>> When fixing the bpf test_tunnel.sh genve failure. I only fixed
>> the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
>> fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
>> there is no geneve opt"), when there is no tunnel option and
>> bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
>> packets and break all geneve rx traffic. Just set opt_class to 0 and
>> keep returning TC_ACT_OK at the end.
>>
>> Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>   tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
>> index 9afe947cfae9..ba6eadfec565 100644
>> --- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
>> +++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
>> @@ -508,10 +508,8 @@ int _ip6geneve_get_tunnel(struct __sk_buff *skb)
>>   	}
>>   
>>   	ret = bpf_skb_get_tunnel_opt(skb, &gopt, sizeof(gopt));
>> -	if (ret < 0) {
>> -		ERROR(ret);
>> -		return TC_ACT_SHOT;
>> -	}
>> +	if (ret < 0)
>> +		gopt.opt_class = 0;
>>   
>>   	bpf_trace_printk(fmt, sizeof(fmt),
>>   			key.tunnel_id, key.remote_ipv4, gopt.opt_class);
>> -- 
>> 2.26.2
>>

