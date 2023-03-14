Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93CF6B8718
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCNAkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCNAkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA56F87A14;
        Mon, 13 Mar 2023 17:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E3F6157B;
        Tue, 14 Mar 2023 00:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD300C433D2;
        Tue, 14 Mar 2023 00:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678754347;
        bh=I5IHq5bn2nVWOr2WOI4rN3AaQ6amvwyigKJTJsYavWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RruQ+s06WTk+cgWdUxjMHNjDsZv9dZeRSQBbtDz0mm8ecHaKRqyke90dcSCWbvpdf
         xOy6FZr9xiRMMF/3D/cbp9YhCSUxmF4asMpc9X0jdYOSBJLfzwpXIkETHdpLgvYyCO
         6ogWtkTJZhcch7QFSxcA7085rNO2EqjU0h3aQ5qvpCp+OQCJK1bpQylahTJj4TH7b1
         flkn6Ia7DtYZvHaLvyfmfKFMEcEqxDyH8NMzkQuRtlTccvCTa0Xd09hJOJ+cftRDxb
         aGOg+4Wf3ZWGxTxeTiNbrB9hUFlgB2r1+ebAK0+DVcjF0WdYdNoqS3IqP3KOrhN7iK
         GIEJl2rq3Q6LQ==
Date:   Mon, 13 Mar 2023 17:39:04 -0700
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
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 08/11] net: stmmac: Add EMAC3 variant of dwmac4
Message-ID: <20230313173904.3d611e83@kernel.org>
In-Reply-To: <20230313165620.128463-9-ahalaney@redhat.com>
References: <20230313165620.128463-1-ahalaney@redhat.com>
        <20230313165620.128463-9-ahalaney@redhat.com>
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

On Mon, 13 Mar 2023 11:56:17 -0500 Andrew Halaney wrote:
> EMAC3 is a Qualcomm variant of dwmac4 that functions the same, but has a
> different address space layout for MTL and DMA registers. This makes the
> patch a bit more complicated than we would like so let's explain why the
> current approach was used.

Please drop all the static inlines in C sources, you're wrapping 
a single function call, the compiler will do the right thing.

Please no more than 6 function arguments.
