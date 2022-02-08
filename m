Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82CC4AD893
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiBHNP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376354AbiBHM53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:57:29 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B74C03FECA
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:57:27 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id b2so3244876vso.9
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 04:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZ2ThHzP4ksA4NOQgohi764WWAj9VnjVAoaKOn8fduI=;
        b=EMNBfmRp2wjXy+C2nQjYiC4DxNdDT0Ya2c9ZJSm2s/IK+XPPjo+cGsdCTvp9u90FsG
         tRqCGtNC3wCccHPKhPWChFxncjU99ntTEaBdEPB03bc9P8/U8FYgUFY7vdSZAP+LL66n
         8muVbJxDU+xxi+GmHrXwjsvugC3kqxn9ef9hdQsp10IXD+NVENGlrxBTWY+UFPNoHPf4
         RHbN11vXN69TDV8BidyZ8l4EP8cJ2ab/NHOkJSAN5IKDoyD0sZA7xP4PaeLcrr5DiYd4
         g91AF4JgLxIiEs01Ea2luKoKeXr9sBtd2/KBDK+xVx2Jy59x8WCPTibulnNVsHC01Xk4
         ZNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZ2ThHzP4ksA4NOQgohi764WWAj9VnjVAoaKOn8fduI=;
        b=4gTZLjp8CbLrikMWO+d0LY9eT4YLhODCVg5SfnGYytw729681rp5LbxCUUl96iuL/2
         rIiBkSCqslD/wr4IKXyfGI02k7fHl6tQ+wQmOYhrtheqZp2bz6dOfvPwbZy9Cj0E1kC4
         45ZHEDt9yG8PKIy/YNY7JTTTw3LhlUhkTge2Xe1HTuq1cF22cB1YE30lhCDY65YOrxQB
         DtBSO3kR3O/d9d+fPyDTJKRcBtzOj+mPaRnr+U5PEUJSAk+koX2tVgbsq7/VaaSPdgtn
         r/Tlt8Nle46oq1vdCrzDHDPYjgjCGyQOitNZ683Y8QugFHaF2nTLDH/AGrymiBds+lMT
         c94Q==
X-Gm-Message-State: AOAM530cPBOqZO319ovAt3yb0BsMP4jHniEMy8qGj0OCfl6dPOd0FlgG
        3RhNinqeKXiM3T7LyTolDPelS1Wx6RIfV6CZeXdLNAsVUbBw9g==
X-Google-Smtp-Source: ABdhPJwzYnmI8xSLok/uyBrzIkBQJkWypFop0Iw7jyMCJjojRBeCCoicMZcYrBL6mMytDpkckHcQi/Zv4nuSY6mysaM=
X-Received: by 2002:a67:e146:: with SMTP id o6mr1574855vsl.12.1644325046779;
 Tue, 08 Feb 2022 04:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20220208025511.1019-1-lina.wang@mediatek.com> <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
In-Reply-To: <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 8 Feb 2022 04:57:14 -0800
Message-ID: <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix wrong network header length
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 12:25 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Tue, 2022-02-08 at 10:55 +0800, Lina Wang wrote:
> > When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
> > several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
> > ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> > network_header\transport_header\mac_header have been updated as ipv4 acts,
> > but other skbs in frag_list didnot update anything, just ipv6 packets.
> >
> > udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
> > frag_list and make sure right udp payload is delivered to user space.
> > Unfortunately, other skbs in frag_list who are still ipv6 packets are
> > updated like the first skb and will have wrong transport header length.
> >
> > e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
> > has the same network_header(24)& transport_header(64), after
> > bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
> > skb's network_header is 44,transport_header is 64, other skbs in frag_list
> > didnot change.After skb_segment_list, the other skbs in frag_list has
> > different network_header(24) and transport_header(44), so there will be 20
> > bytes difference,that is difference between ipv6 header and ipv4 header.
>
> > Actually, there are two solutions to fix it, one is traversing all skbs
> > and changing every skb header in bpf_skb_proto_6_to_4, the other is
> > modifying frag_list skb's header in skb_segment_list.
>
> I don't think the above should be addressed into the GSO layer. The
> ebpf program is changing the GRO packet in arbitrary way violating the
> GSO packet constraint - arguably, it's corrupting the packet.
>
> I think it would be better change the bpf_skb_proto_6_to_4() to
> properly handle FRAGLIST GSO packets.
>
> If traversing the segments become too costly, you can try replacing
> GRO_FRAGLIST with GRO_UDP_FWD.

Yeah, I don't know...

I've considered that we could perhaps fix the 6to4 helper, and 4to6 helper...
but then I think every *other* helper / code path that plays games
with the packet header needs fixing as well,
ie. everything dealing with encap/decap, vlan, etc..

At that point it seems to me like it's worth fixing here rather than
in all those other places.

In general it seems gro fraglist as implemented is just a bad idea...
Packets (and things we treat like packets) really should only have 1 header.
GRO fraglist - as implemented - violates this pretty fundamental assumption.
As such it seems to be on the gro fraglist implementation to deal with it.
That to me seems to mean it should be fixed here, and not elsewhere.

(btw. wrt. this commit itself, it seems like the diff should be a signed int)
