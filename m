Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCF347CA0
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhCXPbB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 11:31:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:1310 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236683AbhCXPaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 11:30:39 -0400
IronPort-SDR: TDT8xas+TqaIoJVkNiEXLLro6tSxpW0oapG8TPTC6sWKawxhr1Y2bBwLEzL0ayTAGLvsVAhDyD
 h+K9Yw2upJzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190823083"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="190823083"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 08:30:38 -0700
IronPort-SDR: /4dqq/0JWisBWvhTbTEBIBwFyl3ZwxDSlbNQvn9KHdRvSPPQs9Sb14vUi+jgB7se4K1pbShwF/
 LGKAbJDldGYw==
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="415534424"
Received: from hcarliss-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 08:30:27 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
        Martin Sebor <msebor@gcc.gnu.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?utf-8?Q?Jos=C3=A9?= Roberto de Souza <jose.souza@intel.com>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Aditya Swarup <aditya.swarup@intel.com>
Subject: Re: [PATCH 10/11] drm/i915: avoid stringop-overread warning on pri_latency
In-Reply-To: <20210322160253.4032422-11-arnd@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-11-arnd@kernel.org>
Date:   Wed, 24 Mar 2021 17:30:24 +0200
Message-ID: <874kh04lin.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc-11 warns about what appears to be an out-of-range array access:
>
> In function ‘snb_wm_latency_quirk’,
>     inlined from ‘ilk_setup_wm_latency’ at drivers/gpu/drm/i915/intel_pm.c:3108:3:
> drivers/gpu/drm/i915/intel_pm.c:3057:9: error: ‘intel_print_wm_latency’ reading 16 bytes from a region of size 10 [-Werror=stringop-overread]
>  3057 |         intel_print_wm_latency(dev_priv, "Primary", dev_priv->wm.pri_latency);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/i915/intel_pm.c: In function ‘ilk_setup_wm_latency’:
> drivers/gpu/drm/i915/intel_pm.c:3057:9: note: referencing argument 3 of type ‘const u16 *’ {aka ‘const short unsigned int *’}
> drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function ‘intel_print_wm_latency’
>  2994 | static void intel_print_wm_latency(struct drm_i915_private *dev_priv,
>       |             ^~~~~~~~~~~~~~~~~~~~~~
>
> My guess is that this code is actually safe because the size of the
> array depends on the hardware generation, and the function checks for
> that, but at the same time I would not expect the compiler to work it
> out correctly, and the code seems a little fragile with regards to
> future changes. Simply increasing the size of the array should help.

Agreed, I don't think there's an issue, but the code could use a bunch
of improvements.

Like, we have intel_print_wm_latency() for debug logging and
wm_latency_show() for debugfs, and there's a bunch of duplication and
ugh.

But this seems like the easiest fix for the warning.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/drm/i915/i915_drv.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 26d69d06aa6d..3567602e0a35 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1095,11 +1095,11 @@ struct drm_i915_private {
>  		 * in 0.5us units for WM1+.
>  		 */
>  		/* primary */
> -		u16 pri_latency[5];
> +		u16 pri_latency[8];
>  		/* sprite */
> -		u16 spr_latency[5];
> +		u16 spr_latency[8];
>  		/* cursor */
> -		u16 cur_latency[5];
> +		u16 cur_latency[8];
>  		/*
>  		 * Raw watermark memory latency values
>  		 * for SKL for all 8 levels

-- 
Jani Nikula, Intel Open Source Graphics Center
