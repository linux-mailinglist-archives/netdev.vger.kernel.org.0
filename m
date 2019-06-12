Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C683E4286A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439582AbfFLOJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:09:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436722AbfFLOJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G8cnegkgLj8HIVPm0uNCzgOo5RYPJrR2RspEMWthgSk=; b=YlQnhPUmIadnbjfUYCJw2j/BWH
        d6Id/aJ0bGlcddFjklx4nPXKvz8VnGS3xTzvhFPFhqkigFyrRIqc8ogRUYI6ZqIxxaUEgMjQNYyOh
        9xtrp1zt9WIShE8wx+OKBj2WHlVST2UYx7sQURVMdqZyB+jghGkj5//AhhZIIgXaPSO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb3w1-00057g-5T; Wed, 12 Jun 2019 16:09:05 +0200
Date:   Wed, 12 Jun 2019 16:09:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: net-next: KSZ switch driver oops in ksz_mib_read_work
Message-ID: <20190612140905.GB18923@lunn.ch>
References: <6dc8cc46-6225-011c-68bc-c96a819fa00d@sedsystems.ca>
 <3f8ee5e5-9996-dd74-807a-a4b24cd9ee4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8ee5e5-9996-dd74-807a-a4b24cd9ee4c@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 04:27:47PM -0700, Florian Fainelli wrote:
> On 6/11/19 10:57 AM, Robert Hancock wrote:
> > We are using an embedded platform with a KSZ9897 switch. I am getting
> > the oops below in ksz_mib_read_work when testing with net-next branch.
> > After adding in some debug output, the problem is in this code:
> > 
> > 	for (i = 0; i < dev->mib_port_cnt; i++) {
> > 		p = &dev->ports[i];
> > 		mib = &p->mib;
> > 		mutex_lock(&mib->cnt_mutex);
> > 
> > 		/* Only read MIB counters when the port is told to do.
> > 		 * If not, read only dropped counters when link is not up.
> > 		 */
> > 		if (!p->read) {
> > 			const struct dsa_port *dp = dsa_to_port(dev->ds, i);
> > 
> > 			if (!netif_carrier_ok(dp->slave))
> > 				mib->cnt_ptr = dev->reg_mib_cnt;
> > 		}
> > 
> > The oops is happening on port index 3 (i.e. 4th port) which is not
> > connected on our platform and so has no entry in the device tree. For
> > that port, dp->slave is NULL and so netif_carrier_ok explodes.
> > 
> > If I change the code to skip the port entirely in the loop if dp->slave
> > is NULL it seems to fix the crash, but I'm not that familiar with this
> > code. Can someone confirm whether that is the proper fix?
> 
> Yes, the following should do it, if you confirm that is the case, I can
> send that later with your Tested-by.
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c
> b/drivers/net/dsa/microchip/ksz_common.c
> index 39dace8e3512..5470b28332cf 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -93,6 +93,9 @@ static void ksz_mib_read_work(struct work_struct *work)
>                 if (!p->read) {
>                         const struct dsa_port *dp = dsa_to_port(dev->ds, i);
> 
> +                       if (dsa_is_unused_port(dp))
> +                               continue;
> +
>                         if (!netif_carrier_ok(dp->slave))
>                                 mib->cnt_ptr = dev->reg_mib_cnt;
>                 }
> 

Hi Florian

There is a mutex held within the loop. So a continue is not going to
work here.

     Andrew
