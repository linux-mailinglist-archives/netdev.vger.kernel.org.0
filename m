Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FB358D312
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 07:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiHIFFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 01:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiHIFFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 01:05:18 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D7AD8D
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 22:05:15 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id p123-20020a6bbf81000000b00674f66cf13aso5752040iof.23
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 22:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=qUzj7rWhLGlDQzF8thFJBaPTyzvuhS4YOtcqLhUFOLs=;
        b=5DVcWuW1u5mKiReKbKAmzb+EKhGvx9wY3aRFPphZsGbM4S2L7E9/Y//fdFSaAxnD09
         vkjSTmoKn5ckAqSeBjLMBsbngjt7Duh4Itl57AijSMyOp3j8poopILmrBNKFN53Gfxvq
         gWpPgrLTFhzjyZ0+bQbYnA0tjlfqchVOixxtOAyNyeuIPX6fUm2lREz8dEKX+hjW7aKn
         OMOW5Y4Bn3WGMAtdQrgr/2yHSx5dPulnpYFwAfPXKH705ka/IK/X4z24/33qvOoYskxT
         nSj3VCuixCQVjFTMKZvKTgS4nc+gaUO7ZsdaIajaVwIKmlXpqHwuPqlpt+M3637CpsWQ
         xNAA==
X-Gm-Message-State: ACgBeo3+OVe03f/AzH3RJ3AAAyJyXBSCyMVbxIj10NF2stcNC9fDonbs
        uac/UGQ+605h8nmwz/7UqnvegLhBXs5Wf1jV0tOCFN8w2dj1
X-Google-Smtp-Source: AA6agR5aIg7EG5tXDrRBXY91bjwDVFTlTStKPPlUOZ01fdT3atbXH2xDpCmUABiiS8AOM2W3io5UvxFVHYr9g5xTSjShCrM8MkT7
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a41:b0:2de:e162:c5bb with SMTP id
 u1-20020a056e021a4100b002dee162c5bbmr9825959ilv.102.1660021515241; Mon, 08
 Aug 2022 22:05:15 -0700 (PDT)
Date:   Mon, 08 Aug 2022 22:05:15 -0700
In-Reply-To: <000000000000cad57405e5b5dbb7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc500505e5c7e01f@google.com>
Subject: Re: [syzbot] possible deadlock in p9_req_put
From:   syzbot <syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com>
To:     andrei.otcheretianski@intel.com, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        fgheet255t@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
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

commit 54283409cd162fc60480df514924ed4cb313735e
Author: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date:   Tue Jun 14 14:20:04 2022 +0000

    wifi: mac80211: Consider MLO links in offchannel logic

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1046e22a080000
start commit:   ca688bff68bc Add linux-next specific files for 20220808
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1246e22a080000
console output: https://syzkaller.appspot.com/x/log.txt?x=1446e22a080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c20e006003cdecb
dashboard link: https://syzkaller.appspot.com/bug?extid=50f7e8d06c3768dd97f3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f6ea66080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1640de8e080000

Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
Fixes: 54283409cd16 ("wifi: mac80211: Consider MLO links in offchannel logic")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
