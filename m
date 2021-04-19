Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3713364CBD
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhDSVFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhDSVFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B81F6101C;
        Mon, 19 Apr 2021 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618866283;
        bh=BatIuz7zrAF5lJzJJQfQ3s2F5twGFrJv0Zvadn3IGXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rO5RfE6NHjW2IJxJzNVH2kfC5gvwmOP415hNH+GKNCkr9bK/1t+AIJrR35dgzPytC
         lZ6IedHF/P+BhzneKPs1F70WrgvH2TETSO7B1xQ3PBdXkbBd1qfMSU9X+zqyex6HML
         08PwBQ+AeDZmQJDjSr7/Iq+Q0Qlk0sY5mQxirVKqSpRIf3l9n6gGlWPEXoYJxRn25+
         VAk2p41ceOFHtOqEskIWzR18ltovvpR1aI2KyhXrGTITKh32ysBtM0gF5HWoFQ3Xdy
         O0+oyT5OcI3d/KCehOBS0/c9Sx+SiQ99PisRh+w4TTVEan3Izme0VO6fuu632j79By
         lkz1JjAXG+QoQ==
Date:   Mon, 19 Apr 2021 14:04:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
Message-ID: <20210419140442.79dd0ce0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 02:42:20 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series contains logic for enabling the lossless mode on the
> RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> memory.
> 
> During testing it was found that, with the default FIFO configuration,
> a sender which isn't persuaded by our PAUSE frames and keeps sending
> will cause some MAC RX frame errors. To mitigate this, we need to ensure
> that the FIFO never runs completely full, so we need to fix up a setting
> that was supposed to be configured well out of reset. Unfortunately this
> requires the addition of a new mini-driver.

FWIW back in the day when I was working on more advanced devices than 
I deal with these days I was expecting to eventually run into this as
well and create some form of devlink umbrella. IMHO such "mini driver"
is a natural place for a devlink instance, and not the PFs/ports.
Is this your thinking as well? AFAICT enetc doesn't implement devlink
today so you start from whatever model works best without worrying
about backward compat.
