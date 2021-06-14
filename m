Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D793A6A97
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhFNPjp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 11:39:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57247 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbhFNPjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:39:15 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lsoe9-00085z-Vs; Mon, 14 Jun 2021 15:37:06 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id F15C55FBC4; Mon, 14 Jun 2021 08:37:03 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id EC06EA040B;
        Mon, 14 Jun 2021 08:37:03 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jussi Maki <joamaki@gmail.com>
cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next 0/3] XDP bonding support
In-reply-to: <CAHn8xckZAwozmRVLDUuPv-gFCy9AaBC-3cKZ4iU4enfkN5my-g@mail.gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com> <CAEf4Bzar4+HQ_0BBGt75_UPG-tVpjqz9YVdeBi2GVY1iam4Y2g@mail.gmail.com> <CAHn8xckZAwozmRVLDUuPv-gFCy9AaBC-3cKZ4iU4enfkN5my-g@mail.gmail.com>
Comments: In-reply-to Jussi Maki <joamaki@gmail.com>
   message dated "Mon, 14 Jun 2021 14:25:42 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6698.1623685023.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 14 Jun 2021 08:37:03 -0700
Message-ID: <6705.1623685023@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jussi Maki <joamaki@gmail.com> wrote:

>On Thu, Jun 10, 2021 at 7:24 PM Andrii Nakryiko
><andrii.nakryiko@gmail.com> wrote:
>>
>> On Wed, Jun 9, 2021 at 6:55 AM Jussi Maki <joamaki@gmail.com> wrote:
>> >
>> > This patchset introduces XDP support to the bonding driver.
>> >
>> > Patch 1 contains the implementation, including support for
>> > the recently introduced EXCLUDE_INGRESS. Patch 2 contains a
>> > performance fix to the roundrobin mode which switches rr_tx_counter
>> > to be per-cpu. Patch 3 contains the test suite for the implementation
>> > using a pair of veth devices.
>> >
>> > The vmtest.sh is modified to enable the bonding module and install
>> > modules. The config change should probably be done in the libbpf
>> > repository. Andrii: How would you like this done properly?
>>
>> I think vmtest.sh and CI setup doesn't support modules (not easily at
>> least). Can we just compile that driver in? Then you can submit a PR
>> against libbpf Github repo to adjust the config. We have also kernel
>> CI repo where we'll need to make this change.
>
>Unfortunately the mode and xmit_policy options of the bonding driver
>are module params, so it'll need to be a module so the different modes
>can be tested. I already modified vmtest.sh [1] to "make
>module_install" into the rootfs and enable the bonding module via
>scripts/config, but a cleaner approach would probably be to, as you
>suggested, update latest.config in libbpf repo and probably get the
>"modules_install" change into vmtest.sh separately (if you're happy
>with this approach). What do you think?

	The bonding mode and xmit_hash_policy (and any other option) can
be changed via "ip link"; no module parameter needed, e.g.,

ip link set dev bond0 type bond xmit_hash_policy layer2

	-J

>[1] https://lore.kernel.org/netdev/20210609135537.1460244-1-joamaki@gmail.com/T/#maaf15ecd6b7c3af764558589118a3c6213e0af81

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
