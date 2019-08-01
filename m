Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914997E54E
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389424AbfHAWUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:20:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730266AbfHAWUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 18:20:02 -0400
Received: from localhost (unknown [172.58.27.22])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C080D15434E4E;
        Thu,  1 Aug 2019 15:20:01 -0700 (PDT)
Date:   Thu, 01 Aug 2019 18:19:59 -0400 (EDT)
Message-Id: <20190801.181959.616930719935387626.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: reduce risk of wakeup queue starvation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564496598-5080-1-git-send-email-jon.maloy@ericsson.com>
References: <1564496598-5080-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 15:20:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 30 Jul 2019 16:23:18 +0200

> In commit 365ad353c256 ("tipc: reduce risk of user starvation during
> link congestion") we allowed senders to add exactly one list of extra
> buffers to the link backlog queues during link congestion (aka
> "oversubscription"). However, the criteria for when to stop adding
> wakeup messages to the input queue when the overload abates is
> inaccurate, and may cause starvation problems during very high load.
> 
> Currently, we stop adding wakeup messages after 10 total failed attempts
> where we find that there is no space left in the backlog queue for a
> certain importance level. The counter for this is accumulated across all
> levels, which may lead the algorithm to leave the loop prematurely,
> although there may still be plenty of space available at some levels.
> The result is sometimes that messages near the wakeup queue tail are not
> added to the input queue as they should be.
> 
> We now introduce a more exact algorithm, where we keep adding wakeup
> messages to a level as long as the backlog queue has free slots for
> the corresponding level, and stop at the moment there are no more such
> slots or when there are no more wakeup messages to dequeue.
> 
> Fixes: 365ad35 ("tipc: reduce risk of user starvation during link congestion")
> Reported-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied, thank you.
