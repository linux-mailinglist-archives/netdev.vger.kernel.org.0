Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9141D1AB3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389480AbgEMQJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:09:43 -0400
Received: from verein.lst.de ([213.95.11.211]:47365 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389465AbgEMQJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:09:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3DC4168B05; Wed, 13 May 2020 18:09:38 +0200 (CEST)
Date:   Wed, 13 May 2020 18:09:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: cleanly handle kernel vs user buffers for
 ->msg_control
Message-ID: <20200513160938.GA22381@lst.de>
References: <20200511115913.1420836-1-hch@lst.de> <20200511115913.1420836-4-hch@lst.de> <c88897b9-7afb-a6f6-08f1-5aaa36631a25@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c88897b9-7afb-a6f6-08f1-5aaa36631a25@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 08:41:57AM -0700, Eric Dumazet wrote:
> > +	 * recv* side when msg_control_is_user is set, msg_control is the kernel
> > +	 * buffer used for all other cases.
> > +	 */
> > +	union {
> > +		void		*msg_control;
> > +		void __user	*msg_control_user;
> > +	};
> > +	bool		msg_control_is_user : 1;
> 
> Adding a field in this structure seems dangerous.
> 
> Some users of 'struct msghdr '  define their own struct on the stack,
> and are unaware of this new mandatory field.
> 
> This bit contains garbage, crashes are likely to happen ?
> 
> Look at IPV6_2292PKTOPTIONS for example.

I though of that, an that is why the field is structured as-is.  The idea
is that the field only matters if:

 (1) we are in the recvmsg and friends path, and
 (2) msg_control is non-zero

I went through the places that initialize msg_control to find any spot
that would need an annotation.  The IPV6_2292PKTOPTIONS sockopt doesn't
need one as it is using the msghdr in sendmsg-like context.

That being said while I did the audit I'd appreciate another look from
people that know the networking code better than me of course.
