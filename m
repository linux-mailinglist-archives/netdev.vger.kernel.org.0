Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F94562A3A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiGAEPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiGAEPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7759220C6;
        Thu, 30 Jun 2022 21:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA9662308;
        Fri,  1 Jul 2022 04:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B72FC341C7;
        Fri,  1 Jul 2022 04:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656648935;
        bh=nJlI/Jamu/8sQmVxqIyvQSpUXbhqCWxKej5hmDDfaIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Llp1ksqgfDmiCd1pwpbpbiiI/s0klFoGRwf63umUn2iLf5NPLMnFTmWAhQfRpzacP
         DgwsPRoQxivMa18KXjf2+K2xag3jNu55QB8kFLHrF6Pl6HxlHk43o/5DFkqh82PuXR
         0GSOoypLQQmv7CPj1OL4PGGEnCzFIaoIpNBylrAntNhDJf9OXfWeB7VqwOrvTLhQYz
         PseDLjx63PiAoLyqrtg6YkmE5uP15ShK3YInN0glxxNxeyv4Y/bjcM0GJpLXLjqgwh
         0n4xDmEIBwxhkpoBkTAmHnZfrKc0eC/KHxNXeJiyVybeH3WH/959KT2GjtrAg6gYDA
         nXXxC+dbkLLqQ==
Date:   Thu, 30 Jun 2022 21:15:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <jbrouer@redhat.com>, <hawk@kernel.org>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next v2] net: page_pool: optimize page pool page
 allocation in NUMA scenario
Message-ID: <20220630211534.6d1c32da@kernel.org>
In-Reply-To: <20220629133305.15012-1-huangguangbin2@huawei.com>
References: <20220629133305.15012-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 21:33:05 +0800 Guangbin Huang wrote:
> +#ifdef CONFIG_NUMA
> +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
> +#else
> +	/* Ignore pool->p.nid setting if !CONFIG_NUMA */
> +	pref_nid = NUMA_NO_NODE;
> +#endif

Please factor this out to a helper, this is a copy of the code from
page_pool_refill_alloc_cache() and #ifdefs are a little yuck.
