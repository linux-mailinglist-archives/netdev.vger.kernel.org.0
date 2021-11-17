Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48F045480E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhKQOFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236521AbhKQOF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:05:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 371CC613AC;
        Wed, 17 Nov 2021 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637157749;
        bh=Mtv73a/gWQFkxHU/GfoZwoU5lbINq7mSuYKyIVKcxm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GEw5KMy04sQwKqAohBbVqMSt1pRHPXLTHAkCfQzAeyU7py3dxmVU6XwWwD0qAZ6m7
         SorenLcW3mRAj6ZF6x36rT0byl8ZSYGME4FKn9h2C9JHYajdrGwtWOso9E8aYelrc3
         UVPNdNSdPm9W5i7jW71cb+9hr6Yfl75DSrkwLDlMbAsqkJ2GHQhw4CIP54yUfQlDuV
         KzkE3pwOcQmg2LTfXm2vcwJ2PIdP94eO0hWfmULALNkgFyPsAlArlU3RwfX8dnp/a6
         HMZozI+c9r8+Eut+zK7XxwYAYPquHFPY4S6AuVR4LMEaOu0N1ACx0qdMcpQPcz/A1D
         jEwv/q9QKjT4g==
Date:   Wed, 17 Nov 2021 06:02:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <20211117060228.65947629@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZUCRk8nz1rnnRRL@unreal>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
        <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZKmlzhu0gtKpvXW@unreal>
        <20211115171530.432f5753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZUCRk8nz1rnnRRL@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 15:23:18 +0200 Leon Romanovsky wrote:
> > I'd drop these notifications, the user didn't ask to flash the device,
> > it's just code reuse in the driver, right?  
> 
> Sorry, I missed your reply.
> 
> I'm not sure about code reuse, from the code, it looks like attempt to
> burn FW during mlxsw register.
> 
> __mlxsw_core_bus_device_register
>  -> mlxsw_core_fw_rev_validate
>   -> mlxsw_core_fw_flash
>    -> mlxfw_firmware_flash
>     -> mlxfw_status_notify
>      -> devlink_flash_update_status_notify
>       -> __devlink_flash_update_notify
>        -> WARN_ON(...)  
> 
> The mlxfw_firmware_flash() routine is called by mlx5 too, so I can't
> remove mlxfw_status_notify() calls without too much changes.
> 
> Easiest solution was to remove WARN_ON(), because no one really
> interested in these events anyway. I searched in github and didn't
> find any user who listened to them.

Drop in the core. Like this?


 	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
 		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
