Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52337682F6C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjAaOik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAaOij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:38:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1A05B95
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:38:36 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id n6so11960127edo.9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CM90C1hIDCOcuqgsaAT3C7sRdlZjaO5k2QqE3aWUAHk=;
        b=4a7GgGnkNnk340PoIGp91AScwgV2DQt/yZBRyKbI3D3K+GXa//kC12NcxMnS6X4zzD
         /jvJxndJiHzER+mxOLLxN7ziuG/CS70sM+QzevY00pYMhzOlwgqSjcRuBtw5lNUv1Jg0
         PubkFwpmDdJ/GQlXM5I2NbDS8+yS/C0Ny2pTemMt5vZjDSIFXxxYapi5ccZSf7jX+OBx
         IlKIQzSW6wAHeYWrgbMFAR1KQpe2B1AkPGwgRYYDB4igHoc8MFmRVr6zfxpWXrK9fQqs
         dQSCM7yuKDsD4qBQkVgMnPxURdBcFB2q2k03/E62nFhOBBdu1JB1+ZGBSNSMJYKny7KF
         x59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CM90C1hIDCOcuqgsaAT3C7sRdlZjaO5k2QqE3aWUAHk=;
        b=J3NBCx8XPGd7aPwg7dwcw7ErlksisjYYlttXGaI2+iHJ6c+ysIHPEtn90JjWfITZKO
         Cfiz9b2Mims7X7+rxt9Dc3jIAgvAyI0djJNFOOXtU8xc3ogrTndd2WZXMuLPoA+vORkM
         NLinrrfGLfN4aIgBjpdal30cpNqApFg7dwgXx/n/gaIM9qm8/iAfy4OFhNT4P+H1MYeT
         rlPgB9x/npvM3Y/NO0mMWSEaXG9bMOV7ADEG/hoEvsOQDn3670k1TRjEz5LE/kbxKGIW
         GyPXh4kMu/8PKllbWzKf8HxvvXczlolFWRzW0P3T1mCVtmNADdwchtgewGJsdXW1A2dp
         GRgg==
X-Gm-Message-State: AO0yUKWqFsDBPM6SSMGUSdqFmCoGNxuRvMZADbdLOe1eNpSK//3qoJpf
        CUbRdMhLBEJLaehYM/e/CGJyEg==
X-Google-Smtp-Source: AK7set9+RcnlHbh5DCVOuavl31xqlO7F06zzM9dn8Diw6aslXDBzeV6ZTTjrQPnFfmBYKEIVi2EuPQ==
X-Received: by 2002:aa7:d69a:0:b0:4a2:dac:d2a4 with SMTP id d26-20020aa7d69a000000b004a20dacd2a4mr18178014edr.9.1675175915198;
        Tue, 31 Jan 2023 06:38:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z4-20020a170906714400b0087223b8d6efsm8639974ejj.16.2023.01.31.06.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:38:34 -0800 (PST)
Date:   Tue, 31 Jan 2023 15:38:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
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
Message-ID: <Y9kn6bh8z11xWsDh@nanopsycho>
References: <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk>
 <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6w6vqyd.fsf@toke.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 01:17:14PM CET, toke@redhat.com wrote:
>Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
>> Toke, i dont think i have managed to get across that there is an
>> "autonomous" control built into the kernel. It is not just things that
>> come across netlink. It's about the whole infra.
>
>I'm not disputing the need for the TC infra to configure the pipelines
>and their relationship in the hardware. I'm saying that your
>implementation *of the SW path* is the wrong approach and it would be
>better done by using BPF (not talking about the existing TC-BPF,
>either).
>
>It's a bit hard to know your thinking for sure here, since your patch
>series doesn't include any of the offload control bits. But from the
>slides and your hints in this series, AFAICT, the flow goes something
>like:
>
>hw_pipeline_id = devlink_program_hardware(dev, p4_compiled_blob);
>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>
>tc_act = tc_act_create(hw_pipeline_id, sw_pipeline_id)
>
>which will turn into something like:
>
>struct p4_cls_offload ofl = {
>  .classid = classid,
>  .pipeline_id = hw_pipeline_id
>};
>
>if (check_sw_and_hw_equivalence(hw_pipeline_id, sw_pipeline_id)) /* some magic check here */
>  return -EINVAL;
>
>netdev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_P4, &ofl);
>
>
>I.e, all that's being passed to the hardware is the ID of the
>pre-programmed pipeline, because that programming is going to be
>out-of-band via devlink anyway.
>
>In which case, you could just as well replace the above:
>
>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>
>with
>
>sw_pipeline_id = bpf_prog_load(BPF_PROG_TYPE_P4TC, "my_obj_file.o"); /* my_obj_file is created by P4c */
>
>and achieve exactly the same.
>
>Having all the P4 data types and concepts exist inside the kernel
>*might* make sense if the kernel could then translate those into the
>hardware representations and manage their lifecycle in a uniform way.
>But as far as I can tell from the slides and what you've been saying in
>this thread that's not going to be possible anyway, so why do you need
>anything more granular than the pipeline ID?

Toke, I understand what what you describe above is applicable for the P4
program instantiation (pipeline definition).

What is the suggestion for the actual "rule insertions" ? Would it make
sense to use TC iface (Jamal's or similar) to insert rules to both BPF SW
path and offloaded HW path?


>
>-Toke
>
