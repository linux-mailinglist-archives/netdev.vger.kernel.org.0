Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B242A2CB1FB
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgLBBCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgLBBCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:02:50 -0500
Date:   Tue, 1 Dec 2020 17:02:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606870930;
        bh=Mv72xmaXHxFh/vs9C4SGslW+0sUCRt8DsIvueC3oBUE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ORH2QKT9gRngdorP8/A1YBUzIg9IS0y8kALeLgUbUvBR9YxmfYitypJSmWT9i4brV
         mPvu36aluu8pE6Auz3PPmEK0lUo+JbMA9L2CeFhBbaBLfoph/SWi0yCENumAFFqPmi
         ++hRvXidcIyBelzgDANGp9Pn9i/d1LSGQ8Z9h8bo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 1/6] s390/ctcm: Avoid temporary allocation of
 struct th_header and th_sweep.
Message-ID: <20201201170208.67ba8ac7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130100950.42051-2-jwi@linux.ibm.com>
References: <20201130100950.42051-1-jwi@linux.ibm.com>
        <20201130100950.42051-2-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 11:09:45 +0100 Julian Wiedmann wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The size of struct th_header is 8 byte and the size of struct th_sweep
> is 16 byte. The memory for is allocated, initialized, used and
> deallocated a few lines later.
> 
> It is more efficient to avoid the allocation/free dance and assign the
> values directly to skb's data part instead of using memcpy() for it.
> 
> Avoid an allocation of struct th_sweep/th_header and use the resulting
> skb pointer instead.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> [jwi: use skb_put_zero(), instead of skb_put() + memset to 0]
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Stuff like that is usually done when skb data cannot be assumed to be
aligned. I don't see where the skbs are allocated here, so fingers
crossed :)
