Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D85AB722
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiIBRE7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Sep 2022 13:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiIBRE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:04:57 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014919294
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:04:55 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2043.outbound.protection.outlook.com [104.47.22.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-cUr6CQrEMxakLgSrrmJdpg-1; Fri, 02 Sep 2022 19:04:52 +0200
X-MC-Unique: cUr6CQrEMxakLgSrrmJdpg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0827.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Fri, 2 Sep 2022 17:04:51 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%2]) with mapi id 15.20.5588.015; Fri, 2 Sep 2022
 17:04:51 +0000
Date:   Fri, 2 Sep 2022 19:04:50 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220902170450.GA139955@francesco-nb.int.toradex.com>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
X-ClientProxiedBy: MR1P264CA0140.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::6) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb3ed6fe-57a3-4384-811d-08da8d05401f
X-MS-TrafficTypeDiagnostic: ZRAP278MB0827:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: gUYFk1or56sa/7seaXPMnEkVZBGPR5uItumZ0bXEodoVWqsdp5JHdfaIsBL3SJzDRIzU7rThHiLG1V4LDSwwJjoLw7lPh480Fdj8a3qjZqi/ltNJHXSNQ5DgxhKz+ubvkf6NQOUDB45J61tiYDM0Mo0cW7e4PjrOduujTv7cKfNodzttqKtjoCK1Nug5n4ce7msjcuCyGLLVHdY5BkX8tTnbnq0jnzfM4Ex83ugdGyWHhE/bLhCvOVMPJZDGpjbpdTpgCf9O9KT9P0hNnxxhTTr0hBtneJebVmqQFpA3FqinOMIDC3mVscUJ6oDNcv4xvbiIWCvUuyhF0H8eM1L6GjeI2L2dcYT73c8slCSxjPZGjeQnjMHGjhnAcCq2QV/s26f9Ar1yj0Eq7Nvr5CYF2aZaympETQUiA0eu7ngUOMIUhNiEwvNQoDHehqHj2IxoVXt2NQmxN2gJkyNSfDVflt9CFW0jhSQrDHRLnv0is4S7V9Rn8JAlHhexRKYBLxkbEk14AcJsYNwjKFQ4PMqq4GrcD1i9xuTqEr1rr4nDG5lWWI6I3MgTUrjhdI1gKWETv7xsgw9ALnZerEhPV0SKeUGakS+R23RSBJG4LG+rCVyEkC1u3qT1REH7fqYksbUQ2spbpEC5ze9XQi+pw1SOu1/JNMkhISeKtZyOhiwc69FInF6RGLqi+8HKfMfdagTRyALRZeZZ8JnJnpBSZLu4AG6j1MZpjYF6Zphmw/kB7cez/zw3CSHx98eg8BE6MsfMvL4Hd5SOtuvgU7euRJk8O4oCR5aN3bfG1GvRLcZtb0PDGX5EBDU8XrBlF05mZyxM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(8676002)(66556008)(4326008)(2906002)(66476007)(33656002)(5660300002)(8936002)(86362001)(41300700001)(6506007)(316002)(44832011)(6916009)(4744005)(966005)(6486002)(54906003)(478600001)(38100700002)(186003)(1076003)(26005)(6512007)(83380400001)(52116002)(66574015)(38350700002)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WTEYB6WEKi1ULg0dCmcqOzhpZFXZ1/Z3QZC2qiAfPbR6pPfFPe9LMq7sk+HT?=
 =?us-ascii?Q?N1YVYnZwBhvEttel2aqhn2VnpTqJ4QOsyGFHbhGCAxcKr0cEi5AG0IKtqBk6?=
 =?us-ascii?Q?GM5iqN3AOeat1oXsuMzhEmkA2rP5V5jb4X0IRv5BIohDOMLm9WV05CqC2r3Y?=
 =?us-ascii?Q?5cJa/TgjbPPQnaQWD4eSCXbOuTwIUNvETv+pzYOCevTlUiZZXxwenvwpcXge?=
 =?us-ascii?Q?hnWSGdijWFY/w5klmhFpn5SueZYYigeLG3gPgHr2UPeRgswmv3diAQeFSHhG?=
 =?us-ascii?Q?uD+LHKOZ/X+TFNSbgKjTzAEKEtcQ7h1rFichex0zoBBGn4YyM0MyGTVobzjy?=
 =?us-ascii?Q?kYGDdkOqM7QCRuDcTpQWK2FUqUgj4pGXLo7e4jFTkqX37pflRa3lt/5J+gk4?=
 =?us-ascii?Q?jOy8DRHrdrjiS0oO58ytByPEAaIUNEwUSsMd7G6R905ptzrAxhH5fSPEj6/l?=
 =?us-ascii?Q?rRTPJjixLgmGlGsqU0NmeBRCJHa7nvdkOC4ZHFioV6tUgySIvp3PQmwGWqMO?=
 =?us-ascii?Q?+IsBHzAjsWI7saP41B9z+C8I+VvVTpdgBT3F9UfNt/69bB3If/f1R1hYTsh6?=
 =?us-ascii?Q?Dm7R+/8EWnmoyBOiE/qcuzWPifuHALWQnFwhGw4o2zVvR+C50V+K2eRUO88r?=
 =?us-ascii?Q?+nr6Gy7O484nAPrpPVzzgpqDXXf9Q3tAVD2fJoCxHsE39Goc4PL256ay5HOr?=
 =?us-ascii?Q?hDzw94z27nl1nEyanuyBfIGeJtG2yg9524caOA/duVy5AlMMjoi8zZanNetA?=
 =?us-ascii?Q?TQoyc/7/NzEPDchqsaCcjg0iMBwDO4Op0UO7XgzzdjClpKUDGeSxkw2UVGg2?=
 =?us-ascii?Q?80Ha1JeOhUxETZPpNlN7zhXbORRjlqbTAQnXvSuPyGjzUbTczJf35eYzTXwq?=
 =?us-ascii?Q?jHmGLg2IgUHxrm5luSC6w7rb+o7spFAcPOYaRSO3Xvh+Ke8m71MHMFhOIp8k?=
 =?us-ascii?Q?G92VJPxs7ArxQyYyHXsElW1gFNe2sTeK9PKAhOK30/Z3O+ffIWZ0o+fIQJax?=
 =?us-ascii?Q?DGzQabQYRi4hewQIV8pSquiSIkj62+gwEFzrvHVDS65IxioRCbplCY5rVqOi?=
 =?us-ascii?Q?FpP0d69CFoOJ/cXa2Y2IaJVDYaxlN8UG6X8EPSmEILZgmk6E4m9N/xyccyeh?=
 =?us-ascii?Q?epqFWjlzgiMv0HeyLcCDWN/ol5b7R+EKZMyv7HkBnW/NMi5iryUBE6Aw+TxB?=
 =?us-ascii?Q?H0SXb2ouNjYweisV1h3Ldu7/XNzPczUVgQsGxL/tiYRnQg2vkLICDPIlr/tv?=
 =?us-ascii?Q?Whq42R7lTpViI8cFf9P3M2TqRSBFRLNIt0ufNyg1uqDTbGBAuQfM8Kwz92xC?=
 =?us-ascii?Q?RsLKoeyKc3w9en9H8EwXfXgxOubjbGvY9MvlLNwyJFETKol/Qmhi6uY2JRx/?=
 =?us-ascii?Q?1pvgKcg7vpK/leBhiy2ZmDsLeWOAAZbhZqm9ocLzs1H+SylftOHapOd6rtLH?=
 =?us-ascii?Q?4CkVoq+iV5Y9OJxXu9CZVxSFMwzcbunIqYh403srCICs+0jYwInUJNLmDpLf?=
 =?us-ascii?Q?ZEzWRchcooJWeKVkj/Oi+0OfjjhlRNCsuV98O929wbX6W2VA0AOVNZwpzQr0?=
 =?us-ascii?Q?1h1xXM2RavllIH6jyec3eanfej6lLGcB8UutyR1jt7/EkDiKZFoeKR3tCTeU?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3ed6fe-57a3-4384-811d-08da8d05401f
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 17:04:51.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVRx0bUWvEglBmqwiXZv2mIX1nyUmArOioY5Ku/S7FoeCSyzKSs21GTbtHk61z9zcCENFqVzo55nPiQfFRDT00RMPrE9V2zu5WKSbocOg7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0827
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

On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
> 
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Apalis iMX6

