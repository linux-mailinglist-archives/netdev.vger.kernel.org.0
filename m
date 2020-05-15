Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9131D55E7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgEOQZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:25:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50480 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgEOQZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:25:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 350E78EE2CA;
        Fri, 15 May 2020 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589559953;
        bh=oe8glbLAsYuPDWO/9J63l1A3/JX/rXGWHMdk2ewNMOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Czl8nSVKq6x+5ktnGMuDJVoRjCd8L3FTEERzkB0JPBwHBwxznk411UGYdCzb5lZu1
         guXqDfI5hhx4GtqifLJzgz2O7o+zakP9bsnBOCG71vbinXNa+oln+R6g4WgfNyfjcx
         Dabx0g7ig9tCia5NBUFs1/E7rJ8h9iOaFC99r79c=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 97RosFnuv28I; Fri, 15 May 2020 09:25:53 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0DABA8EE25D;
        Fri, 15 May 2020 09:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589559952;
        bh=oe8glbLAsYuPDWO/9J63l1A3/JX/rXGWHMdk2ewNMOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tEY8nMzR1YlR1vbSBOyT5z55J1VGQgL9BDudw6VE1ewecDFlqb3xXMh32AnzbC6a0
         GT1kzr/7c46ULfMWi/Nj6X758girml/uRbappkQnXN1skHpVjas/3GLPJiLL2lQrCw
         JH6+lou1vP4NouYYQFthT7Aiqk1UItTX2BoqHrRA=
Message-ID: <1589559950.3653.11.camel@HansenPartnership.com>
Subject: Re: [PATCH v2] Implement close-on-fork
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Karstens, Nate" <Nate.Karstens@garmin.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>,
        "a.josey@opengroup.org" <a.josey@opengroup.org>
Date:   Fri, 15 May 2020 09:25:50 -0700
In-Reply-To: <5b1929aa9f424e689c7f430663891827@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
         <20200515155730.GF16070@bombadil.infradead.org>
         <5b1929aa9f424e689c7f430663891827@garmin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-15 at 16:07 +0000, Karstens, Nate wrote:
> Matthew,
> 
> What alternative would you suggest?
> 
> From an earlier email:
> 
> > ...nothing else addresses the underlying issue: there is no way to
> > prevent a fork() from duplicating the resource. The close-on-exec
> > flag partially-addresses this by allowing the parent process to
> > mark a file descriptor as exclusive to itself, but there is still
> > a period of time the failure can occur because the auto-close only
> > occurs during the exec(). Perhaps this would not be an issue with
> > a different process/threading model, but that is another discussion
> > entirely.
> 
> Do you disagree there is an issue?

Oh good grief that's a leading question: When I write bad code and it
crashes, most people would agree there is an issue; very few would
agree the kernel should be changed to fix it. Several of us have
already said the problem seems to be with the way your application is
written.  You didn't even answer emails like this speculating about the
cause being the way your application counts resources:

https://lore.kernel.org/linux-fsdevel/1587569663.3485.18.camel@HansenPartnership.com/

The bottom line is that we think you could rewrite this one application
not to have the problem you're complaining about rather than introduce
a new kernel API to "fix" it.

James



