Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE99F50E461
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbiDYPbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiDYPbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ECE10783D;
        Mon, 25 Apr 2022 08:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B89560F13;
        Mon, 25 Apr 2022 15:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F76DC385A4;
        Mon, 25 Apr 2022 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650900487;
        bh=k7PzVbMbt1y/AYQMFuHxEDkA1XKQyYfivu84dwzKtTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eq3WzFq5UKNWtvuVTieJUtO7QfcYzpMOeRnjb5JBR/xelmAT9DPLaVSytsOJcwvvZ
         mFwdqvIkc8WxkqYkl8gQXAswOxCHV5jvDN/4CbUKRYJMHCA1BjpnZ5SfJUdX5ogCbP
         t7HrXihO5c2wlUCjyui5jwaXdCSrygFFpM9aeLtrpN5IiZKRhBqaGhrWU6jH9r1frs
         OuqmKpxaFu7Z+DOcMFJuhf/a7t89kMFSQrSCZepe9cPqRZw+rPTuyShGufDspsTHO4
         hH+WE93JytnwHg5Zqq25yZxOQXUOGwbvQuoVhZOeGkwJxsB1ZPUdjpe7Rg6E7WqSdy
         W3zMCyobtMKKQ==
Date:   Mon, 25 Apr 2022 08:28:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jann Horn <jannh@google.com>, Lukas Wunner <lukas@wunner.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220425082804.209e3676@kernel.org>
In-Reply-To: <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
        <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
        <20220423160723.GA20330@wunner.de>
        <20220425074146.1fa27d5f@kernel.org>
        <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
        <20220425080057.0fc4ef66@kernel.org>
        <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 08:13:40 -0700 Eric Dumazet wrote:
> dev_hold() has been an increment of a refcount, and dev_put() a decrement.
> 
> Not sure why it is fundamentally broken.

Jann described a case where someone does

    CPU 0      CPU 1     CPU 2

  dev_hold()
   ------  #unregister -------
             dev_hold()
                         dev_put()

Our check for refcount == 0 goes over the CPUs one by one,
so if it sums up CPUs 0 and 1 at the "unregister" point above
and CPU2 after the CPU1 hold and CPU2 release it will "miss"
one refcount.

That's a problem unless doing a dev_hold() on a netdev we only have 
a reference on is illegal.

> There are specific steps at device dismantles making sure no more
> users can dev_hold()
> 
> It is a contract. Any buggy layer can overwrite any piece of memory,
> including a refcount_t.
> 
> Traditionally we could not add a test in dev_hold() to prevent an
> increment if the device is in dismantle phase.
> Maybe the situation is better nowadays.

