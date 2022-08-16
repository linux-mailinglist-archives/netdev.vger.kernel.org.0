Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DA6595529
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiHPI0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiHPI0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:26:01 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332D1405DF
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:58:09 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id e2-20020a056e020b2200b002e1a5b67e29so6523195ilu.11
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=lUHutYvTWkC02k1JHzLmqGKDgiRolEQq5obnJ8zZPao=;
        b=ezcQK9izqJ4YlW4Edeh5sDXCm8KSAyOq0hFI2vRH6N9NkHBb+pkQZOaC9NscpmuN7C
         Mmo3jk0ALfbdmUwfC6vwBIJOMlS6vVws2yb1Jdw7GSYIOfuOTMAUdMfNKCORgtgwWhIm
         jbjniofxLZel6nzj9p44+jzRka1ySYRvTCEGuY/ckMkG3wfn2cTTjVpGXD7S+lbYfiRy
         vj/Xlk/j2s/HQpN18sKjKJSeSB0sK3bpUFdn9eZ1r6O3P/xeCAvE40/YxUEPUCQSXbUs
         OmNaortWQOuaWb/B8sVYwMU5+c8hzrNjteDxpmresePVeiTgZlQQmvJBmlHZR7dnFhxv
         xndg==
X-Gm-Message-State: ACgBeo0jSgIyTf9huRPZmAmgPGpCMAT2CIXECRTn65H2aT9/3KqF/iRI
        1Pgi+F9uWw3CkeiYE00kEFqZDzZ8AU9um87vW2aATiG3ASBS
X-Google-Smtp-Source: AA6agR5xlqIUCDW7/LHVLDMOCEAifJLoInIbGB8XrCdW2sWYNDqAtG4CM3T91W0o7i7Os/k2xLXXOpNa8DlLGy4FJj8FrzXAZVhs
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194d:b0:2de:a54b:2e51 with SMTP id
 x13-20020a056e02194d00b002dea54b2e51mr8736771ilu.257.1660629488569; Mon, 15
 Aug 2022 22:58:08 -0700 (PDT)
Date:   Mon, 15 Aug 2022 22:58:08 -0700
In-Reply-To: <000000000000aaac8505dc135b07@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c518d505e6556ed8@google.com>
Subject: Re: BUG: corrupted list in insert_work
From:   syzbot <syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        brauner@kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        dvyukov@google.com, hannes@cmpxchg.org, hdanton@sina.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lizefan.x@bytedance.com, lkp@intel.com, lkp@lists.01.org,
        mkoutny@suse.com, netdev@vger.kernel.org, oliver.sang@intel.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com,
        syzkaller-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tj@kernel.org, yhs@fb.com
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

syzbot suspects this issue was fixed by commit:

commit d007f49ab789bee8ed76021830b49745d5feaf61
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 18 06:13:40 2022 +0000

    percpu_ref_init(): clean ->percpu_count_ref on failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c66b6b080000
start commit:   ebc9fb07d294 ANDROID: random: fix CRC issues with the merge
git tree:       android12-5.10-lts
kernel config:  https://syzkaller.appspot.com/x/.config?x=32c952ff4a8ff8c1
dashboard link: https://syzkaller.appspot.com/bug?extid=e42ae441c3b10acf9e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172a9074080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10456caa080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: percpu_ref_init(): clean ->percpu_count_ref on failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
