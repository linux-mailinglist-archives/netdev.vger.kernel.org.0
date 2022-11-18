Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E322B62EC5A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiKRD2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiKRD2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:28:03 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9725818E22
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:28:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b11so3397633pjp.2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F36ePDNlCEzEo7uhtE/7mj1A0uCdl18mggSDLjAIBVk=;
        b=YGVVEvY578X0bTstx0iAIrqJGez3hsnxoOoUpBJT4Q9jd9MXem7asmcwvnybW4tQ6n
         O2sYVrDWp3ZDjHWyIpKoSkDDM8DX1wS35HCnLZ5qUAqvYm8P1Oop8ScWiHthkWoTiwEo
         CEV64OSa2G+hbEfS6PUOfR0b6WGDjNC290oqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F36ePDNlCEzEo7uhtE/7mj1A0uCdl18mggSDLjAIBVk=;
        b=eLco5THL1HtttkJvxEbe/cupVsd2JvqPmWvP64SV7oJPobkqGAG3SoTWdmS4qfF9bp
         O1CM+GvoXURGkHB0XeOiWqZLZ+X3d61qQmCTXNMHvl8vmI5k+ifwv1HWc0IYCxwqDxpg
         /fxagUknJIEzMtXF/yoQcTEgWU96iBUAsN+CxyBCgpcySV0nF1xYpsyR9CaB7dZzsTRF
         GZQvH/oQfvKNg/SdvajI2mIi28BLgco5CX5dcbxW2kmE3a4jwRheH7egxH9AleYHG4br
         DUh30qtq16A2eGeCn44T/LWaO7e5UlJ2scazt3REMALGI8V5oNO8WhyEXJjKDZp+p/Wd
         uzfw==
X-Gm-Message-State: ANoB5plF+67sjAbNfAixC9biLZ2wr3bZOeYBXi+67bXshgg3w0VOwPF6
        LtFaG6Ko0eBneJq+jpd0V6zzaA==
X-Google-Smtp-Source: AA0mqf5NTXas/rZvXyznEcobhz5OK9ZKiMSPkpTirE6uepnuMidQlAXHwj1y8KC784/f0fIKmsAVdg==
X-Received: by 2002:a17:902:6b08:b0:187:4467:7aba with SMTP id o8-20020a1709026b0800b0018744677abamr5639625plk.61.1668742082081;
        Thu, 17 Nov 2022 19:28:02 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090a558400b00210c84b8ae5sm1598458pji.35.2022.11.17.19.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 19:28:01 -0800 (PST)
Date:   Thu, 17 Nov 2022 19:27:59 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <202211171855.9AEB6E3@keescook>
References: <202211161454.D5FA4ED44@keescook>
 <202211161502.142D146@keescook>
 <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
 <20221116170526.752c304b@kernel.org>
 <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
 <20221116221306.5a4bd5f8@kernel.org>
 <20221117082556.37b8028f@hermes.local>
 <20221117123615.41d9c71a@kernel.org>
 <202211171431.6C8675E2@keescook>
 <20221117162822.5cb04021@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117162822.5cb04021@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:28:22PM -0800, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:35:32 -0800 Kees Cook wrote:
> > As for testing, I can do that if you want -- the goal was to make sure
> > the final result doesn't trip FORTIFY when built with -fstrict-flex-arrays
> > (not yet in a released compiler version, but present in both GCC and Clang
> > truck builds) and with __builtin_dynamic_object_size() enabled (which
> > is not yet in -next, as it is waiting on the last of ksize() clean-ups).
> 
> I got distracted, sorry. Does this work?
> 
> -->8--------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: netlink: remove the flex array from struct nlmsghdr
> 
> I've added a flex array to struct nlmsghdr to allow accessing
> the data easily. But it leads to warnings with clang, when user
> space wraps this structure into another struct and the flex
> array is not at the end of the container.
> 
> Link: https://lore.kernel.org/all/20221114023927.GA685@u2004-local/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks! Yes, this seems to be happy with all the future stuff enabled.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  include/uapi/linux/netlink.h | 2 --
>  net/netlink/af_netlink.c     | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index 5da0da59bf01..e2ae82e3f9f7 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -48,7 +48,6 @@ struct sockaddr_nl {
>   * @nlmsg_flags: Additional flags
>   * @nlmsg_seq:   Sequence number
>   * @nlmsg_pid:   Sending process port ID
> - * @nlmsg_data:  Message payload
>   */
>  struct nlmsghdr {
>  	__u32		nlmsg_len;
> @@ -56,7 +55,6 @@ struct nlmsghdr {
>  	__u16		nlmsg_flags;
>  	__u32		nlmsg_seq;
>  	__u32		nlmsg_pid;
> -	__u8		nlmsg_data[];
>  };
>  
>  /* Flags values */
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 9ebdf3262015..d73091f6bb0f 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2514,7 +2514,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  		if (!nlmsg_append(skb, nlmsg_len(nlh)))
>  			goto err_bad_put;
>  
> -		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
> +		memcpy(nlmsg_data(&errmsg->msg), nlmsg_data(nlh),
>  		       nlmsg_len(nlh));
>  	}
>  
> -- 
> 2.38.1
> 

-- 
Kees Cook
