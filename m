Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344FF52F74D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiEUBPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiEUBP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85D41B12E6;
        Fri, 20 May 2022 18:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 999A6B82EEF;
        Sat, 21 May 2022 01:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21206C385A9;
        Sat, 21 May 2022 01:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653095724;
        bh=5h1u9rIL0LMHGhntqNEZenEqpOh1+zfbjPRvQyknlKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lubYSphgq27MQ0eBYSqc7LblrhdRU9J15rSZLm0pyVb5Msj93lFGzoiwRfoB7DFcR
         y4mrFUPq+c2g9t9uqE58DWbo4zeWkOTGkbwnlhIHpfRaOno7bargXoVHMeW+S7fgaV
         8QLreMvyJ0eHgiNkWG+GYBjros80xXbNuDurTICOb5lMUI6DwoA89VO3Q3H7ZF8aDq
         bl/rTs6WFuXPSbsSDoREP41TXawtNUnUBGM79nj0tHel/fn3aha28XOuY0nzvhS9q9
         La1dRIAxqt+X/mEniU7TP7otE6qX2f+kemXKw5Zi8bAYavRb+aSvIZnPDbiY6sgdEz
         ECpAhce/Lh/Rw==
Date:   Fri, 20 May 2022 18:15:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        Xin Long <lucien.xin@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/6] rxrpc: Enable IPv6 checksums on transport
 socket
Message-ID: <20220520181522.42630ce9@kernel.org>
In-Reply-To: <165306442878.34086.2437731947506679099.stgit@warthog.procyon.org.uk>
References: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
        <165306442878.34086.2437731947506679099.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 17:33:48 +0100 David Howells wrote:
> AF_RXRPC doesn't currently enable IPv6 UDP Tx checksums on the transport
> socket it opens and the checksums in the packets it generates end up 0.
> 
> It probably should also enable IPv6 UDP Rx checksums and IPv4 UDP
> checksums.  The latter only seem to be applied if the socket family is
> AF_INET and don't seem to apply if it's AF_INET6.  IPv4 packets from an
> IPv6 socket seem to have checksums anyway.
> 
> What seems to have happened is that the inet_inv_convert_csum() call didn't
> get converted to the appropriate udp_port_cfg parameters - and
> udp_sock_create() disables checksums unless explicitly told not too.
> 
> Fix this by enabling the three udp_port_cfg checksum options.
> 
> Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
> Reported-by: Marc Dionne <marc.dionne@auristor.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

This is already in net..
pw build got gave up on this series.
Could you resend just the other 5 patches?
