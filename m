Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B4B275A9C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWOs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:48:56 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:60634 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726504AbgIWOs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4DYJKE8l8EdESOXVwsp+gos89esEsmURD8s5B4Bsfec=; b=RSQ+DQS4PaLen4FanX1zUpusmC
        OHWXejqIFItnVTGDp+b/dg12zVaDRxod2M2lHqBTd1wuU9VdN4tAlPOYuXIbLyW6webaKVGsHb4sU
        +Zv3/lgtW70dj7YK6MLfjmP/UtcK+EgPmtQCn+YK7eXj64c571iIXke3Ne1v7OP9dCYU=;
Received: from [94.26.108.4] (helo=karbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kL64P-0005m4-T2; Wed, 23 Sep 2020 17:48:34 +0300
Date:   Wed, 23 Sep 2020 17:48:32 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, yuehaibing@huawei.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
Message-ID: <20200923144832.GA11151@karbon>
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com>
 <1600856557.26851.6.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600856557.26851.6.camel@suse.com>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-23 12:22:37, Oliver Neukum wrote: > Am Mittwoch,
   den 23.09.2020, 14:35 +0530 schrieb Himadri Pandya: > > Hi, > > > Many usage
    of usb_control_msg() do not have proper error check on return > > [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-23 12:22:37, Oliver Neukum wrote:
> Am Mittwoch, den 23.09.2020, 14:35 +0530 schrieb Himadri Pandya:
> 
> Hi,
> 
> > Many usage of usb_control_msg() do not have proper error check on return
> > value leaving scope for bugs on short reads. New usb_control_msg_recv()
> > and usb_control_msg_send() nicely wraps usb_control_msg() with proper
> > error check. Hence use the wrappers instead of calling usb_control_msg()
> > directly.
> > 
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> Nacked-by: Oliver Neukum <oneukum@suse.com>
> 
> > ---
> >  drivers/net/usb/rtl8150.c | 32 ++++++--------------------------
> >  1 file changed, 6 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> > index 733f120c852b..e3002b675921 100644
> > --- a/drivers/net/usb/rtl8150.c
> > +++ b/drivers/net/usb/rtl8150.c
> > @@ -152,36 +152,16 @@ static const char driver_name [] = "rtl8150";
> >  */
> >  static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> >  {
> > -	void *buf;
> > -	int ret;
> > -
> > -	buf = kmalloc(size, GFP_NOIO);
> 
> GFP_NOIO is used here for a reason. You need to use this helper
> while in contexts of error recovery and runtime PM.
> 
> > -	if (!buf)
> > -		return -ENOMEM;
> > -
> > -	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> > -			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
> > -			      indx, 0, buf, size, 500);
> > -	if (ret > 0 && ret <= size)
> > -		memcpy(data, buf, ret);
> > -	kfree(buf);
> > -	return ret;
> > +	return usb_control_msg_recv(dev->udev, 0, RTL8150_REQ_GET_REGS,
> > +				    RTL8150_REQT_READ, indx, 0, data,
> > +				    size, 500);
> 
> This internally uses kmemdup() with GFP_KERNEL.
> You cannot make this change. The API does not support it.
> I am afraid we will have to change the API first, before more
> such changes are done.

One possible fix is to add yet another argument to usb_control_msg_recv(), which 
would be the GFP_XYZ flag to pass on to kmemdup().  Up to Greg, of course.


cheers,
Petko
