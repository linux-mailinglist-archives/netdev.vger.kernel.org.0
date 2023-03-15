Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF486BA74E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCOFnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjCOFnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289BF4AFC0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA5B7B81C76
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F69C433EF;
        Wed, 15 Mar 2023 05:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678858993;
        bh=FkG5jBow06RCQeQ2P8k71zpDcSSdYSMIP1IIyg1BwYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aCEy4GdRHtvdHxgBEZVs+Ok2tJL2FZ3kZWkDyR+Q8mFtbpBcxNM2Nfm8eVx+FqOX6
         0XtL+xBMCIx/LLDQgO35+I2LsHgFQ7YAEPxPvtz04KC2OIyqXiajPDoOGmwfgWu4PF
         U/ZU7E3BEt3YbykfGqEK2rVQEcheZx5Tu8k7El2oLzDOD9eoV9FwnY4l4a0Kes9WhO
         wUp3Jp+94fko48YC/oekmlDPtJiRieaxDDQfgP3yTXcmI+Pd8kNmO0uSBCH9E18lrt
         Kqip+SdI3bybTxZ2U+lOyLRA09Li8hWSPQGgUi+cPnrm79BlzDOpD9co/qwOG1c54R
         J69R5Vv2sw2zQ==
Date:   Tue, 14 Mar 2023 22:43:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tao Liu <taoliu828@163.com>
Cc:     paulb@nvidia.com, roid@nvidia.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH for-5.10] skbuff: Fix nfct leak on napi stolen
Message-ID: <20230314224312.41b6b248@kernel.org>
In-Reply-To: <20230314121017.1929515-1-taoliu828@163.com>
References: <20230314121017.1929515-1-taoliu828@163.com>
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

On Tue, 14 Mar 2023 20:10:17 +0800 Tao Liu wrote:
> Upstream commit [0] had fixed this issue, and backported to kernel 5.10.54.
> However, nf_reset_ct() added in skb_release_head_state() instead of
> napi_skb_free_stolen_head(), which lead to leakage still exist in 5.10.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984
> 
> Fixes: 570341f10ecc ("skbuff: Release nfct refcount on napi stolen or re-used skbs"))
> Signed-off-by: Tao Liu <taoliu828@163.com>

I'm not sure Greg will spot this. Make sure you CC stable.
