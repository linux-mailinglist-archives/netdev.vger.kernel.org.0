Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E039A637D83
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKXQQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXQQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:16:04 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9BD5ADF9;
        Thu, 24 Nov 2022 08:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=miyEx8Lvn6qBvvvvpZMBad8XUo7oHhn8LKm5H35p0iY=; b=au0bv3esIGNCwbpleIoD/gmreN
        V3Z0IPip15p0H9Xw1rTsoyl0PAF6DVHZl4pLDzbcogCNMVYDD923dL0b0OxfHhJBgTUabM31lr3Go
        ZrDKiCSk4YNsdL2Hv+MukyGKSMi2Ep0RlokzXjefT0BfKhd8Nr4vgmxh5L6sCH06HMaKHBWQnwKzY
        3fA3NsYSYu1aDRIgSUiGH3JtimB34qHvBjG5S4gCTHeVC6fGKiaKB7b5DadqKv4nSNOIP8xJy7kci
        4rn2ArI8X+YGsqQWlxi3xXXa7FPpvsVyALkgvL+m+90JrjAZjJk5KyI4spECoGtLipVEpo/QlnLJo
        PhGe5M5A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oyEsz-006TPU-3B;
        Thu, 24 Nov 2022 16:15:38 +0000
Date:   Thu, 24 Nov 2022 16:15:37 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     asmadeus@codewreck.org
Cc:     Wang Hai <wanghai38@huawei.com>, ericvh@gmail.com,
        lucho@ionkov.net, linux_oss@crudebyte.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/9p: Fix a potential socket leak in p9_socket_open
Message-ID: <Y3+YqUbLXZ1ouynB@ZenIV>
References: <20221124081005.66579-1-wanghai38@huawei.com>
 <Y382Spkkzt+i86e8@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y382Spkkzt+i86e8@codewreck.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 06:15:54PM +0900, asmadeus@codewreck.org wrote:
> Wang Hai wrote on Thu, Nov 24, 2022 at 04:10:05PM +0800:
> > Both p9_fd_create_tcp() and p9_fd_create_unix() will call
> > p9_socket_open(). If the creation of p9_trans_fd fails,
> > p9_fd_create_tcp() and p9_fd_create_unix() will return an
> > error directly instead of releasing the cscoket, which will
> 
> (typo, socket or csocket -- I'll fix this on applying)
> 
> > result in a socket leak.
> > 
> > This patch adds sock_release() to fix the leak issue.
> 
> Thanks, it looks good to me.
> A bit confusing that sock_alloc_files() calls sock_release() itself on
> failure, but that means this one's safe at least...

sock_alloc_file() unconditionally consumes socket reference;
either it is transferred to new struct file it returns, or
it's dropped.  Makes for simpler logics in callers...
FWIW,
ACKed-by: Al Viro <viro@zeniv.linux.org.uk>
on the leak fix.
