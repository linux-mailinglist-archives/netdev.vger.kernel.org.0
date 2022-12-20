Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC656652720
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiLTThV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLTThT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:37:19 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A19DD2D0
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:37:18 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id a10-20020a056e02180a00b0030bc09c6b94so2537279ilv.6
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:37:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xtf3kK/4JkO5DVd4qOuGUgyJBsIREUJl3kcqk4Bwjr4=;
        b=beLH1NXeWnlUTqccYT68vuGbeE9LpCp08PuTR4wyYxjXgsjNlpvLfpT0PbKIGYcodP
         zBOQF+O6j747G7E0w1+KXiySxZXU4Y+da+xdlm1tIyn5n+AXOFGhDmO5CJNNV6IgFXtY
         7OlwTUt9kvC2nCBpfi6nCTJ2YbgLUu9MWBOmhhAyVcLIyQF5k8GjISISbH2e5ISBFvky
         qFed3Tp34YEmvpyJ1Q7/c+6xqNFQ5aTHxD8pBZ0TWwKHVSphTJ1xn8DuDG/O+/9ZkxxQ
         XqTVgYmqUeBplQzbS5sx5LtSsWUfTaZWE2KlUzVxqeepro3v09VSmbDvhGk7cR7kntLC
         iiTA==
X-Gm-Message-State: ANoB5pk//gnd80rvuIfYrsl+WvF7fT0/Bok/5IGqXQKf+4D97WcKypSs
        7tXRAado5YpRlvtkKGFVsJtRscKlQefcFPLA/CfpxXRar24n
X-Google-Smtp-Source: AA0mqf79LM6cuQfmZgkg9I2E8BaJp2XadINP9woNrMjfuuHwCStlay7Ncmm1QjAAXXiaNN1Z3ZOaFyHazaxPHao1vnryZURMltfR
MIME-Version: 1.0
X-Received: by 2002:a92:d8ca:0:b0:303:6b79:14bb with SMTP id
 l10-20020a92d8ca000000b003036b7914bbmr11203430ilo.9.1671565038025; Tue, 20
 Dec 2022 11:37:18 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:37:18 -0800
In-Reply-To: <CAKH8qBs1UiikX=_CBzRC_2rg3sp8CU5hhB7sOkNkNBqm8OqFEw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f881505f047903b@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
From:   syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org, sdf@google.com,
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5778 } 2673 jiffies s: 2773 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         13e3c779 Merge tag 'for-netdev' of https://git.kernel...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12cb0e5d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12df6a9b880000

