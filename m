Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7D31E8A70
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgE2Vup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 17:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgE2Vup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 17:50:45 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D750F20707;
        Fri, 29 May 2020 21:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590789045;
        bh=sri8YMGiZ1xVcVFaNw3SSXiGg4AvgkySnNPIaesgh3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oc9pQS96D7Q1ZsEVH4TNvNnyqYQQ/k/RlLBeS6+ElUeFEvFYQ5iArykWhCIIBO0Hs
         TQx3h5pEZCJAv+hyqVxUPKC7F3AVA1d6qcbaqXPe+akV9gbR+pEocLhB6hljjI9l9V
         aIMV9xeJ/TYZXV7B2oDfo+Hv5P5Xvomw0bIgB3lI=
Date:   Fri, 29 May 2020 14:50:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
        <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 20:44:29 +0000 Saeed Mahameed wrote:
> > I thought you said that resync requests are guaranteed to never fail?
> 
> I didn't say that :),  maybe tariq did say this before my review,

Boris ;)

> but basically with the current mlx5 arch, it is impossible to guarantee
> this unless we open 1 service queue per ktls offloads and that is going
> to be an overkill!

IIUC every ooo packet causes a resync request in your implementation -
is that true?

It'd be great to have more information about the operation of the
device in the commit message..

> This is a rare corner case anyway, where more than 1k tcp connections
> sharing the same RX ring will request resync at the same exact moment. 

IDK about that. Certain applications are architected for max capacity,
not efficiency under steady load. So it matters a lot how the system
behaves under stress. What if this is the chain of events:

overload -> drops -> TLS steams go out of sync -> all try to resync

We don't want to add extra load on every record if HW offload is
enabled. That's why the next record hint backs off, checks socket 
state etc.

BTW I also don't understand why mlx5e_ktls_rx_resync() has a
tls_offload_rx_force_resync_request(sk) at the end. If the update 
from the NIC comes with a later seq than current, request the sync 
for _that_ seq. I don't understand the need to force a call back on
every record here. 

Also if the sync failed because queue was full, I don't see how forcing 
another sync attempt for the next record is going to match?
