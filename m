Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF935491A
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbhDEXDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238588AbhDEXDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 19:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E73A261245;
        Mon,  5 Apr 2021 23:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617663820;
        bh=1AznXBQfF1+pBkELXM8nG0mQZUPP9odUX2yAu3YDAQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=idhKNXMpAKmA6s0RF7c1Pva/twDK/S610l/S2HVR9afYjjcNiT7hTgV5sm7YAzDLu
         AvCiLCJ4Ilwf5XE5edAzAtf5LptOa1d8zAQ2V6fd2uuSOpRJXdXcPKKi7C3pqMbiB2
         wQp410uTA+EMC7JZqdg271Av41ZHlhLEcbVYtY8h+Jc7ec9wfKyQ1QUKAEov1MYYln
         odchKma8Kx8G6zo+yIJy9W/xlykRn87PsGgUZkacI8/QUOeK80vWda5bfvrl99vkx5
         dunR0uOboFo+kbAKWiCcYQIyLlWV3Rb3XD+AJVm3zpEsperYjrFZfiwMhveH8G/7st
         dOGH6Ri9fxOJQ==
Date:   Mon, 5 Apr 2021 16:03:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Julian Labus <julian@freifunk-rtk.de>, netdev@vger.kernel.org,
        mschiffer@universe-factory.net,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: stmmac: zero udp checksum
Message-ID: <20210405160339.1c264af4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YGs+DeFzhVh7UlEh@lunn.ch>
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
        <YGsQQUHPpuEGIRoh@lunn.ch>
        <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
        <YGs+DeFzhVh7UlEh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Apr 2021 18:42:53 +0200 Andrew Lunn wrote:
> > But was is still a bit strange to me is that it seems like the stmmac driver
> > behaves different than other ethernet drivers which do not drop UDP packets
> > with zero checksums when rx checksumming is enabled.  
> 
> To answer that, you need somebody with more knowledge of the stmmac
> hardware.

+1 stmmac maintainers could you advise?

> It is actually quite hard to do. It means you need to parse
> more of the frame to determine if the frame contains a VXLAN
> encapsulated frame. Probably the stmmac cannot do that. It sees the
> checksum is wrong and drops the packet.
>
> Have you looked at where it actually drops the packet?
> Is it one of
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/norm_desc.c#L95
> 
> or
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/enh_desc.c#L87
> 
> It could be, you need to see if the checksum has fail, then check if
> the checksum is actually zero, and then go deeper into the frame and
> check if it is a vxlan frame. It could be the linux software checksum
> code knows about this vxlan exception, so you can just run that before
> deciding to drop the frame.

To be clear the expectation is that devices / drivers will only drop
packets on L2 / FCS errors. If L3 or L4 csum is incorrect the packet
should be passed up the stack and kernel will handle it how it sees fit.
