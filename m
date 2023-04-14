Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC76E1B65
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDNFAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDNFAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5DA10EC;
        Thu, 13 Apr 2023 22:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA0306439C;
        Fri, 14 Apr 2023 05:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B95C433D2;
        Fri, 14 Apr 2023 05:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681448448;
        bh=CXO10PjY2/zG6b2bRTZgyHaMtJBiQFKnOvBLnoXwp3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OtxFy53iprI5S3FaCLu1j1YLT0nHaMG8mq5nDd6a6av6Sq5yXeJBsgN9vYA7zZuaS
         yz6zr5CmXoNY59Km5LDmkHHECjVlUacCK6Dgj3qa6JRFVdxfxE5VxO2wXTa2DeNlH7
         Kwwb9OQbNnLbyZCZWmLKQWtxGT9dpnk7C6zJRIFDvNPjsz1jLBj8bnOSyU2oHprzWj
         eCNTwFxRbqkUoT+zuIiCKFvBwbeOXI5p8cmM5ZR5jMD3rzKM7FCcw36Em1r2/uGoMX
         gGkEpypLzQaO0I4uAcgiNtuT7dqAKj1TxFOoJSMH6TZvIqwpXqTIm3a/vXCe3sUH5X
         ANM9oT9ucXZQA==
Date:   Thu, 13 Apr 2023 22:00:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yan Wang <rk.code@outlook.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        netdev@vger.kernel.org (open list:STMMAC ETHERNET DRIVER),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next v3] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
Message-ID: <20230413220046.267fdc31@kernel.org>
In-Reply-To: <KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB544872920F00149E3BDDC7ECE6999@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 11:07:10 +0800 Yan Wang wrote:
> The system hang because of dsa_tag_8021q_port_setup()->
> 				stmmac_vlan_rx_add_vid().
> 
> I found in stmmac_drv_probe() that cailing pm_runtime_put()
> disabled the clock.
> 
> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> resume/suspend is active.
> 
> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
> registers after stmmac's clock is closed.
> 
> I would suggest adding the pm_runtime_resume_and_get() to the
> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> while in use.
> 
> Fixes: b3dcb3127786 ("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
> Signed-off-by: Yan Wang <rk.code@outlook.com>

Happy to see you managed to work around the email server problems!

Please make sure to read this doc before posting the next version:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
