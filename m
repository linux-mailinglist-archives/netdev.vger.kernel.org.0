Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81F068388D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAaVVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAaVVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:21:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1366C561B0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A206E616D2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C370AC433D2;
        Tue, 31 Jan 2023 21:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675200091;
        bh=QQyvXTUOdXYr4EOshabRa7qhjJfXg2s0SdzQbkVaoL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pncUS/98kS8tpSyXstBFRYR4sy6ybcbmPk/f77OKIl/QlTWoDdw6O2uUa2LfpNv/r
         F+IY1rygzNfxbM2itgKjrdJEH0YTPQEB37OoapE5pKi+fMxG0qIM/YbpT7vy7njrHy
         OHTp5rBqhA2vlom5ObzQsyRpjBZMigyWJCebcuzM72SH1tTItO5DthiujW0cHhwKMU
         FwB6xEUkoA5mbrMA3g7jvRNKrLA0oxNvgHsmQLnAf/zOfptpKljQiA71kRkI07768i
         pKg/P3EDxTqIC2s2oAFvPZwSJdFubKjBxbnSvaB0xfupUwEjCRnrd14knHSoO24L8K
         zMYQ9bpe7l1Ag==
Date:   Tue, 31 Jan 2023 13:21:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Message-ID: <20230131132129.0d043582@kernel.org>
In-Reply-To: <Y9kXV1LvDfXjzA9R@unreal>
References: <20230131080313.2076060-1-simon.horman@corigine.com>
        <Y9j/Rvi9CSYX2qSk@unreal>
        <Y9kGcnKUUO5HURZX@corigine.com>
        <Y9kXV1LvDfXjzA9R@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 15:27:51 +0200 Leon Romanovsky wrote:
> > > > +	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
> > > > +		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));  
> > > 
> > > This memset can be removed if you initialize lag_info to zero.
> > > struct nfp_tun_neigh_lag lag_info = {};  
> > 
> > Happy to change if that is preferred.
> > Is it preferred?  
> 
> I don't see why it can't be preferred.

It's too subjective to make Simon respin, IMO.
