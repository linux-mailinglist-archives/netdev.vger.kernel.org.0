Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77B204482
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgFVXey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730296AbgFVXex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:34:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBA8C061573;
        Mon, 22 Jun 2020 16:34:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4ED341297218C;
        Mon, 22 Jun 2020 16:34:53 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:34:52 -0700 (PDT)
Message-Id: <20200622.163452.937354562065071557.davem@davemloft.net>
To:     tuomas.tynkkynen@iki.fi
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: smsc95xx: Fix use-after-free after removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621104326.30604-1-tuomas.tynkkynen@iki.fi>
References: <20200621104326.30604-1-tuomas.tynkkynen@iki.fi>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:34:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Date: Sun, 21 Jun 2020 13:43:26 +0300

> Syzbot reports an use-after-free in workqueue context:
> 
> BUG: KASAN: use-after-free in mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
>  mutex_unlock+0x19/0x40 kernel/locking/mutex.c:737
>  __smsc95xx_mdio_read drivers/net/usb/smsc95xx.c:217 [inline]
>  smsc95xx_mdio_read+0x583/0x870 drivers/net/usb/smsc95xx.c:278
>  check_carrier+0xd1/0x2e0 drivers/net/usb/smsc95xx.c:644
>  process_one_work+0x777/0xf90 kernel/workqueue.c:2274
>  worker_thread+0xa8f/0x1430 kernel/workqueue.c:2420
>  kthread+0x2df/0x300 kernel/kthread.c:255
> 
> It looks like that smsc95xx_unbind() is freeing the structures that are
> still in use by the concurrently running workqueue callback. Thus switch
> to using cancel_delayed_work_sync() to ensure the work callback really
> is no longer active.
> 
> Reported-by: syzbot+29dc7d4ae19b703ff947@syzkaller.appspotmail.com
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

Applied, thanks.
