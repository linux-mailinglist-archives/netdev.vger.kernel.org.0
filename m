Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AB45B282C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 23:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIHVLn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Sep 2022 17:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiIHVLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 17:11:41 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Sep 2022 14:11:38 PDT
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96856AFAFC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 14:11:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 8DECB1410EC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:01:37 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id sIFsDWLPkuoT for <netdev@vger.kernel.org>;
        Thu,  8 Sep 2022 23:01:32 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 4A603140A17
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:01:32 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id EA72469985; Thu,  8 Sep 2022 23:01:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id E51E460094
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:01:31 +0200 (CEST)
Date:   Thu, 8 Sep 2022 23:01:31 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: RFH, where did I go wrong?
Message-ID: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

under high load, my homegrown qdisc causes a system crash,
but I’m a bit baffled at the message and location. Perhaps
anyone has directly an idea where I could have messed up?


Transcription of the most relevant info from the screen photo:

virt_to_cache: Object is not a Slab page!
… at mm/slab.h:435 kmem_cache_free+…

Call Trace:
__rtnl_unlock+0x34/0x40
netdev_run_todo+…
rtnetlink_rcv_msg
? _copy_to_iter
? __free_one_page
? rtnl_calcit.isra.0
netlink_rcv_skb
netlink_unicast
netlink_sendmsg
sock_sendmsg
____sys_sendmsg
[…]

The trace is followed by two…

BUG: Bad rss-counter state mm:0000000001b817b09
first one is type:MM_FILEPAGES val:81
second one is type:MM_ANONPAGES val:30


I guess I either messed up with pointers or locking, but I don’t
have the Linux kernel coding experience to know where to even start
looking for causes.

Source in question is…
https://github.com/tarent/sch_jens/blob/iproute2_5.10.0-4jens14/janz/sch_janz.c
… though I don’t exactly ask for someone to solve this for me (though
that would, obviously, also be welcome ☺) but to get to know enough
for me to figure out the bug.

I probably would start by adding lots of debugging printks, but the
problem occurs when throwing iperf with 40 Mbit/s on this set to limit
to 20 Mbit/s, which’d cause a lot of information — plus I don’t even
know what kind of error “Object is not a Slab page” is (i.e. what wrong
thing is passed where or written to where).

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
