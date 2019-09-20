Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79069B916E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387698AbfITOLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:11:53 -0400
Received: from mail.w1.fi ([212.71.239.96]:60768 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbfITOLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 10:11:53 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 10:11:51 EDT
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id 6738411952;
        Fri, 20 Sep 2019 14:01:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hAKQx5DjrZrw; Fri, 20 Sep 2019 14:01:45 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Fri, 20 Sep 2019 17:01:43 +0300
Date:   Fri, 20 Sep 2019 17:01:43 +0300
From:   Jouni Malinen <j@w1.fi>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.infradead.org,
        openwrt-devel@lists.openwrt.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy crashes
Message-ID: <20190920140143.GA30514@w1.fi>
References: <20190920133708.15313-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190920133708.15313-1-zajec5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 03:37:08PM +0200, Rafał Miłecki wrote:
> Hardware or firmware instability may result in unusable wiphy. In such
> cases usually a hardware reset is needed. To allow a full recovery
> kernel has to indicate problem to the user space.

Why? Shouldn't the driver be able to handle this on its own since all
the previous configuration was done through the driver anyway. As far as
I know, there are drivers that do indeed try to do this and handle it
successfully at least for station mode. AP mode may be more complex, but
for that one, I guess it would be fine to drop all associations (and
provide indication of that to user space) and just restart the BSS.

> This new nl80211 command lets user space known wiphy has crashed and has
> been just recovered. When applicable it should result in supplicant or
> authenticator reconfiguring all interfaces.

For me, that is not really "recovered" if some additional
reconfiguration steps are needed.. I'd like to get a more detailed view
on what exactly might need to be reconfigured and how would user space
know what exactly to do. Or would the plan here be that the driver would
not even indicate this crash if it is actually able to internally
recover fully from the firmware restart?

> I'd like to use this new cfg80211_crash_report() in brcmfmac after a
> successful recovery from a FullMAC firmware crash.
> 
> Later on I'd like to modify hostapd to reconfigure wiphy using a
> previously used setup.

So this implies that at least something would need to happen in AP mode.
Do you have a list of items that the driver cannot do on its own and why
it would be better to do them from user space?

> I'm OpenWrt developer & user and I got annoyed by my devices not auto
> recovering after various failures. There are things I cannot fix (hw
> failures or closed fw crashes) but I still expect my devices to get
> back to operational state as soon as possible on their own.

I fully agree with the auto recovery being important thing to cover for
this, but I'm not yet convinced that this needs user space action. Or if
it does, there would need to be more detailed way of indicating what
exactly is needed for user space to do. The proposed change here is just
saying "hey, I crashed and did something to get the hardware/firmware
responding again" which does not really tell much to user space other
than potentially requiring full disable + re-enable for the related
interfaces. And that is something that should not actually be done in
all cases of firmware crashes since there are drivers that handle
recovery in a manner that is in practice completely transparent to user
space.

-- 
Jouni Malinen                                            PGP id EFC895FA
