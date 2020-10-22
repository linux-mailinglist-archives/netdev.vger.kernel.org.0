Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD9296198
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 17:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901388AbgJVPWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 11:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895398AbgJVPWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 11:22:41 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B62208B8;
        Thu, 22 Oct 2020 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603380161;
        bh=Oi59GErF2Dk9QeTdJbv2Mt1P0TdyHr05cqU2Ha0Bz6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wfG2dLrDuO5jQzAdAmJMnRkju7aYmTs8W4SeuTCT7g2gDZ6BMElU7QrofGGL81OiI
         bsHabsBsD679lgYli9OJwM/pRT26o6VBSS/6oGafLl/sqOU53wb/N2X62ED+rxdXm/
         hHz+obL9q5ja820/p4Vd5qGHI0k8tJEMD1sl8dLk=
Date:   Thu, 22 Oct 2020 08:22:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
Message-ID: <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
References: <20201022072814.91560-1-xie.he.0141@gmail.com>
        <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 00:46:38 -0700 Xie He wrote:
> It was very hard for me to attempt fixing. There are too many drivers
> that need to be fixed. Fixing them is very time-consuming and may also
> be error-prone. So I think it may be better to just remove
> IFF_TX_SKB_SHARING from ether_setup. Drivers that support this feature
> should add this flag by themselves. This also makes our code cleaner.

Are most of these drivers using skb_padto()? Is that the reason they
can't be sharing the SKB?

I think the IFF_TX_SKB_SHARING flag is only used by pktgen, so perhaps
we can make sure pktgen doesn't generate skbs < dev->min_mtu, and then
the drivers won't pad?
