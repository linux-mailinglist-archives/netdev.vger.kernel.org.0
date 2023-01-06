Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F14660584
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbjAFRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbjAFRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:18:30 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6421A806
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:18:29 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id be25-20020a056602379900b006f166af94d6so1096463iob.8
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 09:18:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNubMI1GatQvLGtaWUgQht+S/ChcWAcDTlFlP/zM3lw=;
        b=08Ntxm9JjflLchLndDExNBzPsZadSEozqyj8T4R3LZ4JHbnDCrxKda7gU7sn6DzB9d
         5eGB4fujdo8HT6oIiWc2zN+4Dg2Txh2bf2bB89KEEjYIEv0oUmzlqaj3SfU/LuoNJn2Z
         Ef1xtAzGXwToIouirYGoF/JZ10J2Jn8U6UhYqMD5mWHFRiKbEWCu431l7/9wVsFKzEFD
         EWvhmB9Cf8UAkv5y1o3z/rW0uIXLPUCwbX8+lniQOvWcMY3UTb+EPknkbhfylEmc7WaK
         /EpwtdOdr9JWtlNMKGOKUESBbLteUGg3bHP//j9xbLO4eLHMjY5RPbYklOGpB7SU78bk
         Z6ug==
X-Gm-Message-State: AFqh2kqw9ri2m2eXl9CCSqR1nz3pdxRBhRX/9Mbjt4OAiqI/lBVYILHz
        kkxzDIrKcB7I37UaI9chBF32noyhiJkVToep91XoRJpNXgpU
X-Google-Smtp-Source: AMrXdXsC4+9DIJj/3HSQrpzNWCyl6PVy0sO43QtssChaZWPBo2v+DiTAj5KrRFuPHZIJNFMRYRhQQO79CuInadAneRX5Eo4M6ZNg
MIME-Version: 1.0
X-Received: by 2002:a92:c984:0:b0:304:a7a2:6878 with SMTP id
 y4-20020a92c984000000b00304a7a26878mr5636073iln.206.1673025508785; Fri, 06
 Jan 2023 09:18:28 -0800 (PST)
Date:   Fri, 06 Jan 2023 09:18:28 -0800
In-Reply-To: <783988.1673005658@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026c40c05f19b9b69@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_peer
From:   syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in corrupted

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5540 } 2684 jiffies s: 2885 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         9e80802b rxrpc: TEST: Remove almost all use of RCU
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=1587a762480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=affadc28955d87c3
dashboard link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
