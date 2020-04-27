Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA91BAC67
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgD0SXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725995AbgD0SXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:23:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00E5C0610D5;
        Mon, 27 Apr 2020 11:23:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 496C715D53D2D;
        Mon, 27 Apr 2020 11:23:11 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:23:10 -0700 (PDT)
Message-Id: <20200427.112310.1116562235104207694.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu, tanxin.ctf@gmail.com
Subject: Re: [PATCH] net/tls: Fix sk_psock refcnt leak when in
 tls_data_ready()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587820223-40918-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587820223-40918-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:23:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Sat, 25 Apr 2020 21:10:23 +0800

> tls_data_ready() invokes sk_psock_get(), which returns a reference of
> the specified sk_psock object to "psock" with increased refcnt.
> 
> When tls_data_ready() returns, local variable "psock" becomes invalid,
> so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one exception handling path of
> tls_data_ready(). When "psock->ingress_msg" is empty but "psock" is not
> NULL, the function forgets to decrease the refcnt increased by
> sk_psock_get(), causing a refcnt leak.
> 
> Fix this issue by calling sk_psock_put() on all paths when "psock" is
> not NULL.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable.
