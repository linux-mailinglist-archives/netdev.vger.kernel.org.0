Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650806B1BD1
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 07:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCIGvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 01:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCIGvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 01:51:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8BD93E2D;
        Wed,  8 Mar 2023 22:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 097F361A01;
        Thu,  9 Mar 2023 06:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F56AC433D2;
        Thu,  9 Mar 2023 06:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678344701;
        bh=5vy2q8a1kNSG2PJaeuSkCgz3Tv69W3F7z95NxLs4+7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OnxQCzPMeQFFAPihqgV4fvOiIXv6yYsoWU04mjMlGxCgHHrvOT/suD7nYK/yRsCps
         A9CrWrheS8CHnn2/wShhecayMN8tqAtOU/WZIPMHD8kwNuxuf6pDlw5YtHvrLR3KX3
         heQZ95s+l5CFcujcMreuvfuHTj47ga6Olhc6JBCE39qvZWX5VrgADDWGhE096s4A/L
         tkaT7gYYpPRERbktido+J7sS3GMrWver0NfzGr3Mo2mske2TucKLriiXi8f5OR4sxO
         I6EIrwRegJlTmRmQoVTdYEsjZR12lSBkpYgXI+oMC7sdKM93xeLXwUbN9sM5RNODfc
         YpZ6ozG1yiflA==
Date:   Wed, 8 Mar 2023 22:51:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Yichun Zhang <yichun@openresty.com>,
        Alexander Duyck <alexanderduyck@fb.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net, stable v1 3/3] virtio_net: add checking sq is full
 inside xdp xmit
Message-ID: <20230308225140.46c22c89@kernel.org>
In-Reply-To: <20230308071921-mutt-send-email-mst@kernel.org>
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
        <20230308024935.91686-4-xuanzhuo@linux.alibaba.com>
        <7eea924e-5cc3-8584-af95-04587f303f8f@huawei.com>
        <1678259647.118581-1-xuanzhuo@linux.alibaba.com>
        <5a4564dc-af93-4305-49a4-5ca16d737bc3@huawei.com>
        <20230308071921-mutt-send-email-mst@kernel.org>
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

On Wed, 8 Mar 2023 07:21:07 -0500 Michael S. Tsirkin wrote:
> > >  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
> > >  *                               struct net_device *dev);
> > >  *	Called when a packet needs to be transmitted.
> > >  *	Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should stop
> > >  *	the queue before that can happen; it's for obsolete devices and weird
> > >  *	corner cases, but the stack really does a non-trivial amount
> > >  *	of useless work if you return NETDEV_TX_BUSY.
> > >  *	Required; cannot be NULL.  
> > 
> > Thanks for the pointer. It is intersting, it seems most driver is not flollowing
> > the suggestion.  
> 
> Yes - I don't know why.

Most modern drivers don't stop the queue upfront?
We try to catch it in review, so anything remotely recent should. 
But a lot of people DTRT *and* check at the start of .xmit if 
the skb fits (return BUSY if it doesn't) - defensive programming.
But the BUSY path should never hit.
