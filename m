Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0451E18A4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbgEZBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbgEZBA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:00:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6F7C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 18:00:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEEF9119480FF;
        Mon, 25 May 2020 18:00:25 -0700 (PDT)
Date:   Mon, 25 May 2020 18:00:24 -0700 (PDT)
Message-Id: <20200525.180024.261815334954697599.davem@davemloft.net>
To:     bpoirier@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        edumazet@google.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: Avoid spurious rx_dropped increases with
 tap and rx_handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
References: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:00:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@cumulusnetworks.com>
Date: Mon, 25 May 2020 14:01:37 +0900

> Consider an skb which doesn't match a ptype_base/ptype_specific handler. If
> this skb is delivered to a ptype_all handler, it does not count as a drop.
> However, if the skb is also processed by an rx_handler which returns
> RX_HANDLER_PASS, the frame is now counted as a drop because pt_prev was
> reset. An example of this situation is an LLDP frame received on a bridge
> port while lldpd is listening on a packet socket with ETH_P_ALL (ex. by
> specifying `lldpd -c`).
> 
> Fix by adding an extra condition variable to record if the skb was
> delivered to a packet tap before running an rx_handler.
> 
> The situation is similar for RX_HANDLER_EXACT frames so their accounting is
> also changed. OTOH, the behavior is unchanged for RX_HANDLER_ANOTHER frames
> - they are accounted according to what happens with the new skb->dev.
> 
> Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")
> Message-Id: <20200522011420.263574-1-bpoirier@cumulusnetworks.com>
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>

You can state over and over about the semantics of PASS and other
rx_handler return values, but as Eric pointed out we free this SKB
so the counter should be bumped.

I'm sorry if it is confusing, but the counter is counting the event
accurately.

If you can make that kfree_skb() not happen, then maybe it shouldn't
be incremented.  But until then...

I'm not applying this, sorry.
