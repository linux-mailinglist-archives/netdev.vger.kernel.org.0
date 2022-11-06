Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86461E78B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 00:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiKFXZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 18:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiKFXZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 18:25:06 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1CEA186
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 15:25:05 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13ba86b5ac0so11067384fac.1
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 15:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QG/CjKSvFZQaCoWr7ypQoCkxCBty+FpzO0Qi0VrwzRs=;
        b=iRdfPsrvF+v5ExFdlaCQIx4OL1DauA7BjJ16lfYfi8OsstkYtKmTwFRymon6hD5mGs
         3XX7fjmsM1AGS31I/7dOZK3EeqLXf1gtqYmFQuRzfOLY5Sw9pY7BBnbL42/RF/1ke0Sf
         fFDSWemjJ3N6Qotq/eIPCvtvY9cQa13ieouQTXPNsCnxcwned6CiDy6BZTyYA3QT7EJm
         JWJC4CQaElVvPgTHCBwG1XfbQw6wCTF43RnYMwvC5vOv1zqxkdtas7VIph80VmW9uuPy
         Krmwfo2T7SxRU9c8X7xbwlJS3UaBnScrOQe7UsM3gdS84d+QtQEFyzaumH7q3W8DMoXr
         /Erg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QG/CjKSvFZQaCoWr7ypQoCkxCBty+FpzO0Qi0VrwzRs=;
        b=ZA9+VR7qfF4jV5JH4FELVCXokK8WUCHn76EzHPNja87UjNlzhMl+v1d55tToMzzeFF
         Xtfj4tY5+T4l+uiEltb7piymGPemuiELVleR/488N6wdbpijrU8vE73ykfi9jk36JIHV
         iytYKhoczTuIZG1jH1zfuGbl9OKBcmqHqBmkFky2M/k4InoW4pxfYRuqdzL7/pC03G0B
         yb3Pdn1d61gPPuoGrQUStzmbsS9T4RPdqPtvLjdB1zBs6ObB/YITmwYIdpfJgqyxswXA
         LOEKRA+tekWv8oUw/8r1uc7lUDDQSnIn8FafjVzd/AaRN7QzRoGHLVlQyIfxpXuUC/LF
         LgzA==
X-Gm-Message-State: ACrzQf2NOJBSzl7+9c3+IjApG6wjyE+X3mObf7GilC/ZMb/9gtaUoRER
        GxNf6FoQmwebvtPTXBEhoyO15aUXZC/d+yV/Eex4MQ==
X-Google-Smtp-Source: AMsMyM6RBiAxPrS70jGeErOWqI6T+eSQAVfp1vPQBXJAAh/J4/m3YkRq/wIHtvcBhfQxhEE6uC2O+LIDYuOLo8YddHM=
X-Received: by 2002:a05:6870:b6a3:b0:13b:f4f1:7dec with SMTP id
 cy35-20020a056870b6a300b0013bf4f17decmr28328780oab.282.1667777105032; Sun, 06
 Nov 2022 15:25:05 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000bab2c05e95a81a3@google.com> <000000000000946f3005eca8cafe@google.com>
In-Reply-To: <000000000000946f3005eca8cafe@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 6 Nov 2022 15:24:53 -0800
Message-ID: <CACT4Y+bX40TE_rx0SFnixoQVd_vHuGih9mtJA4TB7-dDOeguew@mail.gmail.com>
Subject: Re: [syzbot] BUG: corrupted list in hci_conn_add_sysfs
To:     syzbot <syzbot+b30ccad4684cce846cef@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 at 10:56, syzbot
<syzbot+b30ccad4684cce846cef@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 448a496f760664d3e2e79466aa1787e6abc922b5
> Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Date:   Mon Sep 19 17:56:59 2022 +0000
>
>     Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1052f8fe880000
> start commit:   dc164f4fb00a Merge tag 'for-linus-6.0-rc7' of git://git.ke..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
> dashboard link: https://syzkaller.appspot.com/bug?extid=b30ccad4684cce846cef
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1110db8c880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e58aef080000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


Looks reasonable based on subsystem and the patch:

#syz fix: Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
