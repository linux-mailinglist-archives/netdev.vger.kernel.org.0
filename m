Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C504C3D9D53
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhG2F4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 01:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhG2F4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 01:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 854FE61042;
        Thu, 29 Jul 2021 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627538193;
        bh=+SNXxGgtyfvtJSvpFlcjUjBSnYextIMvu3GnqLmisRg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=WQfdXRaghOLXCT8ymhifuJr8DNZEffe/G+jLc+ym/fXkJttIe2razGZt7Ai/Dskty
         mp3udIEdjRafAUq7M7ZSvFzqobaUKbRu4cTixJR2sqnNvPfj21h714N12Mk/LFXudD
         9+NsLn4X8zeIrXPdueqCEyuN7a+iOiimS257+kK8=
Date:   Thu, 29 Jul 2021 07:56:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, Bart Van Assche <bvanassche@acm.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <YQJDCw01gSp1d1/M@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
 <20210728213730.GR5047@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728213730.GR5047@suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:37:30PM +0200, David Sterba wrote:
> On Wed, Jul 28, 2021 at 02:37:20PM -0700, Bart Van Assche wrote:
> > On 7/28/21 2:14 AM, Dan Carpenter wrote:
> > > On Wed, Jul 28, 2021 at 10:59:22AM +0200, David Sterba wrote:
> > >>>   drivers/media/platform/omap3isp/ispstat.c |  5 +--
> > >>>   include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
> > >>>   2 files changed, 36 insertions(+), 13 deletions(-)
> > >>>
> > >>> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> > >>> index 5b9b57f4d9bf..ea8222fed38e 100644
> > >>> --- a/drivers/media/platform/omap3isp/ispstat.c
> > >>> +++ b/drivers/media/platform/omap3isp/ispstat.c
> > >>> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
> > >>>   int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> > >>>   					struct omap3isp_stat_data_time32 *data)
> > >>>   {
> > >>> -	struct omap3isp_stat_data data64;
> > >>> +	struct omap3isp_stat_data data64 = { };
> > >>
> > >> Should this be { 0 } ?
> > >>
> > >> We've seen patches trying to switch from { 0 } to {  } but the answer
> > >> was that { 0 } is supposed to be used,
> > >> http://www.ex-parrot.com/~chris/random/initialise.html
> > >>
> > >> (from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/)
> > > 
> > > In the kernel we don't care about portability so much.  Use the = { }
> > > GCC extension.  If the first member of the struct is a pointer then
> > > Sparse will complain about = { 0 }.
> > 
> > +1 for { }.
> 
> Oh, I thought the tendency is is to use { 0 } because that can also
> intialize the compound members, by a "scalar 0" as it appears in the
> code.
> 

Holes in the structure might not be initialized to anything if you do
either one of these as well.

Or did we finally prove that is not the case?  I can not remember
anymore...

greg k-h
