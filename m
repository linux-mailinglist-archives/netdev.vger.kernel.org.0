Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91A26BD5F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIPGjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:39:36 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:56154 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbgIPGjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:39:35 -0400
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 02:39:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wtu7UwIuDippJJwE5jWzvgh91CAIDjoUM/4pw51EOEc=; b=pqmtaaTvkLHf6V1EmHjEox/Z0I
        HvraRytcLRb1olVf6GUtBPM7FbCviCPkC2x7Cspnzm5G1hi/hPR0Ax2FifJ295RGrksZZM4xx/BEW
        GsW+Lw8ce7T4uheXR30LEcxT/xm+1jmG79erCMq1xZpmneERgwtKTlcp/sftGbZTzu/0=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kIR6D-0005AO-Oi; Wed, 16 Sep 2020 09:39:25 +0300
Date:   Wed, 16 Sep 2020 09:39:25 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs
 on failed register reads
Message-ID: <20200916063925.GC38262@p310>
References: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
 <20200916062227.GD142621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916062227.GD142621@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-16 08:22:27, Greg KH wrote: > On Wed, Sep 16, 2020
    at 10:35:40AM +0530, Anant Thazhemadam wrote: > > get_registers() copies
   whatever memory is written by the > > usb_control_msg() call even i [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-16 08:22:27, Greg KH wrote:
> On Wed, Sep 16, 2020 at 10:35:40AM +0530, Anant Thazhemadam wrote:
> > get_registers() copies whatever memory is written by the
> > usb_control_msg() call even if the underlying urb call ends up failing.
> > 
> > If get_registers() fails, or ends up reading 0 bytes, meaningless and 
> > junk register values would end up being copied over (and eventually read 
> > by the driver), and since most of the callers of get_registers() don't 
> > check the return values of get_registers() either, this would go unnoticed.
> > 
> > It might be a better idea to try and mirror the PCI master abort
> > termination and set memory to 0xFFs instead in such cases.
> 
> It would be better to use this new api call instead of
> usb_control_msg():
> 	https://lore.kernel.org/r/20200914153756.3412156-1-gregkh@linuxfoundation.org

Heh, wasn't aware of the new api.

> How about porting this patch to run on top of that series instead?  That 
> should make this logic much simpler.

I'll need to check if in this case 'size' is the right amount of bytes expected 
and not an upper limit.  Then i'll convert it to the new api.


cheers,
Petko


> > Fixes: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
> > Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> > Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> > Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > ---
> >  drivers/net/usb/rtl8150.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> > index 733f120c852b..04fca7bfcbcb 100644
> > --- a/drivers/net/usb/rtl8150.c
> > +++ b/drivers/net/usb/rtl8150.c
> > @@ -162,8 +162,13 @@ static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> >  	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> >  			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
> >  			      indx, 0, buf, size, 500);
> > -	if (ret > 0 && ret <= size)
> > +
> > +	if (ret < 0)
> > +		memset(data, 0xff, size);
> > +
> > +	else
> >  		memcpy(data, buf, ret);
> > +
> >  	kfree(buf);
> >  	return ret;
> >  }
> > @@ -276,7 +281,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
> >  
> >  static inline void set_ethernet_addr(rtl8150_t * dev)
> >  {
> > -	u8 node_id[6];
> > +	u8 node_id[6] = {0};
> 
> This should not be needed to be done.
> 
> thanks,
> 
> greg k-h
> 
