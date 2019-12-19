Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4FD1267EE
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLSRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:23:31 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59932 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:23:30 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBJHNOd9087725;
        Thu, 19 Dec 2019 11:23:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576776204;
        bh=4srQ/0uAnN+hYZObGD7gQKkd7uIuFLnNmTORzgKRcCc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=daWxkDnFFF56ChFGUZ3fYXv56vJ7c+f8eC/M847gMe3UyJKcYu6Fio4AkQvSbIWkJ
         yD9hCZyEJKe4nObnILHOZ19TZdpkGjjqBTvLsT9nl9ShREvpfCh5Gs3ffX67gMUxjQ
         Eh8Ov7RcYjA2itEcgyGNSz/kWFLuXxPksU9eRK2c=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBJHNO5S013837
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Dec 2019 11:23:24 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Dec 2019 11:23:22 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Dec 2019 11:23:23 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBJHNMmw033028;
        Thu, 19 Dec 2019 11:23:22 -0600
Subject: Re: RSTP with switchdev question
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "Kwok, WingMan" <w-kwok2@ti.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>
References: <c234beeb-5511-f33c-1232-638e9c9a3ac2@ti.com>
 <7ca19413-1ac5-946c-c4d0-3d9d5d88e634@ti.com>
 <20191217112122.GB17965@lunn.ch>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <93982e05-e15b-7589-de38-ea64a87580fd@ti.com>
Date:   Thu, 19 Dec 2019 12:30:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20191217112122.GB17965@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for responding to this.

On 12/17/2019 06:21 AM, Andrew Lunn wrote:
> On Mon, Dec 16, 2019 at 11:55:05AM -0500, Murali Karicheri wrote:
>> + switchdev/DSA experts
> 
> Hi Murali
> 
> I did not reply before because this is a pure switchdev issue. DSA
> does things differently. The kernel FDB and the switches FDB are not
> kept in sync. With DSA, when a port changes state, we flush the switch
> FDB. For STP, that seems to be sufficient. There have been reports for
> RSTP this might not be enough, but that conversation did not go very
> far.
I am new to RSTP and trying to understand what is required to be done
at the driver level when switchdev is used.

Looks like topology changes are handled currectly when only Linux bridge
is used and L2 forwarding is not offloaded to switch (Plain Ethernet
interface underneath).

This is my understanding. Linux bridge code uses BR_USER_STP to handle
user space  handling. So daemon manages the STP state machine and update
the STP  state to bridge which then get sent to device driver through
switchdev SET attribute command in the same way as kernel STP. From the
RSTP point of view, AFAIK, the quick data path switch over happens by
purging and re-learning when topology changes (TCN BPDUs). Currently
we are doing the following workaround which seems to solve the issue
based on the limited testing we had. Idea is for the switchdev based
switch driver to monitor the RTP state per port and if there is any
change in state, do a purge of learned MAC address in switch and send a
notification to bridge using
call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info);

Following transition to be monitored and purged on any port:-
  Blocking   -> Learning  (assuming blocking to forward doesn't happen
                directly)
  Blocking   -> Forward (Not sure if this is possible. Need to check the
                spec.
  Learning   -> Blocked
  Forwarding -> Blocked

Hope the above are correct. Do you know if DSA is checking the above
transitions? Also when the learned address are purged in the switch
hardware, send event notification to Linux bridge to sync up with it's
database.

Since this is required for all of the Switchdev supported drivers,
it make sense to move this to switchdev eventually to trigger purge at
switch as well as notification to bridge for purge its entries. What do 
you think?

Regards,

Murali

> 
> I've no idea how this is supposed to work with a pure switchdev
> driver. Often, to answer a question like this, you need to take a step
> backwards. How is this supposed to work for a machine with two e1000e
> cards and a plain software bridge? What ever APIs user space RSTP is
> using in a pure software case should be used in a switchdev setup as
> well, but extra plumbing in the kernel might be required, and it
> sounds like it may be missing...
> 
>        Andrew
> 

-- 
Murali Karicheri
Texas Instruments
