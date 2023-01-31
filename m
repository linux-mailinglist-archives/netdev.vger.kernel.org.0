Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2740E682C6A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjAaMSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjAaMSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:18:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0CC40BE2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675167439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kscQvCOlnmLTeTuEXG46fk0e4XgTZdYApC30tCuFi/8=;
        b=IN824g3cy8w1HFdUtyXz/ErtGCeMw0CUCSP/mtc5uvj+3H1ZPqBOeP9taxc2BDXupmBzpl
        Ng43Y3pzubLIUePEt/YJWGpkgbBabprtvCk2PzpmkxNI4Wc39iSzsii0LHZ2rLXRloD1Td
        Inmhos2Ga0F8wgQLKFnwFkIYp0QM9KE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-XxcE6Dd3OAqzREQPg5ZVwg-1; Tue, 31 Jan 2023 07:17:17 -0500
X-MC-Unique: XxcE6Dd3OAqzREQPg5ZVwg-1
Received: by mail-ed1-f69.google.com with SMTP id s3-20020a50ab03000000b0049ec3a108beso10447839edc.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:17:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kscQvCOlnmLTeTuEXG46fk0e4XgTZdYApC30tCuFi/8=;
        b=2kLCBYZNZv4g7pPpuLiUYyXWIX9HNE86xdJRalWRwmQFxuKr/g8UxWEtBUzi5cJzUD
         WCllkOsCabud7QEQtw2Vw0d4Py4vdS4qbhN7gP3EzfTkr/wNRjEaWThxTOAPa/ShW+5N
         bN5pC27JDojaY6b2zE90LSOpvZ3s41GSqPYw/bk0fSxyTRkH4j/92HKT8XgFOboWZD2b
         SODme7IAxhx1lmCwFFARlFQEf5LMtE28P/TGUkh2WpbcP+/cB+MfjkOR3f1ui4PGRthn
         tsTh7iwktHKQh5ujLOSxizoOP0GkympWWjkB9taZzvRb335VCSqfgrY7JjZkVp28KDvx
         p8fw==
X-Gm-Message-State: AFqh2krCgDjTjXZdlWXb+IvZFmXB5uQgLJ9iOEtrcGUC9qfjI8Q+BoHX
        zmJ8hd7DQNCD9qwkYO+8bcWSwwyl8UjrZsHaPqQL8Dy1drDPXFXyL99djYt9WVWZqVSiLGCcP/U
        xEGQ6SynrVhR+ex8a
X-Received: by 2002:a17:906:60d2:b0:872:6bd0:d2b with SMTP id f18-20020a17090660d200b008726bd00d2bmr49217732ejk.45.1675167436446;
        Tue, 31 Jan 2023 04:17:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuz+A3x3qQ9wL1iAsPDwbY6ysAQeP2j0QktRRl1mLHeJMhh4QmYqcd7WuvJGMfpHo6Or9d6QA==
X-Received: by 2002:a17:906:60d2:b0:872:6bd0:d2b with SMTP id f18-20020a17090660d200b008726bd00d2bmr49217706ejk.45.1675167436151;
        Tue, 31 Jan 2023 04:17:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ed10-20020a056402294a00b004a236384909sm3936277edb.10.2023.01.31.04.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:17:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 730E59727F6; Tue, 31 Jan 2023 13:17:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
In-Reply-To: <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Jan 2023 13:17:14 +0100
Message-ID: <87h6w6vqyd.fsf@toke.dk>
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

> Toke, i dont think i have managed to get across that there is an
> "autonomous" control built into the kernel. It is not just things that
> come across netlink. It's about the whole infra.

I'm not disputing the need for the TC infra to configure the pipelines
and their relationship in the hardware. I'm saying that your
implementation *of the SW path* is the wrong approach and it would be
better done by using BPF (not talking about the existing TC-BPF,
either).

It's a bit hard to know your thinking for sure here, since your patch
series doesn't include any of the offload control bits. But from the
slides and your hints in this series, AFAICT, the flow goes something
like:

hw_pipeline_id = devlink_program_hardware(dev, p4_compiled_blob);
sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)

tc_act = tc_act_create(hw_pipeline_id, sw_pipeline_id)

which will turn into something like:

struct p4_cls_offload ofl = {
  .classid = classid,
  .pipeline_id = hw_pipeline_id
};

if (check_sw_and_hw_equivalence(hw_pipeline_id, sw_pipeline_id)) /* some magic check here */
  return -EINVAL;

netdev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_P4, &ofl);


I.e, all that's being passed to the hardware is the ID of the
pre-programmed pipeline, because that programming is going to be
out-of-band via devlink anyway.

In which case, you could just as well replace the above:

sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)

with

sw_pipeline_id = bpf_prog_load(BPF_PROG_TYPE_P4TC, "my_obj_file.o"); /* my_obj_file is created by P4c */

and achieve exactly the same.

Having all the P4 data types and concepts exist inside the kernel
*might* make sense if the kernel could then translate those into the
hardware representations and manage their lifecycle in a uniform way.
But as far as I can tell from the slides and what you've been saying in
this thread that's not going to be possible anyway, so why do you need
anything more granular than the pipeline ID?

-Toke

