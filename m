Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC24AE7F7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbiBIEHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347509AbiBIDtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:49:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D836C06174F;
        Tue,  8 Feb 2022 19:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF752B81E57;
        Wed,  9 Feb 2022 03:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D912C340E7;
        Wed,  9 Feb 2022 03:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644378542;
        bh=NH/0rQb0O2Au84RUhggPWG4HEjxTOHr2UcxZto/4Uhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=foyT8vJq6VkQKzP0c23smMGcRl/maRyaVj5vNuuZ96ohBFb0F4ek91IrERNdj0D7G
         yi+kE42/jSvQTbHzkDW7NMYDI27rnjQimCE8CBdBkbAnaQSHBSkpkCNr5bT2LxY86u
         hxiEvsjvn0f9oou2Hf5lzNGVIUwx7GW4TL3gR4lWi/hINeA3QeqP+dHTWy/o8BoNLx
         bhps5CvNF507w/eolYjFss9mLDTYrWNGtj2w7nvE17YmZJ71R2RBJ4my5acQqIK8Co
         i1DI+EY8RGpn6BitStzJTWXy+yR+Qw//vo//gTB3ZRzs4pIZwWIqQKVaSjEoClaV6X
         vXudEdveHDjQA==
Date:   Tue, 8 Feb 2022 19:49:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     simon.horman@corigine.com, David Miller <davem@davemloft.net>,
        shenyang39@huawei.com, libaokun1@huawei.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] net: netronome: nfp: possible deadlock in
 nfp_cpp_area_acquire() and nfp_cpp_area_release()
Message-ID: <20220208194900.6d1afbc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <922a002a-3ab6-eabe-131c-af3b8951866b@gmail.com>
References: <922a002a-3ab6-eabe-131c-af3b8951866b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022 10:50:44 +0800 Jia-Ju Bai wrote:
> Hello,
>=20
> My static analysis tool reports a possible deadlock in the nfp driver in=
=20
> Linux 5.16:
>=20
> nfp_cpp_area_acquire()
>  =C2=A0 mutex_lock(&area->mutex); --> Line 455 (Lock A)
>  =C2=A0 __nfp_cpp_area_acquire()
>  =C2=A0=C2=A0=C2=A0 wait_event_interruptible(area->cpp->waitq, ...) --> L=
ine 427 (Wait X)
>=20
> nfp_cpp_area_release()
>  =C2=A0 mutex_lock(&area->mutex); --> Line 502 (Lock A)
>  =C2=A0 wake_up_interruptible_all(&area->cpp->waitq); --> Line 508 (Wake =
X)
>=20
> When nfp_cpp_area_acquire() is executed, "Wait X" is performed by=20
> holding "Lock A". If nfp_cpp_area_release() is executed at this time,=20
> "Wake X" cannot be performed to wake up "Wait X" in=20
> nfp_cpp_area_acquire(), because "Lock A" has been already hold by=20
> nfp_cpp_area_acquire(), causing a possible deadlock.
>=20
> I am not quite sure whether this possible problem is real and how to fix=
=20
> it if it is real.

It's not.

> Any feedback would be appreciated, thanks :)
>
>
> Best wishes,
> Jia-Ju Bai

