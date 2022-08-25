Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3A5A1884
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiHYSNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243297AbiHYSMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34864BB924
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661451169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fi5a4KAJqfy3ci33ccYmogCkY8ciHV2wHDw8LNbyax8=;
        b=H8dNzrIddSnqYvhnE8FM6wxIdi82gDs4QYgLoQAAavNEgk/rYfvPZXfNEdoNXrK1zvwqmr
        2iPJQucd8f1pMICkSt5pXA8xsOyugWlmNqvtGpBS6FQ15Wr5EaTLH/KLyFHQHpyzGP5y7s
        ItHyKc9cEEn+pAkFYA2S8NO0q6YdTlA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-j7j06pvjP0K5YxDzIBmiHg-1; Thu, 25 Aug 2022 14:12:47 -0400
X-MC-Unique: j7j06pvjP0K5YxDzIBmiHg-1
Received: by mail-wr1-f70.google.com with SMTP id q19-20020adfab13000000b0022588ea1182so119920wrc.20
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=fi5a4KAJqfy3ci33ccYmogCkY8ciHV2wHDw8LNbyax8=;
        b=NGq67cesYHhvA7Y4+Rn61j/PiGr1USfiiV4yxwkI5J/N8DDW5xbLHJXQbOI0u/u5R8
         fEwDI6Pafcta3GFE6DohGP05iqxPEsDhcAAXYH63KWTPrZ7l89K5qJiEMBsFLZE80jhs
         JVn5+RWEq9xB6I61sqSVqqi2j7Beh7yUX02lL1isto4ZQ9J0pAfV9Een9uIo8oHcc2ct
         8lt42relp+lYKCx+YiD168x9oajQh2C39JIMegX1fbPBtKh5/F7Zo0x7mL3jigJgeNmz
         m3T7wJ8OdYlytHUsUiFe8sZytnee928rgYumzERGVn5g9ua1kGq7UNV8nty67gP7IFnh
         GCOg==
X-Gm-Message-State: ACgBeo3mbGojPJcS1AiILWtgJk7PS0n5crICHO/Y+s8w6CuropBc9FYe
        TKs686GxtPXiQum6RCIwWWCCkH2Ohg3B0sHA0jdEfSOxaedUf4V+ErakgBp/AToTvoEgsCwIOa2
        XgCTUenXSeOvj1Nm97FwPMoNEsfHoHUG2AqR2UT8HXW2W7cBlhbOwKYRhbCinB/6Zr1L9
X-Received: by 2002:a05:600c:216:b0:3a6:60e1:2726 with SMTP id 22-20020a05600c021600b003a660e12726mr2944921wmi.182.1661451166443;
        Thu, 25 Aug 2022 11:12:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4/nJYROvYiQ2IAfhO3CgdBZ6m1FiBVpd031oI0fdbvWUxPIJUgnQVz/WpVzsga42+sehCrlg==
X-Received: by 2002:a05:600c:216:b0:3a6:60e1:2726 with SMTP id 22-20020a05600c021600b003a660e12726mr2944883wmi.182.1661451166173;
        Thu, 25 Aug 2022 11:12:46 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id w1-20020a05600018c100b00225250f2d1bsm20371622wrq.94.2022.08.25.11.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:12:45 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
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
Subject: [PATCH v3 5/9] lib/test_cpumask: Add for_each_cpu_and(not) tests
Date:   Thu, 25 Aug 2022 19:12:06 +0100
Message-Id: <20220825181210.284283-6-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220825181210.284283-1-vschneid@redhat.com>
References: <20220825181210.284283-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the recent introduction of for_each_andnot(), add some tests to
ensure for_each_cpu_and(not) results in the same as iterating over the
result of cpumask_and(not)().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 lib/test_cpumask.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/test_cpumask.c b/lib/test_cpumask.c
index 81b17563fcb3..62d499394d8a 100644
--- a/lib/test_cpumask.c
+++ b/lib/test_cpumask.c
@@ -29,6 +29,19 @@
 		KUNIT_EXPECT_EQ((test), nr_cpu_ids - mask_weight, iter);	\
 	} while (0)
 
+#define EXPECT_FOR_EACH_CPU_OP_EQ(test, op, mask1, mask2)			\
+	do {									\
+		const cpumask_t *m1 = (mask1);					\
+		const cpumask_t *m2 = (mask2);					\
+		int weight;                                                     \
+		int cpu, iter = 0;						\
+		cpumask_##op(&mask_tmp, m1, m2);                                \
+		weight = cpumask_weight(&mask_tmp);				\
+		for_each_cpu_##op(cpu, mask1, mask2)				\
+			iter++;							\
+		KUNIT_EXPECT_EQ((test), weight, iter);				\
+	} while (0)
+
 #define EXPECT_FOR_EACH_CPU_WRAP_EQ(test, mask)			\
 	do {							\
 		const cpumask_t *m = (mask);			\
@@ -50,6 +63,7 @@
 
 static cpumask_t mask_empty;
 static cpumask_t mask_all;
+static cpumask_t mask_tmp;
 
 static void test_cpumask_weight(struct kunit *test)
 {
@@ -91,10 +105,15 @@ static void test_cpumask_iterators(struct kunit *test)
 	EXPECT_FOR_EACH_CPU_EQ(test, &mask_empty);
 	EXPECT_FOR_EACH_CPU_NOT_EQ(test, &mask_empty);
 	EXPECT_FOR_EACH_CPU_WRAP_EQ(test, &mask_empty);
+	EXPECT_FOR_EACH_CPU_OP_EQ(test, and, &mask_empty, &mask_empty);
+	EXPECT_FOR_EACH_CPU_OP_EQ(test, and, cpu_possible_mask, &mask_empty);
+	EXPECT_FOR_EACH_CPU_OP_EQ(test, andnot, &mask_empty, &mask_empty);
 
 	EXPECT_FOR_EACH_CPU_EQ(test, cpu_possible_mask);
 	EXPECT_FOR_EACH_CPU_NOT_EQ(test, cpu_possible_mask);
 	EXPECT_FOR_EACH_CPU_WRAP_EQ(test, cpu_possible_mask);
+	EXPECT_FOR_EACH_CPU_OP_EQ(test, and, cpu_possible_mask, cpu_possible_mask);
+	EXPECT_FOR_EACH_CPU_OP_EQ(test, andnot, cpu_possible_mask, &mask_empty);
 }
 
 static void test_cpumask_iterators_builtin(struct kunit *test)
-- 
2.31.1

