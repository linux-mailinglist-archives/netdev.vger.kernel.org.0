Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC83A24A3C6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgHSQIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:08:24 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58100 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgHSQIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:08:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07JG8Mth115806
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597853302;
        bh=+9eG03NpZZ3JryGrDd8EdWW/rdijdqGFPRq5pq5xr48=;
        h=To:From:Subject:Date;
        b=yMxdZn+cPpscfBkwImeqlY+AVUIVuVHt58kjHeZfXRcRQS2z9JchanOkf5WgwEugI
         67vwuMzsTsrzHZzqEUDDDj7TsKs1j1qDd1mj5JkdguegmiwXcc+OvBw6MUF3uxVDG3
         08dZYv4xr/Hd1SOL6ucUp5gzk4GaDZG7cljycF8Q=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07JG8Muu102433
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:08:22 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 19
 Aug 2020 11:08:22 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 19 Aug 2020 11:08:22 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07JG8LeR116509;
        Wed, 19 Aug 2020 11:08:21 -0500
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Subject: VLAN over HSR/PRP - Issue with rx_handler not called for VLAN hw
 acceleration
Message-ID: <dcea193d-8143-a664-947c-8a1baea7bc2c@ti.com>
Date:   Wed, 19 Aug 2020 12:08:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All,

I am working to add VLAN interface creation over HSR/PRP interface.
It works fine after I fixed the HSR driver to allow creation of
VLAN over it and with VLAN without hw acceleration. But with hw
acceleration, the HSR hook is bypassed in net/core/dev.c as

	if (skb_vlan_tag_present(skb)) {
		if (pt_prev) {
			ret = deliver_skb(skb, pt_prev, orig_dev);
			pt_prev = NULL;
		}
		if (vlan_do_receive(&skb))
			goto another_round;
		else if (unlikely(!skb))
			goto out;
	}

	rx_handler = rcu_dereference(skb->dev->rx_handler);
	if (rx_handler) {
		if (pt_prev) {
			ret = deliver_skb(skb, pt_prev, orig_dev);
			pt_prev = NULL;
		}
		switch (rx_handler(&skb)) {
		case RX_HANDLER_CONSUMED:
			ret = NET_RX_SUCCESS;
			goto out;
		case RX_HANDLER_ANOTHER:
			goto another_round;
		case RX_HANDLER_EXACT:
			deliver_exact = true;
		case RX_HANDLER_PASS:
			break;
		default:
			BUG();
		}
	}

What is the best way to address this issue? With VLAN hw acceleration,
skb_vlan_tag_present(skb) is true and rx_handler() is not called.

Thanks

-- 
Murali Karicheri
Texas Instruments
