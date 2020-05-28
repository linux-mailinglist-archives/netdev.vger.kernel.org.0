Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D11E5227
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgE1APM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:15:12 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:25734 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgE1APM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:15:12 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 49XSrZ01RrzGW;
        Thu, 28 May 2020 02:15:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1590624910; bh=bE5OIfRgRR3wz2fkwDTc4dDloItTfp73c2jh7ITkw/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cx20+T6We4k3t5E0V87ihGNXNbKLURdTutLdwBVVajF/UVckTq5QseiAkWM/zuZHd
         HmM6N5I2fevT6zQG1x4Mty2GAm/4BsSobWEEX1GoUDEg/8pt/guqgRou3ynxOsvT6Q
         ekFC1m8y9qdEfQsI5gUv0IM+eRb+aXmEuPxBZLnQhk5PiWB0HHaOuwo6pBwmS371Hd
         bp+xgRpGVAVso2Bx8yIO9DpkCVywB7vJbsfEPc1Hng9rcZdZiieq3T0b1Cj96bJMqD
         Ck/UK9jqkQd3Qd9Ml0wAoObuBtS7ZL5s62nDiHm+4t7MNo0p2V/Lr78hjfWb1sNumk
         ffhDH40Yu0cng==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.2 at mail
Date:   Thu, 28 May 2020 02:15:07 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 00/11] Nested VLANs - decimate flags and add
 another
Message-ID: <20200527234849.GA18589@qmqm.qmqm.pl>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 02:25:01PM -0700, Edwin Peer wrote:
> This series began life as a modest attempt to fix two issues pertaining
> to VLANs nested inside Geneve tunnels and snowballed from there. The
> first issue, addressed by a simple one-liner, is that GSO is not enabled
> for upper VLAN devices on top of Geneve. The second issue, addressed by
> the balance of the series, deals largely with MTU handling. VLAN devices
> above L2 in L3 tunnels inherit the MTU of the underlying device. This
> causes IP fragmentation because the inner L2 cannot be expanded within
> the same maximum L3 size to accommodate the additional VLAN tag.
> 
> As a first attempt, a new flag was introduced to generalize what was
> already being done for MACsec devices. This flag was unconditionally
> set for all devices that have a size constrained L2, such as is the
> case for Geneve and VXLAN tunnel devices. This doesn't quite do the
> right thing, however, if the underlying device MTU happens to be
> configured to a lower MTU than is supported. Thus, the approach was
> further refined to set IFF_NO_VLAN_ROOM when changing MTU, based on
> whether the underlying device L2 still has room for VLAN tags, but
> stopping short of registering device notifiers to update upper device
> MTU whenever a lower device changes. VLAN devices will thus do the
> sensible thing if they are applied to an already configured device,
> but will not dynamically update whenever the underlying device's MTU
> is subsequently changed (this seemed a bridge too far).
[...]

Hi!

Good to see someone taking on the VLAN MTU mess.  :-)

Have you considered adding a 'vlan_headroom' field (or another name)
for a netdev instead of a flag? This would submit easily to device
aggregation (just take min from the slaves) and would also handle
nested VLANs gracefully (subtracting for every layer).

In patch 3 you seem to assume that if lower device reduces MTU below
its max, then its ok to push it up with VLAN headers. I don't think
this is apropriate when reducing MTU because of eg. PMTU limit for
a tunnel.

Best Regards,
Micha³ Miros³aw
