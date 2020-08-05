Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D323CF3D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHETRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:17:46 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37406 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgHETPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:15:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 075JFC84038468;
        Wed, 5 Aug 2020 14:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596654912;
        bh=pYUuL/x4z1bQ6GnIDrhWIjVhchQvj8ZdqdLtpj1p924=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QaSQx4ckYSkpp7KW0rBV8Dbu+iB19PSivUbIH43Tf4t5swjw8yosNsjvPIykGhfPu
         Ejs3OZ1CUqIkwGI4Z/DG6PnJHqGAdUPJcKMNUDzf67E3u35N1CVssCRFkQu91XTxAL
         mCfocpSFhUl9J/olNxnDcxMsu7ndMpIB7PzERzjE=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 075JFCaE025585
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 5 Aug 2020 14:15:12 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 5 Aug
 2020 14:15:11 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 5 Aug 2020 14:15:12 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 075JF7Ct118872;
        Wed, 5 Aug 2020 14:15:08 -0500
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
 <20200804210759.GU1551@shell.armlinux.org.uk>
 <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com>
 <20200804214448.GV1551@shell.armlinux.org.uk>
 <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com>
 <20200804231429.GW1551@shell.armlinux.org.uk> <875z9x1lvn.fsf@kurt>
 <4d9aeb50-e8df-369a-7e3d-87ff9ba86079@ti.com> <87bljpnqji.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <292391c2-e59c-7c53-6bdd-164d9f3fd867@ti.com>
Date:   Wed, 5 Aug 2020 22:15:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87bljpnqji.fsf@kurt>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/08/2020 16:57, Kurt Kanzenbach wrote:
> On Wed Aug 05 2020, Grygorii Strashko wrote:
>> I really do not want touch netcp, sry.
>> There are other internal code based on this even if there is only one hooks in LKML now.
>> + my comment above.
> 
> OK, I see. The use of lists makes more sense now.
> 
>>
>> I'll try use skb_reset_mac_header(skb);
>> As spectrum does:
>>    	skb_reset_mac_header(skb);
>> 	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, true);
>>
>> if doesn't help PATCH 6 is to drop.
> 
> So, only patch 6 is to drop or 5 as well? Anyhow, I'll wait for your
> test results. Thanks!

Patch 5 not affected as all RX packet have timestamp and it's coming different way.
TX not affected as skb come to .xmit() properly initialized.

As I've just replied for patch 6 - skb_reset_mac_header() helps.

Rhetorical question - is below check really required?
Bad packets (short, crc) expected to be discarded by HW

	/* Ensure that the entire header is present in this packet. */
	if (ptr + sizeof(struct ptp_header) > skb->data + skb->len)
		return NULL;


And I'd like to ask you to update ptp_parse_header() documentation
with description of expected SKB state for this function to work.


-- 
Best regards,
grygorii
