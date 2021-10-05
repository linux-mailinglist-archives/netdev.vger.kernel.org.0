Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA69422AF9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhJEO11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:27:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:64964 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhJEO10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:27:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10128"; a="225697603"
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="225697603"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 07:23:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="567668957"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 05 Oct 2021 07:23:04 -0700
Received: from alobakin-mobl.ger.corp.intel.com (tmaksymc-MOBL1.ger.corp.intel.com [10.213.3.130])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 195EN2hK013921;
        Tue, 5 Oct 2021 15:23:02 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Date:   Tue,  5 Oct 2021 16:22:58 +0200
Message-Id: <20211005142258.557-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <b335852ecaba3c86d1745b5021bb500798fc843b.camel@kernel.org>
References: <20210929155334.12454-1-shenjian15@huawei.com> <20211001151710.20451-1-alexandr.lobakin@intel.com> <YVsWyO3Fa5RC0hRh@lunn.ch> <b335852ecaba3c86d1745b5021bb500798fc843b.camel@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Mon, 04 Oct 2021 15:30:21 -0700

> On Mon, 2021-10-04 at 16:59 +0200, Andrew Lunn wrote:
> > On Fri, Oct 01, 2021 at 05:17:10PM +0200, Alexander Lobakin wrote:
> > > From: Jian Shen <shenjian15@huawei.com>
> > > Date: Wed, 29 Sep 2021 23:50:47 +0800
> > >
> > > Hi,
> > >
> > > > For the prototype of netdev_features_t is u64, and the number
> > > > of netdevice feature bits is 64 now. So there is no space to
> > > > introduce new feature bit.
> > > >
> > > > This patchset try to solve it by change the prototype of
> > > > netdev_features_t from u64 to bitmap. With this change,
> > > > it's necessary to introduce a set of bitmap operation helpers
> > > > for netdev features. Meanwhile, the functions which use
> > > > netdev_features_t as return value are also need to be changed,
> > > > return the result as an output parameter.
> > > >
> > > > With above changes, it will affect hundreds of files, and all the
> > > > nic drivers. To make it easy to be reviewed, split the changes
> > > > to 167 patches to 5 parts.
> > >
> > > If you leave the current feature field set (features, hw_features
> > > etc.) as is and just add new ones as bitmaps -- I mean, to place
> > > only newly added features there -- you won't have to change this in
> > > hundreds of drivers.
> >
> > That makes things messy for the future. Two different ways to express
> > the same thing. And it is a trap waiting for developers to fall
> > into. Is this a new feature or an old feature bit? Should i add it to
> > the old or new bitmap? Will the compiler error out if i get it wrong,
> > or silently accept it?
> >
> > > Another option is to introduce new fields as bitmaps and mirror all
> > > features there, but also keep the current ones. This implies some
> > > code duplication -- to keep both sets in sync -- but it will also
> > > allow to avoid such diffstats. Developers could switch their
> > > drivers
> > > one-by-one then, and once they finish converting,
> >
> > Which will never happen. Most developers will say, why bother, it
> > works as it is, i'm too lazy. And many drivers don't have an active
> > developer, and so won't get converted.
> >
> > Yes it is a big patchset, but at the end, we get a uniform API which
> > is future proof, and no traps waiting for developers to fall into.
> >
>
> I agree, i had to visit this topic a year ago or so, and the only
> conclusion was is to solve this the hard way, introduce a totally new
> mechanism, the safest way is to remove old netdev_features_t fields
> from netdev and add new ones (both names and types), so compiler will
> catch you if you missed to convert a place.

Makes sense! I'm more a fan of "total conversions" rather than
keeping both old/new, just wasn't sure about how long it would
take to collect acks. On the other hand, there is probably no
need to wait for every single driver team: no real logic changes,
sole convertion stuff to bitmaps.

Anyway, we ran out of bits for both netdev_features_t and
priv_flags, so such changes need to be done.

> maybe hide the implementation details and abstract it away from drivers
> using getters and manipulation APIs, it is not that bad since drivers
> are already not supposed to modify netdev_features directly.

That can also be actual, the only thing is that we need to wrap only
basic access to netdev_features_t type itself as we have a set of
fields (hw, vlan, gso etc.) to work with.

> > Andrew

Thanks,
Al
