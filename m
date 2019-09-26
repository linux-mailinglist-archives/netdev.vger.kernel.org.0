Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2DFBEC82
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfIZH0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:26:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfIZH0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:26:02 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C88221272A384;
        Thu, 26 Sep 2019 00:26:00 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:25:59 +0200 (CEST)
Message-Id: <20190926.092559.1616198841008311134.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, sd@queasysnail.net, pabeni@redhat.com
Subject: Re: [PATCH net] macsec: drop skb sk before calling
 gro_cells_receive
From:   David Miller <davem@davemloft.net>
In-Reply-To: <36f492a4977192dc4bc22a8c3bbfaf496ed89328.1569229366.git.lucien.xin@gmail.com>
References: <36f492a4977192dc4bc22a8c3bbfaf496ed89328.1569229366.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:26:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 23 Sep 2019 17:02:46 +0800

> Fei Liu reported a crash when doing netperf on a topo of macsec
> dev over veth:
 ...
> The issue was caused by skb's true_size changed without its sk's
> sk_wmem_alloc increased in tcp/skb_gro_receive(). Later when the
> skb is being freed and the skb's truesize is subtracted from its
> sk's sk_wmem_alloc in tcp_wfree(), underflow occurs.
> 
> macsec is calling gro_cells_receive() to receive a packet, which
> actually requires skb->sk to be NULL. However when macsec dev is
> over veth, it's possible the skb->sk is still set if the skb was
> not unshared or expanded from the peer veth.
> 
> ip_rcv() is calling skb_orphan() to drop the skb's sk for tproxy,
> but it is too late for macsec's calling gro_cells_receive(). So
> fix it by dropping the skb's sk earlier on rx path of macsec.
> 
> Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Reported-by: Fei Liu <feliu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
