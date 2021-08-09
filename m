Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783283E449D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhHILXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:23:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34390 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbhHILXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 07:23:44 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6D8F421ED4;
        Mon,  9 Aug 2021 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628508202;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEHaigBd+p4Kdq3FOyfyiQahnEWWgwrbyI9p3sYy9Jg=;
        b=FUJg+QaU7zw3qTf6t8q9Qr96X0Utqfsl+nS4wyhc9/5vWZMS539Of9T5SM02pWzim1Cnda
        RMrFBB4C9IiCbCzLy7hKe0Nw5kCTqLiYUG2RwoYyBydeMv59tIlgL5Vpa/xsWEDauKkWvj
        09N1MMAWFSlJkFOi7ijKkWYVWovvXhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628508202;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEHaigBd+p4Kdq3FOyfyiQahnEWWgwrbyI9p3sYy9Jg=;
        b=4VeRarVySJZv/AlngzeBW/O6mbVTRAHHGwmwBsPvaCbeLhv85RY/VfIGPtUkorqnnpUTKq
        o+aHpptVRlTrrwAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 53C44A3B8E;
        Mon,  9 Aug 2021 11:23:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BAE5EDA880; Mon,  9 Aug 2021 13:20:30 +0200 (CEST)
Date:   Mon, 9 Aug 2021 13:20:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 47/64] btrfs: Use memset_after() to clear end of struct
Message-ID: <20210809112030.GM5047@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-48-keescook@chromium.org>
 <20210728094215.GX5047@twin.jikos.cz>
 <202107281455.2A0753F5@keescook>
 <20210729103337.GS5047@suse.cz>
 <202107310822.31BEB6E543@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202107310822.31BEB6E543@keescook>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 08:25:51AM -0700, Kees Cook wrote:
> On Thu, Jul 29, 2021 at 12:33:37PM +0200, David Sterba wrote:
> > On Wed, Jul 28, 2021 at 02:56:31PM -0700, Kees Cook wrote:
> > > On Wed, Jul 28, 2021 at 11:42:15AM +0200, David Sterba wrote:
> > > > On Tue, Jul 27, 2021 at 01:58:38PM -0700, Kees Cook wrote:
> > > > >  	}
> > > > >  	if (need_reset) {
> > > > > -		memset(&item->generation_v2, 0,
> > > > > -			sizeof(*item) - offsetof(struct btrfs_root_item,
> > > > > -					generation_v2));
> > > > > -
> > > > 
> > > > Please add
> > > > 		/* Clear all members from generation_v2 onwards */
> > > > 
> > > > > +		memset_after(item, 0, level);
> > > 
> > > Perhaps there should be another helper memset_starting()? That would
> > > make these cases a bit more self-documenting.
> > 
> > That would be better, yes.
> > 
> > > +		memset_starting(item, 0, generation_v2);
> > 
> > memset_from?
> 
> For v2, I bikeshed this to "memset_startat" since "from" is semantically
> close to "source" which I thought might be confusing. (I, too, did not
> like "starting".) :)

memset_startat works for me, thanks.
