Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B474A32A3
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353431AbiA2XkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiA2XkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5CCC061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:04 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i186so7034711pfe.0
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HxhGWZBYeYX0I+rT8duDFrHz+s74UhJdLy7jrNvZlQw=;
        b=cdEN1bKKL0I3hFH8ki7G3m6QrxcLVBXkHkTiY9q8w8EZ4/WloUxAeKRlJqB8j8hxKy
         B1/BaX5q7XkfDSJlO/42c21uWSgOLjOI2QGOETBggb/oTDgPFTUO1Wim8oetlbGTLrGT
         LpOT3bEjLQoJ/6/b1dHilpFPrk3Cq8IKkKqlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HxhGWZBYeYX0I+rT8duDFrHz+s74UhJdLy7jrNvZlQw=;
        b=RFCy5hDGOn/lfhjv91GX/RwF1Hxji+lmnlrp48y3tE3HWaK6lgjtXamrnb1eYhTupe
         lfEaqdJzK6pHOtjEdb0MTMkot1o2si48N0Peued6Xy4kNgiNeu2XWZ3XGgFhlF/TLgfi
         smuNfj5DMA0qxBcOSCH65KQIQE9qhOLJpEXGGLLflweONPoXpug6IYEkcFjxphRipatc
         uNFP4HDsrJq/fwAbow7Gwnll30jaNeEBTtQVXBK+T05iF4ZzFoHptkImrXNGOLwdhLLS
         OGdSnbZhV1xR6JaNqs7UQIC80DhEqp15GT/08SZINsaNF+h3fNHF9AuTzIGm081d8vE0
         Yf2Q==
X-Gm-Message-State: AOAM533dE3C93dxwKwO2P2uyW98p2xCIUR1wxxdSWSLZhj7Qo/mWzt4u
        e7tpAhQ9C/8nUrCM0vS99P0VU8GxKIGifVXBSE48If7ipjpHI2eVWDyGRgyhSQrowp7pRXafmcD
        B9mpNyh1QsPkemtDYZYUeOb46QfsJ0YfpHkA2u1Icr+1XMSVuG46C5i1ICMP0yR7hkbXK
X-Google-Smtp-Source: ABdhPJw2i0t7lUzbWD68A8J9o2kqP7CC8gwU5mMcEEI0Pr/4ft4FOLI8uvz8Ws1DA+/JpS+h13CdhQ==
X-Received: by 2002:a65:538e:: with SMTP id x14mr11608086pgq.58.1643499602818;
        Sat, 29 Jan 2022 15:40:02 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:02 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 00/10] page_pool: Add page_pool stat counters
Date:   Sat, 29 Jan 2022 15:38:50 -0800
Message-Id: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

This series adds some stat counters for the page_pool allocation path which
help to track:

	- fast path allocations
	- slow path order-0 allocations
	- slow path high order allocations
	- refills which failed due to an empty ptr ring, forcing a slow
	  path allocation
	- allocations fulfilled via successful refill
	- pages which cannot be added to the cache because of numa mismatch
	  (i.e. waived)

This v2 series includes some major changes from the original, namely:

	1. A new kernel config option has been added, which defaults to N,
	   preventing this code from being compiled in by default
	2. The stats structure has been converted to a per-cpu structure
	3. The stats are now exported via proc (/proc/net/page_pool_stat)

The main advantage of the v2 over the original approach is that no
modifications to drivers are required and no new external APIs are
introduced.

I benchmarked the code with the stats enabled and again with them disabled
using the netoptimizer/prototype-kernel benchmark programs [1], as Jesper
suggested.

Test system:
	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
	- 2 NUMA zones, with 18 cores per zone and 2 threads per core

bench_page_pool_simple results:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

for_loop			0	0.337		0	0.334
atomic_inc 			13	6.021		13	6.022
lock				31	13.545		31	13.846

no-softirq-page_pool01		45	20.040		44	19.388
no-softirq-page_pool02		46	20.295		43	19.073
no-softirq-page_pool03		110	48.053		122	53.405

tasklet_page_pool01_fast_path	14	6.126		12	5.640
tasklet_page_pool02_ptr_ring	42	18.334		40	17.695
tasklet_page_pool03_slow	109	47.854		108	47.355

bench_page_pool_cross_cpu results:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	2246	979.007		2136	931.075
page_pool_cross_cpu CPU(1)	2240	976.289		2145	934.924
page_pool_cross_cpu CPU(2)	1123	489.511		1072	467.474

page_pool_cross_cpu average	1886	-		1784	-

Thanks.

[1]:
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/lib

Joe Damato (10):
  page_pool: kconfig: Add flag for page pool stats
  page_pool: Add per-cpu page_pool_stats struct
  page_pool: Add a macro for incrementing stats
  page_pool: Add stat tracking fast path allocations
  page_pool: Add slow path order 0 allocation stat
  page_pool: Add slow path high order allocation stat
  page_pool: Add stat tracking empty ring
  page_pool: Add stat tracking cache refill
  page_pool: Add a stat tracking waived pages
  net-procfs: Show page pool stats in proc

 include/net/page_pool.h | 20 ++++++++++++++
 net/Kconfig             | 12 +++++++++
 net/core/net-procfs.c   | 69 ++++++++++++++++++++++++++++++++++++++++++++++++-
 net/core/page_pool.c    | 28 +++++++++++++++++---
 4 files changed, 125 insertions(+), 4 deletions(-)

-- 
2.7.4

