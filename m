Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C27CC6E8
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbfJEA2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:28:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60404 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEA2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:28:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90C6814F2D927;
        Fri,  4 Oct 2019 17:28:08 -0700 (PDT)
Date:   Fri, 04 Oct 2019 17:28:08 -0700 (PDT)
Message-Id: <20191004.172808.542472286230604033.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, lbianconi@redhat.com, xmu@redhat.com
Subject: Re: [PATCH net] net: ipv4: avoid mixed n_redirects and rate_tokens
 usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <25ac83a5c5660b43a27712d692266cd97668a2e4.1570194598.git.pabeni@redhat.com>
References: <25ac83a5c5660b43a27712d692266cd97668a2e4.1570194598.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 17:28:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  4 Oct 2019 15:11:17 +0200

> Since commit c09551c6ff7f ("net: ipv4: use a dedicated counter
> for icmp_v4 redirect packets") we use 'n_redirects' to account
> for redirect packets, but we still use 'rate_tokens' to compute
> the redirect packets exponential backoff.
> 
> If the device sent to the relevant peer any ICMP error packet
> after sending a redirect, it will also update 'rate_token' according
> to the leaking bucket schema; typically 'rate_token' will raise
> above BITS_PER_LONG and the redirect packets backoff algorithm
> will produce undefined behavior.
> 
> Fix the issue using 'n_redirects' to compute the exponential backoff
> in ip_rt_send_redirect().
> 
> Note that we still clear rate_tokens after a redirect silence period,
> to avoid changing an established behaviour.
> 
> The root cause predates git history; before the mentioned commit in
> the critical scenario, the kernel stopped sending redirects, after
> the mentioned commit the behavior more randomic.
> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: c09551c6ff7f ("net: ipv4: use a dedicated counter for icmp_v4 redirect packets")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable.
