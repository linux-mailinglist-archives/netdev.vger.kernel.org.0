Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E6F5AA641
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiIBDUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIBDUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C62DD;
        Thu,  1 Sep 2022 20:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F28A9B82980;
        Fri,  2 Sep 2022 03:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C0DC433C1;
        Fri,  2 Sep 2022 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662088836;
        bh=YCJr9iHj+jHwZFgouCTxuRVFKnFA7bJfiUzOTkjxtlU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dYSc+wLxPM3Yxq6Tepm+O2b5CE0LnE/uLcuB3UF7dpSrUCNiaq1IjDnAKB3j5h6Od
         kde0sBLDinZONd4n/Gd2VmnhXEUL8d2coEnSIqCEye2PPPhtpgvRy+JClBsqQ5yD3B
         uF2QlkmbEr714wxnl/dzRNK95n5BZunlBWJ+bDTJq8br8+Lj1hMlfXwxko4d4Xb7Bv
         KU5pvdluBstPOvjtNT2SFQYC1zrftKAuMoQhgjnz07Rke5QZcpPvFNtRCcM0XhRDpN
         kw7U7gYdianibdtrotsZJbh/dB2Tb3elNYjYf+AQxjaD/1vJmD6XhP2IC+uISPj2Mj
         zhsHiqcmU66AQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
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
Subject: Re: [PATCH] iwlwifi: calib: Refactor iwl_calib_result usage for clarity
References: <20220901204558.2256458-1-keescook@chromium.org>
Date:   Fri, 02 Sep 2022 06:20:26 +0300
In-Reply-To: <20220901204558.2256458-1-keescook@chromium.org> (Kees Cook's
        message of "Thu, 1 Sep 2022 13:45:58 -0700")
Message-ID: <87ilm6ea2t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

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

Gregory, as this fixes a future warning can I take this directly to
wireless-next?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
