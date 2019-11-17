Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB40FF8B2
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 10:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfKQJwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 04:52:40 -0500
Received: from mail.dlink.ru ([178.170.168.18]:37258 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfKQJwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 04:52:40 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 44A741B20C5D; Sun, 17 Nov 2019 12:52:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 44A741B20C5D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1573984355; bh=kb0YVBramWtjA/Ad8wxxFedgfyiwwLDzdL9qmwmkwJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=CYTJS3OPFdbnqAqD6h9NnT5GP96M+sKXbB5l2quB1ODwLZ2oRj8lF8SMe3fQnKBrx
         eGlDMkBsi6YPE0BtsF4dpyMVNNE4XzANSawajT2/yphkVDHVOtp5uoTfmfHy90cZhg
         LXfVWQAU8GF+SLSwmSAA6dBrnKKYolIuygqq/w5c=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 903E41B202CB;
        Sun, 17 Nov 2019 12:52:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 903E41B202CB
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 57C4B1B2022F;
        Sun, 17 Nov 2019 12:52:24 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Sun, 17 Nov 2019 12:52:24 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sun, 17 Nov 2019 12:52:24 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: allow fast GRO for skbs with
 Ethernet header in head
In-Reply-To: <20191116.130101.268806870571558138.davem@davemloft.net>
References: <20191115091135.13487-1-alobakin@dlink.ru>
 <20191116.130101.268806870571558138.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <5622418d39ce3ebc3d526d3e16c8546b@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote 17.11.2019 00:01:

> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Fri, 15 Nov 2019 12:11:35 +0300
> 
>> Commit 78d3fd0b7de8 ("gro: Only use skb_gro_header for completely
>> non-linear packets") back in May'09 (v2.6.31-rc1) has changed the
>> original condition '!skb_headlen(skb)' to
>> 'skb->mac_header == skb->tail' in gro_reset_offset() saying: "Since
>> the drivers that need this optimisation all provide completely
>> non-linear packets" (note that this condition has become the current
>> 'skb_mac_header(skb) == skb_tail_pointer(skb)' later with commmit
>> ced14f6804a9 ("net: Correct comparisons and calculations using
>> skb->tail and skb-transport_header") without any functional changes).
>> 
>> For now, we have the following rough statistics for v5.4-rc7:
>> 1) napi_gro_frags: 14
>> 2) napi_gro_receive with skb->head containing (most of) payload: 83
>> 3) napi_gro_receive with skb->head containing all the headers: 20
>> 4) napi_gro_receive with skb->head containing only Ethernet header: 2
>> 
>> With the current condition, fast GRO with the usage of
>> NAPI_GRO_CB(skb)->frag0 is available only in the [1] case.
>> Packets pushed by [2] and [3] go through the 'slow' path, but
>> it's not a problem for them as they already contain all the needed
>> headers in skb->head, so pskb_may_pull() only moves skb->data.
>> 
>> The layout of skbs in the fourth [4] case at the moment of
>> dev_gro_receive() is identical to skbs that have come through [1],
>> as napi_frags_skb() pulls Ethernet header to skb->head. The only
>> difference is that the mentioned condition is always false for them,
>> because skb_put() and friends irreversibly alter the tail pointer.
>> They also go through the 'slow' path, but now every single
>> pskb_may_pull() in every single .gro_receive() will call the *really*
>> slow __pskb_pull_tail() to pull headers to head. This significantly
>> decreases the overall performance for no visible reasons.
>  ...
>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> 
> Applied to net-next, thanks.

Thank you!

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
