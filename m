Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFD348B20
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCYIFc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Mar 2021 04:05:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:34351 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCYIFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:05:22 -0400
IronPort-SDR: fhSYScwTavgQKe1dCnryrywzUrSmsao/0sARx65F6Qc4V+nDgydgykkDivnsdXhbeLeqxMIzyu
 KiZ9BeCeZE7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190971098"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="190971098"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 01:05:21 -0700
IronPort-SDR: YSlh8X6JrYCAgcFAjL5XZMs9hqgR3pcWRIp1+nLDHbTGxn8DfB0UC8NvUc6Fyh2eKqFMEpwwEz
 JeibtqsaiX5Q==
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="415886752"
Received: from jweber-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.244])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 01:05:09 -0700
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
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
In-Reply-To: <20210322160253.4032422-12-arnd@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-12-arnd@kernel.org>
Date:   Thu, 25 Mar 2021 10:05:06 +0200
Message-ID: <87wntv3bgt.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc-11 warns that intel_dp_check_mst_status() has a local array of
> fourteen bytes and passes the last four bytes into a function that
> expects a six-byte array:
>
> drivers/gpu/drm/i915/display/intel_dp.c: In function ‘intel_dp_check_mst_status’:
> drivers/gpu/drm/i915/display/intel_dp.c:4556:22: error: ‘drm_dp_channel_eq_ok’ reading 6 bytes from a region of size 4 [-Werror=stringop-overread]
>  4556 |                     !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/i915/display/intel_dp.c:4556:22: note: referencing argument 1 of type ‘const u8 *’ {aka ‘const unsigned char *’}
> In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
> include/drm/drm_dp_helper.h:1459:6: note: in a call to function ‘drm_dp_channel_eq_ok’
>  1459 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
>       |      ^~~~~~~~~~~~~~~~~~~~
>
> Clearly something is wrong here, but I can't quite figure out what.
> Changing the array size to 16 bytes avoids the warning, but is
> probably the wrong solution here.

Ugh. drm_dp_channel_eq_ok() does not actually require more than
DP_LINK_STATUS_SIZE - 2 elements in the link_status. It's some other
related functions that do, and in most cases it's convenient to read all
those DP_LINK_STATUS_SIZE bytes.

However, here the case is slightly different for DP MST, and the change
causes reserved DPCD addresses to be read. Not sure it matters, but
really I think the problem is what drm_dp_channel_eq_ok() advertizes.

I also don't like the array notation with sizes in function parameters
in general, because I think it's misleading. Would gcc-11 warn if a
function actually accesses the memory out of bounds of the size?

Anyway. I don't think we're going to get rid of the array notation
anytime soon, if ever, no matter how much I dislike it, so I think the
right fix would be to at least state the correct required size in
drm_dp_channel_eq_ok().


BR,
Jani.


>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 8c12d5375607..830e2515f119 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -65,7 +65,7 @@
>  #include "intel_vdsc.h"
>  #include "intel_vrr.h"
>  
> -#define DP_DPRX_ESI_LEN 14
> +#define DP_DPRX_ESI_LEN 16
>  
>  /* DP DSC throughput values used for slice count calculations KPixels/s */
>  #define DP_DSC_PEAK_PIXEL_RATE			2720000

-- 
Jani Nikula, Intel Open Source Graphics Center
