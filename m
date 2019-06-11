Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A23D5B0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfFKSoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:44:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389600AbfFKSoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:44:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B34DE15259C97;
        Tue, 11 Jun 2019 11:44:08 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:44:08 -0700 (PDT)
Message-Id: <20190611.114408.1066206492769692313.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: correct udp zerocopy refcnt also when
 zerocopy only on append
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607215748.146484-1-willemdebruijn.kernel@gmail.com>
References: <20190607215748.146484-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:44:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri,  7 Jun 2019 17:57:48 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> The below patch fixes an incorrect zerocopy refcnt increment when
> appending with MSG_MORE to an existing zerocopy udp skb.
> 
>   send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt 1
>   send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt still 1 (bar frags)
> 
> But it missed that zerocopy need not be passed at the first send. The
> right test whether the uarg is newly allocated and thus has extra
> refcnt 1 is not !skb, but !skb_zcopy.
> 
>   send(.., MSG_MORE);			// <no uarg>
>   send(.., MSG_ZEROCOPY);		// refcnt 1
> 
> Fixes: 100f6d8e09905 ("net: correct zerocopy refcnt with udp MSG_MORE")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thanks Willem.
