Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962532764FE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgIXAV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIXAV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:21:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65290C0613CE;
        Wed, 23 Sep 2020 17:21:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17AAA11E49F6E;
        Wed, 23 Sep 2020 17:04:39 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:21:25 -0700 (PDT)
Message-Id: <20200923.172125.1341776337290371000.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     hkallweit1@gmail.com, geert+renesas@glider.be,
        f.fainelli@gmail.com, andrew@lunn.ch, kuba@kernel.org,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
References: <20200923.131529.637266321442993059.davem@davemloft.net>
        <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
        <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:04:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Wed, 23 Sep 2020 15:42:17 -0700

> Maybe we need to clear IFF_UP before calling ops->ndo_stop(dev),
> instead of after on __dev_close_many(). Assuming no driver is checking
> IFF_UP state on its own ndo_stop(), other than this, the order
> shouldn't really matter, since clearing the flag and calling ndo_stop()
> should be considered as one atomic operation.

This is my biggest concern, that some ndo_stop, or some helper called
by ndo_stop, checks IFF_UP or similar.

There is also something else.  We have both synchronous and async code
that checks state like IFF_UP and 'present' and makes a decision based
upon that.

If an async code path tests 'present', gets true, and then the RTNL
holding synchronous code path puts the device into D3hot immediately
afterwards, the async code path will still continue and access the
chips registers and fault.

I'm saying all of this because the only way this bug makes sense
is if the ->ndo_stop() sequence that marks the device !present and
then clears IFF_UP runs with the RTNL mutex held, and the code path
that tests this state in the linkwatch bits in question do not.
