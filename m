Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1022B6F806
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 05:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfGVDmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 23:42:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfGVDmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 23:42:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2B0A14EC8269;
        Sun, 21 Jul 2019 20:42:13 -0700 (PDT)
Date:   Sun, 21 Jul 2019 20:42:10 -0700 (PDT)
Message-Id: <20190721.204210.539463810722664682.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, aprout@ll.mit.edu,
        jonathan.lemon@gmail.com, mkubecek@suse.cz, ncardwell@google.com,
        ycheng@google.com, cpaasch@apple.com, jtl@netflix.com
Subject: Re: [PATCH net] tcp: be more careful in tcp_fragment()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719185233.242049-1-edumazet@google.com>
References: <20190719185233.242049-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 20:42:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 19 Jul 2019 11:52:33 -0700

> Some applications set tiny SO_SNDBUF values and expect
> TCP to just work. Recent patches to address CVE-2019-11478
> broke them in case of losses, since retransmits might
> be prevented.
> 
> We should allow these flows to make progress.
> 
> This patch allows the first and last skb in retransmit queue
> to be split even if memory limits are hit.
> 
> It also adds the some room due to the fact that tcp_sendmsg()
> and tcp_sendpage() might overshoot sk_wmem_queued by about one full
> TSO skb (64KB size). Note this allowance was already present
> in stable backports for kernels < 4.15
> 
> Note for < 4.15 backports :
>  tcp_rtx_queue_tail() will probably look like :
> 
> static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> {
> 	struct sk_buff *skb = tcp_send_head(sk);
> 
> 	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> }
> 
> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Andrew Prout <aprout@ll.mit.edu>
> Tested-by: Andrew Prout <aprout@ll.mit.edu>
> Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Tested-by: Michal Kubecek <mkubecek@suse.cz>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Christoph Paasch <cpaasch@apple.com>
> Cc: Jonathan Looney <jtl@netflix.com>

Applied and queued up for -stable.
