Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DCA6763CA
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjAUEZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjAUEZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:25:09 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83E54119;
        Fri, 20 Jan 2023 20:24:50 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id jr19so4581282qtb.7;
        Fri, 20 Jan 2023 20:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+S0aKvtNtHji2MwhEJCerU5PDiGf8bD52pNGNrh5jes=;
        b=aMj8AEtUF7+dyhnay+QHtRZynp8reOr1WKixbCoxjKPgzn4RbIoBzC6ObzXVtimmCl
         gxeLz4Pf+NcsqI6ANdrOSokQ5PV2rFWyi8IuNdK/+325yIgghnbm2i35b/kBDRSzgU1E
         hHoJ9jiV//+RqlxtX18tN+85qBpVl9OTclfHDu7NSijv3lrX24mdNc0XJFldC/9B8tca
         zBY7y4R7i6JKiTNnPDjHxQrjyvvc8ob2w7rputsx8wrzgIZBWuhD3g764GOTseVURSl6
         jdS+kq++ChxJmCNbWH1lTil1mePsY0mHnURRwnCoJy8tBXKgFpWOPgYjOghP27CjLDfs
         erxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+S0aKvtNtHji2MwhEJCerU5PDiGf8bD52pNGNrh5jes=;
        b=DxEqhksqJBmykFmrTzAO9S/MGMNsFhlcA/beSpojMxfg40U1D9udDMQWqHYQccFT0X
         uBivr6yXtB2dmu4xG5z5ZVV4UvBQ+mJs3qWqi06EoOXfOYedUjFCQn3UPTAMW4ygRE35
         pHOStVX5ALLCExuaE9QrU3uLncm1k/EN86G1w9zxiRCkks+P/7rUfDxZaLCFHrN8CkS5
         /wsV1TEVgWbn4ltHXitN6pgjoxvQ4t8s9rtNjB3SuiM+PJxkd91PzOP7J/HMgUu+nbVb
         +KxA8RTx96CHoTt/gmIDWrvKbVDX/lCVGppUvBZgWdmlVEDzcV5bmt/54s2H2KvIa0fU
         pZQw==
X-Gm-Message-State: AFqh2kqRyITJn3BUYG3elXBx0DN/Hc4N2xhP3kV4UV/3+wgaOKKVNYbY
        XSBO3wcflJdacZ+HxSuwPIsCtA39sfo=
X-Google-Smtp-Source: AMrXdXtIv5QggoFAoBrhAWpQnUP/+5MgCRar/zhpHAxgG25dU29UxDfYodLxvFHa/bEwvKhOLpn4Sw==
X-Received: by 2002:ac8:6681:0:b0:3b6:3b1a:d028 with SMTP id d1-20020ac86681000000b003b63b1ad028mr22452427qtp.19.1674275089170;
        Fri, 20 Jan 2023 20:24:49 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id dt26-20020a05620a479a00b00705c8cce5dcsm16652425qkb.111.2023.01.20.20.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:48 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
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
Subject: [PATCH 7/9] sched/topology: Introduce for_each_numa_hop_mask()
Date:   Fri, 20 Jan 2023 20:24:34 -0800
Message-Id: <20230121042436.2661843-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
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

From: Valentin Schneider <vschneid@redhat.com>

The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
reachable within a given distance budget, wrap the logic for iterating over
all (distance, mask) values inside an iterator macro.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 344c2362755a..fea32377f7c7 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -261,4 +261,22 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
 }
 #endif	/* CONFIG_NUMA */
 
+/**
+ * for_each_numa_hop_mask - iterate over cpumasks of increasing NUMA distance
+ *                          from a given node.
+ * @mask: the iteration variable.
+ * @node: the NUMA node to start the search from.
+ *
+ * Requires rcu_lock to be held.
+ *
+ * Yields cpu_online_mask for @node == NUMA_NO_NODE.
+ */
+#define for_each_numa_hop_mask(mask, node)				       \
+	for (unsigned int __hops = 0;					       \
+	     mask = (node != NUMA_NO_NODE || __hops) ?			       \
+		     sched_numa_hop_mask(node, __hops) :		       \
+		     cpu_online_mask,					       \
+	     !IS_ERR_OR_NULL(mask);					       \
+	     __hops++)
+
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.34.1

