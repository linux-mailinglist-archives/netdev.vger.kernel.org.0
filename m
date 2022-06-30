Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F085625C4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiF3V7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiF3V7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:59:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21273FBE7;
        Thu, 30 Jun 2022 14:59:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sb34so599771ejc.11;
        Thu, 30 Jun 2022 14:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VCFiO/DeU9BXKDMeaTVORaJLJS+2vXFEBjORLfl2s5k=;
        b=LvKY1OOTT78vTS8EPbGj0TrO58Z6edbacT16WUNefQLwdjxglPKC7hY1zgMoBIDwzP
         2xci4QFis9EXN30WVQkkwLYWs7l87b+YBiiRWyiHrhSXInAHmd1BM7aDXMhtPMZI2HY4
         LBqz+kuSiDwiwJ8EQhRZsklryzlVX/6VZ/Dm8QkCM7gS97EHASij1PJFrTFg3JdqV4pE
         72QKMYh6DQiwnvMQHeU9G6LbKsFaDoxkZibp7qSQ0GnOAW6OnFg0JT+KoD1aqaUuzPLf
         h75v8xrcHZUUpGwz0Pq4KzKkNFFgAbl1vUiw7aSTsjp24LOIpKbFQZWeSHfUJLj6RAJs
         dBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VCFiO/DeU9BXKDMeaTVORaJLJS+2vXFEBjORLfl2s5k=;
        b=NWKzicev+ZSPJzn3Je0ulWmq03XpEr+auwguLicX4HqZ9wh/z2LokxTzKWZ7LZkUn3
         BGs5CTjcpChMVinI1Kh4wyG68muOIdPAx6x5bl77KVeGPnPyaGYsVLeolSeDC96JlDDM
         sj3YRnKTf8k0sOuXhlV6Nq2MpIk4I/ABjuIBzBXEixw77K6kX1JlipwFKNpGABAQ0udi
         JsFC8d5/lfgH5zioTmmKiGe5DSDx9/x30/sRch2+56ksAkb5F3oIlFxrT9VrfjMGIJhu
         mceb7UlViRrRBmalD0V7JkcE+BUuLzKiUg7fuJ6yXsQzAUyOtE29vd8vmL/U4n91ZogU
         wUug==
X-Gm-Message-State: AJIora/D6BMLqlDHj/gEDNorgrSKf92gIxY24ABcXKmlxFmVrubC2sl2
        LtTxe0IfFayWipgQyfKaZKyRGNu9SDe7qSIJ3yC5lrn/
X-Google-Smtp-Source: AGRyM1utaObcR+X0r6TrHRoLKwSzV4pBavCJL1T5Wzg7peFzpGSlpvtkm1Sf8JauMB3VhrTRV7HUakvHEsj0+Nbkr+k=
X-Received: by 2002:a17:906:5a62:b0:728:f6d4:7786 with SMTP id
 my34-20020a1709065a6200b00728f6d47786mr10914153ejc.184.1656626375309; Thu, 30
 Jun 2022 14:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <CANn89iK6g+4Fy2VMV7=feUAOUDHu-J38be+oU76yp+zGH6xCJQ@mail.gmail.com>
 <CAKgT0UcKRJUJrpFHdNrdH98eu_dpiZiVakJRqc2qHrdGJJQRQA@mail.gmail.com> <2254584.ElGaqSPkdT@opensuse>
In-Reply-To: <2254584.ElGaqSPkdT@opensuse>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 30 Jun 2022 14:59:23 -0700
Message-ID: <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 11:18 AM Fabio M. De Francesco
<fmdefrancesco@gmail.com> wrote:
>
> On gioved=C3=AC 30 giugno 2022 18:09:18 CEST Alexander Duyck wrote:
> > On Thu, Jun 30, 2022 at 8:25 AM Eric Dumazet <edumazet@google.com> wrot=
e:
> > >
> > > On Thu, Jun 30, 2022 at 5:17 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
> > > > <maciej.fijalkowski@intel.com> wrote:
> > > > >
> > > > > On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco
> wrote:
> > > > > > The use of kmap() is being deprecated in favor of
> kmap_local_page().
> > > > > >
> > > > > > With kmap_local_page(), the mapping is per thread, CPU local an=
d
> not
> > > > > > globally visible. Furthermore, the mapping can be acquired from
> any context
> > > > > > (including interrupts).
> > > > > >
> > > > > > Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame()
> because
> > > > > > this mapping is per thread, CPU local, and not globally visible=
.
> > > > >
> > > > > Hi,
> > > > >
> > > > > I'd like to ask why kmap was there in the first place and not pla=
in
> > > > > page_address() ?
> > > > >
> > > > > Alex?
> > > >
> > > > The page_address function only works on architectures that have
> access
> > > > to all of physical memory via virtual memory addresses. The kmap
> > > > function is meant to take care of highmem which will need to be
> mapped
> > > > before it can be accessed.
> > > >
> > > > For non-highmem pages kmap just calls the page_address function.
> > > > https://elixir.bootlin.com/linux/latest/source/include/linux/highme=
m-internal.h#L40
> > >
> > >
> > > Sure, but drivers/net/ethernet/intel/ixgbe/ixgbe_main.c is allocating
> > > pages that are not highmem ?
> > >
> > > This kmap() does not seem needed.
> >
> > Good point. So odds are page_address is fine to use. Actually there is
> > a note to that effect in ixgbe_pull_tail.
> >
> > As such we could probably go through and update igb, and several of
> > the other Intel drivers as well.
> >
> > - Alex
> >
> I don't know this code, however I know kmap*().
>
> I assumed that, if author used kmap(), there was possibility that the pag=
e
> came from highmem.
>
> In that case kmap_local_page() looks correct here.
>
> However, now I read that that page _cannot_ come from highmem. Therefore,
> page_address() would suffice.
>
> If you all want I can replace kmap() / kunmap() with a "plain"
> page_address(). Please let me know.
>
> Thanks,
>
> Fabio

Replacing it with just page_address() should be fine. Back when I
wrote the code I didn't realize that GFP_ATOMIC pages weren't
allocated from highmem so I suspect I just used kmap since it was the
way to cover all the bases.

Thanks,

- Alex
