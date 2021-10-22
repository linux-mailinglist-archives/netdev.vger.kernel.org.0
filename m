Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845DD437719
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhJVMaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:30:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhJVMaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 08:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=esoWB3Yx4NGmvYuBdsyz4pIiztvyP8DSBH+TI5+spqU=; b=Jr8eluEVsvf9IU8dAsCYvHQ2kE
        Qx9oMZv7Y3Geon/qO2KmvhowxyVh4v1Uve0Xtlhmp3HVot4TV7bmfurY5oNeZ0yLQKXpaNr70X+am
        myhLD9ig9wtt0v2j87nzJNg0ie/Hzo4BYDiDWDgl6CYzjv+W3QRW1jQ6jedMpGI7R4hU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdte5-00BNlG-S8; Fri, 22 Oct 2021 14:27:37 +0200
Date:   Fri, 22 Oct 2021 14:27:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     kuba@kernel.org, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <YXKuOSDraUsaN75U@lunn.ch>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 12:32:28PM +0300, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add firmware (FW) version 4.0 support for Marvell Prestera
> driver.
> 
> Major changes have been made to new v4.0 FW ABI to add support
> of new features, introduce the stability of the FW ABI and ensure
> better forward compatibility for the future driver vesrions.
> 
> Current v4.0 FW feature set support does not expect any changes
> to ABI, as it was defined and tested through long period of time.
> The ABI may be extended in case of new features, but it will not
> break the backward compatibility.
> 
> ABI major changes done in v4.0:
> - L1 ABI, where MAC and PHY API configuration are split.
> - ACL has been split to low-level TCAM and Counters ABI
>   to provide more HW ACL capabilities for future driver
>   versions.
> 
> To support backward support, the addition compatibility layer is
> required in the driver which will have two different codebase under
> "if FW-VER elif FW-VER else" conditions that will be removed
> in the future anyway, So, the idea was to break backward support
> and focus on more stable FW instead of supporting old version
> with very minimal and limited set of features/capabilities.
 
> +/* TODO: add another parameters here: modes, etc... */
> +struct prestera_port_phy_config {
> +	bool admin;
> +	u32 mode;
> +	u8 mdix;
> +};

> @@ -242,10 +246,44 @@ union prestera_msg_port_param {
>  	u8  duplex;
>  	u8  fec;
>  	u8  fc;
> -	struct prestera_msg_port_mdix_param mdix;
> -	struct prestera_msg_port_autoneg_param autoneg;
> +
> +	union {
> +		struct {
> +			/* TODO: merge it with "mode" */

> +		struct {
> +			/* TODO: merge it with "mode" */
> +			u8 admin:1;
> +			u8 adv_enable;
> +			u64 modes;
> +			/* TODO: merge it with modes */
> +			u32 mode;
> +			u8 mdix;
> +		} phy;

You claim this is stable, yet there are four TODOs. Please could you
convince us you can actually do these TODO without breaking the
ABI. Can you add more members to the end of these structures, and the
firmware/driver can know they are there? Since these are often unions,
you might not be able to tell from the length of the message
exchanged.

As Jakub pointed out, your structures have horrible alignment. Have
you run this on both 32 and 64 bit systems? It would be good to add

BUILD_BUG_ON(sizeof(*foo) != 42)

for all the structures that get passed to/from the firmware.

    Andrew
