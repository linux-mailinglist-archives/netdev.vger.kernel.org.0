Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CF276504
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIXAXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:23:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F59C0613CE;
        Wed, 23 Sep 2020 17:23:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C51C11E442B7;
        Wed, 23 Sep 2020 17:07:03 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:23:49 -0700 (PDT)
Message-Id: <20200923.172349.872678515629678579.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     hkallweit1@gmail.com, geert+renesas@glider.be,
        f.fainelli@gmail.com, andrew@lunn.ch, kuba@kernel.org,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923.172125.1341776337290371000.davem@davemloft.net>
References: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
        <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
        <20200923.172125.1341776337290371000.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:07:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 23 Sep 2020 17:21:25 -0700 (PDT)

> If an async code path tests 'present', gets true, and then the RTNL
> holding synchronous code path puts the device into D3hot immediately
> afterwards, the async code path will still continue and access the
> chips registers and fault.

Wait, is the sequence:

	->ndo_stop()
		mark device not present and put into D3hot
		triggers linkwatch event
	  ...
			 ->ndo_get_stats64()

???

Then yeah we might have to clear IFF_UP at the beginning of taking
a netdev down.
