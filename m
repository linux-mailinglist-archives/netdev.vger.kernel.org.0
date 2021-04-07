Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7549356CA4
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352449AbhDGMve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhDGMvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 08:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB93461279;
        Wed,  7 Apr 2021 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617799882;
        bh=m4r6X7ZfydL60kYXm+rHrFPGoJaR2k9l7+B9drZZwHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eg/cjZglmOs+0VhFkHOsbQYekE4Y92vEuJBZOVSLDNZVQfAEP1v6sKbxxj2OdpXJF
         0pZVBfLKcL6GDGHkWX+FLJ+Xr/nMDvmCJ2MUqjdOlIuDdSxbiX9+9H5gpBW0wWqc/8
         okJfq9ghElwMauqW9owTQlMBIIG2C4oi+Fq/N26+ZHh4y2EZy7aAFTc3MOcAMTHDoV
         SWwqaCpcAk2IxZojl2RWYV2abb6pcohUL4MVAzo8zpLvQnT7k9KYt9mZgzZtz58nuU
         BSyTJA/Khnnm0eJmluiWbJil/6fkvj8wVQWGhM6hw21/fvp66BrKBamkWETivurx/0
         nJY+4P1lqwslQ==
Date:   Wed, 7 Apr 2021 15:51:18 +0300
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG2qxjPJ4ruas1dI@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG1o4LXVllXfkUYO@unreal>
 <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:40:13AM +0000, Dexuan Cui wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, April 7, 2021 1:10 AM
> > 
> > <...>
> > 
> > > +int gdma_verify_vf_version(struct pci_dev *pdev)
> > > +{
> > > +	struct gdma_context *gc = pci_get_drvdata(pdev);
> > > +	struct gdma_verify_ver_req req = { 0 };
> > > +	struct gdma_verify_ver_resp resp = { 0 };
> > > +	int err;
> > > +
> > > +	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
> > > +			  sizeof(req), sizeof(resp));
> > > +
> > > +	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
> > > +	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
> > > +
> > > +	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> > > +	if (err || resp.hdr.status) {
> > > +		pr_err("VfVerifyVersionOutput: %d, status=0x%x\n", err,
> > > +		       resp.hdr.status);
> > > +		return -EPROTO;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > <...>
> > > +	err = gdma_verify_vf_version(pdev);
> > > +	if (err)
> > > +		goto remove_irq;
> > 
> > Will this VF driver be used in the guest VM? What will prevent from users to
> > change it?
> > I think that such version negotiation scheme is not allowed.
> 
> Yes, the VF driver is expected to run in a Linux VM that runs on Azure.
> 
> Currently gdma_verify_vf_version() just tells the PF driver that the VF driver
> is only able to support GDMA_PROTOCOL_V1, and want to use
> GDMA_PROTOCOL_V1's message formats to talk to the PF driver later.
> 
> enum {
>         GDMA_PROTOCOL_UNDEFINED = 0,
>         GDMA_PROTOCOL_V1 = 1,
>         GDMA_PROTOCOL_FIRST = GDMA_PROTOCOL_V1,
>         GDMA_PROTOCOL_LAST = GDMA_PROTOCOL_V1,
>         GDMA_PROTOCOL_VALUE_MAX
> };
> 
> The PF driver is supposed to always support GDMA_PROTOCOL_V1, so I expect
> here gdma_verify_vf_version() should succeed. If a user changes the Linux VF
> driver and try to use a protocol version not supported by the PF driver, then
> gdma_verify_vf_version() will fail; later, if the VF driver tries to talk to the PF
> driver using an unsupported message format, the PF driver will return a failure.

The worry is not for the current code, but for the future one when you will
support v2, v3 e.t.c. First, your code will look like a spaghetti and
second, users will try and mix vX with "unsupported" commands just for the
fun.

Thanks

> 
> Thanks,
> -- Dexuan
