Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB1C1DFB4B
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 00:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgEWWHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 18:07:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgEWWHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 18:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0TK5MmKYn5+XxQjFm2ZcAEYxJODgUuVlSgKNVIWlelg=; b=U+ECCzfrr5GlGnp3+qFA5qCwGh
        F6/x+t55V2gne2ChJHDxbip9rS/G8717Oonoi6z5AZFBcgO5SycL1DNo5EEuI8vrApvMaFtO0dDFj
        ItbLycYGZd/Pe2H3nMflntjo0wRgkidtQ85O74upuyvB8hajEFzZiFA/TguoBvbiersg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jccIv-0035cb-EF; Sun, 24 May 2020 00:07:41 +0200
Date:   Sun, 24 May 2020 00:07:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
Message-ID: <20200523220741.GO610998@lunn.ch>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
 <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
 <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
 <20200523150951.GK610998@lunn.ch>
 <a59412a5-7cc6-dc70-b851-c7d65c1635b7@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a59412a5-7cc6-dc70-b851-c7d65c1635b7@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Any why is your PHY special, in that is does care about out of range
> > delays, when others using new the new core helper don't?
> 
> We are not rounding to nearest here.  Basically the helper works to find the
> best match
> 
> If the delay passed in is less than or equal to the smallest delay then
> return the smallest delay index
> 
> If the delay passed in is greater then the largest delay then return the max
> delay index

+               /* Find an approximate index by looking up the table */
+               if (delay > delay_values[i - 1] &&
+                   delay < delay_values[i]) {
+                       if (delay - delay_values[i - 1] < delay_values[i] - delay)
+                               return i - 1;
+                       else
+                               return i;

This appears to round to the nearest value when it is not an exact
match.

The documentation is a hint to the DT developer what value to put in
DT. By saying it rounders, the developer does not need to go digging
through the source code to find an exact value, otherwise -EINVAL will
be returned. They can just use the value the HW engineer suggested,
and the PHY will pick whatever is nearest.

> Not sure what you mean about this PHY being special.  This helper is
> not PHY specific.

As you said, if out of range, the helper returns the top/bottom
value. Your PHY is special, the top/bottom value is not good enough,
you throw an error.

The point of helpers is to give uniform behaviour. We have one line
helpers, simply because they give uniform behaviour, rather than have
each driver do it subtlety different. But it also means drivers should
try to not add additional constraints over what the helper already
has, unless it is actually required by the hardware.

> After I think about this more I am thinking a helper may be over kill here
> and the delay to setting should be done within the PHY driver itself

The helper is useful, it will result in uniform handling of rounding
between DT values and what the PHY can actually do. But please also
move your range check and error message inside the helper.

     Andrew
