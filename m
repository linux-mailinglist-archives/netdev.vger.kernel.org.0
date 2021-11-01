Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C30441B32
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhKAMfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:35:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhKAMfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 08:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=QQpd4gj8vhmT9qQJtq2apZihJtjk5BMu+3btujgwhUo=; b=0G
        q0Ytnms8gpto8Im8cPpfoEwkj+jybiOr/nfMkB+WWfrQ4jhwe/2ZGmBfs5SH9hnOswGwj0VaTrDC5
        oIMe6e1mEpNBMzqlwGV8f72Ieb1z3E4ECzlSnYoRSBaiuI+kQzTyxmysumITlXMd0LXHq6EtNVUbG
        9IgM9FNHTFDYVEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhWTx-00CIkM-KT; Mon, 01 Nov 2021 13:32:09 +0100
Date:   Mon, 1 Nov 2021 13:32:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        hkallweit1@gmail.com, alexandr.lobakin@intel.com, saeed@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv3 PATCH net-next] net: extend netdev_features_t
Message-ID: <YX/eScgmGwDyalhA@lunn.ch>
References: <20211101010535.32575-1-shenjian15@huawei.com>
 <YX9RCqTOAHtiGD3n@lunn.ch>
 <0c45431b-ad76-87c6-c498-f19584ae6840@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c45431b-ad76-87c6-c498-f19584ae6840@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >   static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
> > > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> > > index 16f778887e14..9b3ab11e19c8 100644
> > > --- a/include/linux/netdev_features.h
> > > +++ b/include/linux/netdev_features.h
> > > @@ -101,12 +101,12 @@ enum {
> > >   typedef struct {
> > >   	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
> > > -} netdev_features_t;
> > > +} netdev_features_t;

> > That hunk looks odd.

> Yes, but it can be return directly, so we don't have to change
> the prototype of functions which return netdev_features_t,
> like  ndo_features_check.
> 
> > > -static inline void netdev_feature_zero(netdev_features_t *dst)
> > > +static inline void netdev_features_zero(netdev_features_t *dst)
> > >   {
> > >   	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
> > >   }
> > > -static inline void netdev_feature_fill(netdev_features_t *dst)
> > > +static inline void netdev_features_fill(netdev_features_t *dst)
> > >   {
> > >   	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
> > >   }
> > I'm wondering that the value here is? What do we gain by added the s.
> > These changes cause a lot of churn in the users of these functions.
> This function is used to expression like below:
> 
> "lowerdev_features &= (features | ~NETIF_F_LRO);"  in drivers/net/macvlan.c

O.K, now i know what is confusing me. This is not a patch on top of
clean net-next/master. It does not have netdev_features_t as a bitmap,
it does not have netdev_feature_fill().

You already have some other changes applied to your tree, and this
patch is on top of that?

I think we generally agree about the direction you are going. What we
probably want to see is a patchset against net-next/master which
converts the core and one driver to this new API. That allows us to
review the new API, which is the important thing here.

>  I prefered to rename the netdev field active_features .

O.K.

	Andrew
