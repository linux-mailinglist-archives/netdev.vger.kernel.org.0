Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D951C542194
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiFHCXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446703AbiFHCVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:21:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB010D5FA;
        Tue,  7 Jun 2022 17:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD90CB82474;
        Wed,  8 Jun 2022 00:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6543CC34114;
        Wed,  8 Jun 2022 00:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654647296;
        bh=NXXoRp3O0lf2L8bwbUT1SM463oYDoMSvjZr5C8vGoKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRdbU3ay3EiyLv2foPiwz+TygNsWU7MyKzHKlESvJxuAb7eR63u681318bdo/MAXq
         FfjMqnCKgC6Ff50dOEsigEc6ZoyaRWfSYIpIwNZM6Fdo/dyrEvguprqmZgcXZAK3cb
         I7TZVDZxfHxjPR02m5i60tesHyvlqrPCTHr8jnJBG0e8lcMB6Z756AGB48/GfkpidO
         2vbw8fevrDY2WVHgsIDrup82xjHl7nAnDu6HFmBIHdQPBPrVV7UGdMJQIESxOTbJ/M
         sJWGckCAEi5HSFl34k0Db1SqRUb3K9PgViCcOAbyzPgTcyUjHnqiZmmi9kNzp7I4yM
         6EM1z0/POLoKw==
Date:   Tue, 7 Jun 2022 17:14:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Staudt <max@enpas.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220607171455.0a75020c@kernel.org>
In-Reply-To: <20220608014248.6e0045ae.max@enpas.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
        <20220607182216.5fb1084e.max@enpas.org>
        <20220607150614.6248c504@kernel.org>
        <20220608014248.6e0045ae.max@enpas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022 01:43:54 +0200 Max Staudt wrote:
> It seems strange to me to magically build some extra features into
> can_dev.ko, depending on whether some other .ko files are built in that
> very same moment, or not. By "magically", I mean an invisible Kconfig
> option. This is why I think Vincent's approach is best here, by making
> the drivers a clearly visible subset of the RX_OFFLOAD option in
> Kconfig, and RX_OFFLOAD user-selectable.

Sorry for a chunked response, vger becoming unresponsive the week after
the merge window seems to become a tradition :/

We have a ton of "magical" / hidden Kconfigs in networking, take a look
at net/Kconfig. Quick grep, likely not very accurate but FWIW:

# not-hidden
$ git grep -c -E '(bool|tristate)..' net/Kconfig
net/Kconfig:23

# hidden
$ git grep -c -E '(bool|tristate)$' net/Kconfig
net/Kconfig:20

> How about making RX_OFFLOAD a separate .ko file, so we don't have
> various possible versions of can_dev.ko?
> 
> @Vincent, I think you suggested that some time ago, IIRC?
> 
> (I know, I was against a ton of little modules, but I'm changing my
> ways here now since it seems to help...)

A separate module wouldn't help with my objections, I don't think.
