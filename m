Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB8672EF6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjASC0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjASC0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:26:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE5267968
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:26:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 162FF617CE
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F37C433D2;
        Thu, 19 Jan 2023 02:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674095161;
        bh=Mi6ICJL4HchSsfUlrUvAqnmRfPSLK8ZVbVsq0b2XbTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U9lzaJRS/4XDp3zXuyDlf1AO0r7VuOQJ4jH+w02dxpXSPAj6liyDsadvJMnBoFmgq
         Y/KGRp4pIU9O+IM0Rug0xXGd8+webSsR8iCbXvQvmrG7RFyT03G4HDpiwOoNtvY5Nq
         s+/4WePA605rF7QHjmcpoWXJMYH9g8WdfLRCQJCcVFu/bWYVKyrUtNk5XtnQoe/qK+
         7uZbMFR7YcnBifIFD2Vp84lQ0ZnVocvNADftitPyW3ufbmG82Cbrs7jAE8hNyXZJjs
         5lqjdgzrruPJrQXu/7oaUv2WR3XanGrb7Ew8ZNT+sOyfSW2lnamZY8GBPkRBYZuLGg
         SixfhhabCrlQw==
Date:   Wed, 18 Jan 2023 18:26:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Message-ID: <20230118182600.026c8421@kernel.org>
In-Reply-To: <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
        <167361792462.531803.224198635706602340.stgit@firesoul>
        <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
> > +		skb_mark_not_on_list(segs);  
> 
> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
> 
> I don't understand why I cannot clear skb->next here?

Some of the skbs on the list are not private?
IOW we should only unlink them if skb_unref().
