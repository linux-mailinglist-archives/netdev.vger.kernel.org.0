Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7722446DA4
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfFOBxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:53:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOBxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:53:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DB9212D69F7B;
        Fri, 14 Jun 2019 18:53:01 -0700 (PDT)
Date:   Fri, 14 Jun 2019 18:53:00 -0700 (PDT)
Message-Id: <20190614.185300.694618024091547290.davem@davemloft.net>
To:     edumazet@google.com
Cc:     willemb@google.com, maheshb@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/8] net/packet: better behavior under DDOS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 18:53:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 12 Jun 2019 09:52:25 -0700

> Using tcpdump (or other af_packet user) on a busy host can lead to
> catastrophic consequences, because suddenly, potentially all cpus
> are spinning on a contended spinlock.
> 
> Both packet_rcv() and tpacket_rcv() grab the spinlock
> to eventually find there is no room for an additional packet.
> 
> This patch series align packet_rcv() and tpacket_rcv() to both
> check if the queue is full before grabbing the spinlock.
> 
> If the queue is full, they both increment a new atomic counter
> placed on a separate cache line to let readers drain the queue faster.
> 
> There is still false sharing on this new atomic counter,
> we might in the future make it per cpu if there is interest.

Series applied.

