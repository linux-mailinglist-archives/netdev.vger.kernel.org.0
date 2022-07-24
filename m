Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214A557F52F
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiGXNRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 09:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiGXNRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 09:17:18 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851F0E097
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 06:17:17 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id g8-20020a92cda8000000b002dcbd57f808so5728771ild.4
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 06:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hjEUNMgdvQs7+SQfFq8IM6gLNyCL0JlcuMD7/mHIX5A=;
        b=jJ9gs2hd+n8MHg6FGW7J/FvbsgBWY7slpzkqfipYJP+8xlve9aIkjO/yBdYXJD0XuL
         cUBPsFajOiz3FHacpzEvL7eHaxt8495k0gqV0jOnvEyg8MYHuBBZzMjlpI87d089ECgj
         j6cVaak441Bf96Kyj+wnBdBcG/KYxnFpJuAIqMqnhzLicp4asHWhGDJPLiaW69Y5lkfW
         bGq29B96+Q1VW4PVud1vjE3AlWaPe62qC4HmDi3HZysviQFzKrjJcToDULrNQPu8uwww
         gAL/ZZhOQG87pKyydrQIaHhd4esX5cIVqUb0SUpBFlIOqbtH0MnrL2+opb1c2/GMpDk7
         ytew==
X-Gm-Message-State: AJIora878V3f1erZ435VwIX/MCecJVTPUcxdXVp/hl5KuWAHyhvgmke/
        rmXYn/lxuMTD7r3t7gsbVsty6/BSzI43KGQchv/Psngpk2u0
X-Google-Smtp-Source: AGRyM1u73sB/d40+FJtdvxjS5zQsJTrRiTiu0Z8RQGmxOnP1tvrQ7TjhLqZC76uGpi9cdO/lQahHFSbrR4hSNom7Q5/LF/pUMjbT
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c45:b0:2dc:dc24:c103 with SMTP id
 d5-20020a056e021c4500b002dcdc24c103mr3199320ilg.132.1658668636866; Sun, 24
 Jul 2022 06:17:16 -0700 (PDT)
Date:   Sun, 24 Jul 2022 06:17:16 -0700
In-Reply-To: <00000000000011f0c905d9097a62@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6917605e48ce2bf@google.com>
Subject: Re: [syzbot] WARNING in p9_client_destroy
From:   syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, elver@google.com,
        ericvh@gmail.com, hdanton@sina.com, k.kahurani@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, rientjes@google.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, vbabka@suse.cz
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

syzbot has bisected this issue to:

commit 7302e91f39a81a9c2efcf4bc5749d18128366945
Author: Marco Elver <elver@google.com>
Date:   Fri Jan 14 22:03:58 2022 +0000

    mm/slab_common: use WARN() if cache still has objects on destroy

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=142882ce080000
start commit:   cb71b93c2dc3 Add linux-next specific files for 20220628
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=162882ce080000
console output: https://syzkaller.appspot.com/x/log.txt?x=122882ce080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
dashboard link: https://syzkaller.appspot.com/bug?extid=5e28cdb7ebd0f2389ca4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156f74ee080000

Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com
Fixes: 7302e91f39a8 ("mm/slab_common: use WARN() if cache still has objects on destroy")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
