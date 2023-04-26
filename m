Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B676EF12E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbjDZJ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbjDZJ3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:29:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2100.outbound.protection.outlook.com [40.107.237.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD0835BB;
        Wed, 26 Apr 2023 02:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJGwCynTGNfmb/87JGWoBO6niOvmrahYPJd36ytre3Fywyo78pj6csyRZp0pReWCcudcdSJOrR9GBdkkbRGywafZ6MWuZV5DKc/322mNh4SV46LOqwskZs1PHkPznLNu3j67M0oF41qo8bavIRj47bWWkMpZyAK//XrtJtu5tSvcAVHOHOAMf6VqMlUakmwAKX03UlZah1Gs/qaMwgdwpZg7WyBUcAmyY3rIk7hWgLYNwX/emElY+IUYqS4+I2chDZ0eUWdNCzyLygOgdlE2vYpAmfsRjSCNkf6DJSpx23mHhR33kcNkkuVT4FDnUsMFgza1RsLe5IfO6DHkcgcyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5cnDIurI5d0zgWiAunpe6t8qwIAMc/W1o1lHbSqxgk=;
 b=ZMe2JWphSKcrOmimK8GCPdQFtev9OLjKlXokelD4g4J1EwkuKYoW1zinBJfemEDSIvDjRaPI83i3soJ+12gryBmBIQWbn8eXlv+D6PLMImvgpeDiurvGyh+KXKSyPgSvqMH0B0F92X7AXneahb4SkZIKKjV/w942hhTYY2vpfzGFxYuaqhL511HP5iqAljNLxduPciPhadlW1pxqSNEAfRM9RaBQzLUAqbrKD+HLm+p2NDqT+A1WXPNwwmO3+vFFOlFLZQGF3VeRTpra1u9XiOqsvwFLvP4C+LXCL0pbdl2d6wTeT0U/0pczhRSQM/ys3fXaaWaN597C2DzGmWVCvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5cnDIurI5d0zgWiAunpe6t8qwIAMc/W1o1lHbSqxgk=;
 b=wNcrtSV1RidpBQhR3MEU/0wGkuf1XMKcddFLdwifK1zRlduECxABQJdhnlTYvxZT7U+UAchSj/tPk2esmgwxGSEyPK8aULVKuq+rWx5j8GivoA81jffxqhaWdkGhfCYM0Y3xpiXlkE2IPyShF+HNgSJLkdkjWUMyDPPfYPBGBnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5383.namprd13.prod.outlook.com (2603:10b6:a03:3d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 26 Apr
 2023 09:29:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 09:29:10 +0000
Date:   Wed, 26 Apr 2023 11:29:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: flower: Fix wrong handle assignment
 during filter change
Message-ID: <ZEju3l897gB3IvJR@corigine.com>
References: <20230425140604.169881-1-ivecera@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425140604.169881-1-ivecera@redhat.com>
X-ClientProxiedBy: AM0PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: bf071263-9777-46f6-6871-08db4638b08b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYPSQ3XRnJRcm5i9rSt2dEWFPIf668xiuwsek2gKa7RHO7O+I9cOEFAQOUHl5xHHZHEdvcK5ZX/xNjKuiJP2NSjNQL8k2MsATMH8epTJ15wVLw2vWz6K9SRy8hDqxTBUSx0tna3+MlpRwQhiWB7tfmPEhykq6FsxfA7TAH8zwtdnOLoGVW57Ir1fiXv/RHHP/JEAiwsd/Zie9oft1k8vYLhV1me/peEmEl56XSrROXfIzmW/2bCraZXzz8UTHXfhjpFpTbiyEKlZ3/DGqrd6qvWettpB8H5UgsHHsGQobtjMJ8QS5k4Im4WfU16rji5GdXpPGa2LDguo+wd+Br2yWSU4RJqgQXa7sMhZ+iis306C1EiSK2jzIxiAq83gLwOEgf/VGrgaLNohJ7jyGhLCzOcDVKMC37tNOn3t/fQszeoilyXWdXhoWn0vht5st+d/0jIutLaIJP3fbaOLUBX4jNUY0pzVdQ+rg0cyYMrEwT5Bq1DIcKt3Pm3ebNa44Sj3wBK34u+TFh6hMH0eEjOQ1mUHp1IG+gEXI8QGiAw4oXOWVD3IhPKdr2/s7cRo9o4o+RdArk3l+YCNlpVMDyPNrts8Egcz8BHYK/gkVoahJMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(376002)(346002)(396003)(451199021)(44832011)(6506007)(6512007)(186003)(316002)(66476007)(66556008)(36756003)(66946007)(6666004)(4326008)(6916009)(478600001)(41300700001)(8676002)(8936002)(54906003)(5660300002)(7416002)(6486002)(38100700002)(2906002)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+G7K+CifSXd5oNcZUJAq8Yg3Jv25gMarjhinN8G9XbdYtWZ8/UnQyn9MCOnJ?=
 =?us-ascii?Q?+Ev47fjuvzP2Y/zryjcgKjcno6nobhfuCE4N6rLWTgjlS5Y+LLOyo2Lsi9eP?=
 =?us-ascii?Q?BKh3oYinPbc2Oi/ikdlGlT86UBt6uhueQq8nWwn4zfFUQD4/vjhsDJQhwUd+?=
 =?us-ascii?Q?cSe4zgkDDEz7SWm3f98XhyDoh5cxAD6LuZpdThx5g8eFi0VuYsIHMrGfhLDc?=
 =?us-ascii?Q?CiHbZ/QBn7mu5p/WRX3YaXBAxgBk6eOaucuBZIx+5DsTuOm/4sghIKWf5NAF?=
 =?us-ascii?Q?A8mKpUm/4mOYu4uA4qGZkJ/NfQzYpbwtoVCbcS0Lqd2a43H00cXdxlcc+XgP?=
 =?us-ascii?Q?GAc0d/Hhb+6AI7M00wUN8DtPokeO6oFkRhBmVyNWApo4V13+q8FgZXwWd7tS?=
 =?us-ascii?Q?FIj4IuYohCRfcTxCSOHx4ONNh5PBV3kEX1lQqPCVMTqKkvNPRn56szwPvKVP?=
 =?us-ascii?Q?AyduK94F1BBDrBBjJN2ru0Kc0Y6+397sgIdsSQwVz2rjK540TzRjemOi36F8?=
 =?us-ascii?Q?zEQGxA5VBzTwAZTAKMZRy1zRWeABUTSTjTPsR0MxAUaitGGc3BixzSNq7hP9?=
 =?us-ascii?Q?/oN/sUCwRsUFNJLyOBd60+aIhnRFWPFn0lGLCSIOHPZLNwMGX61jUddSUiPu?=
 =?us-ascii?Q?dOedbVIr2ZHRmtvWI0zXveAbfVbeT+Uw2yQaNDdilc0tAQ7VhiVvjPzyEj5w?=
 =?us-ascii?Q?2rlBH9YFWrJr5Rl4kbbicyKpcLg0FRjfUskKACLK8PwIuoNzSWDALSgpViJ9?=
 =?us-ascii?Q?JmED5CtBUNqpP3R8joK4f0rqwp7e1CFGUZOKrPTp0voDy2Zxpkux33qtk4t+?=
 =?us-ascii?Q?gpInJtbO302UCuI6hVwYfEgk0FuD3pF2+76XdrfSWOC/he1rdVO+bFLMvUym?=
 =?us-ascii?Q?gcQBqrymnAw5Is6m365h4Px5b1B17r6uvUOr3BzRamoyqMK2GZK1nI69uWyO?=
 =?us-ascii?Q?Q3/pm0Hjun/EOe1AgKk5ljcJVUxJ59tlDVHWXca8CFIUCJFR6s3od6dU2rcP?=
 =?us-ascii?Q?nIugIYjW1tN2v/Gf4ZUfWy6y4++Lx9g1dbJvZS8ivHlBL+tqHOPMFxHGp5OI?=
 =?us-ascii?Q?xOVnsfbLQarzD64pGcuZW5Sy6yCfuYQvZRdFHNrPWrEls3zOPabIdkGU/V2P?=
 =?us-ascii?Q?jTOwvkHUwYc9wNpNRLaN5BuKRqYo5lVPnsvEZq69tp7d8cNuTW7qE6MNUKr/?=
 =?us-ascii?Q?VLzuYnpWERO3A9DlueXtvlZOpu21rgu3liREo+Srhr+TGGqX67MUwIZKn+E4?=
 =?us-ascii?Q?pMZWX0aGw/hmwXKpbKZ6ktJ/GmIs1Kq38ifCKfJ+yV4VAhdsJSACadsCrEZj?=
 =?us-ascii?Q?AUvaeiWWDjeno654SkErG1rNUnsppx6MpOZsqUR7RW+2fupBg68eWCPMp4x4?=
 =?us-ascii?Q?FiuIHB1tB0cuxWs+qcG3HIEdjGoAhFIeww///hkyFbXw7j7lZ7dxmQyt7Wmq?=
 =?us-ascii?Q?wIAebCcG/rI9h32UHls3F2HWFDHqvhMvY9M0ZjbzIQYFA3qe9EwS0EMCwnrZ?=
 =?us-ascii?Q?92/zZsLmceIzE4eI6+setr57EGRKNsCYczjE2FL6D72Om0FUqjwfNRAmlSYD?=
 =?us-ascii?Q?dlSoHApr19r6WygUKgsEa9SS2KtMXr6mkCMcacWt9leHzvaxqNv4/VjgzXc2?=
 =?us-ascii?Q?wvOhLqFVBoS45Qc7bvWgMSJTKpSgayL+BRGUTguDGK5sH5Wp89b66bW1ZLtN?=
 =?us-ascii?Q?9qXGRQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf071263-9777-46f6-6871-08db4638b08b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 09:29:09.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MBGwehneqE7JRkSnGAAd03btH3hBMAiExoz6IlbUgygb3E6ayZTdX+YRqL0SiUieSxCoGh6MKzZPrggtWiMcybX7PLaX8PncPD6+9+JzXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5383
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 04:06:04PM +0200, Ivan Vecera wrote:
> Commit 08a0063df3ae ("net/sched: flower: Move filter handle initialization
> earlier") moved filter handle initialization but an assignment of
> the handle to fnew->handle is done regardless of fold value. This is wrong
> because if fold != NULL (so fold->handle == handle) no new handle is
> allocated and passed handle is assigned to fnew->handle. Then if any
> subsequent action in fl_change() fails then the handle value is
> removed from IDR that is incorrect as we will have still valid old filter
> instance with handle that is not present in IDR.
> Fix this issue by moving the assignment so it is done only when passed
> fold == NULL.
> 
> Prior the patch:
> [root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
> Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances
> exit: 123
> exit: 0
> RTNETLINK answers: Invalid argument
> We have an error talking to the kernel
> Command failed tmp/replace_6:1885
> 
> 
> All test results:
> 
> 1..1
> not ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances
>         Command exited with 123, expected 0
> RTNETLINK answers: Invalid argument
> We have an error talking to the kernel
> Command failed tmp/replace_6:1885
> 
> After the patch:
> [root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
> Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances
> 
> All test results:
> 
> 1..1
> ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
