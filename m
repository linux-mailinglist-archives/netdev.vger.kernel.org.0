Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C76C8064
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjCXOyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjCXOyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:54:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFD526A5;
        Fri, 24 Mar 2023 07:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A2A5CE2632;
        Fri, 24 Mar 2023 14:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C17CC4339B;
        Fri, 24 Mar 2023 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669649;
        bh=TPWqYWYcjZZiJhFHCb/PWgdZwhaa3NIwJxumP8Ne4AE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=u0lCNBJ0KX1SUavcnQTvYjIgcPFdY5tzCGohmUnp7XSarvGJUJR+X3N0ED+b1Z+gl
         sH7TmoEMF7VmFZs1cq+LiAi9G/Y/VbcjZ0+oqscjkssSUtSizmAtfYz6/IP6c/urIf
         uKaWeMaUBcb0+nTO0xMYuB7KU64vNFeWRQ/DUSoKnfsQMJudRgQMgiXqk2Ud/fZ2Qc
         EJtkj0abWuJ5gluxBusHVCp/P7CetWsnWhhKLB+XPuHm/TdBdjWyVWKw9zYKONJlVb
         NNZuVXha92AzZ60/apd6l5K3dOXbJSDTgJ9U5gmy40r5ccFzWh6URv5GjgdvZyygoW
         waJ4xrwIJrA7A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] wifi: carl9170: Replace fake flex-array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZBSl2M+aGIO1fnuG@work>
References: <ZBSl2M+aGIO1fnuG@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167966964574.27260.4294180985386180512.kvalo@kernel.org>
Date:   Fri, 24 Mar 2023 14:54:07 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/ath/carl9170/tx.c:702:61: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/tx.c:701:65: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/267
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

1be3640cbb4a wifi: carl9170: Replace fake flex-array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZBSl2M+aGIO1fnuG@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

