Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBEB5F33AB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJCQgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJCQgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:36:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DF7248FF
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 862D8B81085
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09561C433D6;
        Mon,  3 Oct 2022 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664814967;
        bh=ccW+tkWSElZlxhcfUKcBl7RsYL1qCVl94H7TGENvxYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G1cVCUNiJsfUQm7UxCFkUzHqAUk9PgY0TzsgOhQVnwCspkPBNe8qeBOXPNJf6XlXY
         iWSpAAyHUSlhoobqbln/Dz7WG2o6Y3ukaExZSp19ixW8ZkAgkPwIU5/2/OY+s0JaOe
         pfZA4w7KXl3cHJsJCpqHS/Cg0STrMyRDYxdna8Xbcno1PCjeqUdv50KEI8oqgMLNPE
         PE7rsO5mKe5jisJ8ZZyaeOBcN7yuO1Elq5cjLOqnk6IGwGkZCmP3+JwDgjcsp01OhF
         n4mpBF/YElfVpQgOcRzUaewJhbzJ8a8exJYN+nk1asSeoBGyACG7lQg2vO4dkOdNo8
         B3dTEfENPHZng==
Date:   Mon, 3 Oct 2022 09:36:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>,
        Douglas Miller <dougmill@linux.ibm.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, kernel@pengutronix.de,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Subject: Re: Strangeness in ehea network driver's shutdown
Message-ID: <20221003093606.75a78f22@kernel.org>
In-Reply-To: <20221001143131.6ondbff4r7ygokf2@pengutronix.de>
References: <20221001143131.6ondbff4r7ygokf2@pengutronix.de>
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

On Sat, 1 Oct 2022 16:31:31 +0200 Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> while doing some cleanup I stumbled over a problem in the ehea network
> driver.
>=20
> In the driver's probe function (ehea_probe_adapter() via
> ehea_register_memory_hooks()) a reboot notifier is registered. When this
> notifier is triggered (ehea_reboot_notifier()) it unregisters the
> driver. I'm unsure what is the order of the actions triggered by that.
> Maybe the driver is unregistered twice if there are two bound devices?
> Or the reboot notifier is called under a lock and unregistering the
> driver (and so the devices) tries to unregister the notifier that is
> currently locked and so results in a deadlock? Maybe Greg or Rafael can
> tell about the details here?
>=20
> Whatever the effect is, it's strange. It makes me wonder why it's
> necessary to free all the resources of the driver on reboot?! I don't
> know anything about the specifics of the affected machines, but I guess
> doing just the necessary stuff on reboot would be easier to understand,
> quicker to execute and doesn't have such strange side effects.
>=20
> With my lack of knowledge about the machine, the best I can do is report
> my findings. So don't expect a patch or testing from my side.

Last meaningful commit to this driver FWIW:

commit 29ab5a3b94c87382da06db88e96119911d557293
Author: Guilherme G. Piccoli <kernel@gpiccoli.net>
Date:   Thu Nov 3 08:16:20 2016 -0200

Also that's the last time we heard from Douglas AFAICT..
