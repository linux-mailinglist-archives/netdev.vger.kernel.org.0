Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB123CFAF
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgHETXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgHERaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:30:06 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0724.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D266AC0086A0
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 07:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfwtB4PyI9FcrZAZMqpFyBgWAJRTG30R+S54vbrAri89ezgIo0shSzyKxB0vERCKP4z3NTjcssW5kDo2xTwUxDpx+0wuLa0MApDya202qm4iFlI5H/lnPEdSSaSk3ynxUW70XLnQX7ZEJ58cKJxSJ3Y5v2qu68/eJrcx5CDy73T955lfHN7pXO2HDmofmsCdqgtWaZHpoDJtob+VprvAC6k/Id4DRDDolplPRo5eTSgCl2222dxDgGuHNS5H8YaSixo8U4+sZg57Yz2bl0HT4hAs+da9dvQf4/wBoTjw3l0WGXtmK2GBCYSIvDqZRWmlLLq7kRjnZ/HO72ApXWKgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16h5wR6oPJ7gtXlA94dwyIEGqxLZO5ZJJiqliL5NGiA=;
 b=XIkv7KYGlxI7hAzVzLyxYO/GyFrcAWICXtaSeRO73znsA6xsRuTJi+VavF6HJDrzs7lHs0dHy7e8swZWbOiegwelhJlf+NLt28T9LbFZpWRq6xik8bG/tL/EVzXoqehNCuN6cjJz6fy752PxwVIYfgIeV4pbs+8Oir18+Jx/vZg9Mj4lRIkb7zFMF2+uCc/er1VB3vpUNNhbLbYgB8a5Ocs+R+5VfwlvHV9cm7ZfKt++bIZ4AtcRVKY9e+Nfudtk6qn+dWD2KupXKD5sP5GOvB8t06geYIyiff32+sRifUPdH5OUiPW6jNpZUjydw22gLlQtppTpRGmw/VzD0pT5SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16h5wR6oPJ7gtXlA94dwyIEGqxLZO5ZJJiqliL5NGiA=;
 b=OnMp9qFXWY/D8yPFht+qJr18FIVIPQSlymkDJ1vSjZi3q/J0MmrGUyCYFnssRwW9Mf1uW0J0Ez8DdANDUVN+JuXFmArpXRJkb95stPKbgGadv89aCTjtNQIsflt7svYnpf1i1TQjG4j/l1vxgzGDBGTgnG8ElBLTsdwuBpDHhbA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:4b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Wed, 5 Aug
 2020 14:25:25 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3261.018; Wed, 5 Aug 2020
 14:25:25 +0000
To:     Network Development <netdev@vger.kernel.org>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: rtnl_trylock() versus SCHED_FIFO lockup
Message-ID: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
Date:   Wed, 5 Aug 2020 16:25:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0142.eurprd07.prod.outlook.com
 (2603:10a6:207:8::28) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM3PR07CA0142.eurprd07.prod.outlook.com (2603:10a6:207:8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Wed, 5 Aug 2020 14:25:25 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a2a248a-e66f-4d71-eb6c-08d8394b64f4
X-MS-TrafficTypeDiagnostic: AM0PR10MB2113:
X-Microsoft-Antispam-PRVS: <AM0PR10MB211361CCE19B608D800287A6934B0@AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TrvbbJS5HeGcYjc0qI1co+c0i5HbrIaiE11eMNre0z1JYLeV4s4ApDMURAe/Q2iFrfVYoXRy9uLb7dHEiDY6o81XTdItEoKFANQxsZddFASVyel6U26zE1y8p3ydssw/fs2A4f5sYZhIbYrOjpaNPWGmcsy4WzQQxxVaPgPwqYI5XPEpnZtAjqtEeFmbi9j7hlhayX8iCTDR48jFTWQmsQyNm0ewA0U1S4Rx8u9nabQtS5EW1vBfzbvfjfEFfUFmGrxVzMmu+9ynKMfnX7dKsdLdXgLtKX73OkeD8kJn7ZxLfdFdvxsR2vO1yZzV6g/jeOr2GD+HUfQGVBEXTaOW3OxE2le+m8Mno70nuzLEX4OJCDxHq78Pm53O08n2vHTR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(346002)(136003)(376002)(39840400004)(36756003)(5660300002)(2616005)(956004)(83380400001)(316002)(16526019)(86362001)(31686004)(16576012)(31696002)(44832011)(52116002)(26005)(186003)(66946007)(66556008)(6916009)(6486002)(508600001)(8676002)(8936002)(8976002)(2906002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: e5I60iB38kPO0einfTmXyGPeCZnvd6oVjVPzkuGNujK5mIUOVO2CcVdT5CT05hEM8RXMiWrfG/DR+mClpXbOHCiSKLayYcZRB2TqP0BXfw2KzuzYpp6eiRpeSBu5WIfntCkLPl7tekDBvIBTwXQhXsdA8vLgHCSwBQ3Swz2Twa5/+VTz4wTeC1r3ewZy4IvG4x9dEwoz+QRgJpTEYxcV9nv9pWhXqInO7BGAmxMQqfvl754ZhinQc+6qeMqec7yg3mSMU6fGxazOEUpNUJqyXsZMmZ9OfSyp1DTZujHOPFty+3vXOESLIeN7H/d0pgPKSN36ejljVkgZWEzWekKE+mNjI/Hp8fyxibb9yl1SakiIQBXNan2pwCVV4kT59Iy2IHxfG9gvRHtTe5jNeO15RqE2ehgn2QbrB0TlCZKj/cwmVA4npouvXm9E99GUFYc/5YML8Gn0RkghxxTlFFK+5ne2f+m1UQyc8he2d49XifDTWVIz4yWQ5x6vQ6BWlyG6m52WHEFy/AzATd9rObDCkjA4CUvVLfi03Rh49iMLOjsYL8sjPSmoqAn6GXzT8R6oGwOJxgZv0g5LkCj3sBLQ5Nt65SlemP6NdgxerHuPDSmIzWSr5QIYQ2/vJGt0n5My3tciQd8BvPkAf5arWu9lzg==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2a248a-e66f-4d71-eb6c-08d8394b64f4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 14:25:25.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TG3idoGphUtiHeXJvIAb/8T11Fhe+g3o93+plkPoHjEk9h+0u4l3uV9d3oU+/4tqVugN+noFudolDg9VRfSjFkAiOa25yTrTplgXK30Uajk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We're seeing occasional lockups on an embedded board (running an -rt
kernel), which I believe I've tracked down to the

            if (!rtnl_trylock())
                    return restart_syscall();

in net/bridge/br_sysfs_br.c. The problem is that some SCHED_FIFO task
writes a "1" to the /sys/class/net/foo/bridge/flush file, while some
lower-priority SCHED_FIFO task happens to hold rtnl_lock(). When that
happens, the higher-priority task is stuck in an eternal ERESTARTNOINTR
loop, and the lower-priority task never gets runtime and thus cannot
release the lock.

I've written a script that rather quickly reproduces this both on our
target and my desktop machine (pinning everything on one CPU to emulate
the uni-processor board), see below. Also, with this hacky patch

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 0318a69888d4..df8078c023d2 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -36,6 +36,7 @@ static ssize_t store_bridge_parm(struct device *d,
        char *endp;
        unsigned long val;
        int err;
+       static unsigned int restarts;

        if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
                return -EPERM;
@@ -44,8 +45,14 @@ static ssize_t store_bridge_parm(struct device *d,
        if (endp == buf)
                return -EINVAL;

-       if (!rtnl_trylock())
-               return restart_syscall();
+       if (!rtnl_trylock()) {
+               restarts++;
+               if (restarts < 100)
+                       return restart_syscall();
+               pr_err("too many restarts, doing unconditional
rtnl_lock()\n");
+               rtnl_lock();
+       }
+       restarts = 0;

        err = (*set)(br, val);
        if (!err)

priority inheritance kicks in and boosts the lower-prio thread so the
lockup doesn't happen. But I'm failing to come up with a proper solution.

Thoughts?

Thanks,
Rasmus

Reproducer:

#!/bin/bash

dev=br-test

flusher() {
    # $$ doesn't work as expected in subshells
    read -r pid _ < /proc/self/stat
    echo "flusher: PID $pid"
    chrt -f -p 20 $pid
    while true ; do
        echo 1 > /sys/class/net/${dev}/bridge/flush
        sleep .15
    done
    exit 0
}

worker() {
    read -r pid _ < /proc/self/stat
    echo "worker: PID $pid"
    chrt -f -p 10 $pid
    while true ; do
        read -n 1 -u 12
        ip addr add 200.201.202.203/24 dev ${dev}
        ip addr del 200.201.202.203/24 dev ${dev}
        echo -n . >&21
    done
    exit 0
}

taskset -p 1 $$
chrt -f -p 30 $$

tmpdir=$(mktemp -d)
mkfifo ${tmpdir}/a
mkfifo ${tmpdir}/b

exec 12<> ${tmpdir}/a
exec 21<> ${tmpdir}/b

ip link add name $dev type bridge

( flusher ) &
flusher_pid=$!
( worker ) &
worker_pid=$!

sleep .1
printf '\n'

count=0
while ! [ -e /tmp/stop ] && [ $count -lt 1000 ]; do
    echo -n . >&12
    read -n 1 -u 21 -t 10
    if [ $? -gt 0 ] ; then
        printf '\nlockup?!\n'
        sleep 20
        break
    fi
    count=$((count+1))
    printf '\r%4d' $count
    sleep .02
done

kill $flusher_pid
kill $worker_pid

wait

rm -rf $tmpdir
ip link del $dev type bridge


