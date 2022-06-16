Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76AB54E891
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378164AbiFPRTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378067AbiFPRTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E130248E6E;
        Thu, 16 Jun 2022 10:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B4C61AA0;
        Thu, 16 Jun 2022 17:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800D0C34114;
        Thu, 16 Jun 2022 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655399971;
        bh=dVuVhPmEkC9puN9Rze1DZ34ZIAYl9igVaP1wUSkTnZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvRzKL82Afj1pQ+Lgxowkk0MRYXG+iBGz/N9ndvOmSmZRkK32/FmzJOgPfyetmDWq
         o/xgytYUn/+3nkWCrb5RhgDP8qZr6a9USvDoD701VgSJtNg4ldTJR6vGCfyHa7+oFf
         Dim3Ym/VX/LHRt7gZrV52SmaJ5ZmqLU4/vNyhqqypQDHL9bU9vTRygB5L/Pmm8MsN6
         uemMupVS1yMnFkCyTNCucZt6RZawSdxdxfpF4pJGQr8kGiMcM8046i++o4LV7ohc7F
         YDUXJhyEyTLAaNyN1GKBvNhg15bqcX4/P4heFUSSYHuiI4Ee4dFSYcfykA+r/5fTsd
         zat27tGVbKOgQ==
Date:   Thu, 16 Jun 2022 10:19:28 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] hinic: Replace memcpy() with direct assignment
Message-ID: <YqtmIIAOH7uRNAZ5@dev-arch.thelio-3990X>
References: <20220616052312.292861-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616052312.292861-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 10:23:12PM -0700, Kees Cook wrote:
> Under CONFIG_FORTIFY_SOURCE=y and CONFIG_UBSAN_BOUNDS=y, Clang is bugged
> here for calculating the size of the destination buffer (0x10 instead of
> 0x14). This copy is a fixed size (sizeof(struct fw_section_info_st)), with
> the source and dest being struct fw_section_info_st, so the memcpy should
> be safe, assuming the index is within bounds, which is UBSAN_BOUNDS's
> responsibility to figure out.
> 
> Avoid the whole thing and just do a direct assignment. This results in
> no change to the executable code.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Tom Rix <trix@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Simon Horman <simon.horman@corigine.com>
> Cc: netdev@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Link: https://github.com/ClangBuiltLinux/linux/issues/1592
> Signed-off-by: Kees Cook <keescook@chromium.org>

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

> ---
>  drivers/net/ethernet/huawei/hinic/hinic_devlink.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index 60ae8bfc5f69..1749d26f4bef 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -43,9 +43,7 @@ static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
>  
>  	for (i = 0; i < fw_image->fw_info.fw_section_cnt; i++) {
>  		len += fw_image->fw_section_info[i].fw_section_len;
> -		memcpy(&host_image->image_section_info[i],
> -		       &fw_image->fw_section_info[i],
> -		       sizeof(struct fw_section_info_st));
> +		host_image->image_section_info[i] = fw_image->fw_section_info[i];
>  	}
>  
>  	if (len != fw_image->fw_len ||
> -- 
> 2.32.0
> 
