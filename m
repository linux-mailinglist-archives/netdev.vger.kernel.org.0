Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E69576AFC
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGPAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGPAAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:00:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B394C95B29
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0ABB8252D
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF6CC34115;
        Sat, 16 Jul 2022 00:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657929644;
        bh=+VMjW5Hu/CpmEVecloFYjY6dJgRj/Fac4bkrezdAqXg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aOl7MIAO8+nNbVWX5zzTLvLd2cXd8akajtWyirLJdbYcFeX9gC2e+N2M0nC0MAIGr
         fCiteBISTUhF7rRaUIzqc0nVeoJ6+poguw0+sic3/buIOsXgaikX5gjxmQTeLKpW+z
         0z9eoWTzzFhD0tTIpey4n6S7rE5zfxKgp2rnl13w/xTEd1XgbzEfF8MF/fCfGzJZr8
         dAunauQyeo9lICZ7ldXoVubkFzz50QW2NLMlonbFWyw730/Sa0bopSx7cZNDNasG65
         /Eqo5AckFkeVAUYjgZwCv++8yof7qVMbloM8tilC24IQqAR6dCD6033Xhm0OxeTnhA
         L1Ct87HnEiAfA==
Date:   Fri, 15 Jul 2022 17:00:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20220715170042.4e6e2a32@kernel.org>
In-Reply-To: <20220715232641.952532-1-vladimir.oltean@nxp.com>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
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

On Sat, 16 Jul 2022 02:26:41 +0300 Vladimir Oltean wrote:
> Documentation/networking/bonding.rst points out that for ARP monitoring
> to work, dev_trans_start() must be able to verify the latest trans_start
> update of any slave_dev TX queue. However, with NETIF_F_LLTX,
> netdev_start_xmit() -> txq_trans_update() fails to do anything, because
> the TX queue hasn't been locked.
> 
> Fix this by manually updating the current TX queue's trans_start for
> each packet sent.
> 
> Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave ports")
> Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Did you see my discussion with Jay? Let's stop the spread of this
workaround, I'm tossing..
