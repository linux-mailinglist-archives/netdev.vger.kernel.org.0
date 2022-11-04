Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD26619F56
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiKDR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiKDR4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:56:22 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACB247335
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:56:21 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id w16-20020a6b4a10000000b006a5454c789eso3483103iob.20
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFLDZrSmrKf3eaUSPUfU/z0D34JmXW5qNTObPr5a3dE=;
        b=iub0+ZQZhLZSabk+4OtTLmkiBA4zMnRkujrrdq5RCfQ5rSKilot1X03iTfZVbnitrp
         ZXgEo0Fi3ckyp4It77S60m3C8NawnDncIgfpx6IbrQs/INfLCwY8C0tLIstO8cx1buBi
         ZbRvDfKmPSEBRZnKIEuMNLemSP0rH7M7kVDBchVRWlEGGcujx2OOnb9iuVZcGcnAtDtU
         l0EVzWUuG5nUdmm9IieIq3x2+PlL220yCU+uSudh8CL1d1tr7vc3SLizNVk8fSFJbGl6
         hMsZu/nEML+nL2hrNia/owa0g/SxiyrGUecr02nCDiYvgNkO0mvjnhAsNYFh1AQtGStO
         6uaA==
X-Gm-Message-State: ACrzQf09gvGTTWuqxyNqLtBtselANW7kYog0NATa99C7m/A+bq73dmPU
        h0nyl58iOUy+UdSAakNRHJL3tQu+oSMU3MExzd2ml6efYmWu
X-Google-Smtp-Source: AMsMyM5jISVm+ThnehVRlGr4SGLsiESwHWORrPJaHVN2Gla1RS8HH7b06ZPnW17OhSwF1wbMM8K1f2L1F/XbPusoit6A69WxSHeM
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1210:b0:375:4aa6:ff85 with SMTP id
 n16-20020a056638121000b003754aa6ff85mr19651201jas.227.1667584580937; Fri, 04
 Nov 2022 10:56:20 -0700 (PDT)
Date:   Fri, 04 Nov 2022 10:56:20 -0700
In-Reply-To: <0000000000000bab2c05e95a81a3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000946f3005eca8cafe@google.com>
Subject: Re: [syzbot] BUG: corrupted list in hci_conn_add_sysfs
From:   syzbot <syzbot+b30ccad4684cce846cef@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
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

commit 448a496f760664d3e2e79466aa1787e6abc922b5
Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date:   Mon Sep 19 17:56:59 2022 +0000

    Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1052f8fe880000
start commit:   dc164f4fb00a Merge tag 'for-linus-6.0-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
dashboard link: https://syzkaller.appspot.com/bug?extid=b30ccad4684cce846cef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1110db8c880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e58aef080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
