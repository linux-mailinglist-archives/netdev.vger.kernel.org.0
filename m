Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEC55740A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiFWHfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiFWHfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:35:15 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977046665
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:35:14 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id y22-20020a056602215600b00673b11a9cd5so718445ioy.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7QItAS8B1/7qL5yTPxj88y2NM1HLwSWmFz7/r/sTOpw=;
        b=7AaCYNqDrHhXoBsAQmc+NtbLsaoS4pIpMi7xNpfKQjumhwVWrHp++c5BapxIV4VYEq
         BAeSsW8TrOGqQjAMocJ6/SIg4XjlLuMcR1yTaOvuotrGSRD50ie7Z/UlDYQwhkhDD+8h
         +mPligA/XHRpSaPubc8Cn+Tg4XxdOc/JxoBREK5r5VQZKLpRyH2qBavJbrf51SItJ12n
         knRYPU26AVkBme4xKBdGdPwdq+skJYIkcvgoFYkGCgT17njuqcNBBr9OAvbCTQFCm2z1
         CdLwZpvXhC0dGZx/A2/aEJESS+kq2ukrNxX25/saOh40y6lXfr8VjJB35wL2qvXnkf2K
         NZvw==
X-Gm-Message-State: AJIora9XcAAyXCP+o6pe+IhidZYjELyuecoeo8jVYtNtBHO8V1fL4Vbs
        RmGmQIuLx/2eURVxvu+ve755xh1YYoMkgNSrgjnd0sureyUz
X-Google-Smtp-Source: AGRyM1uDHnpelBbH4pNfjqs05S1Tv86HE01S7bBLQKv9VdmULK/vAW25cGgGt/yXk/plAf0qQ01oPQbiNstvymQby6B/VLWIJO9i
MIME-Version: 1.0
X-Received: by 2002:a05:6638:38a0:b0:331:ec50:d191 with SMTP id
 b32-20020a05663838a000b00331ec50d191mr4517568jav.40.1655969713718; Thu, 23
 Jun 2022 00:35:13 -0700 (PDT)
Date:   Thu, 23 Jun 2022 00:35:13 -0700
In-Reply-To: <000000000000b9edeb05e1aca987@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008b8cd205e2187ea2@google.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage (5)
From:   syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com>
To:     alobakin@pm.me, bp@alien8.de, daniel@iogearbox.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, xuanzhuo@linux.alibaba.com
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

commit c2ff53d8049f30098153cd2d1299a44d7b124c57
Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Thu Feb 18 20:50:02 2021 +0000

    net: Add priv_flags for allow tx skb without linear

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11596838080000
start commit:   a5b00f5b78b7 Merge branch 'hns3-fixres'
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13596838080000
console output: https://syzkaller.appspot.com/x/log.txt?x=15596838080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
dashboard link: https://syzkaller.appspot.com/bug?extid=9cbc6bed3a22f1d37395
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b22abf00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125194eff00000

Reported-by: syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com
Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
