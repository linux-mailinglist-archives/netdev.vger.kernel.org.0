Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40A96C9043
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjCYSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCYSzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:41 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A38A5C7;
        Sat, 25 Mar 2023 11:55:32 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso2575774oti.8;
        Sat, 25 Mar 2023 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nw654FlL6BUkwfjkIWsvpLLmEwiZB7gH0V0i7mwVLn0=;
        b=O1buRl+cXmYERNkRa0ViEqjRktK0lKq/t2aF9T4kvfbdzLOs2G2FMrZfOJpEwOmVm9
         ygQ7msCswMXwobgozy+6WU4IIKcbGgsOqgKuW9dV5o5O6dz5cv5fsqbqy736hDqPGrJQ
         V03JGH4t+X0umsDBujNZQqdbluFXRNGWjFYk1xcn7/ha0fJwdPHx6HTsIhxeO59BKht8
         K7VE57ykrSjN2E+dvYFs4HL/+Dy51s2BANZ9ynav/+F6pZh2JiCVvzVnTC1SGF3wZWl4
         ucqjqCW/MleYRGKEG6Sv2T3Q4EF9f3OzSVFGcgudsrRYEKAkaSFrKYawYzLSctFU6orh
         it/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nw654FlL6BUkwfjkIWsvpLLmEwiZB7gH0V0i7mwVLn0=;
        b=3wLyCFmyHwkOVFTnzCD3oiKN1K3ZxXoz+lA/kDe1MKN8b6LZrbjWlLW3HVYtNzHJJ0
         4RttYxQfKGUruFa7dnddCHwSjKDS1Iic2Pl0M1w9iRpNcO/znIfU1vwx0WzCHfejrF0c
         CLlYq6eSEmwb6oMnZr+anQphI/jg3di9bo6zeUChMo3LDsY3qdBhhDduCcpZjKd+2eo1
         sO8w4tw6VysYQg1vUhAOFVQEKZHC/eVbJNDdCOBNAWi2NYLIrLC3z4RYjeZwkyx717kN
         tryLqxDBEiPRSMBlF4TJQzdP4ntys2tT3w5mcu1EBYhj2/grDBYjzvIQMnQtl91VINEp
         kHlw==
X-Gm-Message-State: AO0yUKX0Ex9Z/oUnH2Jn3OrRjWvP6jAR1XLLlG2tiX0Y1WbOqmUEG9+m
        QeHtpedd60mYmWZlGPdKgqZtSGC3UJg=
X-Google-Smtp-Source: AKy350bbVge6O+ZrE66CYpJHZxTFYDlodaHyMXDOk2H7td8SOsTnBloo26Jkw5VuqZ+c1NmzWl5WVw==
X-Received: by 2002:a05:6830:1e1a:b0:69f:8d0f:9a1e with SMTP id s26-20020a0568301e1a00b0069f8d0f9a1emr3623870otr.7.1679770531267;
        Sat, 25 Mar 2023 11:55:31 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id m2-20020a9d6442000000b0069f0a85fa36sm8532359otl.57.2023.03.25.11.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:30 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH 5/8] lib/cpumask: update comment to cpumask_local_spread()
Date:   Sat, 25 Mar 2023 11:55:11 -0700
Message-Id: <20230325185514.425745-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a for_each_numa_cpu(), which is a more straightforward
replacement to the cpumask_local_spread() when it comes to enumeration
of CPUs with respect to NUMA topology, it's worth to update the comment.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index e7258836b60b..151d1dc5c593 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -127,11 +127,8 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
  *
  * There's a better alternative based on for_each()-like iterators:
  *
- *	for_each_numa_hop_mask(mask, node) {
- *		for_each_cpu_andnot(cpu, mask, prev)
- *			do_something(cpu);
- *		prev = mask;
- *	}
+ *	for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
+ *		do_something(cpu);
  *
  * It's simpler and more verbose than above. Complexity of iterator-based
  * enumeration is O(sched_domains_numa_levels * nr_cpu_ids), while
-- 
2.34.1

