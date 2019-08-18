Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF78E9199E
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfHRVBX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Aug 2019 17:01:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHRVBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:01:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4033F1264DFDB;
        Sun, 18 Aug 2019 14:01:22 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:01:21 -0700 (PDT)
Message-Id: <20190818.140121.879479854866287427.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, lxin@redhat.com, shuali@redhat.com,
        ying.xue@windriver.com, edumazet@google.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v2 1/1] tipc: clean up skb list lock handling on
 send path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565880170-19548-1-git-send-email-jon.maloy@ericsson.com>
References: <1565880170-19548-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:01:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Thu, 15 Aug 2019 16:42:50 +0200

> The policy for handling the skb list locks on the send and receive paths
> is simple.
> 
> - On the send path we never need to grab the lock on the 'xmitq' list
>   when the destination is an exernal node.
> 
> - On the receive path we always need to grab the lock on the 'inputq'
>   list, irrespective of source node.
> 
> However, when transmitting node local messages those will eventually
> end up on the receive path of a local socket, meaning that the argument
> 'xmitq' in tipc_node_xmit() will become the 'ínputq' argument in  the
> function tipc_sk_rcv(). This has been handled by always initializing
> the spinlock of the 'xmitq' list at message creation, just in case it
> may end up on the receive path later, and despite knowing that the lock
> in most cases never will be used.
> 
> This approach is inaccurate and confusing, and has also concealed the
> fact that the stated 'no lock grabbing' policy for the send path is
> violated in some cases.
> 
> We now clean up this by never initializing the lock at message creation,
> instead doing this at the moment we find that the message actually will
> enter the receive path. At the same time we fix the four locations
> where we incorrectly access the spinlock on the send/error path.
> 
> This patch also reverts commit d12cffe9329f ("tipc: ensure head->lock
> is initialised") which has now become redundant.
> 
> CC: Eric Dumazet <edumazet@google.com>
> Reported-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
