Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2165AFD3C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIGHQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIGHQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1AEA2DBE;
        Wed,  7 Sep 2022 00:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4511A6160B;
        Wed,  7 Sep 2022 07:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC0AC433D7;
        Wed,  7 Sep 2022 07:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662535001;
        bh=MrpRDWXHho8O9dUoFZ11Bt8djGB4NUss+3ZdVZoSHVc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hihLo+HAEXzylR9hMj7Sf4Vq9G0K8zZGgAT0/kM0VQkxGK0fvoJ9pKznCrPla8ole
         eWgdfNNzUGuaUOOzisB8KLGko3WSU0XVphWKKPGBqABR0KVhn7q2kAKLSh3aYtFif7
         JZwXS3HX3cXrfxFPdZT+jBp0H3vLMiybGeVdCMpy1gyjILedkIqapFPcs0jtGsHo5V
         YYs9J9vOr+8k9wvMmmt8nJz3H7Hj826/sAk58HAeTxDI1nI7hPvuwej/9X/sGrhusP
         AznfQWq38y24d6lV6QPF/9uL91EYADu8fxAvMfBhnlb7kFBMa7eC49SI0X0OUVhTKe
         kNVGTZvhpp2aw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: iwlwifi: calib: Refactor iwl_calib_result usage for clarity
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220901204558.2256458-1-keescook@chromium.org>
References: <20220901204558.2256458-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Andy Lavr <andy.lavr@gmail.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253499319.23292.401375353887849776.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 07:16:38 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing run-time destination buffer
> bounds checking for memcpy(), refactor the use of struct iwl_calib_result:
> 
> - Have struct iwl_calib_result contain struct iwl_calib_cmd since
>   functions expect to operate on the "data" flex array in "cmd", which
>   follows the "hdr" member.
> - Switch argument passing around to use struct iwl_calib_cmd instead of
>   struct iwl_calib_hdr to prepare functions to see the "data" member.
> - Change iwl_calib_set()'s "len" argument to a size_t since it is always
>   unsigned and is normally receiving the output of sizeof().
> - Add an explicit length sanity check in iwl_calib_set().
> - Adjust the memcpy() to avoid copying across the now visible composite
>   flex array structure.
> 
> This avoids the future run-time warning:
> 
>   memcpy: detected field-spanning write (size 8) of single field "&res->hdr" (size 4)
> 
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Reported-by: Andy Lavr <andy.lavr@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

0d24201f47c4 wifi: iwlwifi: calib: Refactor iwl_calib_result usage for clarity

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220901204558.2256458-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

