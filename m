Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D177840FFBD
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbhIQT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:26:30 -0400
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:51567 "EHLO
        2.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhIQT03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:26:29 -0400
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2021 15:26:29 EDT
Received: from player734.ha.ovh.net (unknown [10.109.156.62])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 5DB6A21981A
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 20:09:15 +0200 (CEST)
Received: from RCM-web7.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player734.ha.ovh.net (Postfix) with ESMTPSA id D11E72215290D;
        Fri, 17 Sep 2021 18:09:07 +0000 (UTC)
MIME-Version: 1.0
Date:   Fri, 17 Sep 2021 20:09:07 +0200
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix array overrun in
 bcm_sf2_num_active_ports()
In-Reply-To: <20210916213336.1710044-1-f.fainelli@gmail.com>
References: <20210916213336.1710044-1-f.fainelli@gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <69b4ba48ff1278337048412d76574beb@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15693637330723711963
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgudduiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvffujghffgfkgihitgfgsehtkehjtddtreejnecuhfhrohhmpeftrghfrghlpgfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeejffdufffgjefgvdeigedukefffeevheejueeikeehudeiudehvdeifeduteehieenucfkpheptddrtddrtddrtddpudelgedrudekjedrjeegrddvfeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeefgedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrrghfrghlsehmihhlvggtkhhirdhplhdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-09-16 23:33, Florian Fainelli wrote:
> After d12e1c464988 ("net: dsa: b53: Set correct number of ports in the
> DSA struct") we stopped setting dsa_switch::num_ports to DSA_MAX_PORTS,
> which created an off by one error between the statically allocated
> bcm_sf2_priv::port_sts array (of size DSA_MAX_PORTS). When
> dsa_is_cpu_port() is used, we end-up accessing an out of bounds member
> and causing a NPD.
> 
> Fix this by iterating with the appropriate port count using
> ds->num_ports.
> 
> Fixes: d12e1c464988 ("net: dsa: b53: Set correct number of ports in
> the DSA struct")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Tested-by: Rafał Miłecki <rafal@milecki.pl>


This fixes:

[    0.515409] Unable to handle kernel read from unreadable memory at 
virtual address 0000000000000028
[    0.524659] Mem abort info:
[    0.527522]   ESR = 0x96000005
[    0.530656]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.536119]   SET = 0, FnV = 0
[    0.539262]   EA = 0, S1PTW = 0
[    0.542481] Data abort info:
[    0.545438]   ISV = 0, ISS = 0x00000005
[    0.549383]   CM = 0, WnR = 0
[    0.552427] [0000000000000028] user address but active_mm is swapper
[    0.558973] Internal error: Oops: 96000005 [#1] SMP
[    0.563986] Modules linked in:
[    0.567125] CPU: 1 PID: 24 Comm: kworker/1:1 Not tainted 5.10.64 #0
[    0.573573] Hardware name: Netgear R8000P (DT)
[    0.578155] Workqueue: events deferred_probe_work_func
[    0.583431] pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[    0.589617] pc : bcm_sf2_recalc_clock+0x58/0xe4
[    0.594271] lr : bcm_sf2_port_setup+0xc0/0x2ac
[    0.598840] sp : ffffffc0109bb980
[    0.602244] x29: ffffffc0109bb980 x28: ffffff801fef6f60
[    0.607710] x27: ffffff8001242b30 x26: 0000000000039040
[    0.613175] x25: 0000000000002380 x24: 0000000000000003
[    0.618641] x23: ffffff800125f880 x22: 0000000000000003
[    0.624107] x21: 0000000000000000 x20: 0000000000000000
[    0.629572] x19: ffffff8001398280 x18: 0000002437b29c0a
[    0.635039] x17: 00008cad14430a3a x16: 0000000000000008
[    0.640503] x15: 0000000000000000 x14: 6863746977732d74
[    0.645969] x13: 656e72656874652e x12: 3030303038303038
[    0.651435] x11: 0002001d00000000 x10: 6d726f6674616c70
[    0.656900] x9 : ffffff800125f880 x8 : ffffff8001398800
[    0.662366] x7 : ffffff80013989b8 x6 : 0000000000000001
[    0.667832] x5 : ffffff800125f97c x4 : ffffff8001242b30
[    0.673297] x3 : 0000000000000009 x2 : ffffff8001242b30
[    0.678763] x1 : 0000000000000000 x0 : ffffff8001398280
[    0.684230] Call trace:
[    0.686740]  bcm_sf2_recalc_clock+0x58/0xe4
