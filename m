Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A718568C7AA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjBFUbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjBFUbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:31:19 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DD92A142
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 12:31:18 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id r18-20020a92d992000000b00313b6f93d45so4271025iln.9
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 12:31:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lcUfKfT8kk091mUeNDNyNXV+W/bZwlZUrmiavyzWKVE=;
        b=fCfxC1AYR4/WGG3N5tExkPEbznjLNMvt8ly+2l4kC8WvSZjAk9G1VYE3V9Nz4P28YF
         NhZ3WL6Zc+94qwYw84Vm2RyWUEhlU2a63QBDswmFpjB33eLX83IQYdl4s6X2/8bPuXpw
         i56SdRSADtfyZOhSxpxJ15dXD+eHaY66qLUEh2iAOJBTtvo04OR4X+JUaJgMcV7OqOWZ
         F6S/Q+sojnPOyk3eXZhVHv9datA3lAoFHc4b4BvG9t3EKS2Sw4+bPmCf7hSYYq2b+UP/
         c97bdE1/jTQDYvC15AoBQlzhXpp9UrAWyzBkCNSVP24ADEGGmZiePphWQUhaoCDiSJdz
         IgcA==
X-Gm-Message-State: AO0yUKUmPAxW5d0fGLoERx/ep9gwo7fKdIZY3TTyDDauqmrcCC2lcieL
        jNgC75SfmZwoOuxU5EiwgMzze+qz1Swb5x6fOPQ7C7tx/5QI
X-Google-Smtp-Source: AK7set/lIX/2jgf1OGRtFFrJw0DWyiffr52+TS2tT4qR8HmxfNuUDQY4i9GdUbMVWehVVSEfF9bkQInUujE4DKrS6Qceu8NmbEmm
MIME-Version: 1.0
X-Received: by 2002:a02:cccb:0:b0:3b1:acaf:d5b2 with SMTP id
 k11-20020a02cccb000000b003b1acafd5b2mr168551jaq.98.1675715477927; Mon, 06 Feb
 2023 12:31:17 -0800 (PST)
Date:   Mon, 06 Feb 2023 12:31:17 -0800
In-Reply-To: <000000000000269f9a05f02be9d8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce7ebf05f40de992@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in copy_verifier_state
From:   syzbot <syzbot+59af7bf76d795311da8c@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        keescook@chromium.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, sdf@google.com, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, v4bel@theori.io,
        yhs@fb.com
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

commit 45435d8da71f9f3e6860e6e6ea9667b6ec17ec64
Author: Kees Cook <keescook@chromium.org>
Date:   Fri Dec 23 18:28:44 2022 +0000

    bpf: Always use maximal size for copy_array()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c62f23480000
start commit:   041fae9c105a Merge tag 'f2fs-for-6.2-rc1' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2f3d9d232a3cac5
dashboard link: https://syzkaller.appspot.com/bug?extid=59af7bf76d795311da8c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1650d477880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1305f993880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bpf: Always use maximal size for copy_array()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
