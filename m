Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22B16D563B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjDDBpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDDBpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:45:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346BB8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE81961E82
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 01:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E575AC433D2;
        Tue,  4 Apr 2023 01:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680572747;
        bh=NQQwbwj9hBaPLb4Kur55baJtQUHfuBbe9jaJEqAH08U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KOkDAKIRVV9W2Klbsw75Imx27unsfctc8wYustyh1hQCwiqWy5LE/o4AWO55lho5z
         K+voVqDZOEp9lgwP4htke9opauGHxPRFRD5owp+KCHwewwBvZgmd2AqhfQOcXeO9EK
         5hFzPlB/1mlcVboOl+i0cZCFcRGemBE52CBt2L8Vfjvl8c67S2WjquY0Vgyu366sG3
         /O8kLPFzV4IFh9MIO9wSLTS8W2dQK/0UDr8BitjP6pRWE3QTLxwOwJT6t6KG4T30Kk
         KsOUHSfl6PD340/vzETAwdmz4hMOW24MRH2ubcO7TUEalbGK0pUaDh3B0xaEPmm9Th
         0wTuKbQYhf62A==
Date:   Mon, 3 Apr 2023 18:45:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230403184545.3eeb6e83@kernel.org>
In-Reply-To: <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
References: <20230331043906.3015706-1-kuba@kernel.org>
        <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 08:53:36 +0800 Yunsheng Lin wrote:
> I wonder if we can make this more generic by adding the skb to per napi
> list instead of sd->defer_list, so that we can always use NAPI kicking to
> flush skb as net_tx_action() done for sd->completion_queue instead of
> softirq kicking?
> 
> And it seems we know which napi binds to a specific socket through
> busypoll mechanism, we can reuse that to release a skb to the napi
> bound to that socket?

Seems doable. My thinking was to first see how well the simpler scheme
performs with production workloads because it should have no downsides.
Tracking real NAPI pointers per socket and extra RCU sync to manage
per-NAPI defer queues may have perf cost.
