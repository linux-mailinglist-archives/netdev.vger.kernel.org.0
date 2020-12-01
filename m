Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491D02C9544
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgLACfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbgLACfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:35:07 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E56F20857;
        Tue,  1 Dec 2020 02:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606790066;
        bh=Kd1t+okwE/MH2CiDN460l9rohKwyUTumtY1RZ+TzwBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=llPnV5dvRYi3b9Et/iTthzJpIrCovQfjSSwQrjQcnKZ5ZlgGKxV5w/majfMI/5Mqt
         xSC74BkAHDDf3sLKkyfkX2buIXbXaNAGYlxSygMU5GFeA8fjbWJRFDBpUMovuJGXFt
         rBDqXAjvNWzaAVC6sRtUL6f9hbVG3d+SsgKvzOkk=
Date:   Mon, 30 Nov 2020 18:34:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org,
        Annika Wickert <annika.wickert@exaring.de>
Subject: Re: [PATCH 1/2] vxlan: Add needed_headroom for lower device
Message-ID: <20201130183425.7086ae00@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126125247.1047977-1-sven@narfation.org>
References: <20201126125247.1047977-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 13:52:46 +0100 Sven Eckelmann wrote:
> It was observed that sending data via batadv over vxlan (on top of
> wireguard) reduced the performance massively compared to raw ethernet or
> batadv on raw ethernet. A check of perf data showed that the
> vxlan_build_skb was calling all the time pskb_expand_head to allocate
> enough headroom for:
> 
>   min_headroom = LL_RESERVED_SPACE(dst->dev) + dst->header_len
>   		+ VXLAN_HLEN + iphdr_len;
> 
> But the vxlan_config_apply only requested needed headroom for:
> 
>   lowerdev->hard_header_len + VXLAN6_HEADROOM or VXLAN_HEADROOM
> 
> So it completely ignored the needed_headroom of the lower device. The first
> caller of net_dev_xmit could therefore never make sure that enough headroom
> was allocated for the rest of the transmit path.
> 
> Cc: Annika Wickert <annika.wickert@exaring.de>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Applied both, thanks!
