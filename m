Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2291D557693
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiFWJ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiFWJ0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:26:53 -0400
X-Greylist: delayed 220 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 02:26:52 PDT
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9AE43AEA;
        Thu, 23 Jun 2022 02:26:52 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 25N9MTVS377698;
        Thu, 23 Jun 2022 11:22:29 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 25N9MTVS377698
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1655976149;
        bh=EKIPvALK1cXTsZBALd26oq28Q8z0/i5tehmQMg7z91A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5jVj9dEVpeCInEvy7kYFtMEp010qxdn7S55rFfgJuXbeqBEBhoEC+361TTbGFXSl
         P3maJiQmPi1ThXl3I2O5DKrXgcaD54A38QROMvnaZ1dLOBwc7h+oCmbLshWIfiFd0h
         ReGH0sSmblIlM1R4GT/szagjF0QRNyq/u80ttTzQ=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 25N9MT45377697;
        Thu, 23 Jun 2022 11:22:29 +0200
Date:   Thu, 23 Jun 2022 11:22:28 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yilun Wu <yiluwu@cs.stonybrook.edu>
Subject: Re: [PATCH] epic100: fix use after free on rmmod
Message-ID: <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
References: <20220623074005.259309-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623074005.259309-1-ztong0001@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tong Zhang <ztong0001@gmail.com> :
> epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
> we already freed the dma buffer. To fix this issue, reorder function calls
> like in the .probe function.
> 
> BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
> Call Trace:
>  epic_rx+0xa6/0x7e0 [epic100]
>  epic_close+0xec/0x2f0 [epic100]
>  unregister_netdev+0x18/0x20
>  epic_remove_one+0xaa/0xf0 [epic100]
> 
> Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
> Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>

The "Fixes:" tag is a bit misleading: this code path predates the move
by several years. Ignoring pci_* vs dma_* API changes, this is pre-2005
material.

Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
