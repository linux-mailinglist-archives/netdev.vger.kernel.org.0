Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502EA356F60
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbhDGOzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345305AbhDGOzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEA96136A;
        Wed,  7 Apr 2021 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617807305;
        bh=rYUMRTaKugSsbNVrBH+/0Cj76xuu7UY8XDoCizR5qR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KxKmzQbmEMU/5eKYaGgXbqXlxGwFTRk7PSL0I+jw8Gz1R2MxxQP9Kp0hKZARdq57X
         3Nnm/ujng8Jki8sVdzxeV9gTP4o+Ats1wb8Zr2SKzt2tnDD2DOTzF2xPbUrd1J6Rr6
         cAh24tEUzGZxMLtVdoxYh9jZgAapg8lDi7hfhMGHmUliUWUNiyvEFgdK91B4223DLg
         OPFNOUIYogu3V4Yp5XL4a5SYN8dLNXNmnMEYx+fUWbeQaJp8Wmrz+Cty1kiyQ1tdTG
         orngoYXzvzwwnFHOQ4TjWkbA2kzudMdMzMFN78T2+1X5Wcxr+nQRrSJM2hHwrmpTus
         Rdu/Qtv20HuTg==
Date:   Wed, 7 Apr 2021 17:55:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG3HxVaotTi/Xk5X@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG1o4LXVllXfkUYO@unreal>
 <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2qxjPJ4ruas1dI@unreal>
 <DM5PR2101MB09342B74ECD56BE4781431EACA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR2101MB09342B74ECD56BE4781431EACA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 02:41:45PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, April 7, 2021 8:51 AM
> > To: Dexuan Cui <decui@microsoft.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> > <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> > Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> > <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> > Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> > Network Adapter (MANA)
> > 
> > On Wed, Apr 07, 2021 at 08:40:13AM +0000, Dexuan Cui wrote:
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Wednesday, April 7, 2021 1:10 AM
> > > >
> > > > <...>
> > > >
> > > > > +int gdma_verify_vf_version(struct pci_dev *pdev)
> > > > > +{
> > > > > +	struct gdma_context *gc = pci_get_drvdata(pdev);
> > > > > +	struct gdma_verify_ver_req req = { 0 };
> > > > > +	struct gdma_verify_ver_resp resp = { 0 };
> > > > > +	int err;
> > > > > +
> > > > > +	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
> > > > > +			  sizeof(req), sizeof(resp));
> > > > > +
> > > > > +	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
> > > > > +	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
> > > > > +
> > > > > +	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> > > > > +	if (err || resp.hdr.status) {
> > > > > +		pr_err("VfVerifyVersionOutput: %d, status=0x%x\n", err,
> > > > > +		       resp.hdr.status);
> > > > > +		return -EPROTO;
> > > > > +	}
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > >
> > > > <...>
> > > > > +	err = gdma_verify_vf_version(pdev);
> > > > > +	if (err)
> > > > > +		goto remove_irq;
> > > >
> > > > Will this VF driver be used in the guest VM? What will prevent from users
> > to
> > > > change it?
> > > > I think that such version negotiation scheme is not allowed.
> > >
> > > Yes, the VF driver is expected to run in a Linux VM that runs on Azure.
> > >
> > > Currently gdma_verify_vf_version() just tells the PF driver that the VF
> > driver
> > > is only able to support GDMA_PROTOCOL_V1, and want to use
> > > GDMA_PROTOCOL_V1's message formats to talk to the PF driver later.
> > >
> > > enum {
> > >         GDMA_PROTOCOL_UNDEFINED = 0,
> > >         GDMA_PROTOCOL_V1 = 1,
> > >         GDMA_PROTOCOL_FIRST = GDMA_PROTOCOL_V1,
> > >         GDMA_PROTOCOL_LAST = GDMA_PROTOCOL_V1,
> > >         GDMA_PROTOCOL_VALUE_MAX
> > > };
> > >
> > > The PF driver is supposed to always support GDMA_PROTOCOL_V1, so I
> > expect
> > > here gdma_verify_vf_version() should succeed. If a user changes the Linux
> > VF
> > > driver and try to use a protocol version not supported by the PF driver,
> > then
> > > gdma_verify_vf_version() will fail; later, if the VF driver tries to talk to the
> > PF
> > > driver using an unsupported message format, the PF driver will return a
> > failure.
> > 
> > The worry is not for the current code, but for the future one when you will
> > support v2, v3 e.t.c. First, your code will look like a spaghetti and
> > second, users will try and mix vX with "unsupported" commands just for the
> > fun.
> 
> In the future, if the protocol version updated on the host side, guests need 
> to support different host versions because not all hosts are updated 
> (simultaneously). So this negotiation is necessary to know the supported 
> version, and decide the proper command version to use. 

And how do other paravirtual drivers solve this negotiation scheme?

> 
> If any user try "unsupported commands just for the fun", the host will deny 
> and return an error.
> 
> Thanks,
> - Haiyang
