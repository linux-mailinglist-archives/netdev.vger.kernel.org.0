Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A716421234
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhJDPDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 11:03:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47770 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235478AbhJDPBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 11:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GkHKRHEmHDja7guXBn/eNKjPUR04IMGDIeI+lsv+15A=; b=X9e29i7U5mC2EpY49HFcwHxmR6
        PPGHz/ARZFVlnGAk1K8iOrWCCDmuMyiB4ieyqelN5qYS+BASqMSaz7iodpy58l3EUdg00TeSGpj3H
        xn5FcvFJew97xMlLj+viPK9QTzTGsam6b3RpBuhL+xj30b5vP9DT0rGWZCEntZBilKxI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXPR2-009YgQ-Ig; Mon, 04 Oct 2021 16:59:20 +0200
Date:   Mon, 4 Oct 2021 16:59:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Message-ID: <YVsWyO3Fa5RC0hRh@lunn.ch>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <20211001151710.20451-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001151710.20451-1-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 05:17:10PM +0200, Alexander Lobakin wrote:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Wed, 29 Sep 2021 23:50:47 +0800
> 
> Hi,
> 
> > For the prototype of netdev_features_t is u64, and the number
> > of netdevice feature bits is 64 now. So there is no space to
> > introduce new feature bit.
> > 
> > This patchset try to solve it by change the prototype of
> > netdev_features_t from u64 to bitmap. With this change,
> > it's necessary to introduce a set of bitmap operation helpers
> > for netdev features. Meanwhile, the functions which use
> > netdev_features_t as return value are also need to be changed,
> > return the result as an output parameter.
> > 
> > With above changes, it will affect hundreds of files, and all the
> > nic drivers. To make it easy to be reviewed, split the changes
> > to 167 patches to 5 parts.
> 
> If you leave the current feature field set (features, hw_features
> etc.) as is and just add new ones as bitmaps -- I mean, to place
> only newly added features there -- you won't have to change this in
> hundreds of drivers.

That makes things messy for the future. Two different ways to express
the same thing. And it is a trap waiting for developers to fall
into. Is this a new feature or an old feature bit? Should i add it to
the old or new bitmap? Will the compiler error out if i get it wrong,
or silently accept it?

> Another option is to introduce new fields as bitmaps and mirror all
> features there, but also keep the current ones. This implies some
> code duplication -- to keep both sets in sync -- but it will also
> allow to avoid such diffstats. Developers could switch their drivers
> one-by-one then, and once they finish converting,

Which will never happen. Most developers will say, why bother, it
works as it is, i'm too lazy. And many drivers don't have an active
developer, and so won't get converted.

Yes it is a big patchset, but at the end, we get a uniform API which
is future proof, and no traps waiting for developers to fall into.

   Andrew
