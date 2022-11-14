Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B31628055
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbiKNNFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiKNNFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:05:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0132A273;
        Mon, 14 Nov 2022 05:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2y401i8RHooQYJjpyKGYLxQ8w5xfHy0k3TPsSzf0CGA=; b=eSL/pC96cN8kEPu5RWSDqWXolS
        ST7oY5KrZkL2r7mOdgFqhzgx/uS9F9A9dNr4lmTkKfc7oKEGyI0Sb3SLFo52pQe7K0h+4v3M0NSn1
        rjM81IGwTY4dd2Ou+T4OuSLdIc7Uk+5aJgTc82sSRD3LDwoZ2EXnuuG233yCEUihuYXo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouZ7i-002Kls-44; Mon, 14 Nov 2022 14:03:38 +0100
Date:   Mon, 14 Nov 2022 14:03:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: fec: Create device link between fec0 and fec1
Message-ID: <Y3I8qnNj1EUmPDmd@lunn.ch>
References: <20221114041143.2189624-1-xiaolei.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114041143.2189624-1-xiaolei.wang@windriver.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 12:11:43PM +0800, Xiaolei Wang wrote:
> On imx6sx, there are two fec interfaces, but the external
> phys can only be configured by fec0 mii_bus. That means
> the fec1 can't work independently, it only work when the
> fec0 is active. It is alright in the normal boot since the
> fec0 will be probed first. But then the fec0 maybe moved
> behind of fec1 in the dpm_list due to various device link.
> So in system suspend and resume, we would get the following
> warning when configuring the external phy of fec1 via the
> fec0 mii_bus due to the inactive of fec0. In order to fix
> this issue, we create a device link between fec0 and fec1.
> This will make sure that fec0 is always active when fec1
> is in active mode.

I'm wondering if this should be more generic? I have seen this setup
more frequently on the FEC, but there are other dual MAC SoCs which
can have a similar setup, two PHYs sharing one MDIO bus.

Can this be pushed into phylib?

    Andrew
