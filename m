Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4476B0ED9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCHQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCHQhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:37:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4786C48AB;
        Wed,  8 Mar 2023 08:37:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnEVqvOjYIV38D5NBna6Vs8K76gWOjTghwZKXSP5tFxJyEH4kiW5XFSFgEekt1vq8jUvnxdsXztY9s/lgVqQU+VKHa9wlhk4Q/mWWsocql/vKSrqaSV1mu7hSxlr2rK0g55+KRtO07SIIBzkb5fkIf7H6wSJFBVDRmW2mCSHKx4Sizy5dyo7zIZ/CW9mnY3rQ0FUr/7EvaIdxfLIJluoEbK9jpAcbyl62B6ArsNWcm+F0FhmPUgSrPoY8PWOqFDYujY51v2BKmn1K7NiKyvEeduBwb1avLLOubck2UdQKcYuSmtFCTLCoCjpY+6kzSfMFLddqxbcd6S7upwXWLfCJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwveoQ7svcvyQa3bDOMwEoXS5U79IJ/EJ3vfg5QqDsM=;
 b=XpjT4uyy8/IKxDBnvtnsVC8EGpOBw7v0stwedqwWSANX7YTXOEFAdYJ3iojLTmMBMmusUgsaj6+HbMngdDGzZKMyRsP7oD3CezCI9CSEgmKhuRPdveWJmbAL/L0ui4saoBJC2b8HWUf44LbSLi3krf87551zFiw5NYoy72eu77PaP6LUmwr9ZlCc2Jyj3U7ltmX7njJEyZx+k+vkCDFFH1aADIpjaNN5isRy4QGU6ZAdlN+jBeRBieIow/5woVZuKBgH6iz3Kr13XtlHw6XQ1AwE1KKXOvX3TLZiOc0QuehybVLeZ2+VrKnlYDEaFqPYlDnUhsCIXSg4j79W2vkRWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwveoQ7svcvyQa3bDOMwEoXS5U79IJ/EJ3vfg5QqDsM=;
 b=VdHkI4X+72K36rfLAxDxaf1pTQfQnWQVIPAvy2F06pllR9kqtRXkleU3gEOWvvsIjOPtPj/OcgE/ELGR9gQu7rvSMOgyC/Tdy6TNbKkuD/4ziU9fP7eUQXknxZ/u+WL2ScZsxgbIbhi/cdJw7sjeH2IQt863COyCPbZe/GIWhAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4582.namprd13.prod.outlook.com (2603:10b6:408:117::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 16:37:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 16:37:44 +0000
Date:   Wed, 8 Mar 2023 17:37:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <ZAi50OqlVD+47iTG@corigine.com>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
 <20230308091237.3483895-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091237.3483895-3-o.rempel@pengutronix.de>
X-ClientProxiedBy: AS4P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4582:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca9abf2-7a27-41ff-f604-08db1ff37172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0AinsqxJ9ctPth+EQxdKmiGcozeFPsVbIDqnN8qSOulnWdtVC3YOFkffjaeCvJ3LvT00qRYN2PlVQlXrCzx2QroY1bv1ZbeR0yUnRSNWvTfylVmO5YusVmE9WUzbBJmtKcxTG0MhkCMHj2XiV6v/yil6Jn2YvgW4CPWJCoMuGM3vQHXWhNqCUUEXYM4BMUWWTYTeMqgPsyx/zH2MRzWz9cRNolzTHfsCihE4Pd2VRH2laparA5vWRFWzJy9mTQBoL4sYoM6BBbi8wk0ODnlx+ZvN/rkS1IVUbi5sPfwlPj67QVFyUNJHyYbjeZv9zDJcPHhfaqKktpeVv4RkUpUyqNgq3Z99KOpEt8sQv5cyeFyyMPWouEnipcouzvXGXVwHTBOSm3lyoqXkw4MKLgSkCYW5gYibq1tjIWzXx7bqk4+DoGR1cj7z0VHsfcI3YfMWxCwhFuOeZYzvxltZsFEEE1GJK4J++8zab4eA0MeBaM3X0NTaH22Cv9K9H5afGYKVq3Kj6GOQBENSy5v5LlbEIwDgBvAXxgz/0/I+jRDNzyjuig9Obb2gW+rr4WfvTHcHaXpQDbm6iAfzAIMYX7pDLLxcpXZhipN0IHbYL9iWZ+yo0svfVFJcHoJDr8qhif52Tl5ddcuoEpnD6xltewMQb2+kqvltMgQgO0+F73Av4D882tGpSJ4r3Jwe2tUK+28
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(366004)(39840400004)(346002)(451199018)(36756003)(4744005)(8936002)(7416002)(5660300002)(6506007)(6666004)(38100700002)(6512007)(83380400001)(186003)(2616005)(54906003)(86362001)(316002)(66556008)(41300700001)(6916009)(66476007)(8676002)(6486002)(966005)(478600001)(66946007)(2906002)(4326008)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c7JdlihUzI5tprUUjCj1jigkRafbqwniyetDTWJNYwfilewHyEKpHh1CP77o?=
 =?us-ascii?Q?HWG0/ebCJ+ESQZ8gz7p2WdH1N0mMpD/JXrb2ovNw1ki5UyxcZnNPlZ+bzh0h?=
 =?us-ascii?Q?DUUMx6BMMIDo+XTG0CEnb4XO5E0qOAAXAuSR1U4inUvtPYnnOPOyss5KZaHj?=
 =?us-ascii?Q?zLyZgBDHBjHW6eOz9bCQ4fV/KmhU5ikBV+Xu6hXVcf+z8990KIsgO9St5D+n?=
 =?us-ascii?Q?e2889jbhWO/FhjxkTJ5A9xWycQrJKTPtHE06ygJ8C9DAUCFdyT5KNAUNTRaJ?=
 =?us-ascii?Q?jwk8cgnnYpauoTlvvHZKKF5V7tjRQz72u/OqkExNGSG1s1cgWDmib/xal+/I?=
 =?us-ascii?Q?DdxtqtFX2BQ7Jn1QJJd0VzBy7HzOSxJ4CFF7sgyPfnXYzmLF99Z2RPpvOYbR?=
 =?us-ascii?Q?EE+zygI1fqA6zytsZzubwITAzGJUK0nLwM0gbtlkiMR1MIkdWXavrhB1Er4v?=
 =?us-ascii?Q?l83CezyytUGH07qKZrnRky0JR2D6vCDHiZS6KJUgzCPt/HAjnS5ulL1mB7Bd?=
 =?us-ascii?Q?NEeTiZfEBQ6VuT+c+u+w3fXFpglDGceCzEl9ESgDZPoS4r665v6QayKE98A9?=
 =?us-ascii?Q?kreOkitSXmvAuroEeMg43Tw5jhS/uR7I+G2J1glK4vF2PpsvGtJ8zYDXzyHK?=
 =?us-ascii?Q?8t/SJYYLCvOyL03BmxaVTGdpdJupm8reE31nlHX8CQO6i9IPvZesQz0wtUy/?=
 =?us-ascii?Q?w+okKsZPPPsi4SoFZWLloAxTs97bJFdQmADKhk0XqLA/b0Eclujw32gMNlt1?=
 =?us-ascii?Q?zwbFLZHJfaaqyG1x8RW7hhLUcvT9jo6WvvLQGwyFy4YLkDhG/Jpf8n+Qc8Q9?=
 =?us-ascii?Q?Ac5hRyKgQzOsLHfKv+SXN0kCS2vloyOjxXmkcqz8rq23rhY7BGnioz1B5QyO?=
 =?us-ascii?Q?vR1qr3M5JeIGcTQZRlLgg8KOfcoVht90aXWaLYj2lm2cQ4Ry89+UITQKQb6d?=
 =?us-ascii?Q?rUj4OOYIkAbpk81emKdrhafGlqparx2wkIOyehlIpccN67pVo29+z6RncVGQ?=
 =?us-ascii?Q?mJ5/2O/zuDpoWJik5YOv0uJQEVBgaKG243AzKy6TcBWRitMr+2DYu0RF4kyj?=
 =?us-ascii?Q?V28cwn1Mq/NxIlm2zWLXlwY6l1JFYvs3Lk7Aych1Ve90ktp4cMrgu2LiRtC9?=
 =?us-ascii?Q?Q+sw4ZMdctfS9J7I/LJgzDW74ilgvpLMfCOiqx5NihJIqSOfX9gZ7ICu1d6P?=
 =?us-ascii?Q?AfbkB/7hHMqd2IEiMxTB/I5fv/pwIub1IjTs/BFfczMdEu09J2Ibg/gJSy/W?=
 =?us-ascii?Q?b6vrGm86c7zg6EPt/VWT5YwpBl6PxGK5WiKRNyGxrDlDhN6423NtU2oPdwtK?=
 =?us-ascii?Q?8ne5UGgJQlVXYbh8YjlHFCbrj2UeZso/VcXEoib1QTIakAE62QHUwalobCMP?=
 =?us-ascii?Q?w7IHExBCehAgMAX+z9rzeXhV8vA8Oko5GpLO9eETnJBYn2s+WX+UYoEASrC7?=
 =?us-ascii?Q?391fQbW0InDmui44KNKDnvAtKe+EKNZEpfHKs9mJQoiLyMcwBuB7fTpH5bvD?=
 =?us-ascii?Q?Ua8B58FMD5dRLJcFqyB50koe77nk7daTGIqBYPiVdFG51tiL/12bRYmDDvoW?=
 =?us-ascii?Q?XeBybpYdaG087EXBNmH5tfkTmcms76J89dSOl7IVb/rfC245Vf4c2QSfjG5i?=
 =?us-ascii?Q?pqENipSdKfalZUEdoWKp2QNCBqNdt+p3un0LTFBphr9Wx092JxYwRROynOuv?=
 =?us-ascii?Q?2fJmew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca9abf2-7a27-41ff-f604-08db1ff37172
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 16:37:44.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sElGhThT40veGSpGgd6SECTx82NhElhi4YtzHBNNJzF+JskGMPG8vvBL8SWcQB4sOcUQyVAhZ5tvuNMoI2lu1tjCCQQrc17S5PtdJFn1obU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4582
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:12:37AM +0100, Oleksij Rempel wrote:
> Add ETS Qdisc support for KSZ9477 of switches. Current implementation is
> limited to strict priority mode.
> 
> Tested on KSZ8563R with following configuration:
> tc qdisc replace dev lan2 root handle 1: ets strict 4 \
>   priomap 3 3 2 2 1 1 0 0
> ip link add link lan2 name v1 type vlan id 1 \
>   egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
> 
> and patched iperf3 version:
> https://github.com/esnet/iperf/pull/1476
> iperf3 -c 172.17.0.1 -b100M  -l1472 -t100 -u -R --sock-prio 2
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

