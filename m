Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848B364759A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLHSba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLHSbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:14 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2D6AE4CA;
        Thu,  8 Dec 2022 10:31:12 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-14455716674so2807284fac.7;
        Thu, 08 Dec 2022 10:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0/IgShbjb7qZAYWczuxoDmDyDdccuNPQ9P2AVi15HY=;
        b=lOxPMsbFDjwHG7HHR/orp+Pa1RS39Ze8na4rbdhPw189WP/MM4eBBehW1SZExmZPxq
         tiJirumWDNQOl3hPWfZpEdC3kT/L0/8Iw3MPpHUq36+mlsJIJ3NErF0CyEoEk24teAvb
         jv8iIoRKaccmPycGlitSJg/uRywRLWiunQxdbZNNXpBEWYpcieBXXwn8Sc/mwlKRGSzx
         8wZo5ds/TIytpQjbzsy5F2LPl0IQFPVHI73htiuJVtdt5VQT1ZP2shA9/xBeLI67XWSt
         19tRLmVoMARQt7scuWD50mPic1sJvH3poXZ9vPehyb0eRK+UXa0cZyII2ssgPYKNiwVG
         nNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0/IgShbjb7qZAYWczuxoDmDyDdccuNPQ9P2AVi15HY=;
        b=KvNdyOpxI2fnsWBIpd2tUzLilvh8efd9M47MLT0A0YBdFcGPKHVTzyaNkGCxtB6j73
         NB2P/WR350FJI002dV3+uGPLBaLF2zwq5xKYrt7VdtzJ9EyzGyx8whdXFMbyjvnmAPa9
         ZLmAhHZLwv8XfxO40cJ/HlPGD4H7Ggdo1gnyGP6Gb05dAjSfipW19AOxiTHg26NIauQU
         MEHqvFAHUiJkobCC7H9MTYE3V92czGhfP4/RKRKM7/sqREh05tXSe5OuiXObS7E9YW+y
         tJVXIQJMWMBODC4X2erNQlKhP6V8SJyUmN2Y8NC1ILvaxluErgk0HSKtOwBTpozBYKv2
         ZCow==
X-Gm-Message-State: ANoB5pnAG1L2fFX5vJVkjxfPmwYIPPPtF8bxhE+neFJWSFnFazezmOUz
        L3CtvSg7Sgy0h3A/cbdra+KfalIcY+s=
X-Google-Smtp-Source: AA0mqf5isVkvLJVjOx5VBCgzSb+tYVQchORCS9bPkl13W6aETbe07HI49CIJpRycmeydxnnPPM4t5g==
X-Received: by 2002:a05:6871:4683:b0:137:3ada:7249 with SMTP id ni3-20020a056871468300b001373ada7249mr1586685oab.54.1670524271939;
        Thu, 08 Dec 2022 10:31:11 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id m24-20020a056870a11800b001447d74a58esm8451783oae.8.2022.12.08.10.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:11 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v3 4/5] cpumask: improve on cpumask_local_spread() locality
Date:   Thu,  8 Dec 2022 10:31:00 -0800
Message-Id: <20221208183101.1162006-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch cpumask_local_spread() to use newly added sched_numa_find_nth_cpu(),
which takes into account distances to each node in the system.

For the following NUMA configuration:

root@debian:~# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3
node 0 size: 3869 MB
node 0 free: 3740 MB
node 1 cpus: 4 5
node 1 size: 1969 MB
node 1 free: 1937 MB
node 2 cpus: 6 7
node 2 size: 1967 MB
node 2 free: 1873 MB
node 3 cpus: 8 9 10 11 12 13 14 15
node 3 size: 7842 MB
node 3 free: 7723 MB
node distances:
node   0   1   2   3
  0:  10  50  30  70
  1:  50  10  70  30
  2:  30  70  10  50
  3:  70  30  50  10

The new cpumask_local_spread() traverses cpus for each node like this:

node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index c7c392514fd3..255974cd6734 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -110,7 +110,7 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 #endif
 
 /**
- * cpumask_local_spread - select the i'th cpu with local numa cpu's first
+ * cpumask_local_spread - select the i'th cpu based on NUMA distances
  * @i: index number
  * @node: local numa_node
  *
@@ -132,15 +132,7 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
 		if (cpu < nr_cpu_ids)
 			return cpu;
 	} else {
-		/* NUMA first. */
-		cpu = cpumask_nth_and(i, cpu_online_mask, cpumask_of_node(node));
-		if (cpu < nr_cpu_ids)
-			return cpu;
-
-		i -= cpumask_weight_and(cpu_online_mask, cpumask_of_node(node));
-
-		/* Skip NUMA nodes, done above. */
-		cpu = cpumask_nth_andnot(i, cpu_online_mask, cpumask_of_node(node));
+		cpu = sched_numa_find_nth_cpu(cpu_online_mask, i, node);
 		if (cpu < nr_cpu_ids)
 			return cpu;
 	}
-- 
2.34.1

