Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9081E6C91DE
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 01:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCZAq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 20:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZAqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 20:46:25 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656707EC5
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 17:46:24 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id h136-20020a6bb78e000000b00758b105cdd3so3435875iof.23
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 17:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679791583;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d15GJEJLrbSuQbr+AyveUByn8eaLHxEndF8G5qdETKg=;
        b=KDRla8BIUiFqlE5pDsYzb4KUQ8c23NbLR8xYEEQbp4vzz/ZA9apj6/voxv9Gbbxcmm
         S2pRVHQ1KiHqp0m7p2rKfWwRLKlSq+Z0F/2HHTSwr9NDRnZcN3zk9AO8so2riMa1YNcK
         p6cJbk8pm6Gj6vi4eNey1BebPxDc3UqFnvazaDKbGG5p9LCD7VXZXgS1IMPBzEl+f/4/
         IRkFo7AZ+jhsGCM304PhHl5+mO5bJ5CUP5QXz6dexk2YhHFtCCHYwRLEhVu1vc31sURI
         sYX0L8gaxem4aK8/UdApYznuKWBl3ipe9JI5qjs+JrShB9rGWWGvns79sfD/aPsU8Ti8
         Oi+A==
X-Gm-Message-State: AAQBX9cIBj0eWxTU7dv5gpTy8Loyck1JNzvTJFKIAuaIqF3bJA61ZvvA
        KrsCUZ3Gr/UPh3PPOuTl22GT4c49hQw0CZjzDdRPHdF5nKS9
X-Google-Smtp-Source: AKy350YZ9Bw8Wn5/59DoOMOyPZeeVBG4oqgre9seN+QlAM/OXP3XvNoAOYg87OLsF8K1W5LMJIqbJ5jc7VzPsO6XacVyiqxdYvr8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d51:b0:325:e737:9d62 with SMTP id
 h17-20020a056e020d5100b00325e7379d62mr2276622ilj.6.1679791583750; Sat, 25 Mar
 2023 17:46:23 -0700 (PDT)
Date:   Sat, 25 Mar 2023 17:46:23 -0700
In-Reply-To: <000000000000e8fd1f05ed75bf20@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5727605f7c2f407@google.com>
Subject: Re: [syzbot] [nfc?] possible deadlock in nci_start_poll
From:   syzbot <syzbot+f1f36887d202cea1446d@syzkaller.appspotmail.com>
To:     bongsu.jeon@samsung.com, davem@davemloft.net, dvyukov@google.com,
        edumazet@google.com, hdanton@sina.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

syzbot suspects this issue was fixed by commit:

commit b2e44aac91b25abbed57d785089c4b7af926a7bd
Author: Dmitry Vyukov <dvyukov@google.com>
Date:   Tue Nov 15 10:00:17 2022 +0000

    NFC: nci: Allow to create multiple virtual nci devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117e50c1c80000
start commit:   0b1dcc2cf55a Merge tag 'mm-hotfixes-stable-2022-11-24' of ..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=436ee340148d5197
dashboard link: https://syzkaller.appspot.com/bug?extid=f1f36887d202cea1446d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125fa5c5880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12508d3d880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: NFC: nci: Allow to create multiple virtual nci devices

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
