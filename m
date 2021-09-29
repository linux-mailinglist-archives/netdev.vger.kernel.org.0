Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38B341CDD7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbhI2VOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346685AbhI2VNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:13:55 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799B8C06161C;
        Wed, 29 Sep 2021 14:12:13 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 7A2467046; Wed, 29 Sep 2021 17:12:11 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 7A2467046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1632949931;
        bh=aNCVSUe1ezHP04FGaabkWlAzsR9PWbBgUjVbZnmPnEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrbW5KlXsi7AXwMiVw+KlMNteT7mz8SGIoElqbTcWay/Zqg8nMzswdS4PIHG5mVEG
         f9zVpwVFZ4zbOnM+wFnZySrN4TwiF3hCDfera4Zlyyft79q61n3KjCBAfkKo7CP5mj
         0wTiw8ZztvDwgvMymGZLkamKQ/2cLLE3MouXI044=
Date:   Wed, 29 Sep 2021 17:12:11 -0400
From:   "bfields@fieldses.org" <bfields@fieldses.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "neilb@suse.com" <neilb@suse.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Message-ID: <20210929211211.GC20707@fieldses.org>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
 <20210928031440.2222303-3-wanghai38@huawei.com>
 <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
 <20210928134952.GA25415@fieldses.org>
 <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
 <20210928141718.GC25415@fieldses.org>
 <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
 <20210928145747.GD25415@fieldses.org>
 <8b0e774bdb534c69b0612103acbe61c628fde9b1.camel@hammerspace.com>
 <20210928154300.GE25415@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928154300.GE25415@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:43:00AM -0400, bfields@fieldses.org wrote:
> On Tue, Sep 28, 2021 at 03:36:58PM +0000, Trond Myklebust wrote:
> > What is the use case here? Starting the gssd daemon or knfsd in
> > separate chrooted environments? We already know that they have to be
> > started in the same net namespace, which pretty much ensures it has to
> > be the same container.
> 
> Somehow I forgot that knfsd startup is happening in some real process's
> context too (not just a kthread).
> 
> OK, great, I agree, that sounds like it should work.

Wang Hai, do you want to try that, or should I?

--b.
