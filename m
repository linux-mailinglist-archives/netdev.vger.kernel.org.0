Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC6280C06
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387577AbgJBBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387496AbgJBBgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:36:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE165C0613D0;
        Thu,  1 Oct 2020 18:36:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 432DD1285CF4B;
        Thu,  1 Oct 2020 18:19:54 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:36:37 -0700 (PDT)
Message-Id: <20201001.183637.2225096830955902572.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, khc@pm.waw.pl
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Correctly handle
 special skb->protocol values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928125643.396575-1-xie.he.0141@gmail.com>
References: <20200928125643.396575-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:19:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Mon, 28 Sep 2020 05:56:43 -0700

> The fr_hard_header function is used to prepend the header to skbs before
> transmission. It is used in 3 situations:
> 1) When a control packet is generated internally in this driver;
> 2) When a user sends an skb on an Ethernet-emulating PVC device;
> 3) When a user sends an skb on a normal PVC device.
> 
> These 3 situations need to be handled differently by fr_hard_header.
> Different headers should be prepended to the skb in different situations.
> 
> Currently fr_hard_header distinguishes these 3 situations using
> skb->protocol. For situation 1 and 2, a special skb->protocol value
> will be assigned before calling fr_hard_header, so that it can recognize
> these 2 situations. All skb->protocol values other than these special ones
> are treated by fr_hard_header as situation 3.
> 
> However, it is possible that in situation 3, the user sends an skb with
> one of the special skb->protocol values. In this case, fr_hard_header
> would incorrectly treat it as situation 1 or 2.
> 
> This patch tries to solve this issue by using skb->dev instead of
> skb->protocol to distinguish between these 3 situations. For situation
> 1, skb->dev would be NULL; for situation 2, skb->dev->type would be
> ARPHRD_ETHER; and for situation 3, skb->dev->type would be ARPHRD_DLCI.
> 
> This way fr_hard_header would be able to distinguish these 3 situations
> correctly regardless what skb->protocol value the user tries to use in
> situation 3.
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
