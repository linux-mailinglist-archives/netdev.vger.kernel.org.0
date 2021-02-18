Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C215931EAA0
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhBRN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:56:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231331AbhBRMy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 07:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613652781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAPWiMLdVgpL54iOswvuAK9eFuhy8zwjl8z04LgGsM0=;
        b=Q3DzArRYmty0FekwceP55r/OERcFfQ07OE8GOdmhWDgSjIjtgBk5XlQ8Sa8jHvCrDNq5l6
        nStT7WJ/DpqgCQm/aAJQVJWUwzsKJaDQ6NWeiQhpIUMgprAl9viYBizCkuGXRDg8oyAN1K
        zHsWeTaQ2WFuke50fmY1Bsc2fIny1YA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-iA1Zs0AHPcal5N-Lhv75GQ-1; Thu, 18 Feb 2021 07:41:54 -0500
X-MC-Unique: iA1Zs0AHPcal5N-Lhv75GQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F202AFA81;
        Thu, 18 Feb 2021 12:41:51 +0000 (UTC)
Received: from ovpn-114-233.ams2.redhat.com (ovpn-114-233.ams2.redhat.com [10.36.114.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D17CC6A03D;
        Thu, 18 Feb 2021 12:41:45 +0000 (UTC)
Message-ID: <639082dd7bddce31122200cc0e587c482379d1a7.camel@redhat.com>
Subject: Re: possible deadlock in mptcp_push_pending
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date:   Thu, 18 Feb 2021 13:41:44 +0100
In-Reply-To: <000000000000787b8805bb8b96ce@google.com>
References: <000000000000787b8805bb8b96ce@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-17 at 09:31 -0800, syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    c48f8607 Merge branch 'PTP-for-DSA-tag_ocelot_8021q'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16525cb0d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
> dashboard link: https://syzkaller.appspot.com/bug?extid=d1b1723faccb7a43f6d1
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-rc7-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.1/15600 is trying to acquire lock:
> ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
> ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp_push_pending+0x28b/0x650 net/mptcp/protocol.c:1466

Even this one is suspected to be a dup of 'WARNING in dst_release': the
subflow socket lock family is reported to be 'sk_lock-AF_INET6', but
subflows are created in kernel, and get 'k-sk_lock-AF_INET6'. This
looks like [re]use after free, likely via msk->first, as in the
suspected dup issue. Lacking a repro, I'm not 110% sure.

@Dmitry, I'm wondering which is the preferred course of action here:
tentatively marking this one as a dup, or leaving it alone till we get
a reproducer?

Thanks!

Paolo

