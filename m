Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B93343A5A0
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhJYVRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbhJYVRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:17:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85934C061224
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:14:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f11so12127728pfc.12
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z00lUsatKc2imgSiGWIDZF0uIcC3k7FGBboNiOBf+rE=;
        b=eId9LLzyLrwvA9SohTjGnv3oVmE6ccHoQVKehocpPnrGwwPgiFRy84ppKNC+f37VpV
         mRt73YFIU/x33pg3q5YAAetghE/xrqlePxhK0vjYN35FOjfLpjl+tvmFfeY2XYDAeKh6
         sn/dyNA2Nqsw61mI5VTCzsVgIk1CFPaNCLrGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z00lUsatKc2imgSiGWIDZF0uIcC3k7FGBboNiOBf+rE=;
        b=OUD29kehvOjysTW4N0fppesFTmrZQ+9rOnS3ijWDrEV7BR/tSlq6FzePeU76gHntoJ
         rCNei2Vm9qq2AcpAnZAGJrI+N+u2Pw/uLauJ2an5RWL+V/YGAfE/SHGLv2xS5iacH6Vr
         +3oDwx4LSPksdkTqOGZuRzQk2Z9n8RE9KUY0GFFpqEYHsugpnpttPX8lHNzFWVGQbdmO
         rrzNm2km2erAuGGjOi5rHBjHryxvoEQqSFVPS8eEVYTTlezk6U14hJWEuZN5SzZmX2+L
         rwO+XALPZudBK9tRiIuyxdR/j+Bj4EyvDsHqhk5VGhEsCIsFCSAi6FGE8WLRPjMgpjCa
         2Q0Q==
X-Gm-Message-State: AOAM531R1tF2JAHYccTKi1fbvmVoqpVGOXIegKaSuKI3NzbDed4A29rx
        ZLlqcM1Qa6yKY5Xa1qDGKTLiWA==
X-Google-Smtp-Source: ABdhPJxC8V4in0W+okVM7nD41XtGYGFz6iLA1Rdh91iNuWdlW5+5qNUga5c7e3xlWKMxb0NrgoI4Ww==
X-Received: by 2002:a05:6a00:2388:b0:44d:4b5d:d5e with SMTP id f8-20020a056a00238800b0044d4b5d0d5emr20949254pfc.80.1635196477239;
        Mon, 25 Oct 2021 14:14:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t3sm16694772pgu.87.2021.10.25.14.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 14:14:36 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:14:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        valentin.schneider@arm.com, qiang.zhang@windriver.com,
        robdclark@chromium.org, christian@brauner.io,
        dietmar.eggemann@arm.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v6 03/12] drivers/connector: make connector comm always
 nul ternimated
Message-ID: <202110251411.93B477676B@keescook>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-4-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025083315.4752-4-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:33:06AM +0000, Yafang Shao wrote:
> connector comm was introduced in commit
> f786ecba4158 ("connector: add comm change event report to proc connector").
> struct comm_proc_event was defined in include/linux/cn_proc.h first and
> then been moved into file include/uapi/linux/cn_proc.h in commit
> 607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux").
> 
> As this is the UAPI code, we can't change it without potentially breaking
> things (i.e. userspace binaries have this size built in, so we can't just
> change the size). To prepare for the followup change - extending task
> comm, we have to use __get_task_comm() to avoid the BUILD_BUG_ON() in
> proc_comm_connector().

I wonder, looking at this again, if it might make more sense to avoid
this cn_proc.c change, and instead, adjust get_task_comm() like so:

#define get_task_comm(buf, tsk)
        __get_task_comm(buf, __must_be_array(buf) + sizeof(buf), tsk)

This would still enforce the original goal of making sure
get_task_comm() is being used on a char array, and now that
__get_task_comm() will truncate & pad, it's safe to use on both
too-small and too-big arrays.

-- 
Kees Cook
