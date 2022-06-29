Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1385605A1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiF2QTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiF2QTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:19:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE23220F4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:19:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f8-20020a17090ac28800b001ed312c6fe1so5791267pjt.8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7SL+gVI/1fryiXm08kyzMRVdUsXymda8l5P6QPOWawE=;
        b=H3XcadEg4vciLzRz4FYeNoHZOSwjncFglokoX9llcnmukYNDhHjrIB04MiFmu7CxYz
         w7DQanNzY6SkkhfvrLFmJQZYQavVHw870ZBd7aTe3byVVv09skv3qtPgqKOlnvhVZ02/
         TvgePho6cduPYSwAp4/faB2iAr7nFu9MxuwzFCF7s/F1Pntxw1e//yResZoiJTrAyya2
         J+zoNVcXW1sDERfnfj+qx0gRkaO147nKB49rFLGqIgC6IpB+hRcf24Ss6iaWVdNXKHxQ
         7G+SHkU4Ud/2CPS5tXyFHEiYjKre9PmvEVMCrNRZboQ9mcUZzPP2mkIsfURel/Xf27Dj
         FVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7SL+gVI/1fryiXm08kyzMRVdUsXymda8l5P6QPOWawE=;
        b=bessWFWexDY5Ed+mt4W3BvGE12JsVNobT7NhnlKSHwf3ajoWDI73/2OPwLIdbohx6q
         XpSNdeeqqtQ9OMS+X983dRzudsnuSbvx7a+/fJOXMBEnmdsuIUk7UpaTpY8XGKnAW5or
         ATGIr5uvk8S3oGonL1BB6Z4S1BJJdO2p8p9tHGkN6cOokthAYiVv3lSbKT0ka52TMQKH
         mUprM/SWVKUXKieRDtp05x70FCC29TVepYem0pkYVJPbW3kVZsnhiVywvLPdzttVf/lb
         SRKVGFGFhJaz3WU8apxxitFB9idJneExFQfIB6EraG5NgrhuXxQh7GXJdyKYngUBWElB
         0m8Q==
X-Gm-Message-State: AJIora9iwFbx9HmsosQfvtcWtrN7NxJJssT5sXrx7uBZPcnAVpWd79ra
        HC1lUd4LJ7n3I/tDG3NGUPtvGDk=
X-Google-Smtp-Source: AGRyM1u1W1f8DXAze5wNrV2deRxfeHXDBJqxZSrE/Dzb/pWBlmtNMjFV7O+3nTvmyiPBF4d8LWK4ilY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:d904:b0:1ec:730c:bcac with SMTP id
 c4-20020a17090ad90400b001ec730cbcacmr6665641pjv.93.1656519550556; Wed, 29 Jun
 2022 09:19:10 -0700 (PDT)
Date:   Wed, 29 Jun 2022 09:19:08 -0700
In-Reply-To: <20220629111351.47699-1-quentin@isovalent.com>
Message-Id: <Yrx7fFFOC0Emzorz@google.com>
Mime-Version: 1.0
References: <20220629111351.47699-1-quentin@isovalent.com>
Subject: Re: [PATCH bpf-next v2] bpftool: Probe for memcg-based accounting
 before bumping rlimit
From:   sdf@google.com
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/29, Quentin Monnet wrote:
> Bpftool used to bump the memlock rlimit to make sure to be able to load
> BPF objects. After the kernel has switched to memcg-based memory
> accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
> for memcg-based accounting support and for raising the rlimit if
> necessary [1]. But this was later reverted, because the probe would
> sometimes fail, resulting in bpftool not being able to load all required
> objects [2].

> Here we add a more efficient probe, in bpftool itself. We first lower
> the rlimit to 0, then we attempt to load a BPF object (and finally reset
> the rlimit): if the load succeeds, then memcg-based memory accounting is
> supported.

> This approach was earlier proposed for the probe in libbpf itself [3],
> but given that the library may be used in multithreaded applications,
> the probe could have undesirable consequences if one thread attempts to
> lock kernel memory while memlock rlimit is at 0. Since bpftool is
> single-threaded and the rlimit is process-based, this is fine to do in
> bpftool itself.

> This probe was inspired by the similar one from the cilium/ebpf Go
> library [4].

> v2:
> - Simply use sizeof(attr) instead of hardcoding a size via
>    offsetofend().
> - Set r0 = 0 before returning in sample program.

> [0] commit 97306be45fbe ("Merge branch 'switch to memcg-based memory  
> accounting'")
> [1] commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of  
> RLIMIT_MEMLOCK")
> [2] commit 6b4384ff1088 ("Revert "bpftool: Use libbpf 1.0 API mode  
> instead of RLIMIT_MEMLOCK"")
> [3]  
> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/t/#u
> [4] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

> Cc: Stanislav Fomichev <sdf@google.com>

Reviewed-by: Stanislav Fomichev <sdf@google.com>
