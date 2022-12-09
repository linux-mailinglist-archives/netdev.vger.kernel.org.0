Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC388647AA4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLIAP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiLIAPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:15:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599AB82F9D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670544861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4T5sBCl/3CDxr25zUnGc9p87c5wEBV2/DlcV/PFZ2Ac=;
        b=FnDez4fvD962bYTx6NEwirqIOXQUdWKcChdP9c/FI222X+dpqAV3D6PAbPUa0jKwzBXNRf
        kLGekOQjzdpavTmYFwlm/KZmCr+NE+p4UBLjhSEr2gdP821NDjaaX3hDDpHM2G8J057iFi
        Cdu2oM9uwpwv8MfFOgv9OeqYyPJy8ZE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-282-aHLDpafUMyyvbnE5MPAAqQ-1; Thu, 08 Dec 2022 19:14:18 -0500
X-MC-Unique: aHLDpafUMyyvbnE5MPAAqQ-1
Received: by mail-ed1-f72.google.com with SMTP id b13-20020a056402350d00b00464175c3f1eso401081edd.11
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 16:14:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4T5sBCl/3CDxr25zUnGc9p87c5wEBV2/DlcV/PFZ2Ac=;
        b=sEdmxxkt0Iozbr++BwKqYlQdVxNlT+EjTFcn1HI+GPVpTcJKZxQogjdeRBycXmPxO/
         rFz6ZGrk5w2SsZb4nofAu96j4vaMiAznunLyywrKdzBsdB+ng0GAVXbHu5jF143vQI4F
         L3kbNG5j2Zhui9jl9YYMJJ/MkkG9MRoPfEEFWSzJQ3y+gNYW4k19R1XceIt+B400khA2
         6QduOfz7Nf6PtGzeOodocWTOjXyBhGZPSt694hRmE7JZjKpEyCq3oEa7ptJYCFy+ldqP
         x4dAueA30qUzshXHdNImTBTXeTVqTnPdHSia2bqLXzJi9Xy7ucDE56gmL5D0QHXb0YL3
         HJYg==
X-Gm-Message-State: ANoB5pkPIuCqKTkKrSVUP3UiDbb4sjm12SM9T9NMm+AWfbeZ6JvFL+Rb
        L9cmJXB9KGIzzj1wGl4pWFoOe5+fm4YWO7+7fEoA0bdYq1UdZsW6N6jB7EswkDSJZI8axITiD/k
        rFUtAO7Gf9hW4cC9O
X-Received: by 2002:a05:6402:3985:b0:461:3ae6:8bfc with SMTP id fk5-20020a056402398500b004613ae68bfcmr3791870edb.34.1670544856452;
        Thu, 08 Dec 2022 16:14:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4pGscj4T39ekLdKdM3k2JNhFGEY2EQzfwP35Z/evcQY53JRadCWkl1oFCQPRUO4A24tOytvg==
X-Received: by 2002:a05:6402:3985:b0:461:3ae6:8bfc with SMTP id fk5-20020a056402398500b004613ae68bfcmr3791804edb.34.1670544854791;
        Thu, 08 Dec 2022 16:14:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u26-20020a05640207da00b0046bc2f432dasm20515edy.22.2022.12.08.16.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:14:14 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B62382E9C9; Fri,  9 Dec 2022 01:14:13 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/12] xdp: hints via kfuncs
In-Reply-To: <CAKH8qBuzpiXrL5SOxd1u0-zim+Kf166DRUDT0PuR081f-ad2-Q@mail.gmail.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <87bkodleca.fsf@toke.dk>
 <CAKH8qBuzpiXrL5SOxd1u0-zim+Kf166DRUDT0PuR081f-ad2-Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Dec 2022 01:14:13 +0100
Message-ID: <87wn71juwa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Thu, Dec 8, 2022 at 2:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > Please see the first patch in the series for the overall
>> > design and use-cases.
>> >
>> > Changes since v3:
>> >
>> > - Rework prog->bound_netdev refcounting (Jakub/Marin)
>> >
>> >   Now it's based on the offload.c framework. It mostly fits, except
>> >   I had to automatically insert a HT entry for the netdev. In the
>> >   offloaded case, the netdev is added via a call to
>> >   bpf_offload_dev_netdev_register from the driver init path; with
>> >   a dev-bound programs, we have to manually add (and remove) the entry.
>> >
>> >   As suggested by Toke, I'm also prohibiting putting dev-bound programs
>> >   into prog-array map; essentially prohibiting tail calling into it.
>> >   I'm also disabling freplace of the dev-bound programs. Both of those
>> >   restrictions can be loosened up eventually.
>>
>> I thought it would be a shame that we don't support at least freplace
>> programs from the get-go (as that would exclude libxdp from taking
>> advantage of this). So see below for a patch implementing this :)
>>
>> -Toke
>
> Damn, now I need to write a selftest :-)
> But seriously, thank you for taking care of this, will try to include
> preserving SoB!

Cool, thanks! I just realised I made on mistake in the attach check,
though:

[...]

>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index b345a273f7d0..606e6de5f716 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -3021,6 +3021,14 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog,
>>                         goto out_put_prog;
>>                 }
>>
>> +               if (bpf_prog_is_dev_bound(tgt_prog->aux) &&
>> +                   (bpf_prog_is_offloaded(tgt_prog->aux) ||
>> +                    !bpf_prog_is_dev_bound(prog->aux) ||
>> +                    !bpf_offload_dev_match(prog, tgt_prog->aux->offload=
->netdev))) {

This should switch the order of the is_dev_bound() checks, like:

+               if (bpf_prog_is_dev_bound(prog->aux) &&
+                   (bpf_prog_is_offloaded(tgt_prog->aux) ||
+                    !bpf_prog_is_dev_bound(tgt_prog->aux) ||
+                    !bpf_offload_dev_match(prog, tgt_prog->aux->offload->n=
etdev))) {

I.e., first check bpf_prog_is_dev_bound(prog->aux) (the program being
attached), and only perform the other checks if we're attaching
something that has been verified as being dev-bound. It should be fine
to attach a non-devbound function to a devbound parent program (since
that non-devbound function can't call any of the kfuncs).

-Toke

