Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851996A3E91
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjB0JrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjB0JrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EB718AA8;
        Mon, 27 Feb 2023 01:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E07E5B80CBE;
        Mon, 27 Feb 2023 09:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13815C433D2;
        Mon, 27 Feb 2023 09:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677491234;
        bh=PI2/InQn4fgFcapZ/jL3kZvFqp5g0t8hWLsIAKp0TZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XApITpVzB/E7lkmjiAebPTI9Qwl3YKnJbkDrHHnws6I160sa2aodXWYtgZFuMSvMZ
         6FqfHPpFwPq+hYWFjMNyptoDdQ5vOd7yN1Ain/Z6fKMyWUVxP2X2m8hPXstdZgt3u3
         EHUbadayhGGlENjcQ2d0hNUoUZg5TrPH/BjTO0weg4iK/Csl7ZnFBvlAJu+aWX9S6x
         l748sVpztd05ceKQblka8pT2EQH6Srep1XCab7NU+tjM4icOyLvuZK0DSzsonJ1wWN
         NScZRV92TR/FBCx94lSrOlCafrSNZUUyEfV0wDnAGF3xv4Z6I9vgXPLZ5Dmd6bH68/
         6seGmFYa6sH0g==
Date:   Mon, 27 Feb 2023 11:47:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] scm: fix MSG_CTRUNC setting condition for
 SO_PASSSEC
Message-ID: <Y/x8H4qCNsj4mEkA@unreal>
References: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023 at 09:17:30PM +0100, Alexander Mikhalitsyn wrote:
> Currently, we set MSG_CTRUNC flag is we have no
> msg_control buffer provided and SO_PASSCRED is set
> or if we have pending SCM_RIGHTS.
> 
> For some reason we have no corresponding check for
> SO_PASSSEC.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  include/net/scm.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Is it a bugfix? If yes, it needs Fixes line.

> 
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 1ce365f4c256..585adc1346bd 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
>  		}
>  	}
>  }
> +
> +static inline bool scm_has_secdata(struct socket *sock)
> +{
> +	return test_bit(SOCK_PASSSEC, &sock->flags);
> +}
>  #else
>  static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
>  { }
> +
> +static inline bool scm_has_secdata(struct socket *sock)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_SECURITY_NETWORK */

There is no need in this ifdef, just test bit directly.

>  
>  static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  				struct scm_cookie *scm, int flags)
>  {
>  	if (!msg->msg_control) {
> -		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
> +		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> +		    scm_has_secdata(sock))
>  			msg->msg_flags |= MSG_CTRUNC;
>  		scm_destroy(scm);
>  		return;
> -- 
> 2.34.1
> 
