Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D9D1E5D57
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbgE1Kpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387902AbgE1Kpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 06:45:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F19207D3;
        Thu, 28 May 2020 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590662748;
        bh=Ue2F8Srr3xnS800AxSipqkHzBXEszGzZ7bGmOn5Al+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n03+AcCPHH5Mprg0wvNevEOV/ofdK/gRsDEomWR3Eak0jVVISflY7Pi3WpkJoQRd8
         acCHSb95BdR7GuBaUJcZNos5ygLgzwYDsCfSVbwZFY8MUeJmKukLDJiVP59IlqPCz+
         6I+2mssBCDVGcj3SnOaKgkq6PUo1x1ppSM5dHPCc=
Date:   Thu, 28 May 2020 12:45:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
Message-ID: <20200528104545.GA3115014@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
 <20200520125611.GI31189@ziepe.ca>
 <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
 <20200528001207.GR744@ziepe.ca>
 <d44a50f6a8af0162a5ff1a6d483adebf16d11256.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44a50f6a8af0162a5ff1a6d483adebf16d11256.camel@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 06:40:05PM -0700, Ranjani Sridharan wrote:
> On Wed, 2020-05-27 at 21:12 -0300, Jason Gunthorpe wrote:
> > On Wed, May 27, 2020 at 01:18:35PM -0700, Ranjani Sridharan wrote:
> > > On Wed, 2020-05-20 at 09:56 -0300, Jason Gunthorpe wrote:
> > > > On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> > > > > +static const struct virtbus_dev_id sof_ipc_virtbus_id_table[]
> > > > > = {
> > > > > +	{"sof-ipc-test"},
> > > > > +	{},
> > > > > +};
> > > > > +
> > > > > +static struct sof_client_drv sof_ipc_test_client_drv = {
> > > > > +	.name = "sof-ipc-test-client-drv",
> > > > > +	.type = SOF_CLIENT_IPC,
> > > > > +	.virtbus_drv = {
> > > > > +		.driver = {
> > > > > +			.name = "sof-ipc-test-virtbus-drv",
> > > > > +		},
> > > > > +		.id_table = sof_ipc_virtbus_id_table,
> > > > > +		.probe = sof_ipc_test_probe,
> > > > > +		.remove = sof_ipc_test_remove,
> > > > > +		.shutdown = sof_ipc_test_shutdown,
> > > > > +	},
> > > > > +};
> > > > > +
> > > > > +module_sof_client_driver(sof_ipc_test_client_drv);
> > > > > +
> > > > > +MODULE_DESCRIPTION("SOF IPC Test Client Driver");
> > > > > +MODULE_LICENSE("GPL v2");
> > > > > +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
> > > > > +MODULE_ALIAS("virtbus:sof-ipc-test");
> > > > 
> > > > Usually the MODULE_ALIAS happens automatically rhough the struct
> > > > virtbus_dev_id - is something missing in the enabling patches?
> > > 
> > > Hi Jason,
> > > 
> > > Without the MODULE_ALIAS,  the driver never probes when the virtual
> > > bus
> > > device is registered. The MODULE_ALIAS is not different from the
> > > ones
> > > we typically have in the platform drivers. Could you please give me
> > > some pointers on what you think might be missing?
> > 
> > Look at how the stuff in include/linux/mod_devicetable.h works and do
> > the same for virtbus
> It looks like include/linux/mod_devicetable.h has everything needed for
> virtbus already.
> > 
> > Looks like you push a MODALIAS= uevent when creating the device and
> > the generic machinery does the rest based on the matching table, once
> > mod_devicetable.h and related is updated. But it has been a long time
> > since I looked at this..
> 
> This is also done with uevent callback in the bus_type definition for
> the virtual_bus.
> 
> Is your expectation that with the above changes, we should not be
> needing the MODULE_ALIAS() in the driver?

Yes, it should not be needed if you did everything properly in
mod_devicetable.h

thanks,

greg k-h
