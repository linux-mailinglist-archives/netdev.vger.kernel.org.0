Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF064E96F3
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbiC1Ms4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiC1Msz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:48:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6F4D9D6
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZTZ9JHwlpWTpwIIeBU2FSj4LgQndUnbr98C4VDSogUo=; b=OJFHQKJSoMf1EJycCcC6CvVBv4
        8ygbNMDVL7vG7fcjnDnh4A2QuDOGvXa86hnT1EGF5ETtg3a6qaY/LTMdOI/JqccKpEERU7ZC+o55v
        1JJdfjsxOx8aLgNeNyW3XwVdigloUAohcPx06fHUCMbF6eXyHGQpiInw2sObZmkYXTVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYolt-00D135-Ke; Mon, 28 Mar 2022 14:46:57 +0200
Date:   Mon, 28 Mar 2022 14:46:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
Message-ID: <YkGuQXL5cRQveSlZ@lunn.ch>
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
 <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
 <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The call to bnxt_ptp_cfg_pin() after the swith will return -ENOTSUPP for
> invalid pin IDs. So I did not feel like adding more changes was necessary.
> 
> We can return an error if you insist, but what should it be ? -EINVAL ?
> -ENODEV ? -ENOTSUPP ? Given that bnxt_ptp_cfg_pin() return -ENOTSUPP, we
> could use that code.

https://elixir.bootlin.com/linux/v5.17.1/source/include/linux/errno.h#L23

ENOTSUPP is an NFS only error code. It should not be used anywhere
else. EOPNOTSUPP is the generic error that should be used. However,
don't replace an ENOTSUPP with an EOPNOTSUPP without considering ABI.

    Andrew
