Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D99757D29F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiGURfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGURfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83F11A382
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FDBF61F1E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 17:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5DEC3411E;
        Thu, 21 Jul 2022 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658424939;
        bh=LTitquVMQ/Rqr1azYGchvZJ//I2yFHtmHGINyyrB5KI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mXXJCHopGvptJky0tJWhTI5jpZ1hZtt9LUtBbCvZzMBuNSFEazcllbYibjLVe6Tpp
         H9xVB3PQQf+SXcX3UNwr142t32/JP525zYZsZQCaGdMxJF6ya/1CmfHCOCvWYD8QW5
         NDBXPc9t9rFIkhtYfbeIu8bL20tt0swR4s+g+KWpSjS3Nxqr+ndBXL47APU241hq0Q
         6XzMKzpgDtvaDPjUmG0Odi74aKZvM7MUEygTNjOvpQRmJd+dNiqQIYUUiav9/bm/+F
         ZQY7X9vffAEPXwDEyHtgxceJM3kMZYPrcAYmv48w6kM1qlkbNWfYs+p1ZCeXY9/9km
         NzE9AOP5CrMdw==
Date:   Thu, 21 Jul 2022 10:35:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Subject: Re: [PATCH net-next v2 5/7] tcp: allow tls to decrypt directly from
 the tcp rcv queue
Message-ID: <20220721103538.583907c0@kernel.org>
In-Reply-To: <084d3496bfb35de821d2ba42a22fd43ff6087921.camel@redhat.com>
References: <20220719231129.1870776-1-kuba@kernel.org>
        <20220719231129.1870776-6-kuba@kernel.org>
        <084d3496bfb35de821d2ba42a22fd43ff6087921.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 12:53:32 +0200 Paolo Abeni wrote:
> I *think* tcp_recv_skb() is not needed here, the consumed skb has been
> removed in the above loop. AFAICS tcp_read_sock() needs it because the
> recv_actor can release and re-acquire the socket lock just after the
> previous tcp_recv_skb() call. 

I see, thanks!

> I guess that retpoline overhead is a concern, to avoid calling
> tcp_read_sock() with a dummy recv_actor?

Yes, and I figured the resulting helper is not very large so should 
be okay. But I can redo it with tcp_read_sock() if you prefer.
