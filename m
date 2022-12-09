Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1756648683
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLIQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIQbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272F285D08;
        Fri,  9 Dec 2022 08:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5AEA62086;
        Fri,  9 Dec 2022 16:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD61C433D2;
        Fri,  9 Dec 2022 16:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670603466;
        bh=CrsN70tzxNPFnIPgooUqIeKbdNwzxazgCygNJ9rpjl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TTwjopn4Ryhmuk9UVzJyXCvzn55rgfLfErBS7J80wtyuvdYVH001ybdQ1L14PTu6K
         aXSE5/Z/EWjmemGnz9KXm1Lv4MpsD2iUFCy/JVBPnISTJ5oq4pvnyQlWUliL9YhgVW
         uEp2cE3OOm+GC5Wv+iL7OK/v97FAhIOQuipn/Oqin4TbzIXziFFsVL41qUhvUzewFH
         bH6+fB6u8J7L53Sylx8Kso1xA2+5KEgwV+YI9A5y+zuGEXlMetOCLlfj6Y7wt9dsZA
         nq2uR6+UiiZOOeWoJL6btts93lHXA9KtOpq+sJeOlgX96kCqmyx5qhtXYyjL3oqF0y
         U82sWQvMl/hjg==
Date:   Fri, 9 Dec 2022 08:31:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciek Machnikowski <maciek@machnikowski.net>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20221209083104.2469ebd6@kernel.org>
In-Reply-To: <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
        <20221207152157.6185b52b@kernel.org>
        <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
        <Y5MW/7jpMUXAGFGX@nanopsycho>
        <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 15:09:08 +0100 Maciek Machnikowski wrote:
> On 12/9/2022 12:07 PM, Jiri Pirko wrote:
> > Looking at the documentation of the chips, they all have mupltiple DPLLs
> > on a die. Arkadiusz, in your proposed implementation, do you model each
> > DPLL separatelly? If yes, then I understand the urgency of need of a
> > shared pin. So all DPLLs sharing the pin are part of the same chip?
> >=20
> > Question: can we have an entity, that would be 1:1 mapped to the actual
> > device/chip here? Let's call is "a synchronizer". It would contain
> > multiple DPLLs, user-facing-sources(input_connector),
> > user-facing-outputs(output_connector), i/o pins.
> >=20
> > An example:
> >                                SYNCHRONIZER
> >=20
> >                               =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90
> >                               =E2=94=82                                =
       =E2=94=82
> >                               =E2=94=82                                =
       =E2=94=82
> >   SyncE in connector          =E2=94=82              =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90              =E2=94=82     SyncE out connector
> >                 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90         =
=E2=94=82in pin 1      =E2=94=82DPLL_1   =E2=94=82     out pin 1=E2=94=82  =
  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >                 =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4         =E2=94=9C=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=A4   =E2=94=82
> >                 =E2=94=82   =E2=94=82         =E2=94=82              =
=E2=94=82         =E2=94=82              =E2=94=82    =E2=94=82   =E2=94=82
> >                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98         =
=E2=94=82              =E2=94=82         =E2=94=82              =E2=94=82  =
  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >                               =E2=94=82              =E2=94=82         =
=E2=94=82              =E2=94=82
> >                               =E2=94=82           =E2=94=8C=E2=94=80=E2=
=94=80=E2=94=A4         =E2=94=82              =E2=94=82
> >    GNSS in connector          =E2=94=82           =E2=94=82  =E2=94=94=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98              =E2=94=82
> >                 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90         =
=E2=94=82in pin 2   =E2=94=82                  out pin 2=E2=94=82     EXT S=
MA connector
> >                 =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98                           =E2=94=82    =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90
> >                 =E2=94=82   =E2=94=82         =E2=94=82                =
           =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=A4   =E2=94=82
> >                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98         =
=E2=94=82                           =E2=94=82           =E2=94=82    =E2=94=
=82   =E2=94=82
> >                               =E2=94=82                           =E2=
=94=82           =E2=94=82    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >                               =E2=94=82                           =E2=
=94=82           =E2=94=82
> >    EXT SMA connector          =E2=94=82                           =E2=
=94=82           =E2=94=82
> >                 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90   mux   =
=E2=94=82in pin 3      =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =E2=94=82           =E2=
=94=82
> >                 =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90  =E2=94=82         =E2=94=82  =E2=94=82           =E2=94=82
> >                 =E2=94=82   =E2=94=82    =E2=94=82    =E2=94=82        =
   =E2=94=82  =E2=94=82DPLL_2   =E2=94=82  =E2=94=82           =E2=94=82
> >                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98    =E2=94=
=82    =E2=94=82           =E2=94=82  =E2=94=82         =E2=94=82  =E2=94=
=82           =E2=94=82
> >                          =E2=94=82    =E2=94=82           =E2=94=94=E2=
=94=80=E2=94=80=E2=94=A4         =E2=94=9C=E2=94=80=E2=94=80=E2=94=98      =
     =E2=94=82
> >                          =E2=94=82    =E2=94=82              =E2=94=82 =
        =E2=94=82              =E2=94=82
> >    EXT SMA connector     =E2=94=82    =E2=94=82              =E2=94=82 =
        =E2=94=82              =E2=94=82
> >                 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=
=82    =E2=94=82              =E2=94=82         =E2=94=82              =E2=
=94=82
> >                 =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98    =E2=94=82              =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98            =
  =E2=94=82
> >                 =E2=94=82   =E2=94=82         =E2=94=82                =
                       =E2=94=82
> >                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98         =
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >=20
> > Do I get that remotelly correct? =20
>=20
> It looks goot, hence two corrections are needed:
> - all inputs can go to all DPLLs, and a single source can drive more
>   than one DPLL
> - The external mux for SMA connector should not be a part of the
>   Synchronizer subsystem - I believe there's already a separate MUX
>   subsystem in the kernel and all external connections should be handled
>   by a devtree or a similar concept.
>=20
> The only "muxing" thing that could potentially be modeled is a
> synchronizer output to synchronizer input relation. Some synchronizers
> does that internally and can use the output of one DPLL as a source for
> another.

My experience with DT and muxes is rapidly aging, have you worked with
those recently? From what I remember the muxes were really.. "embedded"
and static compared to what we want here.

Using DT may work nicely for defining the topology, but for config we
still need a different mechanism.

> > synch
> > synchronizer_register(synch)
> >    dpll_1
> >    synchronizer_dpll_register(synch, dpll_1)
> >    dpll_2
> >    synchronizer_dpll_register(synch, dpll_2)
> >    source_pin_1
> >    synchronizer_pin_register(synch, source_pin_1)
> >    output_pin_1
> >    synchronizer_pin_register(synch, output_pin_1)
> >    output_pin_2
> >    synchronizer_pin_register(synch, output_pin_2)
> >=20
> > synch_board
> >    synchronizer_board_register(synch_board)
> >    synch
> >    synchronizer_board_sync_register(synch_board, synch)
> >    source_connector_1
> >    synchronizer_board_connector_register(synch_board, source_connector_=
1, source_pin_1)
> >    output_connector_1
> >    synchronizer_board_connector_register(synch_board, output_connector_=
1, output_pin_1)
> >    output_connector_2
> >    synchronizer_board_connector_register(synch_board, output_connector_=
2, output_pin_2) =20
>=20
> I'd rather not use pins at all - just stick to sources and outputs. Both
> can use some labels to be identifiable.

TBH I can't comprehend your suggestion.
IIUC you want an object for a source, but my brain can't handle
modeling an external object. For instance the source could be GNSS,=20
but this is not the GNSS subsystem. We have a pin connected to GNSS,
not the GNSS itself.=20
Maybe a diagram would help?
