Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC931940
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFADWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:22:21 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25886 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFADWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:22:20 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x513MGjZ008228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 21:22:17 -0600 (CST)
Received: from intranet.sedsystems.ca (itm1n2.itm.sedsystems.ca [172.31.1.2])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x513MGk2043705;
        Fri, 31 May 2019 21:22:16 -0600
Received: from 192.168.233.77
        (SquirrelMail authenticated user hancock)
        by intranet.sedsystems.ca with HTTP;
        Fri, 31 May 2019 21:22:16 -0600 (CST)
Message-ID: <8fc39ed123aede7ab23954ba06ff4cd5.squirrel@intranet.sedsystems.ca>
In-Reply-To: <49e18fde-5ac4-22ad-90ec-0cbad64d743a@gmail.com>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
    <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
    <20190531205421.GC3154@lunn.ch>
    <49e18fde-5ac4-22ad-90ec-0cbad64d743a@gmail.com>
Date:   Fri, 31 May 2019 21:22:16 -0600 (CST)
Subject: Re: [PATCH net-next] net: phy: Ensure scheduled work is cancelled 
     during removal
From:   hancock@sedsystems.ca
To:     "Heiner Kallweit" <hkallweit1@gmail.com>
Cc:     "Andrew Lunn" <andrew@lunn.ch>,
        "Robert Hancock" <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        "Florian Fainelli" <f.fainelli@gmail.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 31.05.2019 22:54, Andrew Lunn wrote:
>>> It is possible that scheduled work started by the PHY driver is still
>>> outstanding when phy_device_remove is called if the PHY was initially
>>> started but never connected, and therefore phy_disconnect is never
>>> called. phy_stop does not guarantee that the scheduled work is stopped
>>> because it is called under rtnl_lock. This can cause an oops due to
>>> use-after-free if the delayed work fires after freeing the PHY device.
>>>
> The patch itself at least shouldn't do any harm. However the justification
> isn't fully convincing yet.
> PHY drivers don't start any scheduled work. This queue is used by the
> phylib state machine. phy_stop usually isn't called under rtnl_lock,
> and it calls phy_stop_machine that cancels pending work.
> Did you experience such an oops? Can you provide a call chain where
> your described scenario could happen?

Upon further investigation, it appears that this change is no longer
needed in the mainline. Previously (such as in 4.19 kernels as we are
using), phy_stop did not call phy_stop_machine, only phy_disconnect did,
so if the phy was started but never connected and disconnected before
stopping it, the delayed work was not stopped. That sequence didn't occur
often, but could happen in some failure cases which I believe was what I
ran into during development when this change was originally made.

It looks like this was fixed in commit
cbfd12b3e8c3542e8142aa041714ed614d3f67b0 "net: phy: ensure phylib state
machine is stopped after calling phy_stop". So my patch can be dropped -
but maybe that patch should be added to stable?

