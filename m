Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70B5F8029
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJGVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJGVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:39:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2DC64
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:39:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 3so4446584pfw.4
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdA6XcDcQwg9zDLtFIzs93/AhQzMHvgyPe65oak5BT0=;
        b=nWtUNKq8fpP7+oe7Ko7ayU3yWakO5yodmPrVAdSsPswK6lvRmiq6WII4nYMR4uxWfU
         dgGAiLCpxAyMRi7pjuOj37z3loTbG8RJl4/iU5cxyB7CJIUIzRxBSQ5f+zM3YunERMnI
         8kvcnOhvmhCK3FSsMfQ6xvVNmInCdSZijG60A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdA6XcDcQwg9zDLtFIzs93/AhQzMHvgyPe65oak5BT0=;
        b=ePQQIAFPbebWYiGczXDbgCPw4/DZHsXwxwBLHnCi5jWQKtIVBuMu4/oM4UDAjF/5E8
         iSc2zCW3xARZL3/p6azEsJ8JkSn51XYJ6Qr0C1rloj3WHnV3SYOXi75n/kLMyN8wc3L8
         GE+qPdbCfZ7AxyJIDrFv2JKm7BajqSu+I06RVAvEqcH7A+QHEEdExChsGAF4pzkcnvEr
         pPBkKZhUCu/e/zDNSr5TPzrdS/fd3hrhG9j2WhICclZG75lVgbjQecfkjZZsZSDwz/wq
         GkMu8XIeSvTnSs/vRjL7mXnGLNDBruCcohxEJKkJEbse9TT16xOt/F9/rhHRR9Zz1eJG
         LYtg==
X-Gm-Message-State: ACrzQf3lRvpH8EHLMnGBUpbK66OFcWPRJ4bAtN0cwM83PefNBKeWeMb5
        MFiKBSqHGlEBbqcQkzhNbWna2A==
X-Google-Smtp-Source: AMsMyM5Sitfc0wj+QbX6HOmxnxrWy2URPbg4MO2DhArWB89B8N62KltQqNmU2cxjPQR3U+jz72ppnA==
X-Received: by 2002:a05:6a00:2495:b0:562:c459:e327 with SMTP id c21-20020a056a00249500b00562c459e327mr4236531pfv.47.1665178775283;
        Fri, 07 Oct 2022 14:39:35 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b001f2fa09786asm2012655pjl.19.2022.10.07.14.39.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:39:34 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue v4 0/4] Add an i40e_napi_poll tracepoint
Date:   Fri,  7 Oct 2022 14:38:39 -0700
Message-Id: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v4.

Debugging and tuning the NAPI and i40e NIC parameters can be a bit tricky
as there are many different options to test.

This change adds a tracepoint to i40e_napi_poll which exposes a lot of
helpful debug information for users who'd like to get a better
understanding of how their NIC is performing as they adjust various
parameters and tuning knobs.

Note: this series does not touch any XDP related code paths. This
tracepoint will only work when not using XDP. Care has been taken to avoid
changing control flow in i40e_napi_poll with this change.

With this series applied, you can use the tracepoint with perf (assuming
XDP is not being used) by running:

$ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=fp --libtraceevent_print

388.258 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth2 q i40e-eth2-TxRx-9 irq 346 irq_mask 00000000,00000000,00000000,00000000,00000000,00800000 curr_cpu 23 budget 64 bpr 64 rx_cleaned 28 tx_cleaned 0 rx_clean_complete 1 tx_clean_complete 1)
	i40e_napi_poll ([i40e])
	i40e_napi_poll ([i40e])
	__napi_poll ([kernel.kallsyms])
	net_rx_action ([kernel.kallsyms])
	__do_softirq ([kernel.kallsyms])
	common_interrupt ([kernel.kallsyms])
	asm_common_interrupt ([kernel.kallsyms])
	intel_idle_irq ([kernel.kallsyms])
	cpuidle_enter_state ([kernel.kallsyms])
	cpuidle_enter ([kernel.kallsyms])
	do_idle ([kernel.kallsyms])
	cpu_startup_entry ([kernel.kallsyms])
	[0x243fd8] ([kernel.kallsyms])
	secondary_startup_64_no_verify ([kernel.kallsyms])

The output is verbose, but is helpful when trying to determine the impact of
various turning parameters.

Thanks,
Joe

v3 -> v4:
	- All XDP related changes were dropped from both the TX and RX
	  paths (patches 2/4 and 3/4 were updated).
	- A conditional was added to only fire the tracepoint if XDP is NOT
	  enabled (patch 4/4 updated).
	- Fixed format specifier for rx_cleaned and tx_cleaned (from %lu
	  to %u in patch 4/4).

v2 -> v3:
	- Add an rx_clean_complete to the RX patch so that it can be output
	  in tracepoint instead of the valued of 'clean_complete' which can
	  be ambiguous (patch 3/4 was updated).
	- Update the tracepoint to swap 'clean_complete' with
	  'rx_clean_complete' (patch 4/4 was updated).

v1 -> v2:
	- TX path modified to push an out parameter through the function
	  call chain instead of modifying control flow.
	- RX path modified to also use an out parameter to track the number
	  of packets processed.
	- Naming of tracepoint struct members and format string modified to
	  be more readable.

Thanks,
Joe

Joe Damato (4):
  i40e: Store the irq number in i40e_q_vector
  i40e: Record number TXes cleaned during NAPI
  i40e: Record number of RXes cleaned during NAPI
  i40e: Add i40e_napi_poll tracepoint

 drivers/net/ethernet/intel/i40e/i40e.h       |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 49 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 27 +++++++++++----
 4 files changed, 72 insertions(+), 6 deletions(-)

-- 
2.7.4

