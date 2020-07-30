Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575FA23301E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgG3KP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:15:27 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:36785
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgG3KP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:15:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPNN/eB+F4HRN3pD94u4aFn5aI/RzCUvRuAVHhjiRxlywcqr6I4QInDOqBRk/1kFstCFaUlu/sTXLGxUUIk5OdxOaLSf+KOWQqajm/ossctWubM2PD5qoyxVNm3LN/4KJHSalzVp1L2CEcUIQz5UpNZ45d3EyDcet2DT68cFLNbCU1bxC92igVx7NAyHHTQJVKHStxF0NAoxC9343gaQqEFVcnpgZ7tzRDIKpRnm4IBaZtkdpP0amAQmtcLiwkE3UM0rH2+8V0EBeLfpYe5l0HwIGS/yji7eFiC/hFQKmyKS/5QGMJuY0rNiPncyM318I8ZIv4LPUpz95Uc2NsqkRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8ejcXqfZwb+0AZZDDjpqZv0YVcJg6+J8u9EYxNmunU=;
 b=Tu2fYYUrgBO1pStZibaXZvPrYBuCjtM4WmAnw/lPsjTYS8wbqvTj6XM+PD76NyEhLSDjW0ooo+bK0FitEB9z6SjrZFiY1PNLuvQaK2Z4S61f+uqezFV+tfZaMqm/KkH+VcNViBEAh47xwhvOlSSU9v7eKXPa4fyfF58NM7Yc1c/ETxeSAb7kQ/mnFWCQG797OnnZqtjPXRJlCjthS4ps5VjakYq3MzgkkEcTcvbIz0Zl+4Sz8j5XkOru12DgzoTCNPL+pvSCK4J1KYaLOt02dmZzdymMOH4pFuBcPCaS8tZjSM410F5e006doZX0YpevX6rdS/Nnw8YnS2qMNiF6qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8ejcXqfZwb+0AZZDDjpqZv0YVcJg6+J8u9EYxNmunU=;
 b=Vv42/UtU4Talkh0uFBb11wWFkt4tTQHHBBrzhIDzcpNocwbWcQDbicR3qvQz/8TBjx1zeOwPix/CSd40E1fbfZFg8OI/bb5qhyOTaJ3pBBhzpoehTkCHolB0iKRpDuRzcBDwVNa48P6UveLCk06Ly+vk2uqtpx+DW2RUZ6NlHfA=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3036.eurprd05.prod.outlook.com (2603:10a6:3:d4::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.17; Thu, 30 Jul 2020 10:15:21 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.034; Thu, 30 Jul 2020
 10:15:21 +0000
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-2-kurt@linutronix.de>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
In-reply-to: <20200730080048.32553-2-kurt@linutronix.de>
Date:   Thu, 30 Jul 2020 12:15:17 +0200
Message-ID: <87lfj1gvgq.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::41) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:208:d2::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 10:15:19 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef6982ba-7b91-4ba6-54a1-08d83471776d
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3036:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB303639F21D9C3D2DE370D33CDB710@HE1PR0502MB3036.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcJqsUBw5m/Ji+1HYE+A+IP3ogD9sRgNwLi0qm0PYhQQT1vEJdruat0c5dE9OR+Xb4ba1adiN3Dsk1ZQKx6QSgHVgJV1683Xp1A6A1bsEewoAVAg02S0azczhmlmyc+NIAzVFcm6OWZzWZZyZtxc1gDv58uNBk5l/7jRFx7EXc0j0Jood0v1IRfXopjweliaMXWXCUiY7eCBRQQGdJb7EGCkBMxcoXT17SuWHRT7D2YtPvAIXiKLIED57wDElfOu4J62Rogy2uHiQzDafwFT4DEoA9P5s2vRY/0z2PChds0ax6fWaM1JSD7qi6JuUXXbNTi7pd3VyfEFwVXORMNE2RzDTxofvkDXi1PkzTEWqCLtY5f3UBoN24UDmgRr60rA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(478600001)(8676002)(52116002)(8936002)(186003)(16526019)(5660300002)(6496006)(316002)(36756003)(7416002)(26005)(54906003)(86362001)(4326008)(2906002)(66476007)(66556008)(956004)(2616005)(6916009)(6486002)(66946007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w1QxfMamm9CievwXdrLVETBrCbdQRoHg9bsuKKyQo5PK67xVk8T22kGzfOPspuvNSLkVYBZzuL7MGC6f0gJsI3F3NiGZ72OmVcm0GlO/+j3Snm44eo9W38CaptsxtZqRkSlga8/5Te+d5zMWOugMAC44+NAHtw+V05KetTV9VHyR8EJRH3EoF9rOy04Qful7IyhUhXOq/qBrQgO8Vz2q9yg6aIyGgCensYR5csQ1ZYvdV9FIY+aurNX3Pu9+3AuouBk9iwyaKIst3CPbjN47LWYiCwVftJAc9iFBwytkWtPh5GvCunHFuHToH9CLRwi/0DYyOqwHWRJB37pHg/qFwgc/x4ui/OmnMEfBxstXFGH6zqqicEpy99nVCKhvCrVxaSDtr+cPVrTfD+HMdW1I5wyqerEDNuv13dRAMWdd8lPmx/gLg6ILeG18qMINtF/x7dw5U9gwXa3t61M33NFZJi4e0Halt4Uz+Aaer9bqq+aH/Budh/tq/JkXzGSpuDq6uGe32s2CwjlZ36lfdpu+v9Uw9XSiizgKW9DHZFKJBq3hGLO1/USkTier/Bj14PnvUJG+ZhbaKuk5tsER2AId9+eepdzjCstoD/nSFNgllT75tVK1043GQ+LgBaTMDcUSg6LwW8Zmug3IMi6ybppTZA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6982ba-7b91-4ba6-54a1-08d83471776d
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 10:15:21.5066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcR5WV+ElInuXXSRR+YeNQaHrcl0mF0nNqwcQOzLBXlqNPacS1LB9sNz9K27bUPX+Um7QmxpgRm0Ucw7I5UZOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kurt Kanzenbach <kurt@linutronix.de> writes:

> @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL_GPL(ptp_classify_raw);
>  
> +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
> +{
> +	u8 *data = skb_mac_header(skb);
> +	u8 *ptr = data;

One of the "data" and "ptr" variables is superfluous.

> +
> +	if (type & PTP_CLASS_VLAN)
> +		ptr += VLAN_HLEN;
> +
> +	switch (type & PTP_CLASS_PMASK) {
> +	case PTP_CLASS_IPV4:
> +		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
> +		break;
> +	case PTP_CLASS_IPV6:
> +		ptr += IP6_HLEN + UDP_HLEN;
> +		break;
> +	case PTP_CLASS_L2:
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	ptr += ETH_HLEN;
> +
> +	/* Ensure that the entire header is present in this packet. */
> +	if (ptr + sizeof(struct ptp_header) > skb->data + skb->len)
> +		return NULL;

Looks correct.

> +	return (struct ptp_header *)ptr;
> +}
> +EXPORT_SYMBOL_GPL(ptp_parse_header);
> +
>  void __init ptp_classifier_init(void)
>  {
>  	static struct sock_filter ptp_filter[] __initdata = {

