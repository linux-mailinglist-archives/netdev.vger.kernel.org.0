Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086766A81E4
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 13:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCBMGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 07:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCBMGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 07:06:30 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3123B3D4
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 04:06:29 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id i2-20020a5d9e42000000b0074cfcc4ed07so8166674ioi.22
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 04:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+vGFryJyHO/kcxpjviopstdV6X7mkFZpRf95EKbss4=;
        b=xQSm5SQTeVAjMi0M14h3ApvScQve6TvAx77WTEiWEBZlySrZ9jpupsXwDCruh/+33w
         CZeTkpG9MIhbNnzWmq+KqL0Bw+nXfBl3At7iWsQ8v9L6CnpTWnZGqfP4BOM4K9tbPDI2
         pIDI4wCphTL7pvQYZtV1R9Z9zmbbFPA6opqcyftxrck3RBavZs6bXrtm/eAQujcaKlic
         UuU1gHxw3r752grnKEbOqZBo28kMeNZtIjNW6otgjE4dXRvgbOHl+YBPM2blLIdZOL9L
         6llfGdkFOunhOvn6V7UXQ8nWUNtWtjAyscORxCi3DHHYFFSKfnKaCCSiPmkaM2k1TlV3
         fWHw==
X-Gm-Message-State: AO0yUKXvkDpkYDHQ1tgKSURNYETgLzyVO1kl2QSBftNPAGB1YEOb9Khp
        AkieWYHEkyH17MiXZ8x3Vx14qombNESTtBn+vtQx4JJy9Lhg
X-Google-Smtp-Source: AK7set86njqnlQ595UPhEtBjsAoU+5M3f42yKnl+lTOrhfk8tX5iXCF1LaW4id7AOPgZ9ZLcR5qAulh3/EHAi4uFzqSSok1mm5p4
MIME-Version: 1.0
X-Received: by 2002:a02:9465:0:b0:3e0:6875:f5e2 with SMTP id
 a92-20020a029465000000b003e06875f5e2mr4612504jai.6.1677758788383; Thu, 02 Mar
 2023 04:06:28 -0800 (PST)
Date:   Thu, 02 Mar 2023 04:06:28 -0800
In-Reply-To: <000000000000e794f505f5e0029c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099b9c905f5e9a820@google.com>
Subject: Re: [syzbot] [mm?] INFO: task hung in write_cache_pages (2)
From:   syzbot <syzbot+0adf31ecbba886ab504f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, dvyukov@google.com,
        edumazet@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, kasan-dev@googlegroups.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
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

commit 17bb55487988c5dac32d55a4f085e52f875f98cc
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Tue May 17 22:12:25 2022 +0000

    ntfs: Remove check for PageError

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13fd6e54c80000
start commit:   489fa31ea873 Merge branch 'work.misc' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10036e54c80000
console output: https://syzkaller.appspot.com/x/log.txt?x=17fd6e54c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbfa7a73c540248d
dashboard link: https://syzkaller.appspot.com/bug?extid=0adf31ecbba886ab504f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16dc6960c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f39d50c80000

Reported-by: syzbot+0adf31ecbba886ab504f@syzkaller.appspotmail.com
Fixes: 17bb55487988 ("ntfs: Remove check for PageError")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
