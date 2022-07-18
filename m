Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78C57814D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiGRLxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiGRLxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:53:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D7022BC0;
        Mon, 18 Jul 2022 04:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F221B810F4;
        Mon, 18 Jul 2022 11:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC6EC341C0;
        Mon, 18 Jul 2022 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145193;
        bh=Phc0x9SWsO+X5B2V1yFiu7oQp3xqcc3kPiUwuV37VD8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cg61rv7JyfsvKq+pksU/RtmLFEnKmV+HUjSL9k9VcgV9wPu8DQUbXhZkQJU10FWS+
         DHEkassZJsixQy50n+gfle8U7saVv8HQScsSNr5+vm9k0ZeKGWAl7M9kTC7ohwYzkm
         bvHvJR7BJqDCBP5XcbCpRvrA6CEREA3o65Bz7qWBuZk9M4pAEXdf9TkTSD2h6/5ny7
         b3pZFZWIrTBvAjr7+wPNYUxU9Y732kq52a9d6vZBv6mD16sjxRTIjsVNbzzfDOe5Dk
         LjjkrvngQqErw1skCAsTELnEKBC/La+bXexwO2kR3Q8Ki7aA2U/cfky/YWbq9OcUVP
         pOdWGOl45aigg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mt7601u: eeprom: fix clang -Wformat warning
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709001527.618593-1-justinstitt@google.com>
References: <20220709001527.618593-1-justinstitt@google.com>
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
Message-ID: <165814518849.17539.4270310820175063607.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 11:53:10 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:

> When building with Clang we encounter the following warning:
> | drivers/net/wireless/mediatek/mt7601u/eeprom.c:193:5: error: format
> | specifies type 'char' but the argument has type 'int' [-Werror,-Wformat]
> | chan_bounds[idx].start + chan_bounds[idx].num - 1);
> 
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends using
> the promoted-to-type's format flag.
> 
> Moreover, C11 6.3.1.1 states:
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> can represent all values of the original type ..., the value is
> converted to an int; otherwise, it is converted to an unsigned int.
> These are called the integer promotions.`
> 
> With this information in hand, we really should stop using `%hh[dxu]` or
> `%h[dxu]` as they usually prompt Clang -Wformat warnings as well as go
> against documented standard recommendations.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Patch applied to wireless-next.git, thanks.

07db88f11e63 wifi: mt7601u: eeprom: fix clang -Wformat warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709001527.618593-1-justinstitt@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

