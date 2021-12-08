Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFEF46D9DA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhLHRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:40:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49640 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhLHRkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:40:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB1E3B821C7
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 17:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B629C00446;
        Wed,  8 Dec 2021 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638984990;
        bh=NAtD6bwVVosuxl3bw7ZdkMJO7Btjdkm5Bw7DKrlul2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZeqG1tBWvH/3FkKA1NaAjVNVi1IElAJTYST4j8Ji2k8t7y8KbufRs7jZjsRmnrvOq
         sQthnxwv57vkd40tx+r0IVdBzTt/wCHZVLKhAkbAx5jfdYELevkfHIzXoczuJTD47k
         PFJwBXRpdZ2llR72CF34jJGm5X0VeuzceUlKPedCnmgHr4Rfry20fe5UISj9+nWghu
         tPlzBcqDiBRHbpRoYA1ZTTnUN4TcGonS6bD7SHxjYKHqTsnSyoljJGqG/A5BAZh2KO
         WDIDOgTPXmnfUiuIC+lNFASaXZe920kiukMBgG6gjSr8SgHR1Q4pY1p6/T+Vn+ECyJ
         ik2L8FCC0a9eA==
Date:   Wed, 8 Dec 2021 18:36:26 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208183626.4e475b0d@thinkpad>
In-Reply-To: <20211208171909.3hvre5blb734ueyu@skbuf>
References: <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <20211208172104.75e32a6b@thinkpad>
        <20211208164131.fy2h652sgyvhm7jx@skbuf>
        <20211208164932.6ojxt64j3v34477k@skbuf>
        <20211208180057.7fb10a17@thinkpad>
        <20211208171909.3hvre5blb734ueyu@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 19:19:09 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Dec 08, 2021 at 06:00:57PM +0100, Marek Beh=C3=BAn wrote:
> > > Also, maybe drop the "serdes-" prefix? The property will sit under a
> > > SERDES lane node, so it would be a bit redundant? =20
> >=20
> > Hmm. Holger's proposal adds the property into the port node, not SerDes
> > lane node. mv88e6xxx does not define bindings for SerDes lane nodes
> > (yet). =20
>=20
> We need to be careful about that. You're saying that there chances of
> there being a separate SERDES driver for mv88e6xxx in the future?

I don't think so. Although Russell is working on rewriting the SerDes
code to new Phylink API, the SerDes code will always be a part of
mv88e6xxx driver, I think.

But we already have bindings for internal PHYs on mv88e6xxx, so it
wouldn't be tough to add bindings for SerDeses. The question is whether
this is necessary, since the ports are coupled with their SerDeses in
HW, and the coupling cannot be changed.

But there are models, like 88E6390X, where a SerDes lane is shared
between multiple ports, for example lane 0x12 is shared between port 2
and port 9:
- either the lane can belong to port 2, if port 2 uses serdes
- or the lane can belong to port 9 and port 9 can be in multi-lane mode
  (xaui or rxaui). In this case port 2 uses the internal copper PHY,
  AFAIK

So the question is whether we want to be able to defined this
tx-amplitude different for different lanes. But if so, I think we will
need to add bindings for SerDes PHYs into mv88e6xxx.

So anyway, regarding whether the properites should have a "serdes-"
prefix:
- if they are in SerDes node, it isn't necessary
- if we put them in port nodes, it depends, but probably also is not
  necessary, since I don't think there will ever be a conflict with
  copper TX amplitude or something.

Marek
