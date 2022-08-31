Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6755A8407
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiHaRNG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 31 Aug 2022 13:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiHaRNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:13:05 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAD4B72BB
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:13:04 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2046.outbound.protection.outlook.com [104.47.22.46]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-r9uoH4nxNwyvaIJ3euqSaw-1; Wed, 31 Aug 2022 19:13:01 +0200
X-MC-Unique: r9uoH4nxNwyvaIJ3euqSaw-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0327.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Wed, 31 Aug 2022 17:13:00 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%2]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 17:13:00 +0000
Date:   Wed, 31 Aug 2022 19:12:59 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220831171259.GA147052@francesco-nb.int.toradex.com>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
In-Reply-To: <20220831125631.173171-1-csokas.bence@prolan.hu>
X-ClientProxiedBy: MRXP264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::23) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce783c5f-262b-40e2-7b12-08da8b740ebd
X-MS-TrafficTypeDiagnostic: GVAP278MB0327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qXXzX/AEh0uGBTCHDay+bBwc+/9xHay/+k9mpf2PR04o3YlCNLa3Hji1GmoGI+VRRMlfynebZPYxwV9LIL2vtqGFQaCFyII8aWDmmiz6/+4ostpZ1kPmvgz+exTWsqu7OMcEdpUhdyCdPNkMHOvME8Lm28ZpyKS8pVWNEU9yJ4SjfN9XFbJuuWbRLemt8YQm00Vi+Ya18PngJnTGsDRf/91+//hMuUKYrm+kIauB89SqoyniZ/DTNXg4VYyEi3C6YkKwim2Kn1xZVf5bi2eke6suwzj/zYlwfwzyIP3zfk7zFTmMqefubPghTJkqJV2e2WW7rKO96/31x0emDv/veGK+8zNsGj7bBE7d44/n/bU1x40+oA4XnKvpaPfnTtStL1NDP/rgJBsXkKsBvB17cGR/PTTJErrYrz9fEayUjVZBRDZc20MZbTHjRCsCBw0wzsnbVW9ebDSC+JIjTGfGsQsX1SCF+jmgSEXFd3K58u1BoUGSw57biEVbAHhB2bJqqGV7IgZPHOyMQHn4FoNLxKU730ielbj63p/lwVK9xZQbJ2DK2zVzErSIGDtY+Um7CHXuYeWDxTZeHO+23/RaVRuOOB9Mzfk4WTWajBpaEXBvtU6RwHbuA+2jjhbsxszxQlL27jb3/rTpWMuNEhfenF2f1zNZ2zAx69381+MosVO3a4CFiys9tn+qcgVdh1EdOjCY/Lr5uDTMiAaryYF0T59ISlVKi73/1wvxNIgsbaiMVzgT4uE0CSspcUN99lOEi/LXGQx9NQ6SSthxk1nUwlNvPTqdIeKMJ0h3rPox9tI8iMmlxyjoK4TM0V3ABiIE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39850400004)(136003)(376002)(366004)(6916009)(66476007)(26005)(38100700002)(1076003)(6512007)(316002)(38350700002)(54906003)(6506007)(33656002)(6486002)(8676002)(966005)(4326008)(8936002)(2906002)(52116002)(41300700001)(66946007)(186003)(66574015)(83380400001)(86362001)(478600001)(44832011)(66556008)(5660300002)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BinQDk4YhmrYei39aVlJHl5usg/5ttCsNn02JOq2S7yWrmSEEu48VMF6IJNK?=
 =?us-ascii?Q?u2SCX9qhEg9KpLD29K8ACGyWCCAyBwce3izQzuRRjyH08G3FwdRDwi/2r4Ic?=
 =?us-ascii?Q?P3mvBCFz/MI09EsRn97AIVVh5ZjGiAEVwK62Wtu52oNcyemiGGGOxvNLeMye?=
 =?us-ascii?Q?K3m+c1FA8MQ7mb1U1K2EcbPpkjjwcejuGmFNGvkIZKEIyhTQkB6yD3J1ZFMo?=
 =?us-ascii?Q?EoPBhbOhNY9MnVNWTWQgWXWNeLGBuaj9Uu56UtHHBWjygkZefEAKJEq+6lm/?=
 =?us-ascii?Q?grHWKY0pecoYA5v3FFPofc2u51WDcfyIxpNchWvjwii1k/S6YY0fuctcviDz?=
 =?us-ascii?Q?WA28W4tDQioI9P7GdnHfKvW1m6FYcmKfZB6WqXJg3HwmJxO2LtDdHmGJG1Rv?=
 =?us-ascii?Q?IKkqqR1QGtbV1jsCIyzDcbNgcJ/P7/Bh7z9/nsBx+/Iz5GSgtwzylP1aOQBw?=
 =?us-ascii?Q?AUMrnZKYOavDc1jITioUbFobcqWSx6GWKjdZ8txNhPXeWRZTgC7VpRAWFpEQ?=
 =?us-ascii?Q?vF89/eU7KqxGGcEIbdfg1UmBrFARB7PgfMleMc4j+CQB/YZh+5ocLTLqccSI?=
 =?us-ascii?Q?YeNP+ExyzdWqQx0aukjgsP/0qidlEcYx+eRA0uSa4ZGQvweyKlnK3pjj18ox?=
 =?us-ascii?Q?wD7QWtNndd+mWV4oac+9ZKHlIxGImJnpZzxmK6Ssd3v++LQJYfexdK8QGDpt?=
 =?us-ascii?Q?tDjjpVietxVYF6OXoSRIzxfkmEo++tfSWxAkvdjBTXb4jF84xPTJ4y7dl3mS?=
 =?us-ascii?Q?Zg1cpr137wNjLj54AKvlRUt4wIXP2j8YjQ0MeNDwoCNWTGmlHOnfQXjuT/rL?=
 =?us-ascii?Q?Rll05h6eBBa+LviOvQuGM7hk+xW23Oyljyjo1xIniRU4gGv22HXbqrYa6rhJ?=
 =?us-ascii?Q?mQCTtN+Se5Cu0iZKjoZbyrZsDAd6JCgMjipiry8MGMS9zc8I8ATgU5oeRwkc?=
 =?us-ascii?Q?aqEuQnYgveFTfHYgwG53cviRw5eE9uhjMIjYLgdi/cr+6/QuBE5Yo+TJH8cQ?=
 =?us-ascii?Q?APD2o7UM0ibPfHorYlo0G4h7klirnxtiYDFK3gkCGjYKM5eTxkbpnhBJsWd2?=
 =?us-ascii?Q?VuSz8mmhA9PBrrWi1gMja02CFKd3/Pbl254xKZyP59lBSzdIg5/cckR3xDrq?=
 =?us-ascii?Q?AS9CsEmUyGc+V2a3Jhbv5FI4BFjtMDr4pNRAH8N0Eo2P1YljVqnE8xRl4hQD?=
 =?us-ascii?Q?ohZBhgA13VRmEVyDowARFTlt6nmz0IbCOHh2LDbsUysupPKwoWSqdTB/X7W8?=
 =?us-ascii?Q?QLtNgzfWTNWGqd4xNjnGFUU+Rv4OBChNvWbPAnmChiXEE+tjJ8yAItkrTV03?=
 =?us-ascii?Q?ILhKJTF7N1zSi1HYViOfesL4tkJOMuK+eEcNO0lEhnQQM00GWZHFvGE6rnUl?=
 =?us-ascii?Q?TgtxVfOjX5ebu5wF7nvmO11dKW8Npv0FXwSkziVuzqfFBp3bAzmaBbwEvDwW?=
 =?us-ascii?Q?j4DX1Z35nbxWLj5aNM8e1JmZ7yruEruY35scwVR2ZdX49pZW98mGUUFLSttY?=
 =?us-ascii?Q?DsCXj2hCH5g3is0qyp+Yewr5vLsXiJf1bMVkG5FHdj16Uy1TVPKg4ObxIows?=
 =?us-ascii?Q?Jqjdkgkih4mCeeSoiyzqUqveH2Nuzk5soC4UtAt/O0rjUgcshtFWzrtd/QUA?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce783c5f-262b-40e2-7b12-08da8b740ebd
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 17:13:00.6893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ti2rWFsLfwt4NOMbNQNokbgGbAuvLzMFb5ls+/njm3msFyM+uvDS8YHglcdkwu9bugPRkJrXsoAI9Oj6GhbEVeQB1Z09AluED4gDGtBgG/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0327
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

On Wed, Aug 31, 2022 at 02:56:31PM +0200, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `ptp_clk_lock` fixes this.

I would probably add the kernel BUG trace to the commit message.

> Fixes: 91c0d987a9788dcc5fe26baafd73bf9242b68900
> Fixes: 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5
> Fixes: f79959220fa5fbda939592bf91c7a9ea90419040

Just

Fixes: f79959220fa5 ("fec: Restart PPS after link state change")

> 
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>

Is this https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/ the report?

I just stumbled on the same issue on latest torvalds 6.0-rc3.

[   22.718465] =============================
[   22.725431] [ BUG: Invalid wait context ]
[   22.732439] 6.0.0-rc3-00007-gdcf8e5633e2e #1 Tainted: G        W
[   22.742278] -----------------------------
[   22.749217] kworker/3:1/45 is trying to lock:
[   22.757157] c211b71c (&fep->ptp_clk_mutex){+.+.}-{3:3}, at: fec_ptp_gettime+0x30/0xcc
[   22.770814] other info that might help us debug this:
[   22.778718] context-{4:4}
[   22.784065] 4 locks held by kworker/3:1/45:
[   22.790949]  #0: c20072a8 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x1e4/0x730
[   22.806494]  #1: e6a15f18 ((work_completion)(&(&dev->state_queue)->work)){+.+.}-{0:0}, at: process_one_work+0x1e4/0x730
[   22.822744]  #2: c287a478 (&dev->lock){+.+.}-{3:3}, at: phy_state_machine+0x34/0x228
[   22.835884]  #3: c211b2a4 (&dev->tx_global_lock){+...}-{2:2}, at: netif_tx_lock+0x10/0x1c
[   22.849669] stack backtrace:
[   22.855340] CPU: 3 PID: 45 Comm: kworker/3:1 Tainted: G        W          6.0.0-rc3-00007-gdcf8e5633e2e #1
[   22.870713] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   22.880149] Workqueue: events_power_efficient phy_state_machine
[   22.888999]  unwind_backtrace from show_stack+0x10/0x14
[   22.897107]  show_stack from dump_stack_lvl+0x58/0x70
[   22.905067]  dump_stack_lvl from __lock_acquire+0x2844/0x29d4
[   22.913755]  __lock_acquire from lock_acquire+0x108/0x37c
[   22.922065]  lock_acquire from __mutex_lock+0x88/0x105c
[   22.930203]  __mutex_lock from mutex_lock_nested+0x1c/0x24
[   22.938611]  mutex_lock_nested from fec_ptp_gettime+0x30/0xcc
[   22.947278]  fec_ptp_gettime from fec_ptp_save_state+0x14/0x50
[   22.955991]  fec_ptp_save_state from fec_restart+0x48/0x8d4
[   22.964410]  fec_restart from fec_enet_adjust_link+0xa8/0x184
[   22.973004]  fec_enet_adjust_link from phy_link_change+0x28/0x54
[   22.981898]  phy_link_change from phy_check_link_status+0x94/0x108
[   22.990954]  phy_check_link_status from phy_state_machine+0x68/0x228
[   23.000153]  phy_state_machine from process_one_work+0x288/0x730
[   23.008968]  process_one_work from worker_thread+0x38/0x4d0
[   23.017289]  worker_thread from kthread+0xe4/0x104
[   23.024758]  kthread from ret_from_fork+0x14/0x28
[   23.032065] Exception stack(0xe6a15fb0 to 0xe6a15ff8)
[   23.039664] 5fa0:                                     00000000 00000000 00000000 00000000
[   23.052816] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   23.066101] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000


Francesco

