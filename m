Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290E28819A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 07:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgJIFJE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Oct 2020 01:09:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:51020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgJIFJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 01:09:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73697AF48;
        Fri,  9 Oct 2020 05:09:02 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        'Taehee Yoo' <ap420073@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210\@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list\@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev\@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth\@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its debugfs is being used
References: <20201008155048.17679-1-ap420073@gmail.com>
        <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
        <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
Date:   Fri, 09 Oct 2020 07:09:01 +0200
In-Reply-To: <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
        (Johannes Berg's message of "Thu, 08 Oct 2020 18:14:15 +0200")
Message-ID: <87v9fkgf4i.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
>> From: Taehee Yoo
>> > Sent: 08 October 2020 16:49
>> > 
>> > When debugfs file is opened, its module should not be removed until
>> > it's closed.
>> > Because debugfs internally uses the module's data.
>> > So, it could access freed memory.
>> > 
>> > In order to avoid panic, it just sets .owner to THIS_MODULE.
>> > So that all modules will be held when its debugfs file is opened.
>> 
>> Can't you fix it in common code?

Probably not: it's the call to ->release() that's faulting in the Oops
quoted in the cover letter and that one can't be protected by the
core debugfs code, unfortunately.

There's a comment in full_proxy_release(), which reads as

	/*
	 * We must not protect this against removal races here: the
	 * original releaser should be called unconditionally in order
	 * not to leak any resources. Releasers must not assume that
	 * ->i_private is still being meaningful here.
	 */

> Yeah I was just wondering that too - weren't the proxy_fops even already
> intended to fix this?

No, as far as file_operations are concerned, the proxy fops's intent was
only to ensure that the memory the file_operations' ->owner resides in
is still valid so that try_module_get() won't splat at file open
(c.f. [1]).

You're right that the default "full" proxy fops do prevent all
file_operations but ->release() from getting invoked on removed files,
but the motivation had not been to protect the file_operations
themselves, but accesses to any stale data associated with removed files
([2]).


> The modules _should_ be removing the debugfs files, and then the
> proxy_fops should kick in, no?

No, as said, not for ->release(). I haven't looked into the inidividual
patches here, but setting ->owner indeed sounds like the right thing to
do.

But you're right that modules should be removing any left debugfs files
at exit.

Thanks,

Nicolai


[1] 9fd4dcece43a ("debugfs: prevent access to possibly dead
                   file_operations at file open")
[2] 49d200deaa68 ("debugfs: prevent access to removed files' private data")

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
