Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8171B4904
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDVPoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgDVPoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:44:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F5C03C1A9;
        Wed, 22 Apr 2020 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d189Ht66WkNhS7qEev42XSV+pMJKpBQ+6wQXP4iX/B0=; b=nw4Xj1fY4FG1c+4lbVWravMDJg
        FmJrQLxqg8GzrzqGIYlmpd4sbmocteJxuRA0UlFGIAtBEPVd8EtW0bO+XUYXYRGqoYWTkELYcq7Hk
        PiOmvar7kH7mjR6YHZlQIIEtCU3WK6WpmPL7AhpJ4kxkDAz4qoGMAoc677HYTMwbqm2+mXtbjI6bO
        EHSSg8CVovE2aDqNn3EGvysLCibViHIEs/7lXsfKT+1Y0ADQDs8wU6mWsqdT/ZR44ibgrGt87y0G3
        T5VUBSvN8BIwJxipP0FAkplmTKSsCTDs/mUN5D9Fv6HicsQ2PmqoTca6GAbQZYAiUKDKA+kAGudKu
        /vf0E95w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRHXY-0001vC-BB; Wed, 22 Apr 2020 15:43:56 +0000
Date:   Wed, 22 Apr 2020 08:43:56 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     "Karstens, Nate" <Nate.Karstens@garmin.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork
Message-ID: <20200422154356.GU5820@bombadil.infradead.org>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <fa6c5c9c7c434f878c94a7c984cd43ba@garmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa6c5c9c7c434f878c94a7c984cd43ba@garmin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 03:36:09PM +0000, Karstens, Nate wrote:
> There was some skepticism about whether our practice of
> closing/reopening sockets was advisable. Regardless, it does expose what
> I believe to be something that was overlooked in the forking process
> model. We posted two solutions to the Austin Group defect tracker:

I don't think it was "overlooked" at all.  It's not safe to call system()
from a threaded app.  That's all.  It's right there in the DESCRIPTION:

   The system() function need not be thread-safe.
https://pubs.opengroup.org/onlinepubs/9699919799/functions/system.html

> Ultimately the Austin Group felt that close-on-fork
> was the preferred approach. I think it's also worth
> pointing that out Solaris reportedly has this feature
> (https://www.mail-archive.com/austin-group-l@opengroup.org/msg05359.html).

I am perplexed that the Austin Group thought this was a good idea.
