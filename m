Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9D3466FF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCWR4n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Mar 2021 13:56:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41983 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhCWR4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:56:35 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lOlGX-0001cz-9z; Tue, 23 Mar 2021 17:56:29 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6E07D5FEE7; Tue, 23 Mar 2021 10:56:27 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 6682DA0410;
        Tue, 23 Mar 2021 10:56:27 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
cc:     Leon Romanovsky <leon@kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net] bonding: Work around lockdep_is_held false positives
In-reply-to: <0f3add4c-45a4-d3cd-96a3-70c1f0e96ee2@nvidia.com>
References: <20210322123846.3024549-1-maximmi@nvidia.com> <YFilJZOraCqD0mVj@unreal> <0f3add4c-45a4-d3cd-96a3-70c1f0e96ee2@nvidia.com>
Comments: In-reply-to Maxim Mikityanskiy <maximmi@nvidia.com>
   message dated "Tue, 23 Mar 2021 19:34:32 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27508.1616522187.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 23 Mar 2021 10:56:27 -0700
Message-ID: <27509.1616522187@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

>On 2021-03-22 16:09, Leon Romanovsky wrote:
>> On Mon, Mar 22, 2021 at 02:38:46PM +0200, Maxim Mikityanskiy wrote:
>>> After lockdep gets triggered for the first time, it gets disabled, and
>>> lockdep_enabled() will return false. It will affect lockdep_is_held(),
>>> which will start returning true all the time. Normally, it just disables
>>> checks that expect a lock to be held. However, the bonding code checks
>>> that a lock is NOT held, which triggers a false positive in WARN_ON.
>>>
>>> This commit addresses the issue by replacing lockdep_is_held with
>>> spin_is_locked, which should have the same effect, but without suffering
>>> from disabling lockdep.
>>>
>>> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>> ---
>>> While this patch works around the issue, I would like to discuss better
>>> options. Another straightforward approach is to extend lockdep API with
>>> lockdep_is_not_held(), which will be basically !lockdep_is_held() when
>>> lockdep is enabled, but will return true when !lockdep_enabled().
>>
>> lockdep_assert_not_held() was added in this cycle to tip: locking/core
>> https://yhbt.net/lore/all/161475935945.20312.2870945278690244669.tip-bot2@tip-bot2/
>> https://yhbt.net/lore/all/878s779s9f.fsf@codeaurora.org/
>
>Thanks for this suggestion - I wasn't aware that this macro was recently
>added and I could use it instead of spin_is_locked.
>
>Still, I would like to figure out why the bonding code does this test at
>all. This lock is not taken by bond_update_slave_arr() itself, so why is
>that a problem in this code?

	The goal, I believe, is to insure that the mode_lock is not held
by the caller when entering bond_update_slave_arr.  I suspect this is
because bond_update_slave_arr may sleep.  One calling context notes this
in a comment:

void bond_3ad_handle_link_change(struct slave *slave, char link)
{
[...]
	/* RTNL is held and mode_lock is released so it's safe
	 * to update slave_array here.
	 */
	bond_update_slave_arr(slave->bond, NULL);

	However, as far as I can tell, lockdep_is_held() does not test
for "lock held by this particular context" but instead is "lock held by
any context at all."  As such, I think the test is not valid, and should
be removed.

	The code in question was added by:

commit ee6377147409a00c071b2da853059a7d59979fbc
Author: Mahesh Bandewar <maheshb@google.com>
Date:   Sat Oct 4 17:45:01 2014 -0700

    bonding: Simplify the xmit function for modes that use xmit_hash

	Mahesh, Nikolay, any thoughts?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
