Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D0D6E97C0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjDTOz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjDTOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:55:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2118.outbound.protection.outlook.com [40.107.237.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAE910C;
        Thu, 20 Apr 2023 07:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQrDbdrwsb/yWB/HO/fZrykXasVYRNM9jtY0cc7cv2I4QbZy9aJRgNy5nVD5Ply9Cc+qpiSrWgOLQTTIGUYHvsU4iIGzNibmhzy6bjNyk+ceC4TpXLFIU6OPSDh3+SWN3CdMIWyli3Lz/Y4AUZ5KenTw57/ZrqidG20csIgItmJvm9T2/uJH71EzKivRE0UsawNqYWH9Fj7vdzxE9waKhLGI7JvNhsatDlveYv+7Rgjfh0pePyR+8ySsaRdjI40rCqIXEAwQSkVVEXOPAUii9xQKyUNNfJkzNhYicSRWd/4pBs6p6pBpAtX9G2fDSlvw/T8zRHDG3eO0FZ3+STV6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2GDZfvuj38qFyCP0QNpF7bvnHxW4CD30QK+4C74erk=;
 b=BzZguc/xokTpuplyuMMVxjacEfzpkC24voH/62vlPTuPPwr0ra/Aw+n4a4IVgdxk3Q8dadsOfJq6P1J2GR168U8VApWSZlo3esFs1xQ+TNfbNzvh743e1KBtw62FLb3cXvgp6R2mo/CydeDsqfoB9d8rM02qDR6OWzM3xIP7B/MBqI+zWrII6SlzRn5bDStNtqpQ99FBVstf1njFmZgoc0VUWP10BFNXLCVmY1xWN33SmVTJ92BKlz8b9wWkrCi7lHkC8uX+jWmO+bPKAmgCsY0QJl7rrU7TH0+zwOv/RksgMEH/fnACH6tzW1k3SIY3fNxk1GD8wbz5loksKQsgWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2GDZfvuj38qFyCP0QNpF7bvnHxW4CD30QK+4C74erk=;
 b=QCR0XoiP2CbSJWTZZ0FF2GgSQMalTRRIXj4et8w9e6Yw+ViJKD0oLM4AYle8Rbj7diHel3oNqTUAQFQgdzj7Wb9Wd3Cy4uk8YIzbfNG/DXiA0RFGra3ElAs9IhDKsn79sIn4mo0LrpqgGyikwJaeCpPVIGj7Jj05AkxWtywHUMo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5102.namprd13.prod.outlook.com (2603:10b6:408:14a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 14:55:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:55:50 +0000
Date:   Thu, 20 Apr 2023 16:55:39 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Yingsha Xu <ysxu@hust.edu.cn>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: remove return value check of
 debugfs_create_dir()
Message-ID: <ZEFSa0jzZa6QMAsw@corigine.com>
References: <20230419104548.30124-1-ysxu@hust.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419104548.30124-1-ysxu@hust.edu.cn>
X-ClientProxiedBy: AS4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5102:EE_
X-MS-Office365-Filtering-Correlation-Id: 88867c57-ad41-40fa-d0b2-08db41af5486
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0ePdd7Anp9mfwwjuIokzBU0R2KHObYGd9PpQR/R0Uw6eVN8Y/WKLuhcQW1Txf1Gb/8q7hqD2FrHmH4wNVl0CwWnASi5c1XgNDmy9vgx8b3DYZo/4qbThpvuGMW/J0WJBmKIaTI6/rrJayskKqqVQWtGvlawnXMS5PDXi2LBMVkRS8W1fN1uwLFC4q+EJ//19URTP/YODY/S+zBmq28yto67pRtHsYX25CMoZKRC1mxif6Kh0E0r1g2zVUiWC4o0htKcsAZa9N+Y91jjrCEhfNGGC5jhcHDs2paUTcaY64s4+H+lEUilt5SxHmYwYy2dFIOnwOkN6oKL1bisctnB+PuoUeTDWb6+6N6KC8cSwNjjQsKVRmQllHTzFKLoa3/xYaInrWpuYdvB6TefyPFzbv2UAhYLepD6ihanQQcdgZd9yVOmDmaMEY7yH21iUmG0MqsJvE+LZKCv9W5C9Lp6Vt4trpG75IxrNL7R/9/09cW9TzEPQRshzDU1o+HIVsCOwicLKUhewY/2t0xsa2/t/o8LYsATjumnBTJWsq0jya5qWvaW6xqi8u+QG8LLrl/fVOhf2mHWgC9xOgOLwIlBpc35dXkmOBNU0ULtvJdJzSE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6666004)(478600001)(54906003)(66556008)(66946007)(38100700002)(66476007)(5660300002)(8936002)(8676002)(41300700001)(6916009)(4326008)(316002)(6512007)(6506007)(4744005)(2906002)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oVlmcXfCQHVXPLVy5jvpM/IOv1Qa09crclowETz5HBjWH/grQe4FTgma4dhp?=
 =?us-ascii?Q?9WF9GNFxPF7Zu9pleeO1PZRMZeI4rq2HLt/iAqSF5yiQB3oKtvcXSVBUcH1S?=
 =?us-ascii?Q?1JPOsEhq+qY9FZmaad4t6Gop8B7U0QrvIlyj0b4zaSbSXxiJ+UPlFWAcPxYm?=
 =?us-ascii?Q?pnkDLEEtRtMGoBDx9oVX87ZLfMUyt1pvSKGA4VdwZ08yKav7p6Kfx5ot8/Lb?=
 =?us-ascii?Q?XUslZvWRVFeY1JBz1AduHsKOsJe8WP4vSrtNKWtdYx96VCc3Ri5qMjTAVArZ?=
 =?us-ascii?Q?9Fhj+IV4xYTahun+QczohzEW6UfDNQbyYkZAa+C+6V0ePYlqMVW67J4QkdrQ?=
 =?us-ascii?Q?Ap/O1zhuXFNfYCCTyuJI0/lH41+wYwoUM1aSMPsLHzGHLPj3oYn+vmbv+kDj?=
 =?us-ascii?Q?F9bps2X1VWlJImq4fLiMpK75TSSkfKSg1GWp4ZpzX64VwGR925kH1VHv4AUM?=
 =?us-ascii?Q?1QBfn1fHWUXtH17yLJYRaDl9QaQO8GWS3aZftOqF6GGiuiZPxDDAGajIXIux?=
 =?us-ascii?Q?TGFRnb5HgDFJvQHxg9+9mAebqvykKtt0aRqA8oWXGSgIh/mi5fAJeptwgb6G?=
 =?us-ascii?Q?LMtp6J6Vt3H86Fn1oN0K0SjFGj5WGhC2N0g1q6AMkfNZlXAwvkAKuI1U0fnZ?=
 =?us-ascii?Q?FPzC7eObx/5zCgrPlVrbgjN59LRu1nzi3ts33P2Ec5+Zx4WAFKH5sqWSK2+a?=
 =?us-ascii?Q?HXlnlUZVqt9soHSAGpFk7STedZzZTtDs8QTFU3fiRK8VdMC99V+/LR5Ya/vq?=
 =?us-ascii?Q?zEfRr5EjiIz8HgobAdaydteaT/As/FegDj+j4VzZM3wjN8oa9cw+IFnSLx6Y?=
 =?us-ascii?Q?iVP7Pso+2424/DM26BtqKyPjtwUg8e4EsNHYm/0mzSc2YEg7ojOX72LWthn3?=
 =?us-ascii?Q?jZuGFaQFBo2qODj903Rs/XvrJl5+slDSrrWHZw0HGr/KlnwRjf5vLAfHnrc5?=
 =?us-ascii?Q?OFzC5U8WqgQejtC3CrG8AxxS31ywMG9KT8j8Hs9eoNhG1AODLKBfKSFrJfQP?=
 =?us-ascii?Q?xFIqj0lR82jqqRTLEOZWmXybrn7rYCNbCcgW6FH4G3oofaqyerBJj70sDcH/?=
 =?us-ascii?Q?8yhUSZ08pl7FdjR2JVZWSFR4ceMVzsEnKVsH2uUVeofKhrCYYmSloSuQjMGj?=
 =?us-ascii?Q?5ZTU/Nq4ahKjNxG9KGp5WW1jT+HCTchAcxlu2D3FZVouGvA9zQsfZn7n36kO?=
 =?us-ascii?Q?rQoq0mRDNs8e87CXq3MdML3xfH2I4AfsqG5Fb4aQUthKfOwhjtfgDyGEdf1d?=
 =?us-ascii?Q?4i/imfr5m44voRTtSLHva8XH8YqJ/QFDFsCX5BavtRWIOd4ZKW52Pm64NgE/?=
 =?us-ascii?Q?D7nyMDrDVB7GyykR4TI6gR3lgCHs8BbO+fM4BWJZ0nyw+PLifIznNNJngnmQ?=
 =?us-ascii?Q?baoloU6WzHNvUdwt7t7kQvSVIjNwqlDdoKCY2MRIIgDxqOPllS/iODAbjFWE?=
 =?us-ascii?Q?7oOjaD8C5Y0YJFWQQvPGYxOsmz7yBAgUEdMKC0niglR8zHP8sDXzc++C82wj?=
 =?us-ascii?Q?DcDtyX7v3ye96ETx3VzC2ouGM3+mV6+lHFYjjZ1S+8n9/DyC58B7S8/2GD2E?=
 =?us-ascii?Q?nFXsa+k5UE1HgwoMCvZ/jDO3euz42Ba68eB5a6l2+hShN0vlVJYt0hcgkzyc?=
 =?us-ascii?Q?IYoNbIWzYutfKaoex1y1NyLJreN3ujtgJBtawgvYYksR4qvscDkw7FDqhNPe?=
 =?us-ascii?Q?pe9iLw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88867c57-ad41-40fa-d0b2-08db41af5486
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:55:49.9555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scCNjWTzI/iXlc5aPF3eW8WJoOLqJ0KenVl9pWp41mDxNmnTZLaoCz4MSsvxB0eotPpGXydL6360EZF8s4Nmlnl2dKMSXA645BE2ZnFBPkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5102
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 06:45:47PM +0800, Yingsha Xu wrote:
> Smatch complains that:
> debugfs_hw_add() warn: 'statsd' is an error pointer or valid
> 
> Debugfs checks are generally not supposed to be checked for errors
> and it is not necessary here.
> 
> Just delete the dead code.

Perhaps:

As per it's documentation, it's expected that most callers
should ignore errors returned by debugfs_create_dir().
So just delete the unnecessary check.

> Signed-off-by: Yingsha Xu <ysxu@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>

In any case, the change looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
