Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3430129849
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391219AbfEXMus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 08:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390781AbfEXMus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 08:50:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B34683F4C;
        Fri, 24 May 2019 12:50:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29BB063F7C;
        Fri, 24 May 2019 12:50:46 +0000 (UTC)
Message-ID: <1d96f8253ade31028489351fbfacedfc12cdae39.camel@redhat.com>
Subject: Re: [PATCH net-next] udp: Avoid post-GRO UDP checksum recalculation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sean Tranchetti <stranche@codeaurora.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Fri, 24 May 2019 14:50:45 +0200
In-Reply-To: <1558640177-10984-1-git-send-email-stranche@codeaurora.org>
References: <1558640177-10984-1-git-send-email-stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 24 May 2019 12:50:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-23 at 13:36 -0600, Sean Tranchetti wrote:
> Currently, when resegmenting an unexpected UDP GRO packet, the full UDP
> checksum will be calculated for every new SKB created by skb_segment()
> because the netdev features passed in by udp_rcv_segment() lack any
> information about checksum offload capabilities.
> 
> We have no need to perform this calculation again, as
>   1) The GRO implementation guarantees that any packets making it to the
>      udp_rcv_segment() function had correct checksums, and, more
>      importantly,
>   2) Upon the successful return of udp_rcv_segment(), we immediately pull
>      the UDP header off and either queue the segment to the socket or
>      hand it off to a new protocol handler. In either case, the checksum
>      is not needed.

I *think* there is a possible, even if unlikely, exception to the
above: if userspace has set the IP_CHECKSUM sockopt, recvmsg can later
try to access skb csum.

I think that setting NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM only if
!inet_get_convert_csum() would address the above,

Other than that LGTM, thanks for catching this!

Paolo

p.s. I suspect that with this patch GRO + resegmentation is notably
faster than the plain unaggregated path, do you have by chance any
related datapoint?

