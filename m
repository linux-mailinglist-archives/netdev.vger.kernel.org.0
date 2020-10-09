Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8602881BF
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 07:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgJIFjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Oct 2020 01:39:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:43540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbgJIFjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 01:39:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 135A7ACAC;
        Fri,  9 Oct 2020 05:39:00 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Laight <David.Laight@aculab.com>,
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
        <CAMArcTUkC2MzN9MiTu_Qwouj6rFf0g0ac2uZWfSKWHTW9cR8xA@mail.gmail.com>
Date:   Fri, 09 Oct 2020 07:38:59 +0200
In-Reply-To: <CAMArcTUkC2MzN9MiTu_Qwouj6rFf0g0ac2uZWfSKWHTW9cR8xA@mail.gmail.com>
        (Taehee Yoo's message of "Fri, 9 Oct 2020 01:37:26 +0900")
Message-ID: <87r1q8gdqk.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> writes:

> On Fri, 9 Oct 2020 at 01:14, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
>
>> From: Taehee Yoo
>> > Sent: 08 October 2020 16:49
>> >
>> > When debugfs file is opened, its module should not be removed until
>> > it's closed.
>> > Because debugfs internally uses the module's data.
>> > So, it could access freed memory.

Yes, the file_operations' ->release() to be more specific -- that's not
covered by debugfs' proxy fops.


>> > In order to avoid panic, it just sets .owner to THIS_MODULE.
>> > So that all modules will be held when its debugfs file is opened.
>>
>> Can't you fix it in common code?
>
>> Yeah I was just wondering that too - weren't the proxy_fops even already
>> intended to fix this?
>
> I didn't try to fix this issue in the common code(debugfs).
> Because I thought It's a typical pattern of panic and THIS_MODULE
> can fix it clearly.
> So I couldn't think there is a root reason in the common code.

That's correct, ->owner should get set properly, c.f. my other mail in
this thread.


Thanks,

Nicolai

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
