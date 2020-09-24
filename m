Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5B276B02
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgIXHke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:40:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44452 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIXHke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 03:40:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B34E42056D;
        Thu, 24 Sep 2020 09:40:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KxvJixmP7KwB; Thu, 24 Sep 2020 09:40:27 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DAC35201AA;
        Thu, 24 Sep 2020 09:40:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 24 Sep 2020 09:40:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 24 Sep
 2020 09:40:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 04C0C3180126;
 Thu, 24 Sep 2020 09:40:26 +0200 (CEST)
Date:   Thu, 24 Sep 2020 09:40:26 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
Message-ID: <20200924074026.GC20687@gauss3.secunet.de>
References: <0000000000009fc91605afd40d89@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0000000000009fc91605afd40d89@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:56:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eb5f95f1 Merge tag 's390-5.9-6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13996ad5900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ffe85b197a57c180
> dashboard link: https://syzkaller.appspot.com/bug?extid=577fbac3145a6eb2e7a5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in xfrm_flowi_dport include/net/xfrm.h:877 [inline]
> BUG: KASAN: stack-out-of-bounds in __xfrm6_selector_match net/xfrm/xfrm_policy.c:216 [inline]
> BUG: KASAN: stack-out-of-bounds in xfrm_selector_match+0xf36/0xf60 net/xfrm/xfrm_policy.c:229
> Read of size 2 at addr ffffc9001914f55c by task syz-executor.4/15633

This is yet another ipv4 mapped ipv6 address with IPsec socket policy
combination bug, and I'm sure it is not the last one. We could fix this
one by adding another check to match the address family of the policy
and the SA selector, but maybe it is better to think about how this
should work at all.

We can have only one socket policy for each direction and that
policy accepts either ipv4 or ipv6. We treat this ipv4 mapped ipv6
address as ipv4 and pass it down the ipv4 stack, so this dual usage
will not work with a socket policy. Maybe we can require IPV6_V6ONLY
for sockets with policy attached. Thoughts?

