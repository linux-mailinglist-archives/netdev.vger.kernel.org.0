Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750C062FCE9
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbiKRSnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbiKRSnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:43:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16F367128;
        Fri, 18 Nov 2022 10:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B53B824DF;
        Fri, 18 Nov 2022 18:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34999C433D6;
        Fri, 18 Nov 2022 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668796992;
        bh=sMpUopAbCSWGE9RE/G4d9fB88a/c8/HACDUhgT+zK7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kG9zCeMD6VdL17c1FAOVohHkO+0INJfwq65HqZCzszrCo29EdUEOmxwbALs8iQ2YF
         6+AaS7NHF1DmtwdRNxh48dp2w7GVcdWXY4GSlWYM8hWShBv8Gt3Zm2a6m3kJJEqmid
         r/mhx6PmBPAEMyCPA+1wzrSy6HRbwnQH92VCuU3XxYhXisQv1P9PG2bRfYVF2RDPOb
         fyUIsuJb1uSAkfNX6KQpGZS0H282M1LxQAN6ZZ0XvCrxYqog9miKyXz32UOgC/uZoo
         auxhaoqj5BJQk06bHPRRHrykjFFwRJmG9Fju9CKweCOTrdxouSW5ojKj7anw1r8efS
         p/hYs9mFtUkFg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless] brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()
References: <1668657281-28480-1-git-send-email-zhangchangzhong@huawei.com>
        <87bkp5sxj2.fsf@kernel.org>
        <05b2af86-2354-74b0-27b6-7c20be7d035d@huawei.com>
Date:   Fri, 18 Nov 2022 20:43:07 +0200
In-Reply-To: <05b2af86-2354-74b0-27b6-7c20be7d035d@huawei.com> (Zhang
        Changzhong's message of "Thu, 17 Nov 2022 19:04:32 +0800")
Message-ID: <87edu09k90.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> writes:

> On 2022/11/17 18:09, Kalle Valo wrote:
>> Zhang Changzhong <zhangchangzhong@huawei.com> writes:
>> 
>>> The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
>>> in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
>>>
>>> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> 
>> I assume you have not tested this on a real device? Then it would be
>> really important to add "Compile tested only" to the commit log so that
>> we know it's untested.
>> 
>
> OK, I'll add "Compile tested only" to the next version and other untested
> patches.

Thanks. I wish it would become common to use that "Compile tested only".

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
