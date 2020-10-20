Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8895293F31
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407644AbgJTPEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:04:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:56692 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbgJTPEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:04:50 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUtBt-0001LI-3n; Tue, 20 Oct 2020 17:04:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUtBs-000HJs-UX; Tue, 20 Oct 2020 17:04:44 +0200
Subject: Re: [PATCH bpf v2 2/3] bpf_fib_lookup: optionally skip neighbour
 lookup
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106331.15822.2945713836148003890.stgit@toke.dk>
 <20784134-7f4c-c263-5d62-facbb2adb8a8@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9506a687-64a7-8cf4-008f-c4a10f867c01@iogearbox.net>
Date:   Tue, 20 Oct 2020 17:04:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20784134-7f4c-c263-5d62-facbb2adb8a8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25963/Tue Oct 20 16:00:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 3:49 PM, David Ahern wrote:
> On 10/20/20 4:51 AM, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>> that the BPF program will deal with this condition, either by passing the
>> packet up the stack, or by using bpf_redirect_neigh().
>>
>> The neighbour lookup is done via a hash table (through ___neigh_lookup_noref()),
>> which incurs some overhead. If the caller knows this is likely to fail
>> anyway, it may want to skip that and go unconditionally to
>> bpf_redirect_neigh(). For this use case, add a flag to bpf_fib_lookup()
>> that will make it skip the neighbour lookup and instead always return
>> BPF_FIB_LKUP_RET_NO_NEIGH (but still populate the gateway and target
>> ifindex).
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>   include/uapi/linux/bpf.h       |   10 ++++++----
>>   net/core/filter.c              |   16 ++++++++++++++--
>>   tools/include/uapi/linux/bpf.h |   10 ++++++----
>>   3 files changed, 26 insertions(+), 10 deletions(-)
> 
> Nack. Please don't.
> 
> As I mentioned in my reply to Daniel, I would prefer such logic be
> pushed to the bpf programs. There is no reason for rare run time events
> to warrant a new flag and new check in the existing FIB helpers. The bpf
> programs can take the hit of the extra lookup.

Fair enough, lets push it to progs then.
