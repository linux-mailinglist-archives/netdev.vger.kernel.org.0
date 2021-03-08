Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E7330962
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhCHI2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:28:10 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:46400 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhCHI17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 03:27:59 -0500
Received: from [IPv6:2003:e9:d737:8f29:e49:1922:adb:7fb2] (p200300e9d7378f290e4919220adb7fb2.dip0.t-ipconnect.de [IPv6:2003:e9:d737:8f29:e49:1922:adb:7fb2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 326F8C0CBC;
        Mon,  8 Mar 2021 09:27:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1615192077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVcmNkVaT4+KdJAwSWE3Uwhiy5rTlGCGMLR+CL1ud88=;
        b=YO6KWeUf5VB09DvUatnqsZO7VE3lONLQOvrdoKxwFBeyVzN1RDwCdqIX041MYlYKpayszh
        92QckaUlVVVykBU09/LEsElM5yNFXSUGiReviCofCztpB/9rnVx1hEjQzLX/lwqVsNalD9
        gLs72ImrktrJtVjOd6KdaRedVbyuQixtP+h5XhJtRNmUGFYOhZ8BLDYjII07/OFdpV4C9q
        1AL5cDOsDucQ1EEkQ+iLNY4wrsCJZLTN1c4TqyEP57ua17NjTScuU8UTx6GjXmoNNp8DrT
        kk/YI/eVM9US5WfxJa+LuPAIM0UCSwazXVaCvLqtlOpS/BvKMHdAIUV/vrmC/Q==
Subject: Re: [PATCH v2] net: mac802154: Fix general protection fault
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
References: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
 <20210304152125.1052825-1-paskripkin@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <02c79193-808e-55b3-f2c9-9d7a0643aaee@datenfreihafen.org>
Date:   Mon, 8 Mar 2021 09:27:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210304152125.1052825-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 04.03.21 16:21, Pavel Skripkin wrote:
> syzbot found general protection fault in crypto_destroy_tfm()[1].
> It was caused by wrong clean up loop in llsec_key_alloc().
> If one of the tfm array members is in IS_ERR() range it will
> cause general protection fault in clean up function [1].
> 
> Call Trace:
>   crypto_free_aead include/crypto/aead.h:191 [inline] [1]
>   llsec_key_alloc net/mac802154/llsec.c:156 [inline]
>   mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
>   ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
>   rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
>   nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
>   genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>   genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>   genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>   genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>   netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>   sock_sendmsg_nosec net/socket.c:654 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:674
>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
> Change-Id: I29f7ac641a039096d63d1e6070bb32cb5a3beb07
> ---
>   net/mac802154/llsec.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
> index 585d33144c33..55550ead2ced 100644
> --- a/net/mac802154/llsec.c
> +++ b/net/mac802154/llsec.c
> @@ -152,7 +152,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
>   	crypto_free_sync_skcipher(key->tfm0);
>   err_tfm:
>   	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
> -		if (key->tfm[i])
> +		if (!IS_ERR_OR_NULL(key->tfm[i]))
>   			crypto_free_aead(key->tfm[i]);
>   
>   	kfree_sensitive(key);
> 

Alex, are you happy with this patch now? I would like to get it applied. 
Waiting for your review or ack given you had comments on the first version.

regards
Stefan Schmidt
