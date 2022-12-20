Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D238D651C7C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 09:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiLTInc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 03:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiLTIn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 03:43:27 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602B8178AF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 00:43:26 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so8062395iln.21
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 00:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77qvNoQqle0MfKLDQMi01YZLkngrkg9aZffzgWoC0vY=;
        b=13rQaBRknBb6bYvi7hJLkDao012N7VjBd0MYsBmSa4GObO+dok2Bo9CmqnnZSKhCLT
         z9HgL44aP7bwgVGtrj4oSB2pveyy3ZPF8X4hawiC/jki3O1rVcOSF6tncVU5uJ66dBW5
         ht8sAqKEW+/IiDE4m1BXd5WWMRAQEcvZDJtswd1+BanIEjIEZwsv/xTzF/hSa3dTSc++
         imKLI4lXmTrMAq3wbRnjibc272vtcJSoM0vh8THPPkhW8DeNDnO6KBZcMckAiZboM9O5
         M0Qs3PviPhnj7JVD6LOjzqyp1lIiXk0mwuy0sMoh2B8wsI3QCuMSHoQpNE22TAkIZt+M
         y6LA==
X-Gm-Message-State: ANoB5pkpNFLq0dd/iw+vxXwa5xvT/GoD2o7JB268zzOC3WvX2syIp5WZ
        J3k+W7r1GlvFwoPD+KcnxdG3vfg9DxSRcwQJLnljxXNwfFT+
X-Google-Smtp-Source: AA0mqf4KHT2PjH0rudr1knR4xY3Cueu+ZSBoGTVC3IgyDsnWzkduYtWlNbZNuj+1lcG9wQRkygZ76sBT0PKeMjXcG8DlWn7Oafxq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216a:b0:303:129a:8157 with SMTP id
 s10-20020a056e02216a00b00303129a8157mr28409262ilv.38.1671525805458; Tue, 20
 Dec 2022 00:43:25 -0800 (PST)
Date:   Tue, 20 Dec 2022 00:43:25 -0800
In-Reply-To: <Y6Fxfw5fhHhQYaSd@hirez.programming.kicks-ass.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de0f0b05f03e6d9b@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
From:   syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in corrupted

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5791 } 2673 jiffies s: 2805 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         13e3c779 Merge tag 'for-netdev' of https://git.kernel...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
console output: https://syzkaller.appspot.com/x/log.txt?x=121ea2e8480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12d4ad4f880000

