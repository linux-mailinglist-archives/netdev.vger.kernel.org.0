Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE43185DA1
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 15:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgCOOtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 10:49:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgCOOtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 10:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584283774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JPTZzaWSHWqaJnlfbIy3YcXZPQowucS73dRcL1UcEWw=;
        b=KLwBN3/1jLZatRBmMvHC8A7MAJayoE7b+OKl8hzHwKBgntTBlid1NjTT/Hx5V/GWJQgYVC
        esxL3MyZZHbL4ELs5LjLF1m/AtQxZVXUF1j28fFk2JwPVFP7SwWBZfUaFF5RVNzT3jexqJ
        lxI9Nuw5HBKcSlFeoyBePDJB70t9blM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-zedcxP_9NOyM7-3GxM1zkw-1; Sun, 15 Mar 2020 10:49:26 -0400
X-MC-Unique: zedcxP_9NOyM7-3GxM1zkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3228189D6C0;
        Sun, 15 Mar 2020 14:49:23 +0000 (UTC)
Received: from treble (ovpn-120-135.rdu2.redhat.com [10.10.120.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AB1491D92;
        Sun, 15 Mar 2020 14:49:21 +0000 (UTC)
Date:   Sun, 15 Mar 2020 09:49:19 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     syzbot <syzbot+2a3c14db0e17fe4c7409@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, peterz@infradead.org,
        shile.zhang@linux.alibaba.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: BUG: stack guard page was hit in deref_stack_reg
Message-ID: <20200315144919.y6r5sarg5m4s6wpw@treble>
References: <000000000000f5a6bf05a0ce0a95@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000f5a6bf05a0ce0a95@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 03:28:11AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    34a568a2 net: sgi: ioc3-eth: Remove phy workaround
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=103e69fde00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
> dashboard link: https://syzkaller.appspot.com/bug?extid=2a3c14db0e17fe4c7409
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2a3c14db0e17fe4c7409@syzkaller.appspotmail.com

This is a stack overflow caused by a recursive loop in the networking
code.  This chain repeats until it runs out of stack:

>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x6ee/0x930 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  netdev_features_change net/core/dev.c:1364 [inline]
>  netdev_update_features net/core/dev.c:9082 [inline]
>  netdev_update_features+0xc4/0xd0 net/core/dev.c:9079
>  netdev_sync_lower_features net/core/dev.c:8891 [inline]
>  __netdev_update_features+0x821/0x12f0 net/core/dev.c:9026
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9098
>  bond_compute_features.isra.0+0x521/0xa40 drivers/net/bonding/bond_main.c:1188

-- 
Josh

