Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCE71D651F
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 04:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgEQCCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 22:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgEQCC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 22:02:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB791C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 19:02:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EFF012782505;
        Sat, 16 May 2020 19:02:28 -0700 (PDT)
Date:   Sat, 16 May 2020 19:02:25 -0700 (PDT)
Message-Id: <20200516.190225.342589110126932388.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517003354.233373-1-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 19:02:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 17 May 2020 02:33:34 +0200

> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> of silicon, except the former has an SPI interface, while the later has a
> parallel bus interface. Thus far, Linux has two separate drivers for each
> and they are diverging considerably.
> 
> This series unifies them into a single driver with small SPI and parallel
> bus specific parts. The approach here is to first separate out the SPI
> specific parts into a separate file, then add parallel bus accessors in
> another separate file and then finally remove the old parallel bus driver.
> The reason for replacing the old parallel bus driver is because the SPI
> bus driver is much higher quality.

What strikes me in these changes is all of the new indirect jumps in
the fast paths of TX and RX packet processing.  It's just too much for
my eyes. :-)

Especially in the presence of Spectre mitigations, these costs are
quite non-trivial.

Seriously, I would recommend that instead of having these small
indirect helpers, just inline the differences into two instances of
the RX interrupt and the TX handler.
