Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C153AA4BD
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhFPTz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhFPTz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:55:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4575C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:53:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g4so2404731pjk.0
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzHup0H6Vegu59qU+atIUwPpdONAxlTyUHNty9ohr3s=;
        b=CSCRXMIMvz3qd+sf9SNCKVEfrrcvoVXugabEeD9iBEFHR2z5bA1g/qwK3IelLRbF+0
         vEKoMhMXQX6ULMQAY6b8FyNwUnMea8CB9dWCEnjp+48WQk4LX6Lx5XI9k9f7KnXDkEH8
         kx4+c+y4jvdbtVYjL7hpxDJEDhVtJzK4AZx6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzHup0H6Vegu59qU+atIUwPpdONAxlTyUHNty9ohr3s=;
        b=LmYnpmv+V8AKA2K/3sx0RJPyRKCVVo//ru740SG9kYQcAfecacycMaxdVz8RrNz1H4
         PV8bb5JhdITYkI91D7o630Vkjd+77B0KhTw+lYqxaBe5hG6wJ/NHJsRwmoqit91qpRCE
         kyBAIVRyuv0fbZJXreA9L0Pv3PdWgUTwi7r1VjeXI4/qsjUhcXPApMAx18JiScNoIPnt
         6uYkO27H3ndraxZLZ5L1FcCkBsRy9Z1tpIi+GbtDyEvFy/UisNEP1A5V9rEZCbNDrc5E
         CZSERtwr7qN+LnW2akcOXgsFAhiFM2MdcmbS7T4t0wZ/qSGrCdWHtiQWpgB/N9viYSMe
         Rikg==
X-Gm-Message-State: AOAM532Z1SfwDVi/zKgtosFawY8NuHzJ1NL7yG/0k+BSohL1N+JmKsa+
        XElplibbbem6H5LFEMMfe4LLiA==
X-Google-Smtp-Source: ABdhPJy/Y52NcvPMMjqRk40SyVKghvJv+lgF6vsqbYRpbjyBW3HMlkExU8OnZrsBDz31Np3iOpPS7A==
X-Received: by 2002:a17:90b:3e89:: with SMTP id rj9mr1523673pjb.114.1623873228411;
        Wed, 16 Jun 2021 12:53:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f15sm3007836pgg.23.2021.06.16.12.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:53:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hardening@vger.kernel.org
Subject: [PATCH] e100: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Wed, 16 Jun 2021 12:53:44 -0700
Message-Id: <20210616195344.1231850-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=4478c5fecbde1e0721ac67faca5780db5a883da6; i=fkpCCG3twRCnzgbx6tnA60/xgpLIFo7OVVMVyUOI52M=; m=CF57NG64wUjRAJMr07rJpYR31VG7hNQuEGsWk+kxwfo=; p=0rZkHGyxgtrru4XR+5wKed0CXqik4Lmw7Ni3XpznuwU=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKVsgACgkQiXL039xtwCZCeg/+P5j WLT5CuaEh2UcftJai0qrhkuUHyev0+BVMDvbeGZ6VdaLbvqmcqsXRhc1JsJSOwLFJj851Nvc6a/Ty 5oVLkVa3RW6qr1UsR/9B5jnnm2DPI2+d4dBhHWRTDC8seJIIbKzKp1cOnJydFG97c8/uHgMyhPJap k/Yk3IrFJVLuGGwhmbdf0VXquNch9ph6x8pZBJRUi35mEmIVw1KTI2T8/obkd3I8jJsVwLlM1CxT3 SXVtX2nU1pZY3xjqVF0oNdiLz5gl/4crHtt4VXXpyh8Q391+4ypojwRYXZyYyqxhBYmMek1igCKZ/ Zwnat30HmlP5PWJayhnv01I7BUt/GQmvc4JPWm1qE9mbNAEKrGg3tIYSyMg4egu1pmh+Kd9gQpztt PMABu0r+VJdpq5TvpdckyZeo59jc4mOr797arZQ6gnmDWTPH/TLJDRCo/Q3WLHHqtk02oYhji3Set BGA+1hbRyfeiVgU1eA0tCl8iVwVdJRfMp9rJSS66qZJm5W0gEhH3BuOpZEYaECDA4OBcv3GYgCSsF nRkzfc0TqXP4vpBQiRdtj7dgoHFvfXPncL4H6lZ3zpNybTWwEOvbX708tq3DIlpm4cO7ZjghyZvoM 2xFRSxsCBcbrlP1eV5jxudJx3jLaAnA91nGp3wXIz4vFx++il4A05k5BsW3Nm940=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/e100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b0958bd24f6..1ec924c556c5 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2715,10 +2715,10 @@ static void e100_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_TEST:
-		memcpy(data, *e100_gstrings_test, sizeof(e100_gstrings_test));
+		memcpy(data, e100_gstrings_test, sizeof(e100_gstrings_test));
 		break;
 	case ETH_SS_STATS:
-		memcpy(data, *e100_gstrings_stats, sizeof(e100_gstrings_stats));
+		memcpy(data, e100_gstrings_stats, sizeof(e100_gstrings_stats));
 		break;
 	}
 }
-- 
2.25.1

