Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAE11DCCFB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgEUMeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:34:22 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:41014 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgEUMeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:34:21 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LCYGSU068676;
        Thu, 21 May 2020 07:34:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590064456;
        bh=3HwKNsiZR64FJ05ODAi+SwPDScENaEua2gPzI8Vn1lA=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=Few7CvgaQn9OkBxG71L+bKWQV/fGM9nriam3FyyQsq62cF8C/ws0PlYIitUdqWpMy
         fcenJCJ3WJcYEQZQR0P2LqqGRHmoGzMO+AaiYKjY8hv0wuSvwqtoYEEjL2rzllZzh8
         I+uO90CUMTEb6NkWv7gbJFKzzZPkVAdW89rsnx/U=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LCYG6L061400
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 07:34:16 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 07:34:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 07:34:16 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LCYFEI012561;
        Thu, 21 May 2020 07:34:15 -0500
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
 <a947b604-4016-ff02-380f-f3788eea4ed9@ti.com>
Message-ID: <2e96bf73-9ef3-4949-967f-4b9d65816c09@ti.com>
Date:   Thu, 21 May 2020 08:34:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a947b604-4016-ff02-380f-f3788eea4ed9@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, et all,

On 5/13/20 8:27 AM, Murali Karicheri wrote:
> Hello netdev experts,
> 
> On 5/6/20 12:30 PM, Murali Karicheri wrote:
>> This RFC series add support for Parallel Redundancy Protocol (PRP)
>> as defined in IEC-62439-3 in the kernel networking subsystem. PRP
>> Uses a Redundancy Control Trailer (RCT) the format of which is
>> similar to HSR Tag. This is used for implementing redundancy.
>> RCT consists of 6 bytes similar to HSR tag and contain following
>> fields:-
>>
>> - 16-bit sequence number (SeqNr);
>> - 4-bit LAN identifier (LanId);
>> - 12 bit frame size (LSDUsize);
>> - 16-bit suffix (PRPsuffix).
>>
>> The PRPsuffix identifies PRP frames and distinguishes PRP frames
>> from other protocols that also append a trailer to their useful
>> data. The LSDUsize field allows the receiver to distinguish PRP
>> frames from random, nonredundant frames as an additional check.
>> LSDUsize is the size of the Ethernet payload inclusive of the
>> RCT. Sequence number along with LanId is used for duplicate
>> detection and discard.
>>
>> PRP node is also known as Dual Attached Node (DAN-P) since it
>> is typically attached to two different LAN for redundancy.
>> DAN-P duplicates each of L2 frames and send it over the two
>> Ethernet links. Each outgoing frame is appended with RCT.
>> Unlike HSR, these are added to the end of L2 frame and may be
>> treated as padding by bridges and therefore would be work with
>> traditional bridges or switches, where as HSR wouldn't as Tag
>> is prefixed to the Ethenet frame. At the remote end, these are
>> received and the duplicate frame is discarded before the stripped
>> frame is send up the networking stack. Like HSR, PRP also sends
>> periodic Supervision frames to the network. These frames are
>> received and MAC address from the SV frames are populated in a
>> database called Node Table. The above functions are grouped into
>> a block called Link Redundancy Entity (LRE) in the IEC spec.
>>
>> As there are many similarities between HSR and PRP protocols,
>> this patch re-use the code from HSR driver to implement PRP
>> driver. As many part of the code can be re-used, this patch
>> introduces a new common API definitions for both protocols and
>> propose to obsolete the existing HSR defines in
>> include/uapi/linux/if_link.h. New definitions are prefixed
>> with a HSR_PRP prefix. Similarly include/uapi/linux/hsr_netlink.h
>> is proposed to be replaced with include/uapi/linux/hsr_prp_netlink.h
>> which also uses the HSR_PRP prefix. The netlink socket interface
>> code is migrated (as well as the iproute2 being sent as a follow up
>> patch) to use the new API definitions. To re-use the code,
>> following are done as a preparatory patch before adding the PRP
>> functionality:-
>>
>>    - prefix all common code with hsr_prp
>>    - net/hsr -> renamed to net/hsr-prp
>>    - All common struct types, constants, functions renamed with
>>      hsr{HSR}_prp{PRP} prefix.
>>
>> Please review this and provide me feedback so that I can work to
>> incorporate them and send a formal patch series for this. As this
>> series impacts user space, I am not sure if this is the right
>> approach to introduce a new definitions and obsolete the old
>> API definitions for HSR. The current approach is choosen
>> to avoid redundant code in iproute2 and in the netlink driver
>> code (hsr_netlink.c). Other approach we discussed internally was
>> to Keep the HSR prefix in the user space and kernel code, but
>> live with the redundant code in the iproute2 and hsr netlink
>> code. Would like to hear from you what is the best way to add
>> this feature to networking core. If there is any other
>> alternative approach possible, I would like to hear about the
>> same.
>>
>> The patch was tested using two TI AM57x IDK boards which are
>> connected back to back over two CPSW ports.
>>
>> Script used for creating the hsr/prp interface is given below
>> and uses the ip link command. Also provided logs from the tests
>> I have executed for your reference.
>>
>> iproute2 related patches will follow soon....
> Could someone please review this and provide some feedback to take
> this forward?
> 
> Thanks and regards,
>>
>> Murali Karicheri
>> Texas Instruments
> 
> 
> -Cut-------------------------

I plan to send a formal patch early next week as we would like to move
forward with this series. So please take some high level look at this
and guide me if I am on the right track or this requires rework for
a formal patch.
-- 
Murali Karicheri
Texas Instruments
