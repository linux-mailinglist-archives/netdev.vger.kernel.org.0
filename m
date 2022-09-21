Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4355BFE05
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIUMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiIUMgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:36:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D623804BE
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD2A862AC9
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C06C433C1;
        Wed, 21 Sep 2022 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663763797;
        bh=Aa7CovEdNPduFUaorzvyihAuHXr32FqfEG7hPi2Dcz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A3ftAg39TXCTlxPEgWazIvbMU2uaExktVnIdBH1+3zw2wXSaKs5SVmH2d+ivqWCyP
         E+Hw3sJnjLloHGxsrfqaCSM/0M7AqvlsaYwq2jz/KeSIXe1/pWTQz6wrG6OukDKClp
         6yQKS/o4FSc8HkpL/svX9IjOuI2OraIOqgyj0ZfZdRGh7cjHIgQpNMcBilRufDW8va
         /7GCQtmqMDNoQOEINKLX1fiv4Sqh983L5qN5Z+EIKWtikhGOjwTbTmEp2V2ZNCmQyq
         e7MAA1RPLK1Y54vG0Z+PO1910FSzBpd+DtsRZ+RiPC+xiFlQgnDZPaKcl7/DmfaW74
         x69wGdt4luIMg==
Date:   Wed, 21 Sep 2022 05:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Liang He" <windhl@126.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
Message-ID: <20220921053635.06ad8511@kernel.org>
In-Reply-To: <5722f6ba.6204.1835f4924aa.Coremail.windhl@126.com>
References: <20220915040655.4007281-1-windhl@126.com>
        <20220920174529.3e8e106d@kernel.org>
        <5722f6ba.6204.1835f4924aa.Coremail.windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 17:02:52 +0800 (CST) Liang He wrote:
> At 2022-09-21 08:45:29, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >On Thu, 15 Sep 2022 12:06:55 +0800 Liang He wrote:  
> >> In prestera_port_sfp_bind(), there are two refcounting bugs:
> >> (1) we should call of_node_get() before of_find_node_by_name() as
> >> it will automaitcally decrease the refcount of 'from' argument;
> >> (2) we should call of_node_put() for the break of the iteration
> >> for_each_child_of_node() as it will automatically increase and
> >> decrease the 'child'.
> >> 
> >> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> >> Signed-off-by: Liang He <windhl@126.com>  
> >
> >Please repost and CC all the authors of the patch under Fixes.  
> 
> Thanks for your reply, Jakub
> 
> As I was the only one author, you mean following tag format:
> 
> ""
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> CC: Liang He <windhl@126.com>
> Signed-off-by: Liang He <windhl@126.com>

No, no, CC the authors of the patch under fixes, which is to say -
the patch which introduced the problem. The fixes tag you have is:

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")

so:

commit 52323ef75414d60b17f683076833eb55a6bffa2b
Author: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Date:   Tue Jul 19 13:57:16 2022 +0300

    net: marvell: prestera: add phylink support
    
    For SFP port prestera driver will use kernel
    phylink infrastucture to configure port mode based on
    the module that has beed inserted
    
    Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
    Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
    Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
    Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
    Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
    Signed-off-by: David S. Miller <davem@davemloft.net>

I was asking to also CC Yevhen and Oleksandr. Taras seems already CCed.
