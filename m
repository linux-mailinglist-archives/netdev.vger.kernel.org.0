Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2B4462E5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFNPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:34:27 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:33167 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNPe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1560526466;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2bbreNXRy6dVTi/X+I1wm0LTcrhWDDWbP5P/grVWZLc=;
        b=tPjADQG7Tb7mAPPhwHD/B+nvgkoyMkLVE2dMb0y0dIMwMbyk/U1+dzuZjDxX+ku3Mi
        AR2m8p3P4ZPLWTShURRiEKHy/P8WFutppiNJziF4CTct+P0v8ucntd+iIAnab/s2nXR0
        7hXzCIH8Pz9IUp18kHETUPEuDmUglGhaSytCpVg/i9Ejc6h8sJljUt/P1+dtF+ln/dwq
        pn6rtmwtDwoM2hhdDb+IXSS+T1AVKmr3YKuZzd/Lb/SBH7BM0nlDOIe7yhjAjtvLkZAn
        bmxZgL2/ULDaqD+Ub/sVLy5EEHZt8U73GuYndskncA0fj54PXxJlWM2tPt+IS+zaU9JW
        +jmw==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp02-03.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.23 AUTH)
        with ESMTPSA id 603925v5EFS96JJ
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 14 Jun 2019 17:28:09 +0200 (CEST)
Date:   Fri, 14 Jun 2019 17:28:09 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     David Miller <davem@davemloft.net>, uli+renesas@fpond.eu
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com
Message-ID: <1736739012.636692.1560526089090@webmail.strato.com>
In-Reply-To: <20190605.190825.2245741686094611389.davem@davemloft.net>
References: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
 <20190605.190825.2245741686094611389.davem@davemloft.net>
Subject: Re: [PATCH v2] ravb: implement MTU change while device is up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev58
X-Originating-IP: 85.212.196.41
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On June 6, 2019 at 4:08 AM David Miller <davem@davemloft.net> wrote:
> 
> 
> From: Ulrich Hecht <uli+renesas@fpond.eu>
> Date: Wed,  5 Jun 2019 17:14:20 +0200
> 
> > @@ -1811,11 +1811,14 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
> >  static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
> >  {
> >  	if (netif_running(ndev))
> > -		return -EBUSY;
> > +		ravb_close(ndev);
> >  
> >  	ndev->mtu = new_mtu;
> >  	netdev_update_features(ndev);
> >  
> > +	if (netif_running(ndev))
> > +		return ravb_open(ndev);
> > +
> 
> And if ravb_open() fails?  The user sees a failure, but to the user the failure
> means the MTU change can't be done, yet the device has the new MTU set still.
> 
> This really is terrible behavior.
> 
> If you must do a prepare/commit kind of sequence for this to work properly if
> you are going to go down the road of taking the device down to change the MTU
> when the device is UP.

So would rolling back the MTU change in case of a re-open failure be acceptable?

If so, is there additional action that needs to be taken if a device unexpectedly goes down as a side-effect of an MTU change?

CU
Uli
