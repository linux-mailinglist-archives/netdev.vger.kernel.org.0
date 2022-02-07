Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83294AC71B
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiBGRR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350444AbiBGRPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:15:37 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB9C0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:15:37 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nH7bu-000FZb-Gc; Mon, 07 Feb 2022 17:15:30 +0000
Date:   Mon, 7 Feb 2022 17:15:30 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
Message-ID: <YgFTsot6DUQptjWk@zeniv-ca.linux.org.uk>
References: <20220202222031.2174584-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202222031.2174584-1-kuba@kernel.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 02:20:31PM -0800, Jakub Kicinski wrote:
> TLS recvmsg() passes user pages as destination for decrypt.
> The decrypt operation is repeated record by record, each
> record being 16kB, max. TLS allocates an sg_table and uses
> iov_iter_get_pages() to populate it with enough pages to
> fit the decrypted record.
> 
> Even though we decrypt a single message at a time we size
> the sg_table based on the entire length of the iovec.
> This leads to unnecessarily large allocations, risking
> triggering OOM conditions.
> 
> Use iov_iter_truncate() / iov_iter_reexpand() to construct
> a "capped" version of iov_iter_npages(). Alternatively we
> could parametrize iov_iter_npages() to take the size as
> arg instead of using i->count, or do something else..

Er...  Would simply passing 16384/PAGE_SIZE instead of MAX_INT work
for your purposes?
