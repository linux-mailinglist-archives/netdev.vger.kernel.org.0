Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23B633546
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiKVG2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKVG2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2F512771
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:27:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86FCDB8122F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A6CC433D6;
        Tue, 22 Nov 2022 06:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669098472;
        bh=MH/yqZD3LWWVAMcNMt6lFR86KMSWUyjyKO1yYV67qNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oviZiir+KXmCiNBf0drGAYt5D5vN49gNPPGyOKKSAwVxOUBeL8DPuQj/YDsEDTpYt
         9dRuYPmcFl0FWcQw5QSbDu1FLXfQ5ywaUJr1fmHdmi/SjRVuK0Xyitj176VkfRLYUe
         NbtoettThsdYmA7hsjK/qMgITTLDIVinc8eRQ7btr0rxdMTOrotoChNl+gIvSSm4fL
         hAZOt6Y/3JmWOjB6hsZKxv+5sX6LpYaDc4zFlzAHQkPVB/mvHNk9XHGsfsNxgud42M
         jWKHvpN6vWVdfGbZmwR7p2cUnkUjFWnHkdKn6onVZgWiVqyCHsFc7pIKO/61AszRQe
         QK0HFS1+ECZmQ==
Date:   Tue, 22 Nov 2022 08:27:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3xr5DkA+EZXEfkZ@unreal>
References: <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
 <Y3t7aSUBPXPoR8VD@unreal>
 <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:29:12PM +0800, Herbert Xu wrote:
> On Mon, Nov 21, 2022 at 03:21:45PM +0200, Leon Romanovsky wrote:
> >
> > The thing is that this SW acquire flow is a fraction case, as it applies
> > to locally generated traffic.
> 
> A router can trigger an acquire on forwarded packets too.  Without
> larvals this could quickly overwhelm the router.

This series doesn't support tunnel mode yet.

Maybe I was not clear, but I wanted to say what in eswitch case and
tunnel mode, the packets will be handled purely by HW without raising
into SW core.

It is so called transparent IPsec, where all configuration is done on
hypervisor, so VMs connected through eswitch will get already decrypted
traffic which is routed through eswitch NIC logic without passing
hypervisor data path.

Steffen expected to see changes to acquire logic as part of this series
and in my explanation, I tried to explain why it is not needed now and
how will it be implemented later.

Thanks

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
