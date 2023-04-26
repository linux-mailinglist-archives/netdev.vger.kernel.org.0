Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6056EEE93
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbjDZGw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbjDZGwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:52:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8292D7E;
        Tue, 25 Apr 2023 23:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 610A163357;
        Wed, 26 Apr 2023 06:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440DEC4339B;
        Wed, 26 Apr 2023 06:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682491937;
        bh=toSMf0jhH3B5lnQsYRYUOC8wB2CtVUisrL1JID/cGdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqW4ch8Q+udniHHxcnq+mwILYNLbBEB+T7CCVAZt0lVFYT8lbdGeuV+z/COkps0c7
         QikcFTfEztwFiRvrTCHlBFpJ7g/fkHm3rh6R/XvrPTTTUtGlwZsr83TitGuoUikXW0
         Pk48LEpHO1zd/8GxMVaK0q0Kexhi6CD02JhqAd5OxrfPUrC1/7aNQfMhhZzYNBLA7z
         A16NmEpqoWNgW3uqnSSqqN95fXIqchHp0ClvX9xk9GvJvGh5E2kZvJCfhyH7ftMEAT
         tPUBaME/69u5xVmUiF/lISzW3oedJaDCVARd7fMwHZ5EPaR04E6qfbXFhQsBFpQdqf
         33yAjoljQ7oWg==
Date:   Wed, 26 Apr 2023 09:52:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [EXT] Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer
 dereferences
Message-ID: <20230426065213.GJ27649@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-6-gakula@marvell.com>
 <20230423165133.GH4782@unreal>
 <CO1PR18MB4666A3A7B44081290B37E375A1679@CO1PR18MB4666.namprd18.prod.outlook.com>
 <20230425085140.000bbcc1@kernel.org>
 <20230426061654.GC27649@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426061654.GC27649@unreal>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 09:16:54AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 25, 2023 at 08:51:40AM -0700, Jakub Kicinski wrote:
> > On Mon, 24 Apr 2023 10:29:02 +0000 Subbaraya Sundeep Bhatta wrote:
> > > >How did you get call to .mdo_del_secy if you didn't add any secy?
> > > >
> > > >Thanks
> > > >  
> > > It is because of the order of teardown in otx2_remove:
> > >         cn10k_mcs_free(pf);
> > >         unregister_netdev(netdev);
> > > 
> > > cn10k_mcs_free free the resources and makes cfg as NULL.
> > > Later unregister_netdev calls mdo_del_secy and finds cfg as NULL.
> > > Thanks for the review I will change the order and submit next version.
> > 
> > Leon, ack? Looks like the patches got "changes requested" but I see 
> > no other complaint.
> 
> Honestly, I was confused and didn't know what to answer, so decided to
> see next version.
> 
> From one side Subbaraya said that it is possible (which was not
> convincing to me, but ok, most time I'm wrong :)), from another
> he said that he will submit next version.

Jakub,

v2 is perfectly fine.

Thanks

> 
> Thanks
