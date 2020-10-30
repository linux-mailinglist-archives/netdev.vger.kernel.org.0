Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED60529FE4D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJ3HOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3HOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 03:14:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314DC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 00:14:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f38so4458340pgm.2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 00:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Nn37IfTCXj7OmHgyU0P/qf2aXP/R5yi/4Un5UCinwUE=;
        b=MJ4AKEXn7TirRPKSoWVdZOqbNugwSZWnOJSKdKoZwBvgJ2HvloooFF8TK6++IkvgR/
         LG3qbXpz+St1TZ8+d/VnMmvoAStv2CDgczOGUs2r11P8ViMcwHmgfRpj/wLW7hlo+TwC
         I+EuRT6mAu0aLtMGFtMtMoxEfM8ODh7OnnIb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Nn37IfTCXj7OmHgyU0P/qf2aXP/R5yi/4Un5UCinwUE=;
        b=rt+4ogFFbU5R76L0p+OZUPyFx9N8yqptLbfzpKg6OOWmqrPcwW5xn87tvEWZ5OIXtL
         urAbaN3yToAmDlLM1DOyQMLkFWFB3G2M1l/esSdomW/JlyQNIYFuFcYlLoN03NRkHjw9
         u6M1qqYdZlQ1keOgfjFCi6ntliYhMJ36KS1Cde9HJMglXJwB14gKRpJaDRrVqygDiofV
         U59wca4Q8onzkV88L4/7/syxVu/n0HvKO2PRIMJwi/9HC2FZm63nrR2DBfKDWAAM2hIg
         9ZUqrECwJQIr+IQxHMAGmfz/RRqk4nGzqrM0aMQ62JA46OsH90efI7zKx+IqpINLnIyb
         GeBg==
X-Gm-Message-State: AOAM5321+rEaM0hjz9UYMxA0+jyQapj7vj1soEEhHUnx7X4kvNE5H5+I
        pkMY89taMSbwduzeQOPPO3SQXg==
X-Google-Smtp-Source: ABdhPJyM76ixBnDtfwwg71qY1GdE0SSR1uXigQAvZciL/lMm6nMzKuHOPOTW2EhMHzsyMoq95V1IpA==
X-Received: by 2002:a17:90a:73c9:: with SMTP id n9mr1231337pjk.90.1604042085301;
        Fri, 30 Oct 2020 00:14:45 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id y203sm4996152pfb.70.2020.10.30.00.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 00:14:44 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i40e: Fix memory leak in i40e_probe
Date:   Fri, 30 Oct 2020 07:14:30 +0000
Message-Id: <20201030071431.10488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Struct i40e_veb is allocated in function i40e_setup_pf_switch, and
stored to an array field veb inside struct i40e_pf. However when
i40e_setup_misc_vector fails, this memory leaks.

Fix this by calling exit and teardown functions.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4f8a2154b93f..428964c4ade1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15104,6 +15104,8 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (err) {
 			dev_info(&pdev->dev,
 				 "setup of misc vector failed: %d\n", err);
+			i40e_cloud_filter_exit(pf);
+			i40e_fdir_teardown(pf);
 			goto err_vsis;
 		}
 	}
-- 
2.17.1

