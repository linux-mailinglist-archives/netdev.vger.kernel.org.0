Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9CF50BD49
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449763AbiDVQn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449755AbiDVQnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4081E5EDE2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2F59B831BC
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB23C385A8;
        Fri, 22 Apr 2022 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650645659;
        bh=GdVBCuNqKqtbGdf+WuJP2+LimbZ98txv5RWt2y4+MK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m40Nl5ELRMVTN4IIyiC/6yU+7dcB+Y7gcTngYhPB/LnWPwn3iOfgiCC4UGESPrOBP
         fCLynpgo1JxoH44hITP/dyRjAJD7kcPitNuI9GUpKlpUz037U6mCaGHOgXqnYXO2pH
         1RX1erHER6p8M42yDJM0SV7d68N4lLi0w88mCYBBuT44ywpm0N7bUY8hFYAv2MJv9p
         yhVTPx3aJKRhtjD7Lpg+jf+uIHf2vLP5y1WGWu9KirvrEi1XqPXkxM0Z7+vRZ4RGKw
         5HopG4ZoagJKzX1//7ifkxwxEr6IYFCjU1iRayJKxPnUgcfcuI6pUXy0M69QKZGac0
         PAXZtChb66NUw==
Date:   Fri, 22 Apr 2022 09:40:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <20220422094058.30f34bb4@kernel.org>
In-Reply-To: <20220421153920.3637792-1-eric.dumazet@gmail.com>
References: <20220421153920.3637792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 08:39:20 -0700 Eric Dumazet wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 84d78df60453955a8eaf05847f6e2145176a727a..2fe311447fae5e860eee95f6e8772926d4915e9f 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1080,6 +1080,7 @@ struct sk_buff {
>  		unsigned int	sender_cpu;
>  	};
>  #endif
> +	u16			alloc_cpu;
>  #ifdef CONFIG_NETWORK_SECMARK
>  	__u32		secmark;
>  #endif

nit: kdoc missing
