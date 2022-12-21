Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D714653667
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiLUSdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUSdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A6025EB8;
        Wed, 21 Dec 2022 10:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C14AE618E6;
        Wed, 21 Dec 2022 18:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881B2C433EF;
        Wed, 21 Dec 2022 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671647591;
        bh=yRFJzF78Png1ieG07rAaRZltjrfNtQ6gLw4f1d7PGrI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rLVjMVJe3NN2k0Gx137eKQdVs4zTKwr6K5sfgts49VmWOKRBIE6hw5a3UFSqNgQnH
         0RRhq+JesURq5iu7FRpCaJYC0QgH4KlaAIyH2UtwyrInsbpYAad8iNZUgHGxNn76+l
         x6FJadZlUa1ACLTG+C15qUDg8xzkSShqnx+t9o4GTL3Ft5XCQt22kezE3BwjWw80O6
         gmmbVSbVDnKe236nyU8xR+xJPgQ3CyEA1hNvOmJaiyqHFnVyH1xNAO9597e04pD8aP
         KbSxVUwoTkx5s0Qzm6V5gWbDB+EEru265oZO2F3h2q/eH+CedwhxL87+XvOGd+0/Zb
         9YPqgfbTsuEPA==
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
Message-ID: <167164758059.5196.17408082243455710150.kvalo@kernel.org>
Date:   Wed, 21 Dec 2022 18:33:06 +0000 (UTC)
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

Can someone review this?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221207013114.1748936-1-shaozhengchao@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

