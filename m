Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B39D571089
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 04:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiGLC6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 22:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLC6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 22:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6862B600
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 19:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279ED616DE
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47764C34115;
        Tue, 12 Jul 2022 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657594688;
        bh=vgLn7n9RqHasSg1PLAJZYoy8dtByrNoKPQonuE1IEdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzeShxIU/b3Pv8nxktTfRvtKq/RqNoMLGtdsCJEDuDsylxfoYT42br3fWkrcBGsRJ
         91Ed2gSw/+96Ym6/OaRJKqsAugpHCO3OUTX9ow1fAKlLxpurrmAGwOHmFTSkF7gPJm
         IB59KkuRJ2iheOAZ0L7Rx6uNVXCbzt8NNinUH4K8fUpUZOvKJiFM4FEhA8R4+lcMUV
         JHN/ByD2TkzyRi5O2/1TsB/Sjw+nKApF+4bpRmb4iUh0ShGt24GK5R2SAcR41lDe3e
         a+JhsIoav3OuxMAbEnBHUyO4ea3iKDT0ZqpvhO+kvfYxDz0aEHzghvn5istGSat+Dj
         6kRRl4oEI8JUA==
Date:   Mon, 11 Jul 2022 19:58:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ftgmac100: Hold reference returned by
 of_get_child_by_name()
Message-ID: <20220711195807.4f4749ef@kernel.org>
In-Reply-To: <20220710020728.317086-1-windhl@126.com>
References: <20220710020728.317086-1-windhl@126.com>
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

On Sun, 10 Jul 2022 10:07:28 +0800 Liang He wrote:
> +static inline struct device_node *ftgmac100_has_child_node(struct device_node *np, const char *name)
> +{
> +	struct device_node *child_np = of_get_child_by_name(np, "mdio");
> +
> +	of_node_put(child_np);
> +
> +	return child_np;

Could you make the return type bool ? We don't have a reference on 
the child_no node, we should probably not return the pointer.

Also the "inline" keyword is unnecessary the compiler will inline 
a small, static function with a single caller, anyway.
