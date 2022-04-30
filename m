Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FF515F8E
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243774AbiD3RbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383244AbiD3RbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:31:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2114.outbound.protection.outlook.com [40.107.93.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41592ED5B;
        Sat, 30 Apr 2022 10:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyDmmM87L3Ee6dUpw58Od0TkMU8tOUoP34Uo8Oe4nWRpIAp73U4vFTamVYaQ3DEWrYAIyMrBvqTKbg87hXs0hlUNTlNWLYluArLbQ4IId03QtSfqWwInsSQH/K/HrfeWvbHvZ7MO9La5jNhOyxgCIICA+RQsw4e8FkECT53RjU1esIdT7jT3n+SAF4158pp1IijiUB/Y+QQoycg46eTWn+K+yXucMpulqz2sS3HXsCZwh6N81Ac2VAj19Z6PyU7Eyhqbh6GB4RBmGMmYR/Aw3JY8LDQvxlx3nsNhPYt6aa6OGgDDfiBqEP00pxLwLi3kutxwGMBS865jsb6Av/wyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqjnqW0yxWwcGCwWBltyCuEOaT3su1prkf86YQI6EIY=;
 b=ZoBQIwWiu2mTA7ZlDishPWnfCTKEuei/mUrM5+qTz4xG7Nr24pdlRgDj3hJ+m+bIoCJWGXqXUADVlFB8Dl/07cWEKRuBVowYbV6pX9PzE16yxNo9BGjOa/OmS1+gZDurFkPG5z+q/1YEWzMYApPgPUxjJ8Daw4TYdZdJpKK54jc13FtEwpNeLt6pvm78PMu6fGZASs1fIbrh2JpDTr/oLk6knaFLGovPxsFB1aIclTrVK5dFFw0+ITO5WAxkQTy6GCdD29Weeq7N9CDcVhXg0WFnB4qwOU/xvMGuV9SSWXLJyiVidzsUbSsW4B+9wjt/mcQcOodaQbyvkJtq+9dV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqjnqW0yxWwcGCwWBltyCuEOaT3su1prkf86YQI6EIY=;
 b=Fs/ISJiuDwGH94EyIQGPuiEeJ7KerBgELrLvlLh6hvkWdclfITIaCFyxL5nQ8ar6Ylu/L5roplD5bKkqEQ25NyQ7zcJ+ZEoTek/1Of3U192lDOqwQtYloHXudXZLdwlEFoqpUn1K2AqKqOl6tO33BSvlEa4qtKIJZLVMF4L/v3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5199.namprd10.prod.outlook.com
 (2603:10b6:5:3aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 17:27:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 17:27:50 +0000
Date:   Sat, 30 Apr 2022 10:27:47 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Message-ID: <20220430172747.GB3846867@euler>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-3-colin.foster@in-advantage.com>
 <20220429190622.6f5279b8@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429190622.6f5279b8@kernel.org>
X-ClientProxiedBy: MW2PR16CA0014.namprd16.prod.outlook.com (2603:10b6:907::27)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4b69c1c-514a-4d8e-8e6a-08da2acec046
X-MS-TrafficTypeDiagnostic: DS7PR10MB5199:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5199470FC9771EDEE29B5E93A4FF9@DS7PR10MB5199.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEQNRpsDcu6uiY8ChjLoglLJCRKLURzhROWk9H1u7qf3b4IMfD+jwzpHqq0JfAFPP1+xJ9BCobfGqsXUiqds5qoh2wuARueOxlEdubtGSNe2DTUEzwnG2vw95Ml1qL99P8JKNqe6K2br4GJ5BijUFdvIXNmZNBLjiR8aXqeozlT/Hq6pp2Cd+REvWMUNOH6ACfisSS97DIRKsu9S9rHrj2ttTr/0OZyxjFcuWmSejydUmfd72txDDbF45gPZMzC/xVLjHaQf0+ptahIgL4ld1/18FWqYHZcdiKzrOVABeVr3cRt3b5xuPORKpjS35X8hZlUE26qRgEBBTtwJ5z6fnf4EmjuHNQGIpPDNvX8dqfkaJLtNNTXcJqDcI1RekI479wZXadhNk/mSXfm9StZ3UNLRrrGvlISxpHvRRVkBHhdXAx4YMCGBoMCNhrcMbv9KlyHdBhN4tO35sJHxfBj0po6SfTx0wXEI0tWzSaB1RcvEhfiTxF8sEHmpYb3iPmcuXZtYVIOCwZjp9f2z1wOXIJ/9DuOFTSf1Nirw9JtQGV51xYto5vtTYzq4IwwtZPKLcg2W9+69po/wt9glexE71/UsN3rnXY4SjYDbi7kbbZEyUSIOJY/vFgT1hvEgRS8x6yMRb1pWDVjdDPGv+/dofqQqncJM6sNW662Qziro8aBSVEUnQCwkjLeWTEV81R5EpBTJcn+cWfMHye6r6skDwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(136003)(396003)(346002)(39830400003)(376002)(6512007)(26005)(33716001)(8936002)(508600001)(9686003)(6486002)(83380400001)(6916009)(316002)(54906003)(4326008)(8676002)(33656002)(66946007)(186003)(1076003)(66556008)(66476007)(5660300002)(86362001)(38350700002)(38100700002)(6506007)(52116002)(4744005)(6666004)(7416002)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H6znFS2+yHC1wgZwdGLo/60C5wnCrnqUso7KRgGrRhK/In3TYtAsQPT262hW?=
 =?us-ascii?Q?t0hmScFS8UpPszsO5OWcHXI3G3Wc0YsvhN+lsddJ2FYw6yDtSH2f4uKnmkKG?=
 =?us-ascii?Q?IiXLG6qwLpYP0r18zWCacoWC17oKD5L4EXIsHrZ5ZPmc8lAuBt+M4JCotxH0?=
 =?us-ascii?Q?6j5uzw9w1a628+jZ4AYBZcYSGm9ZrR3K8QZOvVwgg+SYZzJ54kjHjBqWs5up?=
 =?us-ascii?Q?RJijTP3dIayCB82LjRdEZ0kBE7vZif6N48CTwRmRuaD9HCRXomie+N2Xzt9D?=
 =?us-ascii?Q?DQyJh8pS4nau+UpdCCz8Bmu3AfgHrV9VpDbVT2n0lRNeQiqL4gztVmomPUSV?=
 =?us-ascii?Q?djbvsceyMwPlfXBrMtS71u4Mkm5Kd2I2OPAzHcbx4nB/FcufQaaW893jITMz?=
 =?us-ascii?Q?Er/YiK1Lngsl6u9MUqcDg3/a21ih1PcH0O/5Ujocnh++Ziplxq61/qSjmeIF?=
 =?us-ascii?Q?7QWLiVc+b+Lg5iFugJl5lQ3iDhjeVh521FS+HjhRfEdgQnY/ltUUHie2JTsI?=
 =?us-ascii?Q?UhyZUw5zCGt4SJ1xWC6m5j6uHdHnm60w1iaTIbgg9HcpcpFJCS01jdayqnmg?=
 =?us-ascii?Q?FUnDvtpad4CIKOk/CZh8jFo9+B+pqpilTl+J+hdsnsrTIPHwc7xAfgrayFfh?=
 =?us-ascii?Q?wZQvMPggkftrGoc/rTIhWw9GzkPXrk942oB9IOIhLGtzSXg377UlQc9ehLoL?=
 =?us-ascii?Q?0+S57UosZjFI08l1k/vY9yFMouvboRGguay+ZZx3PX70W1jhqID1V3cdfYkc?=
 =?us-ascii?Q?gq0K4DmVOr8peXAhd66R4mcRdaqqeYivVQjwfRpilxnc9+Mg3r6r6xJuMNi4?=
 =?us-ascii?Q?fbZBEHQScKh09oV1OmfgE7zV3SeB2p3N0xhVlucMlD/vw3vVfvbZ+TFrjh++?=
 =?us-ascii?Q?07ZqigvBLJZ+8oypzSoPKnwozyj4nbspchA5ezvpF2YYQHHCNc9V7JtDCbmN?=
 =?us-ascii?Q?/JuZe6q81c3s3eISgfIuIp9/7ayh2sRvg+aZgVFVguMIMA+kqaATMthUQ1Yv?=
 =?us-ascii?Q?9/pgHtyjsyu0i6UB0FXr79pQyk7P2RGNqk/MJQ5/Tb2rz5tSHDEqiXjLf7n5?=
 =?us-ascii?Q?gaweoZeeJ4axiai6lBQSkg2D9XkVpFiWgppryyC6dl1gHxCVOBsb4Lta5kru?=
 =?us-ascii?Q?T6VMnCFNGXt1PtAQr0FYzGBXq3/ykH3hNI7jxIfyj9ap11XomY3sRO7Vn7ax?=
 =?us-ascii?Q?oAXQg32IMjNAJnG/aVP7GpN/4OT3mjw/A6GzHTwrTP4/dCmdAiJqRgxjIKG8?=
 =?us-ascii?Q?D8YscJV6Hw+ilwKhivUFTUkM9dAHQMLwQ5GcrRPhGx7N+g3w9dwuzDmDXI22?=
 =?us-ascii?Q?Ckuj7ZgOHG4sB78qbqtNe8gcFtVb6MG0i5VK6mP8ivGBEGUD8fxWSvs3bpf1?=
 =?us-ascii?Q?G+r3SI0flz04BJvUJcZQz3qrbvfni9Dtk/IK5lo1B892+s7rPgiIU8Am/mA6?=
 =?us-ascii?Q?a6TmNNNv+BN9g8bX/+3FlquOeumFzbF6ygnWpLsNg7KMSlvwLUER3/FpNuTE?=
 =?us-ascii?Q?Hwn0ThdFsiZThFtd7+rlXF9wlruOflvt4HOWzIlwawCPQv2+eboIn3M5dQP3?=
 =?us-ascii?Q?mlAw+YyuLxgsFi6A6Sf4TFhDcrgmNn9VqZS6DoC9+KCgE8Elp8RgRFtblnCo?=
 =?us-ascii?Q?NedE8PKe7apVka61LrNpbWgqprcerwgfvoekbsQ2eS1H/cshcOtbbJVh+cY1?=
 =?us-ascii?Q?iXHnkrTOth4tLwMmehizSNoM2rC91/2KOuzhyEWia5rjmvxQobWCaUI4CmnL?=
 =?us-ascii?Q?BmUyIQJ1m3HPy64iXHeYM9zPlRlhKUSXHWmOPNef/EZtXplLsh6y?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b69c1c-514a-4d8e-8e6a-08da2acec046
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 17:27:50.6012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzAXE4zbvEa3pVBXfqnXP126n+UG/BfDmqgolp0uh9zs7is7Mp3MitoeFYd8mUJt4KEVUMOgIaIKGB1eiGEjMr/eRXDIpci+AxAbtpLcmb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5199
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Apr 29, 2022 at 07:06:22PM -0700, Jakub Kicinski wrote:
> On Fri, 29 Apr 2022 16:30:49 -0700 Colin Foster wrote:
> > Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> > constants")
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> Please don't line-wrap tags and please don't add empty lines between
> them. Let's give Vladimir a day or two to comment on the merits and
> please repost with the tags fixed, thanks!

Yep. I saw that on patchwork. Oops. I'll fix it up in whatever future
patch comes.

Thanks!
