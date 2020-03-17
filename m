Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED18187DD7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 11:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgCQKKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 06:10:02 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41067 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgCQKKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 06:10:02 -0400
Received: by mail-oi1-f193.google.com with SMTP id b17so6131670oic.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 03:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zY+jAY+qdQxZ+F5t7p1CA/78xID9/3zkK+z8LvOljUs=;
        b=merkNONVwbgLTn4A0WuVaVQf/As6fkhmZCT3gypLsCCSPSF4m5m4nHRO1B0QzZ4GTf
         sOdJI4cZ4MDwr74sn/cjiGq23ut0cV7qDmH1BSKPvE91CXiyv1GTGjC9S1OfnwS4/XKR
         iuO6guY/WlJ9du643roULwmQV5bsMaQ2sxM20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zY+jAY+qdQxZ+F5t7p1CA/78xID9/3zkK+z8LvOljUs=;
        b=ozMgsEIhhCLx75bHy5FSVmtWhkp9MNzyBpUgEybOxPlcJQnnlqpItcmxSFqmJMqd3/
         wAKnpYmrqZ1CYv3ut4M0iXLM87FPQ57lUvfyBoOmxy+ZYxMnjr7SKy6Io3yrwdopLvWT
         S5lu630LeA3alRnnyj1xl5Toy5LAba1bIlUKUxnMKLTBZaMd8kO00ybnFONNIsVRU3x4
         wbZuCUrZlnolQJBkqU0XsPsDYP2F+JjlcyxUFQWnA4/bKsV+k5P3d/ax5PdrlStiT21k
         SdWAtEv+Yy+QxHStd9TEl8bU43lo8/gYarJoTRHbZ/XG96TzCTKbqhcCfndEL3VChX/U
         LOfw==
X-Gm-Message-State: ANhLgQ3F0+o6OdHiqwC3DTSAw8kZF5uxIbCwfVEY4yOzIiBZ7Z+NasYj
        kQK7Knn2lMh8lz+ItFPyjablSQtjPUpCZqvJVW5ZiRusd4g=
X-Google-Smtp-Source: ADFU+vvk+n+qR+SAhKCdtybK7rkpmFJOg0loURcCwqFjFCCRkP3JAff5oG76ZwMmgcLwbPQIe+UIWgmXWpR6S1wgjeA=
X-Received: by 2002:aca:f541:: with SMTP id t62mr2930491oih.172.1584439799759;
 Tue, 17 Mar 2020 03:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
In-Reply-To: <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 17 Mar 2020 10:09:48 +0000
Message-ID: <CACAyw9_zt-wetBiFWXtpQOOv79QCFR12dA9jx1UDEya=0_poyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 at 03:06, Joe Stringer <joe@wand.net.nz> wrote:
>
> On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > >
> > > This helper requires the BPF program to discover the socket via a call
> > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > helper takes its own reference to the socket in addition to any existing
> > > reference that may or may not currently be obtained for the duration of
> > > BPF processing. For the destination socket to receive the traffic, the
> > > traffic must be routed towards that socket via local route, the socket
> > I also missed where is the local route check in the patch.
> > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
>
> This is a requirement for traffic redirection, it's not enforced by
> the patch. If the operator does not configure routing for the relevant
> traffic to ensure that the traffic is delivered locally, then after
> the eBPF program terminates, it will pass up through ip_rcv() and
> friends and be subject to the whims of the routing table. (or
> alternatively if the BPF program redirects somewhere else then this
> reference will be dropped).

Can you elaborate what "an appropriate routing configuration" would be?
I'm not well versed with how routing works, sorry.

Do you think being subject to the routing table is desirable, or is it an
implementation trade-off?

>
> I think this is a general bpf_sk*_lookup_*() question, previous
> discussion[0] settled on avoiding that complexity before a use case
> arises, for both TC and XDP versions of these helpers; I still don't
> have a specific use case in mind for such functionality. If we were to
> do it, I would presume that the socket lookup caller would need to
> pass a dedicated flag (supported at TC and likely not at XDP) to
> communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> and used to select the reuseport socket.

I was surprised that both TC and XDP don't run the reuseport program!
So far I assumed that TC did pass the skb. I understand that you don't want
to tackle this issue, but is it possible to reject reuseport sockets from
sk_assign in that case?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
