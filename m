Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD444573214
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiGMJIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiGMJIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:08:10 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC916E7CE8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:08:08 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id b11-20020a92340b000000b002d3dbbc7b15so6001517ila.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IjUx3jvjrE3LSejVCszDwxlxPoVo6L4bZafVfTgekgo=;
        b=EJOrW7W70YwJe2jQUTkVeAAxAmey3T5Crbq4IVnmq98IlwuMSOfAP0ikn+b5PBZywh
         2KFic7EHb2DWh72Qd4/KG8xuC/GqkS6x+hN+5MYeKmvs1kmOlOMz+IqDKGEMmXo3GQKJ
         hSSfK9+WVxGbpRTVAGcxMkFrhhPA2BhuO0JdwvBq0Sb6npVWpcHbIsVLPDRYj/yvakc8
         y2uhDyAzSH1r7ZUy9yXaGY4zCJcSffkfHQB4AdLS24KY6IDpQxT4En1+KgZTacMKx8s5
         uTnDdURGpDvw96c2PpF2BsUolUc9fiHMs4Apt/G0OYs1wdBWCSk/MaSAvT094P7LcvAk
         joKA==
X-Gm-Message-State: AJIora8hMKy+m3/PzUqPfdLsha/1TpA5fIONIsEeialPJMaPKkC0/t3u
        oJrLVE6OB5M4kkrbgbLfh2dS54tBdivtsnXPUURK/vysVhAn
X-Google-Smtp-Source: AGRyM1sRr07Kgyknni0yh+KomEWofavQWWh71RoatCmXTlY9LIWi0y/klNu3SnXwp1O1Wel8ZK1E+uD1bDxKjrRJW1BO6Ic3Mg5K
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1069:b0:2dc:7233:740b with SMTP id
 q9-20020a056e02106900b002dc7233740bmr1253741ilj.229.1657703288282; Wed, 13
 Jul 2022 02:08:08 -0700 (PDT)
Date:   Wed, 13 Jul 2022 02:08:08 -0700
In-Reply-To: <181f6c7ee61.6fd1462c198214.9029235269763018181@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4271f05e3ac1ff8@google.com>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
From:   syzbot <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
To:     code@siddh.me, davem@davemloft.net, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in regulatory_init_db

BUG: memory leak
unreferenced object 0xffff8881450dc880 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937974 (age 80.900s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
  backtrace:
    [<ffffffff86ff026b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff86ff026b>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff86ff026b>] regulatory_hint_core net/wireless/reg.c:3216 [inline]
    [<ffffffff86ff026b>] regulatory_init_db+0x22f/0x2de net/wireless/reg.c:4277
    [<ffffffff81000fe3>] do_one_initcall+0x63/0x2e0 init/main.c:1295
    [<ffffffff86f4eb10>] do_initcall_level init/main.c:1368 [inline]
    [<ffffffff86f4eb10>] do_initcalls init/main.c:1384 [inline]
    [<ffffffff86f4eb10>] do_basic_setup init/main.c:1403 [inline]
    [<ffffffff86f4eb10>] kernel_init_freeable+0x255/0x2cf init/main.c:1610
    [<ffffffff845b427a>] kernel_init+0x1a/0x1c0 init/main.c:1499
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

[   88.


Tested on:

commit:         b047602d Merge tag 'trace-v5.19-rc5' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d4252a080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=689b5fe7168a1260
dashboard link: https://syzkaller.appspot.com/bug?extid=7a942657a255a9d9b18a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
