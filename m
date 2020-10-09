Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3DB28857C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbgJIIol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730726AbgJIIok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:44:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4987C0613D2;
        Fri,  9 Oct 2020 01:44:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQo0z-002ADp-I5; Fri, 09 Oct 2020 10:44:37 +0200
Message-ID: <e3a807b1d5f728c178f43b453f3b495bf53abfce.camel@sipsolutions.net>
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Laight <David.Laight@ACULAB.COM>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Date:   Fri, 09 Oct 2020 10:44:35 +0200
In-Reply-To: <03c42bb5f57a4c3d9c782a023add28cd@AcuMS.aculab.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
         <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
         <03c42bb5f57a4c3d9c782a023add28cd@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 08:34 +0000, David Laight wrote:
> 
> > I think adding the .owner everywhere would be good, and perhaps we can
> > somehow put a check somewhere like
> > 
> > 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> > 
> > to prevent the issue in the future?
> 
> Does it ever make any sense to set .owner to anything other than
> THIS_MODULE?

No. But I believe THIS_MODULE is NULL for built-in code, so we can't
just WARN_ON(!fops->owner).

> If not the code that saves the 'struct file_operations' address
> ought to be able to save the associated module.

No, it's const.

> I was also wondering if this affects normal opens?
> They should hold a reference on the module to stop it being unloaded.
> Does that rely on .owner being set?

Yes.

> For debugfs surely it is possible to determine and save THIS_MODULE
> when he nodes are registers and do a try_module_get() in the open?

I don't really see where to save it?

johannes

