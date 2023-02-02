Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE168839D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjBBQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjBBQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:03:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A805DD
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675353753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JH33dAuEgrDN4c6RnZTIhkTDIJUa6XX4XEcpjU1hCzI=;
        b=Es8772pkTCs6rvqIDFtPQJ1VB8nb2amAvMFO0TO+lOoD3f3A80i8igvSLNpHnYlc1eDrRm
        cKPL6wnBSxpyDmY2yJ68Qvc6wxA6V27E9873nEf+RmyJasr0HsqSonMlX1xS5Nnhol07mN
        12n+XeCYmRWfBRaODUEIhmwkxpIG5JE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-xTHnbzqQMbSHgnKH_0KNGw-1; Thu, 02 Feb 2023 11:02:11 -0500
X-MC-Unique: xTHnbzqQMbSHgnKH_0KNGw-1
Received: by mail-wm1-f71.google.com with SMTP id l5-20020a1ced05000000b003db300f2e1cso1172525wmh.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 08:02:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JH33dAuEgrDN4c6RnZTIhkTDIJUa6XX4XEcpjU1hCzI=;
        b=gO4BxDIV8z/e60CICqWvbpYamuk3eLUpYo9i6aEWkPoWK/AOfOqosO8MkH8d0xYUaz
         oYdN/s+gv1TYciEXVkM9HaZMA5D+h45DdJrY+D2xDdafMEAWdnUCKK1xrNv+OTq4Mq/I
         WzJ0SonWW87K2SKAKQH+TwnEH4tQ8Te6xQM4a439Y99QYVRt98oUE0aCa8FRU1pjyhyc
         4IHFlNVqGf/6HkCPaeJ8HT2MlWnu75PyAbbAVcoX9YmRRf3izjtADOzDyV5TGcgp/tNX
         +aYF/D5+VkS2mToAGzrogTAeQQtblHFvE7vWU9QB9leI26wwtzRgmCicOezctETIbPpQ
         gyEA==
X-Gm-Message-State: AO0yUKWQp0pFW0iby8WS+Fn5Wl660vrZqi8M11vTh6HpfEm/KRG5NTJS
        WGmx9WS+GUqvuY0ZbS2fYW5LxAPXx3NryhbvAa0WeW4HJbqkOGCfux3nzCGNBWfRGkRjQ72yUDD
        O0uxT2iHNv9mLwUwtdWumtGNhzzQu8egfE/E2tQiKB0D4S/6b5o2nHBttj8rX9XEMP/I=
X-Received: by 2002:a7b:c388:0:b0:3db:2e6e:7826 with SMTP id s8-20020a7bc388000000b003db2e6e7826mr7071132wmj.5.1675353730021;
        Thu, 02 Feb 2023 08:02:10 -0800 (PST)
X-Google-Smtp-Source: AK7set99x88Md1dphpEviJVpWJUs9RCBK5FUWUv88yIvmRIBadQXA/4ZnAY+PeYGNFMyxQg3pG3qrg==
X-Received: by 2002:a7b:c388:0:b0:3db:2e6e:7826 with SMTP id s8-20020a7bc388000000b003db2e6e7826mr7071089wmj.5.1675353729732;
        Thu, 02 Feb 2023 08:02:09 -0800 (PST)
Received: from [192.168.1.163] ([188.65.88.100])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003daf6e3bc2fsm7974121wms.1.2023.02.02.08.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 08:02:09 -0800 (PST)
Message-ID: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
Date:   Thu, 2 Feb 2023 17:02:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     netdev@vger.kernel.org, richardcochran@gmail.com,
        yangbo.lu@nxp.com, mlichvar@redhat.com,
        gerhard@engleder-embedded.com
Cc:     habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.maftei@amd.com
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Subject: PTP vclock: BUG: scheduling while atomic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Our QA team was testing PTP vclocks, and they've found this error with sfc NIC/driver:
  BUG: scheduling while atomic: ptp5/25223/0x00000002

The reason seems to be that vclocks disable interrupts with `spin_lock_irqsave` in
`ptp_vclock_gettime`, and then read the timecounter, which in turns ends calling to
the driver's `gettime64` callback.

Vclock framework was added in commit 5d43f951b1ac ("ptp: add ptp virtual clock driver
framework").

At first glance, it seems that vclock framework is reusing the already existing callbacks
of the drivers' ptp clocks, but it's imposing a new limitation that didn't exist before:
now they can't sleep (due the spin_lock_irqsave). Sfc driver might sleep waiting for the
fw response.

Sfc driver can be fixed to avoid this issue, but I wonder if something might not be
correct in the vclock framework. I don't have enough knowledge about how clocks
synchronization should work regarding this, so I leave it to your consideration.

These are the logs with stack traces:
 BUG: scheduling while atomic: ptp5/25223/0x00000002
 [...skip...]
 Call Trace:
  dump_stack_lvl+0x34/0x48
  __schedule_bug.cold+0x47/0x53
  __schedule+0x40e/0x580
  schedule+0x43/0xa0
  schedule_timeout+0x88/0x160
  ? __bpf_trace_tick_stop+0x10/0x10
  _efx_mcdi_rpc_finish+0x2a9/0x480 [sfc]
  ? efx_mcdi_send_request+0x1d5/0x260 [sfc]
  ? dequeue_task_stop+0x70/0x70
  _efx_mcdi_rpc.constprop.0+0xcd/0x3d0 [sfc]
  ? update_load_avg+0x7e/0x730
  _efx_mcdi_rpc_evb_retry+0x5d/0x1d0 [sfc]
  efx_mcdi_rpc+0x10/0x20 [sfc]
  efx_phc_gettime+0x5f/0xc0 [sfc]
  ptp_vclock_read+0xa3/0xc0
  timecounter_read+0x11/0x60
  ptp_vclock_refresh+0x31/0x60
  ? ptp_clock_release+0x50/0x50
  ptp_aux_kworker+0x19/0x40
  kthread_worker_fn+0xa9/0x250
  ? kthread_should_park+0x30/0x30
  kthread+0x146/0x170
  ? set_kthread_struct+0x50/0x50
  ret_from_fork+0x1f/0x30
 BUG: scheduling while atomic: ptp5/25223/0x00000000
 [...skip...]
 Call Trace:
  dump_stack_lvl+0x34/0x48
  __schedule_bug.cold+0x47/0x53
  __schedule+0x40e/0x580
  ? ptp_clock_release+0x50/0x50
  schedule+0x43/0xa0
  kthread_worker_fn+0x128/0x250
  ? kthread_should_park+0x30/0x30
  kthread+0x146/0x170
  ? set_kthread_struct+0x50/0x50
  ret_from_fork+0x1f/0x30

