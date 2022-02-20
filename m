Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5674BCB87
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 02:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiBTBkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 20:40:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiBTBkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 20:40:02 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F06642A09;
        Sat, 19 Feb 2022 17:39:43 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y16so3619777pjt.0;
        Sat, 19 Feb 2022 17:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JR8OjwwykcXCRxukVQiMhfl+weFk63dNW5x8uO22H7Q=;
        b=T1OuH5T9i8SB9ObqxfJlFUxNc2yhPkuITeBgmgQHrxwASOHja0osWeCSK25PSdcY4+
         5mkMKydmM7TnLHkaEw6mVD/WPLLQDhH5Jg3dO9pgiprhHiL5A6tCIYfV3mcelt8nz/Pn
         qaYPP4vFs3BzaIy9qV+uNi2YOdQVlLhctxucg5HZG+YKsXc0wlSAIBsWgSDHZ0GaqLLP
         R+TdXoICvM2XgPewNjYuOiKNfHHIRYCu+wdG3qcMk3VqCQES83lD5VHPMFjqNnTWPOUd
         GcS6WTKUoFDLc7BZSFasbCjA6FvNZ4YpyBBGqtoPgiiAwqDh1m2rdk2MlLnu9cjh+/R/
         dRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JR8OjwwykcXCRxukVQiMhfl+weFk63dNW5x8uO22H7Q=;
        b=7Ff0YL418l74p6qyY0m8K8Bx8RYOU9lmWzuR82sXIlhhGhdD//+fMfY4Ydx6H+6CNW
         aNyM0PeMa+MRnXoRJ4Zz/nPh2DeLRzV7UnORjVO1Wz5f+q4X7dRcOXH2geIdjyf1Nzvh
         0BnvwTNJY7Nv7PZ9r5dsW1hU9yxU9bD46tnfWw3i3uVfADwmdVmPowdyRwi7FagtVbGz
         WwglgA1Ul5RQpSfKgVZzcpvkurLSjtUgnutSgWORixyYr3CVXqb30DGbRP1FOOiuakdH
         RUcMRESOYLAHcznnzamxwDY0ib8lxA6Po3rIb/HsgrcTsfA71OEHPxs6oUxbMcu83aGT
         Ny8g==
X-Gm-Message-State: AOAM531kfswu0clQEzj97Ycdba5eCdOay4WahoIJyUmBrphCHc1Ev0WE
        rPjy9h/YzN/Lx1rG9EzAMAqkfvZuTk7WCSJQqT8=
X-Google-Smtp-Source: ABdhPJz39vL7ithBfwtLfxFnN5ihD1o2tEmFxDYm1K1liAVlvGp/MgiUJ/arkijbCMAUNMMD+fBfaY/Hy9RmtXx7Se0=
X-Received: by 2002:a17:902:76c5:b0:14e:e325:9513 with SMTP id
 j5-20020a17090276c500b0014ee3259513mr13538605plt.55.1645321182777; Sat, 19
 Feb 2022 17:39:42 -0800 (PST)
MIME-Version: 1.0
References: <20220219163915.125770-1-jrdr.linux@gmail.com> <20220220004209.hlutexplxhvrmpi6@apollo.legion>
In-Reply-To: <20220220004209.hlutexplxhvrmpi6@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 19 Feb 2022 17:39:31 -0800
Message-ID: <CAADnVQLTcYJSNHGCKNso4K6V+SGT93c6YCmEUNrkJooix3sLHQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Initialize ret to 0 inside btf_populate_kfunc_set()
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Souptick Joarder <jrdr.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 4:42 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, Feb 19, 2022 at 10:09:15PM IST, Souptick Joarder wrote:
> > From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
> >
> > Kernel test robot reported below error ->
> >
> > kernel/bpf/btf.c:6718 btf_populate_kfunc_set()
> > error: uninitialized symbol 'ret'.
> >
> > Initialize ret to 0.
> >
> > Fixes:        dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
> > ---
>
> Thanks for the fix.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Applied to bpf-next, since the bug will not trigger in practice.
