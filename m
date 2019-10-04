Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C76CBB1C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbfJDNAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:00:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfJDNAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6oMY2Xf4PcAVGvb/9bMHLxqJleYs+YlqxCz69/6OLTU=; b=Lb4pEcCpK1x1EAgp31OEmDMKSz
        1M/s9ssNAupizlQMUc5HalbgWpRcgFx13NETzTTnMUQZrFAFYC8tytfXytRSna0M6VLGHNR9q9pFN
        UhGYkLo+FTPxdwbHKzmnjyntolK1+WjA22ZYE9iZfPdFFtbALEj5gYGo7JLyA87NzlpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGNBy-00014o-Mx; Fri, 04 Oct 2019 15:00:18 +0200
Date:   Fri, 4 Oct 2019 15:00:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] mv88e6xxx: Allow config of ATU hash
 algorithm
Message-ID: <20191004130018.GB3817@lunn.ch>
References: <20191004013523.28306-1-andrew@lunn.ch>
 <CA+h21hq8G2fMZenAF_inYxQXePJe41Lk6U8AsJ-7e19YYTp7Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hq8G2fMZenAF_inYxQXePJe41Lk6U8AsJ-7e19YYTp7Wg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 11:44:02AM +0300, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Fri, 4 Oct 2019 at 10:55, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > The Marvell switches allow the hash algorithm for MAC addresses in the
> > address translation unit to be configured. Add support to the DSA core
> > to allow DSA drivers to make use of devlink parameters, and allow the
> > ATU hash to be get/set via such a parameter.
> >
> 
> What is the hash algorithm used by mv88e6xxx? In sja1105 it is simply
> crc32 over the {DMAC, VLAN} key, with a configurable polynomial
> (stored in Koopman notation, but that is maybe irrelevant).
> Are you really changing the algorithm, but only the hashing function's seed?
> If the sja1105 is in any way similar to mv88e6xxx, maybe it would make
> sense to devise a more generic devlink attribute?
> Also, I believe the hashing function is only relevant if the ATU's CAM
> is set- (not fully-) associative. Then it would make sense to maybe
> let the user know what the total number of FDB entries and buckets is?
> I am not clear even after looking at the mv88e6xxx_g1_atu_* functions.
> How would they know they need to change the hash function, and what to
> change it to?

Hi Vladimir

I have a second patchset which gives you an idea of the fill level. It
is documented that there are 4 buckets, and you can get the number of
buckets which are used at each level. The patch will also give the
total number of ATU entries.

The datasheet does not specify how the hashing is performed, just that
there are 4 possible configurations. We founds that the default
configuration does not work too well when all the equipment is from
one vendor, so the OUI is the same. By changing the algorithm we got a
better spread. Maybe it is giving more weight to the lower bits of the
MAC address?

Given the level of undocumented black magic, i don't know if we can do
a more generic configuration.

  Andrew
