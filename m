Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32206C57A3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjCVUb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjCVUbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:31:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20709.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::709])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC599BE16;
        Wed, 22 Mar 2023 13:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNZNw9z/eaMIIufwuc9SFXGYHSGzZj2iMDmdWE/W9IG6RgoAY6eCAP5umvqyVeeaRmy/TWrctg8CClVfTYYkNdsfh85DXNe7OlSZZ8MOcvHXiV6Fn4xcDmiSQrhhKQqGcrqOFl+dqifzL3tS71vu1dx0TPixvHfox3v0dqsGJ3InQrpDBKEY1UXIPevXJg1P2lVRyyktgg0E3Vs54yaJcxUF4IQMKyvDzXOqKrEgd+slRn00fc/aqUDFUpWMDJNJFHzOemCra5x9YCX5JPGPNI0SShdbwHsLNbvIgl7Yvxe+noqCMTqqBRHNblm21tK8JlUq9b3EEGmPo3Euquujqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSgU0qEuTR+I7WLYA3b6O8Sy4zIjeSKPQj1I6YkpmAU=;
 b=kMh8qDv93zLQMY5Xc16Mwh8aYTItagz4pKKg0HwzAF3rWPNOexEiMsgGjF1RgeCSpSIZBTG3a61CFuRaNg25rLuMzGFbHxURxxZg6NM+Al5lxhvYiUD+pqiUJXLpy93IEp07RL5NsgAYTTYmXNgBJggYpgc/zFmPeZcWMQF0ywHVtyrC6aUAAcZkQiELOZgfyyHaZccIoDjg2rvXvIK1UoUIoqFKAxJq3O+CfqOOd9PmBsLhq0Feye0Eu6kyJkXYPhQB4hw49+AcyrRM6V4tyTBumgcLYpop9lbGfqZJ6XhU9OClt7qpersSXD4Kf9VfLmc4rmaW9s/UyKApxsHIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSgU0qEuTR+I7WLYA3b6O8Sy4zIjeSKPQj1I6YkpmAU=;
 b=sSaln+pA+catdJHDZQN1yuEvCiWCMm4KE+aSyKcmzX7GtGtG7GgjEWIy99e1D0/zeSilLpAXFB3YH/gt77NDxAT3J3t/VigbC3Eszf8opLZtPNyNL66ZFaY8pnwu8QVzkT14Y3W2xnI8khGaNHqsVJT+i3FcsfnoHjo9grvJ2Gg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5511.namprd13.prod.outlook.com (2603:10b6:303:196::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:20:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:20:40 +0000
Date:   Wed, 22 Mar 2023 21:20:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v3 2/2] smsc911x: avoid PHY being resumed when
 interface is not up
Message-ID: <ZBtjEfvi2BR9r8Px@corigine.com>
References: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
 <20230322071959.9101-3-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322071959.9101-3-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AM3PR07CA0110.eurprd07.prod.outlook.com
 (2603:10a6:207:7::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5511:EE_
X-MS-Office365-Filtering-Correlation-Id: b679c7c8-e4f3-4396-cc3c-08db2b12e7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFpqIYWFMwsH6eDLP3r3gOgwOkeZsA/XhC595luMzWte9Re5+/siUEX4t0XcNlc6xkf+LHKp8JX7N74uL+/Z8id0cMac0hfnifZa6uQMsigg9+JuwK0g1x95SkwfYzhcBZUOT0ZzyaobKrloVZMqiYiGAUSZs1jU9VnGWpID9Jx7fY/Hx5ezRgiT/PgT1hlTEy15+LgBCR9Gp4NiAGS+Zp21kYAaQZy0tv7Eb56osEGJoQVQVApQjGgsM57RA3npUOGzHjg6N8kpoie6i3KSNYnLc0eKyeQdsRGqNlZMYURjCRk81l0KjjfymvaT+Sy5ieI5380matE1AHiqkH8u0YQBmgdM8syGm6JaMKa+k1kQuoZnthBXotReu/eYGxaaIFj3YAlBjZj7KgvuuxI15HUTXfZ+8GU2bmgmXtifv6VWe+RBOl4juHtnFvsTcDxeExCSlRgsLonT2fqEbq5a1+aiEPBEBGYlYT7L9ygacyrFn3VenhYFvIokF+EmbzA4DoeOIVelKOfwUx8BvDi98iQ9r3p0Lesdt9U5xtaFvp6lGJXBmQtczOHnVwJRrKTNF0IJeI8hEZ08ObHwHlRdq1nfaz0ElG/nGcSOg8dIhx/x42BCx/r9pURwfP8mdO+lf7NYAqNsTvScMzAI+Hddt6lUZTe7RueBv0ziS/htNpc+P4g5IKVUPtwhaDaMv7np
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(396003)(39840400004)(136003)(451199018)(6486002)(2906002)(4326008)(66476007)(8676002)(66946007)(66556008)(83380400001)(316002)(54906003)(41300700001)(6666004)(36756003)(478600001)(6506007)(38100700002)(6512007)(86362001)(7416002)(44832011)(4744005)(8936002)(186003)(2616005)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Paf9MEKeLjnk7U2ZseW5dHZqQRAutk30b73IaAXyLUqYitf+CEJmrIZliQdx?=
 =?us-ascii?Q?O6ZM9iR8V7+fPMSs5MRlKxsXcfrwfMIawItoeGNy6SE2L7mcszkIYEbk6ih4?=
 =?us-ascii?Q?Q08KzoNcKa478JWj6rPZ7Azx40WkzOErqkeSmtip8H7OIPnHQUqO99Neb0C7?=
 =?us-ascii?Q?5ssHaUbAo4rsYNVhqGD4RtKl/fiWDlJq/JyCKe9cXAlxhcHbaqcDawGBidfv?=
 =?us-ascii?Q?fQGZ0RRWFqPZhQrxH8vaCuvU9APhGDoSa3XSX8tNgIUnqY/DftIXEsZK52AL?=
 =?us-ascii?Q?Wu5PKgkngLsCuXqiXf35pj3Wfhu4lf4RZ8tA8Ftj7lu2z9nMRv37giS+s1yO?=
 =?us-ascii?Q?GzDoYQDI9wRh0VePpEv69mUpO3bRKOIkKO3pBOvoJ6pD8ISjk1F3NxQvLGRd?=
 =?us-ascii?Q?5pvtI0K+dTciBmQ7tAVY6wCi5oX5iHSqogjIlmtBr6VAnkW6LtCdeR29prxQ?=
 =?us-ascii?Q?YV8EVYCkubO8sndLg1u3/VIBb1vRk5+XQi4gPMaCSFqDp2h7I7rjqysFVKZt?=
 =?us-ascii?Q?AFkYi/nnz6OtLXDbOdDdhB4yEN+RMBJ9VD3IpYPnDjWKV1gDM2MeyYSp0vHO?=
 =?us-ascii?Q?Rn6cZIes34kabHd6XJgjiw/BpowVprod76JkN2f6PA82PgFkNNuZxIwsZBQA?=
 =?us-ascii?Q?Eo39z6Bwxuqbv118Vn+U/+/ZZSY3DXpLdmFZz2qJKpHELxKfJscvNAjFsBF0?=
 =?us-ascii?Q?cM4Dzit25d/coETuoSZgITg6gsC0zZL54RKXzCeliXnKPmnstvm2sIMkU5Wg?=
 =?us-ascii?Q?dwuh7CYJhHx5+NES7dujFVg2j7V/rdl94raoPg2xVZkEEhYyTDjKBs/+Z53d?=
 =?us-ascii?Q?Q8JFOtBo7avn6bKaiX4OeZFJ/jhhhZr1VPpqUxUdfgCVRRJ47ZlE9bJSOmlK?=
 =?us-ascii?Q?4xvpfywFafkhH3yDBUOD64DUg9P1k5rfLSGq/sQz/KTANJlqHdWjaJrbJ8lv?=
 =?us-ascii?Q?hlHAmLgIztdsIRRWyyGJJVywD5RmkANUEq0AYqFGjSrVq42c2ZonGlMs2YHP?=
 =?us-ascii?Q?p+Z/c5gEnftRTH1yyI3N43vMTRDs9AD6AlqBV2HR6xh575fnkdZJ+OxpNmJy?=
 =?us-ascii?Q?8U0MK4JprLekzU3AUKbPkigkH8l18J5m2FoE0WMCuEmMnJC/CyYoRMW+RvuB?=
 =?us-ascii?Q?QphvZNKZ//lcrslWpLVRvX1OyWnODTS3uICkxxIDIuF9jNtjbPGqrPllAHa5?=
 =?us-ascii?Q?R5wFQmVuS5SKLyXlt2CvnpIYWm4XV9W9y/sHzcOILq7T7J+VqWdpNA6uDRHg?=
 =?us-ascii?Q?fMelIhHBBRm5IAo9wOdB6n+y6ausqhty8mGYQLmSvaZxlGYW5UouSRhfAcBv?=
 =?us-ascii?Q?Y/NMJCc7eu3rpXWFlXB3DF1bSnR/uQ2BpOONFJTcOefVGPo4CYR+5jU/ljSb?=
 =?us-ascii?Q?Tin86m1lozv/+bCfo8YSLmR/3WOOSrTgfU9DjkmW6iWBh6OGDKqKUVkqHE1W?=
 =?us-ascii?Q?APLXrgKs2YYAcO6surrd3dxg+7R1LgBchhPgWtRjtWghBFYf56LfULtwRZcu?=
 =?us-ascii?Q?OexSonksWmn7o4HGXcGB39RSwiDKsMc8Yr714ATPl21zh28mpk9OmFfs0STt?=
 =?us-ascii?Q?6GfGEprLP5YPggGqXSBYr3g8Pv3AFs6RtGxE5y3eMzh5yDJyTKlhcRlpHvs1?=
 =?us-ascii?Q?GxvuHls+rRyoMdMuPcK67mdJ/JSCV5JDjhAu8freo+Mn5sCvrk+oSrBSFvVQ?=
 =?us-ascii?Q?qJbopw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b679c7c8-e4f3-4396-cc3c-08db2b12e7c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:20:40.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4Qo+XeuiepbYusJawsLTDUAIGz7dM+4b7UQVsG037pnTegjhvXVQk7gDeAMhLrkWWL5CZOQfc+96qemcYQhuOAndt9vrwcPXyWf2j/AcV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5511
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 08:19:59AM +0100, Wolfram Sang wrote:
> SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
> 'mac_managed_pm'. However, setting it needs to be moved from init to
> probe, so mdiobus PM functions will really never be called (e.g. when
> the interface is not up yet during suspend/resume).
> 
> Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

