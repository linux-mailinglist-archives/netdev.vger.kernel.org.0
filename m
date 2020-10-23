Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959A2975CC
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 19:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753472AbgJWRbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 13:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753457AbgJWRbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 13:31:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC4920EDD;
        Fri, 23 Oct 2020 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603474271;
        bh=5sJrPDSqlBqp4k079QLSvl4B+9r33Hetazy5nXQ2hfY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RY4KiNxZ+u9TS7Ur6zqq5ZIf/xYI65tdYeelwPgx0PwCRG3fnej4DEf0e8L48tPJm
         jf+DUNQTh1bNhRnuI/br5zPQ/xabXtS0vJtg99TKB12RsWLrhrRfnCGd9PlwsOjsWW
         yN1Vl4iGmt2uX7uTBwYDIM9u/VsRkQvS4uUq56xQ=
Date:   Fri, 23 Oct 2020 10:31:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
Message-ID: <20201023103110.3017f961@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAJht_EMuVzRSp+OmKFY0nPnkC0a39k93KQAeaOFghLBy6TXgiQ@mail.gmail.com>
References: <20201022072814.91560-1-xie.he.0141@gmail.com>
        <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
        <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com>
        <20201022174451.1cd858ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAJht_EOo50TxEUJmQMBBnaH4FW_2Afpcrr0pStFEXH1Bg3vteg@mail.gmail.com>
        <CAJht_EMuVzRSp+OmKFY0nPnkC0a39k93KQAeaOFghLBy6TXgiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 19:25:40 -0700 Xie He wrote:
> On Thu, Oct 22, 2020 at 6:56 PM Xie He <xie.he.0141@gmail.com> wrote:
> > My patch isn't complete. Because there are so many drivers with this
> > problem, I feel it's hard to solve them all at once. So I only grepped
> > "skb_padto" under "drivers/net/ethernet". There are other drivers
> > under "ethernet" using "skb_pad", "skb_put_padto" or "eth_skb_pad".
> > There are also (fake) Ethernet drivers under "drivers/net/wireless". I
> > feel it'd take a long time and also be error-prone to solve them all,
> > so I feel it'd be the best if there are other solutions.  
> 
> BTW, I also see some Ethernet drivers calling skb_push to prepend
> strange headers to the skbs. For example,
> 
> drivers/net/ethernet/mellanox/mlxsw/switchx2.c prepends a header of
> MLXSW_TXHDR_LEN (16).
> 
> We can't send shared skbs to these drivers either because they modify the skbs.
> 
> It seems to me that many drivers have always assumed that they can
> modify the skb whenever needed. They've never considered there might
> be shared skbs. I guess adding IFF_TX_SKB_SHARING to ether_setup was a
> bad idea. It not only made the code less clean, but also didn't agree
> with the actual situations of the drivers.

Indeed. If we remove IFF_TX_SKB_SHARING from ether_setup we may need to
add the flag to the drivers that used to work, otherwise people using
pktgen will see a regression.
