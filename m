Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C36374EA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKXJQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKXJQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:16:20 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E4A9B7C8;
        Thu, 24 Nov 2022 01:16:19 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 526B2C021; Thu, 24 Nov 2022 10:16:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669281384; bh=fYK7x/HVlerQ23GUYyPIC3fExRNhf08M/ieWtcdPBaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1g5nuPdhzJD/GkzC0n8BVpLRwMHqctNyzHWuXnHbIRgSdRg5WvtNsJ1XXuG8agRZr
         zxIg4yy3ZZ1jd7ipVbMnXIBgH2/pCsVny9d3Jgled84C3Itij7gD+14+oeKJMSrkmQ
         Men+YV9uCUEBB6gkh+BvSg0tl2FPljjQkbaEmfVCfP2HJ42V1ww1FZxb4tXBUDjpQ1
         /GUao+dZa3uQLTksW45w6Lpjk93KLgOqbJ1dBnt5W/mdqlTedeFg+Y4gEGocC6GS5P
         g3XXznFJYLWpNm3Tg+wrCm/2RqLT0tcqMHl95NKFSSbTf7TXf03qtO0sa95jd82AnO
         2REc39M3j/1Fg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0621EC009;
        Thu, 24 Nov 2022 10:16:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669281383; bh=fYK7x/HVlerQ23GUYyPIC3fExRNhf08M/ieWtcdPBaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=avBJQWG8xUErxoDHN+z/ITJqMCgszKmNs4fnPIdhhIc9+SfeOb70sirpQZLi2Uz6Y
         HAHGYh2GXqt23vAxe8bbWl6p6MdnQqdHIzaWTOuRigxWC/gez4eULisReRp86HVqSM
         BPP22jEE+mfGnVuwXZbhh672wYDW7QthBbo9d2EHJHCuPLVL0DO0EiOzYLUpXoANwQ
         PD1Jz2WSZvtRECzhM6EhupWV2QW7XqBkxBL8J97LihwEJoe+uAdXpU0ODhd+Bn2EQB
         jMm0JZgyTI11kli7vRvRCA2xKJGi+fVhBvx4xoZnB+lyP5KQBWyf/QfsncxPbbLW6X
         TqW9ndofVBLNA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0f5d5d5a;
        Thu, 24 Nov 2022 09:16:09 +0000 (UTC)
Date:   Thu, 24 Nov 2022 18:15:54 +0900
From:   asmadeus@codewreck.org
To:     Wang Hai <wanghai38@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, viro@zeniv.linux.org.uk,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/9p: Fix a potential socket leak in p9_socket_open
Message-ID: <Y382Spkkzt+i86e8@codewreck.org>
References: <20221124081005.66579-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221124081005.66579-1-wanghai38@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote on Thu, Nov 24, 2022 at 04:10:05PM +0800:
> Both p9_fd_create_tcp() and p9_fd_create_unix() will call
> p9_socket_open(). If the creation of p9_trans_fd fails,
> p9_fd_create_tcp() and p9_fd_create_unix() will return an
> error directly instead of releasing the cscoket, which will

(typo, socket or csocket -- I'll fix this on applying)

> result in a socket leak.
> 
> This patch adds sock_release() to fix the leak issue.

Thanks, it looks good to me.
A bit confusing that sock_alloc_files() calls sock_release() itself on
failure, but that means this one's safe at least...

> Fixes: 6b18662e239a ("9p connect fixes")

(the leak was present before that commit so I guess that's not really
correct -- but it might help figure out up to which point stable folks
will be able to backport so I guess it's useful either way)

-- 
Dominique
