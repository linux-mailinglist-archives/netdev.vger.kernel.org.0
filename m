Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C3243FDA
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHMUfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:35:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:38620 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMUfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:35:13 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k6JwK-0002vf-7Z; Thu, 13 Aug 2020 22:35:08 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k6JwK-000RbZ-1X; Thu, 13 Aug 2020 22:35:08 +0200
Subject: Re: [PATCH bpf] libbpf: Prevent overriding errno when logging errors
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20200813142905.160381-1-toke@redhat.com>
 <CAEf4BzZ6yM_QWu0x4b51NAVzN6-EAoQN4ff4BNiof5CJ5ukhpg@mail.gmail.com>
 <87d03u1fyj.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <868b8e78-f0ae-8e59-1816-92051acba1f5@iogearbox.net>
Date:   Thu, 13 Aug 2020 22:35:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87d03u1fyj.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25901/Thu Aug 13 09:01:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/20 9:52 PM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> On Thu, Aug 13, 2020 at 7:29 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>
>>> Turns out there were a few more instances where libbpf didn't save the
>>> errno before writing an error message, causing errno to be overridden by
>>> the printf() return and the error disappearing if logging is enabled.
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>
>>>   tools/lib/bpf/libbpf.c | 12 +++++++-----
>>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>> index 0a06124f7999..fd256440e233 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -3478,10 +3478,11 @@ bpf_object__probe_global_data(struct bpf_object *obj)
>>>
>>>          map = bpf_create_map_xattr(&map_attr);
>>>          if (map < 0) {
>>> -               cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>>> +               ret = -errno;
>>> +               cp = libbpf_strerror_r(-ret, errmsg, sizeof(errmsg));
>>
>> fyi, libbpf_strerror_r() is smart enough to work with both negative
>> and positive error numbers (it basically takes abs(err)), so no need
>> to ensure it's positive here and below.
> 
> Noted. Although that also means it doesn't hurt either, I suppose; so
> not going to bother respinning this unless someone insists :)

Fixed up while applying, thanks!
