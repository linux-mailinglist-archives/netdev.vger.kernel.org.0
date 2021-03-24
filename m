Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD95347F44
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhCXRXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:23:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:16672 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237098AbhCXRW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 13:22:59 -0400
IronPort-SDR: cQtKDfGSRClLmG3tg20PD7vnKE61zdl5Iy47lu7s8sWzMA5CBf7KgaDKt61tL4HaJj+00Su1S3
 pZ8MXBc748TA==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="252110427"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="252110427"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 10:22:57 -0700
IronPort-SDR: q7x5MCG+vkoOU9Zt5AI1qoSHSHC0Zp99QAlPGLHuv2CUXVcGAPnke24VDa6jskQUUfvyu5ceVQ
 Ar5TomltcFSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="443059639"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by FMSMGA003.fm.intel.com with SMTP; 24 Mar 2021 10:22:49 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 24 Mar 2021 19:22:48 +0200
Date:   Wed, 24 Mar 2021 19:22:48 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
        Martin Sebor <msebor@gcc.gnu.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, Ning Sun <ning.sun@intel.com>,
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
        =?iso-8859-1?Q?Jos=E9?= Roberto de Souza 
        <jose.souza@intel.com>, Matt Roper <matthew.d.roper@intel.com>,
        Aditya Swarup <aditya.swarup@intel.com>
Subject: Re: [PATCH 10/11] drm/i915: avoid stringop-overread warning on
 pri_latency
Message-ID: <YFt1aBFwJI+z97g3@intel.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-11-arnd@kernel.org>
 <874kh04lin.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kh04lin.fsf@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 05:30:24PM +0200, Jani Nikula wrote:
> On Mon, 22 Mar 2021, Arnd Bergmann <arnd@kernel.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > gcc-11 warns about what appears to be an out-of-range array access:
> >
> > In function ‘snb_wm_latency_quirk’,
> >     inlined from ‘ilk_setup_wm_latency’ at drivers/gpu/drm/i915/intel_pm.c:3108:3:
> > drivers/gpu/drm/i915/intel_pm.c:3057:9: error: ‘intel_print_wm_latency’ reading 16 bytes from a region of size 10 [-Werror=stringop-overread]
> >  3057 |         intel_print_wm_latency(dev_priv, "Primary", dev_priv->wm.pri_latency);
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/gpu/drm/i915/intel_pm.c: In function ‘ilk_setup_wm_latency’:
> > drivers/gpu/drm/i915/intel_pm.c:3057:9: note: referencing argument 3 of type ‘const u16 *’ {aka ‘const short unsigned int *’}
> > drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function ‘intel_print_wm_latency’
> >  2994 | static void intel_print_wm_latency(struct drm_i915_private *dev_priv,
> >       |             ^~~~~~~~~~~~~~~~~~~~~~
> >
> > My guess is that this code is actually safe because the size of the
> > array depends on the hardware generation, and the function checks for
> > that, but at the same time I would not expect the compiler to work it
> > out correctly, and the code seems a little fragile with regards to
> > future changes. Simply increasing the size of the array should help.
> 
> Agreed, I don't think there's an issue, but the code could use a bunch
> of improvements.
> 
> Like, we have intel_print_wm_latency() for debug logging and
> wm_latency_show() for debugfs, and there's a bunch of duplication and
> ugh.

There is all this ancient stuff in review limbo...
https://patchwork.freedesktop.org/series/50802/

-- 
Ville Syrjälä
Intel
