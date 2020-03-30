Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F119739D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgC3E6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:58:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgC3E6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:58:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52D3E15C5742A;
        Sun, 29 Mar 2020 21:58:21 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:58:20 -0700 (PDT)
Message-Id: <20200329.215820.1352705339130655350.davem@davemloft.net>
To:     hqjagain@gmail.com
Cc:     marcelo.leitner@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v6] sctp: fix refcount bug in sctp_wfree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327030751.19404-1-hqjagain@gmail.com>
References: <20200327030751.19404-1-hqjagain@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:58:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>
Date: Fri, 27 Mar 2020 11:07:51 +0800

> We should iterate over the datamsgs to move
> all chunks(skbs) to newsk.
> 
> The following case cause the bug:
> for the trouble SKB, it was in outq->transmitted list
> 
> sctp_outq_sack
>         sctp_check_transmitted
>                 SKB was moved to outq->sacked list
>         then throw away the sack queue
>                 SKB was deleted from outq->sacked
> (but it was held by datamsg at sctp_datamsg_to_asoc
> So, sctp_wfree was not called here)
> 
> then migrate happened
> 
>         sctp_for_each_tx_datachunk(
>         sctp_clear_owner_w);
>         sctp_assoc_migrate();
>         sctp_for_each_tx_datachunk(
>         sctp_set_owner_w);
> SKB was not in the outq, and was not changed to newsk
> 
> finally
> 
> __sctp_outq_teardown
>         sctp_chunk_put (for another skb)
>                 sctp_datamsg_put
>                         __kfree_skb(msg->frag_list)
>                                 sctp_wfree (for SKB)
> 	SKB->sk was still oldsk (skb->sk != asoc->base.sk).
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

Applied and queued up for -stable, thanks.
