Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD918288761
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbgJIK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732129AbgJIK5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:57:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B683C0613D2;
        Fri,  9 Oct 2020 03:57:03 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQq56-002Ddb-Pj; Fri, 09 Oct 2020 12:57:00 +0200
Message-ID: <793a6ba5b534917018165d38bcb5e2c5704d82c7.camel@sipsolutions.net>
Subject: Re: [RFC] debugfs: protect against rmmod while files are open
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Date:   Fri, 09 Oct 2020 12:56:59 +0200
In-Reply-To: <8fe62082d9774a1fb21894c27e140318@AcuMS.aculab.com>
References: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
         <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid>
         (sfid-20201009_124139_179083_C8D99C3A) <2a333c2a50c676c461c1e2da5847dd4024099909.camel@sipsolutions.net>
         <8fe62082d9774a1fb21894c27e140318@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 10:56 +0000, David Laight wrote:
> From: Johannes Berg
> > Sent: 09 October 2020 11:48
> > 
> > On Fri, 2020-10-09 at 12:41 +0200, Johannes Berg wrote:
> > 
> > > If the fops doesn't have a release method, we don't even need
> > > to keep a reference to the real_fops, we can just fops_put()
> > > them already in debugfs remove, and a later full_proxy_release()
> > > won't call anything anyway - this just crashed/UAFed because it
> > > used real_fops, not because there was actually a (now invalid)
> > > release() method.
> > 
> > I actually implemented something a bit better than what I described - we
> > never need a reference to the real_fops for the release method alone,
> > and that means if the release method is in the kernel image, rather than
> > a module, it can still be called.
> > 
> > That together should reduce the ~117 places you changed in the large
> > patchset to around a handful.
> 
> Is there an equivalent problem for normal cdev opens
> in any modules?

I guess so, but since there's no proxy_fops infrastructure and no
revoke(), you can't really do anything else other than adding .owner
properly, afaict.

johannes

