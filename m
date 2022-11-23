Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DC86350BF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiKWG7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbiKWG7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:59:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8A382BC0;
        Tue, 22 Nov 2022 22:59:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4431261AA5;
        Wed, 23 Nov 2022 06:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD02C433C1;
        Wed, 23 Nov 2022 06:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669186740;
        bh=zIbIy/PtmE2LjDQ6u0ycesYy6M+OQfQCW7bQkpgh7Wk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bzgzCfjQd1alk5/e+Spa+hdB0/oWpYut0+k/MsWjFCwQ7L+rdhlvDdNiPab4PBrXI
         1HArTIHZwB4Er/kcirALZN/UcNcB/AlutbbLSHLsWt8f4fW2GH+VayFQeqoxzgU+Jj
         +WpqJXCWUj0yZbpxtkjIm6aA3UsNsKdSpwMmsk605B+KVsldgdYgXeDEqhJJaO/cjP
         1pnH1mFaTORk4pTX6HDFo62VluvlVE00/MmG8ylJj5b0mNC4pZo9fGZYylrfFiR7Vo
         ji9o0JpZKxLm+OD30GBRvLjBfBYIUNnYYIxcSRH2dWn+gYMgSuQjdzxPxlqI9w9COc
         O3kE3Uy26wQZQ==
Date:   Wed, 23 Nov 2022 08:58:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
Message-ID: <Y33ErZHAsX76y34Z@unreal>
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
 <Y2zYPOUKgoArq7mM@unreal>
 <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
 <Y3Tj/BrskSJPuTFw@unreal>
 <CACZ4nhsv4zyzANrGh90WGKORz0Su=i7+Jmsk6nWoOq4or7Y0=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ4nhsv4zyzANrGh90WGKORz0Su=i7+Jmsk6nWoOq4or7Y0=Q@mail.gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:02:45AM -0800, Ajit Khaparde wrote:
> On Wed, Nov 16, 2022 at 5:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> ::snip::
> > > > All PCI management logic and interfaces are needed to be inside eth part
> > > > of your driver and only that part should implement SR-IOV config. Once
> > > > user enabled SR-IOV, the PCI driver should create auxiliary devices for
> > > > each VF. These device will have RDMA capabilities and it will trigger RDMA
> > > > driver to bind to them.
> > > I agree and once the PF creates the auxiliary devices for the VF, the RoCE
> > > Vf indeed get probed and created. But the twist in bnxt_en/bnxt_re
> > > design is that
> > > the RoCE driver is responsible for making adjustments to the RoCE resources.
> >
> > You can still do these adjustments by checking type of function that
> > called to RDMA .probe. PCI core exposes some functions to help distinguish between
> > PF and VFs.
> >
> > >
> > > So once the VF's are created and the bnxt_en driver enables SRIOV adjusts the
> > > NIC resources for the VF,  and such, it tries to call into the bnxt_re
> > > driver for the
> > > same purpose.
> >
> > If I read code correctly, all these resources are for one PCI function.
> >
> > Something like this:
> >
> > bnxt_re_probe()
> > {
> >   ...
> >         if (is_virtfn(p))
> >                  bnxt_re_sriov_config(p);
> >   ...
> > }
> I understand what you are suggesting.
> But what I want is a way to do this in the context of the PF
> preferably before the VFs are probed. 

I don't understand the last sentence. You call to this sriov_config in
bnxt_re driver without any protection from VFs being probed,

> So we are trying to call the
> bnxt_re_sriov_config in the context of handling the PF's
> sriov_configure implementation.  Having the ulp_ops is allowing us to
> avoid resource wastage and assumptions in the bnxt_re driver.

To which resource wastage are you referring?

There are no differences if same limits will be in bnxt_en driver when
RDMA bnxt device is created or in bnxt_re which will be called once RDMA
device is created.

Thanks

> 
> ::snip::


