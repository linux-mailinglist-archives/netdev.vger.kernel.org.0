Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503E755A137
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiFXSlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiFXSle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:41:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20718124A;
        Fri, 24 Jun 2022 11:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 438A4B82B93;
        Fri, 24 Jun 2022 18:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89421C34114;
        Fri, 24 Jun 2022 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656096091;
        bh=LLrh7VajFjPgitdpBx89svk5eDbdeDVcrRqjN+kDTDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3B77Hsu8ocmQuG9T1pjrdkUwWevlJCUG7iQDR6TqJAUsrAbCNkilN7IrUvH1NK+z
         /5J54VlciMTaMr8euisYbiIxTKYvhmjluVkInxyu4lnvxq//ZNSAsCSg/lFS/iPt01
         TTaLvL6xyyEp2cWxtcN5221lca2zKbMoM12UIhe1kHzFARnMGk61i5B1dQged6eFo9
         0iTNBagNiaePhn12/PADqa8PJrXmDGlWWFWulv8DHsgO4k/trm/zmVWv/pjBdUlMfs
         RmE11DpZac+DZlZJabuS5j1vIzTSUAVj2SqcDdNTV2lREgMLvZrOaj2NiTFfjHadrK
         Dt5GgW0TccpvA==
Date:   Fri, 24 Jun 2022 11:41:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yilun Wu <yiluwu@cs.stonybrook.edu>
Subject: Re: [PATCH] epic100: fix use after free on rmmod
Message-ID: <20220624114121.2c95c3aa@kernel.org>
In-Reply-To: <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
References: <20220623074005.259309-1-ztong0001@gmail.com>
        <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 11:22:28 +0200 Francois Romieu wrote:
> Tong Zhang <ztong0001@gmail.com> :
> > epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
> > we already freed the dma buffer. To fix this issue, reorder function calls
> > like in the .probe function.
> > 
> > BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
> > Call Trace:
> >  epic_rx+0xa6/0x7e0 [epic100]
> >  epic_close+0xec/0x2f0 [epic100]
> >  unregister_netdev+0x18/0x20
> >  epic_remove_one+0xaa/0xf0 [epic100]
> > 
> > Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
> > Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
> > Signed-off-by: Tong Zhang <ztong0001@gmail.com>  
> 
> The "Fixes:" tag is a bit misleading: this code path predates the move
> by several years. Ignoring pci_* vs dma_* API changes, this is pre-2005
> material.

Yeah, please find the correct Fixes tag.

> Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>

Keep Francois' tag when reposting.
