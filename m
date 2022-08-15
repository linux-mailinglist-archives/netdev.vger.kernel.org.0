Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A95951B0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiHPFJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiHPFIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:08:54 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9F254656
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:09:32 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id c12so4267309vkn.13
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hg8ZlxgjsyqbpHZ7OetYt5d22ngKlCVDzJjkV6i0AyQ=;
        b=S30drc0mcqdIg37qZ647dCbwFWJ4QoJEjm7xBKUMtpZUzFaUVk19baWALb1r7x2uuV
         c8zborMqELFnXK6wWVrSV5XXO5mwk+nKgIiYFYaSuacTp6M1nRwsGWU6y93BrrGbrTjR
         WgCzZUCM036nJdurRU/Jit2OuA4taUWXntnNVY5wYsJ6XGvMvwHVTxVEOxeDed+jwfyw
         oj6DnTQdic9OAqS2B3PgRzpBWQFUiBjqys6KDZtW2XZDt93vgvij0FUWnm+bVPC+CyCl
         jdzOQ6z4p6Cq4cnG9oWy6yBbquBpyaslvtm5+sTUTf6pzjt/pVJBTjysgjtF9U+Ovm6H
         zO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hg8ZlxgjsyqbpHZ7OetYt5d22ngKlCVDzJjkV6i0AyQ=;
        b=k6KvCpSjJWiOZNhzclYhdUN9kpu0mYzlL0KVvfd3AHqMSddllvZxpn/xhuzg3FIFh+
         Hkc4mLf1dpC0uPsu5BTo9Zkw3J/c3ieMhUI4EruiwIYBbggd5CmGpVsGCynS6yZGTxMN
         WhCyPew3K0oxeXY/E30vPVzV4dDlWCtLfqezveWiZPU/M7TzGOYZaELRrxLaZutnOHZX
         XcP4SA1Cgz4JS0qDjuDSDpAz3bsUnHmh/cEXMPCCcLebTRaTCLdQ1Bazl7bLUAUE8H3H
         174VpToYGNHJRFkeoELIKbWSG+Ri3EN7nOhga5feRWSJHjW/F1QJaPABe+8ZgdYZ7io/
         owmQ==
X-Gm-Message-State: ACgBeo1q0kBcCg72Xgt8tvMODqvRcx1jutQxbg2a8LBmJokadx/JKVR8
        Zjii3Fb2Jloh5k+1dNLuofUS83YNnVw=
X-Google-Smtp-Source: AA6agR6EjNLvpFLrMfPJwGId/UZfhG6Qy7MStBUyWhNHXWe65JKY8fm77z6vw542EpsIBjPaWi82SQ==
X-Received: by 2002:a1f:9d17:0:b0:380:48b7:fa5 with SMTP id g23-20020a1f9d17000000b0038048b70fa5mr1923134vke.16.1660597743446;
        Mon, 15 Aug 2022 14:09:03 -0700 (PDT)
Received: from macondo ([2804:431:e7cc:d33f:5121:bb42:7f86:df53])
        by smtp.gmail.com with ESMTPSA id i18-20020a67fa12000000b0038890d0e100sm6019794vsq.27.2022.08.15.14.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:09:02 -0700 (PDT)
Date:   Mon, 15 Aug 2022 18:08:58 -0300
From:   Rafael Soares <rafaelmendsr@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes.berg@intel.com,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: genl: fix error path memory leak in policy
 dumping
Message-ID: <Yvq16sC3Pytaf04k@macondo>
References: <20220815182021.48925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815182021.48925-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:20:21AM -0700, Jakub Kicinski wrote:
> If construction of the array of policies fails when recording
> non-first policy we need to unwind.
> 
> Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
> Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 1afca2a6c2ac..57010927e20a 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  							     op.policy,
>  							     op.maxattr);
>  			if (err)
> -				return err;
> +				goto err_free_state;

There's another call to netlink_policy_dump_add_policy() right above
this one. The patch I posted to syzkaller frees the memory inside
netlink_policy_dump_add_policy() and the result was OK.

>  		}
>  	}
>  
>  	if (!ctx->state)
>  		return -ENODATA;
>  	return 0;
> +
> +err_free_state:
> +	netlink_policy_dump_free(ctx->state);
> +	return err;
>  }
>  
>  static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
> -- 
> 2.37.2
> 
