Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31A663F68
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjAJLpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjAJLpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:45:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13EA4880D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:45:22 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so8132658ilu.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TpK0pPvqOKgjedED423ZnMsHNZBVvA9f0EYOI2eAdnY=;
        b=zfRrWo4iaCu1UBE7Tok78NtiUfkQTUrDdRRaj+uadDV8uUfbj3QWNqKPKPORx+1l/6
         QruZG1jfTQYQipLVeyBjZdtIWmnJBg3KsFJjUvKLyhJyoboXcBWFBZUCvNX5aGEHDdGr
         5Hi0QOfb7piWALSv/WwDTe/TAiRbKmBV7PnjdzlVrXHnRqxvtIfiDU930C9s3t0T8U5f
         a66mjwuvsv3QhnMaPJwDHIpYOHHw/zid4LshP92EOQBSudhoUCYm/3J4BFhNPxLm8Dwb
         2q5w0IgO5DR9GdThnKhvHpTJ4GUxmoLERV/INIWbLu+NLeNyX8K157Qj9NhKRE56vKQe
         TUVQ==
X-Gm-Message-State: AFqh2kpc+zY4ydvW/kxWhFp5qWmWO6S4sWmNstd3h27k5WFhh2QDEupQ
        SkgFajCgpoUGrnB+l7cXJ9LZ6qyWoKC7q1FRAIgAp2MgP/a1
X-Google-Smtp-Source: AMrXdXtmMRvOTMjLV+zOW/Bffy1/EPxrFKkoixfDCmOb+cxvHRhvwlJaa1VZkxp0URrn/hvx/596yhWXT/ZljXYFfZHEpkvqTpX5
MIME-Version: 1.0
X-Received: by 2002:a92:dcd1:0:b0:30c:e85:434e with SMTP id
 b17-20020a92dcd1000000b0030c0e85434emr5539109ilr.239.1673351122256; Tue, 10
 Jan 2023 03:45:22 -0800 (PST)
Date:   Tue, 10 Jan 2023 03:45:22 -0800
In-Reply-To: <00000000000024d6fc05f1d9b858@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a0d7d05f1e76b4d@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_call
From:   syzbot <syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        roman.gushchin@linux.dev, shakeelb@google.com,
        shaozhengchao@huawei.com, syzkaller-bugs@googlegroups.com,
        vasily.averin@linux.dev
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

syzbot has bisected this issue to:

commit a275da62e8c111b897b9cb73eb91df2f4e475ca5
Author: David Howells <dhowells@redhat.com>
Date:   Mon Oct 10 07:45:20 2022 +0000

    rxrpc: Create a per-local endpoint receive queue and I/O thread

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ba382c480000
start commit:   60ea6f00c57d net: ipa: correct IPA v4.7 IMEM offset
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ba382c480000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ba382c480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
dashboard link: https://syzkaller.appspot.com/bug?extid=4bb6356bb29d6299360e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141826f6480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a8642c480000

Reported-by: syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com
Fixes: a275da62e8c1 ("rxrpc: Create a per-local endpoint receive queue and I/O thread")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
