Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71DA4B0610
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiBJGIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:08:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiBJGIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:08:05 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD881E6
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 22:08:07 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id x6-20020a92d306000000b002bdff65a8e1so3284765ila.3
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 22:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hxxPMFG7Sy5R8OTw+DHD+CiI9MhDe02HH/eavpKJlVI=;
        b=J6n6DU74TvX5/2UIUVoeyP00FhroQyr7B+zpXcA0cmF0Xu78htgy2PNsHHBFOcc559
         h7yQGfLt5wG3M1M+HoykxaEPGZAQJl2WsPa9zP636wKYIBd2biWfA7fF+Qm/L/6P44wW
         MPZM/uRuNdPEkVSW6snPkMczVevIKzToEFzCA9jGZJxw5AOnFFWkfAWZIQ+6V+Scohuf
         Da7SyXGIbXzEXzTtBPTQaGchgnHmUwLg2R6PDxJCBbwA5uj19b+AVtqZO+PaDEYoS/on
         t2p06YOBR1k60lnmiPBQgegJ9vUVwN/HcPhSs+b1q4UOfJ/s1xkC39Z3soSaSolxKP0Z
         1vLw==
X-Gm-Message-State: AOAM532SglxBlDVRyilS1c6aUaLPj61YYhvNcJrJP5CBth5vPQgta67v
        sPahi3KjJtZVXac5Pq++5eklzQxD0tlx6ep2u6s3fIUGCFFJ
X-Google-Smtp-Source: ABdhPJxoAleQUKXdKQfyFJ/lU/DvKG+eN88p4ZFdGI/Tl2jq2ibPHrnZmPgShLp0DuHR0xD1pBw8UCAuxjN2bbrZc03Lii2YDBgU
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cd2:: with SMTP id j18mr3118329iow.92.1644473287137;
 Wed, 09 Feb 2022 22:08:07 -0800 (PST)
Date:   Wed, 09 Feb 2022 22:08:07 -0800
In-Reply-To: <000000000000a3571605d27817b5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f60ef05d7a3c6ad@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
From:   syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bjorn.topel@gmail.com, bjorn.topel@intel.com, bjorn@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fgheet255t@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        magnus.karlsson@intel.com, mudongliangabcd@gmail.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        w@1wt.eu, yhs@fb.com
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

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bc74c2700000
start commit:   f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=107c74c2700000
console output: https://syzkaller.appspot.com/x/log.txt?x=17bc74c2700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e514a4700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcdf8a700000

Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
