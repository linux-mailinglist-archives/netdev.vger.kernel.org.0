Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819BB56723E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGEPOz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jul 2022 11:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGEPOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:14:54 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE8D0165A6
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 08:14:52 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2041.outbound.protection.outlook.com [104.47.22.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-4-erKWQ-9oMoSGUEqhZ8hKsw-2; Tue, 05 Jul 2022 17:14:48 +0200
X-MC-Unique: erKWQ-9oMoSGUEqhZ8hKsw-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0632.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:4b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Tue, 5 Jul 2022 15:14:47 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3d:ca30:8c24:1a95]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3d:ca30:8c24:1a95%6]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 15:14:47 +0000
Date:   Tue, 5 Jul 2022 17:14:46 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Max Krummenacher <max.oss.09@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to
 `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
Message-ID: <20220705151446.GA28605@francesco-nb.int.toradex.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
 <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
In-Reply-To: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
X-ClientProxiedBy: ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::14) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e9daa80-8352-4c24-42be-08da5e991919
X-MS-TrafficTypeDiagnostic: GVAP278MB0632:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: V3w1MYmZ3tqntHl3/QyOpjsoid/PWoeelT2LGrFFs3FgumTcURdnJ56Xt2kExedgmrdlViBuV/aFgF9yMwsPeql//NMgbMXwi1MUsURd5bBt2MewZJf3wjkTpyBPDQfom1CJp0tU9xnSTL7H1FcwckLkRSzKQLE3D9UxDHC+EH14dmMYJQ975dfQmlpd4mCCiBSr25jen89DS3HC3JGU7pe+WbrXeOhIu6P8UJkiGv0Me8d19Xlewjvfs7Sr1Xf8QK4nFsDlAWN6lpwd2/ob7x8besE6YJL2oX4LGk/FV+Fik4qDOQSiI9DBlZQdiLk1cLIDWguaf3YFfDuCeweaKNi9jo0HvqpIE9LtWlhJaiHJuHJyP3wN1zM1qI1mS2b7YxTAqtFaBN05QAA96Ub7A1xSEsoTGN/jp8kLiN0wIqhJ/F3adw8GsxxtOB7+25EqnUyerKVs8AviTzdZqRGHe+KvuO8yhUeKLBfCSqPBzvNj/HYXCREUx9qRPZnhNt5uphPJyOHAYvcxilmB3omXCoX0VlhkB43H+f5cOaDcknKiwy/47NCg4fcsehywBOLiCcthVmAb8F0CsMNgwPzBwd+k+6GuK9j19D34AB8kdGnwJF6DkkBLWCxu3hGyuOVQ8pMkpYGcsRmYk8N8uvHULpmPvyPObe0ayLqORxTEQkXDhLIi7LJNUfpJVYZrFGEhUr4Aw+q1p3DSmYSEIX53P8KekciOxiICDjrZgimbjwnF3Hu9N+VLyNvA1Bt1ixdmjNj2QVKmiCRRoIj1nWeUXr9d9lN32lAJ4uV+1aP/cxsOoH70iyspkHVm6FpWrthl8Po4GMcgA6TRkRzxvfW6Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(366004)(396003)(39850400004)(4744005)(7416002)(83380400001)(6486002)(44832011)(2906002)(86362001)(478600001)(52116002)(1076003)(186003)(6506007)(38100700002)(26005)(66476007)(66556008)(66946007)(6512007)(8676002)(4326008)(38350700002)(33656002)(316002)(41300700001)(8936002)(54906003)(5660300002)(6916009)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TVTtcVwNvDEp9xQVvuUk5h/DD9jT/J9o4DHuLr7+5nYqdcTedQ4YsyRvJKu1?=
 =?us-ascii?Q?I1s7hYwsptCiyPyvKERzSRo0HjIghvW3PeCMcU41CWGUnjhtKB9f8ultfwrP?=
 =?us-ascii?Q?E3I/ujNUp89u5YMfefUP4CeRS+9pSJHoKVFfvrXUTCQN6OZ7GZJUbEnNOEaN?=
 =?us-ascii?Q?tLIBHIXwV5HCKGJk7/+wU3CtkY+aMjnxR+RbB7EYZFGpr6dCeIK560blyNax?=
 =?us-ascii?Q?F+jkCr7kYwpq0sLQMpViRDzvzOpP/7bmCtnM09TqQHhkVjkEFlbmbMdyoWu7?=
 =?us-ascii?Q?gd4D2d6qcUo3bhrvdce5f6fF5wwVwcQCuIqBUgz1nV+i+kXzuX1Xk5V10hn0?=
 =?us-ascii?Q?z/BganvTXOYdIubKHTwq+l9pVX7KefrfZNPxR4Xto2tS/YNMMvqCjGasFSng?=
 =?us-ascii?Q?R5sfiYNo9VRkKiOO0PhJ13Z/nzb5HsyRynbeYP/B/pv9dIL0se/gfprzuQb7?=
 =?us-ascii?Q?QoIKB6129juqon+WLmD1cj7jPYAvHFBOzDLseMpqIp2uGIEJQoqAynCpB94r?=
 =?us-ascii?Q?8DkTbV1MK92Ouo0mkTQc4YRDVlYzvLsKCFk9IiFyjDbBlstXaVq9K4DfvJ6z?=
 =?us-ascii?Q?fTVHwZ58EjkQbKJkk1GJGwnxIbifOEQFaBBp1RST7ev4+KKEEvFkQmm7i1kz?=
 =?us-ascii?Q?jVK3NsCSIK/3hEQPcasAdqy/mIAwxKUkKpJjsxrVFJ2DaLiLjtuwmQtqQrVn?=
 =?us-ascii?Q?TTPqqD0wVf9fkqQu7r5B4A6kK+X2iRw6EARLFywKMtc1gj/MQ01TxMsV8ZTl?=
 =?us-ascii?Q?NtP5sRv89YsqHGCN+MShoWKBhea/jSNjDNLPGvnfRvLSOfwcpVy6QWzZ1vNl?=
 =?us-ascii?Q?D9/anNVftRE6seqB/QTpR7ZWHadwUGpfXk4K9kJr3JRPnOUbzZPLxrf8QcwR?=
 =?us-ascii?Q?7ANkkGBfxy6tQXV4kJsjYdiX+OD/3lmQY3vlw4GdOCT1gkN1HDeEUk4tBXQ/?=
 =?us-ascii?Q?T+D/KUDjJp6uHthW/Bxi+Vbt/OWtgdsNJxtEc3X5F0rnftBWSykK55LMswEJ?=
 =?us-ascii?Q?U2U6RAAmxF+92rN4FvjXuJ8LyJ+ifACy5sUqvSwIerL+fdlaFUy8F1xEClFQ?=
 =?us-ascii?Q?hcoIZaLrDWTCdwWjWtHcnar+tH0ZcQIOQQ0HFCwiO1Gi7kLH7B/oNbQJrHkR?=
 =?us-ascii?Q?e33AxW84MDH/B622RHFbFktKw9w/RLnHtl7qGplu94/cDsrrcsX88VmPb09t?=
 =?us-ascii?Q?wH0Z48+IeiUR35jyvy1Vo/2lBlGnktxyKJkV8w1+smy/ZMsJj+AskPz/dzf+?=
 =?us-ascii?Q?gjvGjVPkLiTUAEfpQESp8ERt4IZgNV6+vy7wWxyPv+g3sW10MOyEcW8NJtQ9?=
 =?us-ascii?Q?r20UcrNfhBxSSMexdMG/TsfxLnXQcyrji/w1+OSOROBzBLb+tHjdIVxkShzn?=
 =?us-ascii?Q?T3iU9uMtKcwNktnd/O87C10YQW8jd7ripUWrlUT3LkQ67K+m13tlI5e/6xN/?=
 =?us-ascii?Q?HhzWgVTRhr+Rh3CVvzVj6fncFX9YrK/plBWkCJBQfRk9w4Xv19MDe2Y1qMj2?=
 =?us-ascii?Q?UpDmxnPZY0t8G581TfgvyK8/gWpu8olbWWk8SJ7fOUOkpDwMKs2knEt5wRX2?=
 =?us-ascii?Q?5RoyoT1NhKD+R4FbQWdywkb6l1GTXQER+Ujebv1tbsn90yvv6IJvtsIpM541?=
 =?us-ascii?Q?yN5OovEDqXU475G2poLRDTk=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9daa80-8352-4c24-42be-08da5e991919
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 15:14:47.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eB8wDdlm+feHRFH6Gl4UxFkUAmYjw45nI+0u72SSIw9ChSpMUuERzIOvzXG8wOeqC2wjHV2w5pN4C2/E1Yo/c37OicSCXIVF5ZCPaABqgQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0632
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vasyl,

On Tue, Jul 05, 2022 at 03:59:31PM +0300, Vasyl Vavrychuk wrote:
> Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")

This fixes tag is broken, dd06ed7ad057 does not exist on
torvalds/master, and the `commit` word should be removed.

Should be:

Fixes: ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")


Francesco

