Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7C597573
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbiHQR6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbiHQR6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D16B2AC6B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660759110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dgGyeroL7nQdNp4tnXnxYdnkM2nPtV/937q52s3gCa4=;
        b=RhR0jGn6wHw9glfYy7LT/K2MF0riFcs5550XODkEOUO2V1BZVGKgNdUbsZeOWnAinflNo1
        Vt3ohP77KCNtoE7tsLuIEQKBtzOQ3qumGflHI1DpQIIcekLQDKFSwwSOao/ENDtogka+q+
        zwoQeoQq+bF3adtSubYcHGQ3vPU2doo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-47-_QecKJOQMQqE-PSWmJPf2g-1; Wed, 17 Aug 2022 13:58:27 -0400
X-MC-Unique: _QecKJOQMQqE-PSWmJPf2g-1
Received: by mail-wm1-f70.google.com with SMTP id 203-20020a1c02d4000000b003a5f5bce876so1398965wmc.2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=dgGyeroL7nQdNp4tnXnxYdnkM2nPtV/937q52s3gCa4=;
        b=mrfe94JOCwRbDZcVnhJdsMiOjxEqdeVmKoJBhJ5ODwEQoYrCsWG3kwi9zwavpG2BH/
         aexNIZUquvKTg8DjSbz//iYPeK4Lgpve8uyMLHcvImQhdxuyar3TtAyLvIC2dfBIYhQn
         tXw153eZZtAcGA9EG/MKi7ZpoELoyzZvDY/PK6AgmcPO91FWHTcESAoKj3J5poNtaK12
         7QvbjLuIUya+6y75ou/ERq5vESz4qQ5JF7cF4jJkgzHTDjipqz70h/6jkJ/5muvripX6
         boHK1CaMqdC76LW3xsbQSbvCgPis7kI05sWRn5sl1zYTxoMUdI4YxF4jU64Y932UTmMo
         1Mlw==
X-Gm-Message-State: ACgBeo2CRLr0YF9tZadhZkn0cs+YlXCMkFcLjk/em1MV7GVoLoW+YQTj
        2nsHiUSiDhdyPrzkX13elQOE8hNejXLvf8MTtIsW3wJzSzldrkwC8LJ4vuzfh93MEsDI2kZXqsw
        s/6icgrdWwbDH84zkG6dLR5s8Gfze/o+VNmEyrYIB8cpHFcv8MKdhWGMkLbOfBupb5UoM
X-Received: by 2002:a1c:7c18:0:b0:3a5:aaae:d203 with SMTP id x24-20020a1c7c18000000b003a5aaaed203mr2944207wmc.2.1660759106126;
        Wed, 17 Aug 2022 10:58:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6BuvGaPt3Y8Uq9xyqFkwCoOJ0UWHYzIzHfPTHj9ADsoXRbGLYtizHhA+vtJ3TFF0VSU9wZjQ==
X-Received: by 2002:a1c:7c18:0:b0:3a5:aaae:d203 with SMTP id x24-20020a1c7c18000000b003a5aaaed203mr2944172wmc.2.1660759105855;
        Wed, 17 Aug 2022 10:58:25 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id u8-20020a05600c19c800b003a541d893desm2809009wmq.38.2022.08.17.10.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:58:25 -0700 (PDT)
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH v2 2/5] cpumask: Introduce for_each_cpu_andnot()
Date:   Wed, 17 Aug 2022 18:58:09 +0100
Message-Id: <20220817175812.671843-3-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220817175812.671843-1-vschneid@redhat.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for_each_cpu_and() is very convenient as it saves having to allocate a
temporary cpumask to store the result of cpumask_and(). The same issue
applies to cpumask_andnot() which doesn't actually need temporary storage
for iteration purposes.

Following what has been done for for_each_cpu_and(), introduce
for_each_cpu_andnot().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/cpumask.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0d435d0edbcb..295b137717bb 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -237,6 +237,25 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
 		nr_cpumask_bits, n + 1);
 }
 
+/**
+ * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @src1p: the first cpumask pointer
+ * @src2p: the second cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set in *src1p & ~*src2p
+ */
+static inline
+unsigned int cpumask_next_andnot(int n, const struct cpumask *src1p,
+				 const struct cpumask *src2p)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
+		nr_cpumask_bits, n + 1);
+}
+
 /**
  * for_each_cpu - iterate over every cpu in a mask
  * @cpu: the (optionally unsigned) integer iterator
@@ -297,6 +316,25 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
 		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
 		(cpu) < nr_cpu_ids;)
 
+/**
+ * for_each_cpu_andnot - iterate over every cpu in one mask but not in the other
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_andnot(&tmp, &mask1, &mask2);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_andnot(cpu, mask1, mask2)				\
+	for ((cpu) = -1;						\
+		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
+		(cpu) < nr_cpu_ids;)
+
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
  * @mask: the cpumask to search
-- 
2.31.1

