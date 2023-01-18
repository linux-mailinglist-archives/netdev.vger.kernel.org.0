Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A43672449
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjARQ5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjARQ45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:56:57 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADD854100
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:56:54 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m15so17326683ilq.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Am+zTsGPzp39VN4+txdp6KZSTVqu1zDa8iCNSXcgAoA=;
        b=eYUMH3g5VGlsg/b433gcLhbbrAmfeVZ2GtkCT0+5n7wPaXMJDYOJ/viwJEvhNK3zRq
         pJ5Hpi8KwuaU8zh4ZjCUTy3B9J4nIY3Gy8wTwU9k3FJfC7wYrEALfTyuhNRRwxFreB7V
         zBy1PUaKfGCfFBIFI+zfcJOxjspVm0vnzqMWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Am+zTsGPzp39VN4+txdp6KZSTVqu1zDa8iCNSXcgAoA=;
        b=Cg764YpdSMnBVqhaKMF+xD+i0k1Ca6jSGvPHtTSJxi1GVH5VOoYOjKREnrqqqu9tpW
         yD65ckhpmyigHNrg3FV+3LXQs7vNWJl6GZOhnpFyCFMGVRkPNYTw+d/KB7oiHBQ+8J3D
         m2Cw8i4TkUAHlrwqg5lLIbphkmkF8sF5nWVQuz2RFcfJAKTQZqtIWGf7woTASMfCirEr
         j7rr1InCvAcAghfs7FE9BWu4bqW1N4uayUipJ8kpeT0mGID//Cb9ICmPIVDMWaoMg2DW
         gngvkkJ2vAMCgvSFYHETxiAGWO/HlzN6AUXg/XTLk2tSbNgZg+p0RIgzOxdwg7UoeekG
         If6A==
X-Gm-Message-State: AFqh2kqTY0lJHtNoS8nmiAGnaU3lpeaeZO3e77UzPECDf6FSlqlqU9nj
        hD8EA9ZvFAWvFhiLL1D6QKA9/GtaVDqazQeF
X-Google-Smtp-Source: AMrXdXtMRzyEsyMEdPn9Yy1cNI1cNgvaJtjmVe1bEufRJ48WrAkOJ6XZgD9Pt/Xv7YgTdloKVIaCNg==
X-Received: by 2002:a92:b007:0:b0:30e:f02f:f1bf with SMTP id x7-20020a92b007000000b0030ef02ff1bfmr12574137ilh.30.1674061013408;
        Wed, 18 Jan 2023 08:56:53 -0800 (PST)
Received: from [192.168.0.41] ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id h38-20020a022b26000000b0038ad48b4a6asm10539611jaa.49.2023.01.18.08.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:56:52 -0800 (PST)
Message-ID: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
Date:   Wed, 18 Jan 2023 10:56:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
From:   Frederick Lawler <fred@cloudflare.com>
Subject: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We've been testing Linux 6.1.4, and came across an intermittent "BUG: 
using __this_cpu_add() in preemptible" [1] in our services leveraging 
TCP_FASTOPEN and our kernel configured with:

CONFIG_PREEMPT_BUILD=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
CONFIG_PREEMPT_RCU=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_DEBUG_PREEMPT=y

I'm not sure how related this is to commit 0a375c822497 ("tcp: 
tcp_rtx_synack() can be called from process context
"), as I haven't found a reliable reproducer yet.

The stack trace below has audit_*(), but we have other traces with 
do_tcp_setsockopt() mixed in the backtrace. Once we get to 
tcp_rx_synack() in the __release_sock() path, we get the same problem.

[1]:
BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/209282
caller is tcp_make_synack+0x38d/0x5a0
CPU: 3 PID: 209282 Comm: nginx-ssl Kdump: loaded Tainted: G           O 
      6.1.4-cloudflare-2023.1.2 #1
Hardware name: Quanta Cloud Technology Inc. QuantaPlex T42S-2U/T42S-2U 
MB (Lewisburg-1G) CLX, BIOS 3B16.Q102 02/19/2020
Call Trace:
<TASK>
  dump_stack_lvl+0x34/0x48
  check_preemption_disabled+0xdd/0xe0
  tcp_make_synack+0x38d/0x5a0
  tcp_v4_send_synack+0x50/0x1f0
  tcp_rtx_synack+0x55/0x140
  ? load_balance+0xa91/0xd40
  ? _copy_to_iter+0x1d6/0x560
  inet_rtx_syn_ack+0x16/0x30
  tcp_check_req+0x39f/0x660
  tcp_rcv_state_process+0xa3/0x1020
  ? tcp_mstamp_refresh+0xe/0x40
  ? tcp_update_recv_tstamps+0x61/0x90
  ? tcp_recvmsg_locked+0x1eb/0x960
  tcp_v4_do_rcv+0xc6/0x280
  __release_sock+0xb4/0xc0
  release_sock+0x2b/0x90
  tcp_recvmsg+0x7c/0x200
  inet_recvmsg+0x52/0x130
  __sys_recvfrom+0xa8/0x120
  ? audit_filter_inodes.part.0+0x2e/0x110
  ? auditd_test_task+0x3c/0x50
  ? __audit_syscall_entry+0xd5/0x120
  __x64_sys_recvfrom+0x20/0x30
  do_syscall_64+0x38/0x90
  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
RIP: 0033:0x7fafc19adc74
Code: 89 4c 24 1c e8 2d 41 f8 ff 44 8b 54 24 1c 8b 3c 24 45 31 c9 89 c5 
48 8b 54 24 10 48 8b 74 24 08 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00 
f0 ff ff 77 34 89 ef 48 89 04 24 e8 59 41 f8 ff 48 8b 04
RSP: 002b:00007ffc42e18a20 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00007faf26457870 RCX: 00007fafc19adc74
RDX: 0000000000000001 RSI: 00007ffc42e18a60 RDI: 000000000000076a
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 00007faf2261fd40
R13: 00007faf26457870 R14: 00007faf1fe962c0 R15: 00007ffc42e18a60
</TASK>

Thanks,
Fred
