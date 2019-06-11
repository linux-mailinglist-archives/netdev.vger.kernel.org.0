Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABCA3D68E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407071AbfFKTQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:16:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404789AbfFKTQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:16:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2076D1525DA02;
        Tue, 11 Jun 2019 12:16:02 -0700 (PDT)
Date:   Tue, 11 Jun 2019 12:16:01 -0700 (PDT)
Message-Id: <20190611.121601.1611337978166305865.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: add optional per socket transmit delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611030334.138942-1-edumazet@google.com>
References: <20190611030334.138942-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 12:16:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 10 Jun 2019 20:03:34 -0700

> This patchs adds TCP_TX_DELAY socket option, to set a delay in
> usec units.
> 
>   unsigned int tx_delay = 10000; /* 10 msec */
> 
>   setsockopt(fd, SOL_TCP, TCP_TX_DELAY, &tx_delay, sizeof(tx_delay));

I'm trying to think about what the implications are for allowing
arbitrary users to do this.

It allows a user to stuff a TCP cloned SKB in the queues for a certain
amount of time, and then multiply this by how big a send window the
user can create (this ramp up takes no time, as the TCP_TX_DELAY
option can be intentionally set only after the window is maxxed out)
and how many TCP flows the user can create.

Is this something worth considering?
