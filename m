Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90669B0CA
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjBQQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjBQQZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:25:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E2E6FF06;
        Fri, 17 Feb 2023 08:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 094B0B82C8D;
        Fri, 17 Feb 2023 16:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC55C433EF;
        Fri, 17 Feb 2023 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676651100;
        bh=Fivo8skmOnLjZ6w79U1hARfmITc2NZC2f+v1QE5S9BU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kjl+EICL9e4LimEnwy+wLQ6YzvCdreayGpUgzvGnDUPNzfyORlU713P1Zf4Oq4FGM
         aw6c7as+448jKtU1QrE8Z6Nb9u/Yd0pVI1aFtrWf3B4XFzsTey0heuO+USmaQLUBG5
         tiPZCH0YhTBHeR7J6ZTWp1uvrUGpCj6je9ZbUQ2hrHPSh1msoaNtXf0cSOQQ06B2jA
         isfpbRKkBU9mA0EOAyX7Q3WxnfZfz7DWp4JaQ2OnLM0uQneh2lo0ir/Drs+l7PfuMa
         SXjcZqJDydfkj+S26NfpZz6sjZ7qB0z/kgc7OFBY4Y5nlYR6KB6GH31NuFa+i+fsa1
         uZXgIR5DezhZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath: Silence memcpy run-time false positive warning
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230210054310.never.554-kees@kernel.org>
References: <20230210054310.never.554-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167665109178.8263.14788866045287619411.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:24:58 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> The memcpy() in ath_key_config() was attempting to write across
> neighboring struct members in struct ath_keyval. Introduce a wrapping
> struct_group, kv_values, to be the addressable target of the memcpy
> without overflowing an individual member. Silences the false positive
> run-time warning:
> 
>   memcpy: detected field-spanning write (size 32) of single field "hk.kv_val" at drivers/net/wireless/ath/key.c:506 (size 16)
> 
> Link: https://bbs.archlinux.org/viewtopic.php?id=282254
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

bfcc8ba45eb8 wifi: ath: Silence memcpy run-time false positive warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230210054310.never.554-kees@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

