Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91956AA6E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiGGSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236128AbiGGSYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86B22F03B;
        Thu,  7 Jul 2022 11:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B1FDB82340;
        Thu,  7 Jul 2022 18:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2AAC3411E;
        Thu,  7 Jul 2022 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657218246;
        bh=linJlkK0HAHLMdjOBvguKF5iShjpB0jbq6MyXKvaFZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7htMa30gqLwN5lFj4UQ3gQzBYmSefuAKVWW0S+566czBzSzYGqykYQIN06GHeevb
         9DusZE68RJje8w4Q9uDUjmr7C2+ZId96lP/Pwxu20yrP/JtwL5bAukJgqa3HjmjPwy
         PrQYi6Y1AZhLD/AacgcQOZ+2P86XP68lu45bUL4gKBM8hHPlmCI7FsXTirjZcYZ5AP
         DFCb+7F1Ic5HrITZVHD1xd3dEoE3j2vr3skb+KCY/lp4jiKlvw/REycoBJLd3TrQ4w
         9HkQGVlqs94MD29jYTxs1Qmj9UmBM/HNdSfhLIE4xobjyQk2J5+uzB24tQtRVx+c25
         EahEvIT50eJ8Q==
Date:   Thu, 7 Jul 2022 11:24:03 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        marc.dionne@auristor.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com, trix@redhat.com
Subject: Re: [PATCH v2] net: rxrpc: fix clang -Wformat warning
Message-ID: <Ysckw9ok670tojo1@dev-arch.thelio-3990X>
References: <20220706235648.594609-1-justinstitt@google.com>
 <20220707182052.769989-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707182052.769989-1-justinstitt@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 11:20:52AM -0700, Justin Stitt wrote:
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

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
> diff from v1 -> v2: 
> * Change format specifier from %u to %x to properly represent hexadecimal.
> 
>  net/rxrpc/rxkad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index 08aab5c01437..258917a714c8 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c
> @@ -431,7 +431,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
>  		break;
>  	}
>  
> -	_leave(" = %d [set %hx]", ret, y);
> +	_leave(" = %d [set %x]", ret, y);
>  	return ret;
>  }
>  
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
