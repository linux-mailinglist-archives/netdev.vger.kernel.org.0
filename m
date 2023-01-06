Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92A0660440
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbjAFQ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbjAFQ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:27:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43865DE44;
        Fri,  6 Jan 2023 08:27:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F69AB81D9C;
        Fri,  6 Jan 2023 16:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E830AC433D2;
        Fri,  6 Jan 2023 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673022459;
        bh=AzKGgYVMInMdjQmyjjFqHOTYxjbhsiHA9tT3/tUbEUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDpwNPQ/qxOtAqUGh6oWYPqYoW+8fR5Rdb9DsxBjoXcyX4mhoBNctjDttvQkh+cmW
         AA60OgAQLh21G+T4GyaMeG8o3WYi5cLDIaZvVkOCnWAFirx0JwS1FvLCbEu7f+O7kC
         1p9HJyCCbwxqCSUD9jUJVjoedaIMkVM+jNUVQ+d63bjdkFFD1a0c9R+mpYYgONnkX9
         lrB2qw0ruuHEJk3DAJog6bfXyH3QuCe7YYnrwyHGqKPMY11wx6c1Xe3NKWZo9uzAKT
         lm0MWUqGejl4KhbN/7wZX8yY4lQifK+mIUiQ/zwitfn5t5nPZq7KZXVDQXK+inRtLq
         Z2kunqJCvvMGA==
Date:   Fri, 6 Jan 2023 10:27:44 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH] net/i40e: Replace 0-length array with
 flexible array
Message-ID: <Y7hMALdQP7MC+mD7@work>
References: <20230105234557.never.799-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105234557.never.799-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 03:46:01PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct i40e_lump_tracking's
> "list" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
> 
> In function 'i40e_put_lump',
>     inlined from 'i40e_clear_interrupt_scheme' at drivers/net/ethernet/intel/i40e/i40e_main.c:5145:2:
> drivers/net/ethernet/intel/i40e/i40e_main.c:278:27: warning: array subscript <unknown> is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Warray-bounds=]
>   278 |                 pile->list[i] = 0;
>       |                 ~~~~~~~~~~^~~
> drivers/net/ethernet/intel/i40e/i40e.h: In function 'i40e_clear_interrupt_scheme':
> drivers/net/ethernet/intel/i40e/i40e.h:179:13: note: while referencing 'list'
>   179 |         u16 list[0];
>       |             ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/net/ethernet/intel/i40e/i40e.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index 60e351665c70..3a1c28ca5bb4 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -176,7 +176,7 @@ enum i40e_interrupt_policy {
>  
>  struct i40e_lump_tracking {
>  	u16 num_entries;
> -	u16 list[0];
> +	u16 list[];
>  #define I40E_PILE_VALID_BIT  0x8000
>  #define I40E_IWARP_IRQ_PILE_ID  (I40E_PILE_VALID_BIT - 2)
>  };
> -- 
> 2.34.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
