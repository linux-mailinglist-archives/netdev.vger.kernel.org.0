Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3466E7789
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjDSKiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjDSKin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:38:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8994BE;
        Wed, 19 Apr 2023 03:38:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBpJEavjfPkw5oUQfZdyPOPnA6JMO2JpcByWLP5DQepyvPgcCrrSbLKzI0cdtVfVev0uakMNYLxUFcEy3L7fg3BchDvLbQUh/djOhKQ9fnOJIVBpvAzVPAclueiDpjYynydWttAp0C5NWM52pUOhhwrpgQtSwiKn1MMUhvtmX+Lqs5kuNQUAMzSblRyS4NQYEAGPP73nr963zvt3/li8VnCooOBQg6zJwXY+NuBlmdqJVE3nOzS+DYt/QGIFZt+SSvTOFHh8SOUzWUT5vGG+PTn4mWJNe3kYtU01YnC+SnL8hXzh3C9A/eC+bigEIHNdcHMnLToyINfdA+FZ87Jfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLsnh9EYk8OxLlnD90fU8UuSi30hO9ajVB8DRARWwUk=;
 b=fwoa/nldQpwc2EwT0mObblvFCrf8UHIKgJdw7h0AwPqDoOaOllB52K4eGmwYXpL7h3CG1mpFLUZKQKY6ouCeMdCKiwtxVRLeLMkqQoOX/dw+f0MQXKgaaqqT0rAwhKn06NdTMK8GBbwOXfE2PZ3/0JyWuyYyk+RM9fV++cWhVxH4FcmCUlxI1RxDgeQKsE8+TR4l28EHNITH0l/gcA47kDd1tdEW8qBnC/qikcfrOgGVVU9V/1Ejdwu58XuuTWpIohmknKZ1G7zGWqACkTc2x0ZC/4gqXQan0fyESv/ZLEMlXWPNeOav5uXNMOOFPW348rmCjOC9urr2zr7pz42ekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLsnh9EYk8OxLlnD90fU8UuSi30hO9ajVB8DRARWwUk=;
 b=przM92VNJa1fw/fpEM43mFAWmURzxKiG895I7o5W4Co1am7LTBzyBGJdn/V/0al2qDtYwjwtwqyjDuQNdVNnXzwiAAGHj7vqaQHUICj0mfqgouCgx+5QUqrBb6yYmyYPMBHqcxsU3Ok/VQl8SYDzW9eLAKpAJydNX4sAWVneNuI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6303.namprd13.prod.outlook.com (2603:10b6:806:2e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 10:38:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 10:38:39 +0000
Date:   Wed, 19 Apr 2023 12:38:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 04/10] octeontx2-pf: Increase the size of dmac
 filter flows
Message-ID: <ZD/Ep3oe5LrpRIfd@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-5-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-5-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: adc72532-448d-4340-2d04-08db40c23c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6e8l9S+vhOxA7t8rkn8eblIGDPG2Ze+WOuK0TGLbmZnyyJapegaXW8xIMaA7twjgHa1B6egszOhigGPQqoDZu9VL1Zco4MxieZZNvR9/e1x0/ivxH/2jpVLmpgoLbA7AgpJi4bQfj8A4Vs+GxUe+DQhG8c52/Mcr/UaOXnvtgE+GBF8GU4NXHY8ts9s3uW/cA0a9pl8+shcIafilAhu9SOoG8fD9VuAkqLKY3uJoTol+twG6itmL7TI7NHH4WIHNTLiofz5/jrugEPUhZrk38XjCrFv47HXBjUd5hRMJdEIrv9epyjIdag+3sXRl8+TijcClTuJzzZgvN+tdecqkHRPAq1+BLcVvMr0uyUU2F+mC02nTWp/lzPBz0auO6T8SGSsWVRDEDEiNrrbzhHfkKAVPkQmbihDxBQT3Jb9Pvt1znULjJDq64JvW4ZcbmQbYkZiZBAv7e8p2o5U9VeeYe6Y+pQInpC6sFJKUpNsikMkG/ug2z9DaVfjKk4FI/gzJshw5mZIR9tnm4Qkf8W0IvfaJoR+OE6Yzo+iEpLo7AYOK2Xa5/astZX75y1GfQlUZ5XSthzni8DjWWZy/2Tyb0hW/T5o3DY3pTHAU6osVgE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199021)(36756003)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(6486002)(41300700001)(478600001)(6666004)(5660300002)(8936002)(8676002)(2906002)(7416002)(44832011)(4744005)(86362001)(38100700002)(2616005)(6506007)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k9wDcJlE6mEvE+yHnnwUBhfPHM5btznwss0lf/mcG7ACNY1ZMdeIAjRP+Gk+?=
 =?us-ascii?Q?YDOonzjy6fjjt/yeHOcGywbMiA8B6lWKYBgA/so3BFcdO2uRRpkKYhyINRVJ?=
 =?us-ascii?Q?UezfpsVkm6dW+AFf4szwaAdZAYMZ0JpgAOiyulcCrz1ZNP+stLOBEMr03hMB?=
 =?us-ascii?Q?FPaCRoPXrawBj91Ps6hS4/Bz0AkICQ9kyFdFdMCt0ryTppvblsZ+K5xV6aR3?=
 =?us-ascii?Q?kjoIOwfycDSJfdKUUcHPvBUht3gqL+3B+B1lXzhSJoIX5dASFiTHux/mYoNm?=
 =?us-ascii?Q?lFSBR50kN7eWJeq+jldwdEslMcb4iBiua3hP2m7Poc8z747YoZol1LTbmv+3?=
 =?us-ascii?Q?3h+j4TN8IJhoAup6O15umsv/9Rv/QYHUDFWKNR1KRLj53LXWxNNVI9i4Ai9w?=
 =?us-ascii?Q?24M1Z72KOXYa2wpQVSHikzeQi8brUdAyupn3/gGwFek2Sx9UX2lCu7daAems?=
 =?us-ascii?Q?8XuMkYDVa1nBUWVj8k0qeVk4kFJB+uvZgevTlMPR15rjpkuJ9X37DBo+k5lV?=
 =?us-ascii?Q?v/2JCnB/+4MeRpoPEJj1xUJ/WcSF2PHxFCX8r69Uw/aRChOYwmKUi8k3nRVC?=
 =?us-ascii?Q?w7zQ2wUbjI64bkgyv9OIbjows3I0jV6Zhl4nqs2aGYHpAVZ+XBmFLMx9W6Si?=
 =?us-ascii?Q?W2FWNwPFSeNejRI3IVik2PR7mg3V9Bvi4hqU39XosgpVYy8pmevxF1ggY9Wh?=
 =?us-ascii?Q?gbN1rhsSw/k0Bqn9blpwEWAVEhYFJAQsTQvUiqis5f4biNos+3SoAtXjupSV?=
 =?us-ascii?Q?MoqdElwUyFvo0mFT8+5+/4DFTXuXZms05jRNtY517kiKRgNqpbBSn/BgmGdS?=
 =?us-ascii?Q?HbUNMJosDcY+m9eHDIlJ4gjZKxXZloiZ3JHvURZiA1/u2LfwUZw+zZAiWzgP?=
 =?us-ascii?Q?fVfKGGkUWFcm/MfRpakGbeho5Vyb0/rfpeLK2wXoGEHSQ/ucCwhVY5uWR+Z/?=
 =?us-ascii?Q?5VNbNMkKwjInW7QxXrlsyhIrTHzJx7ixdeYhA8j26dyogY/HP1GYFM7n3BPI?=
 =?us-ascii?Q?j2gXnfCc2OHyHx+ZR5rbC3gZ4SBYzMQ5AMzEnjbwNRl3SXrq/3iW0XcWMBBe?=
 =?us-ascii?Q?NQVasqOCJum9QvWth0QlqwQnF3QS50ZY4k6qc5o1P1T6CMJ7ofqdjYFtslgs?=
 =?us-ascii?Q?pq6alv8pTe0NW0S/4nWk1ijk2/AwqXgfAGGGSjYoSJAZqul8fk0H+k89NsbR?=
 =?us-ascii?Q?lWdVzPu+BhNUmLU9O6u3qyUL9emKXQyCET8FjUXGnLWL4XSATo7ysGoJWfJP?=
 =?us-ascii?Q?gq04FUWX/YM4zd7brfLH09CDPcwjYwSMlEqRYV/7SfbmvMJwGg3ePlMs2vJE?=
 =?us-ascii?Q?yQB9y+fw1lLy3Eb1tlxG+Ex/+FaDTKcbtOr+eXFzHHmqsoKxk/O4FBsS2iDy?=
 =?us-ascii?Q?7klWdlph5jFtjaIUkfKk0rakxcrDido4Gkr4C4bSTmgigsTQwha4S9n3q/KG?=
 =?us-ascii?Q?awYtalRWnPJAxbML9l1Y8jdZRPpkZcNv8i/WwKxBWZo8C1dUrVWh7RAKPPyD?=
 =?us-ascii?Q?wdwLrAGRLET4KqpRAVHIdFPgAqxxyYoD85FQoQYKHU//kKxovYf8nrD20xBo?=
 =?us-ascii?Q?qjFVTM0gPk8lC/XVw75bVlDUUw1ou33a1UBJlV3vv5Qlf5q2vOlbpXj728UK?=
 =?us-ascii?Q?+1u9dG9f5eT5CWhjNez4cZUEgvjVc5jVhKOSx4Nt+hTs4a/kYnEQylGCXScA?=
 =?us-ascii?Q?JrLZrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc72532-448d-4340-2d04-08db40c23c85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 10:38:38.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+vgq9gv1nBCNGuuqjMeaQDVNJ7BbdFEaCn1vy8eRJlFH17YqXK7PQb2rEAB4TOXHKf84F6BZWPJRHUkUGDYM+CUQvdCxT3xEtjagEnvCI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:12AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> CN10kb supports large number of dmac filter flows to be
> inserted. Increase the field size to accommodate the same
> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

