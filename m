Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6B45C85D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhKXPSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:18:42 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:57104 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230158AbhKXPSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:18:41 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AO8rHXf003816;
        Wed, 24 Nov 2021 10:14:58 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3chj9csr87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 10:14:58 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 1AOFEvV9004733
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Nov 2021 10:14:57 -0500
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Wed, 24 Nov 2021 10:14:56 -0500
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Wed, 24 Nov 2021 10:14:56 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Wed, 24 Nov 2021 10:14:56 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1AOFEqcE000856;
        Wed, 24 Nov 2021 10:14:53 -0500
From:   <alexandru.tachici@analog.com>
To:     <o.rempel@pengutronix.de>
CC:     <alexandru.tachici@analog.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 3/8] net: phy: Add BaseT1 auto-negotiation registers
Date:   Wed, 24 Nov 2021 17:24:53 +0200
Message-ID: <20211124152453.21123-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012071438.GB938@pengutronix.de>
References: <20211012071438.GB938@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: F7nQfJ2zPz8HfNaeNym8A094BGhRZ1mf
X-Proofpoint-GUID: F7nQfJ2zPz8HfNaeNym8A094BGhRZ1mf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_04,2021-11-24_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=276 adultscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hm.. MDIO_AN_T1_ADV_M_MST is T4 of Link codeword Base Page. The spec says:
> "Transmitted Nonce Field (T[4:0]) is a 5-bit wide field whose lower 4
> bits contains a random or pseudorandom number. A new value shall be
> generated for each entry to the Ability Detect state"
>
> Should we actually do it?

Managed to get some answears from the HW team:

Bits 7.515.3:0 correspond to the lower 4 bits of the Transmitted Nonce Field. We do not allow users to write these bits as they need to be controlled by the auto-negotiation (AN) sequencers in order to ensure that AN remains robust and reliable. However, the Transmitted Nonce value is readable via register 7.515. So we could call these bits out in the documentation and indicate that they are readonly.

Bottom line is that the driver cannot and should not do anything with the lower 4 Transmitted Nonce bits. The PHY controls them.

Also from 802.3 98.2.1.2.3 Transmitted Nonce Field:
If the device has received a DME page with good CRC16 and the link partner has a Transmitted Nonce Field
(T[4:0]) that matches the devices generated T[4:0], the device shall invert its T[0] bit and regenerate a new
random value for T[3:1] and use that as its new T[4:0] value. Since the DME pages are exchanged in a halfduplex manner, it is possible to swap to a new T[4:0] value prior to transmitting the DME page. One device
will always see a DME page with good CRC16 before the other device hence this swapping will guarantee
that nonce_match will never be true.

Seems that there must be hardware to deal with nonce collisions.

Regards,
Alexandru
