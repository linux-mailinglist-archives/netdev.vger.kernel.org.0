Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792D756AA24
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbiGGR65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiGGR6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127E240AD;
        Thu,  7 Jul 2022 10:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1336B82299;
        Thu,  7 Jul 2022 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59E9C3411E;
        Thu,  7 Jul 2022 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657216727;
        bh=iL3xIVjNybuWSiJjZ22VYxa1SB6+T14cOhJZN7GXylI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LDQrMLNrzJ6N5uQHsqODYBfAgEIQ1w+ISzrC5bbPvDpbr2SISXO3U+dJkEYXLD9NI
         XePnOs2Zx7ktshBV61vIp6UjBVtCr4FRvRJEwIDt+yLsC6nOQxgNGBLqp8MBLnCQHC
         EmNXV/y2HBtC+S64KN8I97tX+RoapjOxA1jU5layGe7ejrTCiXIjsp6bDAZm5IFmrx
         tkoJKWxC/gfjGH/gGL+uAg/hb5pE488qNrC3VuV8AE+SivhrvRXbYCmCgifSTO/TEX
         XGONNh3hPdOJM+3i/UJhczZgbt8Xgeuo9EkFSfphoDEXVCNYbg95xUqVA1EIJ1e3JE
         TfXjIBUtptDOg==
Date:   Thu, 7 Jul 2022 10:58:45 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: rxrpc: fix clang -Wformat warning
Message-ID: <Ysce1Xur72MYp0/d@dev-arch.thelio-3990X>
References: <20220706235648.594609-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706235648.594609-1-justinstitt@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Justin,

On Wed, Jul 06, 2022 at 04:56:48PM -0700, Justin Stitt wrote:
> When building with Clang we encounter this warning:
> | net/rxrpc/rxkad.c:434:33: error: format specifies type 'unsigned short'
> | but the argument has type 'u32' (aka 'unsigned int') [-Werror,-Wformat]
> | _leave(" = %d [set %hx]", ret, y);
> 
> y is a u32 but the format specifier is `%hx`. Going from unsigned int to
> short int results in a loss of data. This is surely not intended
> behavior. If it is intended, the warning should be suppressed through
> other means.
> 
> This patch should get us closer to the goal of enabling the -Wformat
> flag for Clang builds.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
>  net/rxrpc/rxkad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index 08aab5c01437..aa180464ec37 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c
> @@ -431,7 +431,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
>  		break;
>  	}
>  
> -	_leave(" = %d [set %hx]", ret, y);
> +	_leave(" = %d [set %u]", ret, y);

Should this just become %x to keep printing it as a hexidecimal number?

Cheers,
Nathan

>  	return ret;
>  }
>  
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
