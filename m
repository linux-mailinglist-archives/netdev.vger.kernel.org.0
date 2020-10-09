Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0922883D6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbgJIHpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbgJIHpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 03:45:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F86C0613D2;
        Fri,  9 Oct 2020 00:45:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQn5j-0028Ss-3l; Fri, 09 Oct 2020 09:45:27 +0200
Message-ID: <fd8aaf06b53f32eae7b5bdcec2f3ea9e1f419b1d.camel@sipsolutions.net>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its
 debugfs is being used
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nicolai Stange <nstange@suse.de>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        'Taehee Yoo' <ap420073@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date:   Fri, 09 Oct 2020 09:45:20 +0200
In-Reply-To: <87v9fkgf4i.fsf@suse.de>
References: <20201008155048.17679-1-ap420073@gmail.com>
         <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
         <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
         <87v9fkgf4i.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 07:09 +0200, Nicolai Stange wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
> > > From: Taehee Yoo
> > > > Sent: 08 October 2020 16:49
> > > > 
> > > > When debugfs file is opened, its module should not be removed until
> > > > it's closed.
> > > > Because debugfs internally uses the module's data.
> > > > So, it could access freed memory.
> > > > 
> > > > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > > > So that all modules will be held when its debugfs file is opened.
> > > 
> > > Can't you fix it in common code?
> 
> Probably not: it's the call to ->release() that's faulting in the Oops
> quoted in the cover letter and that one can't be protected by the
> core debugfs code, unfortunately.
> 
> There's a comment in full_proxy_release(), which reads as
> 
> 	/*
> 	 * We must not protect this against removal races here: the
> 	 * original releaser should be called unconditionally in order
> 	 * not to leak any resources. Releasers must not assume that
> 	 * ->i_private is still being meaningful here.
> 	 */

Yeah, found that too now :-)

> > Yeah I was just wondering that too - weren't the proxy_fops even already
> > intended to fix this?
> 
> No, as far as file_operations are concerned, the proxy fops's intent was
> only to ensure that the memory the file_operations' ->owner resides in
> is still valid so that try_module_get() won't splat at file open
> (c.f. [1]).

Right.

> You're right that the default "full" proxy fops do prevent all
> file_operations but ->release() from getting invoked on removed files,
> but the motivation had not been to protect the file_operations
> themselves, but accesses to any stale data associated with removed files
> ([2]).

:)

I actually got this to work in a crazy way, I'll send something out but
I'm sure it's a better idea to add the .owner everywhere, but please
let's do it in fewer than hundreds of patches :-)

johannes

