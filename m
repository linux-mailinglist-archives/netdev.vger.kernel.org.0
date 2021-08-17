Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4703EEEE6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbhHQPF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232705AbhHQPFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 11:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5184060FBF;
        Tue, 17 Aug 2021 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629212692;
        bh=SByw50eAs4QyfClYIcyp6O5ZL5ic9z6TSkIV2b/FWYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SxE0cWJQk1e2eWRWjKxIkESYwOOvh9EQ8HoAKl2zufhfPAfbWCyLUiivS2YeuPWaq
         QOLMlHT8vwJh9Bd1vp8y++j+/4MGB89vawJmEvbe6ndVhnrcDDqm+8OnphRsUylKBZ
         qeaNyBx3GzJ546L9DeBG6oX0jcC78Z5diwqDNnLm5Ujav3F41IbqYh/aH3kQgkyGe9
         FLgnQpAb3E7SvrHid3pavR9HL/ulZaLE4AHy/GyeMAO/zC25yG2g0N4k53XetLchdg
         29CyMyWxp/k++C8RnKVHHHarSSqcpZi6VDjfszqproUjKE0UCt6KpMCDNIPJuSvKQ9
         5tDo+x8W17ZMQ==
Date:   Tue, 17 Aug 2021 08:04:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bechtel <post@jbechtel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210815231738.7b42bad4@mmluhan>
        <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 15:08:00 -0700 Jakub Kicinski wrote:
> On Sun, 15 Aug 2021 23:17:38 +0200 Jonas Bechtel wrote:
> > I've got following installation:
> > * ping 32 bit version
> > * Linux 4.4.0 x86_64 (yes, somewhat ancient)
> > * iproute2  4.9.0 or 4.20.0 or 5.10.0
> > 
> > With one ping command active, there are two raw sockets on my system:
> > one for IPv4 and one for IPv6 (just one of those is used).
> > 
> > My problem is that
> > 
> > ss -awp
> > 
> > shows 
> > * two raw sockets (4.9.0)
> > * any raw socket = bug (4.20.0)
> > * any raw socket = bug (5.10.0)  
> 
> Could you clarify how the bug manifests itself? Does ss crash?
> 
> > So is this a bug or is this wont-fix (then, if it is related to
> > kernel version, package maintainers may be interested)?  

I had a look, I don't see anything out of the ordinary. I checked with
v4.6, I don't have a 4.4 box handy. It seems ss got support for dumping
over netlink in the 4.9. On a 4.4 kernel it should fall back to using
procfs tho, raw_show() calls inet_show_netlink() which should fails and
therefore the code should fall through to the old procfs stuff.

No idea why that doesn't happen for you. Is this vanilla 4.4 or does it
have backports? Is there a /sys/module/raw_diag/ directory on your
system after you run those commands?

Does setting PROC_NET_RAW make the newer iproute version work for you?

$ PROC_NET_RAW=/proc/net/raw ss -awp
