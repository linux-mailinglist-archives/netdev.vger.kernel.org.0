Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853094D5396
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbiCJV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 16:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiCJV3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 16:29:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C853DD7636
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 13:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 338A7CE25CB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2BDC340E8;
        Thu, 10 Mar 2022 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646947682;
        bh=EQoqXZtv7Fet3pxSMhIDxuM3uM9/oglCOyRo0WQA7Js=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W4P5dEaRlnPM6HeOiIUz5UI7k5SmBPlwSmGWPvjYn7x0qBxy1kjT0CuF+8s2E/U8Q
         /O/M/cuxs9jqBWsHKgFeUVrpkj+f7+7qoqTI0xRhde3Vs1T6cVJX4chQ8EqBfRGyqX
         sdJaaX9jckDU3N8FRpimqG0wM/+9KIjw1OSObEXeziczGe83mRyNM6+zulseUeIVWJ
         vgHYIoMvTcZIf/RtYnLkLaagQ7WWnbNnXNWcaZgWt5mdrWj7EdEIJZlGYwpc+SKnfT
         OwiWAnURpguomq3PBDUFhEIcwVdXJCrZDCAmAAUUmsKuHmXW11BhGIZX1thT6mtDbN
         ow10BqiCtqdhQ==
Date:   Thu, 10 Mar 2022 13:28:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220310132801.2fbfb3bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yipp3sQewk9y0RVP@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
        <Yim9aIeF8oHG59tG@shredder>
        <Yipp3sQewk9y0RVP@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 23:13:02 +0200 Ido Schimmel wrote:
> On Thu, Mar 10, 2022 at 10:57:17AM +0200, Ido Schimmel wrote:
> > Thanks for working on this. I ran a few tests that exercise these code
> > paths with a debug config and did not see any immediate problems. I will
> > go over the patches later today =20
>=20
> Went over the patches and they look good to me. Thanks again. Will run a
> full regression with them on Sunday.

Thanks!

> I read [1] and [2] again to refresh my memory about this conversion. Can
> you provide a rough outline of how you plan to go about it?

TBH I haven't started on breaking out more patches, yet. My rough=20
idea was to try to tackle the eswitch callback next and then the
reset callback.

> Asking so that I will know what to expect and how it all fits
> together. I expect that eventually 'DEVLINK_NL_FLAG_NO_LOCK' will be
> removed from 'DEVLINK_CMD_RELOAD' and then the
> devl_lock()/devl_unlock() that you left in drivers will be moved to
> earlier in the probe path so that we don't deadlock on reload.

Yup, that's the end goal =F0=9F=A4=9E
