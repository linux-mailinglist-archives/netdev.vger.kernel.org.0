Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07382918D1
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgJRS0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgJRS0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 14:26:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14AD21655;
        Sun, 18 Oct 2020 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603045615;
        bh=SlZgxGNGsrjH8Ef0LjyB2AeicMtrdksOpK9vWtOJZkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SrYlgbxAuEKP5KePBYv8aFENO3bvDw2e2qqtsLX2eEZuUv+jDB7HJATyQQcNRCIfz
         JpJvnXUeqWoxcOUtXChnLNXSLUbEYKH1VFSFwzek3kUMA8i8ajW8bi6HBPTCEb6cwS
         kEJqNgZmdFvzhGpPF8S+kBQATSQ8QrlxASVlZYC8=
Date:   Sun, 18 Oct 2020 11:26:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201018112653.21735d08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018173649.GF456889@lunn.ch>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
        <20201017213611.2557565-2-vladimir.oltean@nxp.com>
        <20201018094951.0016f208@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201018173649.GF456889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 19:36:49 +0200 Andrew Lunn wrote:
> On Sun, Oct 18, 2020 at 09:49:51AM -0700, Jakub Kicinski wrote:
> > > +	struct u64_stats_sync	syncp;
> > > +} __aligned(1 * sizeof(u64));  
> > 
> > Why aligned to u64? Compiler should pick a reasonable alignment here 
> > by itself.  
> 
> Hi Jakub
> 
> I wondered that as well. But:
> 
> struct gnet_stats_basic_cpu {
>         struct gnet_stats_basic_packed bstats;
>         struct u64_stats_sync syncp;
> } __aligned(2 * sizeof(u64));
> 
> /* often modified stats are per-CPU, other are shared (netdev->stats) */
> struct pcpu_sw_netstats {
>         u64     rx_packets;
>         u64     rx_bytes;
>         u64     tx_packets;
>         u64     tx_bytes;
>         struct u64_stats_sync   syncp;
> } __aligned(4 * sizeof(u64));
> 
> struct pcpu_lstats {
>         u64_stats_t packets;
>         u64_stats_t bytes;
>         struct u64_stats_sync syncp;
> } __aligned(2 * sizeof(u64));
> 
> Cargo cult or is there a real need?

Hm, looks like the intent is to enforce power of two alignment 
to prevent the structure from spanning cache lines. Doesn't make 
any difference for 1 counter, but I guess we can keep the style 
for consistency.
