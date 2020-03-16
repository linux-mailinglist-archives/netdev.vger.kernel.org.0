Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E72F186319
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgCPCkJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 15 Mar 2020 22:40:09 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:52376 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbgCPCkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:40:04 -0400
Received: by mail-il1-f199.google.com with SMTP id d2so12630591ilf.19
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=G7pIHMXafOLm3F/2/i2LvBMFMIvTzROgcOUTWFn2X6I=;
        b=kv8DPgUHxTyqaz4+9wS8NRVYeH/uVR+zUX9OIgDZ12oCGPAxw7xVs5u8PoWxQnUGq9
         xqo/I12qNs45St4dCew4uyzcqygNVjX2FxdKI58JQsoBKUph8GJxxciho9zv7lDCO6iM
         ZYN4vZFPHgxgALME6qeKG/6n3lW7unZdV74NtmHyTL+1Izwdy0GQpfWeXKHInW3uRoOf
         iIBxS2wyMTWINR1OnUh2qJGXXX0kFo6yj7cuTKGN1ArB62je3cX0KWZcFDxGLugkkSx+
         0nIbdWKK/AwY3rsIEY/0cQ5mP4XrDa5xamm0xvzLRiBGndYHG3a6xohridmP9nknLoRI
         VJFA==
X-Gm-Message-State: ANhLgQ2K9MiyukR79a/Y6Faq+NV8n73jaB7xIVLU1HnklYAgjhHqWcEd
        /jaqgWRZezjKoBROWm/XCNuE0FdIIdGKF8v6/fVqnnH2cUV2
X-Google-Smtp-Source: ADFU+vsoZxccOxRhbL4Y/MIwgxSx220g7zIbktYsAfwneEMRwc/N8lW0/7POXMyHaJ8GuPRqszlVeuTTjg5as1yqhzbhVmbrzHSZ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3dd:: with SMTP id r29mr2463944jaq.94.1584326403449;
 Sun, 15 Mar 2020 19:40:03 -0700 (PDT)
Date:   Sun, 15 Mar 2020 19:40:03 -0700
In-Reply-To: <000000000000bdb5b2059c865f5c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c695f05a0efbc52@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>
To:     a@unstable.cc, akpm@linux-foundation.org, allison@lohutok.net,
        arnd@arndb.de, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net,
        christian.brauner@ubuntu.com, christian@brauner.io,
        coreteam@netfilter.org, dan.carpenter@oracle.com,
        davem@davemloft.net, elena.reshetova@intel.com,
        florent.fourcot@wifirst.fr, fw@strlen.de, geert@linux-m68k.org,
        hare@suse.com, heiko.carstens@de.ibm.com, hpa@zytor.com,
        info@drgreenstore.com, info@metux.net, jcmvbkbc@gmail.com,
        jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux@armlinux.org.uk, mareklindner@neomailbox.ch,
        mingo@redhat.com, netdev@vger.kernel.org,
        netfilter-core-owner@lists.netfilter.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        peterz@infradead.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b8e545e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126748d6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1385f959e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
