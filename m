Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0B25A0D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfEUVjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:39:33 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:42526 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEUVjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:39:33 -0400
Received: by mail-pg1-f182.google.com with SMTP id e17so13840pgo.9;
        Tue, 21 May 2019 14:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9hhkE0rIkqPUVKFSYmVgLQQYtPSv0Lsn6s3P1xry1Fo=;
        b=R5ZLoIDSct96YC/uOlMS5zkhX74pu+hjmNej2rZ2mJfApB81rUSgYKtH6YzIAkrlSw
         wBavjlES2qfPWlLOxtbTV4UnVxbTWrg/Gthpv+DXZ+ueRe6bJmDGTgh7H2FC7wC5/H0d
         f4DU4PW+GkWr567O2ZiuFsNhlP+ixqsLZIKZe4Ys6UQvLWAR0ocOinygABy8PwQ9LZhk
         vM4gSULGkn+qqcy+tyuJ7p3eojVs74b+vmU4e9mMSwwrt3CoiB0I5CdMpNz4ic2dEZyG
         bRJYghz8g3vlyWove5V3YPGmdfA7wJDyX5tMaT059hi8pRtjniVLRc8F3PtsNWX0yWgk
         5opQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9hhkE0rIkqPUVKFSYmVgLQQYtPSv0Lsn6s3P1xry1Fo=;
        b=FjRoSZdT8AGCNjrx9adjxD5XozAZhyordYLdlIe7Z3gucp7EOinPOMGI2CcMngq51y
         R+ALQi3RSKXVg8tw2dAx65rS4hjFsYlvzTq4VYVrvedsw13UxwASBBcH+spslfKfRvlV
         NktgrIvk6eQf3YXoKuaexEe7uNi0juyKOI8ncMopOLfwjxqQQnA6ukJbK6TvuctFaGjF
         OmUBOkCAP/LCURlmoUYg64un7D0jBH2mRQQCOzzK8Iizxg/gGsQLgD7P4kudcwiNBKH+
         w/8iqVpClrcqV7ax3mW+cd8j2SCNkRqgo4gvvRShvHC8rjMWUzyUkGVaFgPqRn2MkTBv
         ym3w==
X-Gm-Message-State: APjAAAWMDo8Pf12kh7mvUBJ+JnpasBEKOVxSIABI2113PNxcEVR5xw5U
        iD+HjUzw1XnBL7GiwZk6myyf4X7U
X-Google-Smtp-Source: APXvYqz0wBwUqFbCUAydEF9sCfHfZKFus6A5n+E1dTgBbgBH4zp3SQcNsNf8n7Jj/r1o7pERHGUMYQ==
X-Received: by 2002:a63:1b56:: with SMTP id b22mr82653824pgm.87.1558474772144;
        Tue, 21 May 2019 14:39:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:1eff])
        by smtp.gmail.com with ESMTPSA id a3sm24566816pgl.74.2019.05.21.14.39.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:39:31 -0700 (PDT)
Date:   Tue, 21 May 2019 14:39:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Nitin Hande <nitin.hande@gmail.com>,
        Joe Stringer <joe@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
Message-ID: <20190521213928.ny2mwreu4fnigj2i@ast-mbp.dhcp.thefacebook.com>
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
 <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com>
 <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
 <CAGUcTrqnrE+9BGsuc3sf_DpzsD01wP6h3PbK3-u6hk=6wM0zGg@mail.gmail.com>
 <CACAyw9-ijc1o1QOnQD=ukr-skswxe+4mDVKdX58z6AkTrEpOuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-ijc1o1QOnQD=ukr-skswxe+4mDVKdX58z6AkTrEpOuA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 04:47:58PM +0100, Lorenz Bauer wrote:
> On Fri, 17 May 2019 at 00:38, Nitin Hande <nitin.hande@gmail.com> wrote:
> >
> > On Thu, May 16, 2019 at 2:57 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, May 16, 2019 at 09:41:34AM +0100, Lorenz Bauer wrote:
> > > > On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
> > > > >
> > > > > On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > > >
> > > > > > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > > > > > that the sk_lookup_* helpers currently return inconsistent results if
> > > > > > SK_REUSEPORT programs are in play.
> > > > > >
> > > > > > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > > > > > to the full packet
> > > > > > that triggered the look up. To support this, inet_lookup gained a new
> > > > > > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > > > > > program is skipped and instead the socket is selected by its hash.
> > > > > >
> > > > > > The first problem is that not all callers to inet_lookup from BPF have
> > > > > > an skb, e.g. XDP. This means that a look up from XDP gives an
> > > > > > incorrect result. For now that is not a huge problem. However, once we
> > > > > > get sk_assign as proposed by Joe, we can end up circumventing
> > > > > > SK_REUSEPORT.
> > > > >
> > > > > To clarify a bit, the reason this is a problem is that a
> > > > > straightforward implementation may just consider passing the skb
> > > > > context into the sk_lookup_*() and through to the inet_lookup() so
> > > > > that it would run the SK_REUSEPORT BPF program for socket selection on
> > > > > the skb when the packet-path BPF program performs the socket lookup.
> > > > > However, as this paragraph describes, the skb context is not always
> > > > > available.
> > > > >
> > > > > > At the conference, someone suggested using a similar approach to the
> > > > > > work done on the flow dissector by Stanislav: create a dedicated
> > > > > > context sk_reuseport which can either take an skb or a plain pointer.
> > > > > > Patch up load_bytes to deal with both. Pass the context to
> > > > > > inet_lookup.
> > > > > >
> > > > > > This is when we hit the second problem: using the skb or XDP context
> > > > > > directly is incorrect, because it assumes that the relevant protocol
> > > > > > headers are at the start of the buffer. In our use case, the correct
> > > > > > headers are at an offset since we're inspecting encapsulated packets.
> > > > > >
> > > > > > The best solution I've come up with is to steal 17 bits from the flags
> > > > > > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > > > > > the offset itself.
> > > > >
> > > > > FYI there's also the upper 32 bits of the netns_id parameter, another
> > > > > option would be to steal 16 bits from there.
> > > >
> > > > Or len, which is only 16 bits realistically. The offset doesn't really fit into
> > > > either of them very well, using flags seemed the cleanest to me.
> > > > Is there some best practice around this?
> > > >
> > > > >
> > > > > > Thoughts?
> > > > >
> > > > > Internally with skbs, we use `skb_pull()` to manage header offsets,
> > > > > could we do something similar with `bpf_xdp_adjust_head()` prior to
> > > > > the call to `bpf_sk_lookup_*()`?
> > > >
> > > > That would only work if it retained the contents of the skipped
> > > > buffer, and if there
> > > > was a way to undo the adjustment later. We're doing the sk_lookup to
> > > > decide whether to
> > > > accept or forward the packet, so at the point of the call we might still need
> > > > that data. Is that feasible with skb / XDP ctx?
> > >
> > > While discussing the solution for reuseport I propose to use
> > > progs/test_select_reuseport_kern.c as an example of realistic program.
> > > It reads tcp/udp header directly via ctx->data or via bpf_skb_load_bytes()
> > > including payload after the header.
> > > It also uses bpf_skb_load_bytes_relative() to fetch IP.
> > > I think if we're fixing the sk_lookup from XDP the above program
> > > would need to work.
> > >
> > > And I think we can make it work by adding new requirement that
> > > 'struct bpf_sock_tuple *' argument to bpf_sk_lookup_* must be
> > > a pointer to the packet and not a pointer to bpf program stack.
> > > Then helper can construct a fake skb and assign
> > > fake_skb->data = &bpf_sock_tuple_arg.sport
> > > It can check that struct bpf_sock_tuple * pointer is within 100-ish bytes
> > > from xdp->data and within xdp->data_end
> > > This way the reuseport program's assumption that ctx->data points to tcp/udp
> > > will be preserved and it can access it all including payload.
> > >
> > > This approach doesn't need to mess with xdp_adjust_head and adjust uapi to pass length.
> > > Existing progs/test_sk_lookup_kern.c will magically start working with XDP
> > > even when reuseport prog is attached.
> > > Thoughts?
> >
> > I like this approach. A fake_skb approach will normalize the bpf_sk_lookup_*()
> > API peering into the kernel API between TC and XDP invocation. Just one question
> > that comes, I remember one of the comments I received during my XDP commit
> > was the stateless nature of XDP services and providing a fake_skb may bring
> > some potential side-effects to the desire of statelessness. Is that
> > still a possibility?
> > How do we guard against it?
> 
> To follow up on this, I'm also not sure how to tackle a "fake skb". If
> I remember this
> came up during the flow dissector series, and wasn't met with
> enthusiasm. Granted,
> replacing the skb argument to the lookup functions seems even harder, so maybe
> this is the lesser evil?

flow_dissector pretends to have 'skb' as bpf prog argument.
It doesn't allocate actual 'struct sk_buff' on the kernel side.
The verifier rewrites __sk_buff->foo accesses into
'struct bpf_flow_dissector'->bar access.
I was hoping similar idea can apply here.
BPF_PROG_TYPE_SK_REUSEPORT type takes 'struct sk_reuseport_md *'
so we don't need real skb there anyway.
But for older socket_filter based so_reuseport progs it's more difficult,
since at the verification time they're generic socket_filter progs.
Right now I don't have a better idea than to do static per_cpu struct sk_buff.

