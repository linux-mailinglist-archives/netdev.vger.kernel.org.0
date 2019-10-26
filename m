Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC4E5812
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfJZCZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:25:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfJZCZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 22:25:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1F8214B7272C;
        Fri, 25 Oct 2019 19:25:53 -0700 (PDT)
Date:   Fri, 25 Oct 2019 19:25:53 -0700 (PDT)
Message-Id: <20191025.192553.474380182181088667.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     edumazet@google.com, netdev@vger.kernel.org, ncardwell@google.com,
        cpaasch@apple.com, ycheng@google.com
Subject: Re: [net-next v2] tcp: add TCP_INFO status for failed client TFO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571843366-14691-1-git-send-email-jbaron@akamai.com>
References: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
        <1571843366-14691-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 19:25:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Wed, 23 Oct 2019 11:09:26 -0400

> The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
> or not data-in-SYN was ack'd on both the client and server side. We'd like
> to gather more information on the client-side in the failure case in order
> to indicate the reason for the failure. This can be useful for not only
> debugging TFO, but also for creating TFO socket policies. For example, if
> a middle box removes the TFO option or drops a data-in-SYN, we can
> can detect this case, and turn off TFO for these connections saving the
> extra retransmits.
> 
> The newly added tcpi_fastopen_client_fail status is 2 bits and has the
> following 4 states:
> 
> 1) TFO_STATUS_UNSPEC
> 
> Catch-all state which includes when TFO is disabled via black hole
> detection, which is indicated via LINUX_MIB_TCPFASTOPENBLACKHOLE.
> 
> 2) TFO_COOKIE_UNAVAILABLE
> 
> If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
> is available in the cache.
> 
> 3) TFO_DATA_NOT_ACKED
> 
> Data was sent with SYN, we received a SYN/ACK but it did not cover the data
> portion. Cookie is not accepted by server because the cookie may be invalid
> or the server may be overloaded.
> 
> 4) TFO_SYN_RETRANSMITTED
> 
> Data was sent with SYN, we received a SYN/ACK which did not cover the data
> after at least 1 additional SYN was sent (without data). It may be the case
> that a middle-box is dropping data-in-SYN packets. Thus, it would be more
> efficient to not use TFO on this connection to avoid extra retransmits
> during connection establishment.
> 
> These new fields do not cover all the cases where TFO may fail, but other
> failures, such as SYN/ACK + data being dropped, will result in the
> connection not becoming established. And a connection blackhole after
> session establishment shows up as a stalled connection.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Applied, thanks Jason.
