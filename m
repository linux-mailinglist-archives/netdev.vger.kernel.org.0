Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563ABB3177
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfIOSux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:50:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfIOSux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:50:53 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83292153E82E2;
        Sun, 15 Sep 2019 11:50:51 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:50:49 +0100 (WEST)
Message-Id: <20190915.195049.1709278574899996404.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Fix load order between DSA drivers and
 taggers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912131645.24782-1-andrew@lunn.ch>
References: <20190912131645.24782-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:50:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 12 Sep 2019 15:16:45 +0200

> The DSA core, DSA taggers and DSA drivers all make use of
> module_init(). Hence they get initialised at device_initcall() time.
> The ordering is non-deterministic. It can be a DSA driver is bound to
> a device before the needed tag driver has been initialised, resulting
> in the message:
> 
> No tagger for this switch
> 
> Rather than have this be fatal, return -EPROBE_DEFER so that it is
> tried again later once all the needed drivers have been loaded.
> 
> Fixes: d3b8c04988ca ("dsa: Add boilerplate helper to register DSA tag driver modules")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> 
> I did wonder if we should play with the core and tag drivers and make
> them use subsystem_initcall(), but EPROBE_DEFER seems to be the more
> preferred solution nowadays.

Yes that does indeed seem preferable these days and all of the init
types is usually quite fragile.

Applied and queued up for v5.2 -stable.

Thanks.
