Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C363D486E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 21:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfJKT3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 15:29:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:32866 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfJKT3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 15:29:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9BJTLh6047140
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570822161;
        bh=5fhmCwZiHftan+NIjCnL6WxijnVapmo69AcIaLOMjQQ=;
        h=To:From:Subject:Date;
        b=HUDnm3w0fNsR9NLy0HTZIJDB75WUDsMdYHF7xWMzsYiU7EVA6poHAWSlBbHelt/T/
         Q/og5etd7aSYhzBIAV53UhccMIZj5AW5Ej41swJftkbwge0+Pj1gLeA3Fb/gmQgl8I
         lW35MvDdYL+lXDC0KkX5afonatpMNIRnSwyqZzP8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9BJTLqU013264
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:29:21 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 11
 Oct 2019 14:29:16 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 11 Oct 2019 14:29:16 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9BJTKqM015759
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:29:20 -0500
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Murali Karicheri <m-karicheri2@ti.com>
Subject: taprio testing - Any help?
Message-ID: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
Date:   Fri, 11 Oct 2019 15:35:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am testing the taprio (802.1Q Time Aware Shaper) as part of my
pre-work to implement taprio hw offload and test.

I was able to configure tap prio on my board and looking to do
some traffic test and wondering how to play with the tc command
to direct traffic to a specfic queue. For example I have setup
taprio to create 5 traffic classes as shows below;-

Now I plan to create iperf streams to pass through different
gates. Now how do I use tc filters to mark the packets to
go through these gates/queues? I heard about skbedit action
in tc filter to change the priority field of SKB to allow
the above mapping to happen. Any example that some one can
point me to?

Here is what I have tried so far.

tc qdisc replace dev eth0 parent root handle 100 taprio \
     num_tc 5 \
     map 0 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 \
     queues 1@0 1@1 1@2 1@3 1@4 \
     base-time 1564628923967325838 \
     sched-entry S 01 4000000 \
     sched-entry S 02 4000000 \
     sched-entry S 04 4000000 \
     sched-entry S 08 4000000 \
     sched-entry S 10 4000000 \
     clockid CLOCK_TAI

root@am57xx-evm:~# tc qdisc show  dev eth0 

qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2
queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 
1 offset 4 count 1
clockid TAI offload 0   base-time 1564628923967325838 cycle-time 
20000000 cycle-time-extension 0
         index 0 cmd S gatemask 0x1 interval 4000000
         index 1 cmd S gatemask 0x2 interval 4000000
         index 2 cmd S gatemask 0x4 interval 4000000
         index 3 cmd S gatemask 0x8 interval 4000000
         index 4 cmd S gatemask 0x10 interval 4000000

qdisc pfifo 0: parent 100:5 limit 1000p
qdisc pfifo 0: parent 100:4 limit 1000p
qdisc pfifo 0: parent 100:3 limit 1000p
qdisc pfifo 0: parent 100:2 limit 1000p
qdisc pfifo 0: parent 100:1 limit 1000p

Murali
