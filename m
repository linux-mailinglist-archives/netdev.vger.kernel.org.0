Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78C2E6BF0
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgL1Wzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44328 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbgL1WwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 17:52:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AC5C04CE686D1;
        Mon, 28 Dec 2020 14:51:28 -0800 (PST)
Date:   Mon, 28 Dec 2020 14:51:28 -0800 (PST)
Message-Id: <20201228.145128.1498314185351532341.davem@davemloft.net>
To:     weichen.chen@linux.alibaba.com
Cc:     eric.dumazet@gmail.com, kuba@kernel.org,
        splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        dsahern@kernel.org, liuhangbin@gmail.com,
        roopa@cumulusnetworks.com, jdike@akamai.com,
        nikolay@cumulusnetworks.com, lirongqing@baidu.com,
        mrv@mojatatu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: neighbor: fix a crash caused by mod zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201225054448.73256-1-weichen.chen@linux.alibaba.com>
References: <dbc6cd85-c58b-add2-5801-06e8e94b7d6b@gmail.com>
        <20201225054448.73256-1-weichen.chen@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 14:51:29 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: weichenchen <weichen.chen@linux.alibaba.com>
Date: Fri, 25 Dec 2020 13:44:45 +0800

> pneigh_enqueue() tries to obtain a random delay by mod
> NEIGH_VAR(p, PROXY_DELAY). However, NEIGH_VAR(p, PROXY_DELAY)
> migth be zero at that point because someone could write zero
> to /proc/sys/net/ipv4/neigh/[device]/proxy_delay after the
> callers check it.
> 
> This patch uses prandom_u32_max() to get a random delay instead
> which avoids potential division by zero.
> 
> Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>
> ---
> V4:
>     - Use prandom_u32_max() to get a random delay in
>       pneigh_enqueue().
> V3:
>     - Callers need to pass the delay time to pneigh_enqueue()
>       now and they should guarantee it is not zero.
>     - Use READ_ONCE() to read NEIGH_VAR(p, PROXY_DELAY) in both
>       of the existing callers of pneigh_enqueue() and then pass
>       it to pneigh_enqueue().
> V2:
>     - Use READ_ONCE() to prevent the complier from re-reading
>       NEIGH_VAR(p, PROXY_DELAY).
>     - Give a hint to the complier that delay <= 0 is unlikely
>       to happen.
> 
> V4 is quite concise and works well.
> Thanks for Eric's and Jakub's advice.

Applied and queued up for -stable, thanks.
