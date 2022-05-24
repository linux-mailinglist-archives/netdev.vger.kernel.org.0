Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1CB533132
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbiEXTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 15:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240814AbiEXTDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 15:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8B9E9F3;
        Tue, 24 May 2022 12:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1F3461668;
        Tue, 24 May 2022 19:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E931CC34100;
        Tue, 24 May 2022 19:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653418896;
        bh=KSZsbhwiRi3M8nxpOedIKbFYyLcvnJ63M8XoVXAIzeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BOFqdBMgOE0t35cDDks6OE8Twthx5wZ9OuWLqN4oNuXkjA0Pb8Z9VbTh69HeCJ/FR
         l57QTmEidl5VAJd6e7Vh6L+mR2QPo3h9NqADkIAtTdcofr2TUuPj69OyMYh4hvAlye
         TQDeR9aKkiVrcEmatu3vIBk3fyYAsj/jlY8O1nUZZhkrCutKeF4IwVDe88vyods8cm
         t5xgla4YRyo0yIOvq5u8SKI5g0Ma+J1GaZ/o8rqZPCnYl2NowzaoNMO4VHYmHVXWyg
         Mhl7uZK9xwW7RMLC0BwDLqcR38YHvimkH67Z29wnM6Ez4DywCNF6YAbKpJEGTbgBZH
         qb1dtcUpEGx0g==
Date:   Tue, 24 May 2022 12:01:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, guoheyi@linux.alibaba.com,
        chenhao288@hisilicon.com, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.17 10/12] net: ftgmac100: Disable hardware
 checksum on AST2600
Message-ID: <20220524120134.2c466107@kernel.org>
In-Reply-To: <CAK8P3a2EZKnLB5c9YuKbaug16tG7juidmQ+g-wLNHx_-zxTD5A@mail.gmail.com>
References: <20220524155929.826793-1-sashal@kernel.org>
        <20220524155929.826793-10-sashal@kernel.org>
        <CAK8P3a3J6gh-0Z8JKEBDva7ox39ps5CCxJ4K7T1LyWMbTHna8Q@mail.gmail.com>
        <CAK8P3a2EZKnLB5c9YuKbaug16tG7juidmQ+g-wLNHx_-zxTD5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 20:47:51 +0200 Arnd Bergmann wrote:
> On Tue, May 24, 2022 at 8:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Tue, May 24, 2022 at 5:59 PM Sasha Levin <sashal@kernel.org> wrote:  
> > >
> > >  # ip link set mtu 1410 dev eth0
> > >
> > > The observed results:
> > >
> > >  1500 - good
> > >  1434 - bad
> > >  1400 - good
> > >  1410 - bad
> > >  1420 - good  
> >
> > Does it require multiples of four? Maybe it just skips the last bytes?  
> 
> Nevermind, I missed that this was a backport of a merged patch, rather
> than a new one.

Great minds think alike, tho ;)

https://lore.kernel.org/all/YowcZUX3lwAA6c5k@lunn.ch/
