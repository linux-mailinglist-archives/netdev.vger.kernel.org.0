Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B5B14CA32
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgA2MGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:06:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgA2MGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:06:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580299589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n8ggB9lNFliA144N9ZRBwOnBhRCpFljRjwzjSrA0YuU=;
        b=d1XVkaYjT3Yl27FIQES+igua7oc2hjWxhsJlgIP5Cx7YaCyYx+HvjCtY8qcu1UAJkskedY
        a/HzJezoM09uNRzooE+yvw691v+V/CzmCMUV3Bm/RUAMWrRArRApQqBfv6uwnXFGR+TBqJ
        Ngmfexo8143sW6292HYdK3LEVozoyTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-z97udVoNPz-XJWWnQFyreA-1; Wed, 29 Jan 2020 07:06:25 -0500
X-MC-Unique: z97udVoNPz-XJWWnQFyreA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A98107ACC7;
        Wed, 29 Jan 2020 12:06:24 +0000 (UTC)
Received: from cera.brq.redhat.com (unknown [10.43.2.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66AE1388;
        Wed, 29 Jan 2020 12:06:23 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:06:22 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Petr Oros <poros@redhat.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net] phy: avoid unnecessary link-up delay in polling
 mode
Message-ID: <20200129130622.1b8b6e43@cera.brq.redhat.com>
In-Reply-To: <20200129101308.74185-1-poros@redhat.com>
References: <20200129101308.74185-1-poros@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 11:13:08 +0100
Petr Oros <poros@redhat.com> wrote:

> commit 93c0970493c71f ("net: phy: consider latched link-down status in
> polling mode") removed double-read of latched link-state register for
> polling mode from genphy_update_link(). This added extra ~1s delay into
> sequence link down->up.
> Following scenario:
>  - After boot link goes up
>  - phy_start() is called triggering an aneg restart, hence link goes
>    down and link-down info is latched.
>  - After aneg has finished link goes up. In phy_state_machine is checked
>    link state but it is latched "link is down". The state machine is
>    scheduled after one second and there is detected "link is up". This
>    extra delay can be avoided when we keep link-state register double read
>    in case when link was down previously.
> 
> With this solution we don't miss a link-down event in polling mode and
> link-up is faster.
> 
> Fixes: 93c0970493c71f ("net: phy: consider latched link-down status in polling mode")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/phy/phy-c45.c    | 5 +++--
>  drivers/net/phy/phy_device.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index a1caeee1223617..bceb0dcdecbd61 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_device *phydev)
>  
>  		/* The link state is latched low so that momentary link
>  		 * drops can be detected. Do not double-read the status
> -		 * in polling mode to detect such short link drops.
> +		 * in polling mode to detect such short link drops except
> +		 * the link was already down.
>  		 */
> -		if (!phy_polling_mode(phydev)) {
> +		if (!phy_polling_mode(phydev) || !phydev->link) {
>  			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
>  			if (val < 0)
>  				return val;
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6a5056e0ae7757..d5f4804c34d597 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
>  
>  	/* The link state is latched low so that momentary link
>  	 * drops can be detected. Do not double-read the status
> -	 * in polling mode to detect such short link drops.
> +	 * in polling mode to detect such short link drops except
> +	 * the link was already down.
>  	 */
> -	if (!phy_polling_mode(phydev)) {
> +	if (!phy_polling_mode(pihydev) || !phydev->link) {
                               ^
Please remove the extra 'i' ----

Thx,
Ivan

