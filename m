Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37BF14F316
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgAaUON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:14:13 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:44080 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAaUON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:14:13 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VKE94v126115;
        Fri, 31 Jan 2020 14:14:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580501649;
        bh=3NWxZM5OP6M2Ss+5LeyFGu7KEdF6VUD+PUYkKi/SwVo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=RioywwgQwN+kIApN6zzx9GopBz/txa7KZYhzRW7izvqF0zYFl3ICL/XE3xcOiJM4A
         MwOf3odx0oFS9+qFJPxriqaiuwsXFuAz381UoDMXRCad8vr3OjsghkKRXCnBl6gM7F
         K1Tgy1X6qR3qR5TJwm7uPuCRFER/svXw3tnne9S0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VKE9st010091
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 14:14:09 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 14:14:09 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 14:14:08 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VKE8DV048162;
        Fri, 31 Jan 2020 14:14:08 -0600
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
 <d03b5867-a55b-9abc-014f-69ce156b09f3@ti.com>
 <5c956a5a-cd83-f290-9995-6ea35383f5f0@gmail.com>
 <516ae353-e068-fe5e-768f-52308ef670a9@ti.com>
 <77b55164-5fc3-6022-be72-4d58ef897019@gmail.com>
 <07701542-2a94-7333-6682-a8e8986ea6d4@ti.com>
 <d194f979-ca6e-b33f-b18c-f8f238b66897@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <01797864-5a63-c3a0-d1d2-99dfff3a0aa1@ti.com>
Date:   Fri, 31 Jan 2020 14:10:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d194f979-ca6e-b33f-b18c-f8f238b66897@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 1/31/20 2:02 PM, Florian Fainelli wrote:
> On 1/31/20 11:54 AM, Dan Murphy wrote:
> <snip>
>> So then it would be ok to do a genphy_read_status and then override the
>> speed and duplex mode from the PHYSTS register?
> I would think so yes, especially if that is needed for reporting the
> actual link speed that ended up being negotiated, and not the one that
> the link was initially trained at. That assumes I understand that the
> problem is that you advertise and want Gigabit, but because of a 4-wire
> cable being plugged in, you ended up at 100Mbits/sec.

Exactly.

>> I don't think that the link change notification is needed.  The speed
>> should not change once the cable is plugged in and the speed is negotiated.
> The link change notification is just to signal to the user that the
> speed may have been reduced due to downshifting, which would/could
> happen with 4-wires instead of the expected 8-wires. Certainly not
> strictly necessary right now, I agree.

Ack

Dan

