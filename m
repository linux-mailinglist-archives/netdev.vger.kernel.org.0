Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D27170DF5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgB0Bhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbgB0Bhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 20:37:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775A1208E4;
        Thu, 27 Feb 2020 01:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582767473;
        bh=ut9DRKOHm8KOJIlXHPDFbdv5xJK2MELW0SXZxXzrfno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LD+O0vEgbpLYMKYaD38u/JtxkurNExsx9XaEcuepzKwmTnxNyV1Njav+mWFQUwWLo
         W+rq2y60SrMI52b7roR1HtZgl9JhR8s9xPXiZNToTa5H/cBULqfnesYX8CQX1WK+CM
         H3ySc3n4OYkGvQlZk47rYp8XBSZEza6aS8G1XQU8=
Date:   Wed, 26 Feb 2020 17:37:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200226120142-mutt-send-email-mst@kernel.org>
References: <20200226093330.GA711395@redhat.com>
        <87lfopznfe.fsf@toke.dk>
        <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
        <20200226115258-mutt-send-email-mst@kernel.org>
        <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
        <20200226120142-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 12:02:03 -0500 Michael S. Tsirkin wrote:
> On Wed, Feb 26, 2020 at 09:58:00AM -0700, David Ahern wrote:
> > On 2/26/20 9:55 AM, Michael S. Tsirkin wrote:  
> > > OK that seems to indicate an ndo callback as a reasonable way
> > > to handle this. Right? The only problem is this might break
> > > guests if they happen to reverse the order of
> > > operations:
> > > 	1. set mtu
> > > 	2. detach xdp prog
> > > would previously work fine, and would now give an error.  
> > 
> > That order should not work at all. You should not be allowed to change
> > the MTU size that exceeds XDP limits while an XDP program is attached.  
> 
> 
> Right. But we didn't check it so blocking that now is a UAPI change.
> Do we care?

I'd vote that we don't care. We should care more about consistency
across drivers than committing to buggy behavior.

All drivers should have this check (intel, mlx, nfp definitely do),
I had a look at Broadcom and it seems to be missing there as well :(
Qlogic also. Ugh.
