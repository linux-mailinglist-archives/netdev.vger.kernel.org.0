Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EFE68DD99
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjBGQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjBGQHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:07:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA34E39A;
        Tue,  7 Feb 2023 08:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJdunNuin41tsCNUuLRbr1wGJcfMjVoHQ+iIvu0u25ePmnPUT9uMQdLlLjnOfW0E+00feKg/w+hqmBEWZ6Ngh29VY4vbFIHjgb/7CuFoGL2nG1oemSBFK7MWnua+l0+eLLRFbC2CgGIDyMDpQNv7rNXVF2j9ilZKJvm6YpUk6pnYB5AtwqRgM1oVkvxs5dvbQkTt44bTBWQpMceMYn+AchcGh47wTIAwxx0BV1xdd5ieEQc2lRtjkB7LOdO5e5DmlH7pN+kv7kkvtwFXv5HNBPTBzFFla8IX9wR3TP1n871fnEqXyvt0G04vAYbQGdLZdezYo5veqchVRPhBJt30iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqW+0/yoPwJLSPtuCdsxzmsZ9WckoY98mJIA31DU1iM=;
 b=SSiLjdEMRrWH4HJHjUHxOtF16RB81PDUwxndPnLYiEveevaB3H9M591EPzomY6wdZWpkRt7RXN2DNNfGs32OMu+D62YzEZGNL3f0LQRHQfxO0+wI/zGkxxouC1LNdPrhBlIxS6NkLVS8LjaFrUofeBdmbAPxhh6YyXQrhbpL+mu1QeA7DN2AWpkjltEjKqk+XpQhaF2tI97nQHSOm77fwmXvS6tzqLUF83C6TnuTz7VMy51Mc1dcSHBoj74GvwA/IQGubct2tpGAF9ZLVCLoYIXGpVrjMJAm9P9g9UFHzoWOfJpoTwXobUqDPBzz4N9//m7h/CGLoyjE6aK3WYIY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqW+0/yoPwJLSPtuCdsxzmsZ9WckoY98mJIA31DU1iM=;
 b=c/qtwOtGvVlsxlnL44Vto1K/bPY3IkNswnVwQ2KoOGUcJ6v543Cvfhww/vMuTNv4Ovv6dNHBfLl/HZdvxmo8+68Gwoa0fyn9S0a7qYrQLgQLio7o9xR25SZ0ZjKcKFnupbCA53AmF0+jXoLjJP6Qh844XWnA8PRBgh3DYtN77u4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6301.namprd13.prod.outlook.com (2603:10b6:806:2e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 16:07:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 16:07:35 +0000
Date:   Tue, 7 Feb 2023 17:07:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Bo Liu <liubo03@inspur.com>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill: Use sysfs_emit() to instead of sprintf()
Message-ID: <Y+J3QBuOYSj4ONrh@corigine.com>
References: <20230201081718.3289-1-liubo03@inspur.com>
 <Y91bc2LWMl+DsjcW@corigine.com>
 <87pmal7bsh.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmal7bsh.fsf@kernel.org>
X-ClientProxiedBy: AM0PR02CA0224.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: e0aa7c80-751e-40ad-1f64-08db09256d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3q/v6Qmky08kX00bh0q+d/OZdKnLCJqsKK9VFpOhG5IvlG6E1nxn4uJ3y0Xib+AbHKyIvdxBlopBGH/MiSpY1ZAWp7ApFl/1UtxAZGm264vzEld7W3wubW8ix2bnwl0I0SxI3j4Z52lWZObwTKCUD9RR2rr4lVaQMCurou29PfzrMIqkDGqSKVnt6t5PSxQ1amYngcclLC8VBNzwpNtPk+v0hPtjy1dHgbKkJAN6Mfw8oRmWg8Q9BNWxwqo/OO+iRos6uyvqhq3XNl3nOJW5frC1N3vMRgGLZcXRyZ18GxcII4rA8I7CLKIFtiKWASv8IqrE5QxOJjRda5VAe9dPm0PcMY95kMTxvmr6rM/DtNMqSfxXWy5XeugDDg6nJeJoQCDU1DYP1BxckluPT6TZHKi7tWttx/JRIkDnIAyWDNDG/WAOAJFalIaFHb4o6h7k3Oksfb+ZYhLT4nWiS1tb4kOD1nLvUmL6hgHiXQ3Bs3eFlmEp8StI7+K6AvQ5RzCQNJyc/BkR5INJGap3Sh585gXQnIraa6tKH6ufMxxHSvhjWmb5Cd+0L+qyRb2q+KV1SN2QsMlVLA3DMQ5x3Ya+BYz0NoDY8m6JbrQMeuiCj1KkaCcXq+O9ESZ8i8FoIXAU8HaR6RqkmNTHiP91h0H0iMiqumPIVDu5lycKx9W3xT8/I9xzL8ZWx5p9v/KEA9M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(4744005)(44832011)(86362001)(2906002)(38100700002)(2616005)(6486002)(186003)(6512007)(7416002)(6506007)(36756003)(66946007)(316002)(66476007)(478600001)(6916009)(41300700001)(8936002)(8676002)(4326008)(6666004)(5660300002)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0XQnKA6AcuVAi//0UWotbOAhBN1lD7aXnUxgQ3fgACAFcveQ2emDJpnAePMg?=
 =?us-ascii?Q?QufwwNujZozXyMYY95UDvf7t/Sm+/u3kv5kzcyIC+Ax0drp5hO8cVi8d1pHE?=
 =?us-ascii?Q?nU0j+iO/m7QLdFAYtntQ5DA2gW7eK1xKSl2H0OLPeQWmyaRlJYhBavFjYwyh?=
 =?us-ascii?Q?inx4np5f06XWS3LlS6pwInalXzySc73MoELiyZ1b1GQjmEMAIam4ZWbp/jp1?=
 =?us-ascii?Q?OWxqDM1DhS6eHQG9WrvMjFZCTdiSEfzjBp23iCOrXN4A7wjz6st7HAwXXQhP?=
 =?us-ascii?Q?7sjKLPdRuOZVutxAMenxyBRhJDlYcju73uDPMYdMljJgFH8J+pvdkJGbpqNd?=
 =?us-ascii?Q?UcuujZwZJdW4i/9UXVjK5f59VUaioqzhtMVfUxi4s3DkkOtXGRaGDyyBBMU8?=
 =?us-ascii?Q?AR63qUZ5mmMEgvp+JrffU2bJ3gtna3+33qZAYs4HM2YcUZsXJh5HNfj0rmt7?=
 =?us-ascii?Q?Tguq94j08UsFgDonNtksGMhKpiuop9wHccE0T29YJg3XGZ3FUTs0MM/Uh2xn?=
 =?us-ascii?Q?LPqzpLK/qN0V7JSHwoOw1Mrpjy9RYQ6Twcv4SxdXVb3iVgzwN1thUPto9cWc?=
 =?us-ascii?Q?RMhTYT7SnyK+ZvFNrB8UhBFNHE9R/d5k5+hyhMBYv6p6OXPo37KCpOTu71j9?=
 =?us-ascii?Q?ie94OnROmIVXly26Bzrf/sAapc1nuvvHsqARzy5jV1t/4nvxsws1J5xW7fIC?=
 =?us-ascii?Q?JMjMEZIusxjC5jmCbOdI6Wu5Rn4b4YQ/COjD7P2Kj8GwdtTYz692uMnFM0it?=
 =?us-ascii?Q?2L9Hi/hr2eM03QGUrYoemRnjzPLw338Tv208irO4SUhzNxQnWPNj02nn1X5y?=
 =?us-ascii?Q?PC6QZGTkkAYslx/6CKVRpEaBjpHtI0weXXj9d+HF/EmHpMG9IwV0clSXLgP4?=
 =?us-ascii?Q?E9ezbqLzlw/7FjpYJotc7dUltGb5ZGW9hS1HeCIjkQpNsWiG1/ihVGrYMd05?=
 =?us-ascii?Q?H6xXwxaZuUpD3dioXhdyl61BCwcyPbG72GVVbNPnJadcJ1LfMXhII5x/Uf3d?=
 =?us-ascii?Q?P7EYQJFQZO/NLuIf185aL+BN0yLoCI3YuDClEtZ+aAgtzWA5caliCd+89AMA?=
 =?us-ascii?Q?w4/0oaJLUhos0FnruDX0zVE1i5w6/LSmkiLM6MYXdilt5QwFZTcH/ldx0Fkt?=
 =?us-ascii?Q?0GYJ7vCbpPLGl2si+re4kr642tEJBs6uhUyZXEj/8Hb0UxftApsFFi7gKVB7?=
 =?us-ascii?Q?rpQwkxIbsmMDtYml6cFGb7vPo42BOBCwF1MEDQicz8NR5BUWKgmutj2QTQpi?=
 =?us-ascii?Q?QhkXc52567I+00cN/mBBXqCZuGZ7N2i3K+VuSA5heN4HURiX6CzkJEBwhNT+?=
 =?us-ascii?Q?8F6whwkg5f/6ybr2Q2JoLFPc+n32Zvt5kIYLARCoHflXbX9tVVcsnHleGbe1?=
 =?us-ascii?Q?ciG6+o9Y9mMieMuE5UaaMZVZRB8GWm7KJh2pCNUkrv4ernRzJZPyuVfaQvi0?=
 =?us-ascii?Q?bpl3jEeKmvbW84FWi7yPtQG+2SvVVrIKH6szj5Ysdy6kuH7/qwRejs6Ww2gI?=
 =?us-ascii?Q?kvyuAA4ulR0jOIpw5BLUfLpn43n1ay5e0NoJmZcVxO8RSetN1DSZdjoJFe9H?=
 =?us-ascii?Q?7OXIh/qtsz3tna3oJE0rFpTr3U0yeuLlMCZNU6tWVISl2N3DyAaYMDWbQq/1?=
 =?us-ascii?Q?jksxs5OCOSWoEbY/Br3so+koTpQMRF/4Z3KiMbhf+nXJ6gBZHLfRKpwQNdLd?=
 =?us-ascii?Q?id6adw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0aa7c80-751e-40ad-1f64-08db09256d1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 16:07:35.4413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xA73qOC7niuC+fPnQjU/wkGQtGktBVyU17wPlr59eOhNVZfbIEDZgfZHaz20O7GXDPjeLYerLJ/sVp2PnitPFBvq0ablQ0nKNhDWJgjHQvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:09:02PM +0200, Kalle Valo wrote:
> Simon Horman <simon.horman@corigine.com> writes:
> 
> > Hi Bo Liu,
> >
> > On Wed, Feb 01, 2023 at 03:17:18AM -0500, Bo Liu wrote:
> >> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> >> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> >> value to be returned to user space.
> >
> > Thanks for your patch. As it is not a bug fix it should be targeted at
> > 'net-next' (as opposed to 'net'). This should be specified in the patch
> > subject something like this:
> >
> > [PATCH net-next v2] rfkill: Use sysfs_emit() to instead of sprintf()
> 
> rfkill patches should go to wireless-next, right?

Yes, my bad.
