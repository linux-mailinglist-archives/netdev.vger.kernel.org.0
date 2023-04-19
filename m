Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33D36E7B5D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjDSN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjDSN4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:56:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2A01AB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 06:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNJ5W7bo5UYbNeG8I6xS6SLMuPhVZ92sxsAucB+NmTQx6GrTPHxvWCtFJi5YJagQuzroKKgqxBxoeLC+WC3+dntH5ugDpJsUzD3Uq3R4k07mXDclWyDW/6/Swqt6xZo3oWlTg2/WBDwJn+vigdiiY5GwBxX8Fzpz45yJ4j9XnFZW/SjaBZ4d4si1iHg71byf8tu5P/mEp/t5ODBoAWPLHy2RpZd+CcG21ZhWwAPPgZFZ7IPPfRjTucW8Gh9+aHfHksnch6n4iLPy4TT0b4j1AjPXmQP1Gpz6DZ+FVCSD0EoCx08upnT+XaO7uEzfhs3aDBU+MDncTfv9Oy7bllbglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uR0YPf9EjOJcSdkH3cNG+Rz3JsQQeMJP2qBo14DE7s=;
 b=MojzYRJj/hK0/yGuJDwevRao1p3639XbDUT/uNDBqqtanqsdi/dSy6XIzxnWGVgnDKX3ulkHvh9dqRrRqMFFjeXBDiBhg1wMGCX5aNsa0NG0ASku/r+4ENTz62sDOpAj2KXrBx/vNqlX0jQ04pTwkzSBz0Qrg4jbSq8oQVpogP/rQuDOtq/7djQvUuUaOKAxCAvMoejETQtsudzltP1pb8g6rvvJsmXqXG+Ez+WM1I3a3n/c/0QkF70g9MDeFNVFk+NaCu3/pAJGqSJQDyloarea+mNCa63ps2R214EKJZL38bM5kfUmQDfkkroawpf8te2qrLZ5QQgf9rqctSJKoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uR0YPf9EjOJcSdkH3cNG+Rz3JsQQeMJP2qBo14DE7s=;
 b=XXJFUFExExr2X9iXN2Ef2KNK0CSUi5xqL0QraQ3uhWc31X6P/dRS1IdJ/VEK6ddevJauR0XbAAAaVlEzZ9DiDkXBP1OqRyXdqskwFz/5yuaZ8scSfLV9gC+XRd2iCM0OE/UV706ROkD8BO6kvcDoMAw1ofxgEECGgXX2QsLBjRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4649.namprd13.prod.outlook.com (2603:10b6:610:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 13:56:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 13:56:37 +0000
Date:   Wed, 19 Apr 2023 15:56:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Sebastian Basierski <sebastianx.basierski@intel.com>,
        kai.heng.feng@canonical.com, sasha.neftin@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/1] e1000e: Disable TSO on i219-LM card to increase
 speed
Message-ID: <ZD/zDjclpxL1o2mp@corigine.com>
References: <20230417205345.1030801-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205345.1030801-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM8P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3cd71d-a043-4ede-b835-08db40dde47d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/u6Pb7T6VkoCNREi7H7PeMxMgOxC1pKLwYQqZ97Mkl8h+opVI0MwE6Rdlxd2ee0haqFfbu0lL1eWCnSF9NalTDHpR1Osv30bbPzSwexLg/LXtxT3kYQsUuGluxQmG0L9MiEXlNuip5jT9402+bTPEYs8gKgGSlHIMDvZtSBWuU7zzlGrKseTVV0FozoxWFY5HN7FOohZfM+4R8J6p2N8GHHgVVgHkuQ8PN/CxzI+k3dTn4/opiQUJgWzn3lVatXKYOoEZ+5eA6zthlIp4GW1QNAaZv/OL9HYqpiu7TstNN2LhJgjalE7Zwkj/pEphmxkc+RbJMXQMz4QHBC0TQOWwlJaPHsjWfomfqViMisb74rVu3b5rjfxtFAyINHy70MJOzkyXwXO4M6dr2G5/z5ZGF1Ud2S2FMkaLaE+g6xU4ioerJ3NOhIKRWrfblPexCge0uR8JE0NVxqjKP6wThGKjt4BMlq4d6uLwFoSADbXJJ97EJPn8eOf1vLvkCZImgq0WQbW2kdyyOHsjPLN+jfgG2kJcjzBNoCmbMXLZhqhwJG78u4Z7+FK0ugpcQLtGfX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(4744005)(8936002)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(54906003)(478600001)(2616005)(83380400001)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PSiXxB8X23cF3LcckJAR/s7PlcPMcbx1GHcaqUnQntKEjODmrv9l2HTNIyvz?=
 =?us-ascii?Q?nzxBraHc2IwrofXo8Wqht14TMZ7UCuESCCS6PFKoGAk07UleoqnP4lbdvdeu?=
 =?us-ascii?Q?MRYAPD0oTH6gfmyPKaKKNKAO50G2FDaxAh93v98fb2VtZzTadivNJApEGZrl?=
 =?us-ascii?Q?zjcJ05xW3LD845MGwrrbO1yFxhrIOePM7vuzSgsALbdfBMhjGhxyfgBtxztg?=
 =?us-ascii?Q?FlwYASUU4w3WVu2P8B1nOK+M1xkv/RibbLgmOHffsVl96X0eMnEb8bBJ5JZQ?=
 =?us-ascii?Q?0oEp3CYfzlSnmMfPI8M/3lCLlaVaGNBtdLt9YqBsBy15vwZIE9obf4Zd7irQ?=
 =?us-ascii?Q?d1+j8la/xPTxdio97WsY2qo7wwUyNY+ktw9Fa18+kBCpCSnOarvu2pABnLde?=
 =?us-ascii?Q?PG69qDGwF3VMA/1QVB3kNAJaFP6ynnKZhMJQ/k/xsfPkiFtf4qchZxTMoNB4?=
 =?us-ascii?Q?EpOBsji9/lwvKYJXN1xd08jX5RdUVbFiFuEgh8hGgnIL+mXrGr7p1qVr1oQh?=
 =?us-ascii?Q?2pctBQO2Fg7vso/ss9KSHq5msRux/a0BhzUFDZWOV0lu1j7XhDyELaAx/1Re?=
 =?us-ascii?Q?OBUi6hZP1poUrhvLYF62ayz+VLw/mOODCbUGpBq5NaCAwvMNszC+6eYTd9nQ?=
 =?us-ascii?Q?InzsEqEg1RxkfNhKPZ+E1qTfA2V+8fCPJebCSbdbUYyrZpZ1a7H3RFKtoaNM?=
 =?us-ascii?Q?z4mrcA5TZmFJfAacYoi5ipiLdjFS4es5ACCPvHkwbvOt1O3pENGqUQFdqVB5?=
 =?us-ascii?Q?P9ZDkeFtMwAEb1hDr8SvtydI6rLXO9LLNRreAGiiJY6rdsdMWVWN1WAVbjgd?=
 =?us-ascii?Q?tqwIYal1u09CsD2lB8qW/FMGB9EgVjQWGC6zH1YeInjeYp3BVd7YaJ9UHoZt?=
 =?us-ascii?Q?x8vUA3yS3FU6fndh/HZhI9LvOGiuX3FCI0U3QJK+cyYhAA9a7bpgx5zxeI+d?=
 =?us-ascii?Q?wO5FTHsd9KxlQOzb4pvNj2UvpsR1L05Etr8p+p8KNyReqzLnoCIeNv9Bf4VO?=
 =?us-ascii?Q?D7ar35nJEYRJnyMwCV1sJEOk9yO6Wtr3NDzvzZji7YZdbdxq1yH7Wn3Iarjz?=
 =?us-ascii?Q?Eu2FysLoinsvzeg2+sXHUUqxLCbr8T/51uP4pSR5cJIkmWTp7GxEbT18pK3L?=
 =?us-ascii?Q?O5F87FcQOAFbBqTmcGyKmq0Mv8tpcu64icPhkso+ylcM00xlfesvnbhCh57I?=
 =?us-ascii?Q?fgZk+RKunjE/aKubOu5FRUSU6qC0NCoxJxzy4YOzVusRZ7RCiWJcSRU/Zqhg?=
 =?us-ascii?Q?1X+cFHQI6WYiAg4dNPmMXNgXJOZB24aWWOo5dwtRTR+vhvY5G+4bvZ6mTWkK?=
 =?us-ascii?Q?6/ZVRevt6JZl9ZcASbxBbbvQQF8g4n/EEMzsasrQn6yXa7IX3oB5X8w9LgS6?=
 =?us-ascii?Q?UEPmSUEvERrQ7xpbznb5EGQwSncTR8fQD6zTbquvmB+RwXj3yXuqg3hbxSw1?=
 =?us-ascii?Q?f9mbXqreZL8SMbP2ny9XKjQmLajLNadwhMbKvkDv55wAEcufC0vXCIupALk+?=
 =?us-ascii?Q?UIpOU+TeuwlnLgVMytVPz4Jnh2pR1R3tTMeR3eIwTGvWB8kbzXOrtB95BQm3?=
 =?us-ascii?Q?gkq941P6fe/Oc7+wK+ARlJHyaOcFf1toArLDysyZOfLXuKtfQuiv6Yzkb7/A?=
 =?us-ascii?Q?DpOrw65qxm3ZyHq5mcOS4ZIPfUSFSNWctZBUOhxDK9B2cmsFvp3rBwuXuyWR?=
 =?us-ascii?Q?CTJScw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3cd71d-a043-4ede-b835-08db40dde47d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 13:56:37.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae6LnrpdbdiCR5m66kvHmVyXGMJbAt9HXXV9UgE9rZ6qBQGWQ70TpNk7DG8LE3ld7SRKTYbf/MzHb/W9KHginlnin4lyIIn+gNi2zk6x1n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4649
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:53:45PM -0700, Tony Nguyen wrote:
> From: Sebastian Basierski <sebastianx.basierski@intel.com>
> 
> While using i219-LM card currently it was only possible to achieve
> about 60% of maximum speed due to regression introduced in Linux 5.8.
> This was caused by TSO not being disabled by default despite commit
> f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround").
> Fix that by disabling TSO during driver probe.
> 
> Fixes: f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround")
> Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

