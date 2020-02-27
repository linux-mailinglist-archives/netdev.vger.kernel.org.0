Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA06170FCC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgB0ErR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:47:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0ErQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:47:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 822FF15B47C83;
        Wed, 26 Feb 2020 20:47:16 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:47:16 -0800 (PST)
Message-Id: <20200226.204716.756773371437694239.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] mptcp: update mptcp ack sequence outside
 of recv path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:47:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 26 Feb 2020 10:14:45 +0100

> This series moves mptcp-level ack sequence update outside of the recvmsg path.
> Current approach has two problems:
> 
> 1. There is delay between arrival of new data and the time we can ack
>    this data.
> 2. If userspace doesn't call recv for some time, mptcp ack_seq is not
>    updated at all, even if this data is queued in the subflow socket
>    receive queue.
> 
> Move skbs from the subflow socket receive queue to the mptcp-level
> receive queue, updating the mptcp-level ack sequence and have recv
> take skbs from the mptcp-level receive queue.
> 
> The first place where we will attempt to update the mptcp level acks
> is from the subflows' data_ready callback, even before we make userspace
> aware of new data.
> 
> Because of possible deadlock (we need to take the mptcp socket lock
> while already holding the subflow sockets lock), we may still need to
> defer the mptcp-level ack update.  In such case, this work will be either
> done from work queue or recv path, depending on which runs sooner.
> 
> In order to avoid pointless scheduling of the work queue, work
> will be queued from the mptcp sockets lock release callback.
> This allows to detect when the socket owner did drain the subflow
> socket receive queue.
> 
> Please see individual patches for more information.

Series applied, thanks Florian.
