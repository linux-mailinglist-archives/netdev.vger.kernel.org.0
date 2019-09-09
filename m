Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B39ADC52
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbfIIPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 11:45:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbfIIPpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 11:45:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i7LqW-0000DN-Ku; Mon, 09 Sep 2019 17:44:52 +0200
Message-ID: <6f3487136e71afbd4d2b621551ee14e68c4cc1ab.camel@sipsolutions.net>
Subject: Re: [PATCH v2] net: enable wireless core features with
 LEGACY_WEXT_ALLCONFIG
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mark Salyzyn <salyzyn@android.com>, Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 09 Sep 2019 17:44:51 +0200
In-Reply-To: <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com> (sfid-20190909_162434_303033_C0355249)
References: <20190906192403.195620-1-salyzyn@android.com>
         <20190906233045.GB9478@kroah.com>
         <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com>
         (sfid-20190909_162434_303033_C0355249)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-09-09 at 07:24 -0700, Mark Salyzyn wrote:
> 
> > How is this patch applicable to stable kernels???

I'm not sure I even buy the arguments to get it into the regular kernel.

> B) there is a shortcoming in _all_ kernel versions with respect to 
> hidden configurations options like this, hoping to set one precedent in 
> how to handle them if acceptable to the community.

This really is the only argument, I think, but I don't really see it as
a shortcoming. The kernel is handling this properly, after all, with
respect to itself. You just have issues with out-of-tree modules.

And while it is true, setting that precedent might ultimately mean we'll
end up with ~80 (**) new Kconfig options in net/ alone ... That's
certainly *NOT* a precedent I want to set nor the way I want to see this
handled, when we already get complaints that we're adding too many
Kconfig options (and those are ones we really do need).

Obviously, nothing stops you from putting this into your kernel (and I
guess you already are), but I don't really see how it benefits us as a
kernel community.

> E) Timely discussion item for LPC?

Perhaps you should indeed drive that discussion there, this really is
bigger than this particular wireless feature. At the very least, to
avoid Kconfig complexity explosion, add a single new

config OPTIONS_FOR_OUT_OF_TREE_MODULES
	bool "..."
	depends on EXPERT
	help
	  ...

and make LEGACY_WEXT_ALLCONFIG depend on that.

But if you're honest and obvious about it like that, I have a hard time
seeing you get that into the tree past Greg or Linus...


Also, you probably know this, but in this particular case you really
should just get rid of your wext dependencies ... this stuff is
literally decades old, and while that isn't necessarily a bad thing, it
also has issues that have been known for a decade or so that simply
cannot be solved.


(**) git grep "bool$" and "tristate$" in Kconfig files under net/ yields
a bit more, but here you already set 5, who knows. Still, even if it's
only 20 in the end that's too much.

johannes


