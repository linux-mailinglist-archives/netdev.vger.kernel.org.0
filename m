Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287CE14A138
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgA0Jx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:53:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgA0Jx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:53:28 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 702971502D65D;
        Mon, 27 Jan 2020 01:53:26 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:53:24 +0100 (CET)
Message-Id: <20200127.105324.147634448385166681.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: walk through all child classes in
 tc_bind_tclass()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124012708.29366-1-xiyou.wangcong@gmail.com>
References: <20200124012708.29366-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:53:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 23 Jan 2020 17:27:08 -0800

> In a complex TC class hierarchy like this:
> 
> tc qdisc add dev eth0 root handle 1:0 cbq bandwidth 100Mbit         \
>   avpkt 1000 cell 8
> tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 100Mbit  \
>   rate 6Mbit weight 0.6Mbit prio 8 allot 1514 cell 8 maxburst 20      \
>   avpkt 1000 bounded
> 
> tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
>   sport 80 0xffff flowid 1:3
> tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
>   sport 25 0xffff flowid 1:4
> 
> tc class add dev eth0 parent 1:1 classid 1:3 cbq bandwidth 100Mbit  \
>   rate 5Mbit weight 0.5Mbit prio 5 allot 1514 cell 8 maxburst 20      \
>   avpkt 1000
> tc class add dev eth0 parent 1:1 classid 1:4 cbq bandwidth 100Mbit  \
>   rate 3Mbit weight 0.3Mbit prio 5 allot 1514 cell 8 maxburst 20      \
>   avpkt 1000
> 
> where filters are installed on qdisc 1:0, so we can't merely
> search from class 1:1 when creating class 1:3 and class 1:4. We have
> to walk through all the child classes of the direct parent qdisc.
> Otherwise we would miss filters those need reverse binding.
> 
> Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
