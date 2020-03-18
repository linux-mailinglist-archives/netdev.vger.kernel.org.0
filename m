Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1639118A3E0
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCRUmR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Mar 2020 16:42:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54825 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRUmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:42:17 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jEfVj-0004Va-6W; Wed, 18 Mar 2020 20:41:55 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 691DB630E4; Wed, 18 Mar 2020 13:41:53 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5DA87AC1DD;
        Wed, 18 Mar 2020 13:41:53 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
In-reply-to: <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com>
References: <20200318140605.45273-1-jarod@redhat.com> <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com> <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Wed, 18 Mar 2020 14:32:52 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25628.1584564113.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 18 Mar 2020 13:41:53 -0700
Message-ID: <25629.1584564113@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Wed, Mar 18, 2020 at 2:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> On 3/18/20 7:06 AM, Jarod Wilson wrote:
>> > Bonding slave and team port devices should not have link-local addresses
>> > automatically added to them, as it can interfere with openvswitch being
>> > able to properly add tc ingress.
>> >
>> > Reported-by: Moshe Levi <moshele@mellanox.com>
>> > CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
>> > CC: netdev@vger.kernel.org
>> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
>>
>>
>> This does not look a net candidate to me, unless the bug has been added recently ?
>>
>> The absence of Fixes: tag is a red flag for a net submission.
>>
>> By adding a Fixes: tag, you are doing us a favor, please.
>
>Yeah, wasn't entirely sure on this one. It fixes a problem, but it's
>not exactly a new one. A quick look at git history suggests this might
>actually be something that technically pre-dates the move to git in
>2005, but only really became a problem with some additional far more
>recent infrastructure (tc and friends). I can resubmit it as net-next
>if that's preferred.

	Commit

c2edacf80e15 bonding / ipv6: no addrconf for slaves separately from master

	should (in theory) already prevent ipv6 link-local addrconf, at
least for bonding slaves, and dates from 2007.  If something has changed
to break the logic in this commit, then (a) you might need to do some
research to find a candidate for your Fixes tag, and (b) I'd suggest
also investigating whether or not the change added by c2edacf80e15 to
addrconf_notify() no longer serves any purpose, and should be removed if
that is the case.

	Note also that the hyperv netvsc driver, in netvsc_vf_join(),
sets IFF_SLAVE in order to trigger the addrconf prevention logic from
c2edacf80e15; I'm not sure if your patch would affect its expectations
(if c2edacf80e15 were removed).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
