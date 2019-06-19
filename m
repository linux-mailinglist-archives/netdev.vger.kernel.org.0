Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157134C346
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfFSVsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:48:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSVsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 17:48:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 489BD30C0DC7;
        Wed, 19 Jun 2019 21:48:19 +0000 (UTC)
Received: from localhost (ovpn-112-10.rdu2.redhat.com [10.10.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10A551813B;
        Wed, 19 Jun 2019 21:48:17 +0000 (UTC)
Date:   Wed, 19 Jun 2019 17:48:17 -0400 (EDT)
Message-Id: <20190619.174817.1569045758201960209.davem@redhat.com>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, ycheng@google.com,
        ncardwell@google.com, soheil@google.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] inet: clear num_timeout reqsk_alloc()
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190619163838.150971-1-edumazet@google.com>
References: <20190619163838.150971-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 19 Jun 2019 21:48:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 19 Jun 2019 09:38:38 -0700

> KMSAN caught uninit-value in tcp_create_openreq_child() [1]
> This is caused by a recent change, combined by the fact
> that TCP cleared num_timeout, num_retrans and sk fields only
> when a request socket was about to be queued.
> 
> Under syncookie mode, a temporary request socket is used,
> and req->num_timeout could contain garbage.
> 
> Lets clear these three fields sooner, there is really no
> point trying to defer this and risk other bugs.
> 
> [1]
> 
> BUG: KMSAN: uninit-value in tcp_create_openreq_child+0x157f/0x1cc0 net/ipv4/tcp_minisocks.c:526
 ...
> Fixes: 336c39a03151 ("tcp: undo init congestion window on false SYNACK timeout")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.
