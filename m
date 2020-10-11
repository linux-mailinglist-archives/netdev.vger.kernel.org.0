Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A6A28A9A9
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgJKTbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:31:38 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:36238 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726333AbgJKTbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lfk8Bx8ZAaoT2rdzuE84wdKCTPTT1fgZZGAXDO2auPE=; b=nPqyL0SK9P/XrtyKOaMoUKTbsZ
        xRYgVjG8lNxwEy1FVQuILLK6LVFkNT/94RWWgrAA/k77UvxU3yrKlBY9HOozL6Qf5vZF6+nFO0Pce
        KyKp6tbXGyNRzOl/OpmTfvS/Bw+c79ZjIMEqJyenZ8b5RTfuh1hNzw75fV1Cxn1Da/pU=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kRh3v-0007ru-He; Sun, 11 Oct 2020 22:31:19 +0300
Date:   Sun, 11 Oct 2020 22:31:19 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random
 MAC addresses
Message-ID: <20201011193119.GA4061@p310>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
 <20201011173030.141582-1-anant.thazhemadam@gmail.com>
 <20201011105934.5c988cd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6307397bd43636fea2e7341d24417cbbc3aaf922.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6307397bd43636fea2e7341d24417cbbc3aaf922.camel@perches.com>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-10-11 11:33:00, Joe Perches wrote: > On Sun, 2020-10-11
    at 10:59 -0700, Jakub Kicinski wrote: > > On Sun, 11 Oct 2020 23:00:30 +0530
    Anant Thazhemadam wrote: > > > In set_ethernet_addr(), if get [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-11 11:33:00, Joe Perches wrote:
> On Sun, 2020-10-11 at 10:59 -0700, Jakub Kicinski wrote:
> > On Sun, 11 Oct 2020 23:00:30 +0530 Anant Thazhemadam wrote:
> > > In set_ethernet_addr(), if get_registers() succeeds, the ethernet address
> > > that was read must be copied over. Otherwise, a random ethernet address
> > > must be assigned.
> > > 
> > > get_registers() returns 0 if successful, and negative error number
> > > otherwise. However, in set_ethernet_addr(), this return value is
> > > incorrectly checked.
> > > 
> > > Since this return value will never be equal to sizeof(node_id), a
> > > random MAC address will always be generated and assigned to the
> > > device; even in cases when get_registers() is successful.
> > > 
> > > Correctly modifying the condition that checks if get_registers() was
> > > successful or not fixes this problem, and copies the ethernet address
> > > appropriately.
> 
> There are many unchecked uses of set_registers and get_registers
>  in this file.
> 
> If failures are really expected, then it might be better to fix
> them up too.

Checking the return value of each get/set_registers() is going to be a PITA and
not very helpful.  Doing so when setting the MAC address _does_ make sense as in
that case it is not a hard error.

In almost all other occasions if usb_control_msg_send/recv() return an error i'd
rather dump an error message (from within get/set_registers()) and let the user
decide whether to get rid of this adapter or start debugging it.


cheers,
Petko


> $ git grep -w '[gs]et_registers' drivers/net/usb/rtl8150.c
> drivers/net/usb/rtl8150.c:static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> drivers/net/usb/rtl8150.c:static int set_registers(rtl8150_t * dev, u16 indx, u16 size, const void *data)
> drivers/net/usb/rtl8150.c:      set_registers(dev, PHYADD, sizeof(data), data);
> drivers/net/usb/rtl8150.c:      set_registers(dev, PHYCNT, 1, &tmp);
> drivers/net/usb/rtl8150.c:              get_registers(dev, PHYCNT, 1, data);
> drivers/net/usb/rtl8150.c:              get_registers(dev, PHYDAT, 2, data);
> drivers/net/usb/rtl8150.c:      set_registers(dev, PHYADD, sizeof(data), data);
> drivers/net/usb/rtl8150.c:      set_registers(dev, PHYCNT, 1, &tmp);
> drivers/net/usb/rtl8150.c:              get_registers(dev, PHYCNT, 1, data);
> drivers/net/usb/rtl8150.c:      ret = get_registers(dev, IDR, sizeof(node_id), node_id);
> drivers/net/usb/rtl8150.c:      set_registers(dev, IDR, netdev->addr_len, netdev->dev_addr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:      set_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:              set_registers(dev, IDR_EEPROM + (i * 2), 2,
> drivers/net/usb/rtl8150.c:      set_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:      set_registers(dev, CR, 1, &data);
> drivers/net/usb/rtl8150.c:              get_registers(dev, CR, 1, &data);
> drivers/net/usb/rtl8150.c:      set_registers(dev, RCR, 1, &rcr);
> drivers/net/usb/rtl8150.c:      set_registers(dev, TCR, 1, &tcr);
> drivers/net/usb/rtl8150.c:      set_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, MSR, 1, &msr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:      set_registers(dev, CR, 1, &cr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, CSCR, 2, &tmp);
> drivers/net/usb/rtl8150.c:      set_registers(dev, IDR, 6, netdev->dev_addr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, BMCR, 2, &bmcr);
> drivers/net/usb/rtl8150.c:      get_registers(dev, ANLP, 2, &lpa);
> 
> 
> 
