Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E71E5334
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgE1BkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:40:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:14389 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgE1BkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:40:06 -0400
IronPort-SDR: a5LBYlLxM55Wt4/IlliqahSIGh9NJL7lRE+4IIXEx4s27xNlnTJG64ooHZVe/SNZ+Lb3Zrvdp4
 uAumOt8SLQcQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 18:40:06 -0700
IronPort-SDR: FQgpI/nboUb/M814O4iY+nqbW+g13psdDzvAv/UUkLaM060TDE0IVSJFZI4ZjjF+Qv16Z1BkMR
 Kv6u4sihA7/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="442758675"
Received: from tgarris-mobl.amr.corp.intel.com ([10.255.72.202])
  by orsmga005.jf.intel.com with ESMTP; 27 May 2020 18:40:05 -0700
Message-ID: <d44a50f6a8af0162a5ff1a6d483adebf16d11256.camel@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Date:   Wed, 27 May 2020 18:40:05 -0700
In-Reply-To: <20200528001207.GR744@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
         <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
         <20200520125611.GI31189@ziepe.ca>
         <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
         <20200528001207.GR744@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-27 at 21:12 -0300, Jason Gunthorpe wrote:
> On Wed, May 27, 2020 at 01:18:35PM -0700, Ranjani Sridharan wrote:
> > On Wed, 2020-05-20 at 09:56 -0300, Jason Gunthorpe wrote:
> > > On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> > > > +static const struct virtbus_dev_id sof_ipc_virtbus_id_table[]
> > > > = {
> > > > +	{"sof-ipc-test"},
> > > > +	{},
> > > > +};
> > > > +
> > > > +static struct sof_client_drv sof_ipc_test_client_drv = {
> > > > +	.name = "sof-ipc-test-client-drv",
> > > > +	.type = SOF_CLIENT_IPC,
> > > > +	.virtbus_drv = {
> > > > +		.driver = {
> > > > +			.name = "sof-ipc-test-virtbus-drv",
> > > > +		},
> > > > +		.id_table = sof_ipc_virtbus_id_table,
> > > > +		.probe = sof_ipc_test_probe,
> > > > +		.remove = sof_ipc_test_remove,
> > > > +		.shutdown = sof_ipc_test_shutdown,
> > > > +	},
> > > > +};
> > > > +
> > > > +module_sof_client_driver(sof_ipc_test_client_drv);
> > > > +
> > > > +MODULE_DESCRIPTION("SOF IPC Test Client Driver");
> > > > +MODULE_LICENSE("GPL v2");
> > > > +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
> > > > +MODULE_ALIAS("virtbus:sof-ipc-test");
> > > 
> > > Usually the MODULE_ALIAS happens automatically rhough the struct
> > > virtbus_dev_id - is something missing in the enabling patches?
> > 
> > Hi Jason,
> > 
> > Without the MODULE_ALIAS,  the driver never probes when the virtual
> > bus
> > device is registered. The MODULE_ALIAS is not different from the
> > ones
> > we typically have in the platform drivers. Could you please give me
> > some pointers on what you think might be missing?
> 
> Look at how the stuff in include/linux/mod_devicetable.h works and do
> the same for virtbus
It looks like include/linux/mod_devicetable.h has everything needed for
virtbus already.
> 
> Looks like you push a MODALIAS= uevent when creating the device and
> the generic machinery does the rest based on the matching table, once
> mod_devicetable.h and related is updated. But it has been a long time
> since I looked at this..

This is also done with uevent callback in the bus_type definition for
the virtual_bus.

Is your expectation that with the above changes, we should not be
needing the MODULE_ALIAS() in the driver?

Thanks,
Ranjani

