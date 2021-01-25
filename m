Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993F6302D89
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbhAYVYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732608AbhAYVX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:23:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BBE2074B;
        Mon, 25 Jan 2021 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611609798;
        bh=EiSMuv3lS+b6L16mi9Gaz56jCTdgSdQyubHBs42fKFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OpzIe3KYHoO/6DncBJ3tHM/TNp0oPv7eY2YfzLue7o0z04iU6lv7EP3AoYs5GDHbv
         D/RuKZrjtCw4bXsE906/0OVxzstUTCaViQW4m4Nf2TNOB3LWj/RFx+37sf5zELOk9F
         G/nG7gUNsBgTqXG/gjqbkC7aZinBPKy7xJkBljp9ofg5c6O9TEp79YcnxnufNIhkvV
         4WzCzc/qnGtofxOVZvCxRCHOegS9a7hMAmxcSnapN7P5MLeaoq7F2KopjkUoyiNpgn
         ISUU8n6arMFu9USTitdHNTr/88Rw5BJYeOGyK4ZPP85/Q/GGCPdR+Knm2NI7p4OKxy
         5YVcdtd1wIyAw==
Date:   Mon, 25 Jan 2021 13:23:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Message-ID: <20210125132317.418a4e35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
References: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:38:56 +0200 Oleksandr Mazur wrote:
> +	if (trap_item->action == DEVLINK_TRAP_ACTION_DROP &&
> +	    devlink->ops->trap_drop_counter_get) {
> +		err = devlink->ops->trap_drop_counter_get(devlink,
> +							  trap_item->trap,
> +							  &drops);
> +		if (err)
> +			return err;
> +	}

Why only report this counter when action is set to drop?

Thinking about it again - if the action can be changed wouldn't it 
be best for the user to actually get a "HW condition hit" counter,
which would increment regardless of SW config (incl. policers)?

Otherwise if admin logs onto the box and temporarily enables a trap 
for debug this count would disappear.
