Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822EE6F472D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbjEBP2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjEBP2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:28:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA023422A;
        Tue,  2 May 2023 08:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVOjp93vTAI1j3OM9SHOdjC506/HDhs457zTQH0+rOH8BqYjkBALQSIA6QSjOEX+S0YIEa2PKI69k957hwtr8GAIyu5OrErus7VXemoCWT2HI2fDlxHg1c4CSnNtdICbHcFnR9ZpvdZJ5K/xhatxewOL3IepTSkMDVS9K9RA98rGFmNyH1tmq3HVJb/2uEThRLc4R1nw5nT94t6Fko3j+Iln9BXHLQAchYIGu3VX97bttR2CdMVeZ+bNN1c4TKJIX7j2oJSJTQpy1jOOB01FudxuLajq70tstoJG/fxZGUPJAU+MHUbzlFB0ZoMQze0a8Cp44vZwmtgK5+k1aZLk9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjzdrzlhMLFMNTiPm1TIZjdAjq+dpPYt8em/aNOJY1A=;
 b=gz43wekHaFHIxDtuvrjnGLJhiIUC8xIcFgrtfL09ffSgQd8MeNPZiHf02CFe8jFrm5o2XXvBZxjzJvoDlpKTsxjPSNVvffH9HdSq3QZYX4QIpZFy7KoXqqldumoZKw9DaxUDpYICY8oW4aKrYrB4MDdKSsXDfhlADYxcweNrOQEYp/98T3D126PYfonkyrrTcsMhEip0dE3blIzcGIBpnpckcP6ncdVDxTQpr/bdTYw+O4iOV0Ulf2pCChvSNtpzFqF5IkQehkz2wEq9USWOID+gQZh+bRXYQRFP4Aw5EKkDu5WUqMBdaY8f6XsqgqXWf7hyIT67WEr5gkcjyOvsMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjzdrzlhMLFMNTiPm1TIZjdAjq+dpPYt8em/aNOJY1A=;
 b=IFzpkUZ9uh8wX2zxgFEqWm+jNd9Gd36dGUwBcjfYGTHXhoV4MTqaqCoacrrxgxghhGeFKdgqaSA2WI+fr8VxZcSxf/MmE87t4YiJZijO6KaTbRsMRjW1y3KtB3jPBC2O5hIM14RwOBePWLtH0ojvaIsquDQI6i89c9wxdHVlcJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3636.namprd13.prod.outlook.com (2603:10b6:a03:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 15:28:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 15:28:16 +0000
Date:   Tue, 2 May 2023 17:28:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] 9p: virtio: fix unlikely null pointer deref in
 handle_rerror
Message-ID: <ZFEsClxYNiR0CQ7r@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-2-efa05d65e2da@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427-scan-build-v1-2-efa05d65e2da@codewreck.org>
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3636:EE_
X-MS-Office365-Filtering-Correlation-Id: ba5eba53-8643-42ae-e5f8-08db4b21d97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbyAcvfeTzG3xl9Aa/eGlC7MVdgTOv4xzKl8qa6A8gIqeSyJoZiUrSiitUR20h8hFYKEtorsOR1ipzgEqD2EbRnmHOOdt7OFzV4Wtevh1xK1n7wLiS1cu5z3p8kiWi43K17T9zmSsx/+BCq8kcI9lkFG59UMiidEMWZ7CiagJl0ViC5/iynhwAA9c0rQe+Y/Oc/TCeY2qkbPKF9VTqn5a4MSewSRNA4ndBH6HlI8dgvwbwu2QHKkJOn0yjsMHApVOjFFLE24YmRqRvPgJHDWy30KAFFpBFHr3YFkbUhF6tT6m8fC3eBVyt2QqW+PnCFHIueFY+BSF1vm4MAPV8l9q6XZsAahgW9i318PksjwSM4K75RMobwvkurR5RUDkdigGemy+iInSH0xztxcIRf9W/rMhLgMaACXKKfgVbEdDGKFPFvMwHPveCg7amwbUbiu7YX0Gv3lebDaca+v1GqNPWIrPAE1ga0s62piE5y1m/9z3Pxx+s3PAmWJ/phgs/mvfKnpBdfI2x8AIb75ArsslLATRY34ZEBSsXb3Wc/FA6tGFdGponeR2/rCJuu8Z7+R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39830400003)(136003)(396003)(366004)(451199021)(8936002)(4744005)(38100700002)(2906002)(41300700001)(7416002)(44832011)(8676002)(5660300002)(36756003)(86362001)(6486002)(6666004)(6506007)(6512007)(54906003)(478600001)(83380400001)(2616005)(186003)(66556008)(6916009)(66946007)(66476007)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cAO9C7frRM3NFiZV8kDsyt64CvVhTPwxhn117P0Bju1Get7gW49qS8AFtAAP?=
 =?us-ascii?Q?5BpfzPiVFtBGdf2ELrT6xkqxOWgt/43r4hlW2hvF5yDuDbuYBiMCSHISEez3?=
 =?us-ascii?Q?kCvj9Ra4sylCdbbmUrihkrJlPUz2V//b6llVZzM6poKPIpOml2d+g8ET87Ad?=
 =?us-ascii?Q?1W5yx0XFo1NMPARlRqK8HsD8OCw3Jx8IWxFjgMvVmJDIKXGX48s7JTIxcS6U?=
 =?us-ascii?Q?y0mR0ZIYAbUeGLdU0iB6M1XQZ7Kpwy+WPPCtBENW87YGH932/V4UM2dP8OFy?=
 =?us-ascii?Q?0IM9tJBqyVnBPwUtFW3VkLX4OM7AqLDNo2DZzxOza1GuDLrArrLNt77ajts6?=
 =?us-ascii?Q?4HTaOiuVEm2d1rKZymAC4AkTCqIgZ6SRQSKkHnz2vgA/nab/aO0w/caFdsoR?=
 =?us-ascii?Q?5IQ2y4ri52n0KNpgb+o4FopunYQwm8bXOhMzCEnyvRTusBS975L3tdrYxeHr?=
 =?us-ascii?Q?DGOG3CB8QTveFQiYz5tJG4zyeE3HEOO+E/laLwdyIrxz2w9wpbuglnOI7XMO?=
 =?us-ascii?Q?XOULd+O/MzKCGDJiXHkZqC/pXIxg5yMUIalk4ZZTIbGIeBmwH6YPxf+YGMQh?=
 =?us-ascii?Q?MMtqQ7qpdN8KLYVBOjrnxHjAOukxVCNwdrh8obxOouAalB8wyQ0URN99uN9L?=
 =?us-ascii?Q?Y/+Rv+FhgfjPx2UVmJa7bRAYaBZQjGSf003AqLIx+H/iltmGO9H1XFh1xm5o?=
 =?us-ascii?Q?rbhWC4AsUTUuVu0iJiIDU8beNEhUrNw3kulNTygr083bxJncI67gNmd0qDnF?=
 =?us-ascii?Q?RTOENRUMZjiJNrvUtVZiSMnD/tpOEKtu2QD5fr3RZnzqRPlsyxUslmCxtSrW?=
 =?us-ascii?Q?P0Fl2Ig4vZrR2ge/6PZMJk0j7R5whkKeR9wUjgyhKvtaHkK8YzsEAbP1Zwaj?=
 =?us-ascii?Q?z+gGBda+8VoIVq0/vlK0VolPnX5A+yBJcWYL/yqE9fO0Mou2qkFCW/S27Ckd?=
 =?us-ascii?Q?LqpSPvztHl7AcoT87wP2fiHPItK0MNX+DMURaAGAGizQy5xx+IaLXOjMD76J?=
 =?us-ascii?Q?xUC9qagQQ58HCCK8lGMi84yYFFih61bGyvUEIukmR7yoA7sIPE6UGcC9OLFd?=
 =?us-ascii?Q?/TW/Sti5PQTyCXvp4xqA2XV3N1vi8pXxrZjdvJU8+/OsvTiFTz15xyYh6vhD?=
 =?us-ascii?Q?opV+4e2yB+WH+zlkgMBjXCoUJSaOs7gOn76khEnugotN1YD2fZ5/olk9LNC+?=
 =?us-ascii?Q?q42Tus3hz72PNwhDGD/YvwcCg2jDJXRUta6JcyZKiovUliU9N7ncxSDHTyiX?=
 =?us-ascii?Q?Z6Wl3JxMvMA6T6U+5XkfGscREntmghDGWKmyrtTsEG/zPwnNtKdODqZ2Bep0?=
 =?us-ascii?Q?ekN+AQOxj3OrDfc/IQmiTwPRgbJWZFLcT4qzG5vsE0koWoAfQM9qkMDIwiXj?=
 =?us-ascii?Q?ge1mc+0ZHZowZh0rTuJElXfeeUSRH++gVxoRZQSdDM/iWt6/tfM/EG5SyVrm?=
 =?us-ascii?Q?9HCf/OawqS/35dYVr+ToGunQlBdyZNqFZiLgdpETS+K6QI/STxdWbTK1ZGDx?=
 =?us-ascii?Q?a8o50wX6h4X+gFBG/BU/fLm+luHtW7p3GJxfZt/6Gs0a7TgRt0Mj7wJlNtQJ?=
 =?us-ascii?Q?NhiTV0M844qaSXuT4PjVPyHjT8dwNuyDgVpSW3gNo3sA5SJIdtNsHZnqnCan?=
 =?us-ascii?Q?aRzZHkSWub+Ii/e33lq9Tj5Xo3Oq5smpKM4B1Td16KrgX0205NAEXA6zTOgC?=
 =?us-ascii?Q?vrvB7A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5eba53-8643-42ae-e5f8-08db4b21d97a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:28:15.9303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk1/P3oToTa5sRnUihfDEVLz7N/SiQoVz7+yNJPoH75sKAD4TbdU0HxgL9eCQ+kQM1FjLMIKYURAmR/r+AGHdvaP7Opj/bzMw79SkhoSJ1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:23:35PM +0900, Dominique Martinet wrote:
> handle_rerror can dereference the pages pointer, but it is not
> necessarily set for small payloads.
> In practice these should be filtered out by the size check, but
> might as well double-check explicitly.
> 
> This fixes the following scan-build warnings:
> net/9p/trans_virtio.c:401:24: warning: Dereference of null pointer [core.NullDereference]
>                 memcpy_from_page(to, *pages++, offs, n);
>                                      ^~~~~~~~
> net/9p/trans_virtio.c:406:23: warning: Dereference of null pointer (loaded from variable 'pages') [core.NullDereference]
>         memcpy_from_page(to, *pages, offs, size);
>                              ^~~~~~
> 
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

