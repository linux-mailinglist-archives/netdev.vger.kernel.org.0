Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9FB5B5D8E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiILPnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiILPnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:43:45 -0400
Received: from smtp2.nicevt.ru (smtp2.nicevt.ru [82.97.198.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961E530565
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:43:44 -0700 (PDT)
X-Virus-Scanned: amavisd-new at zimbra.nicevt.local
Date:   Mon, 12 Sep 2022 19:43:14 +0400 (MSK)
From:   =?utf-8?B?0JLQsNGB0LjQu9C40Lkg0KPQvNGA0LjRhdC40L0=?= 
        <umrihin@nicevt.ru>
To:     netdev <netdev@vger.kernel.org>
Message-ID: <927100312.1863.1662997394065.JavaMail.zimbra@nicevt.ru>
Subject: RFH, is it possible to set ndo_start_xmit() cpu affinity in
 ethernet driver?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.1_GA_3056 (ZimbraWebClient - GC96 (Linux)/8.5.1_GA_3056)
Thread-Topic: RFH, is it possible to set ndo_start_xmit() cpu affinity in ethernet driver?
Thread-Index: jc0zj4Nxt84PCfonbi622av94aQZWQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

On the receiving side we have the opportunity to choose the CPU that will process the receive queue (RPS). 
On the sender side XPS selects the send queue for the given CPU, but there is no way to select the CPU on which ndo_start_xmit() will be launched.
Taskset is able to bind user task, but in ndo_start_xmit() binding differs.
In my case CPU0 reserved for polling kthread, because our NIC have no interrupts, therefore it is necessary. I need nothing else to run on this CPU. 

For example, setting CPU1 for RPS on both nodes:

host1: echo 0x2 > /sys/class/net//queues/rx-0/rps_cpus 
host2: echo 0x2 > /sys/class/net//queues/rx-0/rps_cpus 

Then run iperf on two nodes: 

host1: taskset -c 1 iperf -s 
host2: taskset -c 1 iperf -c host1 

After adding pr_info("cpu%d\n", smp_processor_id()); in my ndo_start_xmit() method, see in dmesg: 

host1: dmesg | grep cpu0 | wc -l
0 
host2: dmesg | grep cpu0 | wc -l
6512

Is it possible to choose the CPU on which ndo_start_xmit() will be launched on the sender side?

Kind regards, Vasiliy
