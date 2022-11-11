Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98C625209
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiKKEAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiKKEAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:00:34 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F07F5D6B5;
        Thu, 10 Nov 2022 20:00:34 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j25-20020a056830015900b0066ca2cd96daso2202114otp.10;
        Thu, 10 Nov 2022 20:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0ZwMR2gCmjCo8DSne7eN5n31OgpWeA+QwMIe/AT+TA=;
        b=njrnJ9vyO0RH4SZFlia43XxDqyHL5yQxnEjslsS8ZZ3a5GZs+uHt38cWCH3yeLB2wP
         3/XRVO24mTH44oADo2t5CL0gWPmfoI+1xX+nsXxEzOcZCWJapa3feyvL1zMBcn0bfjeS
         MIWz2sU5ap00WIDTAreMJcGd5UOzPPb+kxriJiYygVjEgUhWgAIU+71bscSS3PWSbZYr
         3GfxqpbwHvbfHsN3ut6N4QyZa9WfrTgM5DWvoqgf1wggmuDGOkZhDKWSNU2SCMtQdzHX
         nBSQdVtvOkJbOdaY/zcvaIoD2BEs9xUJn/dukih3MTRNu7YHukem3oYf4vYzJR7Xaltg
         INzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0ZwMR2gCmjCo8DSne7eN5n31OgpWeA+QwMIe/AT+TA=;
        b=zmoINtjTZ3s1dTQxW/LtxClLUl6Y9dmCPtoIERnV4VydfvqYPlAnew8+nVbxiGneMp
         VohVPTWdoEH2UlIfzR5vtEUZ8hptg1O3VfYIZNjKJncQFlIw+G+U96KvaLy35+s+DAqf
         hsEaGUeBXizlNzDxqS3WFLd4p/IjM4ZnIhZBZ19e4E9ad0Cc9grOk8uopBN0On3RfoJk
         bgI1WTN3SGQTSThZ6DxpTEI/y9XBY14pI7TpfDdfGFwkljmhkLJdjDc1rswV29egBYgY
         qrHr8rWMGoSq3ulsV1JjgzbE/JACqStjJy7XuomMJqWCGNfFmjii0UyTq8G2gb7C6O63
         L//Q==
X-Gm-Message-State: ANoB5pn8vffOcsH3w5D7HYal/t2OtJPnpVIsx9JnX8GhvG61s5p2xWCh
        5aHmm0+ydWETnO8dK50ADII2QfXXuAY=
X-Google-Smtp-Source: AA0mqf5hhOqnQ/9iobOUUSORsscwhDEjIDe4SzmcDj3oM9x9Nk6CTns4GtZKJUoomiMp0nstW9oSJQ==
X-Received: by 2002:a05:6830:1212:b0:663:c55e:c5ac with SMTP id r18-20020a056830121200b00663c55ec5acmr374932otp.196.1668139233135;
        Thu, 10 Nov 2022 20:00:33 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id d74-20020a4a524d000000b0049052c66126sm471606oob.2.2022.11.10.20.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:00:32 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
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
Subject: [PATCH 2/4] cpumask: introduce cpumask_nth_and_andnot()
Date:   Thu, 10 Nov 2022 20:00:25 -0800
Message-Id: <20221111040027.621646-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111040027.621646-1-yury.norov@gmail.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
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

Introduce cpumask_nth_and_andnot() based on find_nth_and_andnot_bit().
It's used in the following patch to traverse cpumasks without storing
intermediate result in temporary cpumask.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c2aa0aa26b45..debfa2261569 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -391,6 +391,26 @@ unsigned int cpumask_nth_andnot(unsigned int cpu, const struct cpumask *srcp1,
 				nr_cpumask_bits, cpumask_check(cpu));
 }
 
+/**
+ * cpumask_nth_and_andnot - get the Nth cpu set in 1st and 2nd cpumask, and clear in 3rd.
+ * @srcp1: the cpumask pointer
+ * @srcp2: the cpumask pointer
+ * @srcp3: the cpumask pointer
+ * @cpu: the N'th cpu to find, starting from 0
+ *
+ * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ */
+static inline
+unsigned int cpumask_nth_and_andnot(unsigned int cpu, const struct cpumask *srcp1,
+							const struct cpumask *srcp2,
+							const struct cpumask *srcp3)
+{
+	return find_nth_and_andnot_bit(cpumask_bits(srcp1),
+					cpumask_bits(srcp2),
+					cpumask_bits(srcp3),
+					nr_cpumask_bits, cpumask_check(cpu));
+}
+
 #define CPU_BITS_NONE						\
 {								\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-1] = 0UL			\
-- 
2.34.1

