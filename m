Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42C154470
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgBFNBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:01:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbgBFNBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:01:42 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EC7714C652DA;
        Thu,  6 Feb 2020 05:01:39 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:01:37 +0100 (CET)
Message-Id: <20200206.140137.826534991746807346.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, mohitbhasi1998@gmail.com,
        vsaicharan1998@gmail.com, lesliemonis@gmail.com,
        sdp.sachin@gmail.com, gautamramk@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] net: sched: prevent a use after free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205115330.7x2qgaks7racy5wj@kili.mountain>
References: <CAM_iQpVrckjFViizKZH+S=8GC_3T5Gm1vTAUeFkpmqJ_A66x1Q@mail.gmail.com>
        <20200205115330.7x2qgaks7racy5wj@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:01:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 5 Feb 2020 14:53:30 +0300

> The bug is that we call kfree_skb(skb) and then pass "skb" to
> qdisc_pkt_len(skb) on the next line, which is a use after free.
> Also Cong Wang points out that it's better to delay the actual
> frees until we drop the rtnl lock so we should use rtnl_kfree_skbs()
> instead of kfree_skb().
> 
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Use rtnl_kfree_skbs() instead of kfree_skb().  From static analysis.
>     Not tested, but I have audited the code pretty close and I think
>     switing to rtnl_kfree_skbs() is harmless.

Applied, thanks Dan.
