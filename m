Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA44572915
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 00:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiGLWOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 18:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiGLWOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 18:14:53 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A4AB1CC2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 15:14:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 5-20020a620605000000b00527ca01f8a3so2766075pfg.19
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 15:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y6t3iDm9GwNmjV2vlQyhKcUiXb93GbH2Nv8sz+9x1PM=;
        b=L+JGxUqk+x+Rvv1+JcEOnvYuGWypPqnYlFtTwCDRfh7+XIaQder6grPJXbYeqAtZBE
         Pv9osdMol+o8TKB8+Vr3YUJCD1oUKozPs3Xam6Dy8HQyRb/5dMrg0CeWCW7R+Qt4CXJM
         lFZn5r+oeVG0Gu8FGv5TASPc2LVFtPrlDTOidqIj7rgm1oJjTjHet/kWj2pUtUlMtsW0
         0BKehu2K0h0Bfhx/DqvdzmJqktJiAOb3/V8/UI2UDZBmL6uuBPTZTWFoOdNexBeKCIKH
         8G+aplAjz1F3qSeVgDkgeYY8m3Jz7xe5mVQn2XJv8DOxSqQ6dLScs2KZozyuhATYISes
         C7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y6t3iDm9GwNmjV2vlQyhKcUiXb93GbH2Nv8sz+9x1PM=;
        b=jH/2biO/2L9Yj0keP935AIkVTa45mFZwdnZKp/kN72aYNfgArNJWpU4+fkG/f4ABrs
         l2IfqeohmJLyQ/zF+7zv9lQ2aA7GQ6djpi1BLv7cJVGlLuUBD0kBqPICgxmjUn5seSKg
         7wo5if286Q0n/CK2DbclLOlYpA3yIw/gqTrOocRATO8ouaz/kfmuF8M30evPknDdFkaz
         WGNG8bfObKIWtCIaa1+ocgjDO5iFEk7pED3u5orefc4ZBJ6ok3QakYewv6LUAXzokFbN
         d4FgER9n2fC6ekjUpM2M78lhA3KlB9xi8m/iyqQ3ZMI/Lrzn0E6alTUODh4UkxikQMLi
         B1Qw==
X-Gm-Message-State: AJIora+ekjzeFVLJfsnGERoudk5VA2h/wHYbFchei7pDdVN6rYS+fpfu
        sOft24le+mCI2W3wsswg6+AZ+sA=
X-Google-Smtp-Source: AGRyM1s4iuYht14q6gFZMO3RWTR0QLcs3KatATGI4cdY3BULRTru2/uKD1hdqS40x4ACgE6WxjSz52E=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e80a:b0:16c:3e68:bbe1 with SMTP id
 u10-20020a170902e80a00b0016c3e68bbe1mr148045plg.85.1657664091611; Tue, 12 Jul
 2022 15:14:51 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:14:50 -0700
In-Reply-To: <20220712175837.16267-1-andrea.mayer@uniroma2.it>
Message-Id: <Ys3yWlQT/vEpVH+i@google.com>
Mime-Version: 1.0
References: <20220712175837.16267-1-andrea.mayer@uniroma2.it>
Subject: Re: [net 0/3] seg6: fix skb checksum for SRH encapsulation/insertion
From:   sdf@google.com
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Anton Makarov <anton.makarov11235@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12, Andrea Mayer wrote:
> The Linux kernel supports Segment Routing Header (SRH)
> encapsulation/insertion operations by providing the capability to: i)
> encapsulate a packet in an outer IPv6 header with a specified SRH; ii)
> insert a specified SRH directly after the IPv6 header of the packet.
> Note that the insertion operation is also referred to as 'injection'.

> The two operations are respectively supported by seg6_do_srh_encap() and
> seg6_do_srh_inline(), which operate on the skb associated to the packet as
> needed (e.g. adding the necessary headers and initializing them, while
> taking care to recalculate the skb checksum).

> seg6_do_srh_encap() and seg6_do_srh_inline() do not initialize the payload
> length of the IPv6 header, which is carried out by the caller functions.
> However, this approach causes the corruption of the skb checksum which
> needs to be updated only after initialization of headers is completed
> (thanks to Paolo Abeni for detecting this issue).

> The patchset fixes the skb checksum corruption by moving the IPv6 header
> payload length initialization from the callers of seg6_do_srh_encap() and
> seg6_do_srh_inline() directly into these functions.

> This patchset is organized as follows:
>   - patch 1/3, seg6: fix skb checksum evaluation in SRH
>     encapsulation/insertion;
>      (* SRH encapsulation/insertion available since v4.10)

>   - patch 2/3, seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps
>     behaviors;
>      (* SRv6 End.B6 and End.B6.Encaps behaviors available since v4.14)

>   - patch 3/3, seg6: bpf: fix skb checksum in bpf_push_seg6_encap();
>      (* bpf IPv6 Segment Routing helpers available since v4.18)

BPF changes make sense. I've tested them by applying the whole series and
running test_lwt_seg6local.sh.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
Tested-by: Stanislav Fomichev <sdf@google.com>


> Thank you all,
> Andrea

> Andrea Mayer (3):
>    seg6: fix skb checksum evaluation in SRH encapsulation/insertion
>    seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
>    seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

>   net/core/filter.c        | 1 -
>   net/ipv6/seg6_iptunnel.c | 5 ++++-
>   net/ipv6/seg6_local.c    | 2 --
>   3 files changed, 4 insertions(+), 4 deletions(-)

> --
> 2.20.1

