Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66131277859
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgIXSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgIXSQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 14:16:59 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BD8F2220C;
        Thu, 24 Sep 2020 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600971418;
        bh=JPivfR2n/6nemaw09kY1pefU4DjbtFAdL/4DuMfFtrM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=goUH5wUrdNs2WMt+MIFXzoV3g8PVZRp68KVUnuX9gO4apR8YOFv1L5arow4xX4knN
         nDxYZCZpa2SDsZ4XofsH8ChkuQg4+ijfy2ARP4ma+cboJqmE060WLF5QaKB4dvfalD
         GVgt6BSTNGYYKBkB0qJIrlHz+RS3IlJfmfLIHXw0=
Message-ID: <f53b1ea0c733b58a242fd18a3e6c97a7b00ed01e.camel@kernel.org>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, hkallweit1@gmail.com,
        geert+renesas@glider.be, f.fainelli@gmail.com, andrew@lunn.ch,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Sep 2020 11:16:57 -0700
In-Reply-To: <20200924090311.745cac3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
         <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
         <20200923.172125.1341776337290371000.davem@davemloft.net>
         <20200923.172349.872678515629678579.davem@davemloft.net>
         <2cf4178e970d2737e7ba866ebc83a7ec30ca8ad1.camel@kernel.org>
         <20200924090311.745cac3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-24 at 09:03 -0700, Jakub Kicinski wrote:
> On Wed, 23 Sep 2020 22:49:37 -0700 Saeed Mahameed wrote:
> > 2) Another problematic scenario which i see is repeated in many
> > drivers:
> > 
> > shutdown/suspend()
> >     rtnl_lock()
> >     netif_device_detach()//Mark !present;
> >     stop()->carrier_off()->linkwatch_event()
> >     // at this point device is still IFF_UP and !present
> >     // due to the early detach above..  
> >     rtnl_unlock();
> 
> Maybe we can solve this by providing drivers with a better helper for
> the suspend use case?
> 
> AFAIU netif_device_detach() is used by both IO errors and drivers
> willingly detaching the device during normal operation (e.g. for
> suspend).
> 
> Since the suspend path can sleep if we have a separate helper perhaps
> we could fire off the appropriate events synchronously, and
> quiescence
> the stack properly?

I was thinking something similar, a more heavy
weight netif_device_detach(), which will be used in all drivers suspend
flows.
 
1) clear IFF_UP
2) ndo_stop()
3) fire events
4) mark !present
...

5) suspend device


but went and sampled some drivers and found there are many variations
for using netif_device_detach it is not going to be a simple task.

