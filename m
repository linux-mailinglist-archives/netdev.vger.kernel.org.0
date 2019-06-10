Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14EA3AD05
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfFJCdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:33:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbfFJCdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:33:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFAF514EACBF3;
        Sun,  9 Jun 2019 19:33:32 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:33:32 -0700 (PDT)
Message-Id: <20190609.193332.1303109263918456859.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     sergej.benilov@googlemail.com, venza@brownhat.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: re-enable high throughput
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6dc5ff4b-24a4-7631-c598-2500b1a27ff4@gmail.com>
References: <20190607172628.31471-1-sergej.benilov@googlemail.com>
        <CAC9-QvCyZm10wrVd=6Z-9H-Y9mkb_e_4mkhs6KxGUEozy6BsVQ@mail.gmail.com>
        <6dc5ff4b-24a4-7631-c598-2500b1a27ff4@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:33:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 7 Jun 2019 12:18:21 -0700

> Note that this suggests the driver is not performing TX completion
> fast enough.
> 
> Looking at the driver, I do not see anything requesting interrupt
> mitigation, so this might also be caused by a race in the driver
> (some skbs being not TX completed until another unrelated xmit is
> requested)

I think the INTR bit needs to be set in the individual TX descriptors.

This is a classic case of a chip that only interrupts when the entire
TX queue is emptied and the TX engine enters the idle state.

I don't like this skb_orphan() solution as it kills UDP flow control.

I'm not applying this.
