Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99002AFF54
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKLFcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:32964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgKLBjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:39:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AA62067D;
        Thu, 12 Nov 2020 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605145194;
        bh=gFU8NjWqdxTbpUXHuZpihrdyv9TGzkf4s7XOu1dobRg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2cwqd1k+IGtCj0otEDYGV9oVvhfUz+uBx85OmK6GwS59wwgwOsT+WBz42/e+hstWb
         1MA3Km5nm7tEGVr4Dgwlz/nT5Wc14VBS/pooV6lkmtw8JJD8mNoOgejSig4qiOX58p
         lGiYanWYdTwRlIrjUL1OfflR/dnTIBY3oLCCz59E=
Date:   Wed, 11 Nov 2020 17:39:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Tobias Waldekranz" <tobias@waldekranz.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: 6352: parse VTU data
 before loading STU data
Message-ID: <20201111173953.7e194eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <C70U4J6VK2TJ.208R8QGGUAN47@wkz-x280>
References: <20201111152732.6328f5be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <C70U4J6VK2TJ.208R8QGGUAN47@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 00:49:03 +0100 Tobias Waldekranz wrote:
> > I'm unclear what this fixes. What functionality is broken on 6097?  
> 
> VLAN configuration. As soon as you add the second port to a VLAN, all
> other port membership configuration is overwritten with zeroes. The HW
> interprets this as all ports being "unmodified members" of the VLAN.
> 
> I suspect that is why it has not been discovered. In the simple case
> when all ports belong to the same VLAN, switching will still work. But
> using multiple VLANs or trying to set multiple ports as tagged members
> will not work.

I see, this info would be good to include in the commit message.
User impact is what backporters care about the most.

> At the lowest level, the current implementation assumes that it can
> perform two consecutive operations where each op will load half of a
> register, and then read out the union of the information. This is true
> for some devices (6352), but not for others (6097).
> 
> 6352 pseudo-hdl-in-c:
> 
> stu_get_next()
> {
> 	*data |= stu_data & 0xf0f0;
> }
> 
> vtu_get_next()
> {
> 	*data |= vtu_data & 0x0f0f;
> }
> 
> 6097 pseudo-hdl-in-c:
> 
> stu_get_next()
> {
> 	*data = stu_data;
> }
> 
> vtu_get_next()
> {
> 	*data = vtu_data;
> }
> 
> > Can we identify the commit for a fixes tag?  
> 
> I will try to pinpoint it tomorrow. I suppose I should also rebase it
> against "net" since it is a bug.

Indeed, thanks :)
