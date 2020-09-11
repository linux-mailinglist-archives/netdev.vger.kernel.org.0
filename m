Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF532265F3E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgIKMJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgIKMIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:08:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34184C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:08:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so1604579pjr.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TqSpkfkr+tMBwaFyw5XAodcnlGsbsIbSn3rKcAsTlj4=;
        b=mOJfnuHGe/MCToZH9wkaVfhM5iXwRb17dVqfFWfoVBYqa6TM6qXYurdkH8Vqe1S8nx
         FY6Ka0JvVKwKFH4H0kcM0GvYZJGzk/eIZb6s2ScwN+CnszfaONVg+2wc6bK+R7Y7JKp5
         TL5+RDKQK/HLc5bsMXfJ8zgBMTJLA5uTmLu7WU9dsD/fpmGmuj+rG3XtRv2vUGY4pb3C
         iJPmPOnzFHd1Q//1DUdsQLhgZ5F93VGEyvaoj7CXi7RYAC9cfAE9nRV2bNJ8fBYt0rjn
         n5PbDnqOJx4bbwKsdJf2ygE5gb2ev2x+45ARg4KGW4NR1Ix26slAzd6TUoK0OF2+xnOA
         YsWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TqSpkfkr+tMBwaFyw5XAodcnlGsbsIbSn3rKcAsTlj4=;
        b=I1JKhA69xZ8ZIv/5v2zedYumhrM8W7RGB0asizEvlzLQf+IovJPJhspvFSAX6Wmlrq
         1xMBM4ngetNgOmamRcFlFWPkTwqjyQOzib2iLQL6SckQJ9ojoCW3jkoGIRsxodVsoqB6
         WXR8don9GkPV3HG3nb4pIoljLjcQ1PeQ88pKTy4ceoM2gyRKioSWswGDtmfdkCp1r7RN
         lPMdyqjBvCGGEH55qE98nMgjjm7qcno8ABiS6RnCvuGkf1WJo/XU8C1j7BX/vtpT6RgS
         A1LyW/lK7UmJQUP89Q1A3Zo5bMSaTy67tLH4IKXu1CcCX97U16wWJJX5qyTfyVa16gQ4
         geZw==
X-Gm-Message-State: AOAM5328fUV/9NZylTBnWCU7g5utl8VZl2SzkT6hIrPrQIOLO/t9fDGl
        Pi9eSrPNDhRpeK12RZM/amQ=
X-Google-Smtp-Source: ABdhPJxU6Hzk/eEPghef+A/tc7PbZOHogU9xSD8f9jKwHoQAvo8+jcBdodG/eCLN/NWXKsTH3X1QDw==
X-Received: by 2002:a17:90b:70e:: with SMTP id s14mr2105179pjz.206.1599826118580;
        Fri, 11 Sep 2020 05:08:38 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id a3sm2239279pfl.213.2020.09.11.05.08.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 05:08:37 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH net-next] i40e: allow VMDQs to be used with AF_XDP zero-copy
Date:   Fri, 11 Sep 2020 14:08:26 +0200
Message-Id: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
reason, we only allowed main VSIs to be used with zero-copy, but
there is now reason to not allow VMDQs also.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2a1153d..ebe15ca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -45,7 +45,7 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
 	bool if_running;
 	int err;
 
-	if (vsi->type != I40E_VSI_MAIN)
+	if (!(vsi->type == I40E_VSI_MAIN || vsi->type == I40E_VSI_VMDQ2))
 		return -EINVAL;
 
 	if (qid >= vsi->num_queue_pairs)
-- 
2.7.4

