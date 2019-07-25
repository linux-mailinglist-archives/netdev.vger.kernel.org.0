Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DCD75717
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfGYSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:39:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfGYSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:39:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85D01143750EF;
        Thu, 25 Jul 2019 11:39:15 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:39:15 -0700 (PDT)
Message-Id: <20190725.113915.1995894376660846014.davem@davemloft.net>
To:     abauvin@scaleway.com
Cc:     stephen@networkplumber.org, jasowang@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] tun: mark small packets as owned by the tap sock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723142301.39568-1-abauvin@scaleway.com>
References: <20190723142301.39568-1-abauvin@scaleway.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:39:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexis Bauvin <abauvin@scaleway.com>
Date: Tue, 23 Jul 2019 16:23:01 +0200

> - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
> 
> Small packets going out of a tap device go through an optimized code
> path that uses build_skb() rather than sock_alloc_send_pskb(). The
> latter calls skb_set_owner_w(), but the small packet code path does not.
> 
> The net effect is that small packets are not owned by the userland
> application's socket (e.g. QEMU), while large packets are.
> This can be seen with a TCP session, where packets are not owned when
> the window size is small enough (around PAGE_SIZE), while they are once
> the window grows (note that this requires the host to support virtio
> tso for the guest to offload segmentation).
> All this leads to inconsistent behaviour in the kernel, especially on
> netfilter modules that uses sk->socket (e.g. xt_owner).
> 
> Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
> Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")

Applied and queued up for -stable, thanks.
