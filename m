Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C530379E5D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhEKEXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhEKEXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 00:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9946191F;
        Tue, 11 May 2021 04:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620706954;
        bh=YwtDo3LeR3JmT4NhxeAjnRuwPnLFemK+gI6XznEvRuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qf5ZA9kI5amR23oIRR7F81z2D0LxmAnmoLwxO2OyLSFJFYWjuYQORJ2YWtTJmCpHJ
         iGoa6+lsQh291Chp3pTo125Jwjhu90Js32+fMFn+AqFywBpCnH/cCpnXhDqKnTqL5V
         xmj6ak1pAZnCPCqvWmm7ciI4MZUf7c0b72bDlvsnUPKXM1UvyDpYQFo28guHAF6ZKu
         oQL4xWvfOjssqtBBO8oaoCpkayKPK38sedLFCRLOjtRGkAAQkduELVY70xu3p0nwyO
         pp5/y9lh1kQ295Dvdl9pxry8WGlr3Wv4bAmGRc8+wm4lllYnXrgoW63BWBaQDnVo4L
         /VOv3PsisNa5g==
Date:   Mon, 10 May 2021 21:22:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [PATCH net v6 3/3] net: sched: fix tx action reschedule issue
 with stopped queue
Message-ID: <20210510212232.3386c5b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1620610956-56306-4-git-send-email-linyunsheng@huawei.com>
References: <1620610956-56306-1-git-send-email-linyunsheng@huawei.com>
        <1620610956-56306-4-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 09:42:36 +0800 Yunsheng Lin wrote:
> The netdev qeueue might be stopped when byte queue limit has
> reached or tx hw ring is full, net_tx_action() may still be
> rescheduled endlessly if STATE_MISSED is set, which consumes
> a lot of cpu without dequeuing and transmiting any skb because
> the netdev queue is stopped, see qdisc_run_end().
> 
> This patch fixes it by checking the netdev queue state before
> calling qdisc_run() and clearing STATE_MISSED if netdev queue is
> stopped during qdisc_run(), the net_tx_action() is recheduled
> again when netdev qeueue is restarted, see netif_tx_wake_queue().
> 
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Patches 1 and 2 look good to me but this one I'm not 100% sure.

> @@ -251,8 +253,10 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>  	*validate = true;
>  
>  	if ((q->flags & TCQ_F_ONETXQUEUE) &&
> -	    netif_xmit_frozen_or_stopped(txq))
> +	    netif_xmit_frozen_or_stopped(txq)) {
> +		clear_bit(__QDISC_STATE_MISSED, &q->state);
>  		return skb;
> +	}

The queues are woken asynchronously without holding any locks via
netif_tx_wake_queue(). Theoretically we can have a situation where:

CPU 0                            CPU 1   
  .                                .
dequeue_skb()                      .
  netif_xmit_frozen..() # true     .
  .                              [IRQ]
  .                              netif_tx_wake_queue()
  .                              <end of IRQ>
  .                              netif_tx_action()
  .                              set MISSED
  clear MISSED
  return NULL
ret from qdisc_restart()
ret from __qdisc_run()
qdisc_run_end()
-> MISSED not set
