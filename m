Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2390D6C988F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 00:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCZWp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 18:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCZWp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 18:45:27 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8662759D2
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 15:45:26 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id c6-20020a056e020bc600b00325da077351so4688613ilu.11
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 15:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679870726;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lEspjiua93c9Wx+emjhT6RG2FrOB+aKkQEh7PcYsd8=;
        b=5iaITj9JvbqYoH867G7N1I3se2P0eCZAiLk/PkBiubel5ybqekysq+f5Sd00yc3A8n
         zLXUNAoVhHyPjy9mMlBD59UDotZNY6nq1Cg7AD8iE6u84T0qeS3Lz6gk85ImbMKGckqP
         7HAqViBK/GDnnkQ2fdmDKi1XhlZk0Fs+K/stAot0EU0ycdTzDrKBLaiXD56pfWA+XOwt
         Bx1YVCbrso3XKJ0XvvmbhNnXeE0GRaJqrVW80vRU1yxKk34meYOrFku/Cl0L2iYOavR7
         X70tZcd0/eIlNJ8qNydZ21gTThKaykmb3PJ2yXDFwqTjNt309oMRRGzijtywkrXAyX3I
         f3zA==
X-Gm-Message-State: AO0yUKVGrEm5Weyc8d27a0hAWZNIoT0Xudywb+mkYSQF6pkMost2gw4k
        okFijFouiBVc6PHw7eafX6USAN2KfZ+BV+5dSOJtrTfaOU/T
X-Google-Smtp-Source: AK7set96XIPJAXYQwUsGkxnwQBaDfPEB0m4BfUlp93WMIYVCACD6qwJf3nIhLrGieN+ju2bZ7Avb4F/kKUh9Msv9+YADHiF9f6nL
MIME-Version: 1.0
X-Received: by 2002:a02:2941:0:b0:3ec:dc1f:12d8 with SMTP id
 p62-20020a022941000000b003ecdc1f12d8mr3845812jap.4.1679870725894; Sun, 26 Mar
 2023 15:45:25 -0700 (PDT)
Date:   Sun, 26 Mar 2023 15:45:25 -0700
In-Reply-To: <000000000000708b1005f79acf5c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2bdb505f7d5612e@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
From:   syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
To:     avkrasnov@sberdevices.ru, bobby.eshleman@bytedance.com,
        bobby.eshleman@gmail.com, bobbyeshleman@gmail.com,
        davem@davemloft.net, deshantm@xen.org, edumazet@google.com,
        hdanton@sina.com, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oxffffaa@gmail.com, pabeni@redhat.com, sgarzare@redhat.com,
        stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 71dc9ec9ac7d3eee785cdc986c3daeb821381e20
Author: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Fri Jan 13 22:21:37 2023 +0000

    virtio/vsock: replace virtio_vsock_pkt with sk_buff

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12661f29c80000
start commit:   fff5a5e7f528 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11661f29c80000
console output: https://syzkaller.appspot.com/x/log.txt?x=16661f29c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa4b45720ca0519
dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14365781c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12eebc66c80000

Reported-by: syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
