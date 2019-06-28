Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7D595CD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF1IMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:12:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:45182 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfF1IMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:12:12 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hglzK-0004Hi-Kd; Fri, 28 Jun 2019 10:12:06 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hglzK-0001lT-9h; Fri, 28 Jun 2019 10:12:06 +0200
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup
 in eBPF helper
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626136.5209.14349225282974871197.stgit@alrua-x1>
 <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net> <874l4a9o2b.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3f76a90-5cf4-4437-e3e1-75fda1248e53@iogearbox.net>
Date:   Fri, 28 Jun 2019 10:12:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <874l4a9o2b.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28/2019 09:17 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>
>>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>>> indication of whether it can successfully redirect to the map index it was
>>> given. Instead, BPF programs have to track this themselves, leading to
>>> programs using duplicate maps to track which entries are populated in the
>>> devmap.
>>>
>>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>>> helper, which makes it possible to return failure to the eBPF program. The
>>> lower bits of the flags argument is used as the return code, which means
>>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>>>
>>> With this, a BPF program can check the return code from the helper call and
>>> react by, for instance, substituting a different redirect. This works for
>>> any type of map used for redirect.
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> Overall series looks good to me. Just very small things inline here & in the
>> other two patches:
>>
>> [...]
>>> @@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>>  {
>>>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>>  
>>> -	if (unlikely(flags))
>>> +	/* Lower bits of the flags are used as return code on lookup failure */
>>> +	if (unlikely(flags > XDP_TX))
>>>  		return XDP_ABORTED;
>>>  
>>> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
>>> +	if (unlikely(!ri->item)) {
>>> +		WRITE_ONCE(ri->map, NULL);
>>
>> This WRITE_ONCE() is not needed. We never set it before at this point.
> 
> You mean the WRITE_ONCE() wrapper is not needed, or the set-to-NULL is
> not needed? The reason I added it is in case an eBPF program calls the
> helper twice before returning, where the first lookup succeeds but the
> second fails; in that case we want to clear the ->map pointer, no?

Yeah I meant the set-to-NULL. So if first call succeeds, and the second one
fails, then the expected semantics wrt the first call are as if the program
would have called bpf_xdp_redirect() only?

Looking at the code again, if we set ri->item to NULL, then we /must/ also
set ri->map to NULL. I guess there are two options: i) leave as is, ii) keep
the __xdp_map_lookup_elem() result in a temp var, if it's NULL return flags,
otherwise only /then/ update ri->item, so that semantics are similar to the
invalid flags check earlier. I guess fine either way, in case of i) there
should probably be a comment since it's less obvious.

Thanks,
Daniel
