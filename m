Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33D146C39E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhLGTbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhLGTbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 14:31:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE613C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 11:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56BDCCE1B8B
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 19:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E03EC341C3;
        Tue,  7 Dec 2021 19:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638905258;
        bh=q9A1mg6NXYBeu6gzXlhPTl6VrlE0d9NlhaNb0JTmOus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAPb6tBuN9bOMr12xXdaFCMzX7iBCU9Qnf0/AtYKt04KA2ifUBenIXHARewa38xux
         QNyhYZl9zQWj7vZJej9Hmqq9S0wLY+jvO71RGKNHrP/Rf+gMmz62jeIMgjT8osW+Jv
         R3kR1oZKishOdd8wtmonSLnICpcoUBTLws1lxCeOHeh95YEyW67fZ5s0ulaI2JdOxt
         f1+f2Q3TRrWrGKoVrjc6CxGMgSZSsPnoi2xCwYL9JGDiE7iuRuoicanm4Sfa8gTnzs
         88h0iB7PRZOQQAGG7x82grZI3vPiN/tPY0HIjt9gGBpq8NNgiAxfmiq3MJ5jJPnMg5
         dBp8DObebQMgw==
Date:   Tue, 7 Dec 2021 20:27:33 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211207202733.56a0cf15@thinkpad>
In-Reply-To: <20211207190730.3076-2-holger.brunck@hitachienergy.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 20:07:30 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This pat=
ch
> allows to configure the output swing to a desired value in the
> devicetree node of the port. As the chips only supports eight dedicated
> values we return EINVAL if the value in the DTS does not match.
>=20
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>

Holger, Andrew,

there is another issue with this, which I only realized yesterday. What
if the different amplitude needs to be set only for certain SerDes
modes?

I am bringing this up because I discovered that on Turris Mox we need
to increase SerDes output amplitude when A3720 SOC is connected
directly to 88E6141 switch, but only for 2500base-x mode. For
1000base-x, the default amplitude is okay. (Also when the SOC is
connected to 88E6190, the amplitude does not need to be changed at all.)

I plan to solve this in the comphy driver, not in device-tree.

But if the solution is to be done in DTS, shouldn't there be a
possibility to define the amplitude for a specific serdes mode only?

For example
  serdes-2500base-x-tx-amplitude-millivolt
or
  serdes-tx-amplitude-millivolt-2500base-x
or
  serdes-tx-amplitude-millivolt,2500base-x
?

What do you think?

Marek
