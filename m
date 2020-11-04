Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99412A6E67
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgKDT6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgKDT6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 14:58:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102C020759;
        Wed,  4 Nov 2020 19:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604519914;
        bh=7s3+Xan/mrMO6pSY3a53z9rKYVV5X/qFqEpR62+r+GQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GgFN9GBYSFhUpGq3g9LwsSTCag/f9Z4K3aT5b3sHzPvsNzxFrshArJxIuHtLfyrRL
         zxWRnEEhKHF7lH9RESfCq+qAl5ZfsC1X30urgi66WauWW1cxoDMpO6xPx/zOh17Zhq
         YURkosxM//WvH7wDjAtPXZ0N8gh0UKHY1lU0UcnM=
Date:   Wed, 4 Nov 2020 11:58:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v4 05/10] cxgb4/ch_ktls: creating skbs causes panic
Message-ID: <20201104115833.2ff3100a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a29b951d-1666-009a-9a4b-efa2ce8fd5ac@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
        <20201030180225.11089-6-rohitm@chelsio.com>
        <20201103124646.795b96eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a29b951d-1666-009a-9a4b-efa2ce8fd5ac@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 22:23:14 +0530 rohit maheshwari wrote:
> On 04/11/20 2:16 AM, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 23:32:20 +0530 Rohit Maheshwari wrote:  
> >> Creating SKB per tls record and freeing the original one causes
> >> panic. There will be race if connection reset is requested. By
> >> freeing original skb, refcnt will be decremented and that means,
> >> there is no pending record to send, and so tls_dev_del will be
> >> requested in control path while SKB of related connection is in
> >> queue.
> >>   Better approach is to use same SKB to send one record (partial
> >> data) at a time. We still have to create a new SKB when partial
> >> last part of a record is requested.
> >>   This fix introduces new API cxgb4_write_partial_sgl() to send
> >> partial part of skb. Present cxgb4_write_sgl can only provide
> >> feasibility to start from an offset which limits to header only
> >> and it can write sgls for the whole skb len. But this new API
> >> will help in both. It can start from any offset and can end
> >> writing in middle of the skb.  
> > You never replied to my question on v2.
> >
> > If the problem is that the socket gets freed, why don't you make the
> > new skb take a reference on the socket?
> >
> > 650 LoC is really a rather large fix.  
> This whole skb alloc and copy record frags was written under the
> assumption that there will be zero data copy (no linear skb was
> expected) but that isn't correct. Continuing with the same change
> requires more checks and will be more complicated. That's why I
> made this change. I think using same SKB to send out multiple
> records is better than allocating new SKB every time.

Bug fixes are not where code should be restructured.

Please produce a minimal fix.
