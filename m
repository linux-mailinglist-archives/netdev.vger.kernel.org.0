Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4D12F213
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgACATg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:19:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgACATg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:19:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 493581571F314;
        Thu,  2 Jan 2020 16:19:35 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:19:34 -0800 (PST)
Message-Id: <20200102.161934.1501839710048860065.davem@davemloft.net>
To:     ttttabcd@protonmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection
 requests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:19:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ttttabcd <ttttabcd@protonmail.com>
Date: Tue, 31 Dec 2019 01:21:47 +0000

> In the original logic of tcp_conn_request, the backlog parameter of the
> listen system call and net.ipv4.tcp_max_syn_backlog are independent of
> each other, which causes some confusion in the processing.
> 
> The backlog determines the maximum length of request_sock_queue, hereafter
> referred to as backlog.
> 
> In the original design, if syn_cookies is not turned on, a quarter of
> tcp_max_syn_backlog will be reserved for clients that have proven to
> exist, mitigating syn attacks.
> 
> Suppose now that tcp_max_syn_backlog is 1000, but the backlog is only 200,
> then 1000 >> 2 = 250, the backlog is used up by the syn attack, and the
> above mechanism will not work.
> 
> Is tcp_max_syn_backlog used to limit the
> maximum length of request_sock_queue?
> 
> Now suppose sycookie is enabled, backlog is 1000, and tcp_max_syn_backlog
> is only 200. In this case tcp_max_syn_backlog will be useless.
> 
> Because syn_cookies is enabled, the tcp_max_syn_backlog logic will
> be ignored, and the length of request_sock_queue will exceed
> tcp_max_syn_backlog until the backlog.
> 
> I modified the original logic and set the minimum value in backlog and
> tcp_max_syn_backlog as the maximum length limit of request_sock_queue.
> 
> Now there is only a unified limit.
> 
> The maximum length limit variable is "max_syn_backlog".
> 
> Use syn_cookies whenever max_syn_backlog is exceeded.
> 
> If syn_cookies is not enabled, a quarter of the max_syn_backlog queue is
> reserved for hosts that have proven to exist.
> 
> In any case, request_sock_queue will not exceed max_syn_backlog.
> When syn_cookies is not turned on, a quarter of the queue retention
> will not be preempted.
> 
> Signed-off-by: AK Deng <ttttabcd@protonmail.com>

On the surface this looks fine to me, but I'll give Eric a chance to
review and give feedback.

Thank you.
