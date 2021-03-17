Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F348A33F845
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhCQSlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhCQSlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C1364EE1;
        Wed, 17 Mar 2021 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616006460;
        bh=PywSXjszhjfpih1/J3Jyu5wm/EJ4MZXmhjrJnjMgu00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H8arYPQZLqmf123UhLqGHT9osk3DOXy+ZSTrGMV6f8mPWX/2bJv8qEJZM2ATz0HUr
         ZmwBqJfrBmpw4epaLDH0TKn98ZmjmrxtB74XYhMN6XyfJ8yPKnTNeKsS+KB4NwYthJ
         WjzvA/dxTJQr8qJnWRfF2ogW2chnkfibkl33YrAJbj5iQTGtMPDeQXqXyEA+IoerkF
         jHMqQZFEYZfHHt1xZKIjtbYCdNxHNnVIqU1R4uQ/V48A982QjrLalQv4qCeu4sqDia
         lb9rH13Ay+AywbCTn6RSmadrdQvyKJP16Pi9AdhHKp9nIbYlpd6jk/7qun+r/KO67L
         g+jVeQtBGY5hg==
Date:   Wed, 17 Mar 2021 11:40:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [EXT] Re: [PATCH net 1/2] qede: fix to disable start_xmit
 functionality during self adapter test
Message-ID: <20210317114059.28aa2aea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM5PR18MB21529A16BF342B1DBC344403AB6A9@DM5PR18MB2152.namprd18.prod.outlook.com>
References: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
        <1615919650-4262-2-git-send-email-bupadhaya@marvell.com>
        <20210316145935.6544c29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM5PR18MB21529A16BF342B1DBC344403AB6A9@DM5PR18MB2152.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 06:33:37 +0000 Bhaskar Upadhaya wrote:
> > But an interrupt can come in after and enable Tx again.
> > I think you should keep the qede_netif_stop() here instead of moving it
> > down, no?  
> 
> Hi Jakub,
> Normal Traffic flow is enabled by qede_netif_start(edev) and which is placed at the end of this qede_selftest_run_loopback()
> qede_netif_stop(edev) is called prior to the call to qede_netif_start(edev), so unless qede_netif_start(edev)  is called Normal traffic flow will not
> be operational. 

I'm not talking about submitting more traffic.

Consider the following order of events

normal traffic		test

xmit()
			netif_tx_disable()
IRQ
NAPI
netif_tx_wake_queue()

     <--- traffic running again --->

			qede_netif_stop()
