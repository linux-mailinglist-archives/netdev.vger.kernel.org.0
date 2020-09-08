Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E06260FEB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgIHKch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:32:37 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17570 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgIHKc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 06:32:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f575d850000>; Tue, 08 Sep 2020 03:31:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 03:32:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 03:32:23 -0700
Received: from [172.27.14.146] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 10:32:05 +0000
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        <magnus.karlsson@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <intel-wired-lan@lists.osuosl.org>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <0257f769-0f43-a5b7-176d-7c5ff8eaac3a@intel.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <11f663ec-5ea7-926c-370d-0b67d3052583@nvidia.com>
Date:   Tue, 8 Sep 2020 13:32:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0257f769-0f43-a5b7-176d-7c5ff8eaac3a@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599561093; bh=v6mhnh0su9v5m+w8veFytksrof4F394OprHMwmmpBy0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=NweBCg0vQg3H++2Z9mv64cLVpasFCCTDtu3rKUeaYphHzYA/ZaXBqUay9cu53bakc
         7bp2KLXtttBBu1IdDHP0p8AKlzyP7XOfXhJiOi/Zr0SReXeWxliybu13hSXnu+j+oF
         mB/wBb8/VRqpQxDMBsn80JBtf5S5+A4no4pHXQ55B3Bh25QXRsfkhacGt0//RtUrz6
         u4csIH2CPa8+r3hG4RiUVtJ/Ye9mzX2dT4dIZEs3xd72WawnEVXFlCwM4dFlt9gLRa
         QW7PAuhpWkboTNJjEkLAkU1KWJsvvqEpDKv7S/IlB8jf9HqhCVwYjuGvuCLjANmXPM
         9MZfq3ywVe33Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 16:59, Bj=C3=B6rn T=C3=B6pel wrote:
> On 2020-09-04 15:53, Bj=C3=B6rn T=C3=B6pel wrote:
>> This series addresses a problem that arises when AF_XDP zero-copy is=20
>> enabled, and the kernel softirq Rx processing and userland process
>> is running on the same core.
>>
> [...]
>>
>=20
> @Maxim I'm not well versed in Mellanox drivers. Would this be relevant=20
> to mlx5 as well?

Thanks for letting me know about this series! So the basic idea is to=20
stop processing hardware completions if the RX ring gets full, because=20
the application didn't have chance to run? Yes, I think it's also=20
relevant to mlx5, the issue is not driver-specific, and a similar fix is=20
applicable. However, it may lead to completion queue overflows - some=20
analysis is needed to understand what happens then and how to handle it.

Regarding the feature, I think it should be opt-in (disabled by=20
default), because old applications may not wakeup RX after they process=20
packets in the RX ring. Is it required to change xdpsock accordingly?=20
Also, when need_wakeup is disabled, your driver implementation seems to=20
quit NAPI anyway, but it shouldn't happen, because no one will send a=20
wakeup.

Waiting until the RX ring fills up, then passing control to the=20
application and waiting until the hardware completion queue fills up,=20
and so on increases latency - the busy polling approach sounds more=20
legit here.

The behavior may be different depending on the driver implementation:

1. If you arm the completion queue and leave interrupts enabled on early=20
exit too, the application will soon be interrupted anyway and won't have=20
much time to process many packets, leading to app <-> NAPI ping-pong one=20
packet at a time, making NAPI inefficient.

2. If you don't arm the completion queue on early exit and wait for the=20
explicit wakeup from the application, it will easily overflow the=20
hardware completion queue, because we don't have a symmetric mechanism=20
to stop the application on imminent hardware queue overflow. It doesn't=20
feel correct and may be trickier to handle: if the application is too=20
slow, such drops should happen on driver/kernel level, not in hardware.

Which behavior is used in your drivers? Or am I missing some more options?

BTW, it should be better to pass control to the application before the=20
first dropped packet, not after it has been dropped.

Some workloads different from pure AF_XDP, for example, 50/50 AF_XDP and=20
XDP_TX may suffer from such behavior, so it's another point to make a=20
knob on the application layer to enable/disable it.

 From the driver API perspective, I would prefer to see a simpler API if=20
possible. The current API exposes things that the driver shouldn't know=20
(BPF map type), and requires XSK-specific handling. It would be better=20
if some specific error code returned from xdp_do_redirect was reserved=20
to mean "exit NAPI early if you support it". This way we wouldn't need=20
two new helpers, two xdp_do_redirect functions, and this approach would=20
be extensible to other non-XSK use cases without further changes in the=20
driver, and also the logic to opt-in the feature could be put inside the=20
kernel.

Thanks,
Max

>=20
> Cheers,
> Bj=C3=B6rn

