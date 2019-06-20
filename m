Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AB04C46E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfFTAYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:24:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35999 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFTAYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 20:24:41 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so396746ioh.3;
        Wed, 19 Jun 2019 17:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0rPREAEEvj0DOdC10jYRNjjv2DqithI2viZzgrekVqs=;
        b=hKl42BpjP60NrTP7OWfGLyM0B/u5WDL86RzUL9BdJcIawshcqe1GLHTHeD/6xtLLea
         qW4o3/XoiU+vbbfh/KfH/MD6Y5NysjmhKXhkQvVNa/4pHRAJ0Tls5mi2//gbm9y/pcGh
         SZ1wqidZRbinaMxuhLydHzN0AzCZ2yl+bLvtZDL07jjC0xPksmivhuPVNEKXsVg9j9go
         +PlBGlygQy2pcBoHrrygkQiUI5TTQ52PEfM+tffK9iEtCOqPoNNidZ/QvAVT/E/KOCp1
         RSC3YVyN/9gd/EM2lVEOpfNjLJ/qpegYqryV1zkexvpZOz837VJonqp5dG9Y/aNU2pNb
         2eTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0rPREAEEvj0DOdC10jYRNjjv2DqithI2viZzgrekVqs=;
        b=IfVDI4gZHnWz83YMpTxfCY0AWwXB/zzZ1Rl5WXMgODuFU5SD8Vvfykb5w6IKQx/n5O
         Hh+rU73PdZVIyBLAIXhL72XvfzS9pcqWL0G0X6WPIob+Rfu/dqniCVe4K5mNYgKuca5X
         njwME7F0M13gvw57ElmaWw7ZzWQzSUpSIdd26oJp+i0TkHj5Orx094FNCGNVNM57ZJjQ
         rTPDZnjaH/+i/7HraHL8UMJiv9OLp0rUaDhV/q5o+1PbNuWrOoLsOAnytMbR6iPwmnGZ
         k7t6w7Wemd3G0kltMCRmqmkeVTyIFbTQMQbHU2dTpS7wYNZwG3awN3lDufhoFKOer3U2
         mccA==
X-Gm-Message-State: APjAAAXY60NecbTEnKn4HCvUu7QW2fOjlrIo39eyOtOfUvROEYaMRMTt
        tBSO18a8lgqyufEaIDF7Ah8=
X-Google-Smtp-Source: APXvYqxakt5e35+Kzf+yWcvKUUOB5oHMyefqtHfk8mUyO3hgWDj7ZszUGijykPc5XlTW2lkoCpBjrQ==
X-Received: by 2002:a6b:6012:: with SMTP id r18mr1972276iog.241.1560990280452;
        Wed, 19 Jun 2019 17:24:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b14sm23560790iod.33.2019.06.19.17.24.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 17:24:40 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:24:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5d0ad24027106_8822adea29a05b47c@john-XPS-13-9370.notmuch>
In-Reply-To: <20190615191225.2409862-2-ast@kernel.org>
References: <20190615191225.2409862-1-ast@kernel.org>
 <20190615191225.2409862-2-ast@kernel.org>
Subject: RE: [PATCH v3 bpf-next 1/9] bpf: track spill/fill of constants
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> Compilers often spill induction variables into the stack,
> hence it is necessary for the verifier to track scalar values
> of the registers through stack slots.
> 
> Also few bpf programs were incorrectly rejected in the past,
> since the verifier was not able to track such constants while
> they were used to compute offsets into packet headers.
> 
> Tracking constants through the stack significantly decreases
> the chances of state pruning, since two different constants
> are considered to be different by state equivalency.
> End result that cilium tests suffer serious degradation in the number
> of states processed and corresponding verification time increase.
> 
>                      before  after
> bpf_lb-DLB_L3.o      1838    6441
> bpf_lb-DLB_L4.o      3218    5908
> bpf_lb-DUNKNOWN.o    1064    1064
> bpf_lxc-DDROP_ALL.o  26935   93790
> bpf_lxc-DUNKNOWN.o   34439   123886
> bpf_netdev.o         9721    31413
> bpf_overlay.o        6184    18561
> bpf_lxc_jit.o        39389   359445
> 
> After further debugging turned out that cillium progs are
> getting hurt by clang due to the same constant tracking issue.
> Newer clang generates better code by spilling less to the stack.
> Instead it keeps more constants in the registers which
> hurts state pruning since the verifier already tracks constants
> in the registers:
>                   old clang  new clang
>                          (no spill/fill tracking introduced by this patch)
> bpf_lb-DLB_L3.o      1838    1923
> bpf_lb-DLB_L4.o      3218    3077
> bpf_lb-DUNKNOWN.o    1064    1062
> bpf_lxc-DDROP_ALL.o  26935   166729
> bpf_lxc-DUNKNOWN.o   34439   174607
                       ^^^^^^^^^^^^^^
Any idea what happened here? Going from 34439 -> 174607 on the new clang?

> bpf_netdev.o         9721    8407
> bpf_overlay.o        6184    5420
> bpf_lcx_jit.o        39389   39389
> 
> The final table is depressing:
>                   old clang  old clang    new clang  new clang
>                            const spill/fill        const spill/fill
> bpf_lb-DLB_L3.o      1838    6441          1923      8128
> bpf_lb-DLB_L4.o      3218    5908          3077      6707
> bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
> bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
> bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
> bpf_netdev.o         9721    31413         8407      31904
> bpf_overlay.o        6184    18561         5420      23569
> bpf_lxc_jit.o        39389   359445        39389     359445
> 
> Tracking constants in the registers hurts state pruning already.
> Adding tracking of constants through stack hurts pruning even more.
> The later patch address this general constant tracking issue
> with coarse/precise logic.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/verifier.c | 90 +++++++++++++++++++++++++++++++------------
>  1 file changed, 65 insertions(+), 25 deletions(-)

I know these are already in bpf-next sorry it took me awhile to get
time to review, but looks good to me. Thanks! We had something similar
in the earlier loop test branch from last year.
