Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101DA96E8C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfHUAuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:50:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfHUAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 20:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eE6jlzMwjL/0vOOq0z/UzvCZehWd+GQwCOhSvez5srM=; b=cx774dQfO7gGIfeiQp3umu9g6
        yKG7acfAW1GmE9uYDQJ1qf0Jx2B37IwqMXb5/Tzu8vkwtDqzoLkN8dkOsaFL/NtgPylPhdgmUTMHh
        fE9uO588MJd5ndKHrCVQSeA64WT0FwoOOcUhg+NSKve5/dR8ghW63ql6uyBeoajXp456gj9PcKAnX
        25zTNM5zpijqAczeZ7VsaEneyfjWy/hY7c5iwmAFKR1+04w1pL5vsZtQOURXGor8PMPwYEbCvLz4o
        xQFvRiOFohZICxi/naCcuL3ARqlyMCAp97KgJDHDNADjbHdP2rYFrH+3+nmVT3DqC1QEXm1AF4RVq
        LZjLOAXlQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0EpL-000482-7E; Wed, 21 Aug 2019 00:50:15 +0000
Date:   Tue, 20 Aug 2019 17:50:15 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Message-ID: <20190821005015.GA18776@bombadil.infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-30-willy@infradead.org>
 <20190820.165834.1420751898749952901.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820.165834.1420751898749952901.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 04:58:34PM -0700, David Miller wrote:
> From: Matthew Wilcox <willy@infradead.org>
> Date: Tue, 20 Aug 2019 15:32:50 -0700
> 
> > -		idr_replace(&head->handle_idr, fnew, fnew->handle);
> > +		xa_store(&head->filters, fnew->handle, fnew, 0);
> 
> Passing a gfp_t of zero? :-)

Yes!  We know we'll never do an allocation here because we're replacing
an entry that already exists.  It wouldn't harm us to pass a real
GFP flag, so I'll probably just change that.  It might help a future
implementation, and it will definitely save confusion.
