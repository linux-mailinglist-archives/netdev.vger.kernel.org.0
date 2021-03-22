Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99DA344A94
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhCVQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhCVQFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E526619B3;
        Mon, 22 Mar 2021 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429130;
        bh=Cz6Ib/Jy2MCBRG3RkrW7YxIgzj/6kEv+v4DuuyruVdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmX1KQkIWDTM9oL9SIaizhQuXBgId2TgjaOHRvpRa8ujB1Hj1aOwCgrCrMNJVi2gq
         P8VgokfOwAmfnYZLX1rsRk4pLvkeDX2bspNuX1VYi25/JXoxXtnn7F2MgFWC0FsAFu
         N+uQuJ3Me21QeU0KrCs4aFbaBIGeJwlctHwPj1pA51MBMY2ra+UvbFh+zl+P+BsSj9
         1ElKemq6Wxa1TUdo/FGf/LywTMYZxZt3573Q+qI3GKdCXVd48krzSZHquQETNI++01
         tCB8r6B7NO2iohCFFlGopnfYJGFYOD5rOpt+nJhCejnPW+cx72ztkTHm7tbHkrEoPf
         S1/KeKBMSo8Ag==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
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
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Aditya Swarup <aditya.swarup@intel.com>
Subject: [PATCH 10/11] drm/i915: avoid stringop-overread warning on pri_latency
Date:   Mon, 22 Mar 2021 17:02:48 +0100
Message-Id: <20210322160253.4032422-11-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 warns about what appears to be an out-of-range array access:

In function ‘snb_wm_latency_quirk’,
    inlined from ‘ilk_setup_wm_latency’ at drivers/gpu/drm/i915/intel_pm.c:3108:3:
drivers/gpu/drm/i915/intel_pm.c:3057:9: error: ‘intel_print_wm_latency’ reading 16 bytes from a region of size 10 [-Werror=stringop-overread]
 3057 |         intel_print_wm_latency(dev_priv, "Primary", dev_priv->wm.pri_latency);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c: In function ‘ilk_setup_wm_latency’:
drivers/gpu/drm/i915/intel_pm.c:3057:9: note: referencing argument 3 of type ‘const u16 *’ {aka ‘const short unsigned int *’}
drivers/gpu/drm/i915/intel_pm.c:2994:13: note: in a call to function ‘intel_print_wm_latency’
 2994 | static void intel_print_wm_latency(struct drm_i915_private *dev_priv,
      |             ^~~~~~~~~~~~~~~~~~~~~~

My guess is that this code is actually safe because the size of the
array depends on the hardware generation, and the function checks for
that, but at the same time I would not expect the compiler to work it
out correctly, and the code seems a little fragile with regards to
future changes. Simply increasing the size of the array should help.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/i915/i915_drv.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 26d69d06aa6d..3567602e0a35 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1095,11 +1095,11 @@ struct drm_i915_private {
 		 * in 0.5us units for WM1+.
 		 */
 		/* primary */
-		u16 pri_latency[5];
+		u16 pri_latency[8];
 		/* sprite */
-		u16 spr_latency[5];
+		u16 spr_latency[8];
 		/* cursor */
-		u16 cur_latency[5];
+		u16 cur_latency[8];
 		/*
 		 * Raw watermark memory latency values
 		 * for SKL for all 8 levels
-- 
2.29.2

