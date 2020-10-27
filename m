Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9872F29C6E8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827642AbgJ0SZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:25:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40772 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1827297AbgJ0SZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:25:35 -0400
Received: from zn.tnic (p200300ec2f0dae00bf53706700052072.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:bf53:7067:5:2072])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BAB771EC0212;
        Tue, 27 Oct 2020 19:25:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1603823132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HIlEQ668ZK65lA6MbCzNrMzTRfwiOqR1WIXbuHA3yjs=;
        b=EgbFsJdf1OZ3IGcke8XXZo3hz2cAmj/RcULw8QVmtef7YinSrbWCYFvbL5yywQPkzemwXO
        N724w3YmM6BIy+GiS4LbNct6nLnnKYjmBEbvDSj3xaVvbYC4cp66jlosXNW/p8ekCy1vAQ
        YuPzn8Qmf75kT/ZiIBq27HMK3PaA71Y=
Date:   Tue, 27 Oct 2020 19:25:20 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 5/8] edac: ghes: use krealloc_array()
Message-ID: <20201027182520.GK15580@zn.tnic>
References: <20201027121725.24660-1-brgl@bgdev.pl>
 <20201027121725.24660-6-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201027121725.24660-6-brgl@bgdev.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 01:17:22PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Use the helper that checks for overflows internally instead of manually
> calculating the size of the new array.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/edac/ghes_edac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
> index a918ca93e4f7..6d1ddecbf0da 100644
> --- a/drivers/edac/ghes_edac.c
> +++ b/drivers/edac/ghes_edac.c
> @@ -207,8 +207,8 @@ static void enumerate_dimms(const struct dmi_header *dh, void *arg)
>  	if (!hw->num_dimms || !(hw->num_dimms % 16)) {
>  		struct dimm_info *new;
>  
> -		new = krealloc(hw->dimms, (hw->num_dimms + 16) * sizeof(struct dimm_info),
> -			        GFP_KERNEL);
> +		new = krealloc_array(hw->dimms, hw->num_dimms + 16,
> +				     sizeof(struct dimm_info), GFP_KERNEL);
>  		if (!new) {
>  			WARN_ON_ONCE(1);
>  			return;
> -- 

Sure, why not.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
