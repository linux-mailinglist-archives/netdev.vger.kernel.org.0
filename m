Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E494686F0
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385401AbhLDSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:22:02 -0500
Received: from mail-dm6nam10on2104.outbound.protection.outlook.com ([40.107.93.104]:52545
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhLDSWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:22:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWABtLApV5DfIbEvz82pAFmQmEGJ8FqbQcqitcX9uqeF2DKa5qJnHyn4wzAUgqeFF3YBadRROGPQUxkToswE6/bPIw0zEn1+8qrh33A0VCYNXodvhKxHGwLmhTdEXoM96N98zjuuEH07FoZGvN75LfVGPcBMNnJJX1arM1fA8XdCdOUsC0tyc5+wv1BMyA9eZjCSm8HYNrxbB0Uny5QJ5fhGmNOi2lJCE5YWxDzeNbWPoEdJ+mBTwxlxhSHsf6MsJtWQ909e1gflbvRB9DUA2jwGH0V09UxNZt9CJnOlIsCq1iiI2EltQdbmHkOapkHOxmAtX7je3HstvXMUXqlpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UpusbipCfufdiN4gryuaV/bGs17qFXAvR3bAKANx/w=;
 b=Q389halYnA+dM3dmHoddDfFsR68YE4Hz0p1xuh95Ev9Hwsv0Q1zZ6eANTbtK+K8ps2jXX4zSWNhCMY7AEwT1wuf3cUqM7m+sgNB38+nU/opQrxydnLZw67+A4rdAFTcCG4+nAuBYz+PgBJ6yHk/dWAc4Z7g9fOjLeClqb57jYcSWJOpNv913vqKekbrpR+bBSPJ0RUiAxwJyiQ6RQc9uGlNwi1ptLVlN3oqC+Z+1SAE+fmZuzZOhEkoCARGjgGH7QqF9rPmnuucRN/mBngW2Ti6LkE0dEqUjxo0/5bH5PzG6bifcG50GcPvMGwYFZRXRVRb06LNHckctljF0zsh8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UpusbipCfufdiN4gryuaV/bGs17qFXAvR3bAKANx/w=;
 b=dL9FBQYgfvrxFMkcFm5s2AfdmC12JbqrG7jx7HkLQRK3jw6Cf7xDTVWtTcuoV4QDd+a/XcxU8uSAiY73cOpnIoSakfE2g39cqesqGiGgqY4LgczK/9mijxDIYwNTxI8Bm5cyDlRauLq6b3PynUTyQdfIY43WVivzo6utfpkZREE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:18:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:18:28 +0000
Date:   Sat, 4 Dec 2021 10:18:22 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 net-next 4/5] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <20211204181822.GA1037231@euler>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
 <20211204010050.1013718-5-colin.foster@in-advantage.com>
 <20211203174333.074d87b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203174333.074d87b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MW3PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:303:2b::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW3PR05CA0018.namprd05.prod.outlook.com (2603:10b6:303:2b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:18:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e7efb27-9ffb-4786-b14c-08d9b7527827
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2061330CC41322D6A504A974A46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: odxQ8aRijx4NBYlLgtyXmyV7MGj/6gG+M6wmwpz+xM6vs2SvcNY56iur2as019/ynQJdQSPVSCjHGFxXNQDIDyOnv/iqTPOC/2+clI5R4YShwJ7sS5Ak/7aWY3kRiNSAgvSK1Y3DnmG474AxAUx/49w0OtTctboBdVSOyn1vcfl/wzpv/inaHt8Mbty9IA3tCrxUtkLyrOW+/b3NFc7vPIeBTuNWtCfOxHrYNp7qhfnvbje0Fa0X7GsfzStzCuPjLsuecuoaersUsIXqyh9BsNksFNsGJ1qqTDcizrlkhRkniaZ9cTORm+7zHeb5ID/Qn73e3Oq8KYa4dOxyv887Ai4gFARqznyshF3e/XsMFCzODWHwhVUeuAUKDR4SF8KepxJunRkK8zZuMv2kqNp5inNQUt3iPXzAHx3xFbZ9EepxAhnNJYFg9fSo2fQIWqQqS7dLc9cBuSlHudGPbUsA/xxu15Eg2+9zOGh/ldGeqxeCrggsEtDc3ltps/T7YfoGwTMCTXObx+NT00ADZNlaRxdApQCpgUUdoI/lGT7vTxdp5LCBHfPDWSN8iVZAClCxhUX8Ak4F8FTPh1qGay5G41S35fzd9N4I042nfTgJIxvvpUoGYSzC1w4UEQ6lvj71DlX9CeTCWUCXEHvufbvcUlthjOUO/ANFTOU5imKNHFX070Hq23cypCxKFw9gFy75awYOJSKIhk5Sp7TnTbJ3CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(33716001)(54906003)(52116002)(7416002)(9576002)(2906002)(6496006)(66556008)(8676002)(26005)(186003)(55016003)(66476007)(316002)(8936002)(4744005)(9686003)(86362001)(6666004)(33656002)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(1076003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zxHEbfwV7oOIatebMchC2KvNbQrmSSUQInvL9NYDI6kHjkVESuBDV91ERl+Q?=
 =?us-ascii?Q?U2T85LqO8yulQkmmyo22Xe6WbuFzeAZhsATTLg/CqzlqzF1VG9Gve2xJkyHK?=
 =?us-ascii?Q?yrpB7vDQb+R36Kk911AOHES/v2o8gfgYy2M+ylhQNR5qYOqKbp7fege3axwQ?=
 =?us-ascii?Q?QR0Ao0RbjTvGGDpVPYpyHdnFqsQiX2uLgfG3LhNNPUI3I+QLX1hq7J+bGKk3?=
 =?us-ascii?Q?tqjKOMtSFsQfxEKs9PWocdkVD8623ucsAPGZj8ZYzvrBxqIG0570ggLXFJ1+?=
 =?us-ascii?Q?bfK+2fdObyW7nLGoNdeIHJzD4uqK613kOMnpAvK/Kw8D71Ws3uNqhMmgfz8a?=
 =?us-ascii?Q?htaoUNnA9maWaCFlS3kv9n9E2arflcnp4uSK3qFcl4RrtJgPG8ZlxA2Dx5HT?=
 =?us-ascii?Q?BJKMf1wiXANwXo0riW02ZteSbA+J7lfJcRsnC78WT4rZe8dAJrJnQlq2q2Lz?=
 =?us-ascii?Q?PrnF0MPMQuRI0Tnoj8vV4sMXcIcc7H9XIALkfFG3UWEija16lEfjcOrPNf3v?=
 =?us-ascii?Q?CJ0fy8dICnkP39s6zsq2c3lpPz6U/lXerqvzaBS/opbXQ1L0XhD1HFCg7Tvm?=
 =?us-ascii?Q?AW/Z5KhaRNjZFWP8EFec/53ImqVKoM5VTsWqxDJKwLT24oDOyIeEIEWgkbQT?=
 =?us-ascii?Q?4U/dvdrhQ8rB2JGOgGDi1uu6vLLL3SbcjX2YRGL8MHYeLF24GSCM1gWFg2A7?=
 =?us-ascii?Q?rLdhCsnbNicuF7xWBHyoShtTaDGCMEMSJok6gmbp/f6YsO2voyJiTkQ+sCJf?=
 =?us-ascii?Q?21AJFqXrKOBTcOglTsYNtOFLy2aSs2yMNVW63cq2ozfaLs7CJFfoiwkxlD1X?=
 =?us-ascii?Q?6hfCrMonjmt7F0W3HIypXfM/hq+4V05m1/NwRfnut5UTH3mOKj3/LhstyQV3?=
 =?us-ascii?Q?LmA2xnNuLmwHheEYUeBVgb81Q8gpCs75A61VUEY4RvMRajhge72eGryepZ0A?=
 =?us-ascii?Q?x6NQoZl6qKWzJzPtCBrNDG+gwwXESE6XI7KvUEtC6xLnE4wVStgRFdQ+amp/?=
 =?us-ascii?Q?TbB5XAbpP4DeYt+ObyOfoHz9pT6zlFakepbXAUyKl9YAPK5r7HQ+ndrYeQoi?=
 =?us-ascii?Q?74+4Xv6d+7SNquBLIn982cS7neMOPO+0p4Qx0OPVLuqlzJZLW77lWLgC3nfP?=
 =?us-ascii?Q?XqGd8LfH+gO/RY/Ck0tf11bZdifNdDjP47wpl1LmNJc08E2wo9tuHSK8p+En?=
 =?us-ascii?Q?r4hVOEVnrnqX/RJiwMZLiVbWH3w76Ts3m6K7tJczpgL6BVX1YOYSSzd+nc5H?=
 =?us-ascii?Q?u8oU+zchOEzblB6aEPLV1lzDONxV73lrMvRS3NAJLwdmkygYcPB7jORAHdLl?=
 =?us-ascii?Q?s1gP/olNq2EncmfwRON5uytnDYrqvtHkqL+JnINQnC9LblKqysstyEYGHHjV?=
 =?us-ascii?Q?YlvfOYzYO90ov+W2i3HCSmzYtu5dt/H9Q+NGCD24gU0VszBFqrIyQHRqI+Ox?=
 =?us-ascii?Q?jsVwEP0CK8oLHL/N+5I+bGKuAMbLTUm3yOpu+M9FRTshXHcPORvVQ+an/IZK?=
 =?us-ascii?Q?eJvjA+Pv9B6GekKi3WPZmMHpDmVF8+1kU8Ip6U2sUWIDGor9v4eU7G2eWblG?=
 =?us-ascii?Q?20T0ZuM7zyZqfVusBjEkBn8wB9dgjKqFb5VdmJZEK5KB73XGnNsZyNG6FX5r?=
 =?us-ascii?Q?itPn1sHQkb9ceyMgF17XStnGX+cdLESoUyA3zYcuDPcHp8wif44WEIFOSebd?=
 =?us-ascii?Q?MyTRScMwWl7KHaCRGCbiUN6o0pE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7efb27-9ffb-4786-b14c-08d9b7527827
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:18:28.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHok4yj8Uhb4mEGrKZZpADq7NG9TmmzuZtfPQEwsKNj1tKzeWosFz58dsHv/Xgp7COkGV3QUAw9MlEoNz36Hw8gmqlWdJ/L+U6CE6/07n+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 05:43:33PM -0800, Jakub Kicinski wrote:
> On Fri,  3 Dec 2021 17:00:49 -0800 Colin Foster wrote:
> > +#include <soc/mscc/ocelot_vcap.h>
> > +#include "ocelot.h"
> 
> You need to include <soc/mscc/vsc7514_regs.h> here.

Good eye! Sending v3 momentarily.

> 
> > +const u32 vsc7514_ana_regmap[] = {
> 
