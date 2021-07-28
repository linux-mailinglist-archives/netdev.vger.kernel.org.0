Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0526E3D97AE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhG1VkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:40:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1VkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 17:40:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A4D301FFF7;
        Wed, 28 Jul 2021 21:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627508415;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oR4vzK6aCnqNgUfz40K7pF710nacCw6QNahoytQWvX8=;
        b=P+ZyHs6ofwzlskr3maz1kpnvrKfXlFoSHajF4uBqYXJi2q7qQ4/a6KvY4/0cgio85hOyYh
        EBOqUdyPJGAHk7Z+VzxfdvaESSda8uIHQnCY8HfeOaPgPC13mEZcQZ10rs+T5vJ9Pm4uqI
        xEfXn1PQjEiV1Wbs/RqxZWRTjMTIBAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627508415;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oR4vzK6aCnqNgUfz40K7pF710nacCw6QNahoytQWvX8=;
        b=l8IhwodTcUf+H2UTz+tdhmnb2dLWuiDuSzYxRUsIHmqcrBZ5Hdp9nLOp6zptu/z+kIJUOu
        wq++yx9GJLecP8CA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 81390A3B83;
        Wed, 28 Jul 2021 21:40:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6EF36DA8A7; Wed, 28 Jul 2021 23:37:30 +0200 (CEST)
Date:   Wed, 28 Jul 2021 23:37:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210728213730.GR5047@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Bart Van Assche <bvanassche@acm.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 02:37:20PM -0700, Bart Van Assche wrote:
> On 7/28/21 2:14 AM, Dan Carpenter wrote:
> > On Wed, Jul 28, 2021 at 10:59:22AM +0200, David Sterba wrote:
> >>>   drivers/media/platform/omap3isp/ispstat.c |  5 +--
> >>>   include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
> >>>   2 files changed, 36 insertions(+), 13 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> >>> index 5b9b57f4d9bf..ea8222fed38e 100644
> >>> --- a/drivers/media/platform/omap3isp/ispstat.c
> >>> +++ b/drivers/media/platform/omap3isp/ispstat.c
> >>> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
> >>>   int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> >>>   					struct omap3isp_stat_data_time32 *data)
> >>>   {
> >>> -	struct omap3isp_stat_data data64;
> >>> +	struct omap3isp_stat_data data64 = { };
> >>
> >> Should this be { 0 } ?
> >>
> >> We've seen patches trying to switch from { 0 } to {  } but the answer
> >> was that { 0 } is supposed to be used,
> >> http://www.ex-parrot.com/~chris/random/initialise.html
> >>
> >> (from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/)
> > 
> > In the kernel we don't care about portability so much.  Use the = { }
> > GCC extension.  If the first member of the struct is a pointer then
> > Sparse will complain about = { 0 }.
> 
> +1 for { }.

Oh, I thought the tendency is is to use { 0 } because that can also
intialize the compound members, by a "scalar 0" as it appears in the
code.
