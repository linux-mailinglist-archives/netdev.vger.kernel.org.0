Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E794ED375
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 07:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiCaFuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 01:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiCaFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 01:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB41EF
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 22:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4757EB81E0A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 05:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC8AC340ED;
        Thu, 31 Mar 2022 05:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648705707;
        bh=XbCoaj13uluokXsUzl6YF55ClKCfKZ0nCC4luREuWNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tuh1exPjiEEbsJNeeAwXCtlVCRITGoQ5cCLaaf1Br/ctZLVoPSOQ7Djdc1sZfsiWc
         jw+XqmcGFtiRiO4VZKymcjqppZLT3ZUI3kDQP9aJNdxTpCM2IFwjuhFWCT7gFXl/Ha
         zsrtv6j8C8ZB5ulkzKqwr+O5e9CnvH90ERXHMQznIVSSYuvlTvPkMJ78cyiyFBlIiV
         EYshqSsXtQv8RRsPoWIpFCQqpZDw23vSdkJQXc7FEtgIN2GUqE/v4msFEu9d6cvP3E
         4cwESCGjc8+w3iOAwzV8+NO14vk8I7S6S/2UAdewi78NiuURIWW92w0sH61DSt/6/C
         +VqXT6PrT7ydw==
Date:   Wed, 30 Mar 2022 22:48:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: Re: [PATCH net] tipc: use a write lock for keepalive_intv instead
 of a read lock
Message-ID: <20220330224826.500183dc@kernel.org>
In-Reply-To: <20220329161213.93576-1-dossche.niels@gmail.com>
References: <20220329161213.93576-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 18:12:14 +0200 Niels Dossche wrote:
> Currently, n->keepalive_intv is written to while n is locked by a read
> lock instead of a write lock. This seems to me to break the atomicity
> against other readers.
> Change this to a write lock instead to solve the issue.
> 
> Note:
> I am currently working on a static analyser to detect missing locks
> using type-based static analysis as my master's thesis
> in order to obtain my master's degree.
> If you would like to have more details, please let me know.
> This was a reported case. I manually verified the report by looking
> at the code, so that I do not send wrong information or patches.
> After concluding that this seems to be a true positive, I created
> this patch. I have both compile-tested this patch and runtime-tested
> this patch on x86_64. The effect on a running system could be a
> potential race condition in exceptional cases.
> This issue was found on Linux v5.17.
> 
> Fixes: f5d6c3e5a359 ("tipc: fix node keep alive interval calculation")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

Looks good, Jon?
