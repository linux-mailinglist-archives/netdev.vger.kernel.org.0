Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363F41B8380
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 05:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDYDlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 23:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726124AbgDYDlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 23:41:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4DC09B049;
        Fri, 24 Apr 2020 20:40:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so4709953pjh.2;
        Fri, 24 Apr 2020 20:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=84OOmVAi450mFFb8+0vgcFAEdXOfUlR1o+qLDWAE8W8=;
        b=OIzJ/6/iQEIcIVuq+TiS0ASGqW6e70sttvnwauG8yAM8CNxDuUOek0EljcRfkpIfn5
         cT21rciAnWpyK06lV0NUA3CJ7YPTB2bfogQQpzKdQdMB40XNM4UqNuuaaypzNLC4LVY+
         yzobGZwu0Eo6J4VoayY4XdLWLlNyw6bxQ+oyOklmqyiXDJS5lB3Lha0/6xmRIzFKiqZ9
         xunpUrDOCf2qrXr83KISSo4188/Yj3Ha57Dm7Xws2WGIkzRiDjnClzzLsqINmMssDi1X
         faLHawmkxLatPfGBp9viokgZ2GP+DCznQmU0hVghHO3ZBZ8rPga4vbJd7Uw612K5n9zP
         wkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=84OOmVAi450mFFb8+0vgcFAEdXOfUlR1o+qLDWAE8W8=;
        b=pL9yiZxYjr3UK38acf3hooN3ErN2ZwAjGstALoOl+7i1S/a6LfjtOXvFKQK2CxdSBe
         fNp3IwqkHG6w++r5iKXsqFYJR/CubcytDFbq0qeBJfgYr6ZrUp/yQBimPd6TDyaZ4KyR
         4iigcPNjM9aPfKQZD9RZ0i+4LYjlsb2polJ3Fz8M1h0Ch94mEdBa6oNCFOka+gv3jnQB
         xd/McMZWwe5wmUTv0LkR0JXHRT6EmOuK3yQoWsmdhflorR807tPOirDH1sOMpgqZnng7
         d6fgqVuLTdn3wnJiel0dzhb8gvUYTBn9/qgDwE+RzUjkobOFWPHVkE2nMo/JjFy5Wi5c
         nw8A==
X-Gm-Message-State: AGi0PuaLDj0vSCAb7HvxYKKF43TSy3qCC4i2Bb7UfQ4ih3k2+uyYNHNp
        WRS6mSmcaS+7qWjSTE9wUkw=
X-Google-Smtp-Source: APiQypK2ryA1Q8OknVW7rhVnbt+8VTJe2MYl1aWZlMJSNqrkGSEjZhvuwIF95udYgFk7NoYxS8M0Yw==
X-Received: by 2002:a17:90b:3443:: with SMTP id lj3mr10198220pjb.38.1587786059450;
        Fri, 24 Apr 2020 20:40:59 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id g9sm6096353pgj.89.2020.04.24.20.40.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 20:40:59 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     eric.dumazet@gmail.com, geert@linux-m68k.org, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH 2/2] net: openvswitch: use div_u64() for 64-by-32 divisions
Date:   Sat, 25 Apr 2020 11:39:48 +0800
Message-Id: <1587785988-23517-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Compile the kernel for arm 32 platform, the build warning found.
To fix that, should use div_u64() for divisions.
| net/openvswitch/meter.c:396: undefined reference to `__udivdi3'

[add more commit msg, change reported tag, and use div_u64 instead
of do_div by Tonghao]

Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
The author should be:
Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/openvswitch/meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 612ad5586ce9..3d3d8e094546 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -393,7 +393,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 * Start with a full bucket.
 		 */
 		band->bucket = (band->burst_size + band->rate) * 1000ULL;
-		band_max_delta_t = band->bucket / band->rate;
+		band_max_delta_t = div_u64(band->bucket, band->rate);
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
 		band++;
-- 
2.23.0

