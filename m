Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4FACF2E
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 16:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfIHONJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 10:13:09 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:40388 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIHONJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 10:13:09 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail02.iobjects.de (Postfix) with ESMTPSA id DBEDC416D0A6
        for <netdev@vger.kernel.org>; Sun,  8 Sep 2019 16:13:07 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 9BEDDF015F9
        for <netdev@vger.kernel.org>; Sun,  8 Sep 2019 16:13:07 +0200 (CEST)
To:     Netdev <netdev@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Default qdisc not correctly initialized with custom MTU
Organization: Applied Asynchrony, Inc.
Message-ID: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
Date:   Sun, 8 Sep 2019 16:13:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I just installed a better NIC (Aquantia 2.5/5/10Gb, apparently with
multiple queues) and now get the "mq" pseudo-qdisc automatically installed -
so far, so good. I also configure fq_codel as default qdisc via sysctls
and a larger MTU of 9000 for the device. This somehow leads to some
slight confusion about initialization order between the qdiscs and the
device.

Right after booting, where sysctl runs before eth0 setup:

$tc qd show
qdisc noqueue 0: dev lo root refcnt 2
qdisc mq 0: dev eth0 root
qdisc fq_codel 0: dev eth0 parent :8 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :7 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :6 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :5 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :4 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :3 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :2 limit 10240p flows 1024 quantum 1514 ...
qdisc fq_codel 0: dev eth0 parent :1 limit 10240p flows 1024 quantum 1514 ...

Note that fq_codel thinks the quantum (derived from the MTU) is still 1500;
it just used the default setting as there was no link yet.

Howwver, the MTU is set to 9000:

$ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP mode DEFAULT group default qlen 1000

It seems the default qdisc is created before the link is set up, and then
just attached to mq without consideration for the actual link configuration.
Simply kicking the whole thing to replace mq with itself again does the trick:

$tc qd replace root dev eth0 mq
$tc qd show
qdisc noqueue 0: dev lo root refcnt 2
qdisc mq 8001: dev eth0 root
qdisc fq_codel 0: dev eth0 parent 8001:8 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:7 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:6 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:5 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:4 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:3 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:2 limit 10240p flows 1024 quantum 9014 ...
qdisc fq_codel 0: dev eth0 parent 8001:1 limit 10240p flows 1024 quantum 9014 ...

Now the quanta are in line with the actual MTU.

I can't help but feel this is a slight bug in terms of initialization order,
and that the default qdisc should only be created when it's first being
used/attached to a link, not when the sysctls are configured.
Kernel is 5.2.x and I didn't see anything in 5.3 or net-next to address
this yet.

Thoughts?

Holger
