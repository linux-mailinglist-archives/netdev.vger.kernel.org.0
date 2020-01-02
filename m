Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC4812EB86
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgABVty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:49:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgABVty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 16:49:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F5A715698398;
        Thu,  2 Jan 2020 13:49:53 -0800 (PST)
Date:   Thu, 02 Jan 2020 13:49:52 -0800 (PST)
Message-Id: <20200102.134952.739616655559887645.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Improvements to the DSA deferred xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227014208.7189-1-olteanv@gmail.com>
References: <20191227014208.7189-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 13:49:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 03:42:06 +0200

> The DSA deferred xmit mechanism is currently used by a single driver
> (sja1105) because the transmission of some operations requires SPI
> access in the fastpath.
> 
> This 2-patch series makes this mechanism better for everybody:
> 
> - For those who don't use it, thanks to one less assignment in the
>   hotpath
> - For those who do, by making its scheduling more amenable and moving it
>   outside the generic workqueue (since it still deals with packet
>   hotpath, after all)

Two comments about this patch series, I think it needs more work:

1) This adds the thread and the xmit queue but not code that actually
   uses it.  You really have to provide the support code in the driver
   at the same time you add the new facitlity so we can actually see
   how it'll be used.

2) Patch #1 talks about a tradeoff.  Replacing the CB initialization of
   the field skb_get().  But this skb_get() is an atomic operation and
   thus much more expensive for users of the deferred xmit scheme.

Thanks.
