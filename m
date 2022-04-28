Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507EF51327E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345529AbiD1LfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiD1LfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:35:21 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CF31DA46
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:32:07 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso4235416iov.16
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OLJAFGzDsMJJ4vQznge540lOuDzmbTYygXPQSl9cRbQ=;
        b=RgCAmGCdHLiNwVCJRrTTAd8BHZPjRuTjdMc2Ib80QLDqMGjhLRS4ihwg0KfYIPoS/u
         cMmMsNpbJM44+xHOgN9Q48k19HEzT3vU9r8MqoOAarcjTnptneZiaXeKNlS2t5jRgtch
         73T5KxD6WDZSupo8tUn5Xqr+PmA+zBrowkNz3TrTKywbVqZOOwnAsiHVMaiYmvegF9cF
         hxgxtH9YxLfIMtgXH/lTdSVm9rMvJ/Fahp0kjCoVTVA7FH4Wiew6kHo91b/2NasYW6y3
         QTVs0lCF3rUb6rR6WI4fmyi8+venBbNCIFr9nF2BZ6J7uSr1RgNv7PL6rWRiEPJD5Cgh
         auiw==
X-Gm-Message-State: AOAM530+AN09/NRzw7MZAkfEthG2KOqu4ZkA2ou7wB73izv2PORPfVwL
        q07VeFgUWb7j6qvKtYIcivNlpxaVsF9HPq8hdvknPQ1ewm70
X-Google-Smtp-Source: ABdhPJxAB0syNAAGUZ1g96hnh6vV4104IOqaj5OdTdHHn6UlNjjQtYhmf+CWQ5O28oTueITCCnG3U8t1lGf+LO7u83qZ5Ixvnhkl
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20eb:b0:2cd:83e9:b910 with SMTP id
 q11-20020a056e0220eb00b002cd83e9b910mr10188255ilv.185.1651145526916; Thu, 28
 Apr 2022 04:32:06 -0700 (PDT)
Date:   Thu, 28 Apr 2022 04:32:06 -0700
In-Reply-To: <000000000000af7f9905da904400@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009abe0e05ddb546f6@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in dst_destroy
From:   syzbot <syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, weiwan@google.com,
        yajun.deng@linux.dev
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

commit d16e6d19ccc6d3aa6b96d6a8fdb9e04fb9dffdbd
Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date:   Wed Oct 6 01:09:33 2021 +0000

    Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d40c1f700000
start commit:   03fa8fc93e44 Merge branch 'remove-virt_to_bus-drivers'
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16d40c1f700000
console output: https://syzkaller.appspot.com/x/log.txt?x=12d40c1f700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e95eee1a1aa4fb4
dashboard link: https://syzkaller.appspot.com/bug?extid=736f4a4f98b21dba48f0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1239a4e4f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a4b3b8f00000

Reported-by: syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com
Fixes: d16e6d19ccc6 ("Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
