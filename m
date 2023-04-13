Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F56E092A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDMIne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:43:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ABB6183
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAA37611FC
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725D9C433D2;
        Thu, 13 Apr 2023 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681375408;
        bh=7+bqjBzF8wy9P0q2wPyjqx69MOAzIJBDDZiZBrDZKQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ym9gJ6NCeZwa5NEqnmBQEWOEsj83N1dCCDopLsnaAwsChkYaqJcpSthMb8Lmgi5Gn
         x2hn0j3QyrYfOnz6l/uWbXMwTOal3zEjbvtsVHOcfI5ba8k8KrTADNJ5+mdKlkbGFm
         FgUc1kBzqNeevkS0e99jSwlY2Q1ad5rBeHFl5z78+92dKXIImpV1j4c7HDw55hqW2w
         BjD2dtcWahONvxa+MnuBmwKUleVKCGOpx8+e+ISUmbHbeyaZJA7AMeslsJak71OlKA
         9rJahAO5uE7DVoukxL7O5mnW09xEkl9YAs8iCueDkDk4OkFN3T+0kRzne2whpLJ1xQ
         auuwF7oyG5ADw==
Date:   Thu, 13 Apr 2023 11:43:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <20230413084323.GF17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-11-shannon.nelson@amd.com>
 <20230409122316.GF182481@unreal>
 <b075b886-84c6-61d3-c181-7e1ae4152ef6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b075b886-84c6-61d3-c181-7e1ae4152ef6@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 01:02:10PM -0700, Shannon Nelson wrote:
> On 4/9/23 5:23 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Apr 06, 2023 at 04:41:39PM -0700, Shannon Nelson wrote:
> > > An auxiliary_bus device is created for each vDPA type VF at VF
> > > probe and destroyed at VF remove.  The aux device name comes
> > > from the driver name + VIF type + the unique id assigned at PCI
> > > probe.  The VFs are always removed on PF remove, so there should
> > > be no issues with VFs trying to access missing PF structures.
> > > 
> > > The auxiliary_device names will look like "pds_core.vDPA.nn"
> > > where 'nn' is the VF's uid.
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
> > >   drivers/net/ethernet/amd/pds_core/auxbus.c | 112 +++++++++++++++++++++
> > >   drivers/net/ethernet/amd/pds_core/core.h   |   6 ++
> > >   drivers/net/ethernet/amd/pds_core/main.c   |  36 ++++++-
> > >   include/linux/pds/pds_auxbus.h             |  16 +++
> > >   include/linux/pds/pds_common.h             |   1 +
> > >   6 files changed, 170 insertions(+), 2 deletions(-)
> > >   create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
> > >   create mode 100644 include/linux/pds/pds_auxbus.h

<...>

> > 
> > And can we please find another name for functions and parameters which
> > don't include VF in it as it is not correct anymore.
> > 
> > In ideal world, it will be great to have same probe flow for PF and VF
> > while everything is controlled through FW and auxbus. For PF, you won't
> > advertise any aux devices, but the flow will continue to be the same.
> 
> Since we currently only have VFs and not more finely grained sub-functions,
> these seem to still make sense and help define the context of the
> operations.  I can find places where we can reduce the use of 'VF'.  Would
> you prefer PF and SF to PF and VF where the difference is important?

I'm talking about VF names in auxbus code. It simply doesn't belong there as you
are creating/deleting auxiliary devices for specific physical devices. They by
chance your VFs.

"PF/VF probe flow" is my wishful thinking, it is fine to leave it as is.

Thanks
