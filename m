Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADEB276897
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 07:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgIXFtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 01:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgIXFtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 01:49:39 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC961235FD;
        Thu, 24 Sep 2020 05:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600926579;
        bh=VuY5deMJpz9RpbOl6ZDHNd/ktzmGDQjVZoET55OsRWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jTLCPGelAzygXjPA2HO7IY5wi7yWYHK5PC4oxtY34gJoes5bpf+lKxVYIUfll6KIO
         QGqL8VcoNjtRZoybO9cZmHdjLLYnLR4H/VvE9ZloteQCUSacBhUO5JmUXVDoezbVAj
         C6IfzOyB8gVydyoilEG7BAGSBpZHUf51jgI6q4Ys=
Message-ID: <2cf4178e970d2737e7ba866ebc83a7ec30ca8ad1.camel@kernel.org>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     hkallweit1@gmail.com, geert+renesas@glider.be,
        f.fainelli@gmail.com, andrew@lunn.ch, kuba@kernel.org,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Sep 2020 22:49:37 -0700
In-Reply-To: <20200923.172349.872678515629678579.davem@davemloft.net>
References: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
         <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
         <20200923.172125.1341776337290371000.davem@davemloft.net>
         <20200923.172349.872678515629678579.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-23 at 17:23 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 23 Sep 2020 17:21:25 -0700 (PDT)
> 
> > If an async code path tests 'present', gets true, and then the RTNL
> > holding synchronous code path puts the device into D3hot
> immediately
> > afterwards, the async code path will still continue and access the
> > chips registers and fault.
> 
> Wait, is the sequence:
> 
>         ->ndo_stop()
>                 mark device not present and put into D3hot
>                 triggers linkwatch event
>           ...
>                          ->ndo_get_stats64()
> 
> ???
> 

I assume it is, since normally device drivers do carrier_off() on
ndo_stop()

1) One problematic sequence would be 
(for drivers doing D3hot on ndo_stop())

__dev_close_many()
   ->ndo_stop()
      netif_device_detach() //Mark !present;
      ... D3hot
      carrier_off()->linkwatch_event()
            ... // !present && IFF_UP 
      
2) Another problematic scenario which i see is repeated in many
drivers:

shutdown/suspend()
    rtnl_lock()
    netif_device_detach()//Mark !present;
    stop()->carrier_off()->linkwatch_event()
    // at this point device is still IFF_UP and !present
    // due to the early detach above..  
    rtnl_unlock();
   
For scenario 1) we can fix by marking IFF_UP at the beginning, but for
2), i think we need to fix the drivers to detach only after stop :(
   
> Then yeah we might have to clear IFF_UP at the beginning of taking
> a netdev down.


