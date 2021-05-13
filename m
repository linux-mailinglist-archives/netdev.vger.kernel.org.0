Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58B337FA94
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhEMPXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhEMPXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 11:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3684F61182;
        Thu, 13 May 2021 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620919344;
        bh=/M7gWU9HaLG6QbJqmridKAEJyvcI1IJcmogeYbUoJ+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iukByoWv+Aaq41EUuIYacG4iI7RjoJH+Dv+T3aIsAibxD6+BWgk/crbhd2LbCde7a
         lQJuVfSIJjjW+ha/iQ90zSXeJ24s6SuZdG4+KYs7mRYRuMVqUAw2zjZ5ddvv5ixI5c
         akmBnutSNwWueOUI9l5d+0c14qkd5ZK75Z2eJDUIDu/oI3G76zjdm5bL1QfZA+LvtR
         VwivSTFOzL3OanSzxBaJmVXsEPpXK87m5GbwriuVV7ClD48vvVyDjDXP5MsTCIfYli
         vV65c/PLopqhwV7E3xueEGqoiJ75yUY2i4tawdqBSK0g4AfKEVb6McH6ii7aXsRqLc
         +RBpqtIo2cf2w==
Date:   Thu, 13 May 2021 08:22:22 -0700
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
Subject: Re: [PATCH net v7 3/3] net: sched: fix tx action reschedule issue
 with stopped queue
Message-ID: <20210513082222.3b23d3a3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1620868260-32984-4-git-send-email-linyunsheng@huawei.com>
References: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
        <1620868260-32984-4-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 09:11:00 +0800 Yunsheng Lin wrote:
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
> As there is time window betewwn netif_xmit_frozen_or_stopped()
> checking and STATE_MISSED clearing, between which STATE_MISSED
> is set by net_tx_action() scheduled by netif_tx_wake_queue(),
> so set the STATE_MISSED again if netdev queue is restarted.
> 
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

> @@ -35,6 +35,25 @@
>  const struct Qdisc_ops *default_qdisc_ops = &pfifo_fast_ops;
>  EXPORT_SYMBOL(default_qdisc_ops);
>  
> +static void qdisc_maybe_stop_tx(struct Qdisc *q,

nit: qdisc_maybe_clear_missed()?
