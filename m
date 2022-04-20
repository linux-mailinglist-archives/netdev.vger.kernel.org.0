Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0EC507E80
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358767AbiDTCCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358762AbiDTCCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:02:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2093.outbound.protection.outlook.com [40.107.244.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73001BC05;
        Tue, 19 Apr 2022 19:00:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4bRNBf+RFPiIOSxJLK++f8r7m1kiU62TGOUZ8FNcQR5iAqf2YACqza8/JtpIc6xqYPts8JsV5rnkO744VDuHw5V1ZsIDy/uIW2BB0KA33dZSGygLEb4JY7Z5QVuIkXCxlEAy27a8UAYvLPcqQhLW9kVNLtgeHk4dEEXGZ59aQ8oE5fwLSoU864xIgcuSCSxesUtdeHAWLGR/Pe/mPq9K3y8wNqgfSb+bI+iPAy9GKaW1Q6V6ohGkcRMfBsuAZ9gaCadCrm6DTuTqZLMrbrhA5VS+a+w2iLS4+brqpZNQIvHEtkCHoLybPcBA/ftU5hRDE0VhKvHEHFFvEPc3nDA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kjpU0MDgGdK1g/B6xTyahbRRsgOMiw53O50GDgbVJk=;
 b=FBw80OVj32ndS6S2mppx8Cq+NCbawKe04G7FyDUpKL7RGnQjXU0/IxlL62V64aRMX9sOoL7emievFwPC9WFpLk+aUhpwQqjn8M4Uzz/z7QK0Ltw4v4A8p9ZyNO6KbEd41tDZjBs6u2GUt5UnWYQq3xBPWHFAnAgOyG9GEtHWoudYBFj6Mb6oQy+/4NUibY4ZQkiPs7VY/TFyGCe3LMMQk9N/091JpmneXJD76XjT/oNzqszlDsV+9bVKd3d+f1tD/la4OuiJeyQbfHpBakAAOM69bG+BGr9ZGCXDZKSHveJlH40unvQaGvIYJQYGG/Sc1CL1fpHZyKsHAGDbGeQdhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kjpU0MDgGdK1g/B6xTyahbRRsgOMiw53O50GDgbVJk=;
 b=NHamtOI58k8WCDuQKtBImMILXNc0cNL2LyWWETbYEFufFClSy+IFidJBiF5gzTcM//sduekiMSEeRWbSn27hkR7IlN/HklPc+maZ5xM454PHZJYadoPdATO2g++f563g6mNvrQRus2zJv2MeScGszIT8/TImlQZvMjWE/Sv1MtA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from CH2PR13MB3702.namprd13.prod.outlook.com (2603:10b6:610:a1::20)
 by CO1PR13MB4949.namprd13.prod.outlook.com (2603:10b6:303:f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Wed, 20 Apr
 2022 02:00:00 +0000
Received: from CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::9d2f:9b88:eb97:a9f4]) by CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::9d2f:9b88:eb97:a9f4%9]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 02:00:00 +0000
Date:   Wed, 20 Apr 2022 09:59:52 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Message-ID: <20220420015952.GB4636@nj-rack01-04.nji.corigine.com>
References: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
 <Yl8w5XK54fB/rx9c@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl8w5XK54fB/rx9c@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK2PR0401CA0002.apcprd04.prod.outlook.com
 (2603:1096:202:2::12) To CH2PR13MB3702.namprd13.prod.outlook.com
 (2603:10b6:610:a1::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db8ae546-2a04-4c57-99e5-08da227179cd
X-MS-TrafficTypeDiagnostic: CO1PR13MB4949:EE_
X-Microsoft-Antispam-PRVS: <CO1PR13MB4949B66FAA8C363B92DC1FDEFCF59@CO1PR13MB4949.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgR1VQ35hpSejPkPJR7+2/N+pmYc74j2ySWRZQEI1nVgB46X6GTvvM5t7QoKvhvl7bViHb4WS2AtsItfUJOjDU8C36xcwldjKD+fV4TxA0x8qxwtEe8qr0RiIyal1xDOtsR/SMC/fs7KTUTMofl4p/gVNnIhqy+2XbRPR+EXxWOMjK5ucBE1fYUgBXgChurLtv3SQO039xMk2ZCtG5DseE+9e3Xv4JIiB5tV98eEyDgmR78Nk44Kul+3qArCZSa0vkqdDn2r+oSON7sZPDnsjVWsbweTdsUcymzE6xA0WYOxVy7vSzu/JOPtDopZ+BiXjIE389ISNj2sUgwVQjwrGtwAqOhqYu5vDflE1K+f1VkFJlAcMuo6ALFcNF9NjBeGFV9kahsana/iAQSqbY05rl21y8cHjGWKt/mUOMaRdPtjwfrDoVCNtBKpWHTqiy37FATY862aLgVrqh26WAsJMJRzxp9sAmGJZIXKAQHE2ypfxhqDg/czwolk3HYtE7e/eR/29tjtgV6TysLpAu2pfgsW/JdpioDnyXkozhaDie2408q7tfOgPaefEd0bxB0o/E0tLV/ZZhmaaIvlXL53oFPes0+Pmnchw1bPKLxiv5KjMpzl94cFqoxzO+2yMQx2H2iXaxJWDMlo5wMGTYWH9nZ+bNJN28BFdgZilM08RFPzQKDTblP3fOdS9W2oQ+s7ij9leadSs/IaXyYVY4SMbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3702.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(136003)(39840400004)(376002)(366004)(5660300002)(316002)(6916009)(38350700002)(54906003)(86362001)(4744005)(8936002)(44832011)(38100700002)(66946007)(4326008)(8676002)(2906002)(66556008)(66476007)(6512007)(1076003)(107886003)(83380400001)(26005)(6486002)(508600001)(52116002)(6506007)(6666004)(186003)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bg6G7upMfKVZ+wWE1GdBaFFGrzElOOxSDmYJH/9jDAzXgF0qYroSb1lzUn0i?=
 =?us-ascii?Q?sdcq81okk0xqNGxTGjI+r9GyJ6cWWj2mn99QQWZct8ymjqg+q1MoljwMqJh5?=
 =?us-ascii?Q?vWgYrw0fr/0RYcJkca53bhVeZ8cDER3gxcBq3PGop8QV/qNAOWKDRRh3rsG7?=
 =?us-ascii?Q?XOxg0HFMlzBduouKzGQ9w7xaqD1qGS/2vfsJEUI3/S+KR1XO0ggR6ESLzx4e?=
 =?us-ascii?Q?2h8X7zLp/1KCP/qfzsM8CjzVJj0aSpGRT82He5ny9FURjcots6arGjddSe5E?=
 =?us-ascii?Q?rjCY6TDKeuWPNqBICGDlAY6ibe+6gPNhY2tpLTzX2JRI+isOgID7r7w3kjxE?=
 =?us-ascii?Q?JjtrFjliDzjAJeH7WksrfJYs7+RwLf7gDL2CpGT9/AuQRnjOJF3O/bsDpWLq?=
 =?us-ascii?Q?W0rKxVXuTH2wbn3/TWUAX7xULflL5wPzXKx2rUB8xem98jlzeqiYkfS2PNqO?=
 =?us-ascii?Q?vQCjXW19wt6ZFuLGXDQzVMMvpF6Jp09RQm3SLRHIgzMkczSzhyJvmhrACW+v?=
 =?us-ascii?Q?usoCH8q7O+izDd3Vs0eJLo1kiGGhLHj/yDay6ywONJicEnLbsxyLxyyVI5JR?=
 =?us-ascii?Q?unMFJwNPH1yvg0lL0pxNPvQZ12szIPh2TO2zqQ/U440tm8eMuOPgVhxV+ScY?=
 =?us-ascii?Q?dTfOyQOQGwRBqkX3cFIlkbie3e54v+YmyMsrUI4pSb6remO89MPXiUn8BznO?=
 =?us-ascii?Q?HPeYtIdhDoDXOIwDOlxCSsjYJx74o6vko0LVhuokq93k8E7XbWE+kaXWpobk?=
 =?us-ascii?Q?Ad+4U2MfslIRD+6Klp1pLJraWtH8p3SdMLlnBFv81xQd1XxkCIqstNR970mh?=
 =?us-ascii?Q?zLQSxiaJ5HFQ0hRoLsXS+Cf4UV4uKqDjFHq61SHYK4I5su6dzF0KVCDHVcfS?=
 =?us-ascii?Q?skGLbEi33NTVfN4O4PoGsn4en5vCnmiEn51Px4DtNwHn6hZhRQS1KvK4/JIj?=
 =?us-ascii?Q?ayCouaMVwPNkHpzXsdXotnlE2yXYKOZEe5RwlOhaWa0WOxLwjiz/V/snCRvz?=
 =?us-ascii?Q?BuP7DA6sVHBND5J7vgS03s2GztapuxYr/yxIvP8ohWjH1gWRfFmfP6yTB96i?=
 =?us-ascii?Q?MPAB5iBKArI1wIkzeFhDU0dCUu7W1zrbZM41jMHNg01VXW/puG/x+j/XG6pz?=
 =?us-ascii?Q?0LC/o2AIJF1wCvm38FX+O/QmRB2dN6qrt9Ng45JV01A0cST1TBsCivZiPMF1?=
 =?us-ascii?Q?pdG9qDTx4K8zp4yZQxTvs81n661mgfpFe6XvJCJVBoD4HyNwSMoDxzW1bDeS?=
 =?us-ascii?Q?lLdl5yuE0SrSQr/EYbfjZ7hWzOxDaJVhwLPlRVsL8q4ZDsk08DcC5YBxpCHx?=
 =?us-ascii?Q?axdKeaMOzO6vOhhyd8GxM8AHKGC0h4B2z5EZvlcOo3Ng1sMgADgOqVxc+Kqc?=
 =?us-ascii?Q?BlfmqeD1nlK3pUm456z34pK4HOEpQg+Fms/oUem0w+QrpFXaFm90y9ye6qra?=
 =?us-ascii?Q?ewJwY7UKcZxbwe8qrv9q9kxliRVkO/n/i4+Xi9UV4gNzKoFD77bsxc/G0zZB?=
 =?us-ascii?Q?ZH3LGElNveDm8wgwFBg2aI2vUaaULArifi1DEYfl/CKkoNl9FmCg6ytgh02T?=
 =?us-ascii?Q?3n4IL2MwluGGB3lE246ofyGh9INTNHeH1SCWB0Kl8K9ND1qRWkgWrSx6I2dn?=
 =?us-ascii?Q?Mg+set0vOR7wInCj/8Pot/02Z0+3pIMUuVN2OpC39n2XBLZsVq1b2mwqvSFc?=
 =?us-ascii?Q?3RoWpABpxy5Got64qGGDCQl6oZSfZgguMzysYtjT7Y4qW02W9pdZhAKYkJXx?=
 =?us-ascii?Q?Uut3TMnZ9zfbnjOgtLaCz3XOzIHyiKY=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8ae546-2a04-4c57-99e5-08da227179cd
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3702.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 01:59:59.7741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eph+kw3BsPKzAAvXQilbISAbMec4NZwJnsw/7U1f6e/ipoeOiXbnfUrNAXdsVVMAygpTFNxfHVnKCo3RzfHvne51sO4+GqUAbgZunf0LAvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4949
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 12:00:05AM +0200, Andrew Lunn wrote:
> On Tue, Apr 19, 2022 at 06:02:48PM +0800, Yinjun Zhang wrote:
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: linux-pci@vger.kernel.org
> > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  include/linux/pci_ids.h | 2 ++
> 
> The very top of this file says:
> 
>  *      Do not add new entries to this file unless the definitions
>  *      are shared between multiple drivers.
> 
> Please add to the commit messages the two or more drivers which share
> this definition.

It will be used by ethernet and infiniband driver as we can see now,
I'll update the commit message if you think it's a good practice.

> 
> Thanks
> 
>      Andrew
