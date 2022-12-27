Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC03656944
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiL0J5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiL0J4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:56:51 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9209FFC;
        Tue, 27 Dec 2022 01:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s5JtDBhzmiCYKFeCcbSGtbqGBoUAybbEuGC/hLArT4c=; b=B97kKfoQET0Oyt2jzS6spXRM+8
        cxFwF2+lFIxzjjK9Ac9AbfmW7XMiyrPZKaTTjYu0qKmEq4ZaErxCCb5Ipx81PfEYKBN7VUMcO87Cr
        JZu72Bo8zT8nbFbZNGGfdH6Rvc/MhGhjNuzSZ3cQaZrCWJ1cUDTv7Xu2xuKdAbYXPyUE=;
Received: from p200300daa720fc040c81ba64b0a9b1e5.dip0.t-ipconnect.de ([2003:da:a720:fc04:c81:ba64:b0a9:b1e5] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pA6gg-00C1ck-GN; Tue, 27 Dec 2022 10:55:58 +0100
Message-ID: <9e4685a4-5dd1-9f7b-1235-30aebcc9dfd3@nbd.name>
Date:   Tue, 27 Dec 2022 10:55:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221123095754.36821-1-nbd@nbd.name>
 <20221123095754.36821-3-nbd@nbd.name>
 <20221124175410.5684-1-alexandr.lobakin@intel.com>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 3/5] net: ethernet: mtk_eth_soc: work around issue with
 sending small fragments
In-Reply-To: <20221124175410.5684-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.11.22 18:54, Alexander Lobakin wrote:
> From: Felix Fietkau <nbd@nbd.name>
> Date: Wed, 23 Nov 2022 10:57:52 +0100
> 
>> When frames are sent with very small fragments, the DMA engine appears to
>> lock up and transmit attempts time out. Fix this by detecting the presence
>> of small fragments and use skb_gso_segment + skb_linearize to deal with
>> them
> 
> Nit: all of your commit messages don't have a trailing dot (.), not
> sure if it's important, but my eye is missing it definitely :D
> 
> skb_gso_segment() and skb_linearize() are slow as hell. I think you
> can do it differently. I guess only the first (head) and the last
> frag can be so small, right?
> 
> So, if a frag from shinfo->frags is less than 16, get a new frag of
> the minimum acceptable size via netdev_alloc_frag(), copy the data
> to it and pad the rest with zeroes. Then increase skb->len and
> skb->data_len, skb_frag_unref() the current, "invalid" frag and
> replace the pointer to the new frag. I didn't miss anything I
> believe... Zero padding the tail is usual thing for NICs. skb frag
> substitution is less common, but should be legit.
> 
> If skb_headlen() is less than 16, try doing pskb_may_pull() +
> __skb_pull() at first. The argument would be `16 - headlen`. If
> pskb_may_pull() returns false, then yeah, you have no choice other
> than segmenting and linearizing ._.
I looked into this some more and spoke with people at MTK. It appears 
that in principle, the DMA engine is able to process very small 
fragments. However, when it is being flooded with them, a FIFO can 
overflow, which causes the hang that I was observing.
I think your suggestion likely would not fix the issue completely.
A MTK engineer also confirmed that my approach is the correct one for 
handling this.
I will send v2 with an updated description.

Thanks,

- Felix

