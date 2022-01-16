Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E704248FF3F
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiAPVm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:42:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbiAPVm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 16:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BIQJD8Uw6i/i54SJa7kwvlrYv9V/IVzdhllAvBN8ayQ=; b=XXkLi3Ig3ylddaWiv7mlrH46yG
        TTOuVU7MylVJWfI3CfBDxG7qP2bgDOIz0FIIU61efssG1PbKI7vkIipKFhkAQpxBcWHbMAv7os1sH
        49tAXaFtxBbiL1I7UC4eA+1zYpn21Igsu53b7zS2vHQTc/PYubpJoQyI6cC0Uri754ck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9DIP-001Ysh-W7; Sun, 16 Jan 2022 22:42:41 +0100
Date:   Sun, 16 Jan 2022 22:42:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ice: Don't use GFP_KERNEL in atomic context
Message-ID: <YeSRUVmrdmlUXHDn@lunn.ch>
References: <40c94af2f9140794351593047abc95ca65e4e576.1642358759.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c94af2f9140794351593047abc95ca65e4e576.1642358759.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 07:46:20PM +0100, Christophe JAILLET wrote:
> ice_misc_intr() is an irq handler. It should not sleep.
> 
> Use GFP_ATOMIC instead of GFP_KERNEL when allocating some memory.
> 
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I've never played a lot with irq handler. My understanding is that they
> should never sleep.

Hi Christophe

Threaded interrupt handlers are allowed to sleep. However, this
handler is not being used in such a way. So your are probably correct
about GFP_KERNEL vs GFP_ATOMIC. 

> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 30814435f779..65de01f3a504 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3018,7 +3018,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
>  		struct iidc_event *event;
>  
>  		ena_mask &= ~ICE_AUX_CRIT_ERR;
> -		event = kzalloc(sizeof(*event), GFP_KERNEL);
> +		event = kzalloc(sizeof(*event), GFP_ATOMIC);
>  		if (event) {
>  			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
>  			/* report the entire OICR value to AUX driver */

What happens next is interesting...


                        event->reg = oicr;
                        ice_send_event_to_aux(pf, event);

where:

void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
{
        struct iidc_auxiliary_drv *iadrv;

        if (!pf->adev)
                return;

        device_lock(&pf->adev->dev);
        iadrv = ice_get_auxiliary_drv(pf);
        if (iadrv && iadrv->event_handler)
                iadrv->event_handler(pf, event);
        device_unlock(&pf->adev->dev);
}

device_lock() takes a mutex, not something you should be doing in
atomic context.

So it looks to me, this handler really should be running in thread
context...

	Andrew
