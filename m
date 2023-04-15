Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5078F6E31FB
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjDOOxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjDOOxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:53:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4AE198A
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i39Y5oEO8XFjFWW0/zWRKVDoRukYejX7J4Z8p59cN7E=; b=hAXf5oEG+pmXBON23cAIHO0rpd
        CiyKTdTmshcm8fpUVSibtyVM6Yu0Jit4Y4bFFW/nIKeW2G1xgAUUJCk/2w3yGJcxIVPcOYdkJ9wtL
        KGV7/Aey1tiCno13vBwIvElzqltngTDhkHBd6qk0PDFqE4kN2IIPhKkknZdPseafNFLQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pnhGs-00AN02-Q5; Sat, 15 Apr 2023 16:52:58 +0200
Date:   Sat, 15 Apr 2023 16:52:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 2/5] net: wangxun: libwx add rx offload functions
Message-ID: <b4ec1acd-8013-4f90-a4a4-8a1336c457d2@lunn.ch>
References: <20230414104833.42989-1-mengyuanlou@net-swift.com>
 <20230414104833.42989-3-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414104833.42989-3-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#ifdef NAPI_GRO_CB
> +		NAPI_GRO_CB(skb)->data_offset = 0;
> +#endif

https://elixir.bootlin.com/linux/latest/source/include/net/gro.h#L85

NAPI_GRO_CB does not seem to be conditional. Why the #ifdef ?

> +		skb_shinfo(skb)->gso_size = WX_CB(skb)->mss;

I have to question how safe this is:

#define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
#define WX_CB(skb) ((struct wx_cb *)(skb)->cb)

So they are both referring to the same bit of memory.

Does the design take this into account?

     Andrew
