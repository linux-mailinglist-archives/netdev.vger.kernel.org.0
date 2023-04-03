Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1FF6D43C2
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjDCLnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjDCLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:42:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC31618E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680522116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lAA4ki3zB9Sc2BvyQKZ9CRE+NZTe+gbrNnzSl5hXPoY=;
        b=FFCueBIE55SRU1vViDQiOFN1zaQ/ZOBSlPMnJTzRcuyNUcdDep4iKh9tOVLzex64nA2Mx2
        RmWfhHnhabNq+60IMlsdGZVhGDdXG3zl7IWa7Ip6tguO2YKFsj13fgr0Js6t+8/Z623fp4
        JGD/IGJ8nt8p92WNdlrKdlMxkK/wU2I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-dRy5lBTDNgexFNhKWGK0QQ-1; Mon, 03 Apr 2023 07:41:55 -0400
X-MC-Unique: dRy5lBTDNgexFNhKWGK0QQ-1
Received: by mail-qt1-f198.google.com with SMTP id y10-20020a05622a164a00b003e38e0a3cc3so19552855qtj.14
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680522114;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAA4ki3zB9Sc2BvyQKZ9CRE+NZTe+gbrNnzSl5hXPoY=;
        b=TKuIZMmPIuQwSI4mq0taw06roSbtUgV/syhQin+FUlUrCfK+t1BU1b8EE0zuyxhQMK
         2264KmuiFH7vZ7XpZ40wXu7xD0G42o+afF+a+YMkKhVPBSGtJ+viG9DXn2am6IW9IYxQ
         1jLq2UwChGmmMTDP5sLj2nqcRZzlbF+Mz8oZDsl8r1yqxYdX4ZdZoBjrJb+gBiNnMX7v
         XOT9QrDQ/bBrepSov3hC9k05dtc+NITQMbXuvYX2KZrSBNegTNQ38Sx8iRPKZsl9dDYG
         ZDUYhMadQiEB7xPkLeWWbnrTgTFfA6RqqVSLfN1PJNqKau7XLQouBrDm0qE3WQBF3dFK
         pPQg==
X-Gm-Message-State: AAQBX9csbfLU+5eT9Iv67s36o10mE8geykfyTdXRY8njgcsYwzGjKpC3
        pHHxT3G5ENTplWfYWX0mxLcWMboIYmxYcBcefJXUf8/4rb0PXjEhiCX7QE/so7u1NKT4mOrdHOz
        3jgXnalg3rYeoVJcaEhUc8xal
X-Received: by 2002:a05:622a:1894:b0:3e4:d3cc:4211 with SMTP id v20-20020a05622a189400b003e4d3cc4211mr24722784qtc.3.1680522113842;
        Mon, 03 Apr 2023 04:41:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zm+ljI2xLE3+R2zfgshdK/1RT6/i2PIKSmeBthGqj7JRT8S9rzTz9oz3P0oT2TC9+sLWvRog==
X-Received: by 2002:a05:622a:1894:b0:3e4:d3cc:4211 with SMTP id v20-20020a05622a189400b003e4d3cc4211mr24722749qtc.3.1680522113541;
        Mon, 03 Apr 2023 04:41:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id o15-20020a05620a228f00b0073b8512d2dbsm2694344qkh.72.2023.04.03.04.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:41:53 -0700 (PDT)
Message-ID: <352c24ff0c1b3a9f63062c21bbee0dca1b9ebfff.camel@redhat.com>
Subject: Re: [PATCH v4 2/2] gro: optimise redundant parsing of packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Richard Gobert <richardbgobert@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        alexanderduyck@fb.com, lucien.xin@gmail.com, lixiaoyan@google.com,
        iwienand@redhat.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 03 Apr 2023 13:41:49 +0200
In-Reply-To: <20230322193309.GA32681@debian>
References: <20230320163703.GA27712@debian> <20230320170009.GA27961@debian>
         <889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com>
         <CANn89iK_bsPoaRVe+FNZ7LF_eLbz2Af6kju4j9TVHtbgkpcn5g@mail.gmail.com>
         <20230322193309.GA32681@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-22 at 20:33 +0100, Richard Gobert wrote:
> > On Wed, Mar 22, 2023 at 2:59 AM Paolo Abeni <pabeni@redhat.com>
> > wrote:
> > >=20
> > > On Mon, 2023-03-20 at 18:00 +0100, Richard Gobert wrote:
> > > > Currently the IPv6 extension headers are parsed twice: first in
> > > > ipv6_gro_receive, and then again in ipv6_gro_complete.
> > > >=20
> > > > By using the new ->transport_proto field, and also storing the
> > > > size of the
> > > > network header, we can avoid parsing extension headers a second
> > > > time in
> > > > ipv6_gro_complete (which saves multiple memory dereferences and
> > > > conditional
> > > > checks inside ipv6_exthdrs_len for a varying amount of
> > > > extension headers in
> > > > IPv6 packets).
> > > >=20
> > > > The implementation had to handle both inner and outer layers in
> > > > case of
> > > > encapsulation (as they can't use the same field). I've applied
> > > > a similar
> > > > optimisation to Ethernet.
> > > >=20
> > > > Performance tests for TCP stream over IPv6 with a varying
> > > > amount of
> > > > extension headers demonstrate throughput improvement of ~0.7%.
> > >=20
> > > I'm surprised that the improvement is measurable: for large
> > > aggregate
> > > packets a single ipv6_exthdrs_len() call is avoided out of tens
> > > calls
> > > for the individual pkts. Additionally such figure is comparable
> > > to
> > > noise level in my tests.
>=20
> It's not simple but I made an effort to make a quiet environment.
> Correct configuration allows for this kind of measurements to be made
> as the test is CPU bound and noise is a variance that can be reduced
> with=20
> enough samples.
>=20
> Environment example: (100Gbit NIC (mlx5), physical machine, i9 12th
> gen)
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0# power-management and hyperthreading disabled in=
 BIOS
> =C2=A0=C2=A0=C2=A0=C2=A0# sysctl preallocate net mem
> =C2=A0=C2=A0=C2=A0=C2=A0echo 0 > /sys/devices/system/cpu/cpufreq/boost # =
disable
> turboboost
> =C2=A0=C2=A0=C2=A0=C2=A0ethtool -A enp1s0f0np0 rx off tx off autoneg off =
# no PAUSE
> frames
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0# Single core performance
> =C2=A0=C2=A0=C2=A0=C2=A0for x in /sys/devices/system/cpu/cpu[1-9]*/online=
; do echo 0
> >"$x"; done
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0./network-testing-master/bin/netfilter_unload_mod=
ules.sh
> 2>/dev/null # unload netfilter
> =C2=A0=C2=A0=C2=A0=C2=A0tuned-adm profile latency-performance
> =C2=A0=C2=A0=C2=A0=C2=A0cpupower frequency-set -f 2200MHz # Set core to s=
pecific
> frequency
> =C2=A0=C2=A0=C2=A0=C2=A0systemctl isolate rescue-ssh.target
> =C2=A0=C2=A0=C2=A0=C2=A0# and kill all processes besides init
>=20
> > > This adds a couple of additional branches for the common (no
> > > extensions
> > > header) case.
>=20
> The additional branch in ipv6_gro_receive would be negligible or even
> non-existent for a branch predictor in the common case
> (non-encapsulated packets).
> I could wrap it with a likely macro if you wish.
> Inside ipv6_gro_complete a couple of branches are saved for the
> common
> case as demonstrated below.
>=20
> original code ipv6_gro_complete (ipv6_exthdrs_len is inlined):
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0// if (skb->encapsulation)
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c4962b:	f6 87 81 00 00 00 20 	testb=20
> $0x20,0x81(%rdi)
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c49632:	74 2a                	je   =20
> ffffffff81c4965e <ipv6_gro_complete+0x3e>
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0...
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0// nhoff +=3D sizeof(*iph) + ipv6_exthdrs_len(iph=
, &ops);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c4969c:	eb 1b                	jmp  =20
> ffffffff81c496b9 <ipv6_gro_complete+0x99>    <-- jump to beginning of
> for loop
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c4968e:   b8 28 00 00 00          mov  =
  $0x28,%eax
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c49693:   31 f6                   xor  =
  %esi,%esi
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c49695:   48 c7 c7 c0 28 aa 82    mov  =
=20
> $0xffffffff82aa28c0,%rdi
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c4969c:   eb 1b                   jmp  =
=20
> ffffffff81c496b9 <ipv6_gro_complete+0x99>
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c4969e:   f6 41 18 01             testb=
=20
> $0x1,0x18(%rcx)
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496a2:   74 34                   je   =
=20
> ffffffff81c496d8 <ipv6_gro_complete+0xb8>    <--- 3rd conditional
> check: !((*opps)->flags & INET6_PROTO_GSO_EXTHDR)
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496a4:   48 98                   cltq =
=20
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496a6:   48 01 c2                add  =
  %rax,%rdx
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496a9:   0f b6 42 01             movzb=
l 0x1(%rdx),%eax
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496ad:   0f b6 0a                movzb=
l (%rdx),%ecx
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496b0:   8d 04 c5 08 00 00 00    lea  =
=20
> 0x8(,%rax,8),%eax
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496b7:   01 c6                   add  =
  %eax,%esi
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496b9:   85 c9                   test =
  %ecx,%ecx   =20
> <--- for loop starts here
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496bb:   74 e7                   je   =
=20
> ffffffff81c496a4 <ipv6_gro_complete+0x84>    <--- 1st conditional
> check: proto !=3D NEXTHDR_HOP
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496bd:   48 8b 0c cf             mov  =
=20
> (%rdi,%rcx,8),%rcx
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496c1:   48 85 c9                test =
  %rcx,%rcx
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81c496c4:   75 d8                   jne  =
=20
> ffffffff81c4969e <ipv6_gro_complete+0x7e>    <--- 2nd conditional
> check: unlikely(!(*opps))
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0... (indirect call ops->callbacks.gro_complete)
>=20
> ipv6_exthdrs_len contains a loop which has 3 conditional checks.
> For the common (no extensions header) case, in the new code, *all 3
> branches are completely avoided*
>=20
> patched code ipv6_gro_complete:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0// if (skb->encapsulation)
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81befe58:   f6 83 81 00 00 00 20    testb=
=20
> $0x20,0x81(%rbx)
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81befe5f:   74 78                   je   =
=20
> ffffffff81befed9 <ipv6_gro_complete+0xb9>
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0...
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0// else
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81befed9:	0f b6 43 50          	movzbl
> 0x50(%rbx),%eax
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81befedd:	0f b7 73 4c          	movzwl
> 0x4c(%rbx),%esi
> =C2=A0=C2=A0=C2=A0=C2=A0ffffffff81befee1:	48 8b 0c c5 c0 3f a9 	mov    -
> 0x7d56c040(,%rax,8),%rcx
> =C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0... (indirect call ops->callbacks.gro_complete)
>=20
> Thus, the patch is beneficial for both the common case and the ext
> hdr
> case. I would appreciate a second consideration :)

A problem with the above analysis is that it does not take in
consideration the places where the new branch are added:
eth_gro_receive() and ipv6_gro_receive().

Note that such functions are called for each packet on the wire:
multiple times for each aggregate packets.=20

The above is likely not measurable in terms on pps delta, but the added
CPU cycles spent for the common case are definitely there. In my
opinion that outlast the benefit for the extensions header case.

Cheers,

Paolo

p.s. please refrain from off-list ping. That is ignored by most and
considered rude by some.

