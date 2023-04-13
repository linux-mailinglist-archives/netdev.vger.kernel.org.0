Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929CC6E090A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDMIgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDMIgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:36:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3624D93EA
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EAC61330
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC7C433EF;
        Thu, 13 Apr 2023 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681374992;
        bh=F6fLNtLkmW4Q21q6bPgC9l2oEzYf1PtSg9aqhdUrR4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3Czr3NkOR2sD5p4I47vkwedbwtaxv1AlZbTzDMZzy9DPw+qL0l3cq2FQlaugpT1R
         RzZpqSXRzeMggzWKj0T56c++EaQzOaPAlR1V9Y0Al28JeTfFAEvady1efHP8f6RQgg
         DwGaheoNAo2Yh5G1sspOAdgIppRSTDXknhCwRxwRmzM1cF3jVVQJB1pt89Qo0ZiVIK
         tHU0xGgcp3yxU3K6A3IIdRgMfXuDNOtav3FmJEsmf4c7baZlwfsc/X+Qxesq7bAcCP
         +DC00Dn4ruwn19rJtKfasUOWLdBzf9TM9ZlgKv7UqvvUkJcFA+GmyAKoVyrcmKgd3c
         cKjS1mPtQhJSQ==
Date:   Thu, 13 Apr 2023 11:36:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 08/14] pds_core: set up the VIF definitions
 and defaults
Message-ID: <20230413083627.GE17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-9-shannon.nelson@amd.com>
 <20230409120813.GE182481@unreal>
 <1d9f57d4-19ec-62ce-de51-742dc32e2019@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d9f57d4-19ec-62ce-de51-742dc32e2019@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 12:36:31PM -0700, Shannon Nelson wrote:
> On 4/9/23 5:08 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Apr 06, 2023 at 04:41:37PM -0700, Shannon Nelson wrote:
> > > The Virtual Interfaces (VIFs) supported by the DSC's
> > > configuration (vDPA, Eth, RDMA, etc) are reported in the
> > > dev_ident struct and made visible in debugfs.  At this point
> > > only vDPA is supported in this driver - the other interfaces
> > > are defined for future use but not yet realized.
> > 
> > Let's add only supported modes for now.
> 
> As stated, only the vDPA feature is supported in the driver.
> 
> > 
> > <...>
> > 
> > > +static int viftype_show(struct seq_file *seq, void *v)
> > > +{
> > > +     struct pdsc *pdsc = seq->private;
> > > +     int vt;
> > > +
> > > +     for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
> > > +             if (!pdsc->viftype_status[vt].name)
> > > +                     continue;
> > > +
> > > +             seq_printf(seq, "%s\t%d supported %d enabled\n",
> > > +                        pdsc->viftype_status[vt].name,
> > > +                        pdsc->viftype_status[vt].supported,
> > > +                        pdsc->viftype_status[vt].enabled);
> > > +     }
> > > +     return 0;
> > > +}
> > > +DEFINE_SHOW_ATTRIBUTE(viftype);
> > 
> > I think that it is handled by devlink.
> 
> Yes, this is handled for those for which the driver sets up parameters (only
> vDPA), but that doesn't help when we want to see what the device is actually
> advertising.  This shows us what the device is thinking, which we find
> useful in debugging, but it doesn't belong in devlink information.

I'm not sure, users somehow need to know if they can or can't enable
certain feature and it is impossible without advertising it.

All drivers which support auxbus need this feature.

Thanks

> 
> > 
> > Thanks
