Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366EB50A63C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356423AbiDUQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355987AbiDUQzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:55:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D04C49936;
        Thu, 21 Apr 2022 09:52:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96C82153B;
        Thu, 21 Apr 2022 09:52:20 -0700 (PDT)
Received: from ip-10-252-15-9.eu-west-1.compute.internal (unknown [10.252.15.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DAE213F73B;
        Thu, 21 Apr 2022 09:52:17 -0700 (PDT)
From:   Timothy Hayes <timothy.hayes@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     John Garry <john.garry@huawei.com>, Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 0/3] perf: arm-spe: Fix addresses of synthesized Arm SPE events
Date:   Thu, 21 Apr 2022 17:52:02 +0100
Message-Id: <20220421165205.117662-1-timothy.hayes@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes problems related to address in synthesized events from SPE.

Committer testing:

perf record --no-bpf-event -e arm_spe_0/pa_enable=1/ -- sleep 1
perf inject -i perf.data -o perf-inj.data --itrace --strip
perf script -i perf-inj.data --fields hw:+addr,+phys_addr

Before:
	sleep 49337 [004] 20133.731889:          1             l1d-access:  ffffcbebcde1d5b8 [unknown] ([unknown])
	sleep 49337 [004] 20133.731889:          1             tlb-access:  ffffcbebcde1d5b8 [unknown] ([unknown])
	sleep 49337 [004] 20133.731889:          1                 memory:  ffffcbebcde1d5b8 [unknown] ([unknown])

After:
	sleep 49337 [004] 20133.731889:          1             l1d-access: ffff800034123970 ffffcbebcde1d5b8 [unknown] ([unknown])       153d19970
	sleep 49337 [004] 20133.731889:          1             tlb-access: ffff800034123970 ffffcbebcde1d5b8 [unknown] ([unknown])       153d19970
	sleep 49337 [004] 20133.731889:          1                 memory: ffff800034123970 ffffcbebcde1d5b8 [unknown] ([unknown])       153d19970

tools/perf/arch/arm64/util/arm-spe.c                   | 10 ++++++++++
tools/perf/tests/attr/README                           |  1 +
tools/perf/tests/attr/test-record-spe-physical-address | 12 ++++++++++++
tools/perf/util/arm-spe.c                              |  5 +++--
4 files changed, 26 insertions(+), 2 deletions(-)

