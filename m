Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F381556AED8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 01:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbiGGXKe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Jul 2022 19:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbiGGXKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 19:10:33 -0400
Received: from relay5.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BBD60506
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 16:10:32 -0700 (PDT)
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id E23728056B;
        Thu,  7 Jul 2022 23:10:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id 30C582F;
        Thu,  7 Jul 2022 23:10:23 +0000 (UTC)
Message-ID: <6a8e2e97ec48e5694e623126537af3448ed99f56.camel@perches.com>
Subject: Re: [PATCH] net: rxrpc: fix clang -Wformat warning
From:   Joe Perches <joe@perches.com>
To:     Justin Stitt <justinstitt@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Date:   Thu, 07 Jul 2022 16:10:22 -0700
In-Reply-To: <20220706235648.594609-1-justinstitt@google.com>
References: <20220706235648.594609-1-justinstitt@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Stat-Signature: q75ur5j61dcw7mt9j57gstbhoo1aa1j3
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 30C582F
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19JyB57Fw8UcAjCsIKXO1xTw9rawYd6lwM=
X-HE-Tag: 1657235423-298164
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-06 at 16:56 -0700, Justin Stitt wrote:
> When building with Clang we encounter this warning:
> > net/rxrpc/rxkad.c:434:33: error: format specifies type 'unsigned short'
> > but the argument has type 'u32' (aka 'unsigned int') [-Werror,-Wformat]
> > _leave(" = %d [set %hx]", ret, y);

Does anyone still use these debugging macros in rxrpc or
is it historic cruft?

net/rxrpc/ar-internal.h-#define kenter(FMT,...) dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
net/rxrpc/ar-internal.h-#define kleave(FMT,...) dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
net/rxrpc/ar-internal.h-#define kdebug(FMT,...) dbgprintk("    "FMT ,##__VA_ARGS__)
net/rxrpc/ar-internal.h-#define kproto(FMT,...) dbgprintk("### "FMT ,##__VA_ARGS__)
net/rxrpc/ar-internal.h-#define knet(FMT,...)   dbgprintk("@@@ "FMT ,##__VA_ARGS__)

etc...

[]

net/rxrpc/Kconfig:config AF_RXRPC_DEBUG
net/rxrpc/Kconfig-      bool "RxRPC dynamic debugging"
net/rxrpc/Kconfig-      help
net/rxrpc/Kconfig-        Say Y here to make runtime controllable debugging messages appear.
net/rxrpc/Kconfig-
net/rxrpc/Kconfig-        See Documentation/networking/rxrpc.rst

This seems to show there is debugging documentation, but it
doesn't seem to exist in this file.

> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
[]
> @@ -431,7 +431,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
>  		break;
>  	}
>  
> -	_leave(" = %d [set %hx]", ret, y);
> +	_leave(" = %d [set %u]", ret, y);
>  	return ret;
>  }
>  

