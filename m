Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD06D23F530
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 01:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHGXV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 19:21:56 -0400
Received: from agw3.byu.edu ([128.187.16.187]:37038 "EHLO agw3.byu.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgHGXV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 19:21:56 -0400
Received: from cangw2.byu.edu (cangw2.byu.edu [10.18.21.142])
        by agw3.byu.edu (Postfix) with ESMTPS id 020131EF06;
        Fri,  7 Aug 2020 17:21:55 -0600 (MDT)
Received: from mail2.fsl.byu.edu (mail2.rc.byu.edu [128.187.49.32])
        by cangw2.byu.edu (8.15.2/8.15.2/Debian-8) with ESMTPS id 077NLpSW014780
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 7 Aug 2020 17:21:52 -0600
Received: from [192.168.124.133] (v-pool-133.rc.byu.edu [192.168.124.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.fsl.byu.edu (Postfix) with ESMTPSA id 9352E3F2D9;
        Fri,  7 Aug 2020 17:21:51 -0600 (MDT)
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
To:     Scott Dial <scott@scottdial.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, davem@davemloft.net, sd@queasysnail.net
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
From:   Ryan Cox <ryan_cox@byu.edu>
Message-ID: <57885356-da3a-aef9-64b4-84eb126f216c@byu.edu>
Date:   Fri, 7 Aug 2020 17:21:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Bayes-Prob: 0.0001 (Score -1, tokens from: Outbound, byu-edu:default, base:default, @@RPTN)
X-Spam-Score: -1.00 () [Hold at 5.00] Bayes(0.0001:-1.0)
X-CanIt-Geo: ip=128.187.49.32; country=US; region=Utah; city=Provo; latitude=40.2329; longitude=-111.6688; http://maps.google.com/maps?q=40.2329,-111.6688&z=6
X-CanItPRO-Stream: byu-edu:Outbound (inherits from byu-edu:default,base:default)
X-Canit-Stats-ID: 093cLlP7n - d30eb6a69564 - 20200807
X-Scanned-By: CanIt (www . roaringpenguin . com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/20 9:48 PM, Scott Dial wrote:
> The aes-aesni driver is smart enough to use the FPU if it's not busy and
> fallback to the CPU otherwise. Unfortunately, the ghash-clmulni driver
> does not have that kind of logic in it and only provides an async version,
> so we are forced to use the ghash-generic implementation, which is a pure
> CPU implementation. The ideal would be for aesni_intel to provide a
> synchronous version of gcm(aes) that fell back to the CPU if the FPU is
> busy.

I don't know how the AES-NI support works, but I did see your specific 
mention of aesni_intel and figured I should mention that this does also 
affect AMD. I just got access to AMD nodes (2 x EPYC 7302) with a 
Mellanox 10 GbE NIC.  I did the same test and it had a similar 
performance pattern.  I doubt this means much but I figured I should 
mention it.

> I don't know if the crypto maintainers would be open to such a change, but
> if the choice was between reverting and patching the crypto code, then I
> would work on patching the crypto code.

I can't opine on anything crypto-related since it is extremely way 
outside of my area of expertise, though it is helpful to hear what is 
going on.

> In any case, you didn't report how many packets arrived out of order, which
> was the issue being addressed by my change. It would be helpful to get
> the output of "ip -s macsec show" and specifically the InPktsDelayed
> counter. Did iperf3 report out-of-order packets with the patch reverted?
> Otherwise, if this is the only process running on your test servers,
> then you may not be generating any contention for the FPU, which is the
> source of the out-of-order issue. Maybe you could run prime95 to busy
> the FPU to see the issue that I was seeing.

I ran some tests again on the same servers as before with the Intel 
NICs.  I tested with prime95 running on 27 of the 28 cores in *each* 
server simultaneously (allowing iperf3 to use a core on each) throughout 
the entire test.  This was using 5.7.11 with 
ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, so pre-5.7 performance.

MACsec interfaces are deleted and recreated before each test, so 
counters are always fresh.

== MACSEC WITHOUT ENCRYPTION ==

* Server1:
18: ms1: protect on validate strict sc off sa off encrypt off send_sci 
on end_station off scb off replay off
     cipher suite: GCM-AES-128, using ICV length 16
     TXSC: 0000000000001234 on SA 0
     stats: OutPktsUntagged InPktsUntagged OutPktsTooLong InPktsNoTag 
InPktsBadTag InPktsUnknownSCI InPktsNoSCI InPktsOverrun
                          0              0              0 
1123            0                0           1             0
     stats: OutPktsProtected OutPktsEncrypted OutOctetsProtected 
OutOctetsEncrypted
                     3798421                0 30889802591                  0
         0: PN 3799655, state on, key 01000000000000000000000000000000
     stats: OutPktsProtected OutPktsEncrypted
                     3798421                0
     RXSC: 0000000000001234, state on
     stats: InOctetsValidated InOctetsDecrypted InPktsUnchecked 
InPktsDelayed InPktsOK InPktsInvalid InPktsLate InPktsNotValid 
InPktsNotUsingSA InPktsUnusedSA
                  30042694872                 0 0           218  
3675170             0          0 0                0              0
         0: PN 3676633, state on, key 01000000000000000000000000000000
     stats: InPktsOK InPktsInvalid InPktsNotValid InPktsNotUsingSA 
InPktsUnusedSA
             3675170             0              0 0              0

*Server2:
18: ms1: protect on validate strict sc off sa off encrypt off send_sci 
on end_station off scb off replay off
     cipher suite: GCM-AES-128, using ICV length 16
     TXSC: 0000000000001234 on SA 0
     stats: OutPktsUntagged InPktsUntagged OutPktsTooLong InPktsNoTag 
InPktsBadTag InPktsUnknownSCI InPktsNoSCI InPktsOverrun
                          0              0              0 
1227            0                0           1             0
     stats: OutPktsProtected OutPktsEncrypted OutOctetsProtected 
OutOctetsEncrypted
                     3675399                0 30042696158                  0
         0: PN 3676633, state on, key 01000000000000000000000000000000
     stats: OutPktsProtected OutPktsEncrypted
                     3675399                0
     RXSC: 0000000000001234, state on
     stats: InOctetsValidated InOctetsDecrypted InPktsUnchecked 
InPktsDelayed InPktsOK InPktsInvalid InPktsLate InPktsNotValid 
InPktsNotUsingSA InPktsUnusedSA
                  30889801305                 0 0             0  
3798410             0          0 0                0              0
         0: PN 3799655, state on, key 01000000000000000000000000000000
     stats: InPktsOK InPktsInvalid InPktsNotValid InPktsNotUsingSA 
InPktsUnusedSA
             3798410             0              0 0              0


InPktsDelayed was 218 for Server1 and 0 for Server2.

== MACSEC WITH ENCRYPTION ==

I got the following *with* encryption (macsec interface deleted and 
recreated before the test, so counters are fresh):
*Server1:
19: ms1: protect on validate strict sc off sa off encrypt on send_sci on 
end_station off scb off replay off
     cipher suite: GCM-AES-128, using ICV length 16
     TXSC: 0000000000001234 on SA 0
     stats: OutPktsUntagged InPktsUntagged OutPktsTooLong InPktsNoTag 
InPktsBadTag InPktsUnknownSCI InPktsNoSCI InPktsOverrun
                          0              0              0 
1397            0                0           0             0
     stats: OutPktsProtected OutPktsEncrypted OutOctetsProtected 
OutOctetsEncrypted
                           0          5560714 0        46931594623
         0: PN 5561948, state on, key 01000000000000000000000000000000
     stats: OutPktsProtected OutPktsEncrypted
                           0          5560714
     RXSC: 0000000000001234, state on
     stats: InOctetsValidated InOctetsDecrypted InPktsUnchecked 
InPktsDelayed InPktsOK InPktsInvalid InPktsLate InPktsNotValid 
InPktsNotUsingSA InPktsUnusedSA
                            0       45977049585 0          3771  
5417843             0          0 0                0              0
         0: PN 5422860, state on, key 01000000000000000000000000000000
     stats: InPktsOK InPktsInvalid InPktsNotValid InPktsNotUsingSA 
InPktsUnusedSA
             5417843             0              0 0              0

*Server2:
19: ms1: protect on validate strict sc off sa off encrypt on send_sci on 
end_station off scb off replay off
     cipher suite: GCM-AES-128, using ICV length 16
     TXSC: 0000000000001234 on SA 0
     stats: OutPktsUntagged InPktsUntagged OutPktsTooLong InPktsNoTag 
InPktsBadTag InPktsUnknownSCI InPktsNoSCI InPktsOverrun
                          0              0              0 
1490            0                0           0             0
     stats: OutPktsProtected OutPktsEncrypted OutOctetsProtected 
OutOctetsEncrypted
                           0          5421626 0        45977059885
         0: PN 5422860, state on, key 01000000000000000000000000000000
     stats: OutPktsProtected OutPktsEncrypted
                           0          5421626
     RXSC: 0000000000001234, state on
     stats: InOctetsValidated InOctetsDecrypted InPktsUnchecked 
InPktsDelayed InPktsOK InPktsInvalid InPktsLate InPktsNotValid 
InPktsNotUsingSA InPktsUnusedSA
                            0       46931106683 0           109  
5560541             0          0 0                0              0
         0: PN 5561948, state on, key 01000000000000000000000000000000
     stats: InPktsOK InPktsInvalid InPktsNotValid InPktsNotUsingSA 
InPktsUnusedSA
             5560541             0              0 0              0


InPktsDelayed was 3771 for Server1 and 109 for Server2.


The performance numbers were:
* 9.87 Gb/s without macsec
* 6.00 Gb/s with macsec WITHOUT encryption
* 9.19 Gb/s with macsec WITH encryption

iperf3 retransmits were:
* 27 without macsec
* 1211 with macsec WITHOUT encryption
* 721 with macsec WITH encryption


Thanks for the reply and for the background on this.

Ryan
