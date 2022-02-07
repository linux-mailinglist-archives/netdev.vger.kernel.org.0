Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7C14AC7C4
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbiBGRlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbiBGR0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:26:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACEEC0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:26:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D5A60FC7
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0600CC004E1;
        Mon,  7 Feb 2022 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644254781;
        bh=HJl5p9+tsRPv2pogmPvUDPBJ3S/U0GdT6DWgCj+o9JM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S/6+4N/gdVl4kgp1v8OYi6u9i1ycMckRAfUVtq+otp8glQJN5xCMNGX+wldCadtyv
         +tXSuyPKsFPZKbyY+GQUoqZ1cD9+53pQsjY2DuMoEcAcMcx8c8wK4Re7JT4BR2Fs0y
         o71TjT7OGlOz6zIJun/qwZyI8SvrNoUMw4QTPqBdSnRkB8YtQpiWPg8oud2rbx4zuS
         zThF+iNeAlPmDJI7+bEzVhZwmpRRi5sG454OzleWFFOBZeueKjYvWDSeik/3Ko2Y8P
         b5SbdtFeu9lpW325Te7stIaxRMz2XrOfgZPkIrUjvZnySFd5amH5xVant0XOyAX6BJ
         TN4z9LwRPAvfg==
Date:   Mon, 7 Feb 2022 09:26:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
Message-ID: <20220207092619.08754453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
References: <20220202222031.2174584-1-kuba@kernel.org>
        <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
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

On Mon, 7 Feb 2022 17:15:30 +0000 Al Viro wrote:
> On Wed, Feb 02, 2022 at 02:20:31PM -0800, Jakub Kicinski wrote:
> > TLS recvmsg() passes user pages as destination for decrypt.
> > The decrypt operation is repeated record by record, each
> > record being 16kB, max. TLS allocates an sg_table and uses
> > iov_iter_get_pages() to populate it with enough pages to
> > fit the decrypted record.
> > 
> > Even though we decrypt a single message at a time we size
> > the sg_table based on the entire length of the iovec.
> > This leads to unnecessarily large allocations, risking
> > triggering OOM conditions.
> > 
> > Use iov_iter_truncate() / iov_iter_reexpand() to construct
> > a "capped" version of iov_iter_npages(). Alternatively we
> > could parametrize iov_iter_npages() to take the size as
> > arg instead of using i->count, or do something else..  
> 
> Er...  Would simply passing 16384/PAGE_SIZE instead of MAX_INT work
> for your purposes?

The last arg is maxpages, I want maxbytes, no?
