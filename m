Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59C06BAD79
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjCOKUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjCOKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:19:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F8D70434;
        Wed, 15 Mar 2023 03:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A4961CB0;
        Wed, 15 Mar 2023 10:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0373C433EF;
        Wed, 15 Mar 2023 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678875553;
        bh=VRoiTmWaz2biO8bfxNbnjYigMHFcTYcPttbArQsA2po=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YYPpbIq8YPV8QKLN6mqMua6A6EH/aqP9wN0P9tWrRNOob498Pv0jiL+uyYN8mN/pe
         28PJKB3aGj0LhcIcTm70m6h3OHjAH0+cPJMwtfuqLMsg/XA/SMZizB8ZOhcwm3K1Rc
         9XOPkk4DZDsUV5pj5GjSntFrhzehvZ5siec4dxVL83ePBlVTFnti4nBm/haPSrzSTv
         T6MbhQDu1Enob/WSixB6+wj/R3MWmRTwF2wRTmW8bQF+jsEuCu2xaErxgiaKYU7cYg
         a1JHiUatQk8ojc7cDwVS3UMo4qp6zBXjhYUL/E3JfFd0vVMhs4K23jPuBQXcNYQq5f
         xVvmv9TIvEINA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] wifi: ath11k: Replace fake flex-array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZAe5L5DtmsQxzqRH@work>
References: <ZAe5L5DtmsQxzqRH@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167887554899.27926.8193942719912747095.kvalo@kernel.org>
Date:   Wed, 15 Mar 2023 10:19:10 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address 25 of the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c:30:51: warning: array subscript <unknown> is outside array bounds of ‘const u32[0]’ {aka ‘const unsigned int[]’} [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/266
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3b1088a09ec9 wifi: ath11k: Replace fake flex-array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZAe5L5DtmsQxzqRH@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

