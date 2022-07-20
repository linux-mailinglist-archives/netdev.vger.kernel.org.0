Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4864957C0FF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiGTXmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiGTXmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:42:12 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C7B49B42
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:42:11 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id o1so177391qkg.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W0m+zaV/t9IfMCsWddU/BD/INu7/IDz+95VLsqfyLlk=;
        b=U3yy46ize2deAZrpfJnMv8YMz8IGVBTnhJcNPjIo6TTb4pcJ+2Rf0HGhY3BbVcCoWV
         Fr6INq63FCKPdfGdT5sCcLQZ66CU1vzCoHoPBI0mRx57jWPTUrS0g23L/KjiSFAwgK+H
         GO1ZJiWGPLaOR8bFzBjThFgxzhauTq5H8Ad5+6uwjMjSl/nfzhtcdI3wIRqNptpEJG+U
         jwSMlDrGPttQJtFu4an9vV+ShopsjhzcaZ5xQTRm0xyxBBGA30nLu3urNMzTKaoyWP2f
         UTSIu+6q3QG1VRi/P/fHe3ypCskf/KZ6FoqFqMNWVUl/YO7cyrklzl1QWXowrdWg5hgg
         DvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W0m+zaV/t9IfMCsWddU/BD/INu7/IDz+95VLsqfyLlk=;
        b=uKedKKO47kJeSE+9a3GGoGhQ1NLLkcR9EwRgdH+wJqwIQD9IbdcCQKYesT0NzEKYen
         aRs6JRrMy1vGxeMOiIXMXik4Zx+6SEHtKcWrUzMwItLWgFb5dkrVPMa9znMCmKOaLEb3
         5AFlQ50SmnnaI+est1E5ziQ8p5RxfnUc+q1OTaVBF6so9ZTZxbedwcpFx00jlr7frqOA
         Xo/Dvoh5tBTvncUkNgOzR/a5tgliLfOhtnsiZ4gIHMDEBnZ+wsplxaiN4+Ryp1IKjGw0
         cDpy8nP/Z9CRBHeUUxC1GCqpmdUlZz+WLQTHqV5mHWRxTvbgyQsfR3PsPVBuH8Hp4ZAm
         spOg==
X-Gm-Message-State: AJIora8TUfdWJ3RrhDnUQfV9IM27YCdT5YoABKp9Kcm/V8TUtAXJIMfq
        KkBPo11cLghD92Mz3ZjBPEhcqA==
X-Google-Smtp-Source: AGRyM1sNUsHEctZwjSnaPLK4IglthMasJNe6r6fUvGUFoDocPR+S9bJKHQmOgtSIqhnD9Bw+dxK6qg==
X-Received: by 2002:a37:555:0:b0:6b5:dace:f589 with SMTP id 82-20020a370555000000b006b5dacef589mr15076898qkf.444.1658360530482;
        Wed, 20 Jul 2022 16:42:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id z8-20020ac84308000000b0031ee1f0c420sm379908qtm.10.2022.07.20.16.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:42:09 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1oEJKT-001hih-C9; Wed, 20 Jul 2022 20:42:09 -0300
Date:   Wed, 20 Jul 2022 20:42:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Message-ID: <20220720234209.GP5049@ziepe.ca>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 06:48:09PM +0000, Long Li wrote:
> > > @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct
> > > mana_port_context *apc, u32 protection_dom_id,
> > >
> > >  	apc->tx_shortform_allowed = resp.short_form_allowed;
> > >  	apc->tx_vp_offset = resp.tx_vport_offset;
> > > +
> > > +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> > > +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
> > Should this be netdev_dbg()?
> > The log buffer can be flooded if there are many vPorts per VF PCI device and
> > there are a lot of VFs.
> 
> The reason netdev_info () is used is that this message is important
> for troubleshooting initial setup issues with Ethernet driver. We
> rely on user to get this configured right to share the same hardware
> port between Ethernet and RDMA driver. As far as I know, there is no
> easy way for a driver to "take over" an exclusive hardware resource
> from another driver.

This seems like a really strange statement.

Exactly how does all of this work?

Jason
