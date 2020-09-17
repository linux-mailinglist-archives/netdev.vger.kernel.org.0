Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F7B26E98F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIQXlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:41:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B600BC06174A;
        Thu, 17 Sep 2020 16:41:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 478BA13662869;
        Thu, 17 Sep 2020 16:24:56 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:41:42 -0700 (PDT)
Message-Id: <20200917.164142.50960632445826777.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, khc@pm.waw.pl
Subject: Re: [PATCH net] drivers/net/wan/hdlc: Set skb->protocol before
 transmitting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916212507.528223-1-xie.he.0141@gmail.com>
References: <20200916212507.528223-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:24:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed, 16 Sep 2020 14:25:07 -0700

> This patch sets skb->protocol before transmitting frames on the HDLC
> device, so that a user listening on the HDLC device with an AF_PACKET
> socket will see outgoing frames' sll_protocol field correctly set and
> consistent with that of incoming frames.
> 
> 1. Control frames in hdlc_cisco and hdlc_ppp
> 
> When these drivers send control frames, skb->protocol is not set.
> 
> This value should be set to htons(ETH_P_HDLC), because when receiving
> control frames, their skb->protocol is set to htons(ETH_P_HDLC).
> 
> When receiving, hdlc_type_trans in hdlc.h is called, which then calls
> cisco_type_trans or ppp_type_trans. The skb->protocol of control frames
> is set to htons(ETH_P_HDLC) so that the control frames can be received
> by hdlc_rcv in hdlc.c, which calls cisco_rx or ppp_rx to process the
> control frames.
> 
> 2. hdlc_fr
> 
> When this driver sends control frames, skb->protocol is set to internal
> values used in this driver.
> 
> When this driver sends data frames (from upper stacked PVC devices),
> skb->protocol is the same as that of the user data packet being sent on
> the upper PVC device (for normal PVC devices), or is htons(ETH_P_802_3)
> (for Ethernet-emulating PVC devices).
> 
> However, skb->protocol for both control frames and data frames should be
> set to htons(ETH_P_HDLC), because when receiving, all frames received on
> the HDLC device will have their skb->protocol set to htons(ETH_P_HDLC).
> 
> When receiving, hdlc_type_trans in hdlc.h is called, and because this
> driver doesn't provide a type_trans function in struct hdlc_proto,
> all frames will have their skb->protocol set to htons(ETH_P_HDLC).
> The frames are then received by hdlc_rcv in hdlc.c, which calls fr_rx
> to process the frames (control frames are consumed and data frames
> are re-received on upper PVC devices).
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
