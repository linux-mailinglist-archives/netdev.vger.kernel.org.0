Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15556C28AB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCUDmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUDmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:42:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102932E56;
        Mon, 20 Mar 2023 20:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA38EB81235;
        Tue, 21 Mar 2023 03:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17888C433EF;
        Tue, 21 Mar 2023 03:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679370116;
        bh=Jk2T8KzAk6AYQ1kjo+O7hUQbaKhmKLsFTuvlYvwxK/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oLf3l/0yU8YpuM7jfKUSyIKeoRoUdovOG9TYbeB30Wm8DCFIhnaL6MV24hkWZyeUi
         6zntvyKAunOQIffo2oeilPDVtH4aJAV0jofS/FBZkNcRE+rIbye/YZnJ1A3rnj/G9N
         rIvBgzbrwLPBn3WT5EBKLRtM/fCUT4srAorE1TX+XroTG2dxAn3sjDnSNVzrDn63Z5
         4U0YEr+xP21vy0nzcmFci9MHCHCEsBP903MTQ5c275B9i8ZSY9Kn6uHYE4A5RvCkBX
         CL+b8t1GpWaKooO9pIVDpcC21GnX3+ZTBEVLVQcqcQUApDiAeDVzcATDiDvffwRsiR
         wQjxtHPocjnNg==
Date:   Mon, 20 Mar 2023 20:41:53 -0700
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
Subject: Re: [PATCH net-next v2 09/12] net: stmmac: Add EMAC3 variant of
 dwmac4
Message-ID: <20230320204153.21736840@kernel.org>
In-Reply-To: <20230320221617.236323-10-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
        <20230320221617.236323-10-ahalaney@redhat.com>
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

On Mon, 20 Mar 2023 17:16:14 -0500 Andrew Halaney wrote:
> The next approach that was checked was to have a function pointer
> embedded inside a structure that does the appropriate conversion based
> on the variant that's in use. However, some of the function definitions
> are like the following:
> 
>     void emac3_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)

I checked a couple of callbacks and they seem to all be called with
priv->iomem as an arg, so there is no strong reason to pass iomem
instead of priv / hw. Or at least not to pass both..

I think that's a better approach than adding the wrappers :(

Are you familiar with coccinelle / spatch? It's often better than 
just regexps for refactoring, maybe it can help?
