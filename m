Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95496624DCA
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiKJWuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKJWuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:50:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2860549B49
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668120564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2DAMQQ5h7BgqOE6Bw4G6t205nBFzBwUUl3Sh2iE/RY=;
        b=QJsnNdMH79b39aNrz5Y/87I/bQr0QhGoxDjb1Cq1DprElbxUn7XrUOxjyszKBJR84Q96mp
        HPQzO6U3y/DNJ5aBjE2cibxTS7ArEr0nbBTG1p0WVcjhnpBlwTjQpMa1m0QLesy1yZfjly
        70G/2Xk+fayykCyEyQAPB7GsfxzBJww=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-sJQkaq88N0i6ExRa0TG29Q-1; Thu, 10 Nov 2022 17:49:22 -0500
X-MC-Unique: sJQkaq88N0i6ExRa0TG29Q-1
Received: by mail-ed1-f71.google.com with SMTP id z15-20020a05640240cf00b00461b253c220so2423637edb.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:49:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2DAMQQ5h7BgqOE6Bw4G6t205nBFzBwUUl3Sh2iE/RY=;
        b=HMtVT1bf0IpkwZxJbIIP9Uwhk31DpdcqV9QxF4lv+G0s3Mia2izg0IYkNzK7ZO5wZU
         TYUOKBKMr5QEqE5frnDCTEy8+2B/KSXa1eI3ZoZb4PpqxdS3FZFgfk+K/Sq7pIvvXrmX
         uRhsMap2vOs7p+WhQ0T3d+glgKrEqfCAKmPlDVF+grIEdDFjWW5n7Ikm1b5HTTuMiz6I
         ctPhMw/WywUzVkosLf+QQVh2XB0nug2u1CV2NBc9sUgFAzsmRc8Ux6hBzneGfKzTTwzw
         cXvLbJcbOK1RWhFPbYK+4ppiGUauZx9oUAuQB51DBLQp9MjW+JXnvUDNvBG/fRMDIkV8
         /llg==
X-Gm-Message-State: ACrzQf1gZJJD3d+uNFfWuYcrl2yCD/Sl9f5A7CPSSRCh3VZsyqNctoes
        B5cK7xuDV8iaaIF4z52yTBEYUU95CLCf6/6fT6WKhdCCf2Cx13gHh2ibpKYJNSrJrKcG1xM1Hnp
        ywbqtLg2rq5MqQPlZ
X-Received: by 2002:a17:906:a886:b0:78d:5176:c4d2 with SMTP id ha6-20020a170906a88600b0078d5176c4d2mr4007626ejb.532.1668120561206;
        Thu, 10 Nov 2022 14:49:21 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7OFTYsH0ppHroIxDp3Lchlb0aV1CL+pM+HCJ33UgiKxTARGpkaCOtx4sqpIxbBrEHuNjWGkQ==
X-Received: by 2002:a17:906:a886:b0:78d:5176:c4d2 with SMTP id ha6-20020a170906a88600b0078d5176c4d2mr4007603ejb.532.1668120560775;
        Thu, 10 Nov 2022 14:49:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c1-20020a17090618a100b0078b03d57fa7sm228544ejf.34.2022.11.10.14.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:49:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 951E278273E; Thu, 10 Nov 2022 23:49:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <636d352fdf18e_145693208e5@john.notmuch>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <636c533231572_13c9f42087c@john.notmuch> <87v8nmyj5r.fsf@toke.dk>
 <636d352fdf18e_145693208e5@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Nov 2022 23:49:19 +0100
Message-ID: <87r0yaxw5s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Snipping a bit of context to reply to this bit:
>> >>=20
>> >> >>>> Can the xdp prog still change the metadata through xdp->data_met=
a? tbh, I am not
>> >> >>>> sure it is solid enough by asking the xdp prog not to use the sa=
me random number
>> >> >>>> in its own metadata + not to change the metadata through xdp->da=
ta_meta after
>> >> >>>> calling bpf_xdp_metadata_export_to_skb().
>> >> >>>
>> >> >>> What do you think the usecase here might be? Or are you suggestin=
g we
>> >> >>> reject further access to data_meta after
>> >> >>> bpf_xdp_metadata_export_to_skb somehow?
>> >> >>>
>> >> >>> If we want to let the programs override some of this
>> >> >>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can a=
dd
>> >> >>> more kfuncs instead of exposing the layout?
>> >> >>>
>> >> >>> bpf_xdp_metadata_export_to_skb(ctx);
>> >> >>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
>> >>=20
>> >
>> > Hi Toke,
>> >
>> > Trying not to bifurcate your thread. Can I start a new one here to
>> > elaborate on these use cases. I'm still a bit lost on any use case
>> > for this that makes sense to actually deploy on a network.
>> >
>> >> There are several use cases for needing to access the metadata after
>> >> calling bpf_xdp_metdata_export_to_skb():
>> >>=20
>> >> - Accessing the metadata after redirect (in a cpumap or devmap progra=
m,
>> >>   or on a veth device)
>> >
>> > I think for devmap there are still lots of opens how/where the skb
>> > is even built.
>>=20
>> For veth it's pretty clear; i.e., when redirecting into containers.
>
> Ah but I think XDP on veth is a bit questionable in general. The use
> case is NFV I guess but its not how I would build out NFV. I've never
> seen it actually deployed other than in CI. Anyways not necessary to
> drop into that debate here. It exists so OK.
>
>>=20
>> > For cpumap I'm a bit unsure what the use case is. For ice, mlx and
>> > such you should use the hardware RSS if performance is top of mind.
>>=20
>> Hardware RSS works fine if your hardware supports the hashing you want;
>> many do not. As an example, Jesper wrote this application that uses
>> cpumap to divide out ISP customer traffic among different CPUs (solving
>> an HTB scaling problem):
>>=20
>> https://github.com/xdp-project/xdp-cpumap-tc
>
> I'm going to argue hw should be able to do this still and we
> should fix the hw but maybe not easily doable without convincing
> hardware folks to talk to us.

Sure, in the ideal world the hardware should just be able to do this.
Unfortunately, we don't live in that ideal world :)

> Also not obvious tto me how linked code works without more studying,
> its ingress HTB? So you would push the rxhash and timestamp into
> cpumap and then build the skb here with the correct skb->timestamp?

No, the HTB tree is on egress. The use case is an ISP middlebox that
shapes (say) 1000 customers to their subscribed rate, using a big HTB
tree. If you just do this with a single HTB instance on the egress NIC
you run into the global qdisc lock and you can't scale beyond a pretty
measly bandwidth. Whereas if you use multiple HW TXQs and the mq qdisc,
you can partition the HTB tree so you only have a subset of customers on
each HWQ/HTB instance. But for this to work, and still guarantee each
customer gets shaped to the right rate, you need to ensure that all that
customer's traffic hits the same HWQ. The xdp-cpumap-tc tool does this
by configuring the TXQs to correspond to individual CPUs, and then runs
an XDP program that matches traffic to customers and redirects them to
the right CPU (using an LPM map).

This solution runs in production in quite a number of smallish WISPs,
BTW, with quite nice results. The software to set it all up is also open
sourced: https://libreqos.io/

Coming back to HW metadata, the LibreQoS system could benefit from the
hardware flow hash in particular, since that would save a hash operation
when enqueueing the packet into sch_cake.

> OK even if I can't exactly find the use case for cpumap if I had
> a use case I can see how passing metadata through is useful.

Great!

>> > And then for specific devices on cpumap (maybe realtime or ptp
>> > things?) could we just throw it through the xdp_frame?
>>=20
>> Not sure what you mean here? Throw what through the xdp_frame?
>
> Doesn't matter reread patches and figured it out I was slightly
> confused.

Right, OK.

>>=20
>> >> - Transferring the packet+metadata to AF_XDP
>> >
>> > In this case we have the metadata and AF_XDP program and XDP program
>> > simply need to agree on metadata format. No need to have some magic
>> > numbers and driver specific kfuncs.
>>=20
>> See my other reply to Martin: Yeah, for AF_XDP users that write their
>> own kernel XDP programs, they can just do whatever they want. But many
>> users just rely on the default program in libxdp, so having a standard
>> format to include with that is useful.
>>=20
>
> I don't think your AF_XDP program is any different than other AF_XDP
> programs. Your lib can create a standard format if it wants but
> kernel doesn't need to enforce it anyway.

Yeah, we totally could. But since we're defining a "standard" format for
kernel (skb) consumption anyway, making this available to AF_XDP is
kinda convenient so we don't have to :)

>> >> - Returning XDP_PASS, but accessing some of the metadata first (wheth=
er
>> >>   to read or change it)
>> >>=20
>> >
>> > I don't get this case? XDP_PASS should go to stack normally through
>> > drivers build_skb routines. These will populate timestamp normally.
>> > My guess is simply descriptor->skb load/store is cheaper than carrying
>> > around this metadata and doing the call in BPF side. Anyways you
>> > just built an entire skb and hit the stack I don't think you will
>> > notice this noise in any benchmark.
>>=20
>> If you modify the packet before calling XDP_PASS you may want to update
>> the metadata as well (for instance the RX hash, or in the future the
>> metadata could also carry transport header offsets).
>
> OK. So when you modify the pkt fixing up the rxhash makes sense. Thanks
> for the response I can see the argument.

Great! You're welcome :)

-Toke

