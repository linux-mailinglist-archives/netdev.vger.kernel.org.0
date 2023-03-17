Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688786BEF4D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCQRMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCQRMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:12:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2137.outbound.protection.outlook.com [40.107.244.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B0B5A6C6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RO+msWl7xLsZUQRPs9lJZdrzuEaiSkshE0gLGTaeviJleCQf0TvJ68XdFIqZ+g488FeN/E+pPnYInsi921t2bnjDmuVbkk2Cf81G1iScB6aR+o/xIbqPpAzbjVTSo+NDX0WJfHqaRZJknKFYqETUjH+KJwc2PQuF+QfDOQt6DewJZlw9bMDHDfHrnVUcsmy53hy+6y05ZAFfnSQ79+XHnouTvd7q3/rrxc73xitIRJ1KV0mLbC8mJRkmbn7TFWPMWhcRsOgNcCElXT3JZHpQ0ErA49ojtFanGTnVqczzO7XUBmLNxo3hn53B4OUbS9uFxacaolTQ8nnKs651tLldog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2n3zRZk+wDts5si/Wx60uuVTvOvmK0WXqiD+9ZcZiNQ=;
 b=CPdMN9OA+BGTchdVfUpMhDzP/kX77+JmMJYGEAYEtsuT0Z5ABMOKrQ58raTDBzkn9nE/S2Vxa3HwsvTs8luiBnlQuYHNxQwb4ckd2IVYhPSb22RUeDOWM+44jctEnv3DjsfRwJuf48qEu4BD3/MLF9vRlyJ8J6xvaC+9Lh2PW0XLVsyVFNKk5WRDIVquyvo1cvm8PExqk/xq1DTjPvzCec0ZwWVLP0HpAS8+Hq3XUmAWHlSt0p/w/VxFm8Xd1Yp2HY3j6oNSHxTwF7vI0PWcDjVlG/RDG2hBG5zHoSFCSCryD02UKe5g+OWq480ZYfA3CfWv4/QURxpB/w0lFLnmRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2n3zRZk+wDts5si/Wx60uuVTvOvmK0WXqiD+9ZcZiNQ=;
 b=AR4WGIDQdFiYCmRDyN+UHRFq5jayY/+uikcoxGXzLV/xmaHOS/GgZtykNtXDSP/Nnpfz71a3pDjz+74pIg0swmY8hk58mBZ67x2QkkAlK3zAd4oExjU6pcLqN5fRzsmq7GJatI5EpM+m/MIDGqqCZotzFdAioecmJp74F116/Mo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3678.namprd13.prod.outlook.com (2603:10b6:208:1e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 17:12:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 17:12:39 +0000
Date:   Fri, 17 Mar 2023 18:12:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 10/10] tcp: preserve const qualifier in tcp_sk()
Message-ID: <ZBSfZZajdDkltzqQ@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-11-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-11-edumazet@google.com>
X-ClientProxiedBy: AM0PR08CA0026.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3678:EE_
X-MS-Office365-Filtering-Correlation-Id: 014bfae1-c457-4a14-91e5-08db270acfef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dflV7jVE6o/odKVfQ/js7CimNQTkVK2JmGpFD1C8V8fnszzGSTZjVmWlOgjwDGD0WKNb+oLjxw+WllblqdC3MfcF8hvhivRWlINNYdjf8UN2c80C2UgEn8lDFDbub0CT5EV+Ktvno27wMFJ3CQGTag/0Nki+8wV7DQyQecPWBydLOWBRHsT6rLMIEjCojN/LiM+Y2oTBG75hjGEz63TvUK6rE2NI51CrBkyAuKWF+V02Lu9P5Yt3PtcRLS/HMyV/LBkCP4/+btrSYzX9lZpSc1f8RXANqbP+DoCB0qK7GHHDlL4o12WIAj/08gk6wLYxPG612aW+/9acU5bhKDKd/5ZFvBE2JctUvCiq9ZQAx5v7aNMT663JoLEe5naG4whUM/aFVADpySkdCZvgSb1EesmahOVnhnWouBtoAu1zsVd/UBRXujrbWGcKNc68XH0jxaTWSRKg+7OPsXHZb5eo/+yxIdg4in7HdZW8FpLiDWrtvXGmGfhyPgDpmon1goL/H3Spy8RU0p7eNOs2BmO0GJwl3/ARfq7SIqKROO3c4Knozvm+iPZsRm9MlvrO3iyoAPI9M+ZDUTWsK4sqhaUbQ2jvLBAftslicWoS2ekhcCCSD9QFjSAvM+8261frisQu/Hf6Bn3OM1nJnsdI5ky2bZrdLivzcW5P3jmf8al8HQiSxuCtNOcwDsFWROlgTIhn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(346002)(396003)(366004)(136003)(451199018)(36756003)(6486002)(66476007)(6666004)(478600001)(41300700001)(2906002)(4744005)(5660300002)(4326008)(316002)(54906003)(8936002)(66946007)(44832011)(8676002)(6916009)(86362001)(38100700002)(2616005)(66556008)(6512007)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6+ppsuVKtOOn6/7Vg1bhNRmsHLlAAMLeZrRm1arqHG01W1oIqFE6yYtCHgaq?=
 =?us-ascii?Q?/SjSnL+0r+2qPHfcXm/uL9u3eFQdIpG4WeaH3lqQXraAl4XvZv9kb5RuIU2d?=
 =?us-ascii?Q?6O+tQZSn6cYfBCL5ll8dJ3xr7JH/E2usUwRZkfA/SF48Awfqu4glZQdEETbE?=
 =?us-ascii?Q?41G6almg/RAshgL+ba3GaZ1ofIu57ihVWFVrJ6CoNUjJR/2c3JlCkJrz/T3C?=
 =?us-ascii?Q?DmsaqyXvw5XxfcMje1C1/psN+bvPDKfNpjw3f5DpUD2Py048Mn+CWvFe9z14?=
 =?us-ascii?Q?pi59Rmq2+XTfAEe5hYVqrZlxADRG9M1mLrrXsq92DIAAWQ/lhspvVYB7Hg6S?=
 =?us-ascii?Q?0Xgwq8Y5iqCTs5wCPzSLGW1JzN7X9JcAAyZK8VMr0bKVU5EM+iRyfgBlvZuO?=
 =?us-ascii?Q?baC1gubYcQHH2HdWQzlDaNwU3R9UBubneWPvXaJ2urSaUDpWAuE3cUOk6Me2?=
 =?us-ascii?Q?EWjPQtOXt6MOBxu/75Xg4wgGJEBv50NTbBtDuOhLRnJpv2/QdWk9aVV7E0Mw?=
 =?us-ascii?Q?O/4M0RxpZhf5lYeEnwhJB1Hdx+xSRcpXdzNes5Hls0cL7d0WVcMNO/K1EKvm?=
 =?us-ascii?Q?OC258lsGmvVx1o5EOa+1JW7RJ7yA8F0w4LZBHlLgIp0Wefd9+qXnH0rAPB7G?=
 =?us-ascii?Q?br5kN2VzDHlNf+qzcCFQDUFvS0dKe+1gVm3wInn0C++5d6AVLhL2JTqz0mtx?=
 =?us-ascii?Q?XTTvL3NTTGYCnb1sFSSC57Vf0sEIuDdA0EiTNNfbVH51nJ8V0KgWhg/6zinn?=
 =?us-ascii?Q?X9y/+GxZnKozXYv20gDCh2SQrztSmTW+zNSXrC/zA21zcFuljngwX/I3sDhw?=
 =?us-ascii?Q?Bzj3N8MoUuqm1a5Dxiz2caobaFbq8uxiDBXR6MFTrRRFgykX04luJjCsiQC1?=
 =?us-ascii?Q?CjjIMvGgdGTG9kP/4wjw6DGdxqYTW2ieTn+WBmSmE3+kbgAczzzmSJV64qUC?=
 =?us-ascii?Q?4fPK473Ii4GYz2nTkbEWLwRk/tYkHdBRt8EP3lFwDpr+bP/ex0oOGK+WfATF?=
 =?us-ascii?Q?jYqwj3ofU0qdNtDZKZUHgVl1X2CPA/aqGZimJzXEgfywEcHawjjcB/cmFxdH?=
 =?us-ascii?Q?QHI7rLBhntorQpYfVQAzebyeO6XAOlix7ZkUAZhyEQywz6OWdWSclGOwWgCN?=
 =?us-ascii?Q?tGbcMN9LwOJGH7MgrCWAnKXsIR1BvGNd/vvA7gVwpx8ilqFzHySmn2VSFW2U?=
 =?us-ascii?Q?ut12u/QyXQXstdJMKsOtnsv9pxUcsfHi8H4gwzzs90j82iVx5EyLCYgYZl6H?=
 =?us-ascii?Q?bp2oi+mHkxpSpYntgwTqfsyOKVaxgsE4qK5Uu1lZMpeQoIQnW0QxTEBSXiaI?=
 =?us-ascii?Q?9HEkf+o1f6pVmEzNjYQhgUsyU3X2W7aaGwWgbxFJ7QTu/uvHswfxKvgOJBoG?=
 =?us-ascii?Q?EyI/aRKVfT+3O2TVQ/b/XFVLnc0ChsrgZb0pyA1QS6Lcu2T5YaTZk1nSJ7oq?=
 =?us-ascii?Q?L5OM8JbrWhnvz88tiEkhBMxwBG7WPrgXNPcBm6/iX7P+Q82pylbrXZ0U+/Dj?=
 =?us-ascii?Q?gTwelNpgF42qbJDs1c/MGnYrCAcbM9EvzxfsJqzM22P8G9Ac3lrXwJmL6UVx?=
 =?us-ascii?Q?kZAJSyxD1SUh/+9bbHp+SjI/V6CKV8p6/czLhvQlhQL9rF8YvRqq9qMhV7kt?=
 =?us-ascii?Q?o1Doihoe8EfYu9d9orpG9MNrfYm4yC/D39IL9Y/rTDidMIYCsFTxzHZsqQkA?=
 =?us-ascii?Q?xRa8aQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014bfae1-c457-4a14-91e5-08db270acfef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 17:12:39.6515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfsk0Zq8Oqu7nPkpV8L0LmI1XEFIgriYkHoTR+20zpDdWEz0bhi9I+BH43EkpJnsC4C3wnUCfbAgaLh7VW3CtKOZSPItJyIdRZ+HoOyPflQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:39PM +0000, Eric Dumazet wrote:
> We can change tcp_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> We have two places where a const sock pointer has to be upgraded
> to a write one. We have been using const qualifier for lockless
> listeners to clearly identify points where writes could happen.
> 
> Add tcp_sk_rw() helper to better document these.
> 
> tcp_inbound_md5_hash(), __tcp_grow_window(), tcp_reset_check()
> and tcp_rack_reo_wnd() get an additional const qualififer
> for their @tp local variables.
> 
> smc_check_reset_syn_req() also needs a similar change.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Upgrading gives me the heebie-jeebies, but ok.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
