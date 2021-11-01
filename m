Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDC3441F70
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhKARmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhKARmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:42:16 -0400
Received: from mail-ua1-x963.google.com (mail-ua1-x963.google.com [IPv6:2607:f8b0:4864:20::963])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32EAC061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 10:39:36 -0700 (PDT)
Received: by mail-ua1-x963.google.com with SMTP id ay21so12733182uab.12
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 10:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pDN+LX8hoURSSUz1DrVeeghR7JgkeBcWslmRDKSGtoQ=;
        b=Q/vvQL+mIv8C6AZFa+0iEKNXJecivwO18EznsQBhpgm71PWJ4m9GWpO93xbf0MzSM+
         q3fqrnqiKkXgX/XQu0n5lYjs9GcxMkECZCV6LNj3GbwxRNLPeKaRaEsIuh0ZqwyzsPc+
         zZ7s743plnuYssqOVJjE93zOHAeewJ/M7kJRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pDN+LX8hoURSSUz1DrVeeghR7JgkeBcWslmRDKSGtoQ=;
        b=8NAP6D18ectnMUr78mUEqAr8+hmhWHaiLyziTh54HoDA92wnyoH5AGBzmti8sW2F/b
         WqRqyeNE80IZhTq55XqeQoYzsNQwnKZudk1xIINIhe0Cf15HalfZrdjlJ+ZUqn7Cg1KC
         aUHBhXS8ke9ZWQ3MQ3UR1dXxC3FPq4jaYwc7hpR1ZTsWwGOd1tOqEjPWXrO9Sn8Fy64b
         +WPdM/t4TXWnExClUhWRRE1lANdLHQbQEfwUsLO0+16DTMpnUQ8/nUOMg3UCeek2Xm1M
         0f9PUTeV3Iiq71cU/KhSCpZhg3AdM0RvI8Pzi74q1geMaNCzxKNbgDG2hEy9cKMD97Tw
         3UVQ==
X-Gm-Message-State: AOAM533o56ywwDkymK6HK6t0R8d31whxYS7r7tbABw8LzHaW6VaUPaxG
        WNFHIzkDS7KwbXpfddlSzaRJ/QAmGaBEmXoS2UHTdykGAyYtbg==
X-Google-Smtp-Source: ABdhPJy4t8pvVdqZYGJa1F1/4nv5Nf8SRkx9ePNsfEbpUWt4iuP3oNNHCwZJBCS2roQPwQfzvFoZMw5owcR9
X-Received: by 2002:a05:6102:11f5:: with SMTP id e21mr12607991vsg.47.1635788375831;
        Mon, 01 Nov 2021 10:39:35 -0700 (PDT)
Received: from c7-smtp.dev.purestorage.com ([192.30.188.252])
        by smtp-relay.gmail.com with ESMTPS id bk48sm315897vkb.12.2021.11.01.10.39.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 10:39:35 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id A9E1A22085;
        Mon,  1 Nov 2021 11:39:34 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
        id 9DA80E40BDC; Mon,  1 Nov 2021 11:39:04 -0600 (MDT)
From:   Caleb Sander <csander@purestorage.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Caleb Sander <csander@purestorage.com>,
        Joern Engel <joern@purestorage.com>,
        Tony Brelinski <tony.brelinski@intel.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH v2] i40e: avoid spin loop in i40e_asq_send_command()
Date:   Mon,  1 Nov 2021 11:38:08 -0600
Message-Id: <20211101173808.1735144-1-csander@purestorage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YXq3M5XvOkpMgiOg@cork>
References: <YXq3M5XvOkpMgiOg@cork>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the kernel could spend up to 250 ms waiting for a command to
be submitted to an admin queue. This function is also called in a loop,
e.g., in i40e_get_module_eeprom() (through i40e_aq_get_phy_register()),
so the time spent in the kernel may be even higher. We observed
scheduling delays of over 2 seconds in production,
with stacktraces pointing to this code as the culprit.

Use usleep_range() instead of udelay() so the loop can yield the CPU.
Also compute the elapsed time using the jiffies counter rather than
assuming udelay() waits exactly the time interval requested.

Signed-off-by: Caleb Sander <csander@purestorage.com>
Reviewed-by: Joern Engel <joern@purestorage.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Changed from v1:
Use usleep_range() instead of udelay() + cond_resched(),
to avoid using the CPU while waiting.
Use 50 us as the max for the range since hrtimers schedules the sleep
for the max (unless another timer interrupt occurs after the min).
Since checking if the command is done too frequently would waste time
context-switching, use half of the max (25 us) as the min for the range.

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 593912b17..b2c27ab3b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -902,7 +902,7 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 	 * we need to wait for desc write back
 	 */
 	if (!details->async && !details->postpone) {
-		u32 total_delay = 0;
+		unsigned long timeout_end = jiffies + usecs_to_jiffies(hw->aq.asq_cmd_timeout);
 
 		do {
 			/* AQ designers suggest use of head for better
@@ -910,9 +910,8 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 			 */
 			if (i40e_asq_done(hw))
 				break;
-			udelay(50);
-			total_delay += 50;
-		} while (total_delay < hw->aq.asq_cmd_timeout);
+			usleep_range(25, 50);
+		} while (time_before(jiffies, timeout_end));
 	}
 
 	/* if ready, copy the desc back to temp */
-- 
2.25.1

