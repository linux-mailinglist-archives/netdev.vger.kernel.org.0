Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E09D2CC79E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbgLBUSP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 15:18:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgLBUSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:18:14 -0500
Received: from 1.general.jvosburgh.uk.vpn ([10.172.196.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kkYZ6-0001rP-14; Wed, 02 Dec 2020 20:17:28 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 657595FEE8; Wed,  2 Dec 2020 12:17:26 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5F9249FAB0;
        Wed,  2 Dec 2020 12:17:26 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
In-reply-to: <CAKfmpSez1UYLG5nGYbMsRALGpEyXnwJcoFJV_7vALgpG3Xotcw@mail.gmail.com>
References: <20201123031716.6179-1-jarod@redhat.com> <20201202173053.13800-1-jarod@redhat.com> <14711.1606931728@famine> <CAKfmpSez1UYLG5nGYbMsRALGpEyXnwJcoFJV_7vALgpG3Xotcw@mail.gmail.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Wed, 02 Dec 2020 14:23:00 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21152.1606940246.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 02 Dec 2020 12:17:26 -0800
Message-ID: <21153.1606940246@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Wed, Dec 2, 2020 at 12:55 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>>
>> Jarod Wilson <jarod@redhat.com> wrote:
>>
>> >Don't try to adjust XFRM support flags if the bond device isn't yet
>> >registered. Bad things can currently happen when netdev_change_features()
>> >is called without having wanted_features fully filled in yet. Basically,
>> >this code was racing against register_netdevice() filling in
>> >wanted_features, and when it got there first, the empty wanted_features
>> >led to features also getting emptied out, which was definitely not the
>> >intended behavior, so prevent that from happening.
>>
>>         Is this an actual race?  Reading Ivan's prior message, it sounds
>> like it's an ordering problem (in that bond_newlink calls
>> register_netdevice after bond_changelink).
>
>Sorry, yeah, this is not actually a race condition, just an ordering
>issue, bond_check_params() gets called at init time, which leads to
>bond_option_mode_set() being called, and does so prior to
>bond_create() running, which is where we actually call
>register_netdevice().

	So this only happens if there's a "mode" module parameter?  That
doesn't sound like the call path that Ivan described (coming in via
bond_newlink).

	-J

>>         The change to bond_option_mode_set tests against reg_state, so
>> presumably it wants to skip the first(?) time through, before the
>> register_netdevice call; is that right?
>
>Correct. Later on, when the bonding driver is already loaded, and
>parameter changes are made, bond_option_mode_set() gets called and if
>the mode changes to or from active-backup, we do need/want this code
>to run to update wanted and features flags properly.
>
>
>-- 
>Jarod Wilson
>jarod@redhat.com

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
