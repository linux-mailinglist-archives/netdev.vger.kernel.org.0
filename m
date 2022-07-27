Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8885824BF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiG0KsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0KsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B47BC03;
        Wed, 27 Jul 2022 03:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E578E618A3;
        Wed, 27 Jul 2022 10:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE9CC433C1;
        Wed, 27 Jul 2022 10:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658918891;
        bh=DRFuPn9kMjyTP06/jiDcxlM9zqpGD3R4D5kU/hYwyLk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=URFnToo5JzEHl2i3XwSCTggjAVHJj6UFMfKWYLZhpwnkbP2iHgEjljWjwqVWO7KHE
         FTxehimMJgfU3WB68HHKbspKpXoIrrPebG/H6vZh/HG7HDNLm3NBJtrl+oKwmepNh8
         0LeSVct3uBjdBvyloWoMWuHfWBGr+MUXbevB8mL/C+81ZAJ0w0tuQaD45lg7rX1Ud0
         UHG0Ao0OYe4bdAYFYqYInFfGs355tPAhhL6uEbr0gWvL63ZeRGpITgTpdomF3yJRMu
         22B50ciqsOEKsCH1prDTWH+121e6voq2zs8auIoksskDEvtvZgI9SB2Qw9Hd5baDTN
         R5RD4zk+EsH1A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: iwlwifi: mvm: fix clang -Wformat warnings
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220711222919.2043613-1-justinstitt@google.com>
References: <20220711222919.2043613-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Justin Stitt <justinstitt@google.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891888198.17998.12309173336559232552.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:48:07 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:

> When building with Clang we encounter these warnings:
> | drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1108:47: error:
> | format specifies type 'unsigned char' but the argument has type 's16'
> | (aka 'short') [-Werror,-Wformat] IWL_DEBUG_INFO(mvm, "\tburst index:
> | %hhu\n", res->ftm.burst_index);
> -
> | drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1111:47: error:
> | format specifies type 'unsigned char' but the argument has type 's32'
> | (aka 'int') [-Werror,-Wformat] IWL_DEBUG_INFO(mvm, "\trssi spread:
> | %hhu\n", res->ftm.rssi_spread);
> 
> The previous format specifier `%hhu` describes a u8 but our arguments
> are wider than this which means bits are potentially being lost.
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
> `%hhu` to `%d` for both instances of the warning.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Patch applied to wireless-next.git, thanks.

7819b3d1dab5 wifi: iwlwifi: mvm: fix clang -Wformat warnings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220711222919.2043613-1-justinstitt@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

