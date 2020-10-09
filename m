Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4312F2884DE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbgJIIGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbgJIIGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:06:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37F2C0613D2;
        Fri,  9 Oct 2020 01:06:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQnPr-00296a-Hh; Fri, 09 Oct 2020 10:06:15 +0200
Message-ID: <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Date:   Fri, 09 Oct 2020 10:06:14 +0200
In-Reply-To: <20201009080355.GA398994@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 10:03 +0200, Greg KH wrote:

> For lots of debugfs files, .owner should already be set, if you use the
> DEFINE_SIMPLE_ATTRIBUTE() or DEFINE_DEBUGFS_ATTRIBUTE() macros.
> 
> But yes, not all.

Right.

You didn't see the original thread:

https://lore.kernel.org/netdev/20201008155048.17679-1-ap420073@gmail.com/

> I thought the proxy-ops stuff was supposed to fix this issue already.
> Why isn't it, what is broken in them that causes this to still crash?

Well exactly what I described - the proxy_fops *release* doesn't get
proxied, since we don't have any knowledge of the open files (without
this patch) when the proxy_fops are redirected to nothing when a file is
removed.

Nicolai also discussed it a bit here:

https://lore.kernel.org/netdev/87v9fkgf4i.fsf@suse.de/

> And of course, removing kernel modules is never a guaranteed operation,
> nor is it anything that ever happens automatically, so is this really an
> issue?  :)

:)

We used to say the proxy_fops weren't needed and it wasn't an issue, and
then still implemented it. Dunno. I'm not really too concerned about it
myself, only root can hold the files open and remove modules ...

johannes

