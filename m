Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF96D4A6980
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiBBBNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiBBBNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:08 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D12C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o64so18797685pjo.2
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jzh/HKtd4byW+ldSIIcqiy5Qewt2FVTYc3J2xUHR0v0=;
        b=mEgtoHgNNjFYqvtKyo1lIzJUeNRE1L9RSK9gxYFvxxD3b1fbLB+VyvAcLsbCYV8F2R
         Ed1ADMLD3WytnJtHTG6denyKrcfDXWpwEp24oVwlYtFIWEnjBiK75Ape2T4bvmm7fuNQ
         YtIZCg+CRaZzU0Hcno7yrTDxjzgHRdz934RCg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jzh/HKtd4byW+ldSIIcqiy5Qewt2FVTYc3J2xUHR0v0=;
        b=Yycfry7/LI61xqet8UHZ+2DPNVjnnfuTUo1LP16sIXPQzXPLUby2zUH/rTHA5E76GT
         BWLwmalFML1l3bW7/xKjjNUCzIRAJ3OojrPr0IDMUohirBcXdj5QD/JLwQzzhNzmPpGk
         RWx+D/v0oqHkN3bSxyrhS0BEzgBe6CM5MDOD2KfBomK9v/104qgjEIKt/Ac4Hd9GuyF/
         yCkxNAZqxhUPDQwd2Bl+9u5dlODG6tz1tWYxj7FVQq8RBXUsCGrKy/fcIFht0NhhBIiB
         gVa78CQ6nJ7NPhVAwFsTFLjyrVeZEpXLCUWQanIjeIhLh1R6YBCADMDUlbr8V/J5SPns
         eiqQ==
X-Gm-Message-State: AOAM5304ypmMBL7T+rTR9QRG8g3Bk9N5yXPh0FLR/rSdnq9TLZGk3yXO
        8UzUbUNjLYmvcVG5UZ5xk+Ez2ysY7D3t4YcUKFFBjZyg8f1/IaUNfqet9EBsPwSqh3XDSFy0eJC
        TGqjUGNgll6Hx/2WLmAviUbPEA25q/hZO/HvUUb4qaGbbXE9iK7nJoW1NLn88tTViCzff
X-Google-Smtp-Source: ABdhPJxJGOM0OToQa9blbG8mMJgLplN0DhxBhix1pDlHUYU9Ho0Kd20eGnlhm2d1MSngbqYOja4J5g==
X-Received: by 2002:a17:902:9883:: with SMTP id s3mr29180761plp.41.1643764387612;
        Tue, 01 Feb 2022 17:13:07 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:06 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 00/10] page_pool: Add page_pool stat counters
Date:   Tue,  1 Feb 2022 17:12:06 -0800
Message-Id: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Sending a v3 as I noted some issues with the procfs code in patch 10 I
submit in v2 (thanks, kernel test robot) and fixing the placement of the
refill stat increment in patch 8.

I only modified the placement of the refill stat, but decided to re-run the
benchmarks used in the v2 [1], and the results are:

Test system:
	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
	- 2 NUMA zones, with 18 cores per zone and 2 threads per core

bench_page_pool_simple results:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

for_loop			0	0.335		0	0.334
atomic_inc 			13	6.028		13	6.035
lock				32	14.017		31	13.552

no-softirq-page_pool01		45	19.832		46	20.193
no-softirq-page_pool02		44	19.478		46	20.083
no-softirq-page_pool03		110	48.365		109	47.699

tasklet_page_pool01_fast_path	14	6.204		13	6.021
tasklet_page_pool02_ptr_ring	41	18.115		42	18.699
tasklet_page_pool03_slow	110	48.085		108	47.395

bench_page_pool_cross_cpu results:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	2216	966.179		2101	915.692
page_pool_cross_cpu CPU(1)	2211	963.914		2159	941.087
page_pool_cross_cpu CPU(2)	1108	483.097		1079	470.573

page_pool_cross_cpu average	1845	-		1779	-

v2 -> v3:
	- patch 8/10 ("Add stat tracking cache refill") fixed placement of
	  counter increment.
	- patch 10/10 ("net-procfs: Show page pool stats in proc") updated:
		- fix unused label warning from kernel test robot,
		- fixed page_pool_seq_show to only display the refill stat
		  once,
		- added a remove_proc_entry for page_pool_stat to
		  dev_proc_net_exit.

v1 -> v2:
	- A new kernel config option has been added, which defaults to N,
	   preventing this code from being compiled in by default
	- The stats structure has been converted to a per-cpu structure
	- The stats are now exported via proc (/proc/net/page_pool_stat)

Thanks.

[1]:
https://lore.kernel.org/all/1643499540-8351-1-git-send-email-jdamato@fastly.com/T/#md82c6d5233e35bb518bc40c8fd7dff7a7a17e199

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

 include/net/page_pool.h | 20 +++++++++++++++
 net/Kconfig             | 12 +++++++++
 net/core/net-procfs.c   | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/page_pool.c    | 28 ++++++++++++++++++---
 4 files changed, 124 insertions(+), 3 deletions(-)

-- 
2.7.4

