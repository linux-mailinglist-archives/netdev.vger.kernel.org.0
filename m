Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2477361FE1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfGHNzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:55:44 -0400
Received: from mx-relay64-hz1.antispameurope.com ([94.100.133.232]:39163 "EHLO
        mx-relay64-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfGHNzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:55:44 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay64-hz1.antispameurope.com;
 Mon, 08 Jul 2019 15:55:24 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Mon, 8 Jul
 2019 15:55:21 +0200
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
 <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
 <20190705143647.GC4428@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <5e35a41c-be0e-efd4-cb69-cf5c860b872e@eks-engel.de>
Date:   Mon, 8 Jul 2019 15:55:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705143647.GC4428@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay64-hz1.antispameurope.com with 225D65604D1
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think you are going to have to parse the register writes/reads to
> figure out what switch registers it is accessing. That should
> hopefully make it clearer why it is making so many accesses.

Hi Andrew,
I got it working a little bit better. When I'm fast enough I can read
the registers I want but it isn't a solution.

Here is an output of the tracing even with my custom accesses.
mii -i 2 0 0x9b60; mii -i 2 1
phyid:2, reg:0x01 -> 0xc801

Do you know how to delete EEInt bit? It is always one. And now all 
accesses coming from the kworker thread. Maybe this is your polling 
function?

I view the INT pin on an oscilloscope but it never changed. So maybe
this is the problem. We just soldered a pull-up to that pin but it 
still never changend. Maybe you have an idea?

So what I think is, because of the EEInt bit is never set back to one 
i will poll it as fast as possible.

root@DistroKit:~ cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 568/568   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     kworker/0:2-106   [000] ....   209.532531: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   209.532649: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   209.532741: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.532835: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   209.532937: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.533027: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.533632: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   209.533765: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.533875: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.534470: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   209.534603: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.534695: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.535296: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.535429: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.535529: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   209.536129: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.536266: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.536364: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   209.536955: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.537097: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.537194: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.537355: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.537487: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   209.537608: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.537739: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   209.537890: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   209.540203: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.540323: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   209.540469: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   209.540568: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   209.540666: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   209.540768: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   210.491498: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   210.491619: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   210.491762: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   210.491860: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   210.491953: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.492052: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   210.492146: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.492244: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.492332: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   210.493008: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.493160: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.493252: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   210.493342: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.494000: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.494137: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.494236: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.494914: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   210.495050: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.495156: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.495823: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   210.495958: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.496052: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.496646: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.496781: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.496876: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   210.497466: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.497615: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   210.497715: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   210.497870: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.498433: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   210.498582: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   210.498843: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   210.498948: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   210.499519: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   210.572569: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   210.572687: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   210.572790: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.572884: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   210.573502: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.573653: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.573747: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   210.573844: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.574447: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.574585: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   210.574682: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.575275: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.575412: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.575514: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.576103: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   210.576242: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.576346: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.576502: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   210.576596: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.576723: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.576850: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.576978: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.577073: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   210.577201: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.577328: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   210.577452: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   210.577651: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.577780: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   210.580149: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   210.580261: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   210.580365: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   210.580509: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
             mii-387   [000] ....   210.646652: mdio_access: 2188000.ethernet-1 write phy:0x22 reg:0x00 val:0x9b60
             mii-388   [000] ....   210.659304: mdio_access: 2188000.ethernet-1 read  phy:0x22 reg:0x01 val:0xc801
     kworker/0:2-106   [000] ....   211.531394: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   211.531526: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   211.531725: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
     kworker/0:2-106   [000] ....   211.531835: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   211.531936: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.532033: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   211.532131: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.532223: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.532316: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   211.532486: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.532603: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.532707: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   211.532806: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.532902: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.532993: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.533683: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.533832: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   211.533939: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.534613: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.534754: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   211.535418: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.535550: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.535647: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.536398: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.536524: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   211.536629: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.537235: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   211.537373: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   211.537467: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.538068: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   211.538209: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   211.538310: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   211.538472: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   211.538564: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   211.612565: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   211.612685: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   211.612776: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.612876: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   211.612964: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.613580: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.613727: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   211.613829: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.613931: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.614531: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   211.614674: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.614768: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.615374: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.615505: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.615602: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   211.616194: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.616340: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.616444: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   211.616535: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.616696: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.616795: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.616925: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.617052: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   211.617176: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.617273: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   211.617398: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   211.617524: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.617649: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   211.617775: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   211.617959: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   211.620269: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   211.620379: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   212.571491: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   212.571624: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   212.571781: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   212.571886: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   212.571981: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.572079: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   212.572181: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.572272: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.572953: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   212.573091: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.573191: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.573859: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   212.573998: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.574097: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.574756: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.574899: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.575000: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   212.575658: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.575808: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.575909: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   212.576565: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.576699: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.576797: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.576890: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.576982: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   212.577567: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.577720: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   212.577823: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   212.577914: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.578071: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   212.578641: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   212.578876: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   212.578978: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   212.579074: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   212.652559: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   212.652682: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   212.652772: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.652871: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   212.652965: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.653054: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.653668: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   212.653803: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.653909: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.654511: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   212.654646: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.654745: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.655343: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.655485: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.655583: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   212.655746: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.655844: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.655981: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   212.656115: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.656245: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.656381: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.656514: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.656641: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   212.656767: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.656895: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   212.657018: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   212.657142: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.657339: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   212.657471: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   212.657595: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   212.657691: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   212.657869: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   213.611366: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   213.611493: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   213.611682: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   213.611798: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   213.611898: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.611990: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   213.612086: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.612179: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.612284: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   213.612385: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.612495: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.612591: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   213.612686: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.612791: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.612887: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.612982: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.613074: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   213.613165: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.613269: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.613362: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   213.613457: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.613549: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.613642: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.613733: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.613823: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   213.613922: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.614022: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   213.614116: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   213.614209: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.614299: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   213.614390: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   213.614482: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   213.614574: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   213.614667: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   213.692647: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   213.692763: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   213.692857: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.692956: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   213.693052: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.693137: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.693299: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   213.693441: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.693587: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.693728: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   213.693858: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.693988: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.694108: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.694231: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.694354: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   213.694473: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.694599: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.694723: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   213.694842: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.694963: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.695087: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.695211: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.695341: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   213.695464: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.695587: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   213.695679: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   213.695800: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.695928: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   213.696049: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   213.696169: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   213.696290: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   213.696414: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   214.651403: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   214.651531: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   214.651712: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   214.651815: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   214.651915: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.652014: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   214.652692: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.652840: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.652936: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   214.653030: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.653697: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.653831: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   214.653932: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.654596: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.654736: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.654836: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.655587: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   214.655715: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.655820: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.656492: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   214.656628: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.656723: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.657325: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.657462: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.657559: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   214.657711: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.658284: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   214.658425: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   214.658520: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.658682: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   214.658915: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   214.659011: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   214.659662: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   214.659802: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   214.732556: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   214.732681: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   214.732785: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.732882: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   214.732994: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.733089: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.733700: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   214.733841: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.733945: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.734539: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   214.734675: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.734842: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.734944: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.735080: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.735211: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   214.735341: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.735479: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.735613: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   214.735742: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.735871: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.735999: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.736123: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.736245: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   214.736363: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.736488: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   214.736611: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   214.736733: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.736859: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   214.736953: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   214.737074: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   214.737194: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   214.737313: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
             mii-389   [000] ....   214.750875: mdio_access: 2188000.ethernet-1 write phy:0x22 reg:0x00 val:0x9b60
             mii-390   [000] ....   214.759035: mdio_access: 2188000.ethernet-1 read  phy:0x22 reg:0x01 val:0xc801
             mii-391   [000] ....   215.302713: mdio_access: 2188000.ethernet-1 write phy:0x22 reg:0x00 val:0x9b60
             mii-392   [000] ....   215.315237: mdio_access: 2188000.ethernet-1 read  phy:0x22 reg:0x01 val:0xc801
     kworker/0:2-106   [000] ....   215.691372: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   215.691498: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   215.691688: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
     kworker/0:2-106   [000] ....   215.691794: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   215.691894: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.692061: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   215.692174: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.692270: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.692370: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   215.692465: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.692566: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.692658: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   215.693346: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.693481: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.693575: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.694168: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.694319: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   215.694422: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.695026: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.695158: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   215.695253: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.695344: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.695940: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.696074: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.696172: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   215.696775: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.696920: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   215.697017: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   215.697617: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.697752: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   215.697849: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   215.697943: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   215.698180: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   215.698865: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   215.772572: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   215.772693: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   215.772790: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.772891: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   215.772985: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.773078: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.773684: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   215.773818: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.773931: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.774524: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   215.774661: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.774752: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.775351: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.775483: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.775578: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   215.776174: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.776318: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.776417: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   215.776567: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.776704: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.776831: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.776971: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.777070: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   215.777199: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.777335: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   215.777469: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   215.777589: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.777707: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   215.777888: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   215.780209: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   215.780334: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   215.780433: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
             mii-393   [000] ....   215.855952: mdio_access: 2188000.ethernet-1 write phy:0x22 reg:0x00 val:0x9b60
             mii-394   [000] ....   215.867854: mdio_access: 2188000.ethernet-1 read  phy:0x22 reg:0x01 val:0xc801
     kworker/0:2-106   [000] ....   216.731386: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:2-106   [000] ....   216.731518: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:2-106   [000] ....   216.731706: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
     kworker/0:2-106   [000] ....   216.731808: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   216.731907: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.731999: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   216.732681: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.732829: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.732929: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   216.733598: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.733739: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.733835: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   216.734495: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.734633: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.734737: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.735400: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.735544: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   216.735645: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.736310: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.736443: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   216.736539: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.736633: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.737223: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.737355: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.737448: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   216.737610: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.737712: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   216.738280: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:2-106   [000] ....   216.738415: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.738508: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   216.738679: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:2-106   [000] ....   216.738867: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   216.738965: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:2-106   [000] ....   216.739532: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   216.812558: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   216.812673: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   216.812778: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.812874: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   216.812968: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.813583: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.813732: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   216.813835: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.814444: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.814574: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   216.814685: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.815288: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.815424: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.815526: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.816115: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   216.816258: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.816365: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.816958: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   216.817089: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.817184: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.817282: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.817437: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.817569: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   216.817694: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.817977: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   216.820294: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:1-14    [000] ....   216.820419: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.820565: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   216.820670: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:1-14    [000] ....   216.820761: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   216.820867: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:1-14    [000] ....   216.821018: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   217.771340: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x01 val:0x786d
     kworker/0:1-14    [000] ....   217.771464: mdio_access: 2188000.ethernet-1 read  phy:0x01 reg:0x05 val:0x0080
     kworker/0:1-14    [000] ....   217.771642: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:1-14    [000] ....   217.771744: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:1-14    [000] ....   217.771850: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.771959: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   217.772051: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.772149: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.772247: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:1-14    [000] ....   217.772337: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.772451: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.772546: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:1-14    [000] ....   217.772649: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.772749: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.772857: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.772958: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.773048: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:1-14    [000] ....   217.773135: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.773235: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.773925: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:1-14    [000] ....   217.774074: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.774171: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.774845: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.774981: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.775080: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:1-14    [000] ....   217.775739: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.775901: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:1-14    [000] ....   217.776010: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9921
     kworker/0:1-14    [000] ....   217.776669: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.776814: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:1-14    [000] ....   217.776918: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1921
     kworker/0:1-14    [000] ....   217.777513: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:1-14    [000] ....   217.777651: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9521
     kworker/0:1-14    [000] ....   217.778251: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   217.852560: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1521
     kworker/0:2-106   [000] ....   217.852675: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   217.852775: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.852869: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   217.852964: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.853577: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.853724: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   217.853823: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.854427: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.854565: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   217.854665: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.855252: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.855394: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.855494: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.856084: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   217.856218: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.856318: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.856480: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   217.856585: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.856717: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.856852: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.856943: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.857070: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   217.857196: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.857325: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541
     kworker/0:2-106   [000] ....   217.857449: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9941
     kworker/0:2-106   [000] ....   217.857573: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.857693: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x201e
     kworker/0:2-106   [000] ....   217.857874: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1941
     kworker/0:2-106   [000] ....   217.860193: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x01 val:0x203e
     kworker/0:2-106   [000] ....   217.860306: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9541
     kworker/0:2-106   [000] ....   217.860451: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1541


Cheers,
Benjamin

