Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E413EFB2E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhHRGJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhHRGI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:08:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059D7C061A2A
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso1593569pjy.5
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQ7Q3jdQqye6b63JEwuz0UrVtVAQHNs/hH6Rmr9vUg0=;
        b=OT8M8XZVnnmQITowEg3++UaRwWOJ1Y1SHyZ/03bsGckxWX9RY3SQa2j7WZwnatzVuC
         NUqrCYi7tlBXQ4eaoMu2IjOgZjsQuSChke6S+FXKsR302j/bACPi/fzos2tbRcPhxlJj
         cniRY49dbNdwPHsJy3Im0fWTrA1+un2S0g6Mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQ7Q3jdQqye6b63JEwuz0UrVtVAQHNs/hH6Rmr9vUg0=;
        b=OwfI/mjf9tibyhDJjesulna95PD7pvO+Sm3W+v+5LMg7WvxU2sthAs7EuWUPMkJj1O
         Wdo2/S3U8P9eNi/fzoMDroB3Vzti/54E+3+2lAFaH5pWg626RUAENuvnwD7tIdzxQi1t
         4u9ccDEIMVujaK+FqXiyosrVrEDLvnjhzKTROQpUwPdw0o4juaWjHRxPDo+bnWn+/Lj2
         hGlGaGiTGSY1cR0AFYZaD8u6Y0Tg9rwxKG2rHPS9Zte+Yvr/ZCQHgv9fjuDnx3FqSlMs
         0i3hbZ5IJ8pH7o3vCQf0svle+XWGACiOLHcthmUw9Hnm4x7wsz05eVJFAXWnDokjNnik
         Tysg==
X-Gm-Message-State: AOAM531oB6cGMom+oZdQoPEU3XN4Gf1/jBud2jS0OZMzalUx6iX68EmH
        SAhN99lFNJE8NOIyZDC94soRGg==
X-Google-Smtp-Source: ABdhPJxHDh79G9dXaOCC76aPYNrWjNDBVekEddb+DmPCiY5Po2r7Ips+iXeBS4T4v3zWCC+/q5ih1A==
X-Received: by 2002:a17:90b:1809:: with SMTP id lw9mr7721059pjb.231.1629266759658;
        Tue, 17 Aug 2021 23:05:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r4sm4798457pfc.167.2021.08.17.23.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:59 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 23/63] media: omap3isp: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:53 -0700
Message-Id: <20210818060533.3569517-24-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4161; h=from:subject; bh=6HM1xQAwdUhYlxd827odkUtGQFwknJXIWVVzXi/7nLw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMjIy4m5wHWpoRTBmOzDmU3UD7/uFHIYWL3ROtF R72c0SGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIwAKCRCJcvTf3G3AJoU1D/ 96jvsj5Or9IPBjba+1+MOrtyTu3Rf22j5jIOpSBXhF8bAVM3E+Mng2C2kqkdS2VlazoP3om8hm2RdP Bd6ykNbShrvCpyS87VH04TJw+MMBj3lrgwMSPGMclJCuzyMcoXTNNh15yCInvLI9PeemYWqaX5OVtK yisDsbYOp8PJHSGn95diLxU8nrq/G7J2RN/Z8rtlFQeqgGAHhVYXak6AH7RaDKvVmJFqEyhigpN1Gk 7YsDDbRdBgRAKkWtm+lXe5exSDPuh/0/ModmYO1MJ7p1DTSNMZ8BoyOq+RIVrYjd03hIxADreC4CsW 1DfHkIDk+wfRUUEYEgmCgzybZkG/huIU9uSvFPH10ar3mIWJednv0BvKLfmUTxIGGLhbh1Lppzq8Tv N92UE+OlAEEHytlx2d1oYz/6aP+kIBJisjP8fooNvawScUNc3Avdh8YhFjJ2pKLKKsAX9Lh1NSybsX Q/cUCJf44Cjh/P9My6aK0r5w1PlPN8bZ09qi29Fc6SNpT6AB9zaJc6lLqSESSe/+It0OLii+EpNDC1 mDrN/ZkbuxOBRJIwJl2iRCQOPHXSQ/Y6p2gshrXybuBLpLMu8a9tbUHdtwAdyRSxnBYRdHZ4ztMNzV 46peqTZ4Mh+JztxdkIJNqKE0o0PZValipPcEYLpotNQODIZtiKNEtjPvWCTg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields. Wrap the target region
in struct_group(). This additionally fixes a theoretical misalignment
of the copy (since the size of "buf" changes between 64-bit and 32-bit,
but this is likely never built for 64-bit).

FWIW, I think this code is totally broken on 64-bit (which appears to
not be a "real" build configuration): it would either always fail (with
an uninitialized data->buf_size) or would cause corruption in userspace
due to the copy_to_user() in the call path against an uninitialized
data->buf value:

omap3isp_stat_request_statistics_time32(...)
    struct omap3isp_stat_data data64;
    ...
    omap3isp_stat_request_statistics(stat, &data64);

int omap3isp_stat_request_statistics(struct ispstat *stat,
                                     struct omap3isp_stat_data *data)
    ...
    buf = isp_stat_buf_get(stat, data);

static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
                                               struct omap3isp_stat_data *data)
...
    if (buf->buf_size > data->buf_size) {
            ...
            return ERR_PTR(-EINVAL);
    }
    ...
    rval = copy_to_user(data->buf,
                        buf->virt_addr,
                        buf->buf_size);

Regardless, additionally initialize data64 to be zero-filled to avoid
undefined behavior.

Fixes: 378e3f81cb56 ("media: omap3isp: support 64-bit version of omap3isp_stat_data")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/platform/omap3isp/ispstat.c |  5 +++--
 include/uapi/linux/omap3isp.h             | 21 +++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 5b9b57f4d9bf..68cf68dbcace 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 					struct omap3isp_stat_data_time32 *data)
 {
-	struct omap3isp_stat_data data64;
+	struct omap3isp_stat_data data64 = { };
 	int ret;
 
 	ret = omap3isp_stat_request_statistics(stat, &data64);
@@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 
 	data->ts.tv_sec = data64.ts.tv_sec;
 	data->ts.tv_usec = data64.ts.tv_usec;
-	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
+	data->buf = (uintptr_t)data64.buf;
+	memcpy(&data->frame, &data64.frame, sizeof(data->frame));
 
 	return 0;
 }
diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
index 87b55755f4ff..9a6b3ed11455 100644
--- a/include/uapi/linux/omap3isp.h
+++ b/include/uapi/linux/omap3isp.h
@@ -162,6 +162,7 @@ struct omap3isp_h3a_aewb_config {
  * struct omap3isp_stat_data - Statistic data sent to or received from user
  * @ts: Timestamp of returned framestats.
  * @buf: Pointer to pass to user.
+ * @buf_size: Size of buffer.
  * @frame_number: Frame number of requested stats.
  * @cur_frame: Current frame number being processed.
  * @config_counter: Number of the configuration associated with the data.
@@ -176,10 +177,12 @@ struct omap3isp_stat_data {
 	struct timeval ts;
 #endif
 	void __user *buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no type */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 
 #ifdef __KERNEL__
@@ -189,10 +192,12 @@ struct omap3isp_stat_data_time32 {
 		__s32	tv_usec;
 	} ts;
 	__u32 buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no type */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 #endif
 
-- 
2.30.2

