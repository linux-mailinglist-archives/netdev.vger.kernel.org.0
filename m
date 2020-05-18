Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819221D737B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgERJJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:09:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgERJJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589792945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3J2pCTUPD3tt4DsSK1qBiZ+rkPmSwGQCaRcnti/iTrc=;
        b=UKzl69ADOhtqvxKz53qgaYeGgu3sO5nM8JtusM0YAXfWYkM76fYQQXE3ZOiMkbAnyAQGAW
        sD3jkGjOpDYtDpVTXzQoB6KXMtuI4Hh+sUonxzQL0qXY5NybF91c4TPIQa+kICQQdxt9Gl
        7+4qtHrXr3+BUe0sGsY4E8NwcS9hdVY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-AUF4rsY_PC2utQxc9EwHfg-1; Mon, 18 May 2020 05:09:04 -0400
X-MC-Unique: AUF4rsY_PC2utQxc9EwHfg-1
Received: by mail-lj1-f199.google.com with SMTP id g26so473791ljn.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 02:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3J2pCTUPD3tt4DsSK1qBiZ+rkPmSwGQCaRcnti/iTrc=;
        b=N5y7BsUGuIgxnWmvGN0vFy1vvluj7yqxjjXm1PNpt5voYvRV36ej1qlN48gmklBECj
         uHSu6Gwc/D8pN4RbBbbqLoWv2iu9bhxxSH89qIZU/f0lOdSGXiM9O3lMIrrR48oIJd0M
         gDEIXAjNtSxdMZSeJsYdGfKkLGyJG4RUeNP/7/hAgc5L/aFBhECNK+JjaPS9M+OXHosa
         dwausEq4y+h8Ppp5mJeLPpQWlOWPR2Vj6Fc4tuMw6WD6ZR2bG/9IadAE8YTlI8GQaYji
         hs1qRH+o0IWDUFsbPvm1sVv5j9bDDaykiquIN5wv2scpbADtb/3sRJ1isZAs/mjRdKPn
         lEMA==
X-Gm-Message-State: AOAM531uqbCD1/y/4xhUUWKDiOKcDR09RDAbaXHjeWTYBcQ/okM2HPBO
        J1sz3OzeiCZZTbM+ELgT4NkZ6oMEOdClvODvVgR/kONW11zUYjoYJkQ/7yrL24dsdsW2S9L42rC
        mkOjMmPsSbB4XNVEp
X-Received: by 2002:a19:6e48:: with SMTP id q8mr10991942lfk.185.1589792942417;
        Mon, 18 May 2020 02:09:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdcwmLPiKyolljenINhGVrBQnrVPEZoQE0Cn6Q19gzwg+5oz1K/AwezuteRw8QmBD9RI7UQg==
X-Received: by 2002:a19:6e48:: with SMTP id q8mr10991923lfk.185.1589792942134;
        Mon, 18 May 2020 02:09:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q125sm5354759ljb.34.2020.05.18.02.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 02:09:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D8F6B181510; Mon, 18 May 2020 11:08:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
In-Reply-To: <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
References: <20200513014607.40418-1-dsahern@kernel.org> <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 May 2020 11:08:59 +0200
Message-ID: <87lflppq38.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/13/20 4:43 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> I don't like this. I makes the egress hook asymmetrical with the ingress
>> hook (ingress hook sees all traffic, egress only some of it). If the
>> performance hit of disabling GSO is the concern, maybe it's better to
>> wait until we figure out how to deal with that (presumably by
>> multi-buffer XDP)?
>
> XDP is for accelerated networking. Disabling a h/w offload feature to
> use a s/w feature is just wrong. But it is more than just disabling GSO,
> and multi-buffer support for XDP is still not going to solve the
> problem. XDP is free form allowing any packet modifications - pushing
> and popping headers - and, for example, that blows up all of the skb
> markers for mac, network, transport and their inner versions. Walking
> the skb after an XDP program has run to reset the markers does not make
> sense. Combine this with the generic xdp overhead (e.g., handling skb
> clone and linearize), and the whole thing just does not make sense.

I can see your point that fixing up the whole skb after the program has
run is not a good idea. But to me that just indicates that the hook is
in the wrong place: that it really should be in the driver, executed at
a point where the skb data structure is no longer necessary (similar to
how the ingress hook is before the skb is generated).

Otherwise, what you're proposing is not an egress hook, but rather a
'post-REDIRECT hook', which is strictly less powerful. This may or may
not be useful in its own right, but let's not pretend it's a full egress
hook. Personally I feel that the egress hook is what we should be going
for, not this partial thing.

-Toke

