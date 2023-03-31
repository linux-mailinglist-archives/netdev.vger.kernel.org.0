Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCB36D22F2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjCaOuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCaOuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:50:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA501BF62;
        Fri, 31 Mar 2023 07:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19C4629BA;
        Fri, 31 Mar 2023 14:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370C0C433EF;
        Fri, 31 Mar 2023 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274199;
        bh=C0Zd4amGXRyk1IwiPYn8iKt5zSrsVKKFF8PWQuo8LLA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sXWp6Byp66QJMBS71Hca6KR8y9WFhLRf83NemTT7IUrJy7AdfeBJpigK0RrYv42oc
         ncE7ijr6FxJqydhv7HpmLmsnDi98K7Hyql5x9r8VQqj4pj9mk3dbo1iqTu3Ta9NHPR
         gQq47mMrB2Lc8X5BYPlgF1j+cO8oXtYd+MDQB+VYN7yjD2NlCFTGX2ZeYbOI+TsuMt
         uSCPsulSa/X1BHcUYc5nOwItulUgJmr782tXPP/xPpFBz7oRoqNDxExH+5b/vpZRqb
         ffoz9NXrpnRcM8It+EofEQ0SxkSd82ODQ0n5CYWI7ogWE88gA9AOKXK6so/tBid+mc
         5SRRUd0wuxmEw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [next] wifi: rtlwifi: Replace fake flex-array with flex-array
 member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZBz4x+MWoI/f65o1@work>
References: <ZBz4x+MWoI/f65o1@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027419512.32751.3442996258491675750.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:49:57 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> In function ‘fortify_memset_chk’,
>     inlined from ‘rtl_usb_probe’ at drivers/net/wireless/realtek/rtlwifi/usb.c:1044:2:
> ./include/linux/fortify-string.h:430:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   430 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/277
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

82d6077901c6 wifi: rtlwifi: Replace fake flex-array with flex-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZBz4x+MWoI/f65o1@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

