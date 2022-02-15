Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7968A4B62D6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiBOFcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:32:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiBOFcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:32:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922EB8F9BD;
        Mon, 14 Feb 2022 21:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E508B80C6D;
        Tue, 15 Feb 2022 05:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D521C340EC;
        Tue, 15 Feb 2022 05:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644903089;
        bh=+ZzowgUcYtr8+DeP7fjxh31Tuoh9AD2c4/Yi40f98Yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cgDl7WXTUQzAUZ4Hoj46W6XNrmdm1WfcTUJ3PxjgDfMI0044lLvHhaFEoOEkfgm/2
         yd4G8vvtUDNL7ScU00+OxXvK6yD8opDPtNGa2ase7T5vG3ae9Tipzs2wikDFX4Zr4k
         1rc/qjl8TiSPqH1vFP38UwrdgtQ5HH0WYqZ5Uwq/h6qlJyhYnLyZvlGS2gg6ipIUbH
         8GJesWgbDERb7X+8+qi+1ms0JUDonONjAN9UmSXNDIXiuRyzucEVjiGOzG7Nf+5DH6
         DBD5rAN3rHkUq4+REhwEmKrBmJik4yVvtmaDh91mM5NThmC0QoCt1qrb61wxy5zHIf
         sRztnViiqUhVQ==
Date:   Mon, 14 Feb 2022 21:31:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wang, Haiyue" <haiyue.wang@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        "David Awogbemila" <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        "Forrest, Bailey" <bcf@google.com>, Tao Liu <xliutaox@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Fraker <jfraker@google.com>,
        "Yangchun Fu" <yangchun@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] gve: fix zero size queue page list allocation
Message-ID: <20220214213127.3aa9ea5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR11MB34959983354A8C81B065AB5EF7349@BYAPR11MB3495.namprd11.prod.outlook.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
        <20220214212136.71e5b4c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BYAPR11MB34959983354A8C81B065AB5EF7349@BYAPR11MB3495.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 05:25:49 +0000 Wang, Haiyue wrote:
> > On Mon, 14 Feb 2022 10:41:29 +0800 Haiyue Wang wrote:  
> > > According to the two functions 'gve_num_tx/rx_qpls', only the queue with
> > > GVE_GQI_QPL_FORMAT format has queue page list.
> > >
> > > The 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero sized
> > > memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
> > >
> > > The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
> > > address, so the driver can run successfully. Also the code still checks
> > > the queue page list number firstly, then accesses the allocated memory,
> > > so zero number queue page list allocation will not lead to access fault.
> > >
> > > Use the queue page list number to detect no QPLs, it can avoid zero size
> > > queue page list memory allocation.  
> > 
> > There's no bug here, strictly speaking, the driver will function
> > correctly? In that case please repost without the Fixes tag and  
> 
> Code design bug, the 'queue_format == GVE_GQI_RDA_FORMAT' is not correct. But,
> yes, it works. So still need to remove the tag ?

A bug is something that users can notice. If there are conditions under
which this may lead to user-visible mis-behavior then we should keep
the tag and send the patch to stable as well.

If there is no user-visible problem here, then the patch is just
future-proofing / refactoring and we should not risk introducing real
bugs by making people backport it (which is what adding a Fixes will
do).
