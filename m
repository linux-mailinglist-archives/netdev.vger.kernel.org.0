Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17ED478CF
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 05:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfFQDo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 23:44:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55430 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfFQDo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 23:44:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1FCA14DB0328;
        Sun, 16 Jun 2019 20:44:57 -0700 (PDT)
Date:   Sun, 16 Jun 2019 20:44:57 -0700 (PDT)
Message-Id: <20190616.204457.1507896436828804410.davem@davemloft.net>
To:     jeremy@azazel.net
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com
Subject: Re: [PATCH net] lapb: fixed leak of control-blocks.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190616155437.25299-1-jeremy@azazel.net>
References: <0000000000005c5d1d0589660769@google.com>
        <20190616155437.25299-1-jeremy@azazel.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 20:44:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 16 Jun 2019 16:54:37 +0100

> lapb_register calls lapb_create_cb, which initializes the control-
> block's ref-count to one, and __lapb_insert_cb, which increments it when
> adding the new block to the list of blocks.
> 
> lapb_unregister calls __lapb_remove_cb, which decrements the ref-count
> when removing control-block from the list of blocks, and calls lapb_put
> itself to decrement the ref-count before returning.
> 
> However, lapb_unregister also calls __lapb_devtostruct to look up the
> right control-block for the given net_device, and __lapb_devtostruct
> also bumps the ref-count, which means that when lapb_unregister returns
> the ref-count is still 1 and the control-block is leaked.
> 
> Call lapb_put after __lapb_devtostruct to fix leak.
> 
> Reported-by: syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Applied and queued up for -stable.
