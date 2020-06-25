Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BE320A5A1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404326AbgFYTTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390764AbgFYTTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:19:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B889C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 12:19:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32BC0129D3684;
        Thu, 25 Jun 2020 12:19:39 -0700 (PDT)
Date:   Thu, 25 Jun 2020 12:19:38 -0700 (PDT)
Message-Id: <20200625.121938.828374998212486132.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: Re: [PATCH net-next] net: ethernet: fec: prevent tx starvation
 under high rx load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625085728.9869-1-tobias@waldekranz.com>
References: <20200625085728.9869-1-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 12:19:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Thu, 25 Jun 2020 10:57:28 +0200

> In the ISR, we poll the event register for the queues in need of
> service and then enter polled mode. After this point, the event
> register will never be read again until we exit polled mode.
> 
> In a scenario where a UDP flow is routed back out through the same
> interface, i.e. "router-on-a-stick" we'll typically only see an rx
> queue event initially. Once we start to process the incoming flow
> we'll be locked polled mode, but we'll never clean the tx rings since
> that event is never caught.
> 
> Eventually the netdev watchdog will trip, causing all buffers to be
> dropped and then the process starts over again.
> 
> By adding a poll of the active events at each NAPI call, we avoid the
> starvation.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

You're losing events, which is a bug.  Therefore this is a bug fix
which should be submitted to 'net' and an appropriate "Fixes: "
tag must be added to your commit message.

Thank you.
