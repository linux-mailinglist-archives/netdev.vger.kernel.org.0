Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CD254A8E6
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbiFNFtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiFNFtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:49:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400743A70A;
        Mon, 13 Jun 2022 22:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E52B80D47;
        Tue, 14 Jun 2022 05:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DAFC3411B;
        Tue, 14 Jun 2022 05:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655185758;
        bh=R+0qAAX6efv+AygD/S2OgXLLIy/Y/Bbh3wzi0ZGiAWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PYNoPUtL9o4blp5GFVcqKknV93aauo63yGEnKIVW30K7HR/1jkDXld2d/XUhxx6/2
         239sw6OgsseZPYwoxf+GT3DKTYlqIcPibec6wchik4vBaRsXllag2VIz0DPZjEpah2
         yRvOqdBds2oqlZC4fmDYQv/WSMEAWOG3HBLObpjFRlykmKy95Gku+w77MOGKLYDxTy
         qZ8WhEnd9eavxACzB+XBITuOTmBK4sS87kRdCSuEoB+pWIEvoqHQT2R3DAg3E0v5uO
         sIsdRkmRM/VGX8V8mnxPb+1d6DE4PG1YkZOjC4vztpSEbOY5iu5v9DTcNLTISR1vYg
         t5QOZCjsc0QPg==
Date:   Mon, 13 Jun 2022 22:49:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Mentovai <mark@moxienet.com>
Subject: Re: [net-next PATCH 2/2] net: ethernet: stmmac: reset force speed
 bit for ipq806x
Message-ID: <20220613224917.325aca0a@kernel.org>
In-Reply-To: <20220609002831.24236-2-ansuelsmth@gmail.com>
References: <20220609002831.24236-1-ansuelsmth@gmail.com>
        <20220609002831.24236-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jun 2022 02:28:31 +0200 Christian 'Ansuel' Marangi wrote:
> +	dn = of_get_child_by_name(pdev->dev.of_node, "fixed-link");
> +	ret = of_property_read_u32(dn, "speed", &link_speed);
> +	if (ret) {
> +		dev_err(dev, "found fixed-link node with no speed");
> +		return ret;

Doesn't this return potentially leak the reference on dn?
You move the of_node_put() right before the if (ret) {

> +	}
> +
> +	of_node_put(dn);
