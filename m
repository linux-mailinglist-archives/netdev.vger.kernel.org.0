Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373481F8733
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 08:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgFNGLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 02:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNGLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 02:11:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA17C08C5C2
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 23:11:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n11so16601278ybg.15
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 23:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oGqf1++ISmFDrH0evkdua75pRZ4Kzg4x3LpxsrrLQ3g=;
        b=BrFABM4ag3AiIkSAHTtzYJj0AVfZShfyt1f0NnrQp455Jd0W0DB6UkLYIIE25QbI5i
         4oQjlZJygOW9OsWUpbYo1FOpfEIcV525+YWblJxIUp9aQCvnP8kHIONSCdLKeF0QrGRC
         kdy0lTibbcyCtdaHFnannbdLfSqoLIkJkzQ1+Zh0f8M6injkicSk1bqvW99lAsN5/Z4c
         TfeVCsnX9LEaV9GoifSVE4TyA734e7k1z05IpAZaoEMaB1ddmnOSemdp2//KLKNqDSnd
         +6Z9ybiyd8pKCkVBFOC5Al7D23LY/9LV92IsE9YVknh5lgDV2R0bT5Qyp0GDPxqorIRH
         e0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oGqf1++ISmFDrH0evkdua75pRZ4Kzg4x3LpxsrrLQ3g=;
        b=XM8JPw3mIP4aOJ4QkcOFdE+QMFvOBSMC2Vi9iOfruNWk1g9wu+u2lMZpW2TAF2XD6m
         Z+M9INSGKveJKrvJ6DQxuXEKnnriKzFlvn7xvU0+IdrrKx789NGAzfAsYVOqpxnMss2k
         3OLF9BPMjoVdeZ3Lj12bj87c8xJi/CIN9ZSJVNo6T1A/rIY7i5Pry3IlyaT9Wso+mQfF
         n/KoMMJh75ypaOofBZG9ku5K1LG6DMpMT1SrtePcIRcuwlUXd6O4Jk0YcdUBidxJRou7
         9chtZHxPKafi5A2jl9qGkeYVdrIycP9/DovwYQTpxA9LbeRb1BYERS99hTKzle/8VWz0
         3jCg==
X-Gm-Message-State: AOAM5312WbBjF8ixNJUqKSOO1rRVntxukJq3hnHm/jHdUPsqkM4RitkW
        Nhv2UlwZ6xksk92uFb+vLgNKu+pKnJ2z
X-Google-Smtp-Source: ABdhPJxxc0GMogasoSu0mC2tbZOz7tMTybNRR6DrolxuDsgmM7O1Gh44O1ln4xXp0yUDKzvhrDI33/b22P51
X-Received: by 2002:a25:2604:: with SMTP id m4mr33252495ybm.470.1592115089241;
 Sat, 13 Jun 2020 23:11:29 -0700 (PDT)
Date:   Sat, 13 Jun 2020 23:11:22 -0700
Message-Id: <20200614061122.35928-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] e1000e: add ifdef to avoid dead code
From:   Greg Thelen <gthelen@google.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
systems") added e1000e_check_me() but it's only called from
CONFIG_PM_SLEEP protected code.  Thus builds without CONFIG_PM_SLEEP
see:
  drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning: 'e1000e_check_me' defined but not used [-Wunused-function]

Add CONFIG_PM_SLEEP ifdef guard to avoid dead code.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a279f4fa9962..165f0aea22c9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -107,6 +107,7 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
 	{0, NULL}
 };
 
+#ifdef CONFIG_PM_SLEEP
 struct e1000e_me_supported {
 	u16 device_id;		/* supported device ID */
 };
@@ -145,6 +146,7 @@ static bool e1000e_check_me(u16 device_id)
 
 	return false;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
-- 
2.27.0.290.gba653c62da-goog

