Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951EC41F021
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhJAPAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:00:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57888 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhJAPAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:00:34 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633100328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lz8lRAWbKl0x5qKf332mZri03TpupxmEQwHO3I4oZDw=;
        b=lJmg1PquxxU4f28wY5mI4f/WgODTbOm/Iv0pVKOWfTeM+mXF+nZU5IRFoHHOPSN7Q9n4Fq
        3015EL6leb8BnKVIhccbALlXz+2Bu/dVtIqq+kPPERruLgLJUo9qSC6KJl2n5HqQKOIJpI
        Y0KCbtcxRXRzlkDoCMTZuWtF2xkJGmpAiNLSE1wZD1ECkXvUsbpAjMBycinGbEt5e+p4DH
        XvGMGaD9AUwANimsLRKoe78tvybgNmccJdvdqADsIBR3ManTGmfaPv2cM9MQ3rXmpgvh//
        dx4eRmWG+sHM7NyRSWjQbtNMTPKRloe6740OHanhLzzVRH2adAQKLxz19HuArQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633100328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lz8lRAWbKl0x5qKf332mZri03TpupxmEQwHO3I4oZDw=;
        b=4+lLHTD9liCptIi4DZvBqcFDysi5h5NZL5uTCz7XfiD2S3miRRodKOntcFnm9nqI2fg0q4
        StoMvy4WXxxReYCA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next] net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT
Date:   Fri,  1 Oct 2021 16:58:41 +0200
Message-Id: <20211001145841.2308454-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_busy_loop() disables preemption and performs a NAPI poll. We can't acq=
uire
sleeping locks with disabled preemption which would be required while
__napi_poll() invokes the callback of the driver.

A threaded interrupt performing the NAPI-poll can be preempted on PREEMPT_R=
T.
A RT thread on another CPU may observe NAPIF_STATE_SCHED bit set and busy-s=
pin
until it is cleared or its spin time runs out. Given it is the task with the
highest priority it will never observe the NEED_RESCHED bit set.
In this case the time is better spent by simply sleeping.

The NET_RX_BUSY_POLL is disabled by default (the system wide sysctls for
poll/read are set to zero). Disabling NET_RX_BUSY_POLL on PREEMPT_RT to avo=
id
wrong locking context in case it is used.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index fb13460c6dab3..074472dfa94ae 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -294,7 +294,7 @@ config CGROUP_NET_CLASSID
=20
 config NET_RX_BUSY_POLL
 	bool
-	default y
+	default y if !PREEMPT_RT
=20
 config BQL
 	bool
--=20
2.33.0

