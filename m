Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA596CDB11
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjC2Nom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2Nol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:44:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2137.outbound.protection.outlook.com [40.107.94.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1546112B;
        Wed, 29 Mar 2023 06:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsZ2IiA8xtPfsc5j+slXSZYvI9bm/EzUFwnl+sYC3kHIqdM+s59aiwnVpOSlFqVJp0nXdv0uL+RLZNI9fHKtvTJh6/0ZkmPuH5XV+DjUtqnzI9+YcNU+jCspa4zctRXSzDKyBKJp/1DGDXmWNfqmiwHYORQi50ksQ4jbkCFWUpZa8J/j5F12Wg+P0NQkCFCceX+oyjs91gdmXH8TPWlfExtw9M9VA1bumqT2m6D21P5JYULFY8vCgt3Eu3cPjT2DPlEBh7MZqef8AnBPSy4lUEIHWWwnSqQ9uD2q1aj0Un40q1mYZPbDtBdPni8rqJvS61Z/nJXS9Pp/5DUdgkWu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cZgvEgWuw8Wfd4ETHIba55NNu55qBJktvC36s4nSj4=;
 b=NWPjcn0EpvccI6W/Z1MtBIr6S7ESGKSJtlVnBc9MhiHwA76c2UYuuSP2ZgauGVRlCg7L979T2AIoazafFcwT2xlNLPpD9f70uMV1FYwn12S5fpTfUG2sMT95pzLBkeXcqD1QGEdxtGJrBDdL487FUc/Om8rcvL1YgQFxjMT+4FXwrO07NHohIvommpjQ1aHMGcNXeXIgNVJSddfdxsG647P73lrjWlhZI31MC/1xfPaDNP9nQvU90PVE2q29rNktFJLwMp6kQXANHECRnYAfl+ubbL75l4FnSm/CIxLozikjMmCiCAL7mNJb5iPDGwZJT9QwBLsnuQjh6qaz06b+vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cZgvEgWuw8Wfd4ETHIba55NNu55qBJktvC36s4nSj4=;
 b=H9BcRTM1Qq2RlhBi3OSkZefbGfSBEgzAIo8c+70A6/qmlBUlx1EzdvFqbEMJLK7BasmHvGfcUCTvZTYvQIzixHtuLTwu9dcH/EbydAo6fZrU6/T0RN8Hiy3l9sgmc6ZKGFpSL0nYM8bKL+qTaiKVCVlbnwA7vRjV4uc1DojPsFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4831.namprd13.prod.outlook.com (2603:10b6:806:1a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Wed, 29 Mar
 2023 13:44:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:44:38 +0000
Date:   Wed, 29 Mar 2023 15:44:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] mwifiex: remove unused evt_buf variable
Message-ID: <ZCRAv0NoYMm9EV13@corigine.com>
References: <20230329131444.1809018-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329131444.1809018-1-trix@redhat.com>
X-ClientProxiedBy: AS4PR09CA0029.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4831:EE_
X-MS-Office365-Filtering-Correlation-Id: 7357e4aa-d59b-40a5-1dc4-08db305bbd31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UImNiw3rT3h4EaiGIdDRQbc4AmZ85iuh9VEdeb3WWvfaa+6PsR+vlkca+jn7GJgckEBSebKSorfsC8H2qmjv8QKDFlyjk0Q0V1wgbQYb0THqsEA3RB1lJK7zUmGTpmfXDc8mmGwuRVQXFr4UtGkkafFzQUmTKOcSJBRjJkicCu5vzyHc0zH/v5FLz5hIYQbm/6C67PsGioT+9n8mKpNzJJ31ORgiKrf2T17zU/jHVMw+2fISo4DRI5W/v43cSBo0OT2/2tjq39R7TpvTD6GZ6xjM3Zjg5+l0mJzn36xN1o/JrKqctEhqOax8See7rd45GDjiuveYQwzJT6ozlEm+EbGeBwmV6bawucDQLiFhv4HbvTSZWuqJALQwm/vOKLc6SVmvnNVj87kpqjn7zMEU0mHLIi4VjJpvkxBP16Kcge+JwfvWp160/tf8wHKovZ6jufs4g0aTmdQLMZJ6n+3K0NXrGxZK1fAB/hLOTPCRDSGxXkzLGGI40ncfskAhvFUrT1AWeVqO3SbzJsa40dIr2PHWdAt8pN/U+dV5uVzYZE0GxSfRWpKbN2TwQ0hpCo91WHne7qZ77j8eTYvA5/7bTk5yeB1eEjYSgGOkvkc4ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(136003)(346002)(376002)(451199021)(2906002)(44832011)(8936002)(86362001)(66556008)(66946007)(8676002)(66476007)(41300700001)(4326008)(6916009)(36756003)(316002)(186003)(6666004)(6512007)(6506007)(6486002)(7416002)(5660300002)(4744005)(2616005)(38100700002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/vEmPH1xluxcYT89+b+umosN3mja0Wyy5tU+6G1CjWriUV/2fTshAsxqMQw?=
 =?us-ascii?Q?QNjhZTwQTBzpFl/sYhqEbTcFER64Z/yop662zt5l4W575ef8L6KWDC9+tusj?=
 =?us-ascii?Q?vEx4waK0YPVStvZi8hu4BvNCF6w1NFkvga79ojTxedI04OW1JZU6wrVT4X7O?=
 =?us-ascii?Q?sBqekSUVx+ZL/ZUKIch7z0Mqr7lluDZvg6xag0Fc5UvNIjm93ztUaYbz2DHG?=
 =?us-ascii?Q?4f6Kd17mz9qXvHYLa6CBsVLMcoVvXzPMoRnbCtWCWALoV1+WGc+PbJb3IGco?=
 =?us-ascii?Q?v45IoOxDnUcluxRPx9ajo/N4Hw6sieKzfXo8g+U2UUSHEMRSLjWhbOs+5vXX?=
 =?us-ascii?Q?9dxTQxt37U1t+NyNtP/WpEwRtwX7BRjnrAWv8C950ZtGbZ3TZjWofqJMKmYj?=
 =?us-ascii?Q?hKcy7120h5R4q2CmiJVo4A/EKW9gW+t4EUpzNlccWDLqEAWVLYGgfP/8Vt7w?=
 =?us-ascii?Q?8su6yNJrsO+mGPLEGTEA9ZHZ0cxJmsFOtzFTX3AXDql2oM+COOeiRwr9N+vA?=
 =?us-ascii?Q?MFRXjvsG3fsb3r7pupi4G7oMSEnS2voCAdoJzeQvgCvwD3p9yADPK22PA8nI?=
 =?us-ascii?Q?HkeJgbAoL9JkJBnW3J1xxqX+6gin2z7WNQgPxF6k9IwFBwicTJDpRP/wfWy4?=
 =?us-ascii?Q?U/JfrmxlbZ4JGr6bSWwVxE+RnHjkXDyTRfPBwmEGGN4iuto4C240+5qyw3Vu?=
 =?us-ascii?Q?4Buu8cOEiedVEgOuzOznhQ4ZmzPHMFJLhl/+De3TgP0oNW9WxokH8A5pQWbA?=
 =?us-ascii?Q?i4i8FayP+O2yMXlKpbt5TWzOzTF+fYT+piQnrIJRPDF6HMwgaHQ0bvGjC+PN?=
 =?us-ascii?Q?m/dSg3PRdN4X+GixNgG7Lh6ooglbgyMfc+GwEhJ62LGUYBRaCJd3lhaRtjJ8?=
 =?us-ascii?Q?nTcEBoeChd7oNvFGa1fuCyaMyjqjXrBg2QG0lOvkXo2l/qPrK4afJn4BJYtr?=
 =?us-ascii?Q?Vvvf49bdjwPQGrIaaqk5IArImCgWBlGCyvA9dWItNtTaaorhVwIGasyTt//B?=
 =?us-ascii?Q?3TOnc1FNHFCle92jewl6aeHxUbTGBEOaCGstdrkwXG74AbUgRNCGqNJRPNzB?=
 =?us-ascii?Q?gbqvDmIIZEbQMZazgxo50eyfYccW5C+49s/sUCVXDWZZLPt6FngQ9jIac84M?=
 =?us-ascii?Q?3PLxP7YyrxtHh5GdQPQ1TamSrYLl2hZg6MHfS1fiQkC4h/vTV4gUzVNcfd6y?=
 =?us-ascii?Q?79OPR7CO6KAx6KAWvm/lC+VMeUwXmGFA6uP7zjWb13WI0aFT+cWIcfnE0uWd?=
 =?us-ascii?Q?WJrFhiVERfHbGuvF5Cbh/ik10BhC0eyhXcyNYyKuWtRUSr/F7KOcPpRO+ewh?=
 =?us-ascii?Q?fjyn96V7FkKWkfjatyqNYYherSyUCl27I4G5JyctZE84wOtbKgs6F18aNaj/?=
 =?us-ascii?Q?+RbCFYcDUNMrmHMdgHpIPw2ox6b+tsN6FeMniLpntvqIuUg3jT/lZAUlXKvg?=
 =?us-ascii?Q?SO4bJm2/HPJ21UF2YXQxsS8fzqLzLtmz2HcJvooTKrYGR9i81Kuywo7gqtCL?=
 =?us-ascii?Q?RaQVk9XgpG1sCXl4srIeUrAmysUoYGcwYIDVBlLOgfc0d4/n7Q8Xr+O0jT12?=
 =?us-ascii?Q?d4Q5LdQtZQ7Mc5qRrPfw0lg3ap14BRavmSdqtWhoczl1t0TmU/jYvdescaaR?=
 =?us-ascii?Q?qTudXH6QhuYCj0sO706Z4pXB+ioOltV14Ya+Op/Un7S99533EPsbo4FPuymb?=
 =?us-ascii?Q?/EQIyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7357e4aa-d59b-40a5-1dc4-08db305bbd31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:44:37.9621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YQoFhGoOjIry75wt4GrvLtoeHQ/VGOvjXSAKTMvuUoXTYvyeN9NI6dsqc4EQWGUngEkCQHJ4jrqMYKCL9ONyJITk08u9d1ANGUvaOz12t8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4831
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:14:44AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/wireless/marvell/mwifiex/11h.c:198:6: error: variable
>   'evt_buf' set but not used [-Werror,-Wunused-but-set-variable]
>         u8 *evt_buf;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

