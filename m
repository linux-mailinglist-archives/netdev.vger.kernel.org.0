Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F308217A9D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgGGVmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:42:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:58858 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:42:11 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsvLi-0001Rq-2X; Tue, 07 Jul 2020 23:41:58 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsvLh-000N9E-QL; Tue, 07 Jul 2020 23:41:57 +0200
Subject: Re: [PATCH bpf-next v4 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE
 hook
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <20200706230128.4073544-1-sdf@google.com>
 <20200706230128.4073544-2-sdf@google.com>
 <CAEf4Bzb=vHUC2dgxNEE2fvCZrk9+crmZAp+6kb5U1wLF293cHQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <073ac0af-5de7-0a61-4e11-e4ca292f6456@iogearbox.net>
Date:   Tue, 7 Jul 2020 23:41:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb=vHUC2dgxNEE2fvCZrk9+crmZAp+6kb5U1wLF293cHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25866/Tue Jul  7 15:47:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 1:42 AM, Andrii Nakryiko wrote:
> On Mon, Jul 6, 2020 at 4:02 PM Stanislav Fomichev <sdf@google.com> wrote:
>>
>> Implement BPF_CGROUP_INET_SOCK_RELEASE hook that triggers
>> on inet socket release. It triggers only for userspace
>> sockets, the same semantics as existing BPF_CGROUP_INET_SOCK_CREATE.
>>
>> The only questionable part here is the sock->sk check
>> in the inet_release. Looking at the places where we
>> do 'sock->sk = NULL', I don't understand how it can race
>> with inet_release and why the check is there (it's been
>> there since the initial git import). Otherwise, the
>> change itself is pretty simple, we add a BPF hook
>> to the inet_release and avoid calling it for kernel
>> sockets.
>>
>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> ---
>>   include/linux/bpf-cgroup.h | 4 ++++
>>   include/uapi/linux/bpf.h   | 1 +
>>   kernel/bpf/syscall.c       | 3 +++
>>   net/core/filter.c          | 1 +
>>   net/ipv4/af_inet.c         | 3 +++
>>   5 files changed, 12 insertions(+)
>>
> 
> Looks good overall, but I have no idea about sock->sk NULL case.

+1, looks good & very useful hook. For the sock->sk NULL case here's a related
discussion on why it's needed [0].

   [0] https://lore.kernel.org/netdev/20190221221356.173485-1-ebiggers@kernel.org/

> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> index c66c545e161a..2c6f26670acc 100644
>> --- a/include/linux/bpf-cgroup.h
>> +++ b/include/linux/bpf-cgroup.h
> 
> [...]
> 

