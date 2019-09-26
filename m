Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D863BEB61
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 06:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391822AbfIZEjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 00:39:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36223 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbfIZEjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 00:39:01 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iDLYO-0005Au-Q9; Thu, 26 Sep 2019 04:38:57 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id B11E824778D; Wed, 25 Sep 2019 21:38:54 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id AA514289C56;
        Wed, 25 Sep 2019 21:38:54 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Aleksei Zakharov <zaharov@selectel.ru>
cc:     netdev@vger.kernel.org, "zhangsha (A)" <zhangsha.zhang@huawei.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <CAJYOGF9TY8WtUscsfJ=qduAw7_1BwU+4iE+eL6cidM=LBL9w+A@mail.gmail.com>
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com> <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com> <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com> <10497.1569049560@nyx> <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com> <16538.1569371467@famine> <CAJYOGF9TY8WtUscsfJ=qduAw7_1BwU+4iE+eL6cidM=LBL9w+A@mail.gmail.com>
Comments: In-reply-to Aleksei Zakharov <zaharov@selectel.ru>
   message dated "Wed, 25 Sep 2019 14:01:50 +0300."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Wed, 25 Sep 2019 21:38:54 -0700
Message-ID: <15507.1569472734@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aleksei Zakharov <zaharov@selectel.ru> wrote:

>ср, 25 сент. 2019 г. в 03:31, Jay Vosburgh <jay.vosburgh@canonical.com>:
>>
>> Алексей Захаров wrote:
>> [...]
>> >Right after reboot one of the slaves hangs with actor port state 71
>> >and partner port state 1.
>> >It doesn't send lacpdu and seems to be broken.
>> >Setting link down and up again fixes slave state.
>> [...]
>>
>>         I think I see what failed in the first patch, could you test the
>> following patch?  This one is for net-next, so you'd need to again swap
>> slave_err / netdev_err for the Ubuntu 4.15 kernel.
>>
>I've tested new patch. It seems to work. I can't reproduce the bug
>with this patch.
>There are two types of messages when link becomes up:
>First:
>bond-san: EVENT 1 llu 4294895911 slave eth2
>8021q: adding VLAN 0 to HW filter on device eth2
>bond-san: link status definitely down for interface eth2, disabling it
>mlx4_en: eth2: Link Up
>bond-san: EVENT 4 llu 4294895911 slave eth2
>bond-san: link status up for interface eth2, enabling it in 500 ms
>bond-san: invalid new link 3 on slave eth2
>bond-san: link status definitely up for interface eth2, 10000 Mbps full duplex
>Second:
>bond-san: EVENT 1 llu 4295147594 slave eth2
>8021q: adding VLAN 0 to HW filter on device eth2
>mlx4_en: eth2: Link Up
>bond-san: EVENT 4 llu 4295147594 slave eth2
>bond-san: link status up again after 0 ms for interface eth2
>bond-san: link status definitely up for interface eth2, 10000 Mbps full duplex
>
>These messages (especially "invalid new link") look a bit unclear from
>sysadmin point of view.

	The "invalid new link" is appearing because bond_miimon_commit
is being asked to commit a new state that isn't UP or DOWN (3 is
BOND_LINK_BACK).  I looked through the patched code today, and I don't
see a way to get to that message with the new link set to 3, so I'll add
some instrumentation and send out another patch to figure out what's
going on, as that shouldn't happen.

	I don't see the "invalid" message testing locally, I think
because my network device doesn't transition to carrier up as quickly as
yours.  I thought you were getting BOND_LINK_BACK passed through from
bond_enslave (which calls bond_set_slave_link_state, which will set
link_new_link to BOND_LINK_BACK and leave it there), but the
link_new_link is reset first thing in bond_miimon_inspect, so I'm not
sure how it gets into bond_miimon_commit (I'm thinking perhaps a
concurrent commit triggered by another slave, which then picks up this
proposed link state change by happenstance).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
