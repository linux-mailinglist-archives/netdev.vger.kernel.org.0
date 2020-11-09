Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F9D2AC2EA
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgKIRzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbgKIRzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:55:52 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2291C0613CF;
        Mon,  9 Nov 2020 09:55:52 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 9768B1C79; Mon,  9 Nov 2020 12:55:51 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 9768B1C79
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1604944551;
        bh=3bMCJ6oV4LyUEOFexrWIXMDsBYHsUZ6jBKyfSZ6GZAg=;
        h=Date:To:Cc:Subject:References:In-Reply-To:From:From;
        b=wQOvZu2Pbp/isw5mcfB+atX+QmeeTpreMzJ3DMd8juj/0xa56YlEgLBeUvU5TFw6k
         WzDLo+CJ4UO/9YBG/BZyTiJKhy8oyAgEwg2ANtGaFEndc7B8lPMXOgri+yb6l6A/zu
         WNNVrYzt9vcSVgrgapLVXd5sTKs3sGzlqQsPo9Ps=
Date:   Mon, 9 Nov 2020 12:55:51 -0500
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Message-ID: <20201109175551.GC11144@fieldses.org>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
 <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
 <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
 <f03dae6d36c0f008796ae01bbb6de3673e783571.camel@hammerspace.com>
 <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 12:36:15PM -0500, Chuck Lever wrote:
> > On Nov 9, 2020, at 12:32 PM, Trond Myklebust <trondmy@hammerspace.com> wrote:
> > On Mon, 2020-11-09 at 12:12 -0500, Chuck Lever wrote:
> >> I assume you mean the client side only. Those issues aren't a factor
> >> on the server. Not setting SOCK_ZEROCOPY here should be enough to
> >> prevent the use of zero-copy on the client.
> >> 
> >> However, the client loses the benefits of sending a page at a time.
> >> Is there a desire to remedy that somehow?
> > 
> > What about splice reads on the server side?
> 
> On the server, this path formerly used kernel_sendpages(), which I
> assumed is similar to the sendmsg zero-copy mechanism. How does
> kernel_sendpages() mitigate against page instability?

We turn it off when gss integrity or privacy services is used, to
prevent spurious checksum failures (grep for RQ_SPLICE_OK).

But maybe that's not the only problematic case, I don't know.

--b.
