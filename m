Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05361181E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJ1Qvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiJ1Qvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:51:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC81176472
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666975834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5IEmsMn5Ai8kZg6GndigRvOK7uC/c82ztM+YMzpgCc8=;
        b=DlbW/7TwFwGvJrtQSWrcPfb/ICP7hM7C9++myUxZik4d025FoiHUg+4XDc8DZHRF6lISH3
        vtogUwVUbtx3KNH1SR6GtbFYxRnAt+mA7ysWNpLsy4I+vFojQJnxUQ8A+js7eWB8H4qwmt
        IZ2gh9anrGpetJkp+JQkhV5DdmXc238=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-Bh80HkeqPqqyEzKu7hPPFQ-1; Fri, 28 Oct 2022 12:50:33 -0400
X-MC-Unique: Bh80HkeqPqqyEzKu7hPPFQ-1
Received: by mail-wm1-f70.google.com with SMTP id p39-20020a05600c1da700b003cf608d10ccso862408wms.5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5IEmsMn5Ai8kZg6GndigRvOK7uC/c82ztM+YMzpgCc8=;
        b=dvojue/0RajaoWN0kuPGIReGNXq04rvvGlzYUYMrAztGs7jOA3gfHxJml6pZ1H84nB
         hSLbERRLfbwCqJdAbgTGkdMC+6JVm7sfatACaVprSZDf04MtN/ipn1HA7HK9OF7CPuhG
         vEaTPK0+Oh3qAvWE6KOsVd83jC9x28dXB6b9BArBGovmyvZ9Y++ereIKoPZfx79Cq0Cx
         Dm2wIon6mX4oedukrjYPHMSaZInZWe5ZKrRLBDa88+Q6+yCCjLepDVDH5/3Npbq+NqdZ
         9EpSigg2FOrsbiWoWOC+SGcngUji+pmynQwPszGItg72QZJZ669dmp4UnnBOLWFh2crS
         qcHg==
X-Gm-Message-State: ACrzQf1NUVr2hu0W5bPMu0TWnXr1ljoM3xG5qtQlOq6jyOPyUgIlAC96
        EzSjH7s8EpccSrRIoWL6O+HY1oDcQ4JPzpuWSBvNE4Mt+IHB0RpIbSklxaKSLoE505UCFbbAAU4
        VDNMUeubZVvj/CI4oDRcj7WYe2voxgHDeQd9y5ijK0gFMJsFGGvLBkroh8Qrn1lVqViLn
X-Received: by 2002:a05:600c:1987:b0:3c6:fd37:7776 with SMTP id t7-20020a05600c198700b003c6fd377776mr10502312wmq.72.1666975831988;
        Fri, 28 Oct 2022 09:50:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM74cuRyjaHCpA7r3paScYCbeat6QJjVC7nZ8pVMvM74YpYGxqg32Z6AhcfAnDGNtOCVL0MpSw==
X-Received: by 2002:a05:600c:1987:b0:3c6:fd37:7776 with SMTP id t7-20020a05600c198700b003c6fd377776mr10502268wmq.72.1666975831554;
        Fri, 28 Oct 2022 09:50:31 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id ay31-20020a05600c1e1f00b003cf537ec2efsm5065923wmb.36.2022.10.28.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:50:30 -0700 (PDT)
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
Subject: [PATCH v6 0/3] sched, net: NUMA-aware CPU spreading interface
Date:   Fri, 28 Oct 2022 17:49:56 +0100
Message-Id: <20221028164959.1367250-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
it).

The proposed interface involved an array of CPUs and a temporary cpumask, and
being my difficult self what I'm proposing here is an interface that doesn't
require any temporary storage other than some stack variables (at the cost of
one wild macro).

[1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/

Revisions
=========

v5 -> v6
++++++++

o Simplified iterator macro (Andy)
o Cleaned up sched_numa_hop_mask (Andy, Yury)
o Applied Yury's RB tags 

v4 -> v5
++++++++

o Rebased onto 6.1-rc1
o Ditched the CPU iterator, moved to a cpumask iterator (Yury)

v3 -> v4
++++++++

o Rebased on top of Yury's bitmap-for-next
o Added Tariq's mlx5e patch
o Made sched_numa_hop_mask() return cpu_online_mask for the NUMA_NO_NODE &&
  hops=0 case

v2 -> v3
++++++++

o Added for_each_cpu_and() and for_each_cpu_andnot() tests (Yury)
o New patches to fix issues raised by running the above

o New patch to use for_each_cpu_andnot() in sched/core.c (Yury)

v1 -> v2
++++++++

o Split _find_next_bit() @invert into @invert1 and @invert2 (Yury)
o Rebase onto v6.0-rc1

Cheers,
Valentin

Tariq Toukan (1):
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints

Valentin Schneider (2):
  sched/topology: Introduce sched_numa_hop_mask()
  sched/topology: Introduce for_each_numa_hop_mask()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 +++++++++--
 include/linux/topology.h                     | 27 +++++++++++++++++
 kernel/sched/topology.c                      | 32 ++++++++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

--
2.31.1

