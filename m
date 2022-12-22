Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A36B653C9C
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 08:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiLVHiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 02:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiLVHiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 02:38:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD7219281;
        Wed, 21 Dec 2022 23:38:05 -0800 (PST)
Date:   Thu, 22 Dec 2022 08:38:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1671694683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EWXzDsrAEorzDZh3Kox+mXLrcYjGJT3zppjt5m8lhU=;
        b=sn1I8WB9AvT6NkaylHOBRIOC4Y5w/Tv0ZzJj6SNP8a2rdvOUkjxYvcI/ZBtNTbIBnU3NTP
        nYW0j4QB9FjlGTLTpFn1ndOmKwXsyYOUufkwuipI5LNyiHowuCRSCFQ4hUHNJHquVUH25g
        UQw2FG2y5Z74YcxOwNMTWX59Zg7fXOctBpislhcpLR+USO8lU3AE6GpnvH/+iPvuVhDcAW
        3NFX4sgFu6CBE/s4LXmVU6Xmg/eySYV9tPUZz9ZO3s75Ifr4utyKavlCJ6lZtG+mvPA/ep
        Rua1owxnEKeG406OBH2yKzyt2iu56L8uRwlVnAVQyrFfeEdtJYXKW3Y6H6Nq7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1671694683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EWXzDsrAEorzDZh3Kox+mXLrcYjGJT3zppjt5m8lhU=;
        b=QV6/5UwwuXGdNjEz5DkHhUEQYplmYJIYDz8FTNLBDs+Gt0yKVaclhPkVbEotc/3sWepqy8
        IZEbt3nT3OEm41DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Kalle Valo <kvalo@kernel.org>
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
Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
Message-ID: <Y6QJWPDXglDjUP9p@linutronix.de>
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
 <167164758059.5196.17408082243455710150.kvalo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <167164758059.5196.17408082243455710150.kvalo@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-12-21 18:33:06 [+0000], Kalle Valo wrote:
> Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> 
> > After the DMA buffer is mapped to a physical address, address is stored
> > in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
> > brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain physaddr
> > and later unmap the DMA buffer. But when count is always equal to
> > pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
> > will not be unmapped anyway.
> > 
> > Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> Can someone review this?

After looking at the code, that skb is mapped but not inserted into the
ringbuffer in this condition. The function returns with an error and the
caller will free that skb (or add to a list for later). Either way the
skb remains mapped which is wrong. The unmap here is the right thing to
do.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
