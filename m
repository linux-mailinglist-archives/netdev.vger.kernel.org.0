Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9156F6BCBFC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCPKGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjCPKGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:06:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2121.outbound.protection.outlook.com [40.107.237.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59E9B78A3;
        Thu, 16 Mar 2023 03:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQGv7Vg5miRBCVeShwGh/FiikIfi69VZpDPvae0SED0E3aQCNScdjPU9jTq/vi/qIwuYmyihwFoFpInb14KcXV8iokvhBcU0A6q0mIeeUbfU0YpCiAYqy8AgpdoKHeNiN6wz1Xq4BvwFXoI5eVfTy+MRKrZJiEcltDtO6K54/55pmXwjm5XVcMxTg9328FOJzJA7UM57JuK1lek06YKHTG+iJFBzgUHfco4UwqQKXbpvbpyNK3W9cuJnnMI0D/hxhQsU/NRN6OSwK3f5cAUMUg/iZsCHFcFAfQLyM/zI7reYYneEnBPjFOXArSbvqu1TvsQDedXgjKCyyXhcQcKCiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWDS2xX6gpx6orfiDLXNAh/DJCxxEgGoeWwlxaY4KUU=;
 b=XQXG102GKU7272brZp3mGuTJlzVd9Mtuug+pGHCkwya3r9FOGkRC7Se/SEXYw5edeuaT2jwbAprJw1/otogGuwlBW3aliyDL7U0Z4B3aGYdTn+QZC3aH9EDIq08Vhp4lz42aNXdgMuNE6UeX3/GgFjGD886Tm/rg5Wc0PDWF/MKBPKf1b4eQlEv+awIVZCAEh1V8qZKRHJUtTt8fuuduGxwi8UuR3OjMj6PxiLzwiCkZ88tmKRA1W+smRWwch8iaRcIQNbMg2Ceq3emUJwo9v8h/Kw9MHBz7G0xuU7oX76jWpLwAU+bPZtmC8Ym0FKzsoDET77hrSulaEnoSyddJvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWDS2xX6gpx6orfiDLXNAh/DJCxxEgGoeWwlxaY4KUU=;
 b=IXUDvsHNyeGWWLs7+HcpCznyAEzGaeHHjrrpBXLgkwU3bqnsp33W2a5o2+k3lrwYF5hvqB/ov1QBJsbe0B4beVYu8ZBmDWBTY1wDjZrjhh8Qj0DWQudkFlSrX0tFX602Gc2N+v1eJTDuuQ8ep2L7lyFng4fbnBdn216CE10cOTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4066.namprd13.prod.outlook.com (2603:10b6:5:2ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 10:06:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:06:05 +0000
Date:   Thu, 16 Mar 2023 11:05:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/16] can: m_can: Implement transmit coalescing
Message-ID: <ZBLqB1FOrQqZluoA@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-9-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-9-msp@baylibre.com>
X-ClientProxiedBy: AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: ef9f92f6-94a6-43b2-9002-08db26060e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9og7I2+jaCvT0MvCy3TSVKlfw3cuh6pZCkXom0i1azbczBQBmYke/PMSyXwYuj2nmxPfVpWF0lX+FcqeyjdcyfeB4/SR6oThAFxy3cf2AmSPFGlMFjf0rfizW56yLD7NlIDqCQv/5EQY0D1HBRCJYX/qUujPUyoz5sYoxNLAltiqgcm4QuuyMOKX1dHt+L5wZQ05+RgdOyavYGnf9Hh47Y/UqH8CVtUQK/s7N+otqR/2QaHgiK7+gcN10zFLdpXdrRS8XQsRrNxNP5cG+faBX5X7OO4DDoEyAON5g2bmQ7ErB65ZNSDNjVNNiWLZknBIgL+4lV89GTQmKUmHq0ok1efXFPgQXdXj8r5rKOaGz+IbZEDKFksNGARxe9YqTGjWo9LtOiqc/FYbItbOGxmdwp+9OL5EiZKv7U2sy8iBEGfMmJgOi9/j2OTHPhHbkHiXh+LKgbDfRzwkB7scX5zIsrDxGAON7PeHqeMA1XTbuMDWGO7uJhvPJPXCJ9yc6A08B1kAfdYYkYsKcA7xnIa7KfqYlg9w2SvNSmehatSO5yHY+ysu9M9qnwEgKjSzD2OKdbP6khgVsltVR0UNlNm7aFNYJmboSZSz3ZRcIZugdX2V74qCBmd/rHPlaXs6IHN5p/SyqdSBckxbxZhn+9ipQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199018)(36756003)(44832011)(478600001)(2906002)(186003)(316002)(83380400001)(41300700001)(2616005)(54906003)(4744005)(6512007)(6506007)(6486002)(5660300002)(8936002)(66946007)(6666004)(66556008)(66476007)(6916009)(4326008)(8676002)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzHTGaUtKpSQnnFdKtNAxM3XGQdY5VXzXZg06oP+vmmJWrmcUSm2YNBPam/Z?=
 =?us-ascii?Q?LY6bbrwfke/AGsXeIoHo+YZ/+o8PnsYzrMveRw3Seuir52B/IXxyyKemwPRc?=
 =?us-ascii?Q?Uqxi5OXdx+SML/0bHLfcjiPUYdk0Ptx23B7DZysn+HaVVUO8ebL7kcG6nkyx?=
 =?us-ascii?Q?a8kf1F14H8Xv5Zqimaw+sluPvixmaEFaOnc/4jCNMJTwrQiJGtFVUo/uX6fe?=
 =?us-ascii?Q?j0pyXt3C/jAM/LmVOe0ecJ9cR4VI9SS7qN10KqNOdRta/idxoESduagu98eC?=
 =?us-ascii?Q?ToRDiZ4zyM52ykVZs2j2xfcLKxdzYhp3XBM+haCeoGChLpT0tp9rLYG325uT?=
 =?us-ascii?Q?rWZLvENUvqGvp18D97Jiqz5da14QUzjgsBlQI7417s3bd/er7TeNnk65O7/T?=
 =?us-ascii?Q?A7Tg5NQaZKgMttAZ6bQzwhLOR4UOyEbjuwyecpIER+U9/q99hkhFxuwG4V/S?=
 =?us-ascii?Q?AHWECdJF+HrQ/uTCHqyDYNP1Rn+rOh9PbteBMFYSp1mBK5Y5KvPQe5fR14oX?=
 =?us-ascii?Q?do0IOU7bAxErqqe3mWDzgTESvil8hQHMCjFXKkagDelz6l/LdYmmfVyvvu2z?=
 =?us-ascii?Q?p0IWtq4q3bfG6upKL1VhnTetYBLPtwY2l1AC7+J8WlqBhD8uKWwuWaFmnZqE?=
 =?us-ascii?Q?HxZmLUDYj/NXjdWdL6xsKKZPFJoLfz32lSC5CmupmhSPZyBMdD1i5CEIytvf?=
 =?us-ascii?Q?LnhUe1YGh/BnQzjykjuCIBWASs0L19ZZuqaRVj6eYDfAMKmBGBXpSF9Juhrp?=
 =?us-ascii?Q?hWq1WazL4Cj6BYB4dExe5s63y5KIWLx1l57bE37zX7xUPLa4zUoafYZrbKE1?=
 =?us-ascii?Q?RCnGcvTb3Q5Hr8aLm1LYZQxUt4lH4vt0yEzWKJQn3A9BPNtpHA9yN82jbiyE?=
 =?us-ascii?Q?JZ69OASO4hmAwPBLqb+6ZHgyAwAlix59ja+OVwnv4cOnSjR+W4UBkf8cPunc?=
 =?us-ascii?Q?g2dRB1N74kUxdMlpac39U+5e9huYCUdIGbiHPXQy2BBS/o0yorYsYLuOhBrh?=
 =?us-ascii?Q?neVPjdvqogl/4VChBnKpw2iQnypAh3TFR86CXqoDY4qVOFHp3MYutjuhvomy?=
 =?us-ascii?Q?+WfuW13zuABA3jIQKYzGn8YTW8QurxcdVZcHnBYlipeLYr4OLV31VMnZunY4?=
 =?us-ascii?Q?Eyfyzjl5ZJhDnVtHXnizMLqVR0WsM2h+nAPyMKOKSdDtZL8ZxwtOwFF71kPC?=
 =?us-ascii?Q?UQ5dnOQnuYYJpEhDbimIrMyC+nq7zGeHPJwMYAQYDJdz1Mg6ae9IWMZ8J63/?=
 =?us-ascii?Q?85EfCySG/mkgJ/ERl+IQvJ79LhWLPIkKgZgXNpxaNQa2fA9cwRgf3eb077FV?=
 =?us-ascii?Q?2ut7TTO0b6gDzoTDNTWcBs8l4XDDTf5jhO1xck3lwlgIkpaR9EgqxVo9q7Pk?=
 =?us-ascii?Q?PElZvNfc15JEIiNgiFFzwJ1yQuf57jAO/JnyfHYKkvD6lKedySjT5bGrdSzj?=
 =?us-ascii?Q?GD3KayDbWpK0K4xzla96BL23OpIct94uzx/keY1ozxPebKRgTs15HL24q11p?=
 =?us-ascii?Q?9YY9SE8cJmF/26AoCsAzU+vn+dacUIHfKmuGGhfuz2n2UKnHnIYsCLXBqeeF?=
 =?us-ascii?Q?nMo+ZaFKcppz2mImwKoz/MnbN9II9Rx6elXB7oipQd9Lh/JVvVAUE2DB3FQd?=
 =?us-ascii?Q?8GMmPJxX3ega/xEVUFOwPPHyf1l8syXO7A7McdEJ7V97R+d9lBZfy/4eDGDp?=
 =?us-ascii?Q?vB7yPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9f92f6-94a6-43b2-9002-08db26060e04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:06:05.1302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6n9z+K/SBAMCtJ6umPQ6mEjoESQsI4SH8zmafp3bj0sF1i8mYGUcwJo6qzEAmudN1pHNmIR0+5Q6wzj0eLG2fdaDnkf0O7BYL0OYLYLyiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:38PM +0100, Markus Schneider-Pargmann wrote:
> Extend the coalescing implementation for transmits.
> 
> In normal mode the chip raises an interrupt for every finished transmit.
> This implementation switches to coalescing mode as soon as an interrupt
> handled a transmit. For coalescing the watermark level interrupt is used
> to interrupt exactly after x frames were sent. It switches back into
> normal mode once there was an interrupt with no finished transmit and
> the timer being inactive.
> 
> The timer is shared with receive coalescing. The time for receive and
> transmit coalescing timers have to be the same for that to work. The
> benefit is to have only a single running timer.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

