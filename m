Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127AE4F2EC3
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiDEIZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239257AbiDEIT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF27E0A9;
        Tue,  5 Apr 2022 01:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9516C60B0E;
        Tue,  5 Apr 2022 08:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4FEC385A4;
        Tue,  5 Apr 2022 08:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649146242;
        bh=yiUb0KeDIElbsWH/tWSC27FCtW1g3j0B1+uvrjcMk30=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PZodR0flrzbsq2oxkUiMgDvB7X2Elj5eNDBNIJZYSeibE9SQv6EZwbMGUNvIdfWQp
         tpWaIYsoOOdrFrg9SICP2LeeFpBryS4jQX219mjUt5KHjgKoX2oWwqm8LcfCwJsFK1
         qelcqd7V/+W+pYJ4i3MkuqMCh3PfFnrJaeMshf/4xSM7fcxHcv5qUoqcy8emqr1k33
         B5pEfaORqVyi0IwN7hesLxg7AkNyUyY/rEPUfRa/yw2aaBj/z5hQ5iBN8fLg+a8vz5
         rvekW1PWphkFy52GuzH69jcaHfVAXXXanfNn8lg4iW9/vstteRQFxrNZdH1V7UhmvD
         WsrXlZCQ2W7Sg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] carl9170: tx: fix an incorrect use of list iterator
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
References: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164914623778.12306.14074908465775082444.kvalo@kernel.org>
Date:   Tue,  5 Apr 2022 08:10:39 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> If the previous list_for_each_entry_continue_rcu() don't exit early
> (no goto hit inside the loop), the iterator 'cvif' after the loop
> will be a bogus pointer to an invalid structure object containing
> the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
> will lead to a invalid memory access (i.e., 'cvif->id': the invalid
> pointer dereference when return back to/after the callsite in the
> carl9170_update_beacon()).
> 
> The original intention should have been to return the valid 'cvif'
> when found in list, NULL otherwise. So just return NULL when no
> entry found, to fix this bug.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Christian, is this ok to take?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220328122820.1004-1-xiam0nd.tong@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

