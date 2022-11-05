Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADA61D776
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 06:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKEF1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 01:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKEF1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 01:27:19 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FB210B6
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 22:27:18 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id f17-20020a5d8591000000b006bcbe59b6cdso4261645ioj.14
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 22:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ASnNDxhoqSLaBjncwLtyuIp6tFD08p3uNjxVPZiJKI=;
        b=nKR6Nmciyj5CUE0yQ2gE4JExRoB4R5lOD2Mz/16TUJMJapftOZyLw/0xncElC6/j0S
         uzHFXseWAJXxQ6g6p0MkjHyq9uif+Tw6cTuE9v1DNlhOKpmxwN9WlIK4UA5om920hQkJ
         9P3mBrQtnfBgz7oWQ5CFmCOtpcj3WTznRS9AxOB8X61c4ueh5zPtmwEEhL41cEnGWNLy
         vP/6Ud+TtpCp/lBYBci3ilHJLBxUjCEHBWFaRhSLekmtgzocp9fuTaVR0pEXkaOX4Qsf
         M7clNc/hu7Q8TCqfJEcO8A3JgRhQoQLZmi1cMop1lA+RCtbDPgG4J33uYIVM7r2EyP90
         IcPg==
X-Gm-Message-State: ACrzQf0EGRVDXGVw9BjaHu9i+N689DsKdXOqrFxTdGLYDBYzxH6muzjR
        OHpuyDCvt6G8C3diwgOheoVPdYxaaWHwLH8uqc11Vfw+i8ej
X-Google-Smtp-Source: AMsMyM6VWI4Vk3WRzJfNJhb6um+SW7Ecd5WwtI1YxMBLKoya+XpAkwf4Adj2jolavy1c/SExku6Efe+lBuQpH9G+Y3dNw75iPtHB
MIME-Version: 1.0
X-Received: by 2002:a02:a00f:0:b0:375:7166:2dac with SMTP id
 a15-20020a02a00f000000b0037571662dacmr14017102jah.49.1667626037516; Fri, 04
 Nov 2022 22:27:17 -0700 (PDT)
Date:   Fri, 04 Nov 2022 22:27:17 -0700
In-Reply-To: <00000000000041f5bc05e678fa9f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000959e6405ecb271a3@google.com>
Subject: Re: [syzbot] WARNING in __cancel_work
From:   syzbot <syzbot+10e37d0d88cbc2ea19e4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, hdanton@sina.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp,
        penguin-kernel@i-love.sakura.ne.jp, syzkaller-bugs@googlegroups.com
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

syzbot suspects this issue was fixed by commit:

commit 2d2cb3066f2c90cd8ca540b36ba7a55e7f2406e0
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Sat Sep 3 15:32:56 2022 +0000

    Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1469d541880000
start commit:   7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=20bc0b329895d963
dashboard link: https://syzkaller.appspot.com/bug?extid=10e37d0d88cbc2ea19e4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13537803080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e68315080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
