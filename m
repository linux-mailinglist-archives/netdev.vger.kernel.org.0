Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52B135BDF8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbhDLI4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238822AbhDLIyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A446061363;
        Mon, 12 Apr 2021 08:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618217579;
        bh=hrWfHU5AAc5N/c21/smS4Sap61CFVbzlbuSTQUEq1B8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aYsWHDuHjnYvcAjqadsSxQE3wBtMTzBJMv67OFHZ5rnLhkQEFxnpgMWfRjaovnwr6
         GFivLGNUi5hmjXJTxmEINEa8JIxgDGnNxZ4DqYqUQgOVtYVWPagBvsfsuOsmihUbVJ
         lepBlXLejyPqZIl54p2qfjqIcqMXlBhHKYXgKYmKR8OUAfqEPCABpXyKW1NkfFkpgl
         LXPlPrG1FYluboLSa58//ynE8gpd69NGsob4AV/XzqasTw8qqd8BGApp26eITreDDG
         Amrc+hbX1696QejfORGBqICHtep//3uJgHHXIDqMeRpTI+KqE2pXXl1f5r2S5JMXw3
         d5TV+hMh53tcA==
Date:   Mon, 12 Apr 2021 11:52:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YHQKWx6Alcc6OQ9X@unreal>
References: <20210412023455.45594-1-decui@microsoft.com>
 <YHP6s2zagD67Xr0z@unreal>
 <MW2PR2101MB08920145C271FCEF8D337BE2BF709@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB08920145C271FCEF8D337BE2BF709@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 08:35:32AM +0000, Dexuan Cui wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Monday, April 12, 2021 12:46 AM
> > To: Dexuan Cui <decui@microsoft.com>
> > > ...
> > > +#define ANA_MAJOR_VERSION	0
> > > +#define ANA_MINOR_VERSION	1
> > > +#define ANA_MICRO_VERSION	1
> > 
> > Please don't introduce drier versions.
> 
> This is not the usual "driver version", though it's called  "drv version" :-)
> As you can see, the driver does not use the macro MODULE_VERSION().
> 
> Here the "drv version" actually means the version of the VF-to-PF protocol,
> with which the Azure Network Adapter ethernet NIC driver (i.e. the VF driver)
> talks to the PF driver.  The protocol version determines the formats of the
> messages that are sent from the VF driver to the PF driver, e.g. query the
> MAC address, create Send/Receive queues, configure RSS, etc.
> 
> Currently the protocol versin is 0.1.1 You may ask why it's called
> "drv version" rather than "protocol version" -- it's because the PF driver
> calls it that way, so I think here the VF driver may as well use the same
> name. BTW, the "drv ver" info is passed to the PF driver in the below
> function:

Ohh, yes, the "driver version" is not the ideal name for that.

I already looked on it in previous patch, came to the conclusion about
the protocol and forgot :(.

> 
> static int mana_query_client_cfg(struct ana_context *ac, u32 drv_major_ver,
>                                  u32 drv_minor_ver, u32 drv_micro_ver,
>                                  u16 *max_num_vports)
> {
>         struct gdma_context *gc = ac->gdma_dev->gdma_context;
>         struct ana_query_client_cfg_resp resp = {};
>         struct ana_query_client_cfg_req req = {};
>         struct device *dev = gc->dev;
>         int err = 0;
> 
>         mana_gd_init_req_hdr(&req.hdr, ANA_QUERY_CLIENT_CONFIG,
>                              sizeof(req), sizeof(resp));
>         req.drv_major_ver = drv_major_ver;
>         req.drv_minor_ver = drv_minor_ver;
>         req.drv_micro_ver = drv_micro_ver;
> 
>         err = mana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
> 
> Thanks,
> Dexuan
> 
