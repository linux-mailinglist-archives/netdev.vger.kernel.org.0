Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30057639B2E
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiK0Ny5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 08:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0Nyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 08:54:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03880B86E;
        Sun, 27 Nov 2022 05:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A4C860D28;
        Sun, 27 Nov 2022 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D01C433D6;
        Sun, 27 Nov 2022 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669557294;
        bh=yBXFwdf6dHy6NKqLSbFuwY2ODTarq/fHEqUCJbDArGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nk7s5lWEAiKkbiHApH4KVdNYo+dE77wMv9el27gVNLV6vJ8bqio04oPle12nog6/N
         QZJnMGnTpuchNmx+393MIhVm5To4LYwv2fgwAWxLOKa3Wbo2x7CZmTxpFABdw+u3gk
         BKlc2ytv29xRY3fdiySvnZCwugu9Z2Y1dflPI6q8=
Date:   Sun, 27 Nov 2022 14:45:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Raed Salem <raeds@nvidia.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Avihai Horon <avihaih@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Ian King <colin.i.king@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] driver core: make struct class.dev_uevent() take a
 const *
Message-ID: <Y4NqAJW5V0tAP8ax@kroah.com>
References: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
 <d448b944-708a-32d4-37d7-0be16ee5f73c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d448b944-708a-32d4-37d7-0be16ee5f73c@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 03:51:11PM -0800, Bart Van Assche wrote:
> On 11/23/22 04:25, Greg Kroah-Hartman wrote:
> > diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
> > index 7dd1f01ec4f9..7aab4a769736 100644
> > --- a/include/linux/mISDNif.h
> > +++ b/include/linux/mISDNif.h
> > @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *, int, clockctl_func_t *,
> >   						void *);
> >   extern void	mISDN_unregister_clock(struct mISDNclock *);
> > -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
> > +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
> >   {
> >   	if (dev)
> >   		return dev_get_drvdata(dev);
> 
> Why does the dev_to_mISDN() function drop constness? I haven't found an
> explanation for this in the cover letter.

I agree, this is going to be fixed up, see the thread starting here:
	https://lore.kernel.org/r/Y34+V2bCDdqujBDk@kroah.com

I'll work on making a const / non const version for these so that we
don't loose the marking.

Oh wait, no, this function is fine, it's not modifying the device
structure at all, and only returning the pointer in the private data
stored in the device.  There is no loss of const-ness here.

thanks,

greg k-h
