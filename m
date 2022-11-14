Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45726286A5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiKNRIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238174AbiKNRIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C1E2FFC1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FDF8B810A3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67081C43470;
        Mon, 14 Nov 2022 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668445679;
        bh=RS7xnGRgZAWv0GWsiQFM4Ag3CewkH/FioaOOZAymmAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4FDg8nS9HByEpKnAyALlb+xxBVFpiVtjCa8AQUj92sQMWpCXRSfU/HyM234f8QGA
         Bo2pNxQzpAW1rPULOp1wfWdOYolmVTQGZe4szv8XMkrud3cF7i233IvbfyFz9AXSk0
         hnPOSlQf+BGf0J7C9aPHNwBngegN0k8YAMcnk8iZOaMJv0mcZKlXTq+z8tt8ljtXF9
         Jbyyg4r6hsoJUU47qTMhm44OR296QSkFq7LTID4Q7lw5V3VMQHeFFtSDgY0I1XVCLp
         ZX4PeVXNp6qmeYEYRTGn6LDIPcLlqJiOkKhjnUBw0nd2tkTumK9IHnfcuI+AV7R899
         qL5o0rEdzEf8Q==
Date:   Mon, 14 Nov 2022 19:07:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3J16ueuhwYeDaww@unreal>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:31:11AM -0600, Samudrala, Sridhar wrote:
> On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > Currently the default value for number of PF vectors is number of CPUs.
> > > Because of that there are cases when all vectors are used for PF
> > > and user can't create more VFs. It is hard to set default number of
> > > CPUs right for all different use cases. Instead allow user to choose
> > > how many vectors should be used for various features. After implementing
> > > subdevices this mechanism will be also used to set number of vectors
> > > for subfunctions.
> > > 
> > > The idea is to set vectors for eth or VFs using devlink resource API.
> > > New value of vectors will be used after devlink reinit. Example
> > > commands:
> > > $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > $ sudo devlink dev reload pci/0000:31:00.0
> > > After reload driver will work with 16 vectors used for eth instead of
> > > num_cpus.
> > By saying "vectors", are you referring to MSI-X vectors?
> > If yes, you have specific interface for that.
> > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> 
> This patch series is exposing a resources API to split the device level MSI-X vectors
> across the different functions supported by the device (PF, RDMA, SR-IOV VFs and
> in future subfunctions). Today this is all hidden in a policy implemented within
> the PF driver.

Maybe we are talking about different VFs, but if you refer to PCI VFs,
the amount of MSI-X comes from PCI config space for that specific VF.

You shouldn't set any value through netdev as it will cause to
difference in output between lspci (which doesn't require any driver)
and your newly set number.

Also in RDMA case, it is not clear what will you achieve by this
setting too.

Thanks
