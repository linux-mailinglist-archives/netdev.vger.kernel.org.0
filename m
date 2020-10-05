Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C257283D60
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgJERgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 13:36:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47834 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbgJERgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 13:36:36 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kPUPT-0002Z5-LX; Mon, 05 Oct 2020 17:36:27 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 089435FEE7; Mon,  5 Oct 2020 10:36:26 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 015479FB5C;
        Mon,  5 Oct 2020 10:36:25 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable legacy interfaces
In-reply-to: <CAKfmpSd9NaBFhBsS=3zS5R5LeaVzguZjkwuvxSLYNT-Hwvj5Zw@mail.gmail.com>
References: <20201002174001.3012643-7-jarod@redhat.com> <20201002121317.474c95f0@hermes.local> <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com> <20201002.155718.1670574240166749204.davem@davemloft.net> <CAKfmpSd9NaBFhBsS=3zS5R5LeaVzguZjkwuvxSLYNT-Hwvj5Zw@mail.gmail.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Sat, 03 Oct 2020 15:48:26 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15655.1601919385.1@famine>
Date:   Mon, 05 Oct 2020 10:36:25 -0700
Message-ID: <15656.1601919385@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Fri, Oct 2, 2020 at 6:57 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Jarod Wilson <jarod@redhat.com>
>> Date: Fri, 2 Oct 2020 16:23:46 -0400
>>
>> > I'd had a bit of feedback that people would rather see both, and be
>> > able to toggle off the old ones, rather than only having one or the
>> > other, depending on the toggle, so I thought I'd give this a try. I
>> > kind of liked the one or the other route, but I see the problems with
>> > that too.
>>
>> Please keep everything for the entire deprecation period, unconditionally.
>
>Okay, so 100% drop the Kconfig flag patch, but duplicate sysfs
>interface names are acceptable, correct? Then what about the procfs
>file having duplicate Slave and Port lines? Just leave them all as
>Slave?

	My preference is to not alter the existing sysfs / proc behavior
at all, and instead create a netlink / iproute UAPI that becomes the
"preferred" UAPI going forward.  Any new functionality would only be
added to netlink as incentive to switch.

	I don't see the value in adding duplicate fields, as userspace
code that parses them will not be portable if it only checks for the new
field name.  Then, down the road, deleting the old names will break the
userspace code that was never updated (which will likely be most of it).

	I would rather see a single clean break from proc and sysfs to
netlink in one step than a piecemeal addition and removal from the
existing UAPI.  That makes for a much clearer flag day event for end
users.  By this I mean leave proc / sysfs as-is today, and then after a
suitable deprecation period, remove it wholesale (rather than a compile
time option).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
