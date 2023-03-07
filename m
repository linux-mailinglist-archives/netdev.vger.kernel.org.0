Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557DC6AD974
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 09:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCGInv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 03:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCGInt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 03:43:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A12E1A946;
        Tue,  7 Mar 2023 00:43:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B6A031FE14;
        Tue,  7 Mar 2023 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678178627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN/mC5ywri8Tsr8fRJnnEanEH8sLUKMhH0fMNv5LE7Y=;
        b=fWJINjvv/d1bPyDVsCT+SjeYPcy+aywiRxkhivpY9ybDJHt8CZHV5mlkjuMOkeCdMdckJe
        ITMI21Wd4DBV8vcSKJ1UzU2XVR/PfLhxiSMBJXVONSk+jl4kYj54usdC8zMpWuiwPJc4CB
        x0CKbthybB6/dILpkLmKnMuCHsmeW5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678178627;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN/mC5ywri8Tsr8fRJnnEanEH8sLUKMhH0fMNv5LE7Y=;
        b=26NSbNE9AJTm123tuDIcwVywsZC/oRTLii70lcvHsybEbJ7RntZuMe6nyoB/9/MrnysFn/
        BFlJWQ5P4Yv1i4DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 07B2613440;
        Tue,  7 Mar 2023 08:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6fEOOkL5BmRhIQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 07 Mar 2023 08:43:46 +0000
Message-ID: <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
Date:   Tue, 7 Mar 2023 11:43:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
To:     Dongliang Mu <dzm91@hust.edu.cn>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230307073004.74224-1-dzm91@hust.edu.cn>
Content-Language: en-US
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20230307073004.74224-1-dzm91@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/7/23 10:30, Dongliang Mu wrote:
> There is a null pointer dereference if NL802154_ATTR_SCAN_TYPE is
> not set by the user.
> 
> Fix this by adding a null pointer check.
> 
> Reported-and-tested-by: syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Please add a Fixes: tag 

> ---
>  net/ieee802154/nl802154.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 2215f576ee37..1cf00cffd63f 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1412,7 +1412,8 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> +	if (!info->attrs[NL802154_ATTR_SCAN_TYPE] ||
> +	    !nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
>  		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
>  		return -EINVAL;
>  	}
