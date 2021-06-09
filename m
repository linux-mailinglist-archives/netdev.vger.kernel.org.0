Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F563A1A01
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhFIPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:46:32 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60978 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhFIPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:46:29 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by linux.microsoft.com (Postfix) with ESMTPSA id 37E7120B83C2
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 08:44:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 37E7120B83C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623253474;
        bh=E1EPBhxia0ghTE3+LQp+xX8BhdBdyXLpcvwlnPq+4sk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fDv79jK5/BCH81duma+1euAo7begGs6PUhKNM5RG6o96M/VyR3pLVHWHbPaCNYUaB
         SZZCDN5InMYnHHUDfvNvD9PNF1p4wRBb4nHbu8gZ+zLA/G/AMDo8aukHi2TrabNNCl
         84uYc9DI0G9G4qqmD+8AmfTRz2ujv2t4pYmje7ZQ=
Received: by mail-pj1-f50.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso1617980pjb.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 08:44:34 -0700 (PDT)
X-Gm-Message-State: AOAM533b2m2kR2WJMtHaqWvpzAY7c91WjiIImrfzxPbij/ioiJZNaWXu
        M7K8Y4SpRc3lUaX755FTvIoabCmGvdYrJ9fNOyQ=
X-Google-Smtp-Source: ABdhPJylt1Tqn6GYgZeV/zSUn6oha2XCa78ZhfPbgVP5KuJUPRzh1e3upVHtk+TMm0ttq7fdJA+43xPTpEeHl3Ijl4Q=
X-Received: by 2002:a17:90b:109:: with SMTP id p9mr11304227pjz.11.1623253473805;
 Wed, 09 Jun 2021 08:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
 <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com> <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
In-Reply-To: <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Wed, 9 Jun 2021 17:43:57 +0200
X-Gmail-Original-Message-ID: <CAFnufp1vY79fxJEL6eKopTFzJkFz_bZCwaD84CaR_=yqjt6QNw@mail.gmail.com>
Message-ID: <CAFnufp1vY79fxJEL6eKopTFzJkFz_bZCwaD84CaR_=yqjt6QNw@mail.gmail.com>
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 5:03 PM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> hi
>
> On 09/06/2021 15:20, Matteo Croce wrote:
> > On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >>
> >> As already done for mvneta and mvpp2, enable skb recycling for ti
> >> ethernet drivers
> >>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > Looks good! If someone with the HW could provide a with and without
> > the patch, that would be nice!
> >
>
> What test would you recommend to run?
>
> --
> Best regards,
> grygorii

Hi Grygorii,

A test which benefits most from this kind of change is one in which
the frames are freed early.
One option would be to use mausezahn which by default sends frames
with an invalid ethertype, that are dropped very early from the stack
(I think in __netif_receive_skb_core() or near there).
Then, on the device I just watch the device statistics to count
packets per second:

mausezahn eth0 -c 0 -b $board_mac_address

This test should be precise enough for a gigabit link, on faster links
I usually use a DPDK or AF_XDP based one.

Regards,
-- 
per aspera ad upstream
