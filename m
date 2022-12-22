Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911386544F0
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiLVQKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiLVQK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AADD23399;
        Thu, 22 Dec 2022 08:10:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 140B4B81E5F;
        Thu, 22 Dec 2022 16:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D72FC433D2;
        Thu, 22 Dec 2022 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725425;
        bh=zW/zCdG2geFMx+Oi0UXCM4FYkDuzU3+4/7eiEtWnHuI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j7S5AyDi1tPzXIHvoxsohSf54xizwHGV67lBsa+8HETEjtTFHNhh5h7uQ+4k+lIIO
         JuFV/df1EoxM11DayhjUEaiXePwE6HVTkguzje/DjQWa3QI5R+dam5jq3Dn2t1vboN
         3cJqARLnZtvsSHKvb3ki32GPUDPSSgmRhyIvHocNgewqwlbChQw3N48Rrej9YIFaBQ
         Mvk6yXmBjbUIKTyMftBQKmuQTDN+3XLyijDInLQoLnsE5ZJfnYSilZ9OBXARPSVMAi
         ZrgMBPoSdsAT1qzx0qRElTpcgmndumHHmFs0VaVM5yHtcpunDYF4Fgq62dbseEzb8n
         P/olMqn/q7wyg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221207013114.1748936-1-shaozhengchao@huawei.com>
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <aspriel@gmail.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <wright.feng@cypress.com>, <chi-hsien.lin@cypress.com>,
        <a.fatoum@pengutronix.de>, <alsi@bang-olufsen.dk>,
        <pieterpg@broadcom.com>, <dekim@broadcom.com>,
        <linville@tuxdriver.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172541072.8231.13035964565769146616.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:10:20 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> wrote:

> After the DMA buffer is mapped to a physical address, address is stored
> in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
> brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain physaddr
> and later unmap the DMA buffer. But when count is always equal to
> pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
> will not be unmapped anyway.
> 
> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Patch applied to wireless-next.git, thanks.

b9f420032f2b wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221207013114.1748936-1-shaozhengchao@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

