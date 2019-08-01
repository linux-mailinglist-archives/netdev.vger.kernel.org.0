Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936587E091
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbfHAQvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 12:51:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfHAQvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 12:51:15 -0400
Received: from localhost (unknown [IPv6:2603:3004:624:eb00::2d06])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B958153F1035;
        Thu,  1 Aug 2019 09:51:15 -0700 (PDT)
Date:   Thu, 01 Aug 2019 12:51:14 -0400 (EDT)
Message-Id: <20190801.125114.1466241781699884892.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801090347.8258-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 09:51:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu,  1 Aug 2019 17:03:47 +0800

> When setting lots of multicast list on ibmveth, e.g. add 3000 membership on a
> multicast group, the following error message flushes our log file
> 
> 8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> ...
> 1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> 
> We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
> net_err_ratelimited() to avoid this issue. I don't use netdev_err_once() in
> case h_multicast_ctrl() return different lpar_rc types.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Let's work on fixing what causes this problem, or adding a retry
mechanism, rather than making the message less painful.

What is worse is that these failures are not in any way communicated
back up the callchain to show that the operation didn't complete
sucessfully.

This is a real mess in behavior and error handling, don't make it
worse please.
