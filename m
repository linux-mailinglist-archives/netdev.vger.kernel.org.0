Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D426839B7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjAaWyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjAaWyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:54:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2DD26AF
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675205642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/fhAyqhbHHk4Qeba+vupFvDbyZeKLdXhlhNHJowAPuQ=;
        b=Mi+pLfjcxH4gx0lTwOVJEQAn/fxichfDXii6VASsxezeL82B5ND8vlzdPMIFCngbH83tt3
        Bt5pmeJyfdMz2d0KwKu167wJmPIJqQ4tUmwrTls2sS6oAqBJoaSJzxfPHRJfZKfMV/+87t
        1v02GXPBfKKI3iJU2KTRN4cPhrWLS0I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-RESR_ow-OSSj8mmlEsiE1g-1; Tue, 31 Jan 2023 17:54:00 -0500
X-MC-Unique: RESR_ow-OSSj8mmlEsiE1g-1
Received: by mail-ed1-f72.google.com with SMTP id en20-20020a056402529400b004a26ef05c34so1977650edb.16
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fhAyqhbHHk4Qeba+vupFvDbyZeKLdXhlhNHJowAPuQ=;
        b=CFZn4nSRRu3mlUxORF273MXYXhY54PLfVmyIDk5YEd1fukOeGh43K6p5tLuF95vtLg
         65WM+VgQu9jOS1Yy8/wtHEWfC1AdYEHwiNJle5mJ5AXs4s3VBtn7WuEm2efE+9wk1nwT
         80Wb2JqyL0Jm6QHm56NpwnO7uF7HaT3K6gCxRUBlJrcJf9n+ckXmRzLiaPd11nOpbW5o
         97eck9A3O92cIT49jCHVn8fhZ4aW/uqAxF+6Rh5PvPp43e9iIVkpqm5wqNWdKlKj9Cge
         y6cYa4x6e59zqXJ1Nhl004vNM/NDf5e4UR9/7fB694RuEN2pnFKJRivBIMcnasBOFBsL
         KAvg==
X-Gm-Message-State: AO0yUKV44D7wr4F1n8h/JGchO80Mql3cX2ErfPme1pVBUPPl4IqEqMzZ
        LbJzqvrhk7BmyyOMKtD2iN+biD0N93WGmrMu0B42T6hnoeqkVAlGaACVOxELPFHGZUP7aJOOwxL
        EyAgAzWoz98vWAshs
X-Received: by 2002:a17:907:9950:b0:878:5bce:291e with SMTP id kl16-20020a170907995000b008785bce291emr136275ejc.2.1675205638719;
        Tue, 31 Jan 2023 14:53:58 -0800 (PST)
X-Google-Smtp-Source: AK7set8nLMadEPBW/u+Xs/1co9KTo3/6aoAiFefSQFzi08uWartYfTnMYBhNCizVk2czXeABjmSAUg==
X-Received: by 2002:a17:907:9950:b0:878:5bce:291e with SMTP id kl16-20020a170907995000b008785bce291emr136225ejc.2.1675205637806;
        Tue, 31 Jan 2023 14:53:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q18-20020a1709064c9200b0085ff3202ce7sm9073124eju.219.2023.01.31.14.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:53:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E0B729728D7; Tue, 31 Jan 2023 23:53:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho>
 <87357qvdso.fsf@toke.dk>
 <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Jan 2023 23:53:55 +0100
Message-ID: <87o7qe2u4c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> So while going through this thought process, things to consider:
> 1) The autonomy of the tc infra, essentially the skip_sw/hw  controls
> and their packet driven iteration. Perhaps (the patch i pointed to
> from Paul Blakey) where part of the action graph runs in sw.

Yeah, I agree that mixed-mode operation is an important consideration,
and presumably attaching metadata directly to a packet on the hardware
side, and accessing that in sw, is in scope as well? We seem to have
landed on exposing that sort of thing via kfuncs in XDP, so expanding on
that seems reasonable at a first glance.

> 2) The dynamicity of being able to trigger table offloads and/or
> kernel table updates which are packet driven (consider scenario where
> they have iterated the hardware and ingressed into the kernel).

That could be done by either interface, though: the kernel can propagate
a bpf_map_update() from a BPF program to the hardware version of the
table as well. I suspect a map-based API at least on the BPF side would
be more natural, but I don't really have a strong opinion on this :)

-Toke

