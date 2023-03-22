Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A196C5116
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCVQrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCVQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:47:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2118.outbound.protection.outlook.com [40.107.237.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B44918B30;
        Wed, 22 Mar 2023 09:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVYv276m75TQWd2T/n59feKXMeUKADQcRZNJMVZdqIUN92P8cd8HjAgAxM1ptBcedF2M8ElupkLx/ykKPzZtwO5xNaVDDKi44TIWpRBU8/gMNQ7TdAW7CDEMFPgTD7IdIxb8KIHwU/Oj8CGKHXd6cdw5lOG10HPEqVnfZbB9wyikFjaVkhG2QKyzsySwvCkJEPZaZqUjt4yDjEGbBRWzjl/KKy79WHqIW611wEQf5pTKXGYmI29z8ceqRdedbZyJOkWNWM5nwAKRmkuNUpLsWqeycozHhnI4ys2e3pyHw8FtpGmA6Ej3uYwo0zWq+UrAij1WCWhS89sPgGjldA7NLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WYRYgKF/0/QzSy/nQ1gs9vG6ZAeAxVnN1SRoTM+BGo=;
 b=FFAn5iiIUdWLCZpRe48g2z8E5aeVu2w7iBJ6JasbHuN2PbOiBkqjbwGCuS3ryA4bXppNpoi/9/Vk7/bMS91cWvqeSYS9+GTJ83ofFnAndNX3YCUh19RUguS+DiunQ6ooYO1mpa9GQhMvpajYpipa42aGcD0XofWbqUCOqzQChwyIOWsFe9tZgJJjSDAcTDxp1IaPcQoMksoiSYvOsqRsGptd2NEoTMzzEz+KeFk8a5aSKVnC39tGnITXiH3X27hdud9C8c0ThL0xiNEAYZYrgJqhgSPqCQ6JjXgKJEQyLlIh7moykEtnLAC8v1chdzuXWJTNU3qqBoLESdx82XQLjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WYRYgKF/0/QzSy/nQ1gs9vG6ZAeAxVnN1SRoTM+BGo=;
 b=r+YIu3FSUZC24xuc/eAmZvHgoUq4DYxpGEtCv8Li6+8WscCifW2hYM88b9Doe7fEult/c/B0ROxzTw5mdQrQZN1UeIoWmDT6qoYAYvbhHCqiONgr06I2fAQSTAMthMRFWFvB2e6VWr5hQdXvtlg2/kiCRjvTVHI7ijkeJd9+5C4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4683.namprd13.prod.outlook.com (2603:10b6:610:c3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:47:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:47:01 +0000
Date:   Wed, 22 Mar 2023 17:46:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: fix aggregate RMON counters not showing
 the ranges
Message-ID: <ZBsw/SRtCgfadtlC@corigine.com>
References: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4683:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba62350-ace7-46d9-a3a8-08db2af50f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJf+aWJoKycvM8WmL6xCutX8j2th3cSl8mJPXtEUuq5zBTzBgHLvF36mEhHLqRkLvOh31TndbMqMCiA3keu5nu1QqImbqyYuLz0BxDrGfwJVU7jz2oXX9wzEMImsUgsT0RrnmEnyGYOXyaf36oCgw0FCVg1Sj7ikKzsLjV0JPlH/MQQtjAjRfPrcfHag6h5wMf4yuG6K/ANxG+mqmMDzW3gNwhgv3i03tPSMq2eZvEvS6Fq13wBS1aZEqyhdnBZrOWiPBS2oGEFziu0p422S6MqCah2D5oZYnY1AE1rFxbzCR/tltFViojwTRZjrR3auGh7HhAuJoKY4clkzO0IZs7MlQ6DEoI0IYuVke6pg1qwGNPjElBRfN4WZVFnqaAyyXzNGZh+l8IYJpqGeNYigDrJqEqHUpbjDpzvuEtcjE8123BR4Bg7G5Ca3SGCKImpnYaCzbQ849naINaNlj8kVS28rhg8s5PVRxcxT8VCWI4Ili3pxMbsMSxw/SDmRJgP/lHP0lpcib1ngekn6gdyWEOUsJzBVzWPCayGukyIcIbo86f/3FbNZL3XkUoC9c0nPQfBsORrIdJrG76GxIyIN0oYI8URDiZbShYlhY31Sv0dUyQOPuYc/zRT0P2RyQutCoyEobZ2/J8BHobzidQNYAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(396003)(376002)(366004)(451199018)(86362001)(54906003)(6486002)(316002)(2616005)(6506007)(36756003)(478600001)(38100700002)(186003)(6666004)(6512007)(8936002)(2906002)(4744005)(44832011)(41300700001)(5660300002)(8676002)(66946007)(66556008)(66476007)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?01kIbfzSpfkLpcRlzZQzPwgFB9s6T0QgoUaDQyepbxHjwJV7Cco/OuJX8Vnf?=
 =?us-ascii?Q?6PVESL9XHjfkvsIltd/owNMeQVibyVomoC5hQcsPF4oG+5qZdLjsqShxrsAF?=
 =?us-ascii?Q?7f4NomAqVRNajU0XM/PDYSsmNH+0FeiXrumwXzRU9GVfPH/jt0/IaKE5dAcv?=
 =?us-ascii?Q?uQD058NFhGPXr01JbETBXVg2nFAyPPlOwfF4i/+F+gLtKOZx7ucT8wFjq/wO?=
 =?us-ascii?Q?9ihp+2Fb/2F1WuORlvm5g7PBAT/nLtejIVBW9IH0ZTF/42ZbutKSJ1JQlGnF?=
 =?us-ascii?Q?umfNwXYHF1P35oZKb1HN25tX5TE+eXSbP2KWHoyunhp+rrpbaUZDMX4EyMfe?=
 =?us-ascii?Q?99i/2zsTKZCGJPmMemUCQpFBZcH16DD8hEMfcyUF44BwXzEp4iJ8pSgEeS5x?=
 =?us-ascii?Q?8J/7GPeRQNvHcE2gvcBgN715D/fwK/XPEzsCxOZ2LyhjyTPLG/0ikPo6oKc/?=
 =?us-ascii?Q?uZ9TtZcUOm6HuwPkIUWEaHrixc4FZqFNSYz2D44nx8GE6yYgK0oKE8BEjWmz?=
 =?us-ascii?Q?h+Adg8YUtjZOr/ED9JvQfnMJLch0IsU9j9QX227CykJvYpCXtJGBkUqtyoS3?=
 =?us-ascii?Q?qr/iyOeswn/rz7vL00lX2FPLRgVHJ9DseVAYbFSB1yKhanAiQFAvN7YAXlGu?=
 =?us-ascii?Q?MeCzo+ycA71Kxe9hmgd6hvr8UsEN/6RmAUj7zr1AnTgD7gaA0GVAA51F0Jc2?=
 =?us-ascii?Q?DKuzv1UKiFaLQOUrSYjJxQvxwa9T3yLH82QvhOaltMbO4mWcvisyw1ZYYzcl?=
 =?us-ascii?Q?0ePwvvoGNBaEuJO/9bqNB6RqZqOdT2CQeTjSndFTZimLYT4ZuQ4mWcdSuCiX?=
 =?us-ascii?Q?Wpe5lmgLuMGPqw0+DcSUye6UG6IUzPfNQyIVU5KPo8iwBTM2MNFr6yoYKnhG?=
 =?us-ascii?Q?BnDBP5INqUdL4usxeYqBF36KKRHo7xnqANZYIBrqANBaqC/rrktfJn3AHMCJ?=
 =?us-ascii?Q?+9xzdhuEVLblBm58BqUot3mqibr9HPgZ6Bmlo6oZ3vZL1s8D8Siu/ItrfyJF?=
 =?us-ascii?Q?GpYtGqkxs2Cb90uWqpoZxz5YUd+10zfCN5NuPUD/o7la9ewLjDkgLXgqPdit?=
 =?us-ascii?Q?bfPjuCRjIqjcDLCldAe/CgZnNA/dg2QzMvtu75gdHhZ9pg7NX0fMWWOSQ4Yr?=
 =?us-ascii?Q?Mlap5B4oyzOspKmWu3RJpE9iDePwxwn9IrDOsMjtg5bbDN3Xl2SbgQ8txA3c?=
 =?us-ascii?Q?Gy6WfXxxHuwprs14Vxdj72hhbzTpfLG4MtIZ8oTk0DNuUwwnQRBhYI5eEarK?=
 =?us-ascii?Q?xrhFFeRp1y1fyLt2ICa4HQsMhKRjHL7SomwoP2c6SnlRGgdKVd/W4RI1ttwF?=
 =?us-ascii?Q?tBAlqqdpRNYWiOOeQUWBz54ctYuxC41abiUKx2I1q+4uoXrJKmNWeKLzlDPa?=
 =?us-ascii?Q?GeXb59tTzooKKmKItZI3h5G1OqNmqaM2j/YrF/YWT628hUmjDVsGlKowzoHH?=
 =?us-ascii?Q?S+rDeBpOIh/vuiA2NQXgwAntzHeywo3AyxmwBBlCRxSZYrl+Iju0v95tErfU?=
 =?us-ascii?Q?lLxFJxmrAqsJxLs0rMmL1sIX57DPom/6h2cHfBLaNsejP0wUYgrLklBAzH/T?=
 =?us-ascii?Q?Er/zFvbFun7GWbJqBJHtJjsLd1BwdkmaQSqct0DuXsLufxnClbaCfL3D3t8+?=
 =?us-ascii?Q?rQlDWHu/l/mghTQdmC5lKZhMj6tdetUZSAu6BpobJH3s+tn3/htEDddQ0nZm?=
 =?us-ascii?Q?XpZAeg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba62350-ace7-46d9-a3a8-08db2af50f04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:47:01.2404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyd9jm4X1wrWa120ekmkOylI0SJUWk9NYsaCtTXJeEoeLlkR8Y9MBrMCUdVYSH5aW/jgWsU1iSyuPf0Nv0qLV/W9Ci8FQlHqMzJ03yBt+00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4683
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 01:28:31AM +0200, Vladimir Oltean wrote:
> When running "ethtool -S eno0 --groups rmon" without an explicit "--src
> emac|pmac" argument, the kernel will not report
> rx-rmon-etherStatsPkts64to64Octets, rx-rmon-etherStatsPkts65to127Octets,
> etc. This is because on ETHTOOL_MAC_STATS_SRC_AGGREGATE, we do not
> populate the "ranges" argument.
> 
> ocelot_port_get_rmon_stats() does things differently and things work
> there. I had forgotten to make sure that the code is structured the same
> way in both drivers, so do that now.
> 
> Fixes: cf52bd238b75 ("net: enetc: add support for MAC Merge statistics counters")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This feels a bit more like an enhancement than a fix to me,
but I don't feel strongly about it.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
