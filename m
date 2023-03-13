Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085766B7D7D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCMQ2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjCMQ2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:28:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9C52B613;
        Mon, 13 Mar 2023 09:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCrDgWcoqdNjFYQI37E/dlCp2k8O9KiNV/nZ6Jbz+wJKrKRh4WSXKtGWm7m7mVkevnjwzPzM4xVK8jZLN7B85c4bHpzPCm0tQbVabfL5wfS98ptAPwbjvtDPhllMPC6edvfDazhgQgFWgKOO6YaH60Od0LSI5xMWe3vji2r2DEY0zw2XnhIqqx228Yo2o8VDjcQH7ioVndqg9iGK65avvKlv3f8vrsZS4cXrO4scsmVVgkCHYDLnmP3t7L4Fybf9sXPh+x06hUEz/tqzV2Cn/UE8fwEuhOgA8sb3BxBCFiuvvaBJejMBXP/HsNvFA/76xvsjTpvvzm5q+zBbONoPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVNv5/yl2U+V/UZxwhbaP/kIuuHZMdWCNoRtjcpS4C4=;
 b=GyhKdLyeKJjSseKc6reEWvzinermI+sP1b1+RMAUFGYJCOPwVXFO126hieGUjaSbPaXayjJU5NZZKVpRf7ThC/LYNOzxxDwcsqk6FGtU4Noz4CkxWewEeZ52igFBYzQv371La78PdYn8ufyCuMSRMszlTq27w3Fda64DqH7OhDSfsH27KoQ6m26mjYzZMbdI1ZEVGYU2ZfB9udlAhtqGX1ZfkwZeXgLKhSP+6c8kbPxqTB9Bm2yU5NmR2OsqRHCkDFeFmF/As7A5QYRnM40XlefP0bU1sDo5sjkKTRgrR3d7f6QtHl8X+rPLfrCBIQnGMS/NmuRyDNVg+CYFoRdJOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVNv5/yl2U+V/UZxwhbaP/kIuuHZMdWCNoRtjcpS4C4=;
 b=Ler8am5divGsBBiJ/pT/iKIfZ5O7r9FztgjxzCckwlLrx2Eh5iWZM1nR4Wtn7IytXuiI7LpgQk3a/7svUfJgj0cSf10Ve71Tu0NjVufwzharZdUS04vwFRfAc019TTWhXYTQG5biE4oqy9gf7Z7Y8OzovwJzpMQbKy9aRA+iXUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4147.namprd13.prod.outlook.com (2603:10b6:5:2a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:28:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:28:11 +0000
Date:   Mon, 13 Mar 2023 17:28:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] net: marvell: pxa168_eth: drop of_match_ptr for ID
 table
Message-ID: <ZA9PFB/0iphpTRWp@corigine.com>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
 <20230310214632.275648-3-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310214632.275648-3-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AS4P251CA0007.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e5bd49-ee93-499e-5d4a-08db23dfeffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldZxgN36bL5AR3kp2xWJzJbLRjYjL61KTJyKiVUXXZ1kCR9ZuJPG9DYRnXxSGbOgHq7tmjUW/Bw08lk4LDggSlhRt6ys7K2R1LGQSApf7Ud/FzMqpSV9TA1Z2UQwcuxGj0CrsOCMleflOyPkU4+lRSWt9eopEUR7az7YDxjP7NM+6+T97wIx1e/2U48/AWOF9ynfZIhMn6ZJzeA1jpRVJwVFmyqRUHMxRei0KxjgT4zCtOWus1gf0HdCNINQlIfD3nocROOIQgAl6G3UklwWqZe9t+B3NwZ69AFjlLW3MQpX+zH1qf+5DKbBR1EjJNIdZnRPwVXF+zB5J8ARWCI1IcV05jFIE3rhu2um1ksQaDCp7gJHiqHNS6xzfzPQFGOQCZs+3U3bRL3z+LCSKs2liGVXimikSDvdB2Frl+SXg93XRBcvJY1WpuUxxskjhE4fSCv0MLb22jCqjz54WfM3bQ2zZd7UH+8zQV7rYDgTBPC3jQdPxipmFQBW3KzQjCQ50RYh2SVG9cacZETo+5XBOZaWXfy8inyntpU6ZlzXylCBFCf64wmjPmJymvtFTg0WdDDr1tMLTlTOkOXzIoEP7x94WKV8UIm9kU+5ANGi/Rc6CY45ph0QOlOyVQxxKcht9p8YywhiVKgEM4aBxGnwOsbCq+6LQdV1o79At3w0xz6jkPAWDrOfru9ZRsVLX6Zw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(346002)(396003)(376002)(136003)(451199018)(41300700001)(54906003)(478600001)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(6916009)(36756003)(86362001)(38100700002)(6512007)(6486002)(6666004)(186003)(44832011)(5660300002)(7416002)(4744005)(2906002)(316002)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzJaVk5PWDlpNXlTVWRpTzdvNkF3QmdNREE1NVQrSnJzMXNiWU05cEwxblgz?=
 =?utf-8?B?OUR2NjViVlZuc0pqZUg4K3BGUnhkYzFtSW1pOU9NeTZNOW05OEYvRFpPZE9Z?=
 =?utf-8?B?bEhnNlRIMG1sQXdYNldsZThtSGNhUmdTamZET0d4MUtHOVpzQ2w3QTFTcGVM?=
 =?utf-8?B?amNMZW8wYUM1bGhtUUdlTkE4MDNOa3J1M1N1UnFldjlIYmx2eEVhcWhCVVAw?=
 =?utf-8?B?M0pxM1l2QVM4aHozMzREZjFpZVZhTlZEcWtwV1BmUXhrZEhDNGtTN0hJcmZH?=
 =?utf-8?B?YUQ0S1BsRnpZZTlvbGJIaTFoK3lpa2lmRGgzbTlPMzlOdFluYWZFOWs0MXJE?=
 =?utf-8?B?aFlUYUplTlAxU2VDV2EvcEorMjdYVHhlZlJLODdZTnd6cG9UM0RibWxzaWNz?=
 =?utf-8?B?K1FHNDRYQlhUTnZ2S2wyeXZZVEJEK1FTcG4wdE1yL2I4dlZoODlsUTg5VTVR?=
 =?utf-8?B?TUQ2dXFRN2dNRWY5SDUxYmRUUEljcEMvOTFXVGxmY3JxSytObmNHN0drM0c5?=
 =?utf-8?B?T2ZnQk0vQ0R5bmI5aWRISmZyTEE5NTZxUUEzWXJrOTBseStLYmNIVHpmdEhY?=
 =?utf-8?B?UlJHZ2ZwNDY3U3E1aktqR2dhQm14WndhT3NGMkU0YmpXaUtPUVR2cUltKzlm?=
 =?utf-8?B?ajBYR1BydnBmNC9tT09MdWlpQkxmNmlpbVNvK3d6SWZTRVl3aU9rcFA1OWUx?=
 =?utf-8?B?OFJuRFJPQVVZZ0hqaVVyWmlkZEtIN3IxZUZLYitDdFNPQWFzdUMrZEFwZHIx?=
 =?utf-8?B?UjJVU0tvVllzYmxkMm1IMUZrR0hjUDZCNmhsQldqck9wR0c4QlhkYWg0U3py?=
 =?utf-8?B?b0RJVWQrSGsydUNNSytua0oyaVpsZFlGTXBoOE5JZ1NJYk1PM0dsZ0FZTUdl?=
 =?utf-8?B?Yy9pU2FJZEYrV0UwVkFneDNtbW5PdVJacXprclJxVkFsakhxY0llU0JIbVdV?=
 =?utf-8?B?dVAvWGdWZ3R6azVqRFk1azYrdTNneFNTNjJMbW43bzJEYnpYVmFTK3dPd2tz?=
 =?utf-8?B?enNhVCtyR25EeVY1bW44cUswYzE2VXJ6SWhhVFVLMFFwNlJKZDgyRGJUVmtZ?=
 =?utf-8?B?cFpqT25KY0tEdFBENW1POVpienZSTXZIZ0VEQ0R3bm4yZ3pxQWw5V1dpbWxJ?=
 =?utf-8?B?cURDQTRVbENnM3pWTVBvb0gvZnN2Vy9xbktkS3JRSWRJNjd2NmdZUTJKVnRW?=
 =?utf-8?B?alFOWHVEN21tVWgxaWUwdmthejNhWlBtVjd1SjJHaHlXUUw4K1hPSE9QdzRI?=
 =?utf-8?B?WjNJams0ZDIzZENTV0FxVjl0dVV0VzlubmpsQXRjZWVlcE8xamZkSS9zNUw3?=
 =?utf-8?B?Nk51ckFGT0NZU2dKTHZHUi9aS2QyS2xhWjErdG4xQzY0djVmOXd4S0tUNXJv?=
 =?utf-8?B?b2ExTEdNSktoa2o4NHpOZ01IbVFBMjdZeHRCZElnQWdVNWxScDZTanBMamN4?=
 =?utf-8?B?YkEyVW1teTB6dllyM3llRUlpMWQvemJVQjBXRjl2QkJIdHlUTk9OY2lXZGdW?=
 =?utf-8?B?cDdybWp0OVlDeWJmNVcvNFovK3BxZmRXV0lhQk9QRmtjQWZQaGhWMGpwajlz?=
 =?utf-8?B?Nis4dlRBajFycWYwMlVsU3ByUGY3bGNDaVhNa3RCRWRYQU96RXdiTm82MWFm?=
 =?utf-8?B?ODJqSlJEVzJ3UGZDRHg5NFhKM1ZvcUpKTFJHb2p1dDNZekJnN1dJS2Rrd3di?=
 =?utf-8?B?OHNoOWRzOUU0ck53OGE1VE5JMy96dTl5dTE5S0pCSlhZc3pySHV1Y0NqK09I?=
 =?utf-8?B?R05tWHMrc0FKRlM4cFZuQWVreWJyNFdXd01raEQ4TEVJY281YTlEMWJ0cUxY?=
 =?utf-8?B?Q2NZeHR6eGIvQm1sY1Vpb2x2ZU5UQzkxQzdHeER6RmNXbHprUWZ4SWxRWEpS?=
 =?utf-8?B?cERtR0hZcm9KdXhpOGcwcVNqL2RjNklIemVOdS9MTDhKM3RnSEhxaGNOOVpQ?=
 =?utf-8?B?UjdaaHpZbkRxa2hWUm9TOWVwQXhMNG9oQlFWckRvK00zV2VtbVBvemg5dndp?=
 =?utf-8?B?WnQ4a05NZGRBZWtSWVE0ekxMdjg3cTJhL3NNMTJVajJvVzRML2RuVE9qdDBB?=
 =?utf-8?B?OGZRU2NoMm5SVnc4SUlFZmVIbWJScDVTSlk4cmhkKzV0di90bWMrQmdadG5K?=
 =?utf-8?B?ZE9HaENCWCtFbzlNcnJNc242M2x6Z2ZwSmY5VGQvWXBoaWdEd1lRdkgrVGNa?=
 =?utf-8?B?V1JScUVoM0YzRk1uY2hIZHNMdG4rc2hMMllzQW52ejJ1VkFBbi93VWZreFhD?=
 =?utf-8?B?Uk5QTW9FWGhMUEFjemIrL3BTbEVRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e5bd49-ee93-499e-5d4a-08db23dfeffa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:28:11.6242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FMo1aiypoRujuMUs3j4y3/uBELKsnc9vYjPgbEKeaIXkib+ZiZUct0JSU381sMxcSHSLVIGkUyeLQYSPE4atkv/JgK8hUZpGdLjAGKdjPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4147
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:46:30PM +0100, Krzysztof Kozlowski wrote:
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it is not relevant here).
> 
>   drivers/net/ethernet/marvell/pxa168_eth.c:1575:34: error: ‘pxa168_eth_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

