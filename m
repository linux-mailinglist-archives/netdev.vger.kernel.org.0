Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2891F21FEC6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGNUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgGNUmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:42:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95799C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:42:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D65CC15E24237;
        Tue, 14 Jul 2020 13:42:51 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:42:51 -0700 (PDT)
Message-Id: <20200714.134251.618655351471501947.davem@davemloft.net>
To:     borisp@mellanox.com
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8dd10152-b790-d56f-8fbc-5eb2250f2798@mellanox.com>
References: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
        <20200713.180210.1797175286159137272.davem@davemloft.net>
        <8dd10152-b790-d56f-8fbc-5eb2250f2798@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:42:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>
Date: Tue, 14 Jul 2020 10:27:11 +0300

> Why is it the kernel's role to protect against such an error?

Because the kernel should perform it's task correctly no matter what
in the world the user does.

> Surely the user that modifies pagecache data while sending it over
> sendfile (with TCP) will suffer from consistency bugs that are even worse.

No they won't, often times this is completely legitimate.  One task is
doing a sendpage while another process with access to the file writes
to it.

And that's perfectly fine and allowed by the APIs.

And we must set the IP checksums and TLS signatures correctly.

I will not allow for an implementation that can knowingly send corrupt
things onto the wire.

> The copy in the TLS_DEVICE sendfile path greatly reduces the value of
> all of this work. If we want to get the maximum out of this, then the
> copy has to go.
> 
> If we can't make this the default (as it is in FreeBSD), and we can't
> add a knob to enable this. Then, what should we do here?

I have no problem people using FreeBSD if it serves their needs better
than Linux does.  If people want corrupt TLS signatures in legitimate
use cases, and FreeBSD allows it, so be it.

So don't bother using this as a threat or a reason for me to allow a
feature or a change into the Linux networking.  It will never work.

And, let me get this straight, from the very beginning you intended to
try and add this thing even though I was %100 explicitly against it?
