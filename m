Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B954162A8
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbhIWQGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:06:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35438 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242254AbhIWQF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:05:57 -0400
Message-ID: <20210923153339.561136215@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632413064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=/N572lnqpeKhSQ2LBWCWOVWDd83CspIx8lV7izCwEA0=;
        b=eIBJeskyWPAmb8TYgU19ExmRAeOgUx7OHcGhSAlWk9cCln7QogXZTLyfq0nr+rXwvMS50J
        RBFaFftxcfqhuR4kSOD8oGt3F5FWOJcIvPTK2wFXlm75TDOFHwbs1RG2vSAUfdH24dKXAT
        i54a+r5sTek/vFvCJXbk/smkbiCv3Md/iayefkXgR0hByxhwEbTDPR0VO2KUKmvq1+OHSW
        /oVOUIBe3A5XX6qUFHxGEoyof8DLvDNTa4a2NFAGh4zJo7tvin+CCYR4SdBz8SbCkGsfmH
        WdGA/h3Od4fx86qgDmAujHoujBF5vIAbI3/H6W/L39nPiR0CHouOaxrdqTaJ9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632413064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=/N572lnqpeKhSQ2LBWCWOVWDd83CspIx8lV7izCwEA0=;
        b=TH5AB5O/KXVllnKb65lhQoDM4Al+u7D1CMUk4+7DxzABLp3Y8BR2QQi2S35A2iCJrBo57e
        mbckkC3mSOnSxbBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [patch 03/11] net: iosm: Use hrtimer_forward_now()
References: <20210923153311.225307347@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 23 Sep 2021 18:04:23 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hrtimer_forward_now() is providing the same functionality. Preparation for
making hrtimer_forward() timer core code only.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: netdev@vger.kernel.org
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Intel Corporation <linuxwwan@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -482,8 +482,8 @@ static enum hrtimer_restart ipc_imem_sta
 		container_of(hr_timer, struct iosm_imem, startup_timer);
 
 	if (ktime_to_ns(ipc_imem->hrtimer_period)) {
-		hrtimer_forward(&ipc_imem->startup_timer, ktime_get(),
-				ipc_imem->hrtimer_period);
+		hrtimer_forward_now(&ipc_imem->startup_timer,
+				    ipc_imem->hrtimer_period);
 		result = HRTIMER_RESTART;
 	}
 

