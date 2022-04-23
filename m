Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30E050CD5A
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiDWUOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 16:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiDWUOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 16:14:31 -0400
X-Greylist: delayed 552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Apr 2022 13:11:32 PDT
Received: from relais-inet.orange.com (relais-inet.orange.com [80.12.70.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0C3473B2
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 13:11:32 -0700 (PDT)
Received: from opfednr00.francetelecom.fr (unknown [xx.xx.xx.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfednr27.francetelecom.fr (ESMTP service) with ESMTPS id 4Km2HZ75cFz4whx
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 22:02:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1650744139;
        bh=9E77cgeDIyW54O11FaPS7uxHnsXHTBJ73UnWVjAY3Dw=;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type:
         Content-Transfer-Encoding;
        b=rAA1+8bTpzzb6rs6KzTUhYYxYBVevwzj7FGJ5e5a/qkMOXpG2T946IxhQEDnSqscC
         TJITpB6pU+hu+ByFztTI9oRdHiAKeqfOLnTZeDUe3fqdsCu6eoF/zPSLCNBi1z9ORa
         4UIrrTgX/6EfcmMa2qeYH/Swx0ps9hgRX+AoneIjKa+oMFzcf6ff/xZ5719JcwwFu8
         lCYxT2rCMNUt2PZqJm2CnqsV8Wca1VY/8icuYARU7mkd5jw6ai+WogeFoM21Yx9oaA
         PuuQFDRyq/l00neLElLU7IBZzt0O3RuQ9gFFb1u+Q0tZ7QnWh7x6u8rpCvmepq/I65
         5BfoLPciuTb3w==
Message-ID: <16469_1650744138_62645B4A_16469_436_1_4756cc37-340b-f2f6-e004-0d77573f33df@orange.com>
Date:   Sat, 23 Apr 2022 22:02:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   <alexandre.ferrieux@orange.com>
Subject: Zero-Day bug in VLAN offloading + cooked AF_PACKET
To:     <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.115.26.50]
X-ClientProxiedBy: OPE16NORMBX305.corporate.adroot.infra.ftgroup
 (10.115.27.10) To OPE16NORMBX107.corporate.adroot.infra.ftgroup (10.115.27.4)
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I know the subject sounds like this belongs in libpcap bug reports; indeed it 
started there [1]. However, after some digging, it really looks like there's an 
issue in what the kernel itself provides.

TL;DR: outgoing VLAN-tagged traffic to non-offloaded interfaces is captured as 
corrupted in cooked mode, and has been so since at least 3.4...

One popular way of doing captures with libpcap-based tools like tcpdump, is the 
so-called "cooked mode". This is what you get with "tcpdump -i any". The kernel 
API used for this, documented in packet(7), is a socket of family AF_PACKET and 
protocol level SOCK_DGRAM. Contrarily to SOCK_RAW, SOCK_DGRAM provides a kind of 
"near L3" abstraction, stripping most of the L2 headers from the original 
packets. For example, when using recvmsg(),

  - the .msg_iov (main payload) of the recvmsg() is the packet starting at the 
L3 header
  - the .msg_name (aka "address") is a sockaddr_ll structure containing some L2 
information: ethertype, source MAC address.
  - the .msg_control (aka metadata, activated with PACKET_AUXDATA sockopt) may 
contain VLAN information: TCI, TPID.

All this works beautifully most of the time, with or without VLAN tags, as the 
ethertype is correctly extracted and conveyed in the sockaddr_ll. This allows 
any consumer of the L3 frame to decode it properly, knowing exactly wich L3 it's 
looking at.

However, there's a catch: for outgoing packets, *if* the interface has no 
hardware VLAN offloading, the ethertype gets overwritten by ... the TPID 
(0x8100). As a result, a consumer of the L3 frame has absolutely no way to 
recover its type.

As a demo, here is what the venerable "tcpdump -i any" says of an outgoing ARP 
packet on VLAN interface eth0.24, after VLAN offloading has been disabled via 
"ethtool -K". Two lines are generated, as the packet is seen on both eth0.24 
(first line) and eth0 (second line):

  15:06:37.681328 ARP, Request who-has 1.0.24.3 tell 1.0.24.1, length 28
  15:06:37.681336 ethertype IPv4, IP0

The first line is correct, as the frame is captured before handling by the 8021q 
module. The second is not !!

This is the result of the ethertype being overwritten. The actual value is 
0x8100, which tcpdump decodes as a 802.1Q TPID, thus shifting the L3 beginning 
by 4 bytes, ending up seeing a nonsensical "IPv0" frame.

To prove that this is *not* an issue in libpcap or tcpdump, here are the three 
aforementioned pieces of the packet, gotten by a simple test program doing 
recvmsg() on an AF_PACKET+SOCK_DGRAM capture socket:

  On VLAN interface eth0.24: (the "^^^^" show the ethertype's position)
  --------------------------

   - metadata:     107:8:010000001c0000001c0000000000000000000000
   - sockaddr_ll:  1100080606000000010004060025903285a70000
                       ^^^^
   - L3 frame:     00010800060400010025903285a70100180100000000000001001803

  On parent interface eth0:
  -------------------------

   - metadata:     107:8:010000001c0000001c0000000000000000000000
   - sockaddr_ll:  1100810004000000010004060025903285a70000
                       ^^^^
   - L3 frame:     00010800060400010025903285a70100180100000000000001001803

As is clear above, the second instance contains no trace of the original ARP 
ethertype 0x0806.

By contrast, if we re-enable VLAN offloading,

    - the first instance (on subinterface) is unchanged
    - the second instance (on parent interface) is back to normal, with a 
correct ARP ethertype (^^^^=0806) *and* VLAN info in the metadata (TCI-TPID, 
byte-swapped =1800,0081):

  On parent interface eth0:
  -------------------------

   - metadata:     107:8:510000001c0000001c0000000000000018000081
                                                         TCI-TPID
   - sockaddr_ll:  1100080604000000010004060025903285a70000
                       ^^^^
   - L3 frame:     00010800060400010025903285a70100180100000000000001001803

And sure enough, tcpdump is happy again:

  21:44:18.481331 ARP, Request who-has 1.0.24.3 tell 1.0.24.1, length 28
  21:44:18.481338 ethertype ARP, ARP, Request who-has 1.0.24.3 tell 1.0.24.1, 
length 28

I have found this bug active on an old machine with kernel 3.4.
In the URL below you'll find more details on ftrace-based evidence, hinting at 
the 8021q module.
However, I am *not* familiar enough with the Linux network stack (and special 
cases like offloading) to suggest a fix, sorry.
I hope a knowledgeable person will consider this nasty enough to deserve their 
attention.

Thanks in advance !

-Alex


[1] https://github.com/the-tcpdump-group/libpcap/issues/1105

_________________________________________________________________________________________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confidentielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages electroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou falsifie. Merci.

This message and its attachments may contain confidential or privileged information that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and delete this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been modified, changed or falsified.
Thank you.

