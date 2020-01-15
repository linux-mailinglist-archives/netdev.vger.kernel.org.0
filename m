Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492D413C6D7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgAOPBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728915AbgAOPBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 10:01:46 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00DC2084D;
        Wed, 15 Jan 2020 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100505;
        bh=TmlbNmcEzww2kDeZ4p+usdgm4iI5QNe3NceQheUg6/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2BI4ywi51hU470G8nb+vHxNES95oo5JPsGSfejShH3ul2PYJeF5xOS9oMz6y5DAq1
         1/5Gn8zUcNFYecVff+7Fwk5aQYPO6qOxusbqd3Id1XjhlnPFynQ7R8ibCC+F7iSzqJ
         TbfiFBSg4HYL8DysXkEYCBdKhOw1CBEaAFiAIUWQ=
Date:   Wed, 15 Jan 2020 07:01:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Message-ID: <20200115070145.3db10fe4@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1579017328-19643-4-git-send-email-moshe@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
        <1579017328-19643-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 17:55:28 +0200, Moshe Shemesh wrote:
> Add support for FW upgrade reset.
> On devlink reload the driver checks if there is a FW stored pending
> upgrade reset. In such case the driver will set the device to FW upgrade
> reset on next PCI link toggle and do link toggle after unload.
> 
> To do PCI link toggle, the driver ensures that no other device ID under
> the same bridge by checking that all the PF functions under the same PCI
> bridge have same device ID. If no other device it uses PCI bridge link
> control to turn link down and up.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

I'd have a slight preference for the reset to be an explicit command
rather than something the driver does automatically on the reload if
there are pending changes. Won't there ever be scenarios where users
just want to hard reset the device for their own reason?

If multiple devices under one bridge are a real concern (or otherwise
interdependencies) would it make sense to mark the devices as "reload
pending" and perform the reloads once all devices in the group has this
mark set?
