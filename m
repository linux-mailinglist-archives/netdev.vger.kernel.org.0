Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9527E595
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 11:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgI3Jtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 05:49:32 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:27879
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgI3Jtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 05:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTvmd72bhDBBRXNMCiYyVCxFxmHafT4tSOyenvSgV2yEXrd2LK9ZxgazLbygu8cO9aX8lPytUPaNqFa0LP+ipE47LKOqXhAlt1t68elI4xtiMnVMfaF4Ga4BhAGbT/nKblxMDadvK12TMAyoDUy8wXJlO+u0aPDdfffnUVzVEBRMxnYbfGcHDgDdV5Qli1PJOCnQyifMu4cx6lYtDoJteEPd8C4GKxOIPNUeU4jov07NXWWCm+3PjHgv9lV4py0FA/qnCl/SyDDtz+Ec2DSe3bsEu6ycsKh3SBYVuv+DiPPyYfpuZwA/7qFzkfloz4lEgYSC66Fj/zwwNgruJbf4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUAzvz7tmvgURVhQcwOqO+i4o/F7Sg2zcSobH9sPKh4=;
 b=hmQ3lO2nEQ9FiO+oqsV49IfLnPwqTqmhjUOjY3GuNMF9VAJ/XSZOYifVKyeMpyexnamzfiEDbMuNKElxNjJMclzGtNo5R+H0ZlCcQn5/X2yiCnlCDmpXvAXDagOFjMlBZNA3jRP1KdBy4OSp60dDr99qkonIjf887dwsBlxQBJcTUEjIXvG1cjs+AyvroDVwb32605+saj/RXV9Jd46MZazBcUOM38P24hY9qTD5wiXKMosa0N+IV1jT3a3TFc/hVbTOLZOlzCKTm9Z26VoTymYuLQhmrFQdwKrGUfvzmyVuuPHw0nEuBvcFwgM2paNJdfp2H0glC3UK4cz9QStCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUAzvz7tmvgURVhQcwOqO+i4o/F7Sg2zcSobH9sPKh4=;
 b=nj1HFBcd29SQQSTGI/zGslQdQpSRDudFugVY7a85zmeUxFiYMLR59USQJBuf83P5K3Vs75vcZQ4J/03ihWTVzuUEEC8RfTLfVNNhzbSD0be+NMlfzn0F4mX6ktiQJVKARbp0H5H7yGns6CoN/R7sBDZuGEy+SFE1GJli03sXbUI=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DM6PR03MB4361.namprd03.prod.outlook.com (2603:10b6:5:105::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 09:49:30 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 09:49:30 +0000
Date:   Wed, 30 Sep 2020 17:47:43 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <20200930174419.345cc9b4@xhacker.debian>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.74.246.114]
X-ClientProxiedBy: HKAPR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:203:d0::16) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by HKAPR04CA0006.apcprd04.prod.outlook.com (2603:1096:203:d0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Wed, 30 Sep 2020 09:49:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36d11861-8b44-48ff-cd90-08d86526202c
X-MS-TrafficTypeDiagnostic: DM6PR03MB4361:
X-Microsoft-Antispam-PRVS: <DM6PR03MB43610A62676668A0851511FEED330@DM6PR03MB4361.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48Tsjf81hpvdu4UL1TJRAUMEVtusalF7fTwsMEpAMMmLACZn1Nwx1ODrVp06H2mstvcn+zJPUnQ160zjci0J421cSlrK9+tFRia/5PIhZ19GU6G8PNeaQClPwPySk9FYpdO1S1wqr+X4KW3QEK6jTzJJLEEEiEvuaBGP+BX50yjQ3Dr+acQMQretUh9gGt5Cuo6Kr/a0Xa9s0myAnEMWC2mxjqzuMUf2jS9pZIfOziMhDuapUVBXiGtpiYXh3sF78q50BBnM7gaIzfORb9iXPIa3insgKGH8an1SlW5haDsm40Oe3pY+lqNdKzzndisxrpHeshLszPJfCjO6K4TnZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(346002)(376002)(366004)(136003)(110136005)(316002)(86362001)(478600001)(66946007)(4744005)(1076003)(66556008)(66476007)(5660300002)(6666004)(52116002)(7696005)(6506007)(16526019)(26005)(186003)(2906002)(8676002)(4326008)(9686003)(8936002)(956004)(55016002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AO6X4Hq/DIsG94VkenM0qjw0GTtudueKve8/tnbV9EOEuWxoPWNgqV8+BCwQFs7TKyumxcFDB3KReSZeyEXNntC8TKwsXmL2Iu1VtEkcBv9rs8X6+/MVS2Aw6buC3hJ+n4bO3DtCB4hqez6UTFwdHUm+0VavxAPvLNray1NuAEtc2LMQdhcFWoi3AWRCkRXqUBDncBf32AMNqAnkfgB2Nj0l+U66KqyfOJJ13LONc26C0k7xsDrddDHCl8zrKUKsyCmGyK66qnR18ILOEViP2wIB2wUq6CF/XPSfHeyun4fjyyLXEZFHAeJyxyswnKgCmjD5f7vSll2Ilvfc6RzLahpVwDFWrsW7f3pSngQzxZU5RFXBBZ980dH/NTZ5K8HnQk3xl93JbShLJ97BW5QqBku9cwihML74m/oZqPgZetBuzNPK0HijGZ8x3is8VQV+15DifvHBKv19UubY2Wrxq8YIlYHyNGB6e33uPRa32D9l8r3F7/MQiuy4bHmHFfbhqOCC0/LQzn64w+59A9JKujS82IR11dBurnZaHfWmxHm+NzLknHDOYy0XvqFMcqrRKRjqQs2wG88i1XYv8QzolWYkYSfU8hbKbm8b1Gtkd7ddb3+RIz0yCgMhKZZgl83SOIDZWbVOvXxUN0PPgIN7/A==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d11861-8b44-48ff-cd90-08d86526202c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 09:49:30.0142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C61jV/Mt5F0xF0hmKolbLCZ65Ln2n1NLUOOecNoCtLD4e3i3uCI3H3nkyomxcmMnjWMlNqRDWLnSOsqX3BpDrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4361
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A GE phy supports pad isolation which can save power in WOL mode. But once the
isolation is enabled, the MAC can't send/receive pkts to/from the phy because
the phy is "isolated". To make the PHY work normally, I need to move the
enabling isolation to suspend hook, so far so good. But the isolation isn't
enabled in system shutdown case, to support this, I want to add shutdown hook
to net phy_driver, then also enable the isolation in the shutdown hook. Is
there any elegant solution?

Or we can break the assumption: ethernet can still send/receive pkts after
enabling WoL, no?

Thanks in advance,
Jisheng
