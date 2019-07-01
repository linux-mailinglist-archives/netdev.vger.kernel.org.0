Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3B5C407
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGAT41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:56:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37668 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfGAT40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:56:26 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hi2PV-0006Ui-54; Mon, 01 Jul 2019 19:56:21 +0000
Date:   Mon, 1 Jul 2019 20:56:21 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: fix ntohs/htons sparse warnings
Message-ID: <20190701195621.GC17978@ZenIV.linux.org.uk>
References: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 09:35:28PM +0200, Heiner Kallweit wrote:
> Sparse complains about casting to/from restricted __be16. Fix this.

Fix what, exactly?  Force-cast is not a fix - it's "STFU, I know
better, it's really correct" to sparse.  Which may or may not
match the reality, but it definitely requires more in way of
commit message than "sparse says it's wrong; shut it up".

>  static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
> @@ -1537,7 +1537,7 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
>  
>  	if (opts2 & RxVlanTag)
>  		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> -				       ntohs(opts2 & 0xffff));
> +				       ntohs((__force __be16)(opts2 & 0xffff)));
>  }

Should that be ntohs at all?  What behaviour is correct on big-endian host?

AFAICS, in that code opts2 comes from little-endian 32bit.  It's converted to
host-endian, lower 16 bits (i.e. the first two octets in memory) are then
fed to ntohs.  Suppose we had in-core value stored as A0, A1, A2, A3.
On little-endian that code will yield A0 * 256 + A1, treated as host-endian.
On big-endian the same will yield A1 * 256 + A0.  Is that actually correct?

The code dealing with the value passed to __vlan_hwaccel_put_tag() as the
third argument treats it as a host-endian integer.  So... Has anyone
tested that code on b-e host?  Should that ntohs() actually be swab16(),
yielding (on any host) the same value we currently get for l-e hosts only?
