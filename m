Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AB24C768
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgHTVxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:53:50 -0400
Received: from mail-eopbgr770101.outbound.protection.outlook.com ([40.107.77.101]:15621
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbgHTVxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 17:53:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcQ+Fnu83BWveC7qucvFr779R/gkgy7NLFoVnIxY7/WqGr3AN9RQGDm0JRGqRY7QJjpeji8lDrMvOL+W9VJM24A2la9ApahC/SOgDZ5UKrwf/8152PAWuO9b7AkC6WainXmCmr+Gl9eQIsRNrFUjiD4479oj6jA3mEAuWAVf3BY9dXPhOHcJV+ypwUPESUlbjzqz4UxxXcJajhdkXVDk8ZQZjcoKZxiuDj09j1aJPpJi7UVP0FBGJewphclOWA4QZDE0IeekdJyyNYaP0PmmqfBCuPEacP/E20U8LXTUorgOq19PVjZDvSZjkOxFd0gwbhr3o2/eJ7XQbZn5PR3jww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RG4KbGLVdOufIYjQc1al6YSpiV9guQJUhOLQ5+XRbE=;
 b=ILepRKHgs3Z5flcyyWErTXlYuIEtvGpbfWhyZgoyzdD2IIIQdLqDm49+vmU+KC2Q29Mk6O8blaq3nkHOiUCTnm/h8QPEo7l5QfM42/tFPIcX2xuLfCQfVC7P08a7qL8+f0Tn5z/CRiPAoABdt/7SxLgPf4k+xbIP0XwsjDrsiS+YLAdoDdEjxXH8jen6n1WJCw0j6lGh3qgZX1RDeRGmYqoi8ThNYIWZAhSbhu/6qgQDgBmvd/xEjP/zRcraoMIvmQePEvjnxnLVcTEOadOFNbo4ylVY8kWxr1LftxfCgu4Aoxr8ZY6I+7pR9nxuxlEhKBncvdLmr6X9gAkSRqwPeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RG4KbGLVdOufIYjQc1al6YSpiV9guQJUhOLQ5+XRbE=;
 b=Pf9iu/qUELTXl17MjEsSOrzj6JLqilB5hjYthH0dPmKIgIMjqEkNNJiACtHSp3vejRTmNDTl5C9U/ctiCTwcQX5p5O2EW6JwgzW6X3/CX5BiOczPnsMauxoNjoJoPYvcb8aYPW/zf2wiEQkFae0FoBHtKnd1k/R1pADYj5aCu5A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from BYAPR21MB1333.namprd21.prod.outlook.com (2603:10b6:a03:115::15)
 by BY5PR21MB1395.namprd21.prod.outlook.com (2603:10b6:a03:238::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.5; Thu, 20 Aug
 2020 21:53:43 +0000
Received: from BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f]) by BYAPR21MB1333.namprd21.prod.outlook.com
 ([fe80::e1f7:9d59:6ae3:e84f%9]) with mapi id 15.20.3305.021; Thu, 20 Aug 2020
 21:53:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net, 0/2] hv_netvsc: Some fixes for the select_queue
Date:   Thu, 20 Aug 2020 14:53:13 -0700
Message-Id: <1597960395-1897-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:320:31::11) To BYAPR21MB1333.namprd21.prod.outlook.com
 (2603:10b6:a03:115::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from 255.255.255.255 (255.255.255.255) by MWHPR18CA0025.namprd18.prod.outlook.com (2603:10b6:320:31::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 21:53:42 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23690fbb-b0f4-4c19-2038-08d84553814d
X-MS-TrafficTypeDiagnostic: BY5PR21MB1395:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR21MB139593B953FE84B5D94DB0F7AC5A0@BY5PR21MB1395.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lii6AgTstyKx18yPk8a6RREMTybI8ZkloePBarGPztK2nweNaaD3RFFQRDQO7a7Bkdos0iZVAx4Qa05dkurTKIXAcjHUTL3e0PZmrKS4/4qEhYVu14iGr1uP5rxzzFoyWTsCrmcFCavmw25etxUIZxVO+rpgMPqE8XNFxd3QrqcToKk+VZsnIOZAWRgRHChuGT4OW2n14z3AgRUUkm+T2az4o5zPnIhE4UfHe5g7fq7E+bbDZvwsrYlKTedMFhxo/aaYavFhCiltJf0eK/uw7hniPBnngWNnXTrLCosZ+IHBVJ6U+XzG0gE5zDP+ZfVyXjf7jGNvXeFbHEFrWdx08htpSyZQcVFzv8Bg8uAdPIoXDmFccu49Uub7bIeBWpO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1333.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(82950400001)(956004)(82960400001)(2616005)(52116002)(66556008)(66946007)(478600001)(5660300002)(66476007)(316002)(16576012)(6666004)(558084003)(110011004)(83380400001)(36756003)(8936002)(186003)(6486002)(4326008)(10290500003)(2906002)(7846003)(8676002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dqXvoOtUt3wIZIeDNyvT9n/KIOV55DugHIjFO4aNm2KTjlF1Ei5yr+glzjrMLcM/89eXwsT4ReK420nk6yv0a1doaWpENsw0Q1PB737WPdA5p755lfuHQCK6HgKA1vBj7IxFr5mQd+5eNzKrzLq5bqUPPiOXrzINSzGJ/jMLLA9zdIdKjNYbpKqJfgK+uC7KLf+7oLxRzzmvnw62SQda8A+anFVgGmrdtET7Jxds/hcu7KaMv6LHZiw/pXkxqeWNXOvdtJvd/Pu6n1tNmpUO4UsCYfac17Orz8RCE1gege5HyjXI5Xj0gzbMSYR1eanUUqNuElf8c9cQRdk/YTQzfwSsznzrhbe314gc2nHEgm2Uve/XqxUEwGgKno4bT4U7JkoBfh59O6WF6qAKwUeHCnnonoSsp9PcS9rDV5sYPbw7jpA82SUUrIu13FmFXlSbGpSTJVy/Yg0KXzOvBUNJmcdNFZAogy/Swd0u/Cyl4UQ3GYMMfX9TpU51JAiqsPzFteh6dPUlvWOU7Ad/ljbZEQnZTbUPt9R8IwHOmD0AegUwSXAZZ1Qs6mYaUJJqDHS0LWBLzsdHb/G5Oc5pJA9QIEgph89ItgZgUWjuWzEjoIo2K3Wyg6H3zqHYbvTjVOi9KIsqfVco8eTW6Zf4RKHCrw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23690fbb-b0f4-4c19-2038-08d84553814d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1333.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 21:53:43.1532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHaKEgmHoWBcW2rOZ/dks9gMjh3xZuZdpPXn859Cp2p1ZhTgyo1/yfQUQqHr17rCIfcGxHKwph3Pgvol52INeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1395
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set includes two fixes for the select_queue process.

Haiyang Zhang (2):
  hv_netvsc: Remove "unlikely" from netvsc_select_queue
  hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

 drivers/net/hyperv/netvsc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.25.1

