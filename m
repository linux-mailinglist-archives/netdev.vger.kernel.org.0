Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD1647A5A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiLHXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLHXwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:52:18 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B1E7E80D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 15:52:16 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so2595508ila.12
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 15:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyvNwceZF5z8ZR0dxpXEzRAKysxu2R1tYLIvKJOVfyI=;
        b=azrT5rCneElKTO6AP2EXmdPinJUV1gwcDLBB6lEtWi7Oq8pJqN1JiPm+CvDmMAPCmp
         V2qdWGvnwvr5SBiejBOAUEZQqFgWr4suiN6BjV6E7TUIJrlZOttYGjcInkma0px2kT5K
         bwNGKejHZhb2r7FT2dtjdxTwsEivQtEs+3Io2ez1D7Ads6b4zfmDdjMOWuTpI6GvjFoe
         sRhwj94+lh4dRyGauawrPrdsRsyHLs9CucWaqyhotNdFdl9qs6phUlkwsmNhWRl+uVUV
         4WlWtTWRuYrG1QC7Zx6g6+YJQr8pIuzmvyv5MTRUYQ1nuDZeiinjz37/8bZFTD7jY6IP
         8f6g==
X-Gm-Message-State: ANoB5pm6HHu8D2JuLz99hyPVgfH086DfAJH2k7qQQ6QcSnitl9Og8Gl9
        X3k7PSD8s7tGGX2FkZocgd4QLZWscl6HB305eaLJxry2Jlen
X-Google-Smtp-Source: AA0mqf5eNp7hjb0FvQ5EQPFAIrGlfS3LdhxB+RcSrRifO8D2Fx2bnUdUgfZRoSFmRajDyx+hT2z4uiVEMbK/LXsfrO4yJuJdHBGF
MIME-Version: 1.0
X-Received: by 2002:a6b:8f43:0:b0:6e0:34ee:4e97 with SMTP id
 r64-20020a6b8f43000000b006e034ee4e97mr3798174iod.38.1670543536033; Thu, 08
 Dec 2022 15:52:16 -0800 (PST)
Date:   Thu, 08 Dec 2022 15:52:16 -0800
In-Reply-To: <1805058.1670508568@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000c17c905ef59bad4@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_destroy_all_locals
From:   syzbot <syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P4104 } 2661 jiffies s: 2777 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         efb7555b rxrpc: Fix I/O thread stop
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/ afs-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=16b83997880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb14358c9774adf3
dashboard link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
