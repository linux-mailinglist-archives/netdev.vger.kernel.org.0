Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ACB6A987E
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCCNfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjCCNf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:35:29 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049D648E1A
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 05:34:58 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 06407E0002;
        Fri,  3 Mar 2023 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677850497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAYRbizV4utEu96GeXPN1QKfp+AlGLiaOQGQWIa5hlQ=;
        b=VI+sTuBvjeU5q1ReYzBjOQPB7Fz2+AVkZQySNwKSY1+gu034Z27xLAyzlDatXH9HpBRUvj
        Z3ikBqD8HiMaTwWO0ODiG7SYnyDsr8nWAIRiQ51FIjEkjWgYUyS65vwAf2Ru3ZJ5n4xMxa
        AC6Whx1x/RN74mksUMbdVWilmuRPA56AHFahJz9mr33EIfJEUQ6gL6ELMKgjfDAZ0vxdCW
        iAwAxAxcH5WV9OsaSjA9YMjfkJltid68VUb3mGCrAekuSqRkIsVB6b6lFMs/gmdKBycOpj
        o2eecc91EO74naVTZIPvUh+XMtw4hVS7UTxv5OLqasMBA36/Edz6TZNVgpR0EA==
Date:   Fri, 3 Mar 2023 14:34:55 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, linux@armlinux.org.uk,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230303143455.224462ea@kmaincent-XPS-13-7390>
In-Reply-To: <ZAH0FIrZL9Wf4gvp@lunn.ch>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
        <20230303102005.442331-1-michael@walle.cc>
        <ZAH0FIrZL9Wf4gvp@lunn.ch>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Mar 2023 14:20:20 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> I'm not sure we are making much progress here...
>=20
> Lets divide an conquer. As far as i can see we have the following bits
> of work to do:
>=20
> 1) Kernel internal plumbing to allow multiple time stampers for one
> netdev. The PTP core probably needs to be the mux for all kAPI calls,
> and any internal calling between components. This might mean changes
> to all MAC drivers supporting PTP and time stampers. But i don't think
> there is anything too controversial here, just plumbing work.
>=20
> 2) Some method to allow user space to control which time stamper is
> used. Either an extension of the existing IOCTL interface, or maybe
> ethtool. Depending on how ambitious we want to be, add a netlink API
> to eventually replace the IOCTL interface?

Isn't the patch series (with small revisions) from Richard sufficient for t=
his
two points?
https://lkml.kernel.org/netdev/Y%2F0N4ZcUl8pG7awc@shell.armlinux.org.uk/

> 3) Add a device tree binding to control which time stamper is
> used. Probably a MAC property. Also probably not too controversial.
>=20
> 4) Some solution to the default choice if there is no DT property.

And in cases of architectures which do not support DT how do we deal with i=
t?

Regards,
K=C3=B6ry
