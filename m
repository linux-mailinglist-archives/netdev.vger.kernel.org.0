Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69EF11EE36
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLMXIh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 18:08:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:43610 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfLMXIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 18:08:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 15:08:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="208606702"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2019 15:08:35 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.10]) by
 FMSMSX106.amr.corp.intel.com ([169.254.5.184]) with mapi id 14.03.0439.000;
 Fri, 13 Dec 2019 15:08:35 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Topic: [PATCH v3 04/20] i40e: Register a virtbus device to provide
 RDMA
Thread-Index: AQHVruLyruZaK+NBaUahwsdRBRLbTKe0CH+AgAR/tTA=
Date:   Fri, 13 Dec 2019 23:08:34 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
In-Reply-To: <20191210153959.GD4053085@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjYxNzU3YjItYTFiYy00OWQ3LWE0ZWMtZDYwYzY3NDM1NGViIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRGtXZ0M3U1RrSGtkbkpWSGtDbE1IWlRMaVV3aE1kN2x5MnBtbVFMcDhHMkZiOHFCWWhEUzVVOW1EMzN6T2V5biJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
> 

[....]

> >  /**
> > @@ -275,6 +281,27 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
> >  	cdev->lan_info.msix_entries =
> > &pf->msix_entries[pf->iwarp_base_vector];
> >  }
> >
> > +static int i40e_init_client_virtdev(struct i40e_pf *pf) {
> > +	struct i40e_info *ldev = &pf->cinst->lan_info;
> > +	struct pci_dev *pdev = pf->pdev;
> > +	struct virtbus_device *vdev;
> > +	int ret;
> > +
> > +	vdev = &ldev->vdev;
> > +	vdev->name = I40E_PEER_RDMA_NAME;
> > +	vdev->dev.parent = &pf->pdev->dev;
> 
> What a total and complete mess of a tangled web you just wove here.
> 
> Ok, so you pass in a single pointer, that then dereferences 3 pointers deep to find
> the pointer to the virtbus_device structure, but then you point the parent of that
> device, back at the original structure's sub-pointer's device itself.
> 
> WTF?

OK. This is convoluted. Passing a pointer to the i40e_info object should suffice. So something like,

+static int i40e_init_client_virtdev(struct i40e_info *ldev) {
+       struct pci_dev *pdev = ldev->pcidev;
+       struct virtbus_device *vdev = &ldev->vdev;
+       int ret;
+
+       vdev->name = I40E_PEER_RDMA_NAME;
+       vdev->dev.parent = &pdev->dev;
+       ret = virtbus_dev_register(vdev);
+       if (ret)
+               return ret;
+
+       return 0;
+}
+

> 
> And who owns the memory of this thing that is supposed to be dynamically
> controlled by something OUTSIDE of this driver?  Who created that thing 3
> pointers deep?  What happens when you leak the memory below (hint, you did),
> and who is supposed to clean it up if you need to properly clean it up if something
> bad happens?

The i40e_info object memory is tied to the PF driver.

The object hierarchy is,

i40e_pf: pointer to i40e_client_instance 
	----- i40e_client_instance: i40e_info
		----- i40e_info: virtbus_device

For each PF, there is a client_instance object allocated.
The i40e_info object is populated and the virtbus_device hanging off this object is registered.
In irdma probe(), we use the container_of macro to get to this i40e_info object from the
virtbus_device. It contains all the ops/info which RDMA driver needs from the PCI function driver.

The lifetime of the i40e_info object (and the virtbus device) is tied to the PF.
When PF goes away, virtbus_device is unregistered and the client_instance object memory
is freed.

> 
> > +
> > +	ret = virtbus_dev_register(vdev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failure adding client virtbus dev %s %d\n",
> > +			I40E_PEER_RDMA_NAME, ret);
> 
> Again, the core should handle this, right?

Right. Will fix.

> 
> > +		return ret;
> 
> Did you just leak memory?

Thanks! Will fix.

> Also, what ever happened to my "YOU ALL MUST AGREE TO WORK TOGETHER"
> requirement between this group, and the other group trying to do the same thing?  I
> want to see signed-off-by from EVERYONE involved before we are going to
> consider this thing.
> 
We will have all parties cc'ed in the next submission. Would encourage folks to review
and hopefully we can get some consensus.
