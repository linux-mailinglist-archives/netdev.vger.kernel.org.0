Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF521A8C4C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632981AbgDNUSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:18:16 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:33892 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2632807AbgDNUR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 16:17:57 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 37C1A521;
        Tue, 14 Apr 2020 22:17:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1586895471;
        bh=c6Xr5+2L0DxCtZfSvJoou6RSwZxi4WmjMmnUCKihyVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5kQMUxsLc5akyV7IZRrNEf5uWfY0EWXJPRdjxLlff3vbw/+enM8JPoV9d/klth3g
         zy8/qwAIcychqwGy6M1fbNCf4BFOlly2O0efLT8+BkhrXO+ravDVV+cX9ixjTqoIF6
         JhgwFOeRP6FoG1U7zCp4n/vRB5aCityKHQlGUGzU=
Date:   Tue, 14 Apr 2020 23:17:39 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
Message-ID: <20200414201739.GJ19819@pendragon.ideasonboard.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
 <20200408202711.1198966-6-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200408202711.1198966-6-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

Thank you for the patch.

On Wed, Apr 08, 2020 at 10:27:10PM +0200, Arnd Bergmann wrote:
> The 'imply' statement does not seem to have an effect, as it's
> still possible to turn the CMM code into a loadable module
> in a randconfig build, leading to a link error:
> 
> arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
> rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
> arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
> rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
> arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
> rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
> arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':
> 
> Remove the 'imply', and instead use a silent symbol that defaults
> to the correct setting.

This will result in the CMM always being selected when DU is, increasing
the kernel size even for devices that don't need it. I believe we need a
better construct in Kconfig to fix this.

> Fixes: e08e934d6c28 ("drm: rcar-du: Add support for CMM")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/drm/rcar-du/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
> index 0919f1f159a4..5e35f5934d62 100644
> --- a/drivers/gpu/drm/rcar-du/Kconfig
> +++ b/drivers/gpu/drm/rcar-du/Kconfig
> @@ -4,7 +4,6 @@ config DRM_RCAR_DU
>  	depends on DRM && OF
>  	depends on ARM || ARM64
>  	depends on ARCH_RENESAS || COMPILE_TEST
> -	imply DRM_RCAR_CMM
>  	imply DRM_RCAR_LVDS
>  	select DRM_KMS_HELPER
>  	select DRM_KMS_CMA_HELPER
> @@ -15,9 +14,8 @@ config DRM_RCAR_DU
>  	  If M is selected the module will be called rcar-du-drm.
>  
>  config DRM_RCAR_CMM
> -	tristate "R-Car DU Color Management Module (CMM) Support"
> +	def_tristate DRM_RCAR_DU
>  	depends on DRM && OF
> -	depends on DRM_RCAR_DU
>  	help
>  	  Enable support for R-Car Color Management Module (CMM).
>  

-- 
Regards,

Laurent Pinchart
