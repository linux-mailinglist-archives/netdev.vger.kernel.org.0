Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904AA6BAE7D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCOLGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjCOLGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C66A81CF3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so903949wmb.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VME+gjh0d5gcUzQ/4/yTVHRFQqbeb0I6uXkmSQVYdck=;
        b=y1p8f9fSZ5GldLZO13/jCyaGxr9iYN3yNt9HY5orx+tdDY2NajDm735zQxnh0UqwyW
         BasgUBmc5cDrnfeHxyj+9oadP5vwWfEVC6weyJWlMps0yE8bqEVHXR5w5UOUBOOPO01l
         tLAKkLwOAIt36rO1JwkgIPa+he9J/+2mm1cpF9QAIZonCj8zOrkGm5bWvfdD4Ah5Uy17
         FYIF04G62XKwUeantYO6yd693wsP5dAUdrxZFfQrsqNcCWFXLHiLS+uuT0+ceA8ckjhG
         lZbRQeQn9Gz2pXInF9eCSqmFnM97GgbeYCpn3xI+vHQRhryxxVmZVAtsENVKirQLfI/6
         WIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VME+gjh0d5gcUzQ/4/yTVHRFQqbeb0I6uXkmSQVYdck=;
        b=hYClDMq0zQMBfgr3Y3ztx3TeOtvt0Ky8VOZe2d5XzBr8OZy76yB6bITU45unis1cWL
         x5nmXRZQVxjixxxTskfkfFeIjlN9XWzjwLU6lGCEXU1AVDB1/sqQLXM8ij/CHihn6oRb
         cgbRldU0qempk3n2P1v7XRY1R0mZhjBsaiCfrirSuK9uLLkoDpXijhS668vNF+0efySf
         NKifhF7CrmOGpX8+yEzmkvkVjtl+sVwrnDNyvfOLt0pmF9AqW/DRqKYovofC9F7rP7r4
         q+QCfNE8UwvtX4OJpJ0qNspADO9N7yva306ybKjMpXpEignIadIgyQ3HGFPy4QuqB1n9
         PzcQ==
X-Gm-Message-State: AO0yUKXYwe1o+xZSOgqyow8jNMaj4kaHj0O2Lgbqc4UnFUQRmCn2j2eW
        SAmbwg9rAd689ZhXFJIlnu42Gw==
X-Google-Smtp-Source: AK7set+0ad5NmTti0LZIQYnT40wXG6EqaUU3YMKXBkZT7KckBtQVBgcSLqLDs4Fwkq3J1SkXgWd1Vw==
X-Received: by 2002:a05:600c:468e:b0:3e8:f27b:a92c with SMTP id p14-20020a05600c468e00b003e8f27ba92cmr18244483wmo.32.1678878385044;
        Wed, 15 Mar 2023 04:06:25 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:24 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 00/16] can: m_can: Optimizations for m_can/tcan part 2
Date:   Wed, 15 Mar 2023 12:05:30 +0100
Message-Id: <20230315110546.2518305-1-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc and everyone,

third version part 2, functionally I had to move from spin_lock to
spin_lock_irqsave because of an interrupt that was calling start_xmit,
see attached stack. This is tested on tcan455x but I don't have the
integrated hardware myself so any testing is appreciated.

The series implements many small and bigger throughput improvements and
adds rx/tx coalescing at the end.

Best,
Markus

Changes in v3:
- Remove parenthesis in error messages
- Use memcpy_and_pad for buffer copy in 'can: m_can: Write transmit
  header and data in one transaction'.
- Replace spin_lock with spin_lock_irqsave. I got a report of a
  interrupt that was calling start_xmit just after the netqueue was
  woken up before the locked region was exited. spin_lock_irqsave should
  fix this. I attached the full stack at the end of the mail if someone
  wants to know.
- Rebased to v6.3-rc1.
- Removed tcan4x5x patches from this series.

Changes in v2:
- Rebased on v6.2-rc5
- Fixed missing/broken accounting for non peripheral m_can devices.

part 1:
v1 - https://lore.kernel.org/lkml/20221116205308.2996556-1-msp@baylibre.com
v2 - https://lore.kernel.org/lkml/20221206115728.1056014-1-msp@baylibre.com

part 2:
v1 - https://lore.kernel.org/lkml/20221221152537.751564-1-msp@baylibre.com
v2 - https://lore.kernel.org/lkml/20230125195059.630377-1-msp@baylibre.com

stack of calling start_xmit within locked region:
	[  308.170171]  dump_backtrace+0x0/0x1a0
	[  308.173841]  show_stack+0x18/0x70
	[  308.177158]  sched_show_task+0x154/0x180
	[  308.181084]  dump_cpu_task+0x44/0x54
	[  308.184664]  rcu_dump_cpu_stacks+0xe8/0x12c
	[  308.188846]  rcu_sched_clock_irq+0x9f4/0xd10
	[  308.193118]  update_process_times+0x9c/0xec
	[  308.197304]  tick_sched_handle+0x34/0x60
	[  308.201231]  tick_sched_timer+0x4c/0xa4
	[  308.205071]  __hrtimer_run_queues+0x138/0x1e0
	[  308.209429]  hrtimer_interrupt+0xe8/0x244
	[  308.213440]  arch_timer_handler_phys+0x38/0x50
	[  308.217890]  handle_percpu_devid_irq+0x84/0x130
	[  308.222422]  handle_domain_irq+0x60/0x90
	[  308.226347]  gic_handle_irq+0x54/0x130
	[  308.230099]  do_interrupt_handler+0x34/0x60
	[  308.234286]  el1_interrupt+0x30/0x80
	[  308.237861]  el1h_64_irq_handler+0x18/0x24
	[  308.241958]  el1h_64_irq+0x78/0x7c
	[  308.245360]  queued_spin_lock_slowpath+0xf4/0x390
	[  308.250067]  m_can_start_tx+0x20/0xb0 [m_can]
	[  308.254431]  m_can_start_xmit+0xd8/0x230 [m_can]
	[  308.259054]  dev_hard_start_xmit+0xd4/0x15c
	[  308.263241]  sch_direct_xmit+0xe8/0x370
	[  308.267080]  __qdisc_run+0x118/0x650
	[  308.270660]  net_tx_action+0x118/0x230
	[  308.274409]  _stext+0x124/0x2a0
	[  308.277549]  __irq_exit_rcu+0xe4/0x100
	[  308.281302]  irq_exit+0x10/0x20
	[  308.284444]  handle_domain_irq+0x64/0x90
	[  308.288367]  gic_handle_irq+0x54/0x130
	[  308.292119]  call_on_irq_stack+0x2c/0x54
	[  308.296043]  do_interrupt_handler+0x54/0x60
	[  308.300228]  el1_interrupt+0x30/0x80
	[  308.303804]  el1h_64_irq_handler+0x18/0x24
	[  308.307901]  el1h_64_irq+0x78/0x7c
	[  308.311303]  __netif_schedule+0x78/0xa0
	[  308.315138]  netif_tx_wake_queue+0x50/0x7c
	[  308.319237]  m_can_isr+0x474/0x1710 [m_can]
	[  308.323425]  irq_thread_fn+0x2c/0x9c
	[  308.327005]  irq_thread+0x178/0x2c0
	[  308.330497]  kthread+0x150/0x160
	[  308.333727]  ret_from_fork+0x10/0x20

Markus Schneider-Pargmann (16):
  can: m_can: Remove repeated check for is_peripheral
  can: m_can: Always acknowledge all interrupts
  can: m_can: Remove double interrupt enable
  can: m_can: Disable unused interrupts
  can: m_can: Keep interrupts enabled during peripheral read
  can: m_can: Write transmit header and data in one transaction
  can: m_can: Implement receive coalescing
  can: m_can: Implement transmit coalescing
  can: m_can: Add rx coalescing ethtool support
  can: m_can: Add tx coalescing ethtool support
  can: m_can: Cache tx putidx
  can: m_can: Use the workqueue as queue
  can: m_can: Introduce a tx_fifo_in_flight counter
  can: m_can: Use tx_fifo_in_flight for netif_queue control
  can: m_can: Implement BQL
  can: m_can: Implement transmit submission coalescing

 drivers/net/can/m_can/m_can.c | 503 ++++++++++++++++++++++++++--------
 drivers/net/can/m_can/m_can.h |  35 ++-
 2 files changed, 415 insertions(+), 123 deletions(-)

-- 
2.39.2

