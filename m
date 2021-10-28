Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93EA43E3F6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhJ1OlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhJ1Okz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD5060FC4;
        Thu, 28 Oct 2021 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635431908;
        bh=kPrstnTyZrITONhAWz59+Ws0V6aoLXFaxlZSrZphT1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qJlOUK9yWpdYog1QmDYKgc/hfyVMq8OyxFdemYP2ReEKku9QbtEr4bjCr5p5zgXdo
         raQCZF8l+mtMMBR2yMuehecd9h447JuwbrfHpKde3af9JRhVr4waH5SAHshj7nfST2
         7f6SGMBKHIwmKplemKFdCypMlHhd0CBiNRp8FeGyOuMplEIi/5S1nHxFnooAFjrzk7
         cTLbzGSTnHeFQV25fqJnLK33sYonMh9uGC/zghFDmfNMwTdGmtXbX5SBo8lgmSPH3c
         /my70EkQbFPq0nfxmOHrlZ/dUvBB2QHMLtwtU5Ct613onogsM4d0eS/b6FnFZapkMZ
         Bi7Y4DeJyG6Ww==
Date:   Thu, 28 Oct 2021 07:38:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
        <20211027085208.16048-2-tonylu@linux.alibaba.com>
        <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
        <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
        <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 13:57:55 +0200 Karsten Graul wrote:
> So how to deal with all of this? Is it an accepted programming error
> when a user space program gets itself into this kind of situation?
> Since this problem depends on internal send/recv buffer sizes such a
> program might work on one system but not on other systems.

It's a gray area so unless someone else has a strong opinion we can
leave it as is.

> At the end the question might be if either such kind of a 'deadlock'
> is acceptable, or if it is okay to have send() return lesser bytes
> than requested.

Yeah.. the thing is we have better APIs for applications to ask not to
block than we do for applications to block. If someone really wants to
wait for all data to come out for performance reasons they will
struggle to get that behavior. 

We also have the small yet pernicious case where the buffer is
completely full at sendmsg() time, IOW we didn't send a single byte.
We won't be able to return "partial" results and deadlock. IDK if your
application can hit this, but it should really use non-blocking send if
it doesn't want blocking behavior..
