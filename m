Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99035D951
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfGCAkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:40:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfGCAkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:40:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C010813EA68A8;
        Tue,  2 Jul 2019 14:03:58 -0700 (PDT)
Date:   Tue, 02 Jul 2019 14:03:58 -0700 (PDT)
Message-Id: <20190702.140358.359909684176639832.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net-next] af_packet: convert pending frame counter to
 atomic_t
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628145206.13871-1-nhorman@tuxdriver.com>
References: <20190628145206.13871-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 14:03:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 28 Jun 2019 10:52:06 -0400

> Given that the socket transmit path is an exclusive path (locked via the
> pg_vec_lock mutex), we do not have the ability to increment this counter
> on multiple cpus in parallel.  This implementation also seems to have
> the potential to be broken, in that, should an skb be freed on a cpu
> other than the one that it was initially transmitted on, we may
> decrement a counter that was not initially incremented, leading to
> underflow.

This isn't a problem.  There is only one valid "read" operation and that
is the "summation" of all of the per-cpu counters.

All of the overflows and underflows cancel out in the situation you
describe, so all is fine.

I'm hesitant to get behind any fiddling in this area.

Thanks Neil.
