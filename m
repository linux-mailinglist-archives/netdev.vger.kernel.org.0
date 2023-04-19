Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F76E767F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjDSJjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjDSJjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:39:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2133.outbound.protection.outlook.com [40.107.243.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E232D4C
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWD13IYpAls9w7iiG6By0eVSPeIRt2OUMPtEAu4oh3Ex1sXMEUtzp1IHwyMFDZTJflQyWx0FukKM6se4GEaH0GP+cchX+yNa6/bfmQunI9d7HGA0nRAp6rfrwUosSyHLRJJo6Q7bBtSTmy/ULCGs4RbvyY6pb17ZP9q6rG20kEIZGbmfqBK2YiGzOiPcxVHLYX+Wh8JDgADhKjmbjR0QJFf5C1SnORL0087W76koAmZOouSyswrYsY1/5EbeuE+jbsmDlZxZQFb4X51MAwjBtO3COm1qiQjddYOuViTGO/Ss2HCshpqAXf3SSnk9c9JuaiCPpaK64TCvm233p0pKRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve1YjZo+RkBSOP07RQnU6kNdPow3mUmCXHfwRVR6hfo=;
 b=kJvmpKuYFrNdEfDev2kYxdVf+bo9Hq+3jqWcKO4sI53SbWLXZvcF703QISO+dFZXV0VToq3uUo+n9usi1FIBeD/HTCMM7x6Y+PgeYIpYiQLmoMJp6HMSp+KPmnf0l+K+0YMl+qX8z+A2+/AZKORWg6WPXpE0XrzkIgvEMncaxI3EBv5E871FoG61RnVUldhKmqZjQaoFlZovVGMQbqzn7cOVhKMZlO9QWbFL/xKAysV8xTmIPpgrYvHP5Sn81rJX3YLrU2itjneHzAyBisFvYnwjDe+sAKIBqmrQ3o/5CGOuQ/ZuB3w+VxdbhYKJoL/1cnvxxMAGUCTpW0+6pj9fqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ve1YjZo+RkBSOP07RQnU6kNdPow3mUmCXHfwRVR6hfo=;
 b=NT8u1/r5oegCFe3At13s/6JPJEgicTnY0jHGmNDeyy8x2pHk8XZJQau2kA2Md0JNcUw1FQ1hG+A+b5uZEdcL+yma9fKEIDJpgZ/Vk0Y4pasX6gMoebKZYGNbRSzP2DN5FQVi7vsK1GXM2W8OrVMEDONgNi+1nHGqKNH5HeKnQeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4664.namprd13.prod.outlook.com (2603:10b6:408:120::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 09:39:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 09:39:13 +0000
Date:   Wed, 19 Apr 2023 11:39:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v4 2/5] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Message-ID: <ZD+2uqU+axYWg+zH@corigine.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
 <20230418234354.582693-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418234354.582693-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR01CA0079.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4664:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a5264a-cc15-472f-648d-08db40b9ef94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zn6aNlOICPNdVjcAAiGxp9dJsnPhxMq71ySNZDazG77XYKA/DcqMdwuscJl+4hlCTXsI1N6dlcoafNRutiz1DGmTOyTE3IAE5YPDn7s3RtjWEF3LuuvUX9BTw6ns2mSJ15WO2JDbtab6BIGfoYTCCQy+FiajPg2u+ipkdiw7L7ijGjqrh7HI6hCz2xSUfXfgVppNWxlBuK2xmRVNu3XGbgYtWWBwY4bZUzbVkDEd/N7JTZ8S2V/roKaJJxM6PnKwb72wdTqoo0YY9unfyX9uUitdLFwRynhYxHza20hGQNn3yS9dCZLd15KMkdaTw9MqRqMN0sPKYIKbFS3rUHP0zknkbDCFIXqcPvCjsieyVfWC1ZdR4cwpLSyyMynD00Aje387mbj6f0O12m32kZ94fMmc4DiHr5lW+Otkmfiz8wSfcVru+9hmGyztj+l0G2TP663P2/Ft8gOQvKAb78LqpWMqvA8ZUqJYnu7f9lzPBiFIaJlVfkNe/1H22LZPWaTBgvkckWwkTKJa7YxON/VcG3fNWOH4Ak0kpXGtCQOD955+aUnjFoIhE33JP2B6kQRZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(4744005)(8936002)(38100700002)(8676002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(478600001)(2616005)(83380400001)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/NAnkTIQEPZyCmoqrDhPoT8sP65p+bY45bMRR1ZUxWo8BMG1PCDKlXAQBK+O?=
 =?us-ascii?Q?cNwYMFsNgjCeZf60PZW4KV0rmt+RM3GuclXN4sx4l4Bog/PamT+nSO2fDfXS?=
 =?us-ascii?Q?NN0qY7UJQT+pNSC1oU27+4d3RDuwgPc3bkYyNpDqwRHALj/4BKGxXGzaXS/7?=
 =?us-ascii?Q?8mOP1F0Gt7nRSD+yICkAvwH9C5gqzDfcCsvesfH7LJOr8qJb6w8BvtkdIMfN?=
 =?us-ascii?Q?wY1A7yO6yb7lRqAzsI6jHq7PVmxzHDlfo+GVNYdmkLy9gZiCmnT5sKgJOXZJ?=
 =?us-ascii?Q?EoD1ulnAV3yNyqoOdK8P6LsCNZ3RthMiUQbSR91UPlTD0IbeaAM6gQUY5nxx?=
 =?us-ascii?Q?SVCGoVQqmY0uvwsynvlNTkTtDrJLwENLpSTErOS6AGDyHCLixYOkSFPDWlkS?=
 =?us-ascii?Q?9fN1i/FbdrHaWY9mhPd997bI3o+sUZWQi3lvJYDnAqgNKFcHWJSp+pk8/7rs?=
 =?us-ascii?Q?r0uw3P7K4hGYJmRvg1IdRdebYQhZR4CxerC2g0Yh/Cnlb6DMJ2fkQxY9g6Jn?=
 =?us-ascii?Q?it5uev2HOLX2lf46PCAX947cfFyobSnJMYopEh5nhLjRsZiLwrjyZ3FzqfpH?=
 =?us-ascii?Q?e1Mg64xQKHC8L2Vr1AsscZFTtGt4oX7bBr1WUrHr7r3UlbLQpAnVvKEa1esA?=
 =?us-ascii?Q?okX7r5P+dEHUKkbhSMvImju4o4cqhSbwm3b+Qs2lS19oUUzx3+YeaFbqIFy3?=
 =?us-ascii?Q?mXBeDzgIhH5Gz0nHxj/UaWhU28MU13Zdk4Hn0Q8NuTxQpoqwPYyfLyoulkxt?=
 =?us-ascii?Q?ypc/lbUy4IKyJjOLJW+g4Wq21/g0ODMY0Dlf8ZEGXqcPj+0qv583MnfGsNGQ?=
 =?us-ascii?Q?E0frf37Xb8W5fPGu2g2Da5eHeDsz3NvtrfexytMxkrcjM5yasaWcnFMi/Ysh?=
 =?us-ascii?Q?kQXR1AS7drtOTpt5UG421vAgfUuczHkbQMke9jZetPlQMaw4J8bsqKZICsIO?=
 =?us-ascii?Q?1HZjy0NqIyoxHpyScOo552vQaIwFxsOOfreSwkxKTRAEfXTcQQDlkhw9T3Xg?=
 =?us-ascii?Q?upJYJ/bVOVq6spk7G+WCzK2SrMj/A9rdIAqMgOhzBE+QMfgfpSTqQinps2JL?=
 =?us-ascii?Q?7OgK34J2B6zyB/b8tJXZKmqrdnGzgmpbp65ZcWZ481IpYTBP7hagfWJz9ad7?=
 =?us-ascii?Q?XbIb5KcZVFhUdY7IAwQequgzsCvz6bAuYdvox5LeufrJrmk0Rp1O/yB7AcDM?=
 =?us-ascii?Q?bcGrj7pUT8ZMdE5ZhpZJspoxsPeYnFP4cCXOI8oWPxu6rh0XUD29MPAz4cKN?=
 =?us-ascii?Q?X3jluz8d7inQw9IDREWv5fTW3iBhSK5KiIpRbLEdcN2FLkKjaKSiIbJt+ex9?=
 =?us-ascii?Q?zO2LUVS/vnThEbeZMk4JngGaEuhVEahaSsER/k9kVYs11FzR7qNSr0jLorN+?=
 =?us-ascii?Q?stMrQfldwyrIVbUN1euov0IldMwr8jdrHJ89a0vw42nmm7LxkoR/A4Cf6Ttd?=
 =?us-ascii?Q?Dp3ngyGNnF9108M08GVfLdIY0e8Kc2zoA63pCxX6bAy8UbkyZsjAmHBdRxTj?=
 =?us-ascii?Q?clSQc0SUlLbTGGyuZ4KqpbfEsFhljeKeMTEAzoOUY4GjvFHQmNV1ljRy+xKv?=
 =?us-ascii?Q?ojw7rVS6jk6kv1eNjp6sHIXlfCfdPECbpV/YibaW7O1R6TMKUvszmNdH/gDT?=
 =?us-ascii?Q?gIk8u9YXbTXCRGp9VhZoPZbi37uQ73/PaRsz2CfRvMq8QI3KqpDljuT/d/zE?=
 =?us-ascii?Q?HsdcZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a5264a-cc15-472f-648d-08db40b9ef94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 09:39:13.6928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtZihZ3NT1bFcvf++5nAO36huKFkBmEwBZyF/Lq8lHOgd59fplpe8LgUs2f061cpoAF4W6UrflrXLKOUK+xGBwyCKBQIBKtGBBlVsmzJjRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4664
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 08:43:51PM -0300, Pedro Tammela wrote:
> We have extack available when parsing 'ex' keys, so pass it to
> tcf_pedit_keys_ex_parse and add more detailed error messages.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

