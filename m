Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5441EC4CB
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFBWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBWLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:11:00 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB44C08C5C0;
        Tue,  2 Jun 2020 15:11:00 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgF7Z-0029hu-Nk; Tue, 02 Jun 2020 22:10:57 +0000
Date:   Tue, 2 Jun 2020 23:10:57 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602221057.GQ23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200602163048.GL23230@ZenIV.linux.org.uk>
 <20200602163937-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602163937-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 04:42:03PM -0400, Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2020 at 05:30:48PM +0100, Al Viro wrote:
> > On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > > is thus benefitial to enable userspace access, do our thing, then
> > > disable. Except access_ok has already been pre-validated with all the
> > > relevant nospec checks, so we don't need that.  Add an API to allow
> > > userspace access after access_ok and barrier_nospec are done.
> > 
> > This is the wrong way to do it, and this API is certain to be abused
> > elsewhere.  NAK - we need to sort out vhost-related problems, but
> > this is not an acceptable solution.  Sorry.
> 
> OK so summarizing what you and Linus both said, we need at
> least a way to make sure access_ok (and preferably the barrier too)
> is not missed.
> 
> Another comment is about actually checking that performance impact
> is significant and worth the complexity and risk.
> 
> Is that a fair summary?
> 
> I'm actually thinking it's doable with a new __unsafe_user type of
> pointer, sparse will then catch errors for us.

Er... how would sparse keep track of the range?
