Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BDD12D626
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfLaE3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:29:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaE3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:29:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 607EA13EF0998;
        Mon, 30 Dec 2019 20:29:47 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:29:46 -0800 (PST)
Message-Id: <20191230.202946.2283077363010869071.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     edumazet@google.com, ycheng@google.com, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227085237.7295-1-cambda@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:29:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Fri, 27 Dec 2019 16:52:37 +0800

> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
> setting tp->highest_sack to the head of the send queue was removed.
> Of course the logic is error prone, but it is logical. Before we
> remove the pointer to the highest sack skb and use the seq instead,
> we need to set tp->highest_sack to NULL when there is no skb after
> the last sack, and then replace NULL with the real skb when new skb
> inserted into the rtx queue, because the NULL means the highest sack
> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
> the next ACK with sack option will increase tp->reordering unexpectedly.
> 
> This patch sets tp->highest_sack to the tail of the rtx queue if
> it's NULL and new data is sent. The patch keeps the rule that the
> highest_sack can only be maintained by sack processing, except for
> this only case.
> 
> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Applied and queued up for -stable, thanks.
