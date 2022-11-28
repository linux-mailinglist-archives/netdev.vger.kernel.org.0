Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35B63B473
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiK1Vsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiK1Vsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:48:38 -0500
Received: from fritzc.com (mail.fritzc.com [IPv6:2a00:17d8:100::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF92F391;
        Mon, 28 Nov 2022 13:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fritzc.com;
        s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LYB25Fvn7CGwTHKU/acIvDCx4DwFl3MWCqKj8wShNt4=; b=pQdNiJ/spdN4Pd+sUAsg/yCloS
        JrK1bF6nV4L6s3xSW7/B9R51576cN4zE/KAAGmJ7hPFGZetTJJwH+nvj9W2HoZd5RaNXy92TEEGBR
        j+FQmjcZPuSDrz0NzRIlX/UhJIoZ2aFphVeXMiwV+LHTbqhqJZdlHNJs6lQhSh8jIryg=;
Received: from 127.0.0.1
        by fritzc.com with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim latest)
        (envelope-from <christoph.fritz@hexdev.de>)
        id 1ozlyz-000cJ6-JF; Mon, 28 Nov 2022 22:48:10 +0100
Date:   Mon, 28 Nov 2022 22:48:07 +0100
From:   Christoph Fritz <christoph.fritz@hexdev.de>
To:     Ryan Edwards <ryan.edwards@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Richard Weinberger <richard@nod.at>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Message-ID: <Y4UslxhfRPVGXzS/@mars>
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <202211281549.47092.pisa@cmp.felk.cvut.cz>
 <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
 <202211281852.30067.pisa@cmp.felk.cvut.cz>
 <CAEVdEgBtikDjQ-cVOq-MkoS_0q_hGJRVSS=9L=htHhh7YvSUgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEVdEgBtikDjQ-cVOq-MkoS_0q_hGJRVSS=9L=htHhh7YvSUgA@mail.gmail.com>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for all the participation and feedback. Here is my attempt at a
summary of what we have discussed so far:

- Common goal: A solid LIN UAPI and API
  - LIN fits CAN well and could be embedded into Linux CAN infrastructure
  - LIN support cannot be a tty-line-discipline driver for all devices
    out there

  - slLIN should become a user of this API
    - slLIN itself needs some more options in the line-discipline
      configuraion (to tweak UART FIFO settings and e.g. enable
      LIN-break-detection for supported UARTs) _or_ tty-LIN support
      becomes something more like RS485 and get integrated into
      tty-drivers directly.

  - LIN devices with off loading capabilities are a bit special.
    - one approach is to have a kfifo for the slavetable (64 entries a 8
      bytes + checksum and some extra flags for some LIN special cases)
      while updating it from userland through CAN or a simple sysfs
      interface
    - when we agree that "dumb" UARTs have no need for an
      in-kernel-off-load slavetable (because of RT-Linux), then there
      are only devices left (e.g. some USB adapters) maintaining their
      own table, so a simple e.g. sysfs update mechanism would be
      enough (without the need for an in-kernel kfifo buffer).

  - LIN slavetable might need another name

  - LIN needs rx, tx, set bitrate, set checksum variant and maybe update
    a slavetable (or whatever it is called then...)

What do you think? Any objections, corrections, enhancements?

My question is: Which approach of an API is favored: Patch 1 or 2 of
this RFC series or something completely different?

Thanks
  -- Christoph
