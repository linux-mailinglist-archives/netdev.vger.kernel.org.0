Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EF64F6365
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiDFPWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbiDFPV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:21:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC9D536101;
        Wed,  6 Apr 2022 05:32:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2332F1F38A;
        Wed,  6 Apr 2022 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649245050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omCD+DLP3/+QylhgzsKFATIPCNWQpkF0Re2FTx3XaUA=;
        b=B8308rxncAvAJV75F0pwKjhI2+p4nKDbofAxnnot3gLUCcjV5neLLW8OsQyTRtk/t5Pm2R
        yO/chUwNdOraZBuwmUcGtPkvrthRqB4poHNH56EU7o6eYgglaO7YqfEgxsoBBhmBcC7I6o
        2HZtQda3lcljLa5X7YOWOg9zFl5yEsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649245050;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omCD+DLP3/+QylhgzsKFATIPCNWQpkF0Re2FTx3XaUA=;
        b=wISK9QMyY+V16+1YnssoF1ORF0co5WJE3GH0/Dr5sWwz6wHUV3Vdmnlt78Nhubr5VLezb8
        DFDaFbg33wr7ETBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E2CF139F5;
        Wed,  6 Apr 2022 11:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qlY7I3l7TWKFSAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 06 Apr 2022 11:37:29 +0000
Message-ID: <934017ec-8cec-b25c-cd01-f5ede0cfff82@suse.de>
Date:   Wed, 6 Apr 2022 14:36:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] myri10ge: fix an incorrect free for skb in
 myri10ge_sw_tso
Content-Language: ru
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, christopher.lee@cspi.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220406035556.730-1-xiam0nd.tong@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20220406035556.730-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/6/22 06:55, Xiaomeng Tong пишет:
> All remaining skbs should be released when myri10ge_xmit fails to
> transmit a packet. Fix it within another skb_list_walk_safe.
> 
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> 
> changes since v2:
>   - free all remaining skbs. (Xiaomeng Tong)
> 
> changes since v1:
>   - remove the unneeded assignmnets. (Xiaomeng Tong)
> 
> v2:https://lore.kernel.org/lkml/20220405000553.21856-1-xiam0nd.tong@gmail.com/
> v1:https://lore.kernel.org/lkml/20220319052350.26535-1-xiam0nd.tong@gmail.com/
> 
> ---
>   drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> index 50ac3ee2577a..21d2645885ce 100644
> --- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> +++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> @@ -2903,11 +2903,9 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
>   		status = myri10ge_xmit(curr, dev);
>   		if (status != 0) {
a transmit function returns NETDEV_TX_OK on success
>   			dev_kfree_skb_any(curr);
> -			if (segs != NULL) {
> -				curr = segs;
> -				segs = next;
> +			skb_list_walk_safe(next, curr, next) {
>   				curr->next = NULL;
> -				dev_kfree_skb_any(segs);
> +				dev_kfree_skb_any(curr);
>   			}
>   			goto drop;
>   		}
