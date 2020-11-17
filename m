Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBC2B6FE4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKQUQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:16:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKQUQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:16:51 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B31C22202;
        Tue, 17 Nov 2020 20:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605644211;
        bh=xUwY6lt22MzEFDCZmgWEU1DlYjB1M9Wp2Sl1798lpak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GibEs8S6Zdg7Ze18XFWIOHAKBosI3X3SZKzKFHsWDbq3/n5tL+wwtZB0bBKrQnpbw
         E6i6Zovm24xRGrpd2iJVouRg3vi3ucMHogbjvCFh3nRQFdfoipgeUsNcweyMSuD1hp
         UOQA0hwRBBxPI53N3v8lOkpmom9qlFi+byyntK+k=
Date:   Tue, 17 Nov 2020 12:16:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201117121650.74821f53@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201112182608.26177-1-claudiu.manoil@nxp.com>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 20:26:08 +0200 Claudiu Manoil wrote:
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
> The commit introducing MDIO support is -
> commit ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
> but due to subsequent refactoring this patch is applicable on
> top of a later commit.
> 
> Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied.
