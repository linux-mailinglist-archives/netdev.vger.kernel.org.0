Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB704578152
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiGRLyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiGRLyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0962C1;
        Mon, 18 Jul 2022 04:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91636143D;
        Mon, 18 Jul 2022 11:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90053C341C0;
        Mon, 18 Jul 2022 11:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145272;
        bh=JO1/+51IzIqWlRVWa3wn637GFpPwLMpOLbdkHlx7z6s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LyhqHG+1nHgHhSWyS0qNHxtwg2KvdDfaLkocSe8qQpmPpduziHZ2lrRXhKkLOyq9r
         DXnLHnYom0JqG0h1Kyx5UjCBFoE6Hil+1Bw4Ihe/CLl8/k3AJqnMdXnoGr14BRnKfa
         3LGFydaAbvOfagpqm9rZEbVWcsWNEhqpWbzkEFaDvq0BocuJBw00UUajV4zhqENzbL
         ijtdjZqzrZ/F4hDItOADXSFs6Cp1jtY1godjsymHtLIqRz2DzXCAuqiim95HV0y21w
         fFslpygl9J3WkEBeU+qwUwk7qoBa1pH62ehtVrpOJvXNEIZJOmIclJ/6RaMNtBG7VX
         uZAzVyGyQVq7w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mt7601u: fix clang -Wformat warning
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220711212932.1501592-1-justinstitt@google.com>
References: <20220711212932.1501592-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Justin Stitt <justinstitt@google.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814526751.17539.17204768341511432544.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 11:54:29 +0000 (UTC)
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URI_DOTEDU autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:

> When building with Clang we encounter this warning:
> | drivers/net/wireless/mediatek/mt7601u/debugfs.c:92:6: error: format
> | specifies type 'unsigned char' but the argument has type 'int'
> | [-Werror,-Wformat] dev->ee->reg.start + dev->ee->reg.num - 1);
> 
> The format specifier used is `%hhu` which describes a u8. Both
> `dev->ee->reg.start` and `.num` are u8 as well. However, the expression
> as a whole is promoted to an int as you cannot get smaller-than-int from
> addition. Therefore, to fix the warning, use the promoted-to-type's
> format specifier -- in this case `%d`.
> 
> example:
> ```
> uint8_t a = 4, b = 7;
> int size = sizeof(a + b - 1);
> printf("%d\n", size);
> // output: 4
> ```
> 
> See more:
> (https://wiki.sei.cmu.edu/confluence/display/c/INT02-C.+Understand+integer+conversion+rules)
> "Integer types smaller than int are promoted when an operation is
> performed on them. If all values of the original type can be represented
> as an int, the value of the smaller type is converted to an int;
> otherwise, it is converted to an unsigned int."
> 
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-next.git, thanks.

68204a696505 wifi: mt7601u: fix clang -Wformat warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220711212932.1501592-1-justinstitt@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

