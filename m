Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3106BEE66
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCQQdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCQQdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:33:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B074E5C5
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mga/TzcTEKfqBVtogdXKxV/8F5rCb1KQCxby55uDFPPfxdE0L2GDvPQ4M0Aqjw4pNJBCnelPmXgvGr3dbs6zEQBtTA7pirJjs9U2CuCGou3teNKPLlyRDgObAwBzruzlGfM7MzJV+NLqrQ1ZRux2MWwm8iAamtjxIiCC2qJbnAlDe/qWwPzE5cv026EK2TP+1wgETY8EZNVWOoUg31kv3sGDqPw4VeTzjdN6qJdDiU9prpOLgT69V4PJAj6/rwySZJ6tnFx2Ahp9JoqedHOUmN0WuJMixj6zCaESejZ8dn6VO6vAGKBQGIy6o3uIxo0l0Hf6W70DmQSYOPtZuBUMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaoXLqUjWYtWDUVZCzin5kp3bxBnsl9el7UZVgpV8sU=;
 b=O7CHAle+PRn/9SKPOgufbIubq1cj3d7obAHSP+B0LBF4LLXohF6aXLI5iRjQ5LI7Pn9dcmvLMa7d9VzfwajKItEYjaH6tagDDsNwx/UpozKVrQU8zrAnTq/w60tHZ66jxiGJzrB5Td73bHANAlfnpeFflJpo/kMujmDoY5u9z6SSyY2NQkoUt+B/7TfnYEGQ0U37ZoN0J85x/qXG0QULC6+oqJWZt5PFcAqoJn38JNbHOi5qgO9/Nir5VYk3Wxwu/C5345Y2m6TptLJIEL81i0EzFVO5enlc+1FPT2p80obqwiof6QkuCnDphKXdw1gfFKQpdpoOCPCAewHkeF/2FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaoXLqUjWYtWDUVZCzin5kp3bxBnsl9el7UZVgpV8sU=;
 b=VGr6lUKmamgvzl+pD1iUzkaZ3c0zm9JTwTBRX+DrrR2S2uF/TxICVxZLIpWFFhX/WEAa1Cqbh2un1r9PSGj0f3ibsVJ2ku49gf9dalgpXawZzyYYYc7GNgBYOFE/xyAF8LgKkZLJf82ACWjdEhIWcuroedy01TgPklwpOGoWk4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5275.namprd13.prod.outlook.com (2603:10b6:303:146::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Fri, 17 Mar
 2023 16:33:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:33:39 +0000
Date:   Fri, 17 Mar 2023 17:33:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 02/10] af_packet: preserve const qualifier in
 pkt_sk()
Message-ID: <ZBSWW9eJxGlVODTk@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-3-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-3-edumazet@google.com>
X-ClientProxiedBy: AS4P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5275:EE_
X-MS-Office365-Filtering-Correlation-Id: f8ce6b8a-ca78-4d27-4730-08db27055cd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBLulo4GpoGWwM7SpIkz1wfu8YXo9JJ4Fwj4mz48qZ2AhGdGIHxOErU8hGfMLVX5kfT2/0VbojVxeHDkqyFImF2Jue2zOxLq7KwDmqA1GypNNSoLBFHDdgUApsESwc4lfaX13aiGySCvwVCSxfrFDsnWiKvIO7rk0PnqAlqFr8psDCD/ESwcBPNXfXKp9cktvOmSpmzSn+db2ohPdZ2XBaRa8/F9uEaCWsvZ4SNAcZxEbM8sRADDeLbm106mzOb2un7kHo1CcabWiR/HN4rj3dloz6WHaaileFhthAJmPCPn8MKnar9wqEhUs5KiPlJow5P9w9h2drflPJdGdSl0N99XJ9bQ72Qj6whDDjuRnSRyNazKMxAhTqHNDRvs+ny2kuDibrKuJdrbzHX4C3Go1BsYmMmXpQ/pNBURGq2YcNR/kxbDm/MUFOYewfcN5P3ms4q/LMazDMobZX2IY0BXvMztU1HN/w1xgIPbeYcZk0npif05HONX70/XavV8QfqEGRU0oeo6q3IZpmura6wWX2QOSzdgkq0Hu/55zEr0FlpTq0ATF/kVIRwMZpXb1x9pRJukGH9UVQDW2AqbixER/p05USeVWHt5IKqdMweghXsm2qL9UF80kHhDKX185cARmDSQWrvzmMtKz5dZx+QDBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39840400004)(451199018)(38100700002)(6916009)(36756003)(5660300002)(8676002)(4744005)(8936002)(2906002)(4326008)(66946007)(66476007)(66556008)(44832011)(6666004)(6506007)(2616005)(186003)(6512007)(316002)(478600001)(6486002)(41300700001)(54906003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0McicMOT6bdGql/KjgOoOLKL+PoFsDz0SdTOVJyTk0pVxMDJ7bv9No290ayL?=
 =?us-ascii?Q?H403/jOVXFKZ+qldXRFh8TwkxJqheRFBjE3LfGKFdqvJHseFFz/If+AcYuPG?=
 =?us-ascii?Q?U/7TkYdTrJOMlOnMyAbtLHUJX7heCVBcje07bXRQCKRYV9Y25rKyb29To5Nq?=
 =?us-ascii?Q?uKAPK4Meueh38zZTK5U7pCclr9lLib5yKkWXtThTHJgKJ8LECXOmJ5PxsrCR?=
 =?us-ascii?Q?J3Yi/aiWKOBuM5E1R+Bb0X0OKKlSy3ETOBDWASstOqdyLSo7wGi71sO92ioq?=
 =?us-ascii?Q?s72zfyqs5uz659emjCehD3zCCAKdsWuCTYF/Q+unQ+Br7k91XcbcYATw43x1?=
 =?us-ascii?Q?Hx1moSU6vwcggLWegrkNq/0atcTOQYP9ZG9HS5NLHlr6wMTt6SkZi6vGP55u?=
 =?us-ascii?Q?UGq0A0340OIu4MELl9DRMRdTPfYCzuq6AFg0bx568UIMzXrUezA/TXN0iYgw?=
 =?us-ascii?Q?doL6JGdqg6j7zonvbS+VvyjUVLSHbfDL+Yx/+bDKbMMiLkNQ5re3wcx58fT2?=
 =?us-ascii?Q?WmBVCcSUiYNe/u+X7xv/+4qxlk50txUCK89Ao+KJhrCiq0eJk69j3ga9wyh8?=
 =?us-ascii?Q?Bdoy4RDZecSyocVvjw5ajND+tUCIMsHDqls90TQg1daFn7QuXUwljhmbJXvI?=
 =?us-ascii?Q?8QJawjQ/eBe+gvEWBH0kwfw9ufvhp7VruBj7Ze2qvRXEX9X/geYsLco7wyhO?=
 =?us-ascii?Q?NPS25UI0vE/gK3jJptrU2x4mXXZz0UGYlainol2vnuhyv34+i84YRc0+FiP3?=
 =?us-ascii?Q?p8IJW4sTMLcgAsc7LHr2YcZ0IDFkubJM4/3V+u1pHxRnsiStKDyghUbnKKF8?=
 =?us-ascii?Q?Q4RrhvE/lAYU7YsyiDevID9dain6Iinxqi4lfvMEkStATrMzw8yy/NB5EGgU?=
 =?us-ascii?Q?0dybkkkbwKRpgW0mMGF16h0mL+rflfaRvCVotkm00LdK+j47zYGgeBMq/BjY?=
 =?us-ascii?Q?kO30ri25XkWARlgsI27iYyP0egEI/91R+gDuzElExsnrIA+LcUhZWxP0bZMP?=
 =?us-ascii?Q?z6hDvc+EwfI939IX87qBFIakrYPvdwUe97kR1FSEJ481VA0AmA8sGfmDY2ji?=
 =?us-ascii?Q?nJQgg1oPh4M1J4faCJ1dGi75yKBlHcT0w09Z6FXVYnWJsV47Mxs90ly9bld2?=
 =?us-ascii?Q?BZWVD/Cwp1mHmq4BizrfC+tMy83WVYg3SU4qyKgRBRTNRGiQvT8X+4etDtnx?=
 =?us-ascii?Q?p35lcdURCOD7HRgX4h7rSApc9I6PIM0qUzf1P4q51O7xKgc+l0MXlsrVvbK9?=
 =?us-ascii?Q?onoR2HgX580QPLkdq0utRYx6860tqq4mFqIfVoC4D1ppWP9OQ5wTV0ZuQzx3?=
 =?us-ascii?Q?3EKw9OsC29o/Ja93suol5Ozq0b0MC8OdxWLKqaeVuzPojX4P/diDEopBebJp?=
 =?us-ascii?Q?LtOUIeOdCBzKSAwDNxMJs9nztQSnqzZD4UfbmBtmJO25pceBf5E225ewvauL?=
 =?us-ascii?Q?/4yR/cCI1q7335WuHL33zAcOR/PvBdBBol7knsF1S8GUhL0ZPj8s5SogHMT3?=
 =?us-ascii?Q?Kl/uonBQAbY58fUKJWTA/+m8/mrIp/culBwTACxEpYuNqb9oQXNdslE4ZDzN?=
 =?us-ascii?Q?0w9FU7VqmD0ARrg9IJm2klvD1tX8/uESuLsxsSACOqXXsvIxflPdmuTFuI+y?=
 =?us-ascii?Q?BDR7H+LPM+kaAQ07ycxs6lcAwcKPprj9+73b3dRDv69zNLtk8kyv7b6pNf6H?=
 =?us-ascii?Q?ZOw30g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ce6b8a-ca78-4d27-4730-08db27055cd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:33:39.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qa6s7nCwLs9infgxj8kzUe4bgtHIcPkWOtDGkk6lRlXeoMrKrMX3AwQMDlwOHgpUe6wubVbpAyF0skD3KtIlO2H4jgnbX1vS5uvkW4YmdA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5275
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:31PM +0000, Eric Dumazet wrote:
> We can change pkt_sk() to propagate const qualifier of its argument,
> thanks to container_of_const()
> 
> This should avoid some potential errors caused by accidental
> (const -> not_const) promotion.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

