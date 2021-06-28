Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3C3B6B54
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhF1X2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhF1X23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:28:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26E6C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:26:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j11so2997822edq.6
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2ypRTeGHuIOXSEJy9R66nJ8j/xbaZrpom+WwAyuP5cE=;
        b=Ov9QNozqoz/wIo/6zdnuXVrulV7q7idxyUSmryBaQN6lHQc2x9OR5Jb81YjNsXjOIY
         MtJFF5UNMk4JW/56cfWt01MBynaDs0+8rpBGWzsLu7feRIgnn1e7afMiPTCBJ5U0Kn+Z
         hXfx1NqH3ar3m28MjJBfnGseY2NNtkDGN8ZvKC5z3qtNN0lHGtg6eLwScsx/+QWXyXXf
         Ul79IaJFiMR5mHu2O3ArIUcWVHUjXteomPs+eYMuQMYq0/rgF1fDWjp8RClTuhov2e3x
         Ecu+u5+QiQcNpxvjerKSQ+EoJiJj3GQdE64mFFEwEaw4xJJ1kp0/ViQiuGq+WwJNODrS
         5qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2ypRTeGHuIOXSEJy9R66nJ8j/xbaZrpom+WwAyuP5cE=;
        b=lD0U1z17zBAdn+nQ52puo75vnnV2pYica+MVtFB5ifnWsaIzQ5MaVO0yQsSRVT98MC
         ctGQPgAaJaV8oYZwS7v3t0kZz7NQ/YAN9fnOlfO4N2bJuecG8KjJ2VK3c+dKU4AtOXBs
         udI5RJRwZj7ip6eXwOr9VkpWbt3v98l9GEgEo04Hf9cD/v3cHdOnbRgs+2yUPUQbaHFM
         xNl8Pi2RItfj8iehibRv3fw9kHYcki9pybdtc5oVwo9eS8eNdoyQz/F2gLtOQZ7zAjH5
         FAHTQIVanUlT8kJUz/ejVfKz0wosUJRZWAeB8V4ACNnOzOr7/M6S1F0GZFVoCk3Bcy6/
         L5+Q==
X-Gm-Message-State: AOAM532ikM3fIe76K6weRYJ1ucybYYNZwGH6ifqhmyQQbZmB36aIqDiO
        2MHsQU+Fp4m9B7sUTnPrAWNpxN491L0Org==
X-Google-Smtp-Source: ABdhPJx4YEJ4N+EZm3D+ZCcHA5OuyjxSka9dmT05a2T/bvQM8nhGxek9xVLGA9au1cFiSxFUkinHKg==
X-Received: by 2002:aa7:d592:: with SMTP id r18mr1779640edq.269.1624922761259;
        Mon, 28 Jun 2021 16:26:01 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id du7sm10118903edb.1.2021.06.28.16.26.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:26:01 -0700 (PDT)
Date:   Tue, 29 Jun 2021 01:25:59 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 2/2] devlink: Fix printf() type mismatches on 32-bit
 architectures
Message-ID: <20210628232558.GB1443@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628232446.GA1443@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink currently uses "%lu" to format values of type uint64_t,
but on 32-bit architectures uint64_t is defined as unsigned
long long and this does not work correctly.

Fix this by using the standard macro PRIu64 instead.

Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 devlink/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0b5548fb..5db709cc 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3546,7 +3546,7 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 		}
 	}
 	if (total) {
-		pr_out_tty(" %3lu%%", (done * 100) / total);
+		pr_out_tty(" %3"PRIu64"%%", (done * 100) / total);
 		ctx->last_pc = 1;
 	} else {
 		ctx->last_pc = 0;
@@ -3601,7 +3601,7 @@ static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
 		 */
 		if (!ctx->status_msg_timeout) {
 			len = snprintf(msg, sizeof(msg),
-				       " ( %lum %lus )", elapsed_m, elapsed_s);
+				       " ( %"PRIu64"m %"PRIu64"s )", elapsed_m, elapsed_s);
 		} else if (res.tv_sec <= ctx->status_msg_timeout) {
 			uint64_t timeout_m, timeout_s;
 
@@ -3609,11 +3609,11 @@ static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
 			timeout_s = ctx->status_msg_timeout % 60;
 
 			len = snprintf(msg, sizeof(msg),
-				       " ( %lum %lus : %lum %lus )",
+				       " ( %"PRIu64"m %"PRIu64"s : %"PRIu64"m %"PRIu64"s )",
 				       elapsed_m, elapsed_s, timeout_m, timeout_s);
 		} else {
 			len = snprintf(msg, sizeof(msg),
-				       " ( %lum %lus : timeout reached )", elapsed_m, elapsed_s);
+				       " ( %"PRIu64"m %"PRIu64"s : timeout reached )", elapsed_m, elapsed_s);
 		}
 
 		ctx->elapsed_time_msg_len = len;
-- 
2.20.1


