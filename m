Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6842859A806
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbiHSWEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHSWEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B49E3943;
        Fri, 19 Aug 2022 15:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B511861737;
        Fri, 19 Aug 2022 22:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA0FC433C1;
        Fri, 19 Aug 2022 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660946685;
        bh=rWQlTr9SCmxJUyVJc0dKVch+NwVi+wq5baqEhcW9GPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pZZcr1hlHlisGW9WQMDpbMPDXEZNeJK8nV/6os5ZV4I3UMtyB7j0EBTdSgqfmb8zd
         KRXpp9htQjsO2jnu+PT58RkKlmepglAkA+3bbthR0aaUox9mUR6UpXJT5Bwbi/e6Dy
         6ESQeTFAgmla4D9nnpaqw3b+iIYdepR5alnHGA42Pke0KC2PKCrKIPez7dko+lPbs6
         rTQg52t6pazrsepRlwwHcCg08/DHUz17bQZhIz/m84AHWbAFTqez57QdksSddfO61R
         JH1qRJheEthofzKn3oatOIRH2y+Pe/ZI5eZlZMCSHsP8w+anCjvqdU5PueHPDBP8R5
         kY1+r3iedVc1g==
Date:   Fri, 19 Aug 2022 15:04:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fec: change the default rx copybreak length to
 1518
Message-ID: <20220819150443.537904dc@kernel.org>
In-Reply-To: <Yv+y0x6MzVmShWL9@lunn.ch>
References: <20220819090041.1541422-1-wei.fang@nxp.com>
        <Yv+y0x6MzVmShWL9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 17:57:07 +0200 Andrew Lunn wrote:
> On Fri, Aug 19, 2022 at 05:00:41PM +0800, wei.fang@nxp.com wrote:
> > Set the default rx copybreak value to 1518 so that improve the
> > performance when SMMU is enabled. User can change the copybreak
> > length in dynamically by ethtool.  
> 
> Please provide some benchmark for this. And include a range of SoCs
> which include the FEC. Maybe this helps for the platform you are
> testing on, but is bad for imx25, Vybrid etc?
> 
> > + * The driver support .set_tunable() interface for ethtool, user
> > + * can dynamicly change the copybreak value.
> > + */  
> 
> Which also means you could change it for your platform. So a patch
> like this needs justifying.

Fully agreed, perhaps if the DMA mapping on the platform is extremely
slow we're better off making the platform use bounce buffers for
everything.

Another though is that you can try to manually sync only the parts 
of the buffers that the device actually touched instead of full 2kB,
and tell the DMA core to skip the sync of the full buffer.
