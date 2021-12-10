Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BF470265
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbhLJOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:07:05 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:46448 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbhLJOHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:07:04 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6539621108;
        Fri, 10 Dec 2021 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639145008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lStuFTCpT32EwO774aLe8VXENvz+BIXqOEoy5mRtbZQ=;
        b=CodCcSm+SiSjJsATKBo8GG3RC3RU7Z9ToHnWxEijTrG6o2EUvn5+a4YhW+0bQ9P8vMb3XJ
        QFwFl/91GyEsr5oh4xs45vY3Ygx8StbLF3vq0ORPCB96od7j2bsNu6f1ShJFAdQMdoJvR9
        xc1eqdDKuuy9XymuOd59XpozfdKc8u8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639145008;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lStuFTCpT32EwO774aLe8VXENvz+BIXqOEoy5mRtbZQ=;
        b=BejK88X1IqETklRl9RpQBRmeB8aqS218XrXEz140mS50HByghR9yxD90fcQnvC9Dxu6ca0
        Jgdz9Nfc3B7GohAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E8A413E15;
        Fri, 10 Dec 2021 14:03:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MmuqAzBes2FrOwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Fri, 10 Dec 2021 14:03:28 +0000
Subject: Re: [PATCH] netfilter: fix regression in looped (broad|multi)cast's
 MAC handing
To:     =?UTF-8?Q?Ignacy_Gaw=c4=99dzki?= 
        <ignacy.gawedzki@green-communications.fr>, netdev@vger.kernel.org
References: <20211210122600.mrduxdw2uwpwoqbr@zenon.in.qult.net>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <b2e527bc-4c38-54a9-f909-aca6453c0cfc@suse.de>
Date:   Fri, 10 Dec 2021 17:03:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211210122600.mrduxdw2uwpwoqbr@zenon.in.qult.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



12/10/21 3:26 PM, Ignacy Gawędzki пишет:
> In 5648b5e1169f, the test for non-empty MAC header introduced in
> 2c38de4c1f8da7 has been replaced with a test for a set MAC header,
> which breaks the case when the MAC header has been reset (using
> skb_reset_mac_header), as is the case with looped-back multicast
> packets.
> 
> This patch adds a test for a non-empty MAC header in addition to the
> test for a set MAC header.  The same two tests are also implemented in
> nfnetlink_log.c, where the initial code of 2c38de4c1f8da7 has not been
> touched, but where supposedly the same situation may happen.
>
Fixes: 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC 
handling")

> Signed-off-by: Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
> ---
>   net/netfilter/nfnetlink_log.c   | 3 ++-
>   net/netfilter/nfnetlink_queue.c | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 691ef4cffdd9..7f83f9697fc1 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -556,7 +556,8 @@ __build_packet_message(struct nfnl_log_net *log,
>   		goto nla_put_failure;
>   
>   	if (indev && skb->dev &&
> -	    skb->mac_header != skb->network_header) {
> +	    skb_mac_header_was_set(skb) &&
> +	    skb_mac_header_len(skb) != 0) {
>   		struct nfulnl_msg_packet_hw phw;
>   		int len;
>   
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 4acc4b8e9fe5..959527708e38 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -560,7 +560,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>   		goto nla_put_failure;
>   
>   	if (indev && entskb->dev &&
> -	    skb_mac_header_was_set(entskb)) {
> +	    skb_mac_header_was_set(entskb) &&
> +	    skb_mac_header_len(entskb) != 0) {
>   		struct nfqnl_msg_packet_hw phw;
>   		int len;
>   
> 
