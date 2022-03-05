Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032324CE262
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 04:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiCEDMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCEDM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0954527E6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 19:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D73B82C79
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DBAC340E9;
        Sat,  5 Mar 2022 03:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646449896;
        bh=sIWXP1fCgS2Vc7Js3wJIfEvckubMdSkEFvpwbyPwQng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sa8rx9rqI5Y+3smZ7Ewa5fHJCmcBtPmn/T2h7M5ONaV4palO9KsyTNaw8q4jxbIU0
         c21yJ03qkQ/csBMzUpZofL3WFVnN2cmjWOf59L0MM61ZUHbKvfe1MdD2gnDl6IdZom
         xO3+FlwwwBnMMBxXt4kWvzWl/UAlgNZHpqgcEE93Lk+EgToWXfUIUIZNHfA3X2BMLm
         P/2/Jdgueq75PIdUYyCQuFA0ZbgiIMrhSyYNMgyhfsWRECFBJ1kMt9WhezMaaly+Jg
         i7Vu6tA+tGBDkiv3z3dJ6wyfNE7xHfCQMgyOJszvnLdLTtzWauM3lQbDAODT6eFn1X
         RZj3wIypUBaAA==
Date:   Fri, 4 Mar 2022 19:11:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for
 accessing eeprom
Message-ID: <20220304191134.6146087d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DC32C07D-52FC-437C-AE9A-FA03082E008B@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
        <20220303233801.242870-4-jonathan.lemon@gmail.com>
        <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
        <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DC32C07D-52FC-437C-AE9A-FA03082E008B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Mar 2022 08:50:02 -0800 Jonathan Lemon wrote:
> > And AFAIU the company delivering the card writes / assembles the
> > firmware, you can't take FW load from company A and flash it onto
> > company B's card, no? =20
>=20
> Nope.  There are currently 3 designs, and 3 firmware variants.
> I=E2=80=99m looking for a way to tell them apart, especially since the
> firmware file must match the card.  Suggestions?
>=20
> [root@timecard net-next]# devlink dev info
> pci/0000:02:00.0:
>   driver ptp_ocp
>   serial_number fc:c2:3d:2e:d7:c0
>   versions:
>       fixed:
>         board.manufacture GOTHAM
>         board.id RSH04940
>       running:
>         fw 21
> pci/0000:65:00.0:
>   driver ptp_ocp
>   serial_number 4e:75:6d:00:00:00
>   versions:
>       fixed:
>         board.manufacture O2S
>         board.id R3006G000100
>       running:
>         fw 9
> pci/0000:b3:00.0:
>   driver ptp_ocp
>   serial_number 3d:00:00:0e:37:73
>   versions:
>       fixed:
>         board.manufacture CLS
>         board.id R4006G000101
>       running:
>         fw 32773

Thanks for the output!

In my limited experience the right fit here would be PCI Subsystem
Vendor ID. This will also allow lspci to pretty print the vendor
name like:

30:00.0 Dunno controller: OCP Time Card whatever (Vendor X)
