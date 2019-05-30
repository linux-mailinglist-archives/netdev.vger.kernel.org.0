Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E330505
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE3WzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:55:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3WzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:55:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 461D114DDDAF9;
        Thu, 30 May 2019 15:55:00 -0700 (PDT)
Date:   Thu, 30 May 2019 15:54:57 -0700 (PDT)
Message-Id: <20190530.155457.207974832129262644.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net v2] net: correct zerocopy refcnt with udp MSG_MORE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530220121.128798-1-willemdebruijn.kernel@gmail.com>
References: <20190530220121.128798-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 15:55:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 30 May 2019 18:01:21 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> TCP zerocopy takes a uarg reference for every skb, plus one for the
> tcp_sendmsg_locked datapath temporarily, to avoid reaching refcnt zero
> as it builds, sends and frees skbs inside its inner loop.
> 
> UDP and RAW zerocopy do not send inside the inner loop so do not need
> the extra sock_zerocopy_get + sock_zerocopy_put pair. Commit
> 52900d22288ed ("udp: elide zerocopy operation in hot path") introduced
> extra_uref to pass the initial reference taken in sock_zerocopy_alloc
> to the first generated skb.
> 
> But, sock_zerocopy_realloc takes this extra reference at the start of
> every call. With MSG_MORE, no new skb may be generated to attach the
> extra_uref to, so refcnt is incorrectly 2 with only one skb.
> 
> Do not take the extra ref if uarg && !tcp, which implies MSG_MORE.
> Update extra_uref accordingly.
> 
> This conditional assignment triggers a false positive may be used
> uninitialized warning, so have to initialize extra_uref at define.
> 
> Changes v1->v2: fix typo in Fixes SHA1
> 
> Fixes: 52900d22288e7 ("udp: elide zerocopy operation in hot path")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Diagnosed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks.
