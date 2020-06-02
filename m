Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836BB1EC011
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFBQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBQdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:33:10 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABEBC05BD1E;
        Tue,  2 Jun 2020 09:33:09 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jg9qc-0021g4-VR; Tue, 02 Jun 2020 16:33:07 +0000
Date:   Tue, 2 Jun 2020 17:33:06 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602163306.GM23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 06:15:57PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午4:45, Michael S. Tsirkin wrote:
> > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > is thus benefitial to enable userspace access, do our thing, then
> > disable. Except access_ok has already been pre-validated with all the
> > relevant nospec checks, so we don't need that.  Add an API to allow
> > userspace access after access_ok and barrier_nospec are done.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Jason, so I've been thinking using something along these lines,
> > then switching vhost to use unsafe_copy_to_user and friends would
> > solve lots of problems you observed with SMAP.
> > 
> > What do you think?
> 
> 
> I'm fine with this approach.

I am not.

> >   Do we need any other APIs to make it practical?
> 
> 
> It's not clear whether we need a new API, I think __uaccess_being() has the
> assumption that the address has been validated by access_ok().

__uaccess_begin() is a stopgap, not a public API.

The problem is real, but "let's add a public API that would do user_access_begin()
with access_ok() already done" is no-go.
