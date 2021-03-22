Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924E344A97
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhCVQGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhCVQFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D21619CF;
        Mon, 22 Mar 2021 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429143;
        bh=ppc9fZupOrjA6hpvzPGCige1HMZi82rKq0OzuPiwp30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfNQhB8I6TCilI9rWZIUvrD60VxxXK7zzzf2CzYQVcPCX4dTFC+5vrq57/HXue9eN
         7bPBi+K09Uuo8FgLHJN5cLADDDnPtd+D6sEhJhO/VLvKBoLaRa1BESfKHtMpZuvnwh
         D3Vc4uZU9Dcg74j9eeiZa4qkcbeOz2ZvcezhMcicUmJ4FzCGExiFKR4ER32CvaOaWV
         akMTcdJNfGrFGH5JvGZ7qns0oNxpRTzGH0qZ76EqyoQfhjLJvxqyHurET1PBvf6svb
         dBMESSwDo3iJsmPDGBQ1mVtfw03/ahNqDciEznfWOfvZZJNzU8YYxi4I1doMFPdTRo
         oo8eGNoKcMUqQ==
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
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
Date:   Mon, 22 Mar 2021 17:02:49 +0100
Message-Id: <20210322160253.4032422-12-arnd@kernel.org>
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

gcc-11 warns that intel_dp_check_mst_status() has a local array of
fourteen bytes and passes the last four bytes into a function that
expects a six-byte array:

drivers/gpu/drm/i915/display/intel_dp.c: In function ‘intel_dp_check_mst_status’:
drivers/gpu/drm/i915/display/intel_dp.c:4556:22: error: ‘drm_dp_channel_eq_ok’ reading 6 bytes from a region of size 4 [-Werror=stringop-overread]
 4556 |                     !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/display/intel_dp.c:4556:22: note: referencing argument 1 of type ‘const u8 *’ {aka ‘const unsigned char *’}
In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
include/drm/drm_dp_helper.h:1459:6: note: in a call to function ‘drm_dp_channel_eq_ok’
 1459 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
      |      ^~~~~~~~~~~~~~~~~~~~

Clearly something is wrong here, but I can't quite figure out what.
Changing the array size to 16 bytes avoids the warning, but is
probably the wrong solution here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 8c12d5375607..830e2515f119 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -65,7 +65,7 @@
 #include "intel_vdsc.h"
 #include "intel_vrr.h"
 
-#define DP_DPRX_ESI_LEN 14
+#define DP_DPRX_ESI_LEN 16
 
 /* DP DSC throughput values used for slice count calculations KPixels/s */
 #define DP_DSC_PEAK_PIXEL_RATE			2720000
-- 
2.29.2

