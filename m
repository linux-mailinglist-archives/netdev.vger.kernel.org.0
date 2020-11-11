Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B422AE6E8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgKKDQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:16:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKDQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 22:16:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA0C205ED;
        Wed, 11 Nov 2020 03:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605064600;
        bh=bx1h8bRJDzVn9ptvssnv+8ACPdir/rCDsG8o3Q01Xb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TXjHrs/rsSAhazHEeh8w1O/2lWJl7BIY7bQpHS5G8riK+XyENnfuUpZk3V89Jbd6s
         ZEUqCsAaJ0RHTtnW8yOOo0bI6M66g2YwwUkvu78iOveF7DjaHbvfkvkJf+b2m3UD0H
         I1edRcdhtd7Xl8f/sEWkXl2Wbh7fieiKAejPlgFU=
Date:   Tue, 10 Nov 2020 19:16:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] enetc: Workaround for MDIO register access
 issue
Message-ID: <20201110191639.149e5a6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110154304.30871-1-claudiu.manoil@nxp.com>
References: <20201110154304.30871-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 17:43:04 +0200 Claudiu Manoil wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> Due to a hardware issue, an access to MDIO registers
> that is concurrent with other ENETC register accesses
> may lead to the MDIO access being dropped or corrupted.
> The workaround introduces locking for all register accesses
> to the ENETC register space.  To reduce performance impact,
> a readers-writers locking scheme has been implemented.
> The writer in this case is the MDIO access code (irrelevant
> whether that MDIO access is a register read or write), and
> the reader is any access code to non-MDIO ENETC registers.
> Also, the datapath functions acquire the read lock fewer times
> and use _hot accessors.  All the rest of the code uses the _wa
> accessors which lock every register access.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Please check for new sparse warnings.
