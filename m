Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39A1652F5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 00:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBSXMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 18:12:21 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42764 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 18:12:21 -0500
Received: by mail-lj1-f195.google.com with SMTP id d10so2161859ljl.9;
        Wed, 19 Feb 2020 15:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWdZgMsswVvJQU2MierpIWKnEFD04FeEgnx6asgVYnI=;
        b=WZp2sja7wA3CR4NIL6OyZNdn7QmZHOUFWiYV+dkja9uSHKew/+bKSEoWrRnL4FOiqN
         NGKZ4lkj83ixJoxxqYMgH7q+tRSNqs/cV0YQugYHYC6+zecrm6XFLsvmzH/6VoY2M6DH
         YNyynBe/YBVf54qhOuBgRSG0BduKg2rd+Gi9nZfJ+ShsciOYfrDHTibht+8oGOG8wO2i
         C6Mmp0pSF3V8ndb4C8RNL5DKFVNkzFNa4ps+1Uswgqj7AgLHsbDJUrCqc/ZnY1fnbNkT
         TFIojIeyAX77RzBMv0GTNM7oCJsteTdQAglUGUpH1pvd7ycS+nb4V0fsW8NgEVIWhmIY
         iydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWdZgMsswVvJQU2MierpIWKnEFD04FeEgnx6asgVYnI=;
        b=IoyEC68NEy2B9YxLveA561cB1QlNGnv9l+4aHQr3/vSr8aCZu540C0hOz3ApJFtd4E
         maHWFUz5YTZXEVtSqM3kRM129bPQrSuUaDteQXCJRbyJ/2EacT7XRPCN5wXpzzTMvteD
         w39ZuBWvWofJWMVM/ajfTxEtslUzsjFPQTpXa8f1CM6U2KtVmDrqvEUJK9FMns0Vgdtv
         /j5444GS1hoVvQLpHN+dvNcXrtUQeNk7zUD6Mx5p+WiM1mDEb1slua+tUI0WvDOWtdnQ
         O6uW/UCbG+5HxwEFAbDfOT6wSJSdDvIWEYR7kiQHARlzx4VgvSuIOOFtP28JaVCQ7KN9
         5swA==
X-Gm-Message-State: APjAAAWukbffjjmctfRkVxE6NfHQUOI3IuSmGTGQrO+uwJNtuSIduaQd
        GCXPJ6zE524VyvNMplzo+VoRCRCH/+XCA84rt3Y=
X-Google-Smtp-Source: APXvYqwPuJO1pn4qVz8SRf9ExBqbylkQAOl355R6sC3iaV5KVqsifvyxlpaZ5kyrxsscgSt0NeEvY1Pp6dOu7d2MFu8=
X-Received: by 2002:a2e:84d0:: with SMTP id q16mr17395927ljh.138.1582153938706;
 Wed, 19 Feb 2020 15:12:18 -0800 (PST)
MIME-Version: 1.0
References: <20200218172552.215077-1-brianvv@google.com> <c31be4c5-d4c7-5979-215e-de23b9ca0549@fb.com>
In-Reply-To: <c31be4c5-d4c7-5979-215e-de23b9ca0549@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Feb 2020 15:12:06 -0800
Message-ID: <CAADnVQJofPTYg73qoY6e-SwgyrtqPwU9JKx8DQ-9+L_uW6=X9g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] bpf: Do not grab the bucket spinlock by default on
 htab batch ops
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 1:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 2/18/20 9:25 AM, Brian Vazquez wrote:
> > Grabbing the spinlock for every bucket even if it's empty, was causing
> > significant perfomance cost when traversing htab maps that have only a
> > few entries. This patch addresses the issue by checking first the
> > bucket_cnt, if the bucket has some entries then we go and grab the
> > spinlock and proceed with the batching.
> >
> > Tested with a htab of size 50K and different value of populated entries.
> >
> > Before:
> >    Benchmark             Time(ns)        CPU(ns)
> >    ---------------------------------------------
> >    BM_DumpHashMap/1       2759655        2752033
> >    BM_DumpHashMap/10      2933722        2930825
> >    BM_DumpHashMap/200     3171680        3170265
> >    BM_DumpHashMap/500     3639607        3635511
> >    BM_DumpHashMap/1000    4369008        4364981
> >    BM_DumpHashMap/5k     11171919       11134028
> >    BM_DumpHashMap/20k    69150080       69033496
> >    BM_DumpHashMap/39k   190501036      190226162
> >
> > After:
> >    Benchmark             Time(ns)        CPU(ns)
> >    ---------------------------------------------
> >    BM_DumpHashMap/1        202707         200109
> >    BM_DumpHashMap/10       213441         210569
> >    BM_DumpHashMap/200      478641         472350
> >    BM_DumpHashMap/500      980061         967102
> >    BM_DumpHashMap/1000    1863835        1839575
> >    BM_DumpHashMap/5k      8961836        8902540
> >    BM_DumpHashMap/20k    69761497       69322756
> >    BM_DumpHashMap/39k   187437830      186551111
> >
> > Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
>
> Thanks for the fix.
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
