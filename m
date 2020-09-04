Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8FB25DB2F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgIDOR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbgIDOP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:15:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E9E206B8;
        Fri,  4 Sep 2020 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599228956;
        bh=5IQon4NL2Pc4o/mdi6hn7eSpI4KNHrVQj5d3OmOMThI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NH/9P2clf5YF/CkstznzYQpOhOlx8FhtuOLRc3V8lBvZZPVN+/LJiVOw0+EndR1ko
         XlWsA3FFOoBuVUCujiAmgY7sdFmVwYI/5pmh6wd1154glxtuw7ps/MfN8yRxO5iIOG
         E0DT50gOCx3aohn1m/BiYZuxRhqW02G4M5LMipJM=
Date:   Fri, 4 Sep 2020 16:16:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Nuernberger <snu@amazon.com>
Cc:     orcohen@paloaltonetworks.com, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Amit Shah <aams@amazon.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net/packet: fix overflow in tpacket_rcv
Message-ID: <20200904141617.GA3185752@kroah.com>
References: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
 <20200904133052.20299-1-snu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904133052.20299-1-snu@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 03:30:52PM +0200, Stefan Nuernberger wrote:
> From: Or Cohen <orcohen@paloaltonetworks.com>
> 
> Using tp_reserve to calculate netoff can overflow as
> tp_reserve is unsigned int and netoff is unsigned short.
> 
> This may lead to macoff receving a smaller value then
> sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
> is set, an out-of-bounds write will occur when
> calling virtio_net_hdr_from_skb.
> 
> The bug is fixed by converting netoff to unsigned int
> and checking if it exceeds USHRT_MAX.
> 
> This addresses CVE-2020-14386
> 
> Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
> Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [ snu: backported to 4.9, changed tp_drops counting/locking ]
> 
> Signed-off-by: Stefan Nuernberger <snu@amazon.com>
> CC: David Woodhouse <dwmw@amazon.co.uk>
> CC: Amit Shah <aams@amazon.com>
> CC: stable@vger.kernel.org
> ---
>  net/packet/af_packet.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
