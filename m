Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8562927E7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgJSNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:09:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:49354 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgJSNJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:09:28 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUUuh-0007PM-MO; Mon, 19 Oct 2020 15:09:23 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUUuh-0007DK-GW; Mon, 19 Oct 2020 15:09:23 +0200
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
 <d5c14618-089d-5f29-7f10-11d11b0d59ab@gmail.com> <87blh3gu5q.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5365aae3-dd9c-fdde-822b-636cbcd33669@iogearbox.net>
Date:   Mon, 19 Oct 2020 15:09:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87blh3gu5q.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25961/Sun Oct 18 15:56:23 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 9:34 PM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
>> On 10/15/20 9:46 AM, Toke Høiland-Jørgensen wrote:
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index bf5a99d803e4..980cc1363be8 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3677,15 +3677,19 @@ union bpf_attr {
>>>    * 	Return
>>>    * 		The id is returned or 0 in case the id could not be retrieved.
>>>    *
>>> - * long bpf_redirect_neigh(u32 ifindex, u64 flags)
>>> + * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *params, int plen, u64 flags)
>>
>> why not fold ifindex into params? with params and plen this should be
>> extensible later if needed.
> 
> Figured this way would make it easier to run *without* the params (like
> in the existing examples). But don't feel strongly about it, let's see
> what Daniel thinks.

My preference is what Toke has here, this simplifies use by just being able to
call bpf_redirect_neigh(ifindex, NULL, 0, 0) when just single external facing
device is used.

>> A couple of nits below that caught me eye.
> 
> Thanks, will fix; the kernel bot also found a sparse warning, so I guess
> I need to respin anyway (but waiting for Daniel's comments and/or
> instructions on what tree to properly submit this to).

Given API change, lets do bpf. (Will review the rest later today.)
