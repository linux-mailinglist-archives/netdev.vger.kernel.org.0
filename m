Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C890134
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfHPMRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:17:42 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:48732 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfHPMRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:17:42 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 08:17:40 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id CACC9100137;
        Fri, 16 Aug 2019 14:09:11 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id A2FD546B;
        Fri, 16 Aug 2019 14:09:11 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.21.26)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id D501E2EB;
        Fri, 16 Aug 2019 14:09:09 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: r8169: Performance regression and latency instability
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, hkallweit1@gmail.com
Message-ID: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
Date:   Fri, 16 Aug 2019 14:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!

During migration from kernel 3.14 to 4.19, we noticed a regression on 
the network performance. Under the exact same circumstances, the 
standard deviation of the latency is more than double than before on the 
Realtek RTL8111/8168B (10ec:8168) using the r8169 driver.

Kernel 3.14:
     # netperf -v 2 -P 0 -H <netserver-IP>,4 -I 99,5 -t omni -l 1 -- -O 
STDDEV_LATENCY -m 64K -d Send
     313.37

Kernel 4.19:
     # netperf -v 2 -P 0 -H <netserver-IP>,4 -I 99,5 -t omni -l 1 -- -O 
STDDEV_LATENCY -m 64K -d Send
     632.96

In contrast, we noticed small improvements in performance with other 
non-Realtek network cards (igb, tg3). Which suggested a possible driver 
related bug.

However after bisecting the code, I ended up with the following patch, 
which was introduced in kernel 4.17 and modifies net/ipv4:

     commit 0a6b2a1dc2a2105f178255fe495eb914b09cb37a
     Author: Eric Dumazet <edumazet@google.com>
     Date:   Mon Feb 19 11:56:47 2018 -0800

         tcp: switch to GSO being always on

Could you please help me to clarify, should GSO be always on on my 
device? Or does it just affect TCP? According to ethtool it is always 
off, "ethtool -K eth0 gso on" has no effect, unless I switch SG on.

     # ethtool -k eth0
     Offload parameters for eth0:
     Cannot get device udp large send offload settings: Operation not 
supported
     rx-checksumming: on
     tx-checksumming: off
     scatter-gather: off
     tcp-segmentation-offload: off
     udp-fragmentation-offload: off
     generic-segmentation-offload: off
     generic-receive-offload: on
     large-receive-offload: off

I validated that reverting "tcp: switch to GSO being always on" 
successfully brings back the better performance for the r8169 driver.

I'm sure that reverting that commit is not the optimal solution, so I 
would like to kindly ask for help to shed some light in this issue.

Best regards,
Juliana.
