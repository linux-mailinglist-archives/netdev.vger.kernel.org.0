Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E06EEE27
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbjDZGRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDZGRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381FB1FE2;
        Tue, 25 Apr 2023 23:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8CD8626D3;
        Wed, 26 Apr 2023 06:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616A7C433D2;
        Wed, 26 Apr 2023 06:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682489819;
        bh=yxTBxHMI3Xt+WJTN+T1mo1v1VDu0RQ5kia/VlF4XDYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=awoSNDIMotZyV1S0SHNBD53GkM67TRTNvDP3ntx67QsVGh1JgyEZevK/+uR09g4Fv
         cHaC1a2JU2DW3SoxO2wps5H5UQbSchElzIy2inaF3EA9p2JuIXGI8ChqXeVEmkd17u
         dDKumrbS+nHXQdLLNxq6GMnuqf1uMsaot5Cn2CoIkmDTYDlY+zFZvhuhsMTO0D6eyd
         DdVRs0atg/fFPg53z4C0tqlWI8/uZasuEWLhq13SvFR/k2FVSkokH0bYmFzOcV2Bsj
         +Z4pUqXej/oVVSJzf5vLksYZPQcZk0EI/0QvCfqXYvWC0YTiVGA4aHEH2WmpuI20Ww
         8//y4EgbrRQkw==
Date:   Wed, 26 Apr 2023 09:16:54 +0300
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
Message-ID: <20230426061654.GC27649@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-6-gakula@marvell.com>
 <20230423165133.GH4782@unreal>
 <CO1PR18MB4666A3A7B44081290B37E375A1679@CO1PR18MB4666.namprd18.prod.outlook.com>
 <20230425085140.000bbcc1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425085140.000bbcc1@kernel.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 08:51:40AM -0700, Jakub Kicinski wrote:
> On Mon, 24 Apr 2023 10:29:02 +0000 Subbaraya Sundeep Bhatta wrote:
> > >How did you get call to .mdo_del_secy if you didn't add any secy?
> > >
> > >Thanks
> > >  
> > It is because of the order of teardown in otx2_remove:
> >         cn10k_mcs_free(pf);
> >         unregister_netdev(netdev);
> > 
> > cn10k_mcs_free free the resources and makes cfg as NULL.
> > Later unregister_netdev calls mdo_del_secy and finds cfg as NULL.
> > Thanks for the review I will change the order and submit next version.
> 
> Leon, ack? Looks like the patches got "changes requested" but I see 
> no other complaint.

Honestly, I was confused and didn't know what to answer, so decided to
see next version.

From one side Subbaraya said that it is possible (which was not
convincing to me, but ok, most time I'm wrong :)), from another
he said that he will submit next version.

Thanks
