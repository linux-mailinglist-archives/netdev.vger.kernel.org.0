Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC9287D9D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgJHVE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730905AbgJHVE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602191097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqB3iHz5/cM/cl4ywBFbnzeZWHwKJOe5Pql/dzy6gPc=;
        b=EVnLaz+n0/coVhMGqFN57fmCGzrv5slW+r8UeneLwbRefThpcoc40mmVTraS+9iwBwsv/i
        /zmYoFyo4fP+evQIirAzP4FjmcvXYXvbrJtclyd0oAvhJ+thuY2JDnyiwUTieXjglLoR2b
        RoOv8crqK2U285tuhAPQ4CVE4vVlnkY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-Fs4TD851O0mht1W8wc0JsQ-1; Thu, 08 Oct 2020 17:04:54 -0400
X-MC-Unique: Fs4TD851O0mht1W8wc0JsQ-1
Received: by mail-wr1-f69.google.com with SMTP id b11so536889wrm.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UqB3iHz5/cM/cl4ywBFbnzeZWHwKJOe5Pql/dzy6gPc=;
        b=VTJDS0opxPm9jghrifDMEN6GoSDazHcGgXNZrepvU1BkN5P4QDwfZ326uGDvtfNNC2
         TXGFUYXwYCfVy7k57Z87btQcdsIGBMDWzM4ZyoFyi0LFvi3o4dhuneUwxe7+aLSfkdJx
         PyTsB41Ow/idZLtAjm6zXZtgQtpxccHol5CKur+HpBTWkYzdgfLPEJF6hHSu1l2hYwFo
         wudhscYPVSjPm+L/Gr+BN/53jQEWTkdydQfFQE8YMIZ1TUHF4dDr2Nlh7sWqmsUtalWw
         UuHymIkZxmDKY/Nwbs+GbcNh3NrcPhynZX7splZs0QEhtdhZeluydiwQzkjcMsXRWqPY
         raRg==
X-Gm-Message-State: AOAM530KxPn0HWRnbVmru+9QrgxkhoLwACkPIzFXA6TvdvRot6NsaY2n
        mWvNZm68X11FspYoC0V2UyUCoPGyqDMPUDVf3iDWW7j8A5WbTEuhuIZ5wJu3g+ZFtoDlLDMGXn3
        Yw9xwiahNMmfHWG8b
X-Received: by 2002:a5d:558e:: with SMTP id i14mr11992327wrv.40.1602191093195;
        Thu, 08 Oct 2020 14:04:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwad84X0Kl74b51WU6538iqq8F7ZrvmioS8u9IhfGJlG5f+WTZFazhnQGbQPqa5DPO1NMKxqg==
X-Received: by 2002:a5d:558e:: with SMTP id i14mr11992290wrv.40.1602191092605;
        Thu, 08 Oct 2020 14:04:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z6sm3745711wrs.2.2020.10.08.14.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 14:04:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 850411837DC; Thu,  8 Oct 2020 23:04:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next] bpf_fib_lookup: return target ifindex even if
 neighbour lookup fails
In-Reply-To: <5d900a50-31f6-c311-8200-424369872092@iogearbox.net>
References: <20201008145314.116800-1-toke@redhat.com>
 <bf190e76-b178-d915-8d0d-811905d38fd2@iogearbox.net>
 <87a6wwe8nu.fsf@toke.dk>
 <5d900a50-31f6-c311-8200-424369872092@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Oct 2020 23:04:51 +0200
Message-ID: <877ds0e8ek.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

n> On 10/8/20 10:59 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 10/8/20 4:53 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> The bpf_fib_lookup() helper performs a neighbour lookup for the destin=
ation
>>>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectati=
on
>>>> that the BPF program will pass the packet up the stack in this case.
>>>> However, with the addition of bpf_redirect_neigh() that can be used in=
stead
>>>> to perform the neighbour lookup.
>>>>
>>>> However, for that we still need the target ifindex, and since
>>>> bpf_fib_lookup() already has that at the time it performs the neighbour
>>>> lookup, there is really no reason why it can't just return it in any c=
ase.
>>>> With this fix, a BPF program can do the following to perform a redirect
>>>> based on the routing table that will succeed even if there is no neigh=
bour
>>>> entry:
>>>>
>>>> 	ret =3D bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
>>>> 	if (ret =3D=3D BPF_FIB_LKUP_RET_SUCCESS) {
>>>> 		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
>>>> 		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
>>>>
>>>> 		return bpf_redirect(fib_params.ifindex, 0);
>>>> 	} else if (ret =3D=3D BPF_FIB_LKUP_RET_NO_NEIGH) {
>>>> 		return bpf_redirect_neigh(fib_params.ifindex, 0);
>>>> 	}
>>>>
>>>> Cc: David Ahern <dsahern@gmail.com>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>
>>> ACK, this looks super useful! Could you also add a new flag which would=
 skip
>>> neighbor lookup in the helper while at it (follow-up would be totally f=
ine from
>>> my pov since both are independent from each other)?
>>=20
>> Sure, can do. Thought about adding it straight away, but wasn't sure if
>> it would be useful, since the fib lookup has already done quite a lot of
>> work by then. But if you think it'd be useful, I can certainly add it.
>> I'll look at this tomorrow; if you merge this before then I'll do it as
>> a follow-up, and if not I'll respin with it added. OK? :)
>
> Sounds good to me; merge depending on David's final verdict in the other =
thread
> wrt commit description.

Yup, figured that'd be the case - great :)

-Toke

