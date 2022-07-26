Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00061581C28
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiGZWqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGZWqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:46:09 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B81C22284
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:46:08 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id h7-20020a92c267000000b002dd80cf0989so2520981ild.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hGbatg4yqsVpW1X9k4zGa9wMwOyJ1zrxlRK2KHH2X1A=;
        b=PKLrSrbivmJTjdGmnnI7jnvlB8waowoWULAQ25t4GYWUiObvlHVK9bXmDJlo1gFtU8
         g/3BtKUTYVeLZpp5JRvoWQeBvTVsdqnemvIL/2PfEtLIM5TWQtGloKe1/rap81Dl2Wqr
         1vfRg/uEPC+73srccbbBB1t3qX/gMf2/Yn3IXN1+DgqpxaHFr6zGA60gif2DCl4oaFR0
         9ED2WIykfUTPvlfYqLC+iBMYcwCVEsY3rUgXGn5ZIht9yyFweTRrtgt5YqiyGcFSC64r
         RTV7aQ0MY//TQP+U6tZ7QbpOu7eIs1PPVDsSgxGoNtRY3vQ6djc7dPn9syCiLgMih6e0
         loHQ==
X-Gm-Message-State: AJIora9QmIdPG+rv+pmy+iIrBubyDRn4lCB1XmKHC3VaGrK8tWT5q3Aa
        7qgNr2uOGHi9fT64Kptu0RvdzWUF8jMmLzo3Tq9peHNOV2CE
X-Google-Smtp-Source: AGRyM1t8srvf8CVySeqfuH8ynNmReDFNgETq5OFo9IZwJiEeQICtfVGs0hjjCNsRCtmlxIf50Xhmve3XKjx5Q00gn6F5FZpyevRV
MIME-Version: 1.0
X-Received: by 2002:a6b:3f46:0:b0:67b:cd9c:4dc5 with SMTP id
 m67-20020a6b3f46000000b0067bcd9c4dc5mr7010998ioa.213.1658875567524; Tue, 26
 Jul 2022 15:46:07 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:46:07 -0700
In-Reply-To: <000000000000beb14105dd852b6a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000edd28b05e4bd100b@google.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in hsr_node_get_first
From:   syzbot <syzbot+d4de7030f60c07837e60@syzkaller.appspotmail.com>
To:     claudiajkang@gmail.com, davem@davemloft.net, edumazet@google.com,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        hdanton@sina.com, johannes.berg@intel.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, nbd@nbd.name, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com, toke@kernel.org
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

commit f856373e2f31ffd340e47e2b00027bd4070f74b3
Author: Felix Fietkau <nbd@nbd.name>
Date:   Tue May 31 19:08:24 2022 +0000

    wifi: mac80211: do not wake queues on a vif that is being stopped

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11100172080000
start commit:   0840a7914caa Merge tag 'char-misc-5.19-rc4' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=542d3d75f0e6f36f
dashboard link: https://syzkaller.appspot.com/bug?extid=d4de7030f60c07837e60
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12820318080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f144fff00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: wifi: mac80211: do not wake queues on a vif that is being stopped

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
