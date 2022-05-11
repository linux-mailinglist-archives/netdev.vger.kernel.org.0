Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4780522991
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbiEKCU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241104AbiEKCUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189471F7E03;
        Tue, 10 May 2022 19:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D1BB820C2;
        Wed, 11 May 2022 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFDEC385D8;
        Wed, 11 May 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652235621;
        bh=0Oktqdyo/WA/sFzulpP5olHWG1Z+Sf0H9udzHf6YJ/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jxu0lUvVjjhg7ytrUYQA9YCgt8W0XckTvBijUTQ6kpoSCDlBWNG6K4aXF+iEkFl7F
         9mPurwzxlj3y84mqEDAE7COznS+nPj1Ar6BMrjq4A+ytxlKUhekUqfgiwEl3Uj/RxN
         SkByBQk6iikIfuu4vde5e0IRr03F609D2sdfTsNQrqhBENzIeXJQ1pMCrvFHRSUKzM
         zJjEECoMYMJXE3CeURMdOLT7czy3OmJAhF6tGnCfaFKgMYX63gRc6dYXrd3cHh/shR
         Q7LvwNsZIU5d5UPzFbFinHgFhpTUAYyXVhE+GEm2OTXm+WtWSp6UkkIMPPNW42BHwg
         uzMszseHsiVzg==
Date:   Tue, 10 May 2022 19:20:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/17] netfilter: ecache: use dedicated list
 for event redelivery
Message-ID: <20220510192019.2f02057b@kernel.org>
In-Reply-To: <20220510122150.92533-2-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
        <20220510122150.92533-2-pablo@netfilter.org>
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

On Tue, 10 May 2022 14:21:34 +0200 Pablo Neira Ayuso wrote:
> +next:
> +	sent = 0;
> +	spin_lock_bh(&cnet->ecache.dying_lock);
> +
> +	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
...
> +		if (sent++ > 16) {
> +			spin_unlock_bh(&cnet->ecache.dying_lock);
> +			cond_resched();
> +			spin_lock_bh(&cnet->ecache.dying_lock);
> +			goto next;

sparse seems right, the looking looks off in this function
