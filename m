Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142D43018A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfE3SK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:10:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:10:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 995CA14D8ADBA;
        Thu, 30 May 2019 11:10:56 -0700 (PDT)
Date:   Thu, 30 May 2019 11:10:55 -0700 (PDT)
Message-Id: <20190530.111055.1432108566782886319.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, subashab@codeaurora.org
Subject: Re: [PATCH net-next v2] udp: Avoid post-GRO UDP checksum
 recalculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559067774-613-1-git-send-email-stranche@codeaurora.org>
References: <1559067774-613-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:10:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Tue, 28 May 2019 12:22:54 -0600

> Currently, when resegmenting an unexpected UDP GRO packet, the full UDP
> checksum will be calculated for every new SKB created by skb_segment()
> because the netdev features passed in by udp_rcv_segment() lack any
> information about checksum offload capabilities.
> 
> Usually, we have no need to perform this calculation again, as
>   1) The GRO implementation guarantees that any packets making it to the
>      udp_rcv_segment() function had correct checksums, and, more
>      importantly,
>   2) Upon the successful return of udp_rcv_segment(), we immediately pull
>      the UDP header off and either queue the segment to the socket or
>      hand it off to a new protocol handler.
> 
> Unless userspace has set the IP_CHECKSUM sockopt to indicate that they
> want the final checksum values, we can pass the needed netdev feature
> flags to __skb_gso_segment() to avoid checksumming each segment in
> skb_segment().
> 
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>

I've decided to apply this to 'net', thank you.
