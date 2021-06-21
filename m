Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888803AF9A3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 01:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhFUXno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 19:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231486AbhFUXno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 19:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7657960FE7;
        Mon, 21 Jun 2021 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624318889;
        bh=M211reC/PzUa2fK5zaX69qouLBACz0NJLv2ZEfcCGHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3dSRu4iK4ALJu4TJDPv1Ofls54TnkuUynhZHACmVruxyjoLUzRKDRYvkyj2+wRpu
         yXUyrSIVkGr/2S7CXDwcXB7vELZtK1l6YvNGemtLtqBatqb/rdQ+tZF7RBboUvwf6e
         fwZXZ+tJx2dKE0behVJLMpq7ccINJySHjVV3tMn5MDTWyLoCdBdl2Jfb0K25PNhcLQ
         O4steJLCcykd1QLOKP4rfndqsL1znBQjUGKJulH49oR4yAHPAzkxKaPX2trwnvsOqH
         jPSZSfqROQxW+G+1jtoWw9Uz8eP9Z2mhyNOcuhoVS/xEoCT4dOcsoGLg25xcS3oDo+
         tvUSGiYcVzJIw==
Date:   Mon, 21 Jun 2021 16:41:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arijit De <arijitde@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: Ping frame drop
Message-ID: <20210621164128.6ed5556f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR18MB39942C03084DA2E773928C72D40C9@SJ0PR18MB3994.namprd18.prod.outlook.com>
References: <SJ0PR18MB3994A5156DF9B144838A746ED40D9@SJ0PR18MB3994.namprd18.prod.outlook.com>
        <20210618151941.04a2494d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR18MB39942C03084DA2E773928C72D40C9@SJ0PR18MB3994.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please don't top post.

On Sat, 19 Jun 2021 15:14:35 +0000 Arijit De wrote:
> In my network card HW it can verify the received frame's checksum of
> IPv4 header, but it can't verify the checksum of ICMP header. 

Linux does not offload IPv4 header checksums.

> So for
> ICMP kind of received frames driver sets the checksum state to
> CHECKSUM_PARTIAL in skb->ip_summed. Which is as per the linux kernel
> documentation also. 

What documentation are you reading? Setting ip_summed to PARTIAL on
receive is only valid for software/virtual devices, never real HW.

> Now before the commit
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=8f9a69a92fc63917c9bd921b28e3b2912980becf
> this use case was working. But now after introducing this logic for
> CHECKSUM_PARTIAL case, my received ICMP ping frames are getting
> dropped in the linux kernel pskb_trim_rcsum_slow(). I do understand
> that to bypass this scenario I can use CHECKSUM_NONE, but in that
> case HW's capability where checksum is already verified for the IPv4
> header will be unutilized. 
> 
> So please do share if any documentation update has happened for the
> CHECKSUM_PARTIAL scenario or please do let me know what need to be
> updated in the skb for the receive frame in this scenario where only
> Networking layer (i.e. IPv4 in this case) checksum is verified but
> the ICMP(ping) header checksum is not verified  ?

