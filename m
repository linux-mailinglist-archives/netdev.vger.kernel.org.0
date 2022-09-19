Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C95E5BD616
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiISVGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiISVGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:19 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87318201A2;
        Mon, 19 Sep 2022 14:06:18 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1274ec87ad5so1361029fac.0;
        Mon, 19 Sep 2022 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=PaGTi8M5dY/2A2R9W9sSYECJnPcMh78ygGFvCU097mc=;
        b=Re8xlqSlDQVJLgMFuNLu3pRUrxl3Aj2FGVekiqV4X+hUycTLy0o7AoheeNKLixBGWc
         sQRhXNynE5Vu6SErWcskzSbTZEYf5MGkZ4UM9V15CXy+XRHRZiP5fVXmae8mt2/3WbgB
         S6qQbP7huAYRmwwMSYgDbNHS2fRyS/CtmfYZV6zA06Ax1X/MFAPNLZ65JL8sU3frGwUs
         7edZgloP1lQr0U7MMfwQ/B2WYN5PWkMNOte7+Be0zwUnoXtdwA8xM6CTM49WWCfIzM02
         5Y+EyZowyAM1NxxW+7Jhw7ZFL5vfOXMsxWNmE7wx2EYIVWGAmqlMbba2XMvvjGF/xnq5
         /sDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=PaGTi8M5dY/2A2R9W9sSYECJnPcMh78ygGFvCU097mc=;
        b=SYR4exYVnFcdFQBOTnH+uWIJydgcoDUMGThs7j6rN6U8Qb0z8LYvtLkkHTWtmh2ZWK
         OMkse3/n+HAxH5doSqp6TP4idYkvs3pKpjoDIZNTFhFvVIrDDzMsfX7UZDaVpyrejZxT
         h55ORXugQ3FDT3xWW/sDoXopOlV82ELN1ztbLHNo9khgEhxKXjLIbatM/RNd4BHMGPKV
         +byOkTmJzGQcoUjujnSwKqf/cbhT50/0b80e8OQggYPv+xG25jjldxjxFmAgMsUC/CNG
         OVneGI7LYC0UChUjdkI97DXbcxfZuqGPSmoWkvisxLBQ9bxOPY6ahh0gBVxjcWD4kV75
         Slng==
X-Gm-Message-State: ACrzQf37+xRopMD8FsmNEDLuBYJdyVfb8da19itkbrGS6D+fZtQySnWD
        XQJfXNLOkR+aozcqWJo3KHnpKx3q7Kk=
X-Google-Smtp-Source: AMsMyM57VvK3wmcusSoKCXI0U91XyI0ethAntOuPkk7aPr+7wwJOIooFRhvr4H4Z4zwQjFaAME/c/w==
X-Received: by 2002:a05:6871:294:b0:12d:1f91:3e75 with SMTP id i20-20020a056871029400b0012d1f913e75mr70360oae.142.1663621577605;
        Mon, 19 Sep 2022 14:06:17 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id h20-20020a9d6414000000b0061d31170573sm14676119otl.20.2022.09.19.14.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:17 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 0/7] cpumask: repair cpumask_check()
Date:   Mon, 19 Sep 2022 14:05:52 -0700
Message-Id: <20220919210559.1509179-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

After switching cpumask to use nr_cpu_ids in [1], cpumask_check() started
generating many false-positive warnings. There are some more issues with
the cpumask_check() that brake it.

This series fixes cpumask_check() mess and addresses most of the
false-positive warnings observed on boot of x86_64 and arm64.

[1] https://lore.kernel.org/lkml/20220905230820.3295223-4-yury.norov@gmail.com/T/

Yury Norov (7):
  cpumask: fix checking valid cpu range
  net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}
  cpumask: switch for_each_cpu{,_not} to use for_each_bit()
  lib/find_bit: add find_next{,_and}_bit_wrap
  lib/bitmap: introduce for_each_set_bit_wrap() macro
  lib/find: optimize for_each() macros
  lib/bitmap: add tests for for_each() iterators

 include/linux/cpumask.h   |  37 ++----
 include/linux/find.h      | 140 +++++++++++++++++-----
 include/linux/netdevice.h |  10 +-
 lib/cpumask.c             |  12 +-
 lib/test_bitmap.c         | 244 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 375 insertions(+), 68 deletions(-)

-- 
2.34.1

