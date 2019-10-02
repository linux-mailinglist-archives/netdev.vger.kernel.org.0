Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3798FC45B9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfJBBu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:50:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJBBu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:50:56 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E58B51530FB4F;
        Tue,  1 Oct 2019 18:50:54 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:50:54 -0400 (EDT)
Message-Id: <20191001.215054.2217306306286086981.davem@davemloft.net>
To:     dongli.zhang@oracle.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com
Subject: Re: [PATCH v2 1/1] xen-netfront: do not use ~0U as error return
 value for xennet_fill_frags()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569938201-23620-1-git-send-email-dongli.zhang@oracle.com>
References: <1569938201-23620-1-git-send-email-dongli.zhang@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:50:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>
Date: Tue,  1 Oct 2019 21:56:41 +0800

> xennet_fill_frags() uses ~0U as return value when the sk_buff is not able
> to cache extra fragments. This is incorrect because the return type of
> xennet_fill_frags() is RING_IDX and 0xffffffff is an expected value for
> ring buffer index.
> 
> In the situation when the rsp_cons is approaching 0xffffffff, the return
> value of xennet_fill_frags() may become 0xffffffff which xennet_poll() (the
> caller) would regard as error. As a result, queue->rx.rsp_cons is set
> incorrectly because it is updated only when there is error. If there is no
> error, xennet_poll() would be responsible to update queue->rx.rsp_cons.
> Finally, queue->rx.rsp_cons would point to the rx ring buffer entries whose
> queue->rx_skbs[i] and queue->grant_rx_ref[i] are already cleared to NULL.
> This leads to NULL pointer access in the next iteration to process rx ring
> buffer entries.
> 
> The symptom is similar to the one fixed in
> commit 00b368502d18 ("xen-netfront: do not assume sk_buff_head list is
> empty in error handling").
> 
> This patch changes the return type of xennet_fill_frags() to indicate
> whether it is successful or failed. The queue->rx.rsp_cons will be
> always updated inside this function.
> 
> Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Applied and queued up for -stable.
