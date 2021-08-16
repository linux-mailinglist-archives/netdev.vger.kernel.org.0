Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD52D3EDDC3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhHPTU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhHPTUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 15:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C1D060F41;
        Mon, 16 Aug 2021 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629141621;
        bh=/scif1mkCBlmZU+0jJuanWocyxDnQnGUxWglfLlEFKY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XRokmLOLl5aEHn0n/uYcHeCWr8Y1P2RP+CkfGbXWeBpSnmDKiqOVVxuT3i9zz98E/
         zVNXa759iOQ4K1WrteZ6t2hG9KUL8+i5/2xRjDOUrjx41C4sSufBIledgZK8q2wqSf
         WQGzdeR1C+/5MfCcIzf5rNCfPy93B7UN2+gqxQbsuiEViflGInEmdYHaOuKpGivwW7
         DAvbq8ij2x5J5xYnMhecbWwpCbCGnXhUEa4I6VeRSJ9kKU1YHceeXZ+sq8UarREMw8
         u4kvOVjzkx/Uxn5NRb63VaOQrDIQDeCFEacg2opf1N36KeAKljnFfhb+kT4w4/17rj
         rp4ev0eKvSuYg==
Received: by mail-ej1-f50.google.com with SMTP id z20so33738985ejf.5;
        Mon, 16 Aug 2021 12:20:21 -0700 (PDT)
X-Gm-Message-State: AOAM532akqLmK/0Dpon/do4G0jaKJ/W28jP8P3c51ZqVAdsFBiEoS7AS
        QpFHk9enM2Fvz1FtddlIt6TNnGFS5Yw73tgz5w==
X-Google-Smtp-Source: ABdhPJx8cEr2G1dwVnQKOf4s7ZC1dm+QcfNMleG316aSSHpGdOMw8Euw/KHihuc4Sj8dKo50NQTVwClSZSuFoUYqcDE=
X-Received: by 2002:a17:906:fa92:: with SMTP id lt18mr7796ejb.359.1629141620181;
 Mon, 16 Aug 2021 12:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210814010139.kzryimmp4rizlznt@skbuf> <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
 <20210816144622.tgslast6sbblclda@skbuf> <4cad28e0-d6b4-800d-787b-936ffaca7be3@gmail.com>
In-Reply-To: <4cad28e0-d6b4-800d-787b-936ffaca7be3@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 16 Aug 2021 14:20:08 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKYd288Th2cfOp0_HD1C8xtgKjyJfUW4JLpyn0NkGdU5w@mail.gmail.com>
Message-ID: <CAL_JsqKYd288Th2cfOp0_HD1C8xtgKjyJfUW4JLpyn0NkGdU5w@mail.gmail.com>
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
To:     Frank Rowand <frowand.list@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 10:14 AM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 8/16/21 9:46 AM, Vladimir Oltean wrote:
> > Hi Frank,
> >
> > On Mon, Aug 16, 2021 at 09:33:03AM -0500, Frank Rowand wrote:
> >> Hi Vladimir,
> >>
> >> On 8/13/21 8:01 PM, Vladimir Oltean wrote:
> >>> Hi,
> >>>
> >>> I was debugging an RCU stall which happened during the probing of a
> >>> driver. Activating lock debugging, I see:
> >>
> >> I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.
> >>
> >> Looking at the following stack trace, I did not see any calls to
> >> of_find_compatible_node() in sja1105_mdiobus_register().  I am
> >> guessing that maybe there is an inlined function that calls
> >> of_find_compatible_node().  This would likely be either
> >> sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().
> >
> > Yes, it is sja1105_mdiobus_base_t1_register which is inlined.
> >
> >>>
> >>> [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
> >>> [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
> >>> [  101.726763] INFO: lockdep is turned off.
> >>> [  101.730674] irq event stamp: 0
> >>> [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> >>> [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> >>> [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> >>> [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
> >>> [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
> >>> [  101.774558] Call trace:
> >>> [  101.794734]  __might_sleep+0x50/0x88
> >>> [  101.798297]  __mutex_lock+0x60/0x938
> >>> [  101.801863]  mutex_lock_nested+0x38/0x50
> >>> [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
> >>> [  101.809341]  sysfs_remove_dir+0x54/0x70
> >>
> >> The __kobject_del() occurs only if the refcount on the node
> >> becomes zero.  This should never be true when of_find_compatible_node()
> >> calls of_node_put() unless a "from" node is passed to of_find_compatible_node().
> >
> > I figured that was the assumption, that the of_node_put would never
> > trigger a sysfs file / kobject deletion from there.
> >
> >> In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
> >> a from node ("mdio") is passed to of_find_compatible_node() without first doing an
> >> of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.
> >
> > The answer seems simple enough, but stupid question, but why does
> > of_find_compatible_node call of_node_put on "from" in the first place?
>
> Actually a good question.
>
> I do not know why of_find_compatible_node() calls of_node_put() instead of making
> the caller of of_find_compatible_node() responsible.  That pattern was created
> long before I was involved in devicetree and I have not gone back to read the
> review comments of when that code was created.

Because it is an iterator function and they all drop the ref from the
prior iteration.

I would say any open coded call where from is not NULL is an error.
It's not reliable because the DT search order is not defined and could
change. Someone want to write a coccinelle script to check that?

The above code should be using of_get_compatible_child() instead.

Rob
