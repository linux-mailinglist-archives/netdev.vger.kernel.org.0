Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B51F5A1889
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243324AbiHYSMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243229AbiHYSMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B9F74CD8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661451164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa7TgxIpu/jW/iqd5xTwDqe/1bK1e/1x+Xly3SMXIUI=;
        b=et1HTKQhDLL+2LCJmI26o4krfTPy3HDhyDjk5q3CUzKF7Y0y24u46ZgqqHVhAZ5or3y9SU
        9iIUl/oUhHzmM5KzMkG1xK90XYdUY7W7sefQfqeTmK0zluhFmb8fu1ERjXIpns+SZQkhKu
        RBKJ9J7DjpsDq0W79Kt+ZgrF+5ErbSg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-382-6HClr6fCMJuXANS3eOpDHQ-1; Thu, 25 Aug 2022 14:12:43 -0400
X-MC-Unique: 6HClr6fCMJuXANS3eOpDHQ-1
Received: by mail-wm1-f72.google.com with SMTP id ay21-20020a05600c1e1500b003a6271a9718so10982009wmb.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aa7TgxIpu/jW/iqd5xTwDqe/1bK1e/1x+Xly3SMXIUI=;
        b=0Cy4ezCS5cd+kxuP2ojQnaoBiiYjlfGwcpuIZELsHCW3+DTinTxQ/TQEn/4orEdM+9
         YPfBAIHOJAtDiSnBqkt7wBwrgYOVoFwVF6nWff1vEw/SeuvXTv8YbepPjseHOKSImshS
         BE73SqrHP8fX2FZqPxRT4jhJmqvKBxp7S/e0MifGa3tgViDyKt/+luhxKAcCltGV/bMb
         LvSEnAKBr0FUQlyaVesL0VjI2LE7fUMftWmj55NBfHXvVm8f8fkq0YREHo/fSC9GzQMT
         i3Mu/VccLJAKdPAnKdS7fvsQtfnbOfxSDi46K3PvHF6dgq0QR/Jd5YXYBwoX+xFqnPz3
         EDlw==
X-Gm-Message-State: ACgBeo26HalGHa0tQqebQTFqIeDtE9069CKiqdODtdlb742m0uHmJzSC
        M31C9cIsAd9d3Jz1yT13lXV55BALw+Bx9e0gdlEZvyjieuFmKghQoyOlyGS3sZ5po15EwzI29G/
        2IJhZ9pooURllw458U6/64fMrOIpEaByYLZT8t2KwKZAR2oatJ6qUWMtOLQtu4Ur61J+1
X-Received: by 2002:a05:6000:1f9b:b0:225:7694:3b36 with SMTP id bw27-20020a0560001f9b00b0022576943b36mr3024145wrb.310.1661451162052;
        Thu, 25 Aug 2022 11:12:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR48+XemZLeoI5/0hKjHm0hpojsmml99HpqQqzINgCYNPX/9v3T9th/wzQI0CY0AzciHT6w5pQ==
X-Received: by 2002:a05:6000:1f9b:b0:225:7694:3b36 with SMTP id bw27-20020a0560001f9b00b0022576943b36mr3024110wrb.310.1661451161782;
        Thu, 25 Aug 2022 11:12:41 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id w1-20020a05600018c100b00225250f2d1bsm20371622wrq.94.2022.08.25.11.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:12:41 -0700 (PDT)
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
Subject: [PATCH v3 2/9] lib/test_cpumask: Make test_cpumask_last check for nr_cpu_ids bits
Date:   Thu, 25 Aug 2022 19:12:03 +0100
Message-Id: <20220825181210.284283-3-vschneid@redhat.com>
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

test_cpumask_last() currently fails on a system with
  CONFIG_NR_CPUS=64
  CONFIG_CPUMASK_OFFSTACK=n
  nr_cpu_ids < NR_CPUS

  [   14.088853]     # test_cpumask_last: EXPECTATION FAILED at lib/test_cpumask.c:77
  [   14.088853]     Expected ((unsigned int)64) - 1 == cpumask_last(((const struct cpumask *)&__cpu_possible_mask)), but
  [   14.088853]         ((unsigned int)64) - 1 == 63
  [   14.088853]         cpumask_last(((const struct cpumask *)&__cpu_possible_mask)) == 3
  [   14.090435]     not ok 3 - test_cpumask_last

Per smp.c::setup_nr_cpu_ids(), nr_cpu_ids <= NR_CPUS, so we want
the test to use nr_cpu_ids rather than nr_cpumask_bits.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 lib/test_cpumask.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_cpumask.c b/lib/test_cpumask.c
index a31a1622f1f6..81b17563fcb3 100644
--- a/lib/test_cpumask.c
+++ b/lib/test_cpumask.c
@@ -73,8 +73,8 @@ static void test_cpumask_first(struct kunit *test)
 
 static void test_cpumask_last(struct kunit *test)
 {
-	KUNIT_EXPECT_LE(test, nr_cpumask_bits, cpumask_last(&mask_empty));
-	KUNIT_EXPECT_EQ(test, nr_cpumask_bits - 1, cpumask_last(cpu_possible_mask));
+	KUNIT_EXPECT_LE(test, nr_cpu_ids, cpumask_last(&mask_empty));
+	KUNIT_EXPECT_EQ(test, nr_cpu_ids - 1, cpumask_last(cpu_possible_mask));
 }
 
 static void test_cpumask_next(struct kunit *test)
-- 
2.31.1

