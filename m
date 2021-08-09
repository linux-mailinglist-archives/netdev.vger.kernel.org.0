Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA03E3F84
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 08:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhHIGES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 02:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhHIGER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 02:04:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CB260C3E;
        Mon,  9 Aug 2021 06:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628489037;
        bh=sWAw75zZz3G5utbaawNJ9M8XWQpHCfrrFx10QMwrBM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVi+9IZ56hb1Yrk0bQgyiFjceH3/LV1yycjXzre9VzjdCzGrX62pSWhsusO6nbY/l
         MBU345akzBmRay09rI7LBFMR92VLwGxZs+/s2roSNi14kf2d9hB5p4CEMIrvseezVH
         UucrWtXLq5sMNbAdiPfZo/YVw0iV9xQ6maz0gVS8ObZC8cCPFzlqQpGUd0PO/X6eJZ
         /slIgcWiabRDvvzYt3twZ4+ce6sizPvzR9Gg/QRCoJ9qyL2FzBUfE4kJWY1JoYej0m
         ESZOGBFJ1Zb+YpuFuv3RT5A1j4/Ety+q99WdUwn4cn4+xwYBP35gEx7GZ4qixk2Hzp
         eTUdj1lBQ1IYg==
Date:   Mon, 9 Aug 2021 09:03:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
Message-ID: <YRDFSbxtN9uYBMbK@unreal>
References: <cover.1628306392.git.jtoppins@redhat.com>
 <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
 <YQ+vDtXPV5DHqruU@unreal>
 <14b506c3-7e8d-f313-b585-4e7ff1a542cf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14b506c3-7e8d-f313-b585-4e7ff1a542cf@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 09:42:46PM -0400, Jonathan Toppins wrote:
> On 8/8/21 6:16 AM, Leon Romanovsky wrote:
> > On Fri, Aug 06, 2021 at 11:30:55PM -0400, Jonathan Toppins wrote:
> > > There seems to be no reason to have different error messages between
> > > netlink and printk. It also cleans up the function slightly.
> > > 
> > > Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> > > ---
> > >   drivers/net/bonding/bond_main.c | 45 ++++++++++++++++++---------------
> > >   1 file changed, 25 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > index 3ba5f4871162..46b95175690b 100644
> > > --- a/drivers/net/bonding/bond_main.c
> > > +++ b/drivers/net/bonding/bond_main.c
> > > @@ -1712,6 +1712,16 @@ void bond_lower_state_changed(struct slave *slave)
> > >   	netdev_lower_state_changed(slave->dev, &info);
> > >   }
> > > +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
> > > +} while (0)
> > > +
> > > +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
> > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
> > > +} while (0)
> > 
> > I don't think that both extack messages and dmesg prints are needed.
> > 
> > They both will be caused by the same source, and both will be seen by
> > the caller, but duplicated.
> > 
> > IMHO, errors that came from the netlink, should be printed with NL_SET_ERR_MSG(),
> > other errors should use netdev_err/slave_err prints.
> > 
> 
> bond_enslave can be called from two places sysfs and netlink so reporting
> both a console message and netlink message makes sense to me. So I have to
> disagree in this case. I am simply making the two paths report the same
> error in the function so that when using sysfs the same information is
> reported. In the netlink case the information will be reported twice, once
> an an error response over netlink and once via printk.

There is no need to print any errors twice, just add "if (extack)" to you
macros, something like that:

+#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do { 
*       if (extack) 						\
+       	NL_SET_ERR_MSG(extack, errmsg);                 \
+       else 							\
+       	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");  \
+} while (0)

Thanks

> 
> -Jon
> 
