Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA9C34FC15
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhCaJDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbhCaJCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:02:36 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96314C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 02:02:36 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i144so20427871ybg.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 02:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JwwNiMWq1NI+IjmZiI9SVZcuuMJGYh106ExjiMfn84A=;
        b=Er3NhaKGKWg3ISGOjgl9bUZwJwftbCw9I8LaTLVUVpFtUgh+HASL64Omi+uFcrBffA
         JiczftOYSndZV6L067I+0eer86Hm7U6ImYb/z5fDVAgSej1maGF/B29zWG9sU6uMZKTv
         f8/zX4wxHFNYe8nAhDolP2+kiNlcsf+t4+gDmOAuAns73pvQv5dfoQETtHVip2iQyB8R
         ViaOPrw/K3ehBhptcy37G41Jvw1cN6uEIsgkd/i4BS97vDE241K5zUTAZ/MBUlz/k77N
         33tl96/N1EHAffgFetkEoyd/CuTKiJOD4w5keUaY5bHlfbCg/+66S4unERFVw2n8zMrc
         sTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JwwNiMWq1NI+IjmZiI9SVZcuuMJGYh106ExjiMfn84A=;
        b=si5wvDw4PE1FMOkGupQxmmfZZ1FCfrhC2/85CAEQgkTIjPlI9Iw9v0rVEfisb5DUVe
         pgBd9rgC+9OFUMqnqbsvqok8c0L12CZURW45vfHNv7PuSzSj5K3nICCPneW8mU3gGdN3
         bSYZdywIaGszljQqVd3P9N9yLzQKJA/RQKqoygxAHc36XLMDUiOpr5A4VTFQx90JQgQw
         hId9rB0yf/IwNoizN4PcXjhmf+GoQzOSDsBMGTtBNdk1F1AHGaM/dyhnTaUgj03BmCh5
         QOzNsoyF5KQk8VX/5SO+hBoZ9SMUG6lCUQXXTQ8bkED6gypwCfv0MK+8stto5lwaltEI
         pHqg==
X-Gm-Message-State: AOAM531bNCGm8PE7km1KepjHesLhSoeVLE82vOon+HyWVLN5MR+C+FoQ
        7ncpVIgBZU1SVacV+d7rBrzomIjMI9tGy0vPCzIP2g==
X-Google-Smtp-Source: ABdhPJwIFEIa4vsnppgOMa4/VMXg3dqWEOYPiQehfXx1ltQcPaW1fHRmGEw1+9ZkRMzbOn+fvfcS9Zl3rSvG5Cxp7R8=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr3274965ybc.234.1617181355481;
 Wed, 31 Mar 2021 02:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR11MB2870B0910C71BDDFD328B339AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
 <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com> <BYAPR11MB287086509523539BEE534208AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB287086509523539BEE534208AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 11:02:24 +0200
Message-ID: <CANn89iKoMMbZNOoMvS_ObC2r9eumaLNuKhNHASQNC8gp8wdzmQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init methods
To:     "Wong, Vee Khee" <vee.khee.wong@intel.com>
Cc:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:52 AM Wong, Vee Khee <vee.khee.wong@intel.com> wrote:
>
> On Wed, Mar 31, 2021 at 13:58, Eric Dumazet wrote:
> >

> >
> > Nope, I already have a fix, but it depends on a pending patch.
> >
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210330064551.54
> > 5964-1-eric.dumazet@gmail.com/
> >
> > (I need the patch being merged to add a corresponding Fixes: tag)
> >
> > You can try the attached patch :
>
> Thanks, I applied the two patches you mentioned and
> no longer seeing the warnings.
>

Thanks for testing !
