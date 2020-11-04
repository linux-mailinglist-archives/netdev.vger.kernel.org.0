Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1A2A6E7A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 21:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgKDUDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 15:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgKDUDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 15:03:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2FB20739;
        Wed,  4 Nov 2020 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604520221;
        bh=oVi4BnpoAQsCqQI96Ue3SNgLKrABybpx8jyo2qzhN3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQJdZb1X79WT2t9qmyQRV6ZztyGibRyEDmwtcrrfgshPLmOqgytZon6i+0KU32VPK
         CszMmxa38zPIu3j+keJTA8quUGpJDTCM1J8s3suV95ltExlXC4UvU51WamV6fogAwQ
         ult7VQeR/do5eM2QP7EbnYRwzNt0Fa6zIYX6JC4U=
Date:   Wed, 4 Nov 2020 12:03:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     rohit maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v4 07/10] ch_ktls: packet handling prior to start marker
Message-ID: <20201104120339.2fa198e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b9ad82f8-be79-40fe-d782-8cbdd3b42020@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
        <20201030180225.11089-8-rohitm@chelsio.com>
        <20201103125147.565dbf0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b9ad82f8-be79-40fe-d782-8cbdd3b42020@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 22:48:22 +0530 rohit maheshwari wrote:
> On 04/11/20 2:21 AM, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 23:32:22 +0530 Rohit Maheshwari wrote:  
> >> There could be a case where ACK for tls exchanges prior to start
> >> marker is missed out, and by the time tls is offloaded. This pkt
> >> should not be discarded and handled carefully. It could be
> >> plaintext alone or plaintext + finish as well.  
> > By plaintext + finish you mean the start of offload falls in the middle
> > of a TCP skb? That should never happen. We force EOR when we turn on
> > TLS, so you should never see a TCP skb that needs to be half-encrypted.  
> This happens when re-transmission is issued on a high load system.
> First time CCS is and finished message comes to driver one by one.
> Problem is, if ACK is not received for both these packets, while
> sending for re-transmission, stack sends both these together. Now
> the start sequence number will be before the start marker record,
> but it also holds data for encryption. This is handled in this
> patch.
> Are you saying this should not happen?

Maybe Eric could help us out - Rohit says that the TCP stack is
generating skbs which straddle MSG_EOR on re-transmit. Can this 
happen / is it correct?
