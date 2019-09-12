Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC942B0D4E
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbfILK4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:56:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730680AbfILK4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:56:37 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C213128F385C;
        Thu, 12 Sep 2019 03:56:34 -0700 (PDT)
Date:   Thu, 12 Sep 2019 12:56:32 +0200 (CEST)
Message-Id: <20190912.125632.1276632741198765477.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     dlezcano@fr.ibm.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, stranche@codeaurora.org
Subject: Re: [PATCH net] net: Fix null de-reference of device refcount
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568145777-29480-1-git-send-email-subashab@codeaurora.org>
References: <1568145777-29480-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 03:56:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Tue, 10 Sep 2019 14:02:57 -0600

> In event of failure during register_netdevice, free_netdev is
> invoked immediately. free_netdev assumes that all the netdevice
> refcounts have been dropped prior to it being called and as a
> result frees and clears out the refcount pointer.
> 
> However, this is not necessarily true as some of the operations
> in the NETDEV_UNREGISTER notifier handlers queue RCU callbacks for
> invocation after a grace period. The IPv4 callback in_dev_rcu_put
> tries to access the refcount after free_netdev is called which
> leads to a null de-reference-
 ...
> Fix this by waiting for the completion of the call_rcu() in
> case of register_netdevice errors.
> 
> Fixes: 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev failure.")
> Cc: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied and queued up for -stable.
