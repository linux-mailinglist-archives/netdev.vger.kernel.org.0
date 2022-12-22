Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF7653D25
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 09:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiLVIqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 03:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiLVIqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 03:46:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C4D656B;
        Thu, 22 Dec 2022 00:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8073A619E8;
        Thu, 22 Dec 2022 08:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029E9C433EF;
        Thu, 22 Dec 2022 08:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671698791;
        bh=Fnr67KqEO6Zk9hxphWSKR+FdLoX837iPY/pmZU63imk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hy/F+jqxUpbbCluql1w4PKofBFCZrYn0S+fMhzKvxPqfn+McWkvBZGaBWNfe/8krx
         dnsTRyK3s5rlVVagRcrTwcrIpBYu8o6T4002wUCh7qD/ImJgsI1px32tPIACxOkjja
         SVeG/GRXRmqpZ1ljoDPgRT2igrG5V46emyoHYndGY6DLSLMosx+5QEf3DGqb0i8kik
         HyLBepjTdCJAtI0oE6rWCQAe011Kn24+WTsj2oTN5xY+pAIVeh9vZV0LbCWB299QUV
         y+CwFAwSnTwNOUWlGkeh1LN3z+4PeTFT4suR/giKwLuHtD9XZt9hTO67kXwgi05xZX
         SKpUola+ffKtg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, wright.feng@cypress.com,
        chi-hsien.lin@cypress.com, a.fatoum@pengutronix.de,
        alsi@bang-olufsen.dk, pieterpg@broadcom.com, dekim@broadcom.com,
        linville@tuxdriver.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
        <167164758059.5196.17408082243455710150.kvalo@kernel.org>
        <Y6QJWPDXglDjUP9p@linutronix.de>
Date:   Thu, 22 Dec 2022 10:46:22 +0200
In-Reply-To: <Y6QJWPDXglDjUP9p@linutronix.de> (Sebastian Andrzej Siewior's
        message of "Thu, 22 Dec 2022 08:38:00 +0100")
Message-ID: <87cz8bkeqp.fsf@kernel.org>
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

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> On 2022-12-21 18:33:06 [+0000], Kalle Valo wrote:
>> Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>> 
>> > After the DMA buffer is mapped to a physical address, address is stored
>> > in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
>> > brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain physaddr
>> > and later unmap the DMA buffer. But when count is always equal to
>> > pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
>> > will not be unmapped anyway.
>> > 
>> > Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
>> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> 
>> Can someone review this?
>
> After looking at the code, that skb is mapped but not inserted into the
> ringbuffer in this condition. The function returns with an error and the
> caller will free that skb (or add to a list for later). Either way the
> skb remains mapped which is wrong. The unmap here is the right thing to
> do.
>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks for the review, very much appreciated.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
