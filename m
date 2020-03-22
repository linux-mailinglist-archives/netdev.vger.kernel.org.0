Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B885218E631
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCVDGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:06:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgCVDGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:06:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5337F15AC0C33;
        Sat, 21 Mar 2020 20:06:35 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:06:34 -0700 (PDT)
Message-Id: <20200321.200634.534398039682553516.davem@davemloft.net>
To:     kyk.segfault@gmail.com
Cc:     David.Laight@aculab.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v3] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584434318-27980-1-git-send-email-kyk.segfault@gmail.com>
References: <20200313.110542.570427563998639331.davem@davemloft.net>
        <1584434318-27980-1-git-send-email-kyk.segfault@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:06:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yadu Kishore <kyk.segfault@gmail.com>
Date: Tue, 17 Mar 2020 14:08:38 +0530

> 
>> I think you can rebase and submit against net-next.
> 
>> If your patch isn't active in the networking development patchwork instance,
>> it is not pending to be applied and you must resend it.
> 
> Rebasing the patch on net-next and resending it.
> 
> Problem:
> TCP checksum in the output path is not being offloaded during GSO
> in the following case:
> The network driver does not support scatter-gather but supports
> checksum offload with NETIF_F_HW_CSUM.
> 
> Cause:
> skb_segment calls skb_copy_and_csum_bits if the network driver
> does not announce NETIF_F_SG. It does not check if the driver
> supports NETIF_F_HW_CSUM.
> So for devices which might want to offload checksum but do not support SG
> there is currently no way to do so if GSO is enabled.
> 
> Solution:
> In skb_segment check if the network controller does checksum and if so
> call skb_copy_bits instead of skb_copy_and_csum_bits.
> 
> Testing:
> Without the patch, ran iperf TCP traffic with NETIF_F_HW_CSUM enabled
> in the network driver. Observed the TCP checksum offload is not happening
> since the skbs received by the driver in the output path have
> skb->ip_summed set to CHECKSUM_NONE.
> 
> With the patch ran iperf TCP traffic and observed that TCP checksum
> is being offloaded with skb->ip_summed set to CHECKSUM_PARTIAL.
> Also tested with the patch by disabling NETIF_F_HW_CSUM in the driver
> to cover the newly introduced if-else code path in skb_segment.
> 
> Link: https://lore.kernel.org/netdev/CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com
> Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>

Willem, please review and ACK/NACK.

Thank you.
