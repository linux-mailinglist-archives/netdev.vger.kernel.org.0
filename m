Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D224FC6EB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350236AbiDKVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiDKVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:50:25 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341DC1A3B8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:48:10 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id x1-20020a056e020f0100b002c98fce9c13so11457234ilj.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Nrfu+QqSF6/ab+WasZFQXdtEXQrUlu6Oj2jlqNXgE2Y=;
        b=TjQ3fHJIaHGWLoeWP2of/5Zvh5QJ5fmbQxesF6XaacnfTfLS31FagW4gNyrkpqnXE6
         cSvzheC2KsXj+6X7x7nQ4AP5891obSh41IgC7Eag/ZrsM+5rOb+hYjd+p4qIE965oLFO
         YT4ymSKRIk3tUp17f7HbNaEKMh41PJmqUPyzBK0/osRPfCTD8p3BjspSVNVqY+Bc/MTy
         bOxTjGJ+tDfLxboSTMRgVcFdMrLpBZnsgyyIEs+THY8DSuvIGh1Oa+MQnDomVvQMRbJ3
         i6VsAHBPWdfDN1/zCX7d/Wl65LKY2C4YT9y4LSJDA09HLQPncAJ0SR2UnQ6dluIfx33Y
         3YfQ==
X-Gm-Message-State: AOAM533caA5Bzvc7qpLSu09CjpCNL+gyv2Auxj46DPUnOYxh8hAuUyoj
        XfAUcEgCRF21hnwQvD9PspE1KRuxjtGLJY5RWUalao1zTL2D
X-Google-Smtp-Source: ABdhPJwJO9uxDUuoSJ6AW+FyvTZ0JArsOxFYZApz2erqpsQNVtXt62RJ98yJQG2Mai75WQ1cVZbXr1dav+A3EkX+HtssNTxCCL1X
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0e:b0:2c6:18c3:9691 with SMTP id
 g14-20020a056e021e0e00b002c618c39691mr14673558ila.287.1649713689588; Mon, 11
 Apr 2022 14:48:09 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:48:09 -0700
In-Reply-To: <00000000000098289005dc17b71b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000072fb2705dc67e6c0@google.com>
Subject: Re: [syzbot] possible deadlock in sco_conn_del
From:   syzbot <syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        josephsih@chromium.org, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yinghsu@chromium.org
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

syzbot has bisected this issue to:

commit 92b8aa6d18f7a9ae36a0f71d31742aeef201207a
Author: Ying Hsu <yinghsu@chromium.org>
Date:   Sat Mar 26 07:09:28 2022 +0000

    Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fada04f00000
start commit:   d12d7e1cfe38 Add linux-next specific files for 20220411
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fada04f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fada04f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58fcaf7d8df169a6
dashboard link: https://syzkaller.appspot.com/bug?extid=b825d87fe2d043e3e652
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a2ff0f700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149fd2df700000

Reported-by: syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com
Fixes: 92b8aa6d18f7 ("Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
