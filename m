Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE26D4E4E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjDCQsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjDCQsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:48:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3929119B7
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lI5/FUAqob6KZCX+eGDGIr/R7EXfaxKCOi6CiXm58/rY2EUxrHUgNUKAP4nfZnBW3JyKmiqTLvDbI5WqmOF4gZ1tDMGBeIEtEGmjk63qZvbnwmtoqm6r30IQwgA9yAwf9nv8EB85f0D6E/a6ubqIuoGqQhBZAohlfzZnMgoCA67fGum7RpKuNUOKn3G+7ghgwiSxp0riCoZGVF3gYjQ4ccbS1YP39ghLIl7OPOYJOF3XywuD2GPCXoqliDU0HKnbee4KG9hBICBITkFBcBPPB3qXMB7dVQCB/k+zwn3Q8YWtLzXZmCYmsDtAcxlb34pNzoHGRQplfpuGftelqjkv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACMQOVw6/+9N+5dCi4i3iwSt/CSzcQEiP1jnz4MyNI0=;
 b=heB8k+js2nvMoz6DP1z7lIeZcMYpWGvI1DSzWZ0JGRQCh6spqHGidCy2nJDZIAqGMjg94PZXoCx9SpmKB0qi7lf0SPZobrlOX20dk11W+acihGrFIGaGddiMa68zT2RNzGc6JZrDh6OcsFcghudk15mSNIbMEuG+gGxandiqQUkBEgmUsfK6iu3b3BSHQq583R2LxVJXsn5JHPWEUnQN2kNmaUkg7h8Zo5sI92zrEiIWBuPdy+zBuEcRI6tsP+bVISpuAd9fhysX92K/b/qP0f0TnwGFSZ+taO9NZVbEHcCFsDYUG1WB029UTCYoTHVHexN0doIDzcoYBkWd4q/YxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACMQOVw6/+9N+5dCi4i3iwSt/CSzcQEiP1jnz4MyNI0=;
 b=eeE7xjWN9cezMHgmzbAqbfRISH0b0EnPMepVFKuXeJVRmWEHpG4OrOEXvCryh8RGf9z67Le8BAkc9mt4sycmQi4oZolztExkNJ0ORrb1EKjkegRaN/Dl9LtDE1Vy//lRiWGIPwzNWcsE54AVCyvmDMvuHYQNnvG33wmA7r4EqPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7557.eurprd04.prod.outlook.com (2603:10a6:20b:294::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:48:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 16:48:10 +0000
Date:   Mon, 3 Apr 2023 19:48:06 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 7/7] net: create a netdev notifier for DSA to
 reject PTP on DSA master
Message-ID: <20230403164806.23ui4ghljau2xhqx@skbuf>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-8-vladimir.oltean@nxp.com>
 <20230403083019.120b72fd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403083019.120b72fd@kernel.org>
X-ClientProxiedBy: AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b5b4cf-ae92-46cd-ac3a-08db34633516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5nKbp0QoYxNSj4YjEYi6wlUbVArZW1/lOv9QeXp61rZ5vf01sVqpbDoUb2ETqIpR9MXwOc6kTfRjHxXuDy6CRNN4wVvG4O078LfLOGzqHDYhvLisn2859HLj8FLVrrkSqFhcwlnyc+9ZSeawbfqBdWbjjmGIRpU7I1dvwRiAg1SoXciDvhLbnbxCltWP45e0E9qGwjfvgZz5h3AMvFdrCOfnie/ClxBoQSfPvMNo4BLf4NsQoh8AmjzNrPQox4etn3iUPjKgZpawO3j2WkSmM0MO/y5OIQB+hEqShzsA1Dy+QQtghJAO6o1EKPdRFfYHBzHYB0NgA5iPmozY+ZX+3cjIy7IugB5E/Hh/hgK4n8WbpckSI9HGo6MjgoxEyys7eAcdseC/T6mbxu6XKV8Mjo3tBAdhYrWIqjr+YHdBMQWetEBcQBIKYUAsR6kHHpeyELAoUa4OWxItPsmSDmebzi2MPqGpGXNk6eFrPkFoigHJBn7rRXuCMwjiGO3ktwBI+OT8sQR4hPn88eGdScTXcVoNL/vEs3SlcZ5ahwiYo8KOXaXFmOKHBm31DiGBj9L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(86362001)(38100700002)(33716001)(7416002)(316002)(44832011)(54906003)(478600001)(6666004)(66556008)(6916009)(41300700001)(4744005)(4326008)(2906002)(66946007)(6486002)(66476007)(186003)(9686003)(6506007)(1076003)(26005)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aH8wEkVYDaegwCT58bGPhWzD2A/0ZsD55uGA336G1n55ug1QTc6hP62lN+Dy?=
 =?us-ascii?Q?UngGrDDawPI+qDlVgentcFVeftWvAJlq2oxQuMXPzDOH3vlOCFfJZ6nZ+uIZ?=
 =?us-ascii?Q?Rc3edtN3BbOztgtdc9dOxPKSc949bNHGVUHAkzChi95fPcHctk9kI7hJgLaw?=
 =?us-ascii?Q?tJ+Yu9G9QRBf7/ZoYuU0XBcc9ZcpmVDi1fP0yh20x1jvTx6KyUI7HYUW8rNV?=
 =?us-ascii?Q?xxX1QxuvWsHuFwAfuCxFY2Z/nayHcz5y9lYv8h9SQh5Tiz0XJploQYG7hf0U?=
 =?us-ascii?Q?6/lGP2+WBaLKGoVhNCqbJGJuXsR5q1gh6PBTmLd85UaBDWpV8OOTooxL1OXo?=
 =?us-ascii?Q?clCuKuI6mAsoF9pmq/D0soKo+pSXyaLhOzHS9mx93ea1z6bxx1Ece1zQ75KC?=
 =?us-ascii?Q?n7s7YGx+oDq6BV01ZNKkT3PYARxM/SjsRUkK1GVMKVbStE74KI4n7J3BsKDl?=
 =?us-ascii?Q?udhtXtSQ7FbAW1s71nVOZ4Zn4192b2+GODfWQbW3YbXcW51/fToZO9Utb67A?=
 =?us-ascii?Q?qYhNi/aO8s+Eu3TpOVvHkp3prYxXI16i7hXMn1H+x/6mk88ok1+IRNODCPbY?=
 =?us-ascii?Q?V6cbT3dBGTbTilSpfRZtmYb7KmQJyNiiZBQSmGKomc0biHj/B/IyXikJc8E4?=
 =?us-ascii?Q?yVfYviC5+OjR76RAN1Dm+9I1hO2lFHpXsvIK6W3n+496FK//CfkfypiRYfA4?=
 =?us-ascii?Q?3hVi3xnAlZO0TKAob/8yoDJlU7gGQAKulIo8AQwqn1SrD9qTHNSQ5aCBzcov?=
 =?us-ascii?Q?ZgeF6Gc/nXwd15Xf485Dim79wbByh5K3uP+QVZK1ZeYgsZghC5Sghbj9FyfS?=
 =?us-ascii?Q?3x7Q7ITu0XtXOIU+zD8bNOSI4ucLWwhQmUOsHAZo4Xevtd7XSAfGtwZcqRd5?=
 =?us-ascii?Q?tcB21ypnc9u1rq58DugnXcwdrDcK++39lhmCYE0NBf2K8plJfvxBsNjWbDTM?=
 =?us-ascii?Q?xcSEH8SwaGBZ1h8IOHfJWRv5/3AqZLZFDrEC2RLOwDVELRN58cpOMpBE7KZ/?=
 =?us-ascii?Q?QNl6ZkzYtCpZquTMnifv59lJaun4fcRXFkPuSdyCzs15ohu9bI9vWK2tzkhh?=
 =?us-ascii?Q?kZzyvrT1Y6Vmb/6nNVOSAz7jvji40vePw8MyekgOrZtyyMw3bYNTH25NHc3V?=
 =?us-ascii?Q?HYMouJyTu/bbBM/JGogWyMTfUCDzR7VGUZQ/kWDQ7EHTUrhrsePgvq61m/zU?=
 =?us-ascii?Q?dudHIaGuyDehDsMNSIROfv5KGUFvYoo5XJTvbDNB/fRcVj2kHaj4B82T8PiR?=
 =?us-ascii?Q?MdIUjMoDECIUhnbNYtg4dwe4bPWXVCvbs6VeG9hcp7u2Tq12dPiqnazf/cmp?=
 =?us-ascii?Q?wLGjT8nH1MvfVp//sR9L3ZFIjP2qEIctUwlH+ImHgU0XBD6lfVf1nPslztZ5?=
 =?us-ascii?Q?SBZj52mTuSVU604xu7R1PM9ERTJG4aXxqw5IUFusSlgWjYyr83uS5DJAt7XS?=
 =?us-ascii?Q?ZuN07xvjNdJP55qPO8a4cP7FMdSTNg813OGfUoc/ptMGAIGmLmLglFCfrTUM?=
 =?us-ascii?Q?Su63heApgU6gWD7APdvDr8XNt/0cFQDP625eb2K3Z2wgtChqBEV6LGBR7hpx?=
 =?us-ascii?Q?dQ0bJUXnYYKlQbordUbIld/Bmz0kkBJ8QpblgkqO9R+iJvyrT992Gb6Xbm04?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b5b4cf-ae92-46cd-ac3a-08db34633516
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:48:10.1513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JL8zYJT73iL5nhX+/bW6o835N3EleK7SJw15bj24nAZ06GvxJfUumU/dN5zGhVCk28aB2DucSMTUny1ymqkqbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7557
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 08:30:19AM -0700, Jakub Kicinski wrote:
> On Sun,  2 Apr 2023 15:37:55 +0300 Vladimir Oltean wrote:
> > The established way for unrelated modules to react on a net device event
> > is via netdevice notifiers. So we create a new notifier which gets
> > called whenever there is an attempt to change hardware timestamping
> > settings on a device.
> 
> Two core parts of the kernel are not "unrelated modules".
> Notifiers make the code harder to maintain and reason about.
> 
> But what do I know, clearly the code is amazing since it 
> has been applied in <22h on a weekend :|

Responded privately.
