Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3885E8853
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 06:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiIXE2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 00:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiIXE2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 00:28:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21332F8C04;
        Fri, 23 Sep 2022 21:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B17C660A73;
        Sat, 24 Sep 2022 04:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078E9C433D6;
        Sat, 24 Sep 2022 04:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663993692;
        bh=86eW6iIqE0bM9Xt04DpkiC+DSve+XgiN712S/FIk0CI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9BS9Az+Bf6cGWLFRHh1FvsgvpmrpzfqXc2HNs2RJbdTxTmxspK5NUKHb4Kh64oQR
         Sfj890V+mJJxCXY7jCadT/JV9s5fK9TMMGPKyNT3J8R6wUNhCPJKFS9ebeTYwT4PyL
         1eRfvCbuRedXzCY42rWYrbak1Mb8/yvTcLghSv6URJKjVe2qN+7FCduvb5AzK2VBo3
         CROnPmPdIudYPRyepAzJHF7sxxcd8pm33DGCBPCtu6LW1sqaupTet1iX3slgXw9RNB
         XmeBd9nuKOEW5qOeyVnSqvVpd0kSZZ/FCEqgl/S8oA6AzB3Li05izfqkBaR4d46kOl
         +8KN69wSExZOg==
Date:   Fri, 23 Sep 2022 23:28:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] NFC: hci: Split memcpy() of struct hcp_message flexible
 array
Message-ID: <Yy6HVVMGdSCyEHbZ@work>
References: <20220924040835.3364912-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924040835.3364912-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 09:08:35PM -0700, Kees Cook wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated. This
> split already existed for the "firstfrag" case, so just generalize the
> logic further.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/
> 
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Reported-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  net/nfc/hci/hcp.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
> index 05c60988f59a..4902f5064098 100644
> --- a/net/nfc/hci/hcp.c
> +++ b/net/nfc/hci/hcp.c
> @@ -73,14 +73,12 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
>  		if (firstfrag) {
>  			firstfrag = false;
>  			packet->message.header = HCP_HEADER(type, instruction);
> -			if (ptr) {
> -				memcpy(packet->message.data, ptr,
> -				       data_link_len - 1);
> -				ptr += data_link_len - 1;
> -			}
>  		} else {
> -			memcpy(&packet->message, ptr, data_link_len);
> -			ptr += data_link_len;
> +			packet->message.header = *ptr++;
> +		}
> +		if (ptr) {
> +			memcpy(packet->message.data, ptr, data_link_len - 1);
> +			ptr += data_link_len - 1;
>  		}
>  
>  		/* This is the last fragment, set the cb bit */
> -- 
> 2.34.1
> 
