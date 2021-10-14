Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE67042D0E7
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhJNDWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhJNDWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:22:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D6DC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 20:20:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id t184so3402892pfd.0
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 20:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=9Cuicd3PFIxAlARTuuynTrEXWzNJIhPX5Qri2j7k0U8=;
        b=YNfmlJzkiPAUidyhUyJL2zo7zc8tt8H+qRgi/VbebgOvhmx/choTZS2ebSEXVWcThn
         dpBI333uQuTjkAG6dcXq8YC0oUZh/0toaWx6Ok7dIbi3VSYMDkDWx4BGrRbvy3RMXVEl
         Jm+mtHQOB7gBL/+Pp2DqwSkO3SOkh//AgmSAS3h/pDo6VSEX9bQ0Lzuy8hPgo7NKpopW
         xfoEzlGquO2mTZQZVBPRg1Og71cvNkaFExIBBA1dGAkPtKe6Lssna5JJ57mQtsfttNrP
         KxuG2k+zLA4/8bhz5fvnMjeEGJKYUD/dIYzW46FZ+ywfobp7AdNYM/yxHiD3Lie9KbJA
         21Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9Cuicd3PFIxAlARTuuynTrEXWzNJIhPX5Qri2j7k0U8=;
        b=AUeyx0Zl0o6XC17/8EyracceG4D8TWIfMutdXWRaYfcHl2m3qolPyXEWbSVUAgMoNV
         8NOAIg0fgN/HFcxxwKTRCU0f3AvypeRrq6EkTv6v/lM0QqR+5Hxgtvldszq55zmWpVms
         0iaGSsf1xMNvys5puA8LQoU+KA9MVukjx2t9rSskItdGoTD/PmSuOP8BrleNkcRFyAbl
         s56SJzyjOcdM4Hd1V7d1soog7BaqLAUt/y5QJbL9t7PMljAUHSxFm8bQMiX6z9j33Qdn
         qNo6ecE9wq5B9Ap+L4mvEZ753Q4UBZ3mqXi5xQ7qbQCCrudSNi/jkszo9UUEquuIH8km
         aDlw==
X-Gm-Message-State: AOAM530F7Iip+kKSYPLNyx5e7G4XwJeQE8GretTDNw5osxJHUqt2jIW6
        Hppp5Op7WpYohqNWmqX4chhuwQ==
X-Google-Smtp-Source: ABdhPJwIRptt2ov/n+J0S0JoTm7yb52BjYQ8rYjMKg4OwY7K7uN512z20/GO4wthSZk3XE5asPR38w==
X-Received: by 2002:a63:4d20:: with SMTP id a32mr2380296pgb.247.1634181640406;
        Wed, 13 Oct 2021 20:20:40 -0700 (PDT)
Received: from n198-098-106.byted.org ([221.194.138.205])
        by smtp.googlemail.com with ESMTPSA id q3sm855627pgf.18.2021.10.13.20.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 20:20:40 -0700 (PDT)
From:   Kele Huang <huangkele@bytedance.com>
To:     richardcochran@gmail.com
Cc:     xieyongji@bytedance.com, huangkele@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: fix error print of ptp_kvm on X86_64 platform
Date:   Thu, 14 Oct 2021 11:19:52 +0800
Message-Id: <20211014031952.1573640-1-huangkele@bytedance.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a86ed2cfa13c5 ("ptp: Don't print an error if ptp_kvm is not supported")
fixes the error message print on ARM platform by only concerning about
the case that the error returned from kvm_arch_ptp_init() is not -EOPNOTSUPP.
Although the ARM platform returns -EOPNOTSUPP if ptp_kvm is not supported
while X86_64 platform returns -KVM_EOPNOTSUPP, both error codes share the
same value 95.

Actually kvm_arch_ptp_init() on X86_64 platform can return three kinds of
errors (-KVM_ENOSYS, -KVM_EOPNOTSUPP and -KVM_EFAULT). The problem is that
-KVM_EOPNOTSUPP is masked out and -KVM_EFAULT is ignored among them.
This patch fixes this by returning them to ptp_kvm_init() respectively.

Signed-off-by: Kele Huang <huangkele@bytedance.com>
---
 drivers/ptp/ptp_kvm_x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index d0096cd7096a..4991054a2135 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -31,10 +31,10 @@ int kvm_arch_ptp_init(void)
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
 			     KVM_CLOCK_PAIRING_WALLCLOCK);
-	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
+	if (ret == -KVM_ENOSYS)
 		return -ENODEV;
 
-	return 0;
+	return ret;
 }
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
-- 
2.11.0

