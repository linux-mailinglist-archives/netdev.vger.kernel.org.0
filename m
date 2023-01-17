Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161C666E1F1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjAQPTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbjAQPTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:19:11 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2107.outbound.protection.outlook.com [40.107.223.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5713740BFC
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:18:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQxXd60bf0U9wQpPNP4s2oaGEcdMGPko+mmL+A9CAmftjGTsFdhzj29+fKosBSqCXZuJ1lGd1nIfHwmP6HE5TtqSxOtBo2gub/BMrJms74SrLAD703sYMYL+Br22dvEeFM53td+uuKKd+ngDAkuLuBy0LjK9n2uPMVPq4budLczeWb/Ddfs78qWTPgNyd6eHexMo4pAfxXb357BLAXuRNa4X4H0XtxwRK5rMLST+xZapWYBFDoLAIQABl7QsuzRqtuBSwmTAqwoyLBPjTaV4NCKKQjGrUF79NzbCo5KFtuvDw5YlRkRFr4Sa7FAhq363Lmt8xUvBdvqYUrRc2zxwuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdlgHw7PgC2JcxXTdSg70/SKradG5rn6WszVYd9xzgc=;
 b=k45s/u4aa3zZOprVG1VHoEGA5l/dZL7OZ+pX86/Y/+nc0KPF3dY7R72qsdzZaEPnzG7+2PfZCkzV7Gykd5HkcrzYCMsZfwvHlHliNyS0/KpZeXugCeJ6SF4FGH8nxamuXyoog3+CF4yklN0NLwE3N61ttPeiQgAs3ZZxD6unqpPGA3enLebsh7hyDwMmj1ZJX3ynEjnGZJYgv9RVbhDAbgwNtmRc3Ec4Ajo4i5Hk461wtKxyK2bw1JiVnEIY9TSPhPbdvn2oMxkDpWKWd6+02pTkfJAsYMsy+bggqwn7qyQoN/cjw4Uua6JGn+4YH48bzLFkYo+Laog8/6YSrvRh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdlgHw7PgC2JcxXTdSg70/SKradG5rn6WszVYd9xzgc=;
 b=YYAfc3BHsOi9LtL9djr8q1ftgseVRSgFgTgSdBxMZgUGO5BsUyw5Vs900nQL2V6aHkzJjJpMMSCcciQxf5Nx55Y41Em5ZqgCpnOxUQM8Zn10pHdQdHsIn0VI99TY4IurI4iaHgkoAA9t/eb7X7vOF5dhzO1SoiP46zsrNXxMEDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5313.namprd13.prod.outlook.com (2603:10b6:510:f7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:18:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 15:18:52 +0000
Date:   Tue, 17 Jan 2023 16:18:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: wangxun: clean up the code
Message-ID: <Y8a8UDe1k4fyVYds@corigine.com>
References: <20230116103839.84087-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116103839.84087-1-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AM0P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 61f19db4-d170-4dcc-c06f-08daf89e23fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /iM07GZtWVzCQeDGMkCJ66FAR/JYN5OdG0gr/kLWDdZEOFAuAIzJv7/oxrxd9H6CPsM0JddtKylz+IsAnVEYfCjENcbIozRYBrHOzQd6mjtYiIaTkoGE3FOX6dIkPE3AuNrT1segXDtPIU7ZORlWwUGzN+Y5yEJkHZ2KW6Zhld+oae/0QWUOw8fxzfSeLrDaPlX94TwiPvIMl8AclzPo9Q43L3N2il5YuYWojmxRRVGRC67jH+gyFrsgQTyRuJsUOn/9Fl3wg7Ni3PVRcCkpcyqDdNXXNRShknBMmj2ZdCaO+5UUotMwtTBOsJLRH5vmTQ4nYXm897+deqrIH8HVe1sBvjoO0ot7LrovALBw4eiWy06DPcabL1T1kM1mfRbkef5WWf/4JouwW82Uv7O5ZambItc977JUNPn25kQiXUu2ptur3z0UMQR716GJ/fbGg58FGMoFr780ixD7wRH8sa+nMSrienClT4j5NoXRt84iFEnvaZZoDFn16Ong2L5WbrLydqVGPKEwWdyW5IhchbvmXlG782qHHRC2PU0E8yMe2ueoJPkYoQdNBK7umi5Gemzt6Dw8upbDWMHL8Ti7nnyUNslbR69RNeTyGBSeq0TaPwG1ptH6goGPRRziO0XGkHP1+StRYq92zigj4t+4hQMC993LLdrVJwU+Qqt+15prwXRqTm7G+qljnhjHFaNt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39830400003)(366004)(136003)(346002)(396003)(451199015)(6916009)(66946007)(66556008)(41300700001)(66476007)(186003)(6512007)(8676002)(4326008)(2616005)(86362001)(36756003)(5660300002)(8936002)(6666004)(478600001)(6506007)(316002)(38100700002)(4744005)(6486002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sXa4DDEblN4UTIIwNDc4RQ8I690SEVUsIxghb9ZiVpXiJYPMQ97PaEcDGGzx?=
 =?us-ascii?Q?C6UCuhVezUIUOCTVFDe1Pw5JCwg2t6Sj3v/oOXM/Y/veaSVpohQ/SNj+ueeh?=
 =?us-ascii?Q?kBJ/Y9aQtge/b3itEP7p49NlEW85+cY0KB2AQAT3nHu/AFfEtyLM3qPRVWzx?=
 =?us-ascii?Q?Hho9icFiDv+mcCUeR1+iphfX7TWSN15MN/6HHm07M41B4I526MhPaElflt2n?=
 =?us-ascii?Q?dziDe2pgQSnD2PSCrND8UpoIcQpMz+uGpHWF5KqqhBqIZS+zGzeNQZ2ACZZ/?=
 =?us-ascii?Q?7tNVNxzPe9Uks1WUePXLNa8lzIQqtdlmaAxinpToSaOFgAv9zKjRIHJh90YX?=
 =?us-ascii?Q?BQM10c7WfS0SbBeYOvRbqBePUO9ZAeXZYNzfkMSbWSR9LojVdD7uH+tzTXa4?=
 =?us-ascii?Q?cC+7OHZzUt+l6mIjOvSyUsDVkLftAT1Tv34z1p7I+0g4fyg3ROdnTLF3J0I/?=
 =?us-ascii?Q?VPTXa6D4UU3rIbDCpkkEAWZmZL4YY/DLqYpM5CdbIvnbEMziCmBDzHbgSvte?=
 =?us-ascii?Q?R5YANgnrzNzTYMpwLZIX1aAh9bI0+TgtL57k4gSin6oEm/JUZmoexfuHGAMV?=
 =?us-ascii?Q?0r0UPSibqbqzxRYw7MFcDsDU1ZO4O9AdhOHosEQ9zXHFVHa8jFVR/6XWvaXD?=
 =?us-ascii?Q?MKe9SWMCQxW4xsC8JaMEhspeCwDfhRf8H1F6wexanCaJgJLDTbS4Qc+qMZFa?=
 =?us-ascii?Q?NRf3iHp1AFEIIYaGxgbMGe2eDk1piAT50SdjRylFsf3GzhLYhfBVOjhyvbhF?=
 =?us-ascii?Q?XZZ62YsCrUubkeAiMsJ89v8ZwXYNnIwA/qCVXTBVigkl37caoLGEEIVO6JSl?=
 =?us-ascii?Q?U2+cnuVcXzviOfwDHhfWpecP7bbdJAEsWtFW7zjv1hUu+PaQ79vop5+z/OMQ?=
 =?us-ascii?Q?Wj2x4Rpbyc47n2g0D6TcY0xmE9xGclbF17u5mmBnw7UG4v4yEtROO4vblzB5?=
 =?us-ascii?Q?9LwRA30a4bz6jetdq4HxUNpA3/B9IswS87Dq3MDdEpR5ANzeubRoKUKWIEZs?=
 =?us-ascii?Q?Qwn1dLZqGXPPUvi93Iuw9vSLa8MUC/7W9BjNgvKuDprJxNHvzEeazcbGwXz/?=
 =?us-ascii?Q?NfZmALFFYsu8gT0yAKWYPjhEewRyZkl3sTTd49B7sHlvsZyrAg9vxb9d+6OF?=
 =?us-ascii?Q?dx5PmPVNdaojGNjWm95v5XzCA/vWWlLXvVhT/HiC106MRZWTP9BqJizy380e?=
 =?us-ascii?Q?1Rot0welkem43iRjr4xceJ7/O/VaE/X7Q54tFhTHZ61Hgsn37V7pE7jx3+4p?=
 =?us-ascii?Q?FbF6h49V4wpSXI+bxAGs0RS0yQI/K5zcdYBWadA53/bOytn6RbzCXnjYp0+Q?=
 =?us-ascii?Q?Zl7bkuEfKnvH4bjdNeCfUTCiAVYUkOjnxVKeduoExQRipsX3BNcwkJRRGr5y?=
 =?us-ascii?Q?MQSZQrsY/5XbfvLBk7n6TgG4LsvuFw4+1qc6U0Sab0Fnj9Yn24tIgWB1RFgV?=
 =?us-ascii?Q?fMgP8L6EwsPmIisjQe92Cqf/2PwINmC5i7huTvsmK2qSkAVVUbNVA9LrLE1f?=
 =?us-ascii?Q?uNstliOb3oB++pt/2yTT4/MUveLZV+oPWJAxqhwuFSBmCARQCR1avGHrPPL4?=
 =?us-ascii?Q?03MqkDWW025hUbenm1lw2pVM9NRS074W0pAb4wT7V4k9Bg6gDyyr73QxFsae?=
 =?us-ascii?Q?+R4ZNQcD3WiaRsWBMcbjgBV++diW94CF5z2TrjL9fiSHwRg0fTWF9sLiKP74?=
 =?us-ascii?Q?spK4TA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f19db4-d170-4dcc-c06f-08daf89e23fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:18:52.1315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhiFZw/+khAt8wpiBXSh9dTexKY3ugr7eEDu3yHgzFqPj67brsQfqFZwlDSKydu/JXwWucGglAgJ15SZUXJvEQPwAtkBXKYbodKL8o2oe1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5313
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:38:39PM +0800, Mengyuan Lou wrote:
> Convert various mult-bit fields to be defined using GENMASK/FIELD_PREP.
> Simplify the code with the ternary operator.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

Thanks for addressing my review of your earlier patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
