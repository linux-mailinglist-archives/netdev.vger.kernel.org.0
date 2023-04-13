Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F826E06AB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDMGEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMGED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:04:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C314ED8
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 809DC6148C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F64C433EF;
        Thu, 13 Apr 2023 06:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681365841;
        bh=73jC7VuA4E5rMOY0gojw4B2rEbbMXYjFGlAFtZOIy6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N656O0eUs1hO8fX8wktkwnalN9jyi8l9youlfvedic4HF2YRyqVhjXAabGHawzipC
         WFz58XR+FoXYW4y83rSsgZ6JVf2Zj8T2p3IUUrLKvIKOMKt5FO5dtt0BXKtDEOGwEH
         CZoVKyMxvjznTXoJQjbTfsyhKNa6YeFgcO3C88hZI8fxBNE/K9eBDGAHVJBXIArKKt
         3wb7ydCoMkdJDQqpl+dKz+cX4+V67X1/6Fdnd7QWIUrtQ1GRYkQkvwg05NmWNIrqbk
         gR4nmy8b7t+Tf4Fp8A+xrF8IDmOtxv+hiU8ecsr9nlAAifykexUcfY5S5FjT22yY1q
         r7MI+lxuoqDYA==
Date:   Thu, 13 Apr 2023 09:03:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        joshua.a.hay@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        willemb@google.com, decot@google.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        Phani Burra <phani.r.burra@intel.com>,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [PATCH net-next v2 02/15] idpf: add module register and probe
 functionality
Message-ID: <20230413060357.GC182481@unreal>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-3-pavan.kumar.linga@intel.com>
 <20230411123653.GW182481@unreal>
 <b6ed7b0b-9262-3578-1d88-4c848d1aea82@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6ed7b0b-9262-3578-1d88-4c848d1aea82@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:10:18PM -0700, Tantilov, Emil S wrote:
> 
> 
> On 4/11/2023 5:36 AM, Leon Romanovsky wrote:
> > On Mon, Apr 10, 2023 at 06:13:41PM -0700, Pavan Kumar Linga wrote:
> > > From: Phani Burra <phani.r.burra@intel.com>
> > > 
> > > Add the required support to register IDPF PCI driver, as well as
> > > probe and remove call backs. Enable the PCI device and request
> > > the kernel to reserve the memory resources that will be used by the
> > > driver. Finally map the BAR0 address space.
> > > 
> > > PCI IDs table is intentionally left blank to prevent the kernel from
> > > probing the device with the incomplete driver. It will be added
> > > in the last patch of the series.
> > > 
> > > Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> > > Co-developed-by: Alan Brady <alan.brady@intel.com>
> > > Signed-off-by: Alan Brady <alan.brady@intel.com>
> > > Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> > > Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> > > Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> > > Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> > > Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > > Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >   drivers/net/ethernet/intel/Kconfig            | 11 +++
> > >   drivers/net/ethernet/intel/Makefile           |  1 +
> > >   drivers/net/ethernet/intel/idpf/Makefile      | 10 ++
> > >   drivers/net/ethernet/intel/idpf/idpf.h        | 27 ++++++
> > >   .../net/ethernet/intel/idpf/idpf_controlq.h   | 14 +++
> > >   drivers/net/ethernet/intel/idpf/idpf_lib.c    | 96 +++++++++++++++++++
> > >   drivers/net/ethernet/intel/idpf/idpf_main.c   | 70 ++++++++++++++
> > >   7 files changed, 229 insertions(+)
> > >   create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
> > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
> > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
> > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
> > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
> > 
> > <...>

<...>

> > > +/**
> > > + * idpf_probe - Device initialization routine
> > > + * @pdev: PCI device information struct
> > > + * @ent: entry in idpf_pci_tbl
> > > + *
> > > + * Returns 0 on success, negative on failure
> > > + */
> > > +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> > > +{
> > > +	struct idpf_adapter *adapter;
> > > +
> > > +	adapter = devm_kzalloc(&pdev->dev, sizeof(*adapter), GFP_KERNEL);
> > 
> > Why devm_kzalloc() and not kzalloc?
> It provides managed memory allocation on probe, which seems to be the
> preferred method in that case.

I don't think so, as PCI probe/remove has very clear lifetime model and
doesn't need garbage collection memory logic. In general, it is better
to avoid devm_*() APIs as they hide error unwind flows.

Thanks
