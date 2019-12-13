Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EF11ECAC
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLMVLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:11:17 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40742 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMVLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:11:16 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBDLBFM5083710
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:11:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576271475;
        bh=N0P1fYYCmxfGGAdb483IkpjnST0dDom0daWp32u43MA=;
        h=From:To:Subject:Date;
        b=qzA8KWcya0p0Yt2bbgW1HOd/bCYU5zIS47FWGiagxQqKxNg+p3Tp46yv9vnS9tVwX
         jDvHzxXuhC+zPg3OPawFETujeAs9c4gX+E2ngQlikTW9uhK7U+m8fqYQ4ElRCrOjJ9
         /4irKCB7aWrpnH1vXBnP6I592rkg+LDcCgadxGYY=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBDLBFdZ000874
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:11:15 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Dec 2019 15:11:15 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Dec 2019 15:11:15 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBDLBEvt109783;
        Fri, 13 Dec 2019 15:11:14 -0600
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <netdev@vger.kernel.org>, "Kwok, WingMan" <w-kwok2@ti.com>
Subject: RSTP with switchdev question
Message-ID: <c234beeb-5511-f33c-1232-638e9c9a3ac2@ti.com>
Date:   Fri, 13 Dec 2019 16:18:02 -0500
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

Hi Netdev experts,

We are working on a switchdev based switch driver with L2 and stp
offload.  Implemented the driver based on
Documentation/networking/switchdev.txt
Currently seeing an issue with switch over of a link failure. So
wondering how this is supposed to work. So any help on this will
be highy appreciated.


                   0     1
  |-------X---------- B ----------------------|
  A                                           C root
  |-------------------------------------------|

                  Figure 1)

At the start, A, B and C nodes are brought up and mstpd is started
on all nodes and we get a toplogy as above with X marking the link
that breaks the loop. We run a Ping from C to A and it works fine
and takes the direct path from C to A. We then simulate a link
failure to trigger topology change by disconnecting of the link
A to C. Switch over happens and the topology gets updated quickly
and we get the one below in Figure 2).

Case 2)
                   0     1
  |------------------ B ----------------------|
  A                                           C root
  |-------------------X-----------------------|
                 Figure 2)

The ping stops and resume after about 30 seconds instead of right
away as expected in rstp case which should be in milliseconds. On
debug we found following happening.

1) In the steady state, the fdb dump at the firmware on B (This
    implements the switch) shows that both A and C appears on port
    1 as expected.
2  After switch over, Ping frame from C with A's MAC address gets
    sent to B.  However B's fdb entry is still showing it is at
    port 1. Since the frame arrived from C, it drops the frame.

So the question is, in this scenario, how does the data path
restored quickly? Looks like for this to happen FDB at the nodes
needs to get flushed or re-learned so that it will show all nodes
at the correct port in the new topology. So in this case at node
B, A should appear on port 0 instead of port 1 so that L2
forwarding happens correctly? As expected, if another ping is
initiated from A to C, the other ping (C to A) starts working as
the FDB at B is updated. But if data path needs to be restored
quickly, these fdb update should happen immediately. How does
this happen?

Thanks

Murali

-- 
Murali Karicheri
Texas Instruments
