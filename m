Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF4133CA19
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 00:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhCOXmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 19:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhCOXmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 19:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615851719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8p0ewYrXjBd6YhOPwSyL1Y4ews+TOxljgNaVhrVMaM=;
        b=Ki7g3NjLRwiBUF+9DutpoMziGys0uC7Jt/Yvtr3tTz+AqUrZ7oGL9B1OvhTkMvpWsheiO7
        8Ekfw90iFZo3P3g+rQrKg6dRzn4k3ilE+xZk7zOqEJ8H/FTBqqEN3df+pDFwnRr5wnSAOI
        vYb2MWcBbjQzGH+mneYDQyYYhRc2uNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-7lR3_wmhOPq1fU53TqAdDw-1; Mon, 15 Mar 2021 19:41:57 -0400
X-MC-Unique: 7lR3_wmhOPq1fU53TqAdDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70FF5100C619;
        Mon, 15 Mar 2021 23:41:55 +0000 (UTC)
Received: from localhost (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED3165B4A8;
        Mon, 15 Mar 2021 23:41:52 +0000 (UTC)
Date:   Mon, 15 Mar 2021 16:41:51 -0700 (PDT)
Message-Id: <20210315.164151.1093629330365238718.davem@redhat.com>
To:     linyunsheng@huawei.com
Cc:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
From:   David Miller <davem@redhat.com>
In-Reply-To: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Mon, 15 Mar 2021 17:30:10 +0800

> Currently qdisc_lock(q) is taken before enqueuing and dequeuing
> for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
> also taken, which can provide the same protection as qdisc_lock(q).
> 
> This patch removes the unnecessay qdisc_lock(q) protection for
> lockless qdisc' skb_bad_txq/gso_skb queue.
> 
> And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
> besides taking the qdisc_lock(q) when doing the qdisc reset,
> some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
> when checking qdisc status. It is unnecessary to take both lock
> while the fast path only take one lock, so this patch also changes
> it to only take qdisc_lock(q) for locked qdisc, and only take
> qdisc->seqlock for lockless qdisc.
> 
> Since qdisc->seqlock is taken for lockless qdisc when calling
> qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
> to decide if the lockless qdisc is running.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

What about other things protected by this lock, such as statistics and qlen?

This change looks too risky to me.

