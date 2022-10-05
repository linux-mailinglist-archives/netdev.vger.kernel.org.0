Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472665F5674
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJEOcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJEOc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300B972EEB
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 07:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664980347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tObMQCdQ5lmhGEfWf1G2BnwejS8NcVQfKMZ4dQuOMzs=;
        b=Vxw4P2IuHE5f2hkwhPxYjdtVosMxHq3OeUWlpxhRb55uc1DCMMfVU8VCXDMBjeyGI+wtKk
        V10UBAKmuz8k9GjzWIBUd5IGQ8iNUlZ48BbizRPdEuDwdmJah+9503SBg9pKHD7Ip+xGi3
        axlPYTT/Lclovj31JWQ87WbUeXf82sA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-422-HK25Oxx3PHO7pthGumj-1A-1; Wed, 05 Oct 2022 10:32:26 -0400
X-MC-Unique: HK25Oxx3PHO7pthGumj-1A-1
Received: by mail-ed1-f71.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so13612757eda.19
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 07:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tObMQCdQ5lmhGEfWf1G2BnwejS8NcVQfKMZ4dQuOMzs=;
        b=BgJqQkW+lDgll8V1sv+bE7DcisLk38osBoIuBX+PyMDiB+wp7OHtlF/erO92KM1ak0
         xaC9oKasgGpkDT+lDTAJ6sSEJY4mRL3OQMRL913IY2d8OymBPwP7UWj9qz8o+4pBHQ5v
         hSYx0wXYvOGFTnZlWU4Q8u8pINae255FwBP26KLX28oZjB0+sCunOYFzn1wPGFY26vhg
         ubg1uDZk7IyEuiRJCOIyTBElJ4ec9P62BS1GqUqTHUpBRWdU9IBeqveFldJdNrpHbypu
         S24Wr2jQ/Dl1++afb+eP9e2vngZPdOUX9GTtBzWp8p7rHxf67IToRoJN/U3OSraPstUp
         VWuQ==
X-Gm-Message-State: ACrzQf0zEnbSItZaWKCnzOtF5GwfuH2agC8gPuHdOz0Q4cM07e/sr6fo
        LsdOlxOScQ3i64XHrvgBnmMZM1nr9/DLTBtGszJ20t03RwsJOXX6ek3R6MlQDFKuUcZ4SrjGV5v
        NbPlwQNJy8oCDlnJn
X-Received: by 2002:aa7:cfc4:0:b0:459:7fa7:ee29 with SMTP id r4-20020aa7cfc4000000b004597fa7ee29mr43162edy.414.1664980344949;
        Wed, 05 Oct 2022 07:32:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM42hwJh/HghS6gIi4751Sbigc/2qbv0QE2vCVQMGtKvzUxOB4o2QM8m4GamdJlVRWdwnPFMng==
X-Received: by 2002:aa7:cfc4:0:b0:459:7fa7:ee29 with SMTP id r4-20020aa7cfc4000000b004597fa7ee29mr43132edy.414.1664980344506;
        Wed, 05 Oct 2022 07:32:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090632cb00b007030c97ae62sm8767269ejk.191.2022.10.05.07.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 07:32:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E996264EBBE; Wed,  5 Oct 2022 16:32:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, joe@cilium.io,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
In-Reply-To: <3cc8a0c3-7767-12cf-f753-82e2df8ef293@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net> <87bkqqimpy.fsf@toke.dk>
 <3cc8a0c3-7767-12cf-f753-82e2df8ef293@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Oct 2022 16:32:22 +0200
Message-ID: <87wn9egx3d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/5/22 12:33 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>=20
>>> As part of the feedback from LPC, there was a suggestion to provide a
>>> name for this infrastructure to more easily differ between the classic
>>> cls_bpf attachment and the fd-based API. As for most, the XDP vs tc
>>> layer is already the default mental model for the pkt processing
>>> pipeline. We refactored this with an xtc internal prefix aka 'express
>>> traffic control' in order to avoid to deviate too far (and 'express'
>>> given its more lightweight/faster entry point).
>>=20
>> Woohoo, bikeshed time! :)
>>=20
>> I am OK with having a separate name for this, but can we please pick one
>> that doesn't sound like 'XDP' when you say it out loud? You really don't
>> have to mumble much for 'XDP' and 'XTC' to sound exactly alike; this is
>> bound to lead to confusion!
>>=20
>> Alternatives, in the same vein:
>> - ltc (lightweight)
>> - etc (extended/express/ebpf/et cetera ;))
>> - tcx (keep the cool X, but put it at the end)
>
> Hehe, yeah agree, I don't have a strong opinion, but tcx (or just sticking
> with tc) is fully okay to me.

Either is fine with me; I don't have any strong opinions either, other
than "not XTC" ;)

>> [...]
>>=20
>>> +/* (Simplified) user return codes for tc prog type.
>>> + * A valid tc program must return one of these defined values. All oth=
er
>>> + * return codes are reserved for future use. Must remain compatible wi=
th
>>> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
>>> + * return codes are mapped to TC_NEXT.
>>> + */
>>> +enum tc_action_base {
>>> +	TC_NEXT		=3D -1,
>>> +	TC_PASS		=3D 0,
>>> +	TC_DROP		=3D 2,
>>> +	TC_REDIRECT	=3D 7,
>>> +};
>>=20
>> Looking at things like this, though, I wonder if having a separate name
>> (at least if it's too prominent) is not just going to be more confusing
>> than not? I.e., we go out of our way to make it compatible with existing
>> TC-BPF programs (which is a good thing!), so do we really need a
>> separate name? Couldn't it just be an implementation detail that "it's
>> faster now"?
>
> Yep, faster is an implementation detail; and developers can stick to exis=
ting
> opcodes. I added this here given Andrii suggested to add the action codes=
 as
> enum so they land in vmlinux BTF. My thinking was that if we go this rout=
e,
> we could also make them more user friendly. This part is 100% optional,
> but for new developers it might lower the barrier a bit I was hoping given
> it makes it clear which subset of actions BPF supports explicitly and with
> less cryptic name.

Oh, I didn't mean that we shouldn't define these helpers; that's totally
fine, and probably useful. Just that when everything is named 'TC'
anyway, having a different name (like TCX) is maybe not that important
anyway?

>> Oh, and speaking of compatibility should 'tc' (the iproute2 binary) be
>> taught how to display these new bpf_link attachments so that users can
>> see that they're there?
>
> Sounds reasonable, I can follow-up with the iproute2 support as well.

Cool!

-Toke

