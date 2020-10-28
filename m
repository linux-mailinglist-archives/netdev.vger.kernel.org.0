Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259829CD0E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgJ1BjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833087AbgJ1AQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 20:16:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E762223C;
        Wed, 28 Oct 2020 00:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603844181;
        bh=Dl+mj1slgc0isDj7rpRd4dRtbRYsNG/Rbix4uZLptjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZRL4/5G+YNajasrAV3EwWJZg8NDm9kYY1bbgpaAAjDnDx9pz6zPHFVUd8vHiLU0KK
         m/lX2Ug/7DSPawiu0/3UeN5Fa0gX/uiyIBuKqHBjNM24BTWkittOYbsl7t1VUURp+A
         b/KmWtoNJmd/rXxJ6n3IwsPxNtLN6CPi0jcyEGbs=
Date:   Tue, 27 Oct 2020 17:16:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: Re: [PATCH net v2] ravb: Fix bit fields checking in
 ravb_hwtstamp_get()
Message-ID: <20201027171620.2b5eef40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026102130.29368-1-andrew_gabbasov@mentor.com>
References: <20201026102130.29368-1-andrew_gabbasov@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 05:21:30 -0500 Andrew Gabbasov wrote:
> In the function ravb_hwtstamp_get() in ravb_main.c with the existing
> values for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
> (0x6)
> 
> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
> 
> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true,
> it will never be reached.
> 
> This issue can be verified with 'hwtstamp_config' testing program
> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type
> to ALL and subsequent retrieving it gives incorrect value:
> 
> $ hwtstamp_config eth0 OFF ALL
> flags = 0
> tx_type = OFF
> rx_filter = ALL
> $ hwtstamp_config eth0
> flags = 0
> tx_type = OFF
> rx_filter = PTP_V2_L2_EVENT
> 
> Correct this by converting if-else's to switch.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Applied, thank you!
