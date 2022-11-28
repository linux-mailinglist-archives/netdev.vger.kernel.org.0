Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1397063AED8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiK1RZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiK1RZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:25:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D61B20349;
        Mon, 28 Nov 2022 09:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6D92B80E90;
        Mon, 28 Nov 2022 17:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002F2C433D6;
        Mon, 28 Nov 2022 17:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669656311;
        bh=wZlmYJl8LMxMeefdCbrE5viQuX+AZVgF+lHUSAzV8mA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jklUVBk1mHdNx5UwNOVAyoL9FcfwZD4B7KDGLSBvRl5IAv16CCb++ynZ+TPs/2xnW
         Y09yfkYWX7Zusj8ufWXnQv3O5+iO2GnPgg5dqoMaQRFD7eFKipOag5+WZBxv2B/3hS
         npOJ5H5324elD5m0VsViiZtApWHVqoGlQ7+jDW9I=
Date:   Mon, 28 Nov 2022 18:25:09 +0100
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
Message-ID: <Y4Tu9UUGGiEdFcVw@kroah.com>
References: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
 <d448b944-708a-32d4-37d7-0be16ee5f73c@acm.org>
 <Y4NqAJW5V0tAP8ax@kroah.com>
 <5b14cdea-1bbe-1900-0004-a218ba97bbcb@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b14cdea-1bbe-1900-0004-a218ba97bbcb@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 06:38:39PM -0800, Bart Van Assche wrote:
> On 11/27/22 05:45, Greg Kroah-Hartman wrote:
> > On Fri, Nov 25, 2022 at 03:51:11PM -0800, Bart Van Assche wrote:
> > > On 11/23/22 04:25, Greg Kroah-Hartman wrote:
> > > > diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
> > > > index 7dd1f01ec4f9..7aab4a769736 100644
> > > > --- a/include/linux/mISDNif.h
> > > > +++ b/include/linux/mISDNif.h
> > > > @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *, int, clockctl_func_t *,
> > > >    						void *);
> > > >    extern void	mISDN_unregister_clock(struct mISDNclock *);
> > > > -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
> > > > +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
> > > >    {
> > > >    	if (dev)
> > > >    		return dev_get_drvdata(dev);
> > > 
> > > Why does the dev_to_mISDN() function drop constness? I haven't found an
> > > explanation for this in the cover letter.
> > 
> > I agree, this is going to be fixed up, see the thread starting here:
> > 	https://lore.kernel.org/r/Y34+V2bCDdqujBDk@kroah.com
> > 
> > I'll work on making a const / non const version for these so that we
> > don't loose the marking.
> > 
> > Oh wait, no, this function is fine, it's not modifying the device
> > structure at all, and only returning the pointer in the private data
> > stored in the device.  There is no loss of const-ness here.
> 
> Hi Greg,
> 
> This is what I found in include/linux/mISDNif.h:
> 
> struct mISDNdevice {
> 	struct mISDNchannel	D;
> 	u_int			id;
> 	u_int			Dprotocols;
> 	u_int			Bprotocols;
> 	u_int			nrbchan;
> 	u_char			channelmap[MISDN_CHMAP_SIZE];
> 	struct list_head	bchannels;
> 	struct mISDNchannel	*teimgr;
> 	struct device		dev;
> };
> 
> As one can see 'dev' is a member of struct mISDNdevice. I still think that
> dev_to_mISDN() drops constness. Did I perhaps overlook something?

I think you are missing that dev_to_mISDN() is doing something different
than most dev_to_FOO() functions do (i.e. there is no container_of()
call here at all):

static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
{
	if (dev)
		return dev_get_drvdata(dev);
	else
		return NULL;
}

See, no pointer mess or anything else here, all that happens is the
driver data pointer in struct device is returned.

If this was a "normal" dev_to_FOO() function, then yes, the const-ness
of the pointer would be called into question as the thread I linked to
discusses.

thanks,

greg k-h
