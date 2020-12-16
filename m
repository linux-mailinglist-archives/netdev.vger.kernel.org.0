Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED472DB99C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 04:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPDYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 22:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPDYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 22:24:16 -0500
X-Gm-Message-State: AOAM530XxuuE0XCSainU6FfkjuErk/WrIZyHHMtPdyqp6IR3uFyLlu/D
        iaC1G7qoB9wZFxrZmElP8EhWEmdWWWLsszVRQkA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608089015;
        bh=+VWdHZsN3ZF2tTZjB86p57jM2MoFOWc5DUiqA0cxwq4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Vgk/PNpzMjrQ8Y+HS6uWwGUUfuOm8XeWlxAAPutntFQG7kpGCKg8N/NsFAjm4kCOy
         anEi001ODbWsOsqTIEk0zqUha0Fypt5yCF0hTA3s14QDSfIoX0Pd/33/+6O50USeo4
         XVU0veMzd6JBndl8Wz5b0eLLGwV8ZpGuDPfIig6ft+na3gpPo5BAiEbua13DcrYChD
         yBkdLXh83Z2lzshANEdT+hQG/JdlyV5p3jliKOXtDZeWr/yOuKwED2a65L5HKNQc19
         t4lrIAoUcmGCrcAWjowblvKARqLxw3nzzuV0DWGVrFhQqcoYOX1Bpmf+klYLLUSS2x
         9XzibOjW7KgdQ==
X-Google-Smtp-Source: ABdhPJw5aRonCf+dNirajOZSqxn3F3lKvuxpQ3fTcSxdD0iNmU/B4remp5Kol2SBNgdW1MiJb6ZotGV3P8/C5Bam3ZE=
X-Received: by 2002:ac2:5979:: with SMTP id h25mr8173699lfp.57.1608089012744;
 Tue, 15 Dec 2020 19:23:32 -0800 (PST)
MIME-Version: 1.0
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour> <20201215091153.GH2809@kadam>
 <20201215113710.wh4ezrvmqbpxd5yi@gilmour> <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
 <20201215190815.6efzcqko55womf6b@gilmour> <20201215193545.GJ2809@kadam> <902018a7-19eb-cd15-5fde-6e0564fcd95c@wanadoo.fr>
In-Reply-To: <902018a7-19eb-cd15-5fde-6e0564fcd95c@wanadoo.fr>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 16 Dec 2020 11:23:21 +0800
X-Gmail-Original-Message-ID: <CAGb2v65A_Z7=0jN8J08GrufjWTKVvp_LdPPdGVzwqU3HLkHkig@mail.gmail.com>
Message-ID: <CAGb2v65A_Z7=0jN8J08GrufjWTKVvp_LdPPdGVzwqU3HLkHkig@mail.gmail.com>
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 4:16 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 15/12/2020 =C3=A0 20:35, Dan Carpenter a =C3=A9crit :
> > On Tue, Dec 15, 2020 at 08:08:15PM +0100, Maxime Ripard wrote:
> >> On Tue, Dec 15, 2020 at 07:18:48PM +0100, Christophe JAILLET wrote:
> >>> Le 15/12/2020 =C3=A0 12:37, Maxime Ripard a =C3=A9crit :
> >>>> On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
> >>>>> On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote=
:
> >>>>>>> 'irq_of_parse_and_map()' should be balanced by a corresponding
> >>>>>>> 'irq_dispose_mapping()' call. Otherwise, there is some resources =
leaks.
> >>>>>>
> >>>>>> Do you have a source to back that? It's not clear at all from the
> >>>>>> documentation for those functions, and couldn't find any user call=
ing it
> >>>>>> from the ten-or-so random picks I took.
> >>>>>
> >>>>> It looks like irq_create_of_mapping() needs to be freed with
> >>>>> irq_dispose_mapping() so this is correct.
> >>>>
> >>>> The doc should be updated first to make that clear then, otherwise w=
e're
> >>>> going to fix one user while multiples will have poped up
> >>>>
> >>>> Maxime
> >>>>
> >>>
> >>> Hi,
> >>>
> >>> as Dan explained, I think that 'irq_dispose_mapping()' is needed beca=
use of
> >>> the 'irq_create_of_mapping()" within 'irq_of_parse_and_map()'.
> >>>
> >>> As you suggest, I'll propose a doc update to make it clear and more f=
uture
> >>> proof.
> >>
> >> Thanks :)
> >>
> >> And if you feel like it, a coccinelle script would be awesome too so
> >> that other users get fixed over time
> >>
> >> Maxime
> >
> > Smatch has a new check for resource leaks which hopefully people will
> > find useful.
> >
> > https://github.com/error27/smatch/blob/master/check_unwind.c
>
> Nice :)
> I wasn't aware of it.
>
> >
> > To check for these I would need to add the following lines to the table=
:
> >
> >          { "irq_of_parse_and_map", ALLOC, -1, "$", &int_one, &int_max},
> >          { "irq_create_of_mapping", ALLOC, -1, "$", &int_one, &int_max}=
,
> >          { "irq_dispose_mapping", RELEASE, 0, "$"},
> >
> > The '-1, "$"' means the returned value.  irq_of_parse_and_map() and
> > irq_create_of_mapping() return positive int on success.
> >
> > The irq_dispose_mapping() frees its zeroth parameter so it's listed as
> > '0, "$"'.  We don't care about the returns from irq_dispose_mapping().
> >
> > It doesn't apply in this case but if a function frees a struct member
> > then that's listed as '0, "$->member_name"'.
> >
> > regards,
> > dan carpenter
> >
>
> The script I use to try to spot missing release function is:
> ///
> @@
> expression  x, y;
> identifier f, l;
> @@
>
> *       x =3D irq_of_parse_and_map(...);
>          ... when any
> *       y =3D f(...);
>          ... when any
> *       if (<+... y ...+>)
>          {
>                  ...
> (
> *               goto l;
> |
> *               return ...;
> )
>                  ...
>          }
>          ... when any
> *l:
>          ... when !=3D irq_dispose_mapping(...);
> *       return ...;
> ///
>
> It is likely that some improvement can be made, but it works pretty well
> for what I want.
>
> And I have a collection of alloc/free functions that I manually put in
> place of irq_of_parse_and_map and irq_dispose_mapping.

AFAICT the resource leak is likely larger in scope, as many drivers use
platform_get_irq(), which eventually ends up calling irq_create_of_mapping(=
)
through of_irq_get() in the OF path. Same goes for platform_get_irq_byname(=
).

ChenYu


> Up to know, this list is:
>
> // alloc_etherdev/alloc_etherdev_mq/alloc_etherdev_mqs - free_netdev
> // alloc_workqueue - destroy_workqueue
> // class_register - class_unregister
> // clk_get - clk_put
> // clk_prepare - clk_unprepare
> // create_workqueue - destroy_workqueue
> // create_singlethread_workqueue - destroy_workqueue
> //
> dev_pm_domain_attach/dev_pm_domain_attach_by_id/dev_pm_domain_attach_by_n=
ame
> - dev_pm_domain_detach
> // devres_alloc - devres_free
> // dma_alloc_coherent - dma_free_coherent
> // dma_map_resource - dma_unmap_resource
> // dma_map_single - dma_unmap_single
> // dma_request_slave_channel - dma_release_channel
> // dma_request_chan - dma_release_channel
> // framebuffer_alloc - framebuffer_release
> // get_device - put_device
> // iio_channel_get - iio_channel_release
> // ioremap - iounmap
> // input_allocate_device - input_free_device
> // input_register_handle - input_unregister_handle
> // irq_of_parse_and_map / irq_create_of_mapping - irq_dispose_mapping
> // kmalloc - kfree
> // mempool_alloc - mempool_free
> // of_node_get - of_node_put
> // of_reserved_mem_device_init - of_reserved_mem_device_release
> // pinctrl_register - pinctrl_unregister
> // request_irq - free_irq
> // request_region - release_region
> // request_mem_region - release_mem_region
> // reset_control_assert - reset_control_deassert
> // scsi_host_alloc - scsi_host_put
>
> // pci_alloc_irq_vectors - pci_free_irq_vectors
> // pci_dev_get - pci_dev_put
> // pci_enable_device - pci_disable_device
> // pci_iomap - pci_iounmap
> // pci_request_region - pci_release_region
> // pci_request_regions - pci_release_regions
>
> // alloc_skb/__alloc_skb - kfree_skb/__kfree_skb
> // dev_alloc_skb - dev_kfree_skb
>
> // spi_dev_get - spi_dev_put
> // spi_message_alloc - spi_message_free
> // spi_register_master - spi_unregister_master
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
