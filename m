Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131B0288514
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbgJIITG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbgJIITF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:19:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F989C0613D2;
        Fri,  9 Oct 2020 01:19:05 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQncE-0029Tg-Uc; Fri, 09 Oct 2020 10:19:03 +0200
Message-ID: <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Date:   Fri, 09 Oct 2020 10:19:02 +0200
In-Reply-To: <20201009081624.GA401030@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 10:16 +0200, Greg KH wrote:
> On Fri, Oct 09, 2020 at 10:06:14AM +0200, Johannes Berg wrote:
> > We used to say the proxy_fops weren't needed and it wasn't an issue, and
> > then still implemented it. Dunno. I'm not really too concerned about it
> > myself, only root can hold the files open and remove modules ...
> 
> proxy_fops were needed because devices can be removed from the system at
> any time, causing their debugfs files to want to also be removed.  It
> wasn't because of unloading kernel code.

Indeed, that's true. Still, we lived with it for years.

Anyway, like I said, I really just did this more to see that it _could_
be done, not to suggest that it _should_ :-)

I think adding the .owner everywhere would be good, and perhaps we can
somehow put a check somewhere like

	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);

to prevent the issue in the future?

johannes

