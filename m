Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E7B5B7D0C
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIMW3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIMW3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4185A172;
        Tue, 13 Sep 2022 15:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D9461607;
        Tue, 13 Sep 2022 22:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96EC433D6;
        Tue, 13 Sep 2022 22:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663108158;
        bh=YeIdUhpezu+PSJF2j8F0mUYzDwOXfM39RU0PHsl2DNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDisfPbZdMVcviSHu3pvOq/VmFQqmTM3flSTCcgGXVUILoSHAO5gHUK7sE2ExABV5
         iJHkE9p/nJjTJjYQfgVJUlgHHUratE1HPf26eRMyzF3zZX88Q95bpZaoLBYJjPtqm5
         MQuu1zzuEMU9hG0MUxpXVbJM1zdygMBiF8LCznnslNqwQJjy5PvZevA3WcYKYt66tJ
         dbRfBtDKBSM6RbsMjixdiQm1oC97GHdeEGfshsktCWIlqUTDeHpJ4muTUZF/3WTZO/
         YJvcLJ3dC3wuuki6SzvhMMoylD2D45GfL/UvgSvn/arEZ8Aj5kF01t64vFd44/Hk0x
         NUyqzrGTiKP/A==
Date:   Tue, 13 Sep 2022 15:29:15 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: davicom: Fix return type of dm9000_start_xmit
Message-ID: <YyEEO0ttQhMvLFIC@dev-arch.thelio-3990X>
References: <20220912194722.809525-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912194722.809525-1-nhuck@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 12:47:19PM -0700, Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of dm9000_start_xmit should be changed from int to
> netdev_tx_t.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/ethernet/davicom/dm9000.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
> index 0985ab216566..186a5e0a7862 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -1012,7 +1012,7 @@ static void dm9000_send_packet(struct net_device *dev,
>   *  Hardware start transmission.
>   *  Send a packet to media from the upper layer.
>   */
> -static int
> +static netdev_tx_t
>  dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	unsigned long flags;
> -- 
> 2.37.2.789.g6183377224-goog
> 
