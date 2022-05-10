Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D975522596
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiEJUje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiEJUje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB2269EE5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A10F2B81FA8
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5308C385CA;
        Tue, 10 May 2022 20:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652215170;
        bh=ObY94XOPq6sKsw2cpYgvLyFIO32B2GNnzPbNfJ+Qp/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GAbqm2peJ9/4g5EQAhAyfqwtofzgYXVR5GbNJDmWrEI7jAxrgSDiEJV8HbzMdd6kV
         BIEkjieK+4/8K5C2dBkcQgXfmoM2mEvuASN5j3SIc+QX2V1KDFBS0WPEZ1ptM2KdqJ
         epzfJgwwIh2mfnL+F/PfeIERnHWA3nScV8XQsJWn7PcSO+ZKS0Ui45fqW93+UAkc37
         ef8mVZaRU/rvQPd0d15lxj8FoOb1d6+jTaiC/7wKqPxy1CvBUqVl4zsig+CjZLBBZU
         c8lqGlPu4HKv+KLExk1+kGK0GdIOsyPDVB4/ZFYyz1imQpEx90ULyqCy8IJhqzvk3r
         8c9b1+9uMzp1g==
Date:   Tue, 10 May 2022 13:39:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
 output properties
Message-ID: <20220510133928.6a0710dd@kernel.org>
In-Reply-To: <20220509143635.26233-2-josua@solid-run.com>
References: <20220428082848.12191-1-josua@solid-run.com>
        <20220509143635.26233-1-josua@solid-run.com>
        <20220509143635.26233-2-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 May 2022 17:36:33 +0300 Josua Mayer wrote:
> +  adi,phy-output-clock:
> +    description: Select clock output on GP_CLK pin. Three clocks are available:
> +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
> +      The phy can also automatically switch between the reference and the
> +      respective 125MHz clocks based on its internal state.
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +      - 25mhz-reference
> +      - 125mhz-free-running
> +      - 125mhz-recovered
> +      - adaptive-free-running
> +      - adaptive-recovered

I'm still not convinced that exposing the free running vs recovered
distinction from the start is a good idea. Intuitively it'd seem that
it's better to use the recovered clock to feed the wire side of the MAC,
this patch set uses the free running. So I'd personally strip the last 
part off and add it later if needed.

But I won't fuss, if we get an ack from one of the PHY maintainers -
I'll merge as is.

Andrew? 
