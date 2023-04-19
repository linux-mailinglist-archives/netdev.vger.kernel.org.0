Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A007C6E7675
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjDSJh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjDSJhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:37:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20705.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::705])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C19C1992
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnvQDL5v1HJ3hWKXHq5DlL3Q4XZfS1RpUQOvaNXsgi451fLq0H3QjQ6ntySXfc/ArCm7CEUufhUAKyS//WggpfwzNRLgpip7TeesMpT1qoyMfsV0t1gbFW/0doUJ3+GDKzQMe5m9VFN6hlLrbWle7ZZK5922w9rZEIx85mFUsvFsmZjHeg1lZHJ1Ioeb2J9sdCDb2WOFdfBq0swELrXAY5R1McxBjMIbHWBfLZm/JhzWjWi/4A7wABCM4zrZeizixFrJJroV5rwQ5qLoYiYxXKiYyW9NRmeXjBdNi5ZcT55+Va8OtXEBBJxB7oEbWAILGTlXO8ZGdhj72fjkf9RcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itP34hBhj3nxlrRORle7PxFitPCS4lbvO4rPl6GJtb8=;
 b=V3jSj4gRlXWGMfYEQSH6BvYj3z6j2u3AgQ6GTY+eBh6SF80Nka4KY1RtJbNKrSJ4Ei/yaPUGem8zf/na3L6516spLPq/AkOOR90/Mg6ry4ypWFtqtBVMP/DSGfOr8B29DOxK4Rg1U/cwMs9kKoF0o3PXbhYpAyW14V0Ipp6owWaWhCCX9b4LCG4ReXzMkrYZ8mRXVvjWVFJspUOTJaPeh6T0U0cH6zabfigmJrxJiJeShwk0YDX7S7lwmSA7eR6WOqP89dvsnASJIQB6QWf9GUzfCpz2eDWR6vS3r0VuaZald7R6I0IG6eiYl7itxJzvPleCVNvViYPtre2Bhwelcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itP34hBhj3nxlrRORle7PxFitPCS4lbvO4rPl6GJtb8=;
 b=YArKc/0jvhzJAiy3Z25RTdVlNOuiMczO7dVQ6NjyO2Q6Bcp8A4/d+cHnuF2Mbea1e1+urzU9gjjW9suNVXDQ8XpIb9NZtqhggkq00463H1b9pgDnQnwaVF0HDnTlZ46Q1bYwxcFUOfxRhThLz9JY3JKL4EycQilAqpUkP3ThMrQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4664.namprd13.prod.outlook.com (2603:10b6:408:120::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 09:37:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 09:37:26 +0000
Date:   Wed, 19 Apr 2023 11:37:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v4 1/5] net/sched: act_pedit: simplify 'ex' key
 parsing error propagation
Message-ID: <ZD+2T2S+fkyX1mnz@corigine.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
 <20230418234354.582693-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418234354.582693-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P250CA0026.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4664:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0f9abb-92dc-4cad-634a-08db40b9af78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ulQCHdBH9f9UlwwiXgUliKMz+KF3nt/IilkdgOxLsyRhRz23nhTxGPtrLJETM5yOlKF1Q3i0E0gHlW8HBJ60rNk4Sg+37N+JwMo0MJkAL0pmpY4KM1Y4OSa/CqMLl5rC+YTanw3OHz1AcwJgZgEP/XCd82Bps1I1zD80qUMivF4caS7jAVhgk8HAeAPA2zfY5CLnjw8lx6UnEC0LRzoako24V7ljpRpZBjuyhqqpn1xoeihO2JkXoS6YJez6LnzYpG/FV9rA43dl2/56VBqMiVj+thcgdPd30soXISnq6/6e8/xWe34mpgza+jXT+RVIJNwatSK5k/vroj6TAFWrMbH3QDlTxUSvD1ChOKh0FSyQeNeMcWjRH/QalDl3B4ZuNUOIMCrPhu/0FnSfLx10YagqYRd3HI1zzjcxwKEVg4xs0gNWq56fuVO0rSFllKh7ue0Me6Hy/u2IKfBs3do44JcHvdh1byHjqVVg901VAqkFdAHMGzFeyRntsaX4xHnVRWAwBBfd0IjgfxeZ/pOYHp3gA0O0wPWkqsYjikY2/+asZoJjogMSDpRFGnjQ1s6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(4744005)(8936002)(38100700002)(8676002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(478600001)(2616005)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sJwFrF3HMyagawM3dVE2qFIyaPYYdKZWvgYXZ1Ccf1LLaxCpG2ZM8c+NrSl8?=
 =?us-ascii?Q?QHFBU1mRfbiTBq67U1RD1kuJr1FWePw8CZCuRkzO9YUpeQtEItzncnMIyMbx?=
 =?us-ascii?Q?47ZYtH54Xo0FHOdSD9+PfnoTDByS2LRom+EtHMbrKr9dMzcZUiO/5ibtpv80?=
 =?us-ascii?Q?nfE1rANCTnFwLzx1qnywIsT23Q3xq3fwwX78Wc+nVBxqQu62y6aXwOb/GAQ4?=
 =?us-ascii?Q?HtKAslsxv9YzaQOPhnb7m6HqxYgcknLW7ZEK+OAwRF9QvSfyYwAkJivZlMBv?=
 =?us-ascii?Q?xD8q0piV2tHeaoN4T4kCd3ElAwVxEQG4hCq+HN9xBUQlgsgmcdV9w2C1y1rg?=
 =?us-ascii?Q?63w49ZG92qAY55Q1/A8s4KSyKKMJVN8bU2h0vfj+URc0danYmYxwTZNA67Fp?=
 =?us-ascii?Q?B6tIMi1IHgnTPPj6+HXjNP9udNYbWro1+e3mJ21H76vJQiYreqLhxMNaYDEe?=
 =?us-ascii?Q?w1oOJ7CY3J3lr7fGeXs36/tDrgoel4Xi5Mhr2tZmZtQfmR2ho9QeAD132guK?=
 =?us-ascii?Q?L/6tQS3ehMzAEJyFNSuNHRnZlOli4pQjxmXiT0arl2/wp1LLslzdxyqvLlPH?=
 =?us-ascii?Q?ufggTrDnK3FI9es5E8kE2I59qtosJUGR3+3c9BSsDrh/LSGRIgnHXKNt/MVC?=
 =?us-ascii?Q?xkKW+i5bTLyxZ3CwMHiOoW5zydjTioUriEmo6EM+VwNYPciswBqizKQkREPO?=
 =?us-ascii?Q?+8PKCNRIwqS48HNouFQrjdrkVBillY0yM6wcJ9nc9Keq6ArXEYFAPzGv9LQo?=
 =?us-ascii?Q?syP/m5qaaYaWYzUmrWrHGGj3ZuW5Z65DJyPvefyjOuC8P9Vk00HnrFqvg2VA?=
 =?us-ascii?Q?w7+tszkyU9KlQv2+X/dburbop1wsxieeETlecBhFcImsTLk1sWFYuBwIkaz6?=
 =?us-ascii?Q?XUveBXwdhewtWePmHJ/z+g7x1yPIUPrKPESeBx7eyzOhztoAuqquxpsE18qO?=
 =?us-ascii?Q?2QPX+ETHtHL/idmUO0GpD8sygnuhqi9/HACnqdpPxxYZAXuQNzXLI3UL9MYQ?=
 =?us-ascii?Q?vqV5cLZTwGdnrwO11rKS8rDy+wIlMhHcbx2AVrbJn012GIpU/rbtJWn6SlkZ?=
 =?us-ascii?Q?OxMVMfGDuM68fNZe1RMcjv909j1RZbqpCnhitVUuTrRYBGFImfJNwI7yJfOu?=
 =?us-ascii?Q?vVNGOnBP2NNDyQTOodORcCQGS347yQfxYejkW6Vz4Yv0ffFQ854+AZjvRfeZ?=
 =?us-ascii?Q?sFqioMQ9dV2u8HUb8RhrqCFouEcPl1L8ZSVpU5sxDGcfnpPvCO/jFv300pxu?=
 =?us-ascii?Q?PO7mAtgsOHqI+/zeUeAiCRpty08wm9MxTZGLizf18YIDwoL97UrgApuK0Tlc?=
 =?us-ascii?Q?f1ohGRRfcFumXKiCGBH2JrzAhdN/GePpFG1RxqcbKDcRLcziAK8UKHhe9uI4?=
 =?us-ascii?Q?4hEkZ5mAUUi/rftT6A3xBFfja7pzJ9+nypKojcW2oHuPNgWkmk0bvL+bt4Ze?=
 =?us-ascii?Q?HMKOYW8CxNl8BISbFgqWGvFCSRG/H3mCMwmrHrhHQRAuR9gpS2ikHqYoA4c8?=
 =?us-ascii?Q?CbqK+GI5PSNW2Gp0pTsE1Ql+6q+A/u+QfE0OznYCKKW7u0uuxyMJZbFre4ry?=
 =?us-ascii?Q?3t493AL424NtedTEWEPzywklw1eITLd9RxrhcB02LIIO8dngzfsRGftOjPOz?=
 =?us-ascii?Q?Pr2d2U4hwWYzzhNraen0V/OszNOpW97fQkr9Ua+jLvaXtK1jtDkRh2gK4dUW?=
 =?us-ascii?Q?gzEinA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0f9abb-92dc-4cad-634a-08db40b9af78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 09:37:26.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PWS5avuYJnlbdppgnvNnYTQ1MzG1zT4CU+dcWDMHiYYgxBWsMWGEnNiUAGEc7GdgC2cij0mCMir9pYcEGLZCnCxUkumONFF8+lZi2wXh5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4664
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 08:43:50PM -0300, Pedro Tammela wrote:
> 'err' is returned -EINVAL most of the time.
> Make the exception be the netlink parsing and remove the
> redundant error assignments in the other code paths.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

