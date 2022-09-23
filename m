Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE25E7F12
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiIWP4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiIWP4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A320147690
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663948565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9qKy0mrwb1ZaeVcnoJdtpT0vU2IyZpITeq2cNcv3elU=;
        b=gBI40lKtBheAci7zIAXaOUahoGVyplMcEB0D5+qonNBpQBK2ApyRThh1VJ5XokQ2QQTGmX
        /onOGk2Mw9W5h+5dUMNVO0GEcvZi70SODlCBSbNJ5j5+gZCl5K7IJDjUlkuqnAgjl+Ssc5
        eslQv5Xzj9aNw35Iqk2fLD8WdKSOgyA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-vbFzA41POcSOWbvNRoiM-g-1; Fri, 23 Sep 2022 11:56:04 -0400
X-MC-Unique: vbFzA41POcSOWbvNRoiM-g-1
Received: by mail-wr1-f70.google.com with SMTP id u27-20020adfa19b000000b0022863c08ac4so116797wru.11
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9qKy0mrwb1ZaeVcnoJdtpT0vU2IyZpITeq2cNcv3elU=;
        b=jiYLGSAMqzrqoEbz2sEZ48C8B4yQLxiqA9tyrvjE15TSZPizAaxEH5q9azJFW6DOVo
         ee8XZnNOrI5GXvw60zRvu53URjaIui8ROMUs+5W8WevEROkjESzRYUyU8wU1Wc0c96xO
         GuTY1BOO6EjKQBOIrHmCtC9344WTMpHJMJbuIw/rFjKBkyHoEEt/pf1DXfqinaLh3XCD
         k0JCKU1HieG4hzHzsId4JYqyl2xg95+JI3X0frznfFqpl2VhH0V8yAQ6V0dQFSWdBwew
         I7R79c2w2ep08vgw9TLr5yylZEbBLY3LxfpfnbXGFRWWvxmaXekOCB8ayqAjmOB9Ewm0
         Yz4Q==
X-Gm-Message-State: ACrzQf2RrXrLAANaF67Kvb/HKOx3S3IEC3CuEumNUQKkdEgbqXRXtKkW
        cwmIgWucb2/AQxD+pw2I5C+d0tta8R6z/qadujTfK/3D43uw8ulaPiS9XRukMzu0Dn+LEJKt0aU
        Ws9wPg0zL45QVfxTPQBGueHdcfZjgpkhIZOPyG7BjAi3NoxNKjQtS0CJMU0kCSaRwjyx0
X-Received: by 2002:a5d:62c8:0:b0:228:67d2:797b with SMTP id o8-20020a5d62c8000000b0022867d2797bmr5570935wrv.462.1663948562662;
        Fri, 23 Sep 2022 08:56:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4aPbc4vrsR5Vfq6YATZvPVX52Oz7CjIB9xYibgKcC2wNByVZXJ2pv9DnxuyPBkjc5vbnX2Bw==
X-Received: by 2002:a5d:62c8:0:b0:228:67d2:797b with SMTP id o8-20020a5d62c8000000b0022867d2797bmr5570899wrv.462.1663948562369;
        Fri, 23 Sep 2022 08:56:02 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b0021badf3cb26sm9055429wrv.63.2022.09.23.08.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:56:01 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v4 4/7] sched/core: Merge cpumask_andnot()+for_each_cpu() into for_each_cpu_andnot()
Date:   Fri, 23 Sep 2022 16:55:39 +0100
Message-Id: <20220923155542.1212814-3-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
References: <20220923132527.1001870-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the second use of the sched_core_mask temporary mask.

Suggested-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee28253c9ac0..b4c3112b0095 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -360,10 +360,7 @@ static void __sched_core_flip(bool enabled)
 	/*
 	 * Toggle the offline CPUs.
 	 */
-	cpumask_copy(&sched_core_mask, cpu_possible_mask);
-	cpumask_andnot(&sched_core_mask, &sched_core_mask, cpu_online_mask);
-
-	for_each_cpu(cpu, &sched_core_mask)
+	for_each_cpu_andnot(cpu, cpu_possible_mask, cpu_online_mask)
 		cpu_rq(cpu)->core_enabled = enabled;
 
 	cpus_read_unlock();
-- 
2.31.1

