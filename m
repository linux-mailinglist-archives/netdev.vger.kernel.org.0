Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8DA200AC9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbgFSN44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:56:56 -0400
Received: from tk2.ibw.com.ni ([190.106.60.158]:53450 "EHLO tk2.ibw.com.ni"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgFSN4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 09:56:55 -0400
Received: from tk2.ibw.com.ni (localhost [127.0.0.1])
        by tk2.ibw.com.ni (Proxmox) with ESMTP id 047CF20E6C
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:56:52 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 japi.ibw.com.ni 983E11424CB7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibw.com.ni;
        s=B01EB49E-4102-11E9-ABBB-FDA7C1AECE99; t=1592575006;
        bh=VvlzMQWyRuuMw749uyo+SEc6kNI0QrMp9XFbsKCKiHk=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=GIowRbaLfR8hFrB1iNsRbjDzCGag5HyenVW83guutKU8LO1iSaecedOMAtCScMNTh
         OBeM6SRRkdrcAtqgVOwiM7U9sa5V1zcv9dQ0tE0enUEdhneWBfJ0QLQYF9pDqFoR5B
         ldAJ5ox1FbioBTUhcebnNudkQEpGm+AC08E5QPO9zVHvvuJJIL75aoT1QHw/AMA/fM
         Ykd9GFTD6dZ19SKeVU2ys6wR0R1wAgEuQxITJaZxDzZtWlLVgC2e1uxk0S2fvCij4s
         8cvh5qdNDFGMhP4DjCHtbaw+KpKe1UKTgC6AwpWCJwyeUhIBJAmAEoo/LF9xivjE9h
         hgShb7IOQH48A==
Subject: Re: RATE not being printed on tc -s class show dev XXXX
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <d33998c7-f529-e1d1-31a5-626aa8dd44da@ibw.com.ni>
 <CAM_iQpWa6KmiWv72YmB3ufR8Rw9RD9=PwLMamjOS6fSCM+zXbA@mail.gmail.com>
From:   "Roberto J. Blandino Cisneros" <roberto.blandino@ibw.com.ni>
Message-ID: <d746708a-f000-a6f7-d0d5-ab5905d080da@ibw.com.ni>
Date:   Fri, 19 Jun 2020 07:56:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWa6KmiWv72YmB3ufR8Rw9RD9=PwLMamjOS6fSCM+zXbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-NI
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My TC rules are as follow:

TC=3D"/usr/sbin/tc"
DEV=3D$1
ip=3D$2
MASTER1=3D"50000kbit"
RATE1=3D"1000kbit"
burst=3D"5k"
$TC qdisc add dev $DEV root handle 1: htb default 10
$TC class add dev $DEV parent 1: classid 1:1 htb rate ${MASTER1} ceil=20
${MASTER1} burst $burst
$TC class add dev $DEV parent 1:1 classid 1:10 htb rate ${RATE1} ceil=20
${RATE1} prio 3 burst $burst
$TC qdisc add dev $DEV parent 1:10 handle 10: sfq perturb 10
$TC filter add dev $DEV parent 1: protocol all prio 1 u32 match ip dst=20
$ip flowid 1:10
$TC filter add dev $DEV parent 1: protocol all prio 1 u32 match ip src=20
$ip flowid 1:10


El 18/6/20 a las 19:30, Cong Wang escribi=C3=B3:
>
> You either need to enable /sys/module/sch_htb/parameters/htb_rate_est
> or specify a rate estimator when you create your HTB class.
Does it need to be set on the "root handle"?
>
> Thanks.
>

