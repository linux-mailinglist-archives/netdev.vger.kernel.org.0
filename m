Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46E4820D0
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 00:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbhL3XHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 18:07:50 -0500
Received: from mail-bn8nam12on2137.outbound.protection.outlook.com ([40.107.237.137]:2784
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229608AbhL3XHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 18:07:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPG9jktTHAl0UTb4fEhWSGEb4VYxa4y0ArbbsSLTzKggPdnj/1QQ/sUTYwzELkKnKsT5FFgEHEHvnvwTNGi4Iyb8LcAuiUd0P8zXCfs0GjO9pKIVv5wvloBN9j3EV4KW+p6Na6gfwl+ZeapvM4yAih7H4ESxLz+sJKU7YSVigFE63HoCVSI5V7plWcUQUGkxHJEam72Yb901MzI8TAq3yW36M1e+/3hjCpsBqbICPe4PK+ihyzqFhpJclqVFuBuP1MHFMKUIX/VOljhz1/JqRjW+kxhHoGKSPJHr4isQnj1T7zURCl/r9awAzCQOgNyhrwqk0r6fVurcGQX8QKiGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Yjv8HENrW/19ANconkhz0gtPdL2ygCw9V9b60Hg3/0=;
 b=jlnt1e4y+LVSDNMnfUdjLB9cOKt8ROYG7YuyPUtLKIavLUlZgyrFTt5iIwHdaOg2UFWiOC99KSyTk+RmWlsHCXt0pvM5QtgzJSwOxZSXNiR8xVf0k5An1gLHlhZSHaP/JLEHZZTmr1YRJ88hBn7wvUliLcqDJBHW0OaKc07vnZKWN+iXGGR7yeI/1nRmbQ7hqe3XOStLRD2MzdXjHrhqS/031hado6JT0NEOyeSNOdOZH4Usep2hTRjV8Nj06jvwSkYfrLMCOm/uAbSPM8UNgZtG3kHP0R/4bOTJFwLElQ+8JfE8yTl5+8ASfFVKbIEIsmjWK5yedE1DKzWmuRA7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Yjv8HENrW/19ANconkhz0gtPdL2ygCw9V9b60Hg3/0=;
 b=fxr1XvanzOZmYALaT30PNlrrKi+1k3n5b7o0oACvF/bhdwmXzaMb/OkON16sKpG2e4d1Bfp+w2L/5xD9ikAqBSjGSW/vJadSCo8gXv+zgTbXm1uVC4lBjpvBWPd0eczGq6WNfT0qHBEQhodJUKnVbp3c8GAF8uIqjpPKR0d/kbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4451.namprd10.prod.outlook.com
 (2603:10b6:303:96::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Thu, 30 Dec
 2021 23:07:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Thu, 30 Dec 2021
 23:07:46 +0000
Date:   Thu, 30 Dec 2021 15:07:40 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: packets trickling out of STP-blocked ports
Message-ID: <20211230230740.GA1510894@euler>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: CO1PR15CA0094.namprd15.prod.outlook.com
 (2603:10b6:101:21::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b6a82bb-eee5-4272-4834-08d9cbe93144
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4451FC89803B93ACAFD9C5A3A4459@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0xnHJosXEJrDDMxnBw0WQtQxPkU+WuyFOMRwjhvSagp9zQqTaZmQ/bLJu/IR699j2IGyGdC1Pwxo+MuH069uosPYEqo+lRzSejPH56IMM7Im2XSqx62NmGdLKZ3eMwtzhAyT8TszHOVIqUFjHCGtCwmrLNIXPmYwNuMVpoP3tPM6PS59jmiO+60ZFr5CF6DfTS5Nnl4/dFFJUH9Hq1LOMaLkyTtUXgp4zy/2Qv7uoooxKpcn5sc/wKMIXSwRmc0/FXBHdvAsG3ppxLCkbcJnVtMvkekj7QLZK5CT9S52K/2zeT/mbq+rwD/2xtrPyTDnD2yR3UBLE7GrJGUCTSFaHk4WOISS0IoBymMhnCs2D7SyW6J4idz4QjSm82jr5S5QjoNIhksEifxGysPK9PGy6S+ebIRXTHs7tAtcda9pPM6EaNWijZRrSq6H8OnXlmWS691PP1m/3N0RRTfx2rimd5Nu0sE5VHOljOrRciQvJ4frPAQDhyVOfgNFebTdX2C2HXyUDpc2Cd8LL1mTUwMnVwf2unvZqjZOAWBSAJK4iWZVGjJtrVideyId0OzSdz9YvevpztuXxZ2q4MFA28YrrmTDP0VhaN4CNDcqbJsjHVUyjhHb5s03MhAUzeDOB8JKXsacZTyeAhC6cpzUv0RLeGqiEHqXSHiLwDme75E7gbqFKuf34pZdePAWcHITiHk3jbG4fOvei4VvaX16xx1Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(376002)(42606007)(136003)(346002)(396003)(39830400003)(66946007)(508600001)(26005)(15650500001)(52116002)(186003)(6512007)(33716001)(1076003)(66556008)(9686003)(316002)(66476007)(33656002)(6486002)(44832011)(38350700002)(4326008)(86362001)(40140700001)(6666004)(54906003)(83380400001)(38100700002)(6916009)(5660300002)(8676002)(66574015)(2906002)(6506007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7j13LT9JcbJRwHBZrp2uIizamlFss/MYIajPn/Phf6C061U2ZTsyd3Z6jRT?=
 =?us-ascii?Q?hY5deZyXJLJQh2q+guANfFysim/Dlh1k6VN0EqU4T1ceH4B7IhbJ1rM4C/oD?=
 =?us-ascii?Q?2ZoS7XInbfNLzIwl+x+nikoTGR6gINNFSmHE9OAQpnNWvlsGTLmR+pWxZYYa?=
 =?us-ascii?Q?JXXYyBSjHb6gaBZ3xECFmKkSy3sf4fNIWeSb/GGHgSxRVp3wYEP/ffYXy2P3?=
 =?us-ascii?Q?6lVEIzZ91SjnxWVnG9vsa30S3EyWj6x8W69Jc48uBI0L3tr7l4CLNwSKFiL6?=
 =?us-ascii?Q?pe2iALFLbAH3ovAkbwgTmlg/qd87dYIUwpU4QMxnCVNsp4xLft90Oy8Vzu9u?=
 =?us-ascii?Q?KF1/5JaxSRG3Qb/VYMoAtbDHBI/Ev4NQCYwZm7p0qIf/PRNmjgwLDuqvynkT?=
 =?us-ascii?Q?uQbuz9eOd6pw39IHnXhq1Z2QPAP5ch4eFH3jcZKMQ4ZCTWrNPrChdUDByON6?=
 =?us-ascii?Q?E9NENMm8tVrP+Fv/HvjT0XGhq75RqNOQST+7yauVSEh/U3dsPo8vHrC4p4V7?=
 =?us-ascii?Q?Ej9hZvK1r+b1pGGdywCei5sjXXIPh8SLNixHNbdyCP+RBpoQhLua03cE0YYy?=
 =?us-ascii?Q?pOjQUXb5qMXTzEDDBuTJiMPvexOLFNpaeen+Ze7y7COW5G8QC2XUu1fbynro?=
 =?us-ascii?Q?jUbZfjPqvkO1HLEqstE5KbQyC24xW5l+AnXQl3NnnT5iSiIrO9dqHVNmtEo2?=
 =?us-ascii?Q?80qrp4Hw1FGgMBynmv3gBVdHzTuQmAXCIZ1GomYdussmASOiwvb1Qx/7if5a?=
 =?us-ascii?Q?BYOFg2mKSaj0hea6Wjgy2Jz7FZiANvDPixKdxyTiRoM/aTEdsh1yTehyIU+Z?=
 =?us-ascii?Q?X8Gz5ixrohswSBx9tlBjErct63zYpVPGKB3ipo8lgzvMns4A0JnMkYOVKMJ+?=
 =?us-ascii?Q?MGnQeaun2TqwJKrmOD0QEDfaX0AzoBWoqFjJwGIqKpSx2cxiz9onZZAYp8QH?=
 =?us-ascii?Q?Cvu7Y4XmeVT041pKQzk1MWXEeQawnZt7x5qOw647OLwyi5ndG4r2h3rIPcaL?=
 =?us-ascii?Q?W7J/9+q4Nww134Fd8MN0XEzEsZoc4EjdUMWHeB+qTNWbsEG6hVr+Jof8VI26?=
 =?us-ascii?Q?MuZY9zPsC+H+rMhKi1mAFtFD72STBC/LwC4T0JVjG/sNy4w9gm1Ye6Boumdr?=
 =?us-ascii?Q?qcEhSclUIz0qhVRbcJoyk4EH7sOwvFrrXEDtDEx+Rg6tybosWvugvGGacr77?=
 =?us-ascii?Q?YXDLBLFAfpGsZHlGTuhAOnEylM9G0fm6o0rjayN/IaD34wIuVUAXSgBay7Tn?=
 =?us-ascii?Q?cL+WEPhO/7256afndYmFPbynJfp2XeTMNik4GY4E8aBAWGNKmURGEf5uUKX6?=
 =?us-ascii?Q?0wncLJ/1I4sV1tlfWPMM/vD1/v1uAZaY/bxZr6SSWP3E1+HP6IVqLJwxnafA?=
 =?us-ascii?Q?0HHnc5KFS2+PXbzwqkdWddq9qzPHy1ouk18D//PVaGbkMdgyetNuPPgfvNZm?=
 =?us-ascii?Q?LcYZ60fBhatNH89RW3GK/nSV4uUHgl9qhOb/csXFatRjDh8oyvmPQiiBxvMf?=
 =?us-ascii?Q?gFcbxEk7/0V+O1/IzgXVxtszoBDmlHwjycjpeCcq/8+/qGtshyuSD/rjN+VS?=
 =?us-ascii?Q?s3m8ZYmpItC+m2K1wmbc+Dxd95oO3Q/7ebTIyyI/a/9pbC0kDb0eEyKuzjDa?=
 =?us-ascii?Q?O23B9b3AolB37HH5QLNWXhOZ8sbonu94e8ynp/phnqEBzclWOpQ9/vtmP9vt?=
 =?us-ascii?Q?LN+DMQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6a82bb-eee5-4272-4834-08d9cbe93144
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 23:07:46.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTgdoPAylXL2yhwMC4kRXbEY6npXaswLRgkA+LVv1hB6+ioW6jkWjAqsgm5dEJH45M+cSdV2GuzI/KPA3YzQI7DPGthJ0APrmVr+8BN0YlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm not sure who all to include in this email, but I'm starting with
this list to start.

Probably obvious to those in this email list, I'm testing a VSC7512 dev
board controlled via SPI. The patches are still out-of-tree, but I
figured I'll report these findings, since they seem real.

My setup is port 0 of the 7512 is tied to a Beaglebone Black. Port 1 is
tied to my development PC. Ports 2 and 3 are tied together to test STP.

I run the commands:

ip link set eth0 up
ip link set swp[1-3] up
ip link add name br0 type bridge stp_state 1
ip link set dev swp[1-3] master br0
ip addr add 10.100.3.1/16 dev br0
ip link set dev br0 up

After running this, the STP blocks swp3, and swp1/2 are forwarding.

Periodically I see messages saying that swp2 is receiving packets with
own address as source address.

I can confirm that via ethtool that TX packets are increasing on swp3. I
believe I captured the event via tshark. A 4 minute capture showed three
non-STP packets on swp2. All three of these packets are ICMPv6 Router
Solicitation packets. 

I would expect no packets at all to egress swp3. Is this an issue that
is unique to me and my in-development configuration? Or is this an issue
with all Ocelot / Felix devices?

If this is an Ocelot thing, I can try to come up with a different test 
setup to capture more data... printing the packet when it is received,
capturing the traffic externally, capturing eth0 traffic to see if it is
coming from the kernel or being hardware-forwarded...

(side note - if there's a place where a parser for Ocelot NPI traffic is
hidden, that might eventually save me a lot of debugging in Lua)


An idea of how frequently this happens - my system has been currently up
for 3700 seconds. Eight "own address as source address" events have
happened at 66, 96, 156, 279, 509, 996, 1897, and 3699 seconds. 

Thanks, 

Colin Foster
