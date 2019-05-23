Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06571273C6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfEWBFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:05:51 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26480 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558573549;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8VaFhlt3Sv+uRqmY+OUjVcUQP1dzNRTWZVk7slXg7j8=;
        b=OAUyoqWOIVBOtP4Velp/PXn3grMfZg+uXzcGM8C7S0OSYuJolqOivoC8LbrgzKo5lS
        q3q27edKHDs0K9WQSzfhm3JDiWCngUyPGhVP+PsluueT7hWWKJ2bNiYZngYkWQr1Wbso
        iXmuYDAEB7h5zGf2rp8uxncrE0pYZxMVqYkcIjgNYFzx/Ua9uDbWdxjI6SOPAzJ34E9o
        xJHhLcKSwBvWWed/A1QdUT7768j4L6jEKSqTbD4Yep9vtVVjHXw/hfjl+vR/HpEhD20v
        slpqPsWBaDcYH9DjDP+bU8e9GwrfKmJ/gLi61CjzQ53WeidkICbAPg8Y99JsC1A2qgsc
        H/iQ==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-01.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.18 AUTH)
        with ESMTPSA id y08c83v4N12jF5v
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Thu, 23 May 2019 03:02:45 +0200 (CEST)
Date:   Thu, 23 May 2019 03:02:45 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Simon Horman <horms@verge.net.au>, Wolfram Sang <wsa@the-dreams.de>
Cc:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, magnus.damm@gmail.com
Message-ID: <591180619.231842.1558573365579@webmail.strato.com>
In-Reply-To: <20190522115916.vlnbna2vxnf7zhod@verge.net.au>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
 <434070244.1141414.1557385064484@webmail.strato.com>
 <20190509101020.4ozvazptoy53gh55@verge.net.au>
 <344020243.1186987.1557415941124@webmail.strato.com>
 <20190513121807.cutayiact3qdbxt4@verge.net.au>
 <20190520120954.ffz2ius5nvojkxlh@katana>
 <20190522115916.vlnbna2vxnf7zhod@verge.net.au>
Subject: Re: [PATCH] ravb: implement MTU change while device is up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev58
X-Originating-IP: 85.212.212.17
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On May 22, 2019 at 1:59 PM Simon Horman <horms@verge.net.au> wrote:
> 
> 
> On Mon, May 20, 2019 at 02:09:54PM +0200, Wolfram Sang wrote:
> > 
> > > > > > > >    How about the code below instead?
> > > > > > > > 
> > > > > > > > 	if (netif_running(ndev))
> > > > > > > > 		ravb_close(ndev);
> > > > > > > > 
> > > > > > > >  	ndev->mtu = new_mtu;
> > > > > > > > 	netdev_update_features(ndev);
> > > > > > > 
> > > > > > > Is there a need to call netdev_update_features() even if the if is not 
> > > > > > > running?
> > > > > > 
> > > > > > In my testing, it didn't seem so.
> > > > > 
> > > > > That may be because your testing doesn't cover cases where it would make
> > > > > any difference.
> > > > 
> > > > Cases other than changing the MTU while the device is up?
> > > 
> > > I was thinking of cases where listeners are registered for the
> > > notifier that netdev_update_features() triggers.
> > 
> > Where are we here? Is this a blocker?
> 
> I don't think this is a blocker but I would lean towards leaving
> netdev_update_features() in unless we are certain its not needed.
>

I have read through the code and have indeed not found any indication that netdev_update_features() or something equivalent is called implicitly when the device is closed and reopened. I'll send a v2.

CU
Uli
