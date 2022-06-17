Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC654F545
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381814AbiFQKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiFQKWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:22:10 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A278D6A410
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:22:08 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id r9-20020a92cd89000000b002d16798b3cfso2396693ilb.22
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BHa9+hGQ/IHxpauWdzshJrHjnkYBEraCxfPd/dEUtAU=;
        b=t2PlhZtme+bt6nyoR01slptXLIUEhYziTjv+dVDlVVdu2fKoh8ojDJaFXkzh/OX3k0
         NEJ0vrdTy/cp/+JI8wtv14VePY1sQYf+N92fy4CkUI9dJY5KdeGa+bKhXjCQ79p8PyKE
         fBBmhAULzNSqmBNO2+jCXY70w6ZVGM9D7JmCtxBQNaB8zk37GdEVoK8fuhkt6AGIKAiV
         BXbfHvmEEj75baU+xrEtTSPdZcMQ7bNrLx2MKP1cSNH8QclRuYGch7jo5oMQVzawYgck
         Fea0AkBdk6As7LMuCenlvTeYvu4ozMENIhuanOPQ/KUqxfA5lthEdZWJq9Ag1rqTi5bJ
         J2Sg==
X-Gm-Message-State: AJIora/zZm8jtAQWKsrKBAPG/y1Did9n8QHw//C3fj8hKMwPxpDb6Dep
        LNYpnzbI7XdSdffuoXGjxWck7wks7HBN7DXq1qcmBtcY6GpZ
X-Google-Smtp-Source: AGRyM1smu9GzM0y0cFoa15FxWOxLa+jhsxFr0WpG+sezBX1jAlHrD+nTa4zPVOTrTRzJ5B+qmpSlN4EFeuSvc4Z59pOMCUWl/qZw
MIME-Version: 1.0
X-Received: by 2002:a05:6638:329e:b0:331:e8ae:7d9d with SMTP id
 f30-20020a056638329e00b00331e8ae7d9dmr5212322jav.274.1655461328084; Fri, 17
 Jun 2022 03:22:08 -0700 (PDT)
Date:   Fri, 17 Jun 2022 03:22:08 -0700
In-Reply-To: <00000000000006b92e05d6ee4fce@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066643305e1a22061@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in ath9k_hif_usb_reg_in_cb (3)
From:   syzbot <syzbot+b05dabaed0b1f0b0a5e4@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        john.ogness@linutronix.de, kuba@kernel.org, kvalo@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, pmladek@suse.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, syzkaller-bugs@googlegroups.com,
        toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 09c5ba0aa2fcfdadb17d045c3ee6f86d69270df7
Author: John Ogness <john.ogness@linutronix.de>
Date:   Thu Apr 21 21:22:48 2022 +0000

    printk: add kthread console printers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e88490080000
start commit:   210e04ff7681 Merge tag 'pci-v5.18-fixes-1' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=902c5209311d387c
dashboard link: https://syzkaller.appspot.com/bug?extid=b05dabaed0b1f0b0a5e4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f2c009f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b20b35f00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: printk: add kthread console printers

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
