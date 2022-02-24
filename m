Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FB34C2FA5
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiBXP2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiBXP1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:27:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 163EA1A1C44
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645716406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRB/W7Ct6Fvwq8WNLWdOFSX0Quf6CZk21tMewLGkssY=;
        b=VH3b/D6Dkx8sbw29KTvBbuHYosFIo73DNzENyN7my06DL3iaa0UaaeQmyFHbQJzJSWvFb8
        v/PIQcbwwAbtZro3W/4ZhvHMBJIrWZHZ5CpprFHMHyhlVB1czA2CMqGVfVQ778Oc/PNAof
        6afR0/4Rylw1kEZRNGkMcYuUiOF7T04=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-xZgfR3nXP_Sl2w1m0LgAEA-1; Thu, 24 Feb 2022 10:26:44 -0500
X-MC-Unique: xZgfR3nXP_Sl2w1m0LgAEA-1
Received: by mail-qv1-f71.google.com with SMTP id cg14-20020a05621413ce00b0042c2706a4beso3114081qvb.23
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRB/W7Ct6Fvwq8WNLWdOFSX0Quf6CZk21tMewLGkssY=;
        b=gaU663T51qOyzY15nOzAiODVb/WCXSvlT2oMzSRD3w0FRAZSfEqi6+5HIwyMM0YFfD
         DYyE+5+RhSjz25dun63/H9ff4Pbifg99n+fZMGLExx1TkusJ3lDjJLZyvVjLg0UkTJpi
         0/XPPckHk55EzDhNpfLFbk8dlkCO2ewo/HEThK7U5oAeUU5g+O2gXJrH//aGzrwcRgB8
         OSZi7UmFYFE5pcJnaFeW9JWf7EQ7Gc93e/A6+ojlUbcJYcC3BFrlq2H8BeTOcXFvgfn5
         kQxQC/PH+5RRxEKsTgGsxpwVeT0C42h6+kdofixGBPVTQI7m47rcUS4f46UQ07l+3TMT
         wUog==
X-Gm-Message-State: AOAM531Su3boDm+5v4nIxEASA1rtuumqMJyywO/b9BSSw4gzl+zca5c4
        yT1aPwHs/lXoF4EFoJopqM7FWMzZMeXWxb0KwwmRQHjdn2xZRnMdX0LJ79J2mUwVXfkZChjTkHg
        KL2wV5rfzkjXSveYl
X-Received: by 2002:a05:622a:18b:b0:2de:8f67:b3e2 with SMTP id s11-20020a05622a018b00b002de8f67b3e2mr2793287qtw.104.1645716404331;
        Thu, 24 Feb 2022 07:26:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzp5vc0QNLAJZl2b5ZiFxc9Cr3aXdBPfffT7AqQZBnqifESVp3GReU8S1yBO6pNLWMguAaOzw==
X-Received: by 2002:a05:622a:18b:b0:2de:8f67:b3e2 with SMTP id s11-20020a05622a018b00b002de8f67b3e2mr2793263qtw.104.1645716404020;
        Thu, 24 Feb 2022 07:26:44 -0800 (PST)
Received: from [10.0.0.97] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id bp18sm1780832qtb.72.2022.02.24.07.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 07:26:43 -0800 (PST)
Message-ID: <a733fc64-0c59-f495-5f12-d90750fd32d7@redhat.com>
Date:   Thu, 24 Feb 2022 10:26:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] tipc: Fix end of loop tests for list_for_each_entry()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Richard Alpe <richard.alpe@ericsson.com>
Cc:     Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Erik Hugne <erik.hugne@ericsson.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
References: <20220222134311.GA2716@kili>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20220222134311.GA2716@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/22 08:43, Dan Carpenter wrote:
> These tests are supposed to check if the loop exited via a break or not.
> However the tests are wrong because if we did not exit via a break then
> "p" is not a valid pointer.  In that case, it's the equivalent of
> "if (*(u32 *)sr == *last_key) {".  That's going to work most of the time,
> but there is a potential for those to be equal.
>
> Fixes: 1593123a6a49 ("tipc: add name table dump to new netlink api")
> Fixes: 1a1a143daf84 ("tipc: add publication dump to new netlink api")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   net/tipc/name_table.c | 2 +-
>   net/tipc/socket.c     | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
> index 01396dd1c899..1d8ba233d047 100644
> --- a/net/tipc/name_table.c
> +++ b/net/tipc/name_table.c
> @@ -967,7 +967,7 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
>   		list_for_each_entry(p, &sr->all_publ, all_publ)
>   			if (p->key == *last_key)
>   				break;
> -		if (p->key != *last_key)
> +		if (list_entry_is_head(p, &sr->all_publ, all_publ))
>   			return -EPIPE;
>   	} else {
>   		p = list_first_entry(&sr->all_publ,
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 3e63c83e641c..7545321c3440 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -3749,7 +3749,7 @@ static int __tipc_nl_list_sk_publ(struct sk_buff *skb,
>   			if (p->key == *last_publ)
>   				break;
>   		}
> -		if (p->key != *last_publ) {
> +		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
>   			/* We never set seq or call nl_dump_check_consistent()
>   			 * this means that setting prev_seq here will cause the
>   			 * consistence check to fail in the netlink callback
Acked-by: Jon Maloy <jmaloy@redhat.com>

