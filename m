Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C303FC57A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 12:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240910AbhHaKNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:13:11 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34319 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240907AbhHaKNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 06:13:10 -0400
Received: from [192.168.0.4] (ip5f5aeb24.dynamic.kabel-deutschland.de [95.90.235.36])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 830C661E64784;
        Tue, 31 Aug 2021 12:12:13 +0200 (CEST)
Subject: Re: Change in behavior for bound vs unbound sockets
To:     Saikrishna Arcot <sarcot@microsoft.com>,
        Mike Manning <mmanning@vyatta.att-mail.com>
References: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <06425eb5-906a-5805-d293-70d240a1197b@molgen.mpg.de>
Date:   Tue, 31 Aug 2021 12:12:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[cc: +maintainers and commit author and reviewers]

Dear Saikrishna,


Am 31.08.21 um 01:47 schrieb Saikrishna Arcot:

Thank you for bringing this issue, you found working on upgrading the 
Linux kernel in SONiC [1], up on the mailing list.

> When upgrading from 4.19.152 to 5.10.40, I noticed a change in
> behavior in how incoming UDP packets are assigned to sockets that are
> bound to an interface and a socket that is not bound to any
> interface. This affects the dhcrelay program in isc-dhcp, when it is
> compiled to use regular UDP sockets and not raw sockets.
> 
> For each interface it finds on the system (or is passed in via
> command-line), dhcrelay opens a UDP socket listening on port 67 and
> bound to that interface. Then, at the end, it opens a UDP socket also
> listening on port 67, but not bound to any interface (this socket is
> used for sending, mainly). It expects that for packets that arrived
> on an interface for which a bound socket is opened, it will arrive on
> that bound socket. This was true for 4.19.152, but on 5.10.40,
> packets arrive on the unbound socket only, and never on the bound
> socket. dhcrelay discards any packets that it sees on the unbound
> socket. Because of this, this application breaks.
> 
> I made a test application that creates two UDP sockets, binds one of
> them to the loopback interface, and has them both listen on 0.0.0.0
> with some random port. Then, it waits for a message on those two
> sockets, and prints out which socket it received a message on. With
> another application (such as nc) sending some UDP message, I can see
> that on 4.19.152, the test application gets the message on the bound
> socket consistently, whereas on 5.10.40, it gets the message on the
> unbound socket consistently. I have a dev machine running 5.4.0, and
> it gets the message on the unbound socket consistently as well.

It’d be great, if you shared your script.

> I traced it to one commit (6da5b0f027a8 "net: ensure unbound datagram
> socket to be chosen when not in a VRF") that makes sure that when not
> in a VRF, the unbound socket is chosen over the bound socket, if both
> are available. If I revert this commit and two other commits that
> made changes on top of this, I can see that packets get sent to the
> bound socket instead. There's similar commits made for TCP and raw
> sockets as well, as part of that patch series.

Commit 6da5b0f027a8 (net: ensure unbound datagram socket to be chosen 
when not in a VRF) was added to Linux 5.0.

> Is the intention of those commits also meant to affect sockets that
> are bound to just regular interfaces (and not only VRFs)? If so,
> since this change breaks a userspace application, is it possible to
> add a config that reverts to the old behavior, where bound sockets
> are preferred over unbound sockets?
If it breaks user space, the old behavior needs to be restored according 
to Linux’ no regression policy. Let’s hope, in the future, there is 
better testing infrastructure and such issues are noticed earlier.


Kind regards,

Paul


PS:

> --
> Saikrishna Arcot

Saikrishna, if you care, the standard signature delimiter has a trailing 
space.


[1]: https://github.com/Azure/sonic-linux-kernel/pull/227/
[2]: https://en.wikipedia.org/wiki/Signature_block#Standard_delimiter
