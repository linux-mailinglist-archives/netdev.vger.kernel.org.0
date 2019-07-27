Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0356E77BC3
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbfG0USu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:18:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0USt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:18:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E73D11533D862;
        Sat, 27 Jul 2019 13:18:48 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:18:48 -0700 (PDT)
Message-Id: <20190727.131848.1034715270924665758.davem@davemloft.net>
To:     brodie.greenfield@alliedtelesis.co.nz
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz
Subject: Re: [PATCH 0/2] Make ipmr queue length configurable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:18:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
Date: Fri, 26 Jul 2019 08:42:28 +1200

> We want to have some more space in our queue for processing incoming
> multicast packets, so we can process more of them without dropping
> them prematurely. It is useful to be able to increase this limit on
> higher-spec platforms that can handle more items.
> 
> For the particular use case here at Allied Telesis, we have linux
> running on our switches and routers, with support for the number of
> multicast groups being increased. Basically, this queue length affects
> the time taken to fully learn all of the multicast streams. 
> 
> Changes in v3:
>  - Corrected a v4 to v6 typo.

As others have voiced, I think it's dangerous to let every netns
increase this so readily.

We need to either put in a non-initns limit or simply not allow
non-init namespaces to change this.

But really socket queue limits are a better place to enforce this.
