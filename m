Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02B2A39FC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgKCBnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgKCBnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:43:10 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF4F2071A;
        Tue,  3 Nov 2020 01:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604367789;
        bh=aa0iLntd4xlFQ4Vlx6YN0dlVpiz/mYPSOPlVKWILf5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FsyhjDRRf2rUaPMkqhQTKduwHgSpOAPYsZhcCxI07zswQmW8ZMLVF/I5wdm9skPt5
         OfYSeopoBg2j8oH3i0kpicK0TwbaXtOWmoJup+lWTH/KjT4a9o3rMkN/h/raUNk1RO
         QKzpY6gDbM2bV0daRUMxrgX8y+8TlxrWDtfdX+AY=
Date:   Mon, 2 Nov 2020 17:43:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net-next 00/12] Generic TX reallocation for DSA
Message-ID: <20201102174308.797d7e7b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 21:16:08 +0200 Vladimir Oltean wrote:
> Christian has reported buggy usage of skb_put() in tag_ksz.c, which is
> only triggerable in real life using his not-yet-published patches for
> IEEE 1588 timestamping on Micrel KSZ switches.
> 
> The concrete problem there is that the driver can end up calling
> skb_put() and exceed the end of the skb data area, because even though
> it had reallocated the frame once before, it hadn't reallocated it large
> enough. Christian explained it in more detail here:
> 
> https://lore.kernel.org/netdev/20201014161719.30289-1-ceggers@arri.de/
> https://lore.kernel.org/netdev/20201016200226.23994-1-ceggers@arri.de/
> 
> But actually there's a bigger problem, which is that some taggers which
> get more rarely tested tend to do some shenanigans which are uncaught
> for the longest time, and in the meanwhile, their code gets copy-pasted
> into other taggers, creating a mess. For example, the tail tagging
> driver for Marvell 88E6060 currently reallocates _every_single_frame_ on
> TX. Is that an obvious indication that nobody is using it? Sure. Is it a
> good model to follow when developing a new tail tagging driver? No.
> 
> DSA has all the information it needs in order to simplify the job of a
> tagger on TX. It knows whether it's a normal or a tail tagger, and what
> is the protocol overhead it incurs. So this series performs the
> reallocation centrally.

Applied, thank you!
