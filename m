Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BCB574AA8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiGNKc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiGNKc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:32:57 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6724AD7C;
        Thu, 14 Jul 2022 03:32:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5726E20563;
        Thu, 14 Jul 2022 12:32:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PWPr9kUYYydu; Thu, 14 Jul 2022 12:32:50 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 63BA6201CA;
        Thu, 14 Jul 2022 12:32:50 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 512FF80004A;
        Thu, 14 Jul 2022 12:32:50 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 12:32:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Jul
 2022 12:32:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1451D3180B08; Thu, 14 Jul 2022 12:32:49 +0200 (CEST)
Date:   Thu, 14 Jul 2022 12:32:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Justin Stitt <justinstitt@google.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] net: ipv4: fix clang -Wformat warnings
Message-ID: <20220714103249.GK2950045@gauss3.secunet.de>
References: <20220709003704.646568-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220709003704.646568-1-justinstitt@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 05:37:04PM -0700, Justin Stitt wrote:
> When building with Clang we encounter these warnings:
> | net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
> | the argument has type 'int' [-Werror,-Wformat]
> | aalg_desc->uinfo.auth.icv_fullbits / 8);
> -
> | net/ipv4/esp4.c:1114:5: error: format specifies type 'unsigned short'
> | but the argument has type 'int' [-Werror,-Wformat]
> | aalg_desc->uinfo.auth.icv_fullbits / 8);
> 
> `aalg_desc->uinfo.auth.icv_fullbits` is a u16 but due to default
> argument promotion becomes an int.
> 
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends using
> the promoted-to-type's format flag.
> 
> As per C11 6.3.1.1:
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> can represent all values of the original type ..., the value is
> converted to an int; otherwise, it is converted to an unsigned int.
> These are called the integer promotions.` Thus it makes sense to change
> %hu to %d not only to follow this standard but to suppress the warning
> as well.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>

Applied to the ipsec tree, thanks a lot!
