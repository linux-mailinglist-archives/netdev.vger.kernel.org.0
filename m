Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA332B111E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgKLWOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgKLWON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:14:13 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17EC12222F;
        Thu, 12 Nov 2020 22:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219253;
        bh=+4XCALsyM6XaCymycLdFNrWVUEhngmkGeXaC6pGMVHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QkYVe0aFHOycw3a/E3ZPnEHL0lsy25yjcIyNENdYswK4nqne7w45uU5uOUXbk/L7l
         Bd9HiwrpMKVMigdzc+TutQDxZ/Hj9R4ig4iTaHfr0+OmfUCgnOoeVUlCTLkGE5F9bn
         /kWGe2dlYahXjUyLI1WZ3gWUwVhfJsoJjAp1EFKY=
Date:   Thu, 12 Nov 2020 14:14:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: core: support managed resource allocation in
 ndo_open
Message-ID: <20201112141411.6fe75fbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1151799e-7faa-3d86-c610-9b9ebbd62637@gmail.com>
References: <1151799e-7faa-3d86-c610-9b9ebbd62637@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 21:56:10 +0100 Heiner Kallweit wrote:
> Quite often certain resources (irq, bigger chunks of memory) are
> allocated not at probe time but in ndo_open. This requires to relaese
> such resources in the right order in ndo_stop(), and in ndo_open()
> error paths. Having said that the requirements are basically the same
> as for releasing probe-time allocated resources in remove callback
> and probe error paths.
> So why not use the same mechanism to faciliate this? We have a big
> number of device-managed resource allocation functions, so all we
> need is a device suited for managed ndo_open resource allocation.
> This RFC patch adds such a device to struct net_device. All we need
> is a dozen lines of code. Resources then can be allocated with e.g.
> 
> struct device *devm = &dev->devres_up;
> devm_kzalloc(devm, size, gfp);
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

This will not work well with the best known practice on how to change
rings parameters at runtime (allocate new set, swap, free old set).

Personally I'm not a fan of the managed stuff, and I think neither is
Dave. It just makes code harder to prove correct.
