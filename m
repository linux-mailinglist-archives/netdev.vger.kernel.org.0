Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15B645683A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhKSCjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:39:55 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45528 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231217AbhKSCjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:39:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xhao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UxG4QBC_1637289411;
Received: from localhost.localdomain(mailfrom:xhao@linux.alibaba.com fp:SMTPD_---0UxG4QBC_1637289411)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Nov 2021 10:36:51 +0800
From:   Xin Hao <xhao@linux.alibaba.com>
To:     richardcochran@gmail.com
Cc:     xhao@linux.alibaba.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V1] arm64: kvm-ptp: Fix unreasonable return value judgment
Date:   Fri, 19 Nov 2021 10:36:44 +0800
Message-Id: <f94da8a27102a29bb178d5ca237b9e5760154238.1637289060.git.xhao@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kvm_arch_ptp_init() func, it calls kvm_arm_hyp_service_available()
which return value is bool type, the return value cannot be less than 0
So there fix it.

Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
---
 drivers/ptp/ptp_kvm_arm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
index b7d28c8dfb84..38b06e87a192 100644
--- a/drivers/ptp/ptp_kvm_arm.c
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -13,10 +13,7 @@
 
 int kvm_arch_ptp_init(void)
 {
-	int ret;
-
-	ret = kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PTP);
-	if (ret <= 0)
+	if (!kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PTP))
 		return -EOPNOTSUPP;
 
 	return 0;
-- 
2.31.0

