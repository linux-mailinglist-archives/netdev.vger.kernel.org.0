Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035C6576B16
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiGPAUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiGPAUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5F34E851
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367B562079
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774AC34115;
        Sat, 16 Jul 2022 00:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657930800;
        bh=NeGin9ifBVJAUix4KN2IlZ/4aWrNbCvV8jStOoVO0oA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WBFpj6a/low97F+QtJ9x9/2SoZmrzwGA/5sPP7dgVoaB9I2kUm5wR64ql5eVCw8f4
         Lt4BpmQBxoOz8F4sqgO7eJNLurt6X/EaAxH71+4y31GXx+6apkP+wbxzrhqn19S4E9
         KnE3wJAJTrR4X5qshyM0y2vvLmL5NzSLm/Fs7ZEQGHZoLfBFc4LMnpMnQ942SsXR8L
         mcM0v3/OaBireuM954tlwVuKOzm1tNB3Z4wkVPMkbp0tGKa7zNNmPfpO+DgejJ6w9Z
         xL6UfDZtJtMc0E3vZ/V55NmQ58EC3Uc6RNrkjrPym4WePNurj2d4opSxexAZ5pAV5/
         JO/IrakXvEHDg==
Date:   Fri, 15 Jul 2022 17:19:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Message-ID: <20220715171959.22e118d7@kernel.org>
In-Reply-To: <20220716001443.aooyf5kpbpfjzqgn@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
        <20220715170042.4e6e2a32@kernel.org>
        <20220716001443.aooyf5kpbpfjzqgn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jul 2022 00:14:44 +0000 Vladimir Oltean wrote:
> On Fri, Jul 15, 2022 at 05:00:42PM -0700, Jakub Kicinski wrote:
> > On Sat, 16 Jul 2022 02:26:41 +0300 Vladimir Oltean wrote:  
> > > Documentation/networking/bonding.rst points out that for ARP monitoring
> > > to work, dev_trans_start() must be able to verify the latest trans_start
> > > update of any slave_dev TX queue. However, with NETIF_F_LLTX,
> > > netdev_start_xmit() -> txq_trans_update() fails to do anything, because
> > > the TX queue hasn't been locked.
> > > 
> > > Fix this by manually updating the current TX queue's trans_start for
> > > each packet sent.
> > > 
> > > Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave ports")
> > > Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> > 
> > Did you see my discussion with Jay? Let's stop the spread of this
> > workaround, I'm tossing..  
> 
> No, I didn't, could you summarize the alternative proposal?

Make bonding not depend on a field which is only valid for HW devices
which use the Tx watchdog. Let me find the thread...
https://lore.kernel.org/all/20220621213823.51c51326@kernel.org/
