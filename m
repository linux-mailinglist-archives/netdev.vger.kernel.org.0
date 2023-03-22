Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C2A6C48B6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCVLM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCVLM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:12:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A74AFFC;
        Wed, 22 Mar 2023 04:12:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNtsFoJaFzBZAXOpgkQfS/CJgJlryi8l6pejKzFlDnVbZWZaLmn5k+AyXfFS8RJtZlFdBM0fC+Xs/+hs/eAHsixEVzDnHmeOegG2O5mXRAqCJsUFB1WVtj7yEqlXPvcG6NMMQb4Ape3f8d0JseRon+SWc7BmHIFYsYic+W9LU2k1q4BIq6UJ3YxCa3aTriTrM44e9gNIPQAs9d+RvCPfYHxQW1o0NWmEokfyJ94W4AUTJ8Ta2BIQ3NlyBe6tosadx3pUisKXYtlOiEjIocnBkqfHsPeDE9Hj6+BUG06sCrFPmyb/9Culp1+aeG4yQaU7juhJcLV8YuVAbLHjjh9raA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4MAi3DHl1itBsIyqBBVJA+GdpglKeWXlYPh1OdgJJs=;
 b=BJUL19k5kG2OePLqRu2Z+OVq37aPZdbGBTgd5ycIaesXkRQOq2zIWYRkwiupEVYIxOu10kzGmIDnQbV12v+qHLkVvVtnWgWhqybGbAZ5aAPEKQd8T5BiQMi2qx5LnGfSwwQo6watBseORV3ZTQ45Un//3QNW/eftFJfgpfuJvbIY27WWNLY7M5xBs5QPAjoLNPf3pmS3Yc8eYl2rlTc3XjSW8ZtLowvjIu7NnADsYavq4t0tUZCR+WMCqtMW1Tf2wLPdI3rFx00BOhE9YsXKA9O/gpFwm8ltKtHJ7Mt20p0ZO9zM8YYwsWsShZ+6sGNtB+ZwhU2D9o6h13kqonniKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4MAi3DHl1itBsIyqBBVJA+GdpglKeWXlYPh1OdgJJs=;
 b=f2msZu1LcZ92iokAloXv3Zb2m3EtSRNxYCJoqugYu9ZBSdaM3/bjt8E/cikcjKR3KRiyF1ag+lqLe/qRr0DfECFhIIxt2bR9mzNEU/w1NrWPD7nqlFWRKYI5oOeFEqFVvfrJ1iA3a/ev54RVjCBh67Ii9NiLiPAKk1zYfqVvOYM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5295.namprd13.prod.outlook.com (2603:10b6:806:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:12:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:12:25 +0000
Date:   Wed, 22 Mar 2023 12:12:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] net: dsa: b53: mmap: allow passing a chip ID
Message-ID: <ZBrikVxKwBB3QwBd@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230321173359.251778-1-noltari@gmail.com>
 <20230321173359.251778-4-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230321173359.251778-4-noltari@gmail.com>
X-ClientProxiedBy: AS4P195CA0013.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5295:EE_
X-MS-Office365-Filtering-Correlation-Id: d2850d84-61f3-4d0a-84cf-08db2ac650d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IEXxcZXHOKba0z8nDJZVZ3AFqPISzCLgiK+tHzHeidi5jcBwYA8jjSkJmE9PtHZFbTBiP1jF+/G8xmEwhYjfA1wSBHbl6hLLz551eoCOV9RNu/rlu7TRGpm8CxgXIbg2wjjVdlfE2WBkNiNrEFG/Ff//FULfrYY37nZkveejmELbmDIFlTa6TUEUhcwCCjVyrVgz+win8p/tIcnvqcls0NrIahGZE2NJ4rQUGT8VczL6HdAXmOgIQxhXpj60zFAce9WkH8z9B4EqMEEznxDXQyF98GyWoC6+SVFf/+ObtCjuZsKPrFpUviLjrym5rB0sl3bOGy6kpzvL/nIGSGnBHlEoyWvJ1Ngqs2zTa1fCqvbL14u0AWv8bmShY3lY/FiqV703dFJMGiKxFvA3lQebozelN1m9xW5sdGzqz3NEjHrk2ruEYTraIC9M6I6bAj6lf20vpBQ2xWXXQ6dobFlAimX10Qf5fZg8Ej9gFXorKVxNNJ6Hl9rRMV+eC4OuqttfDeX2l0nll2NNTwmT3T/bzQBEihbTwU+//b4XsViprrvp4hX0xmVrr1lZbVPf0qeSfctrgEjvYG+9PDWvQSFnBt+ZGmP1TQ0kIq1T/XFdCG45IHn4wTZuh9o7gSJJeMnY/ofObCAq3RPQHZWkzD3Odw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(451199018)(6512007)(6506007)(6486002)(6666004)(8676002)(316002)(186003)(66476007)(2616005)(66946007)(4326008)(6916009)(478600001)(4744005)(41300700001)(5660300002)(7416002)(8936002)(2906002)(44832011)(66556008)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkRkMUVabExlY3huTUtWLzY5eE9xeHlqUEprRHhOVTdsUDcrT3psVVRPZmhy?=
 =?utf-8?B?MUx2V2lKTzg0Z0ZYTncvbHUzWG1COUZxc2V2Y1E4SE9nTkgwM2VWYW5jUnlq?=
 =?utf-8?B?cC9tZUV3RFNoSFNqUDdHZEpqSHpKZW5KMFpsTDNmWWJydFBBdmo3a2VzZnFy?=
 =?utf-8?B?V1VWRzc1eGdpQkwxaG1nRUhUS1VGZlhseTZDcndxY0xGS0NPZmw1OFJrajN4?=
 =?utf-8?B?S0lSQlJVZUNiOTRUUXpMcDRIK09QS0FmTDVsWngwcG0xMUp5SnNnNjZKWlZV?=
 =?utf-8?B?QjRKdEpGSTVOa00xejBsemt4S2VUOTAvL2hzUlZGTWowUHFpVStTL25QelpK?=
 =?utf-8?B?VHZwTnpHYjg3WkoyelJ3VlVYSWMyMFlkd1FPYTlqM2dkTkNBZHh6VVFmVitx?=
 =?utf-8?B?T2JGeFRDVFRkc2kxaUMzOVZkUkhZS1Y2Q3pOUTYycnBDdUsya0Q5YWQveXd3?=
 =?utf-8?B?SlBoMTNxVXBRWHBaTS9GOUhIa001YW0xb0RLTFVuOTd4TmFPYlNFMGp1ZTNN?=
 =?utf-8?B?SkxjQnQzQ3JTd3NSZFVxZU5FZFFEeVNWU1lnNGU3NGpmbUFGemtkYmRhT2VG?=
 =?utf-8?B?dG80djZkUmFOeWZqWmtBQmNwTDd4QnczZjVpRVBJMFg3K3h0anZsZVBWNXBj?=
 =?utf-8?B?YWhvYXZhOEc2Y0c3WE5qMFh5QmFXYjV1dGJEa2dKUTU3dmgvSEJVMkM4ZnNZ?=
 =?utf-8?B?eU0yaW1hbDFaVDBKakRONEF2MGEwMjR3RFJuT2ZnY2o4RjdmUzhQTGtSV0ZM?=
 =?utf-8?B?NmJ4Zi82ZWdDY3g5Yk1kUFhnbCtGUUFXU1JNbFY1YWxFNzZYTzg4cnRlcmw4?=
 =?utf-8?B?SlpTNjc0STdMMW1JTzBlcmplL05iZCtZMnFROHJ3NEovSGlRd0wrVTdkdkZZ?=
 =?utf-8?B?cVdCOWZHRDRsYmlWVHVYcmpQazBJL1pCQzNnZW5BQlR0aDZjMlMrbk04K2lM?=
 =?utf-8?B?ZkEzbnNjanl5YmlHT3hiU3MrNEpTTVFWcGpQbm9FMnpxTlhvcDJhT0hDOC9Z?=
 =?utf-8?B?Q0tnYVJ6bFlid2hqSGZWaVVsdERJeVROM2h3ZU1CSVRYZEg4VC9vemgvYWpJ?=
 =?utf-8?B?UkdFYWJzUDZMMGxaWWpxSTVYOU5XbFZZRUw4cHEzbGNQTWpVekRGRExDbE4z?=
 =?utf-8?B?K0JWRERtNVk1SkpQa0xXY0RpRlJ2OU5WaDU4VjlkRGlLcVppRUtyY2kyRkNL?=
 =?utf-8?B?T1d5UGx1M2cvTzI2cnh6bDBqc0syUjVrMkNwZGd0SVhSUmRsWVY3UWJqVTky?=
 =?utf-8?B?ZXZxS3laQnVqK3lEN0Z2Q0FjZ0dKZFpoblNrODhOc1YzT2k2SFg0cURMYlZD?=
 =?utf-8?B?VFJwbWtaNGJqZ0d0UEV4bklqV3dSMjN6MW1CZVlGUklROU8rTWdVcFBMQmRN?=
 =?utf-8?B?Znh0ZUZEYko3NzR5a0hYN05xeWlMU3FHMWFyNmNnL25VQ3VUaWNyUmIrSjBq?=
 =?utf-8?B?VUdlMWJQQjRIdmlyNWlWTFVqT1hHSzEwTG4yWnkvNVlpV2hEamsyMzVvd1VX?=
 =?utf-8?B?cDl0aWt0S0ZjcHRzVE5LcXZ4dnFtanZYTTdmeUZxUkJOaXNwdVVxWlNNb1Nm?=
 =?utf-8?B?c0RrMyt6MUwwR2FyTzcxNUhQdTBRV2xtRmYwL0ZaaVkvYmhmYmRaajJOYkFk?=
 =?utf-8?B?d3JwVkJ5VDMyMFVpZWgyZk5acnlFVExMdlh5NDJsTGRlZElvSlpFLy9TSGVk?=
 =?utf-8?B?S00wVzBjMjRDSW5XTlBwT01FZWZEemk5ODBhd1R2UWdVT0dQU0U5eHRSZVAr?=
 =?utf-8?B?Tm5odVNHWTJoMVNHT28rc1dDU1NPci9xS01VYzZwWHZxTEZlTDJwS3BuNXVI?=
 =?utf-8?B?dkVGbzZLZ3h4Mm5VMGtaVTZ5R2dxVGp4cHZRcmtQWkFOSDJsRHBla3ZOc0tG?=
 =?utf-8?B?Y1FaSkpFVVNhSElsTGgxUVN5ZGIvN3hrVTU2Um9SbUpjTTFJWWJBeVpUcWhR?=
 =?utf-8?B?V2Y4Unpmc0RYS0pCL0ZTYTNPM291aUZRZHRob2lDVVlKQXNJYjRqWUNxSkM2?=
 =?utf-8?B?RmlaRi9xRXVUTlMreEdPdGFTeGZjQUF0MnhsNWVFUGNiNVpTRVAxNVVIS3pa?=
 =?utf-8?B?MGpqVzF0TC9ueTlld2xVSXhTQ2lIaHhRN0lGMjM3RVlLeEN1WTdNUkpYYmRC?=
 =?utf-8?B?SHRyYVF0bFhKYlBZam5ldHJ4WHZTZzdkVzNHV3RjcjJuRUpBdEhCdFpOa3Vp?=
 =?utf-8?B?cXBwU0FZWlNYYTRoSWdvd1VudEFxcXoxN2hsOWlvb21yaWRReThCV0NZeWNv?=
 =?utf-8?B?T1BobTBHelZjSHJPbU82UFZ3blpnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2850d84-61f3-4d0a-84cf-08db2ac650d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:12:25.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0P1sMGuw7UgupUTUfHj1vALvTapsfUQ5FmXLUntxlKcKtwhqpMiEWC575NB6toDuZ4nlK5J5o+gHgB3YrEWtddzLPligMAVc9R0U3H144Kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5295
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 06:33:58PM +0100, Álvaro Fernández Rojas wrote:
> BCM6318 and BCM63268 SoCs require a special handling for their RGMIIs, so we
> should be able to identify them as a special BCM63xx switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

