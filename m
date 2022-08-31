Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044495A86AF
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiHaTXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiHaTXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:23:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B13DFB7D;
        Wed, 31 Aug 2022 12:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFDFEB822AD;
        Wed, 31 Aug 2022 19:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E428C43148;
        Wed, 31 Aug 2022 19:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661973829;
        bh=c3t0chfRFPX1swN2ncrFYQRhf9ygUK44TaxGI66WcKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J5UIVBbKlaozc1C+KyB1lnqAPV/SYp2x7iInF+h2cyMlS+lFpi1iC0ylrtO8d4BBz
         htdUXly2QyoGg6vjcCZBDIdVEICLAEGkKI1uB6JmAp0ybqK6Xxr+jr+AiLhBFDuC6c
         2doiQbfOwZt1niUMiyzCJNpjvcqDIHUpnGnH/JArUgeIT6lYVew2LTx4qB0q66169B
         I+GOU4jKHVjZOT+aQ1kC+J0ouQnsN0XG86oELVSmxfhF3XX7qIDZLfXzAY+VKOupB6
         eek18+WhgZN6cP6zPGgKm7AXPL7EuKLGpUiKKe0VoatNdWbSpQ+O1W5Rj2ajM2+0Oz
         YqIjVHS8S2wAA==
Date:   Wed, 31 Aug 2022 12:23:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: lantiq_xrx200: use skb cache
Message-ID: <20220831122347.5c5dcb56@kernel.org>
In-Reply-To: <20220828191931.4923-2-olek2@wp.pl>
References: <20220828191931.4923-1-olek2@wp.pl>
        <20220828191931.4923-2-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Aug 2022 21:19:31 +0200 Aleksander Jan Bajkowski wrote:
> @@ -239,7 +239,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>  		return ret;
>  	}
>  
> -	skb = build_skb(buf, priv->rx_skb_size);
> +	skb = napi_build_skb(buf, priv->rx_skb_size);

This gets called on MTU change, outside of softirq context, no?
