Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A151D129F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgEMM1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:27:36 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33584 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEMM1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 08:27:35 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04DCRWkU103423;
        Wed, 13 May 2020 07:27:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589372852;
        bh=2ig5tIOWD6nykKQyzTlz+iNpTfFh1kkyICxOu/c7i8k=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=pHOShA8XrlH0z9VnTsMMhG0TCxGqUaQQZh5EkqdK3zAw6FrJhR8WSGezRos4wXMZ+
         7drCae5t971PI+VTkrDGW3OEhh1qNYgzPIQDA7YRW+Fr1HflCmdYolVywYs/zSKhVv
         rF7xPVrJEHF3WrKPl/qbkFcCO7SRpvxtOrWuQrE0=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04DCRWdc077159
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 07:27:32 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 13
 May 2020 07:27:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 13 May 2020 07:27:31 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04DCRVs0131026;
        Wed, 13 May 2020 07:27:31 -0500
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
Message-ID: <a947b604-4016-ff02-380f-f3788eea4ed9@ti.com>
Date:   Wed, 13 May 2020 08:27:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev experts,

On 5/6/20 12:30 PM, Murali Karicheri wrote:
> This RFC series add support for Parallel Redundancy Protocol (PRP)
> as defined in IEC-62439-3 in the kernel networking subsystem. PRP
> Uses a Redundancy Control Trailer (RCT) the format of which is
> similar to HSR Tag. This is used for implementing redundancy.
> RCT consists of 6 bytes similar to HSR tag and contain following
> fields:-
> 
> - 16-bit sequence number (SeqNr);
> - 4-bit LAN identifier (LanId);
> - 12 bit frame size (LSDUsize);
> - 16-bit suffix (PRPsuffix).
> 
> The PRPsuffix identifies PRP frames and distinguishes PRP frames
> from other protocols that also append a trailer to their useful
> data. The LSDUsize field allows the receiver to distinguish PRP
> frames from random, nonredundant frames as an additional check.
> LSDUsize is the size of the Ethernet payload inclusive of the
> RCT. Sequence number along with LanId is used for duplicate
> detection and discard.
> 
> PRP node is also known as Dual Attached Node (DAN-P) since it
> is typically attached to two different LAN for redundancy.
> DAN-P duplicates each of L2 frames and send it over the two
> Ethernet links. Each outgoing frame is appended with RCT.
> Unlike HSR, these are added to the end of L2 frame and may be
> treated as padding by bridges and therefore would be work with
> traditional bridges or switches, where as HSR wouldn't as Tag
> is prefixed to the Ethenet frame. At the remote end, these are
> received and the duplicate frame is discarded before the stripped
> frame is send up the networking stack. Like HSR, PRP also sends
> periodic Supervision frames to the network. These frames are
> received and MAC address from the SV frames are populated in a
> database called Node Table. The above functions are grouped into
> a block called Link Redundancy Entity (LRE) in the IEC spec.
> 
> As there are many similarities between HSR and PRP protocols,
> this patch re-use the code from HSR driver to implement PRP
> driver. As many part of the code can be re-used, this patch
> introduces a new common API definitions for both protocols and
> propose to obsolete the existing HSR defines in
> include/uapi/linux/if_link.h. New definitions are prefixed
> with a HSR_PRP prefix. Similarly include/uapi/linux/hsr_netlink.h
> is proposed to be replaced with include/uapi/linux/hsr_prp_netlink.h
> which also uses the HSR_PRP prefix. The netlink socket interface
> code is migrated (as well as the iproute2 being sent as a follow up
> patch) to use the new API definitions. To re-use the code,
> following are done as a preparatory patch before adding the PRP
> functionality:-
> 
>    - prefix all common code with hsr_prp
>    - net/hsr -> renamed to net/hsr-prp
>    - All common struct types, constants, functions renamed with
>      hsr{HSR}_prp{PRP} prefix.
> 
> Please review this and provide me feedback so that I can work to
> incorporate them and send a formal patch series for this. As this
> series impacts user space, I am not sure if this is the right
> approach to introduce a new definitions and obsolete the old
> API definitions for HSR. The current approach is choosen
> to avoid redundant code in iproute2 and in the netlink driver
> code (hsr_netlink.c). Other approach we discussed internally was
> to Keep the HSR prefix in the user space and kernel code, but
> live with the redundant code in the iproute2 and hsr netlink
> code. Would like to hear from you what is the best way to add
> this feature to networking core. If there is any other
> alternative approach possible, I would like to hear about the
> same.
> 
> The patch was tested using two TI AM57x IDK boards which are
> connected back to back over two CPSW ports.
> 
> Script used for creating the hsr/prp interface is given below
> and uses the ip link command. Also provided logs from the tests
> I have executed for your reference.
> 
> iproute2 related patches will follow soon....
Could someone please review this and provide some feedback to take
this forward?

Thanks and regards,
> 
> Murali Karicheri
> Texas Instruments


-Cut-------------------------
