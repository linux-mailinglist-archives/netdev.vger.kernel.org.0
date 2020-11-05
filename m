Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A1E2A80A2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgKEOSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730466AbgKEOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:18:03 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC3FC0613CF;
        Thu,  5 Nov 2020 06:18:01 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r10so1506870pgb.10;
        Thu, 05 Nov 2020 06:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gsfXgYp6d/745vIPy5RjIVehOz0ZLPpOeltimNylI9o=;
        b=DM48THk5JPXrFvaL+o/TrrTHlDQ/280/s6v+YSRtkTpzJ9BCVGqZF022NuUiRSIzZx
         yIjnwa2FEACXxwFnOaHSQ43NBZ2GasIGFJ6qxNFnepnRy0M0S4bn/RY7PWQFgV6zknlH
         9TRqWmOpIXADcfph7/2yhJx9V2Skptm5tegyFBkeMp+sEe1v4fTYAnk7zgejXDorRo4f
         ghtO8PypWRds4kV+DiEttpOMl01qtLpb5UM7T+i4UinQj82wGBF6gzffv77Sg0xAT2pE
         mE4mIgkMnrMx7FYsQ8kELZ4ko0r4VETfSQmj1lsAMk0YMlLvPp2qvfJNkVP/ex+kRp1A
         5i8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gsfXgYp6d/745vIPy5RjIVehOz0ZLPpOeltimNylI9o=;
        b=Hnuk1jxTBDfQD17cq/0dokF3Fj+gmrytVYedweRa9UgVWf2qADNPqm04Jo+RnABPRu
         aNKvPfkgmb30RtG2cD95u5dFt+lYJzFaoh/L5f5S8hkIfotwNsCxXP/jbutuoOe2flLl
         /AohaW9L7hlKanEBuu+1UaZZ1WW110CnxSu8yVq237rHnfpXOhMfzOZjcTQU0AaU/Xy8
         NaUAO6a9915YHSOytfi6RKcssMndROtrcZTTCHNpFtx5C2wJ2fLV4xYLZaowwDXfPhzH
         XAT6Pr3/ovFiia2zFw8WKufG8GwrlMqjK+3FdsCIqTPnyoEm4NMcZ66b3BtVaZqKxSF8
         TLqg==
X-Gm-Message-State: AOAM530npWrBBeNpTI0NIKCPqMDyemXFH7km0p5zsc0oUZODe7DBq8b5
        5fOkQRabUwpB9M1SqQ0unxr8RHpEPR6AgR+MAic=
X-Google-Smtp-Source: ABdhPJwXTwb01LuOIuCIJoXgHdk44wasB0pppP3vWiPTqrgsJlDGm7O4K9WDFYnd65Jf4ac9TImWunVd9mjBa315xpI=
X-Received: by 2002:aa7:8428:0:b029:18b:b43:6cc with SMTP id
 q8-20020aa784280000b029018b0b4306ccmr2692443pfn.73.1604585881330; Thu, 05 Nov
 2020 06:18:01 -0800 (PST)
MIME-Version: 1.0
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com> <20201104153320.66cecba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104153320.66cecba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 5 Nov 2020 15:17:50 +0100
Message-ID: <CAJ8uoz3-tjXekU=kR+HfMhGBcHtAFnKGq1ZvpFq99T_S-mknPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] i40e: introduce lazy Tx completions for
 AF_XDP zero-copy
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 12:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  4 Nov 2020 15:08:57 +0100 Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Introduce lazy Tx completions when a queue is used for AF_XDP
> > zero-copy. In the current design, each time we get into the NAPI poll
> > loop we try to complete as many Tx packets as possible from the
> > NIC. This is performed by reading the head pointer register in the NIC
> > that tells us how many packets have been completed. Reading this
> > register is expensive as it is across PCIe, so let us try to limit the
> > number of times it is read by only completing Tx packets to user-space
> > when the number of available descriptors in the Tx HW ring is below
> > some threshold. This will decrease the number of reads issued to the
> > NIC and improves performance with 1.5% - 2% for the l2fwd xdpsock
> > microbenchmark.
> >
> > The threshold is set to the minimum possible size that the HW ring can
> > have. This so that we do not run into a scenario where the threshold
> > is higher than the configured number of descriptors in the HW ring.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> I feel like this needs a big fat warning somewhere.
>
> It's perfectly fine to never complete TCP packets, but AF_XDP could be
> used to implement protocols in user space. What if someone wants to
> implement something like TSQ?

I might misunderstand you, but with TSQ here (for something that
bypasses qdisk and any buffering and just goes straight to the driver)
you mean the ability to have just a few buffers outstanding and
continuously reuse these? If so, that is likely best achieved by
setting a low Tx queue size on the NIC. Note that even without this
patch, completions could be delayed. Though this patch makes that the
normal case. In any way, I think this calls for some improved
documentation.

I also discovered a corner case that will lead to a deadlock if the
completion ring size is half the size of the Tx NIC ring size. This
needs to be fixed, so I will spin a v2.

Thanks: Magnus
