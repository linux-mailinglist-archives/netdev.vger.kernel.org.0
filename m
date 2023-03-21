Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1016C2895
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCUD2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUD2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA7A360B0;
        Mon, 20 Mar 2023 20:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D402B6194A;
        Tue, 21 Mar 2023 03:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCE4C433EF;
        Tue, 21 Mar 2023 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679369285;
        bh=gPaz0m5VwLPwRghqvP+CjqfIDdbUBC7XARXxckF53iU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U9aP+QFwl15u+q3ZUXeL7tMANBDg6IUHSaiJVTtMXXW84SMdmVBzZlwtprQKRJrrh
         brRsPaWA1aaBp/yJukvczyrPVnpUFfpduzSz3a6rGCTcOqai6meplCoJfbjiLzoKYu
         LbfDelSJfbxIf76FdEgMHyZH3y6oX0vIqarLJw3UfpJcanG7g5Jyc16aozp8ffR4dL
         rvgOA1yfhCAerANOnORiGkZ98Z1vivobuNiguIS1aw/oepjG0obV92Oed2M6v2QXzB
         MVmbtaHKqlfXofv4v4PLTa/855P2iJz9mWYvrXfpKGbw4M7TNvoougEYBTPViWI4bn
         gBJ7PcWu8Pnag==
Date:   Mon, 20 Mar 2023 20:28:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v2 00/12] Add EMAC3 support for sa8540p-ride
Message-ID: <20230320202802.4e7dc54c@kernel.org>
In-Reply-To: <20230320221617.236323-1-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 17:16:05 -0500 Andrew Halaney wrote:
> This is a forward port / upstream refactor of code delivered
> downstream by Qualcomm over at [0] to enable the DWMAC5 based
> implementation called EMAC3 on the sa8540p-ride dev board.
> 
> From what I can tell with the board schematic in hand,
> as well as the code delivered, the main changes needed are:
> 
>     1. A new address space layout for /dwmac5/EMAC3 MTL/DMA regs
>     2. A new programming sequence required for the EMAC3 base platforms
> 
> This series makes those adaptations as well as other housekeeping items
> such as converting dt-bindings to yaml, adding clock descriptions, etc.
> 
> [0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
> 
> v1: https://lore.kernel.org/netdev/20230313165620.128463-1-ahalaney@redhat.com/

At a glance 1-4,8-12 need to go via networking, 5 via clock tree,
and 6,7 via ARM/Qualcomm.

AFAICT there are no strong (compile) dependencies so we can each merge
our chunk and they will meet in Linus's tree? If so please repost just
the networking stuff for net-next, and the other bits to respective
trees, as separate series.
