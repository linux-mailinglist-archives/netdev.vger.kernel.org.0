Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D392AF335
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKKOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:12:53 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41875 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKKOM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:12:26 -0500
Received: by mail-ed1-f67.google.com with SMTP id t9so2430189edq.8;
        Wed, 11 Nov 2020 06:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CuVje61v2yDbbD/sH1NxHzcwnPYG7yJmRCAj0/P2Sz4=;
        b=uYDXMvpn5zFnH/O5OXqHfBNrQ7hmIOnCmgk8KtPFG54ixuzu97cBAkaiiIVittnR7r
         oq2gZdGNMIE991zZWixIKbpH7Ibn7hVCy1FoK9pQ1wGJjSPdDwKqyxp12XWyss6SUBXS
         mLVK12WE4cPKplqg44xPtWJhxfaHGRMryS0M4LyWFtfwsamzPi0DOvOeLq5pecnFg5jz
         7AqnJwVpD77We0D8jy3cRcQiaHa7M4s9p21eb22NS1Jdkh0PcJ//04sUF+q1SphtVC0k
         GkPklSwKtIqrFtTQOoeZ5MRcyqD74hfXWvqmKjBvqKcl4TNR/Wdd5yczHEVPvpxkDqFw
         +TdQ==
X-Gm-Message-State: AOAM531/90aOntW5xTktsw8yEhPdao5rf5mVgQt6udPVs58fcljJttAa
        4IRvpB1aRB5RAA+nt1BSoOY=
X-Google-Smtp-Source: ABdhPJzrpJyj93vo9HYxQo+T5Hf1opEPe5nvkuzKWrLshrsz/BeGF4AfP/RssJDvDuZqILaj297bKw==
X-Received: by 2002:a50:a105:: with SMTP id 5mr5101102edj.165.1605103944354;
        Wed, 11 Nov 2020 06:12:24 -0800 (PST)
Received: from santucci.pierpaolo ([2.236.81.180])
        by smtp.gmail.com with ESMTPSA id h23sm969467edv.69.2020.11.11.06.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 06:12:23 -0800 (PST)
Date:   Wed, 11 Nov 2020 15:12:21 +0100
From:   Santucci Pierpaolo <santucci@epigenesys.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
Message-ID: <X6vxRV1zqn+GjLfL@santucci.pierpaolo>
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
 <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
 <87imacw3bh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imacw3bh.fsf@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

thanks for your reply.

Let me explain the problem with an example.

Please consider the PCAP file:
https://github.com/named-data/ndn-tools/blob/master/tests/dissect-wireshark/ipv6-udp-fragmented.pcap
Let's assume that the dissector is invoked without the flag:
BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL.
 
Without the proposed patch, the flow keys for the second fragment (packet
timestamp 0.256997) will contain the value 0x6868 for the source and
destination port fields: this is obviously wrong.
The same happens for the third fragment (packet timestamp 0.256998) and for
the fourth fragment (packet timestamp 0.257001).

So it seems that the correct thing to do is to stop the dissector after the
IPV6 fragmentation header for all fragments from the second on.

Regards,
    Pierpaolo Santucci

On Wed, Nov 11, 2020 at 12:17:06PM +0100, Jakub Sitnicki wrote:
> On Wed, Nov 11, 2020 at 05:48 AM CET, Andrii Nakryiko wrote:
> > On Tue, Nov 10, 2020 at 9:12 AM Santucci Pierpaolo
> > <santucci@epigenesys.com> wrote:
> >>
> >> From second fragment on, IPV6FR program must stop the dissection of IPV6
> >> fragmented packet. This is the same approach used for IPV4 fragmentation.
> >>
> >
> > Jakub, can you please take a look as well?
> 
> I'm not initimately familiar with this test, but looking at the change
> I'd consider that Destinations Options and encapsulation headers can
> follow the Fragment Header.
> 
> With enough of Dst Opts or levels of encapsulation, transport header
> could be pushed to the 2nd fragment. So I'm not sure if the assertion
> from the IPv4 dissector that 2nd fragment and following doesn't contain
> any parseable header holds.
> 
> Taking a step back... what problem are we fixing here?
> 
> >
> >> Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
> >> ---
> >>  tools/testing/selftests/bpf/progs/bpf_flow.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> >> index 5a65f6b51377..95a5a0778ed7 100644
> >> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> >> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> >> @@ -368,6 +368,8 @@ PROG(IPV6FR)(struct __sk_buff *skb)
> >>                  */
> >>                 if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
> >>                         return export_flow_keys(keys, BPF_OK);
> >> +       } else {
> >> +               return export_flow_keys(keys, BPF_OK);
> >>         }
> >>
> >>         return parse_ipv6_proto(skb, fragh->nexthdr);
> >> --
> >> 2.29.2
> >>
