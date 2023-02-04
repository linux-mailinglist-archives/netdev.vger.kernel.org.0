Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468C168A9D7
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjBDMz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbjBDMzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:55:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2090.outbound.protection.outlook.com [40.107.220.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C7D25BB9;
        Sat,  4 Feb 2023 04:55:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuGjclAIoJjTdpxFMJX8yduq73j4mPyxrQw5tN0FHSxANh0lI0z2WntByxLdf4Q3DBhwmnIdH8myvr5aRbU8hLXJo2ftiO44OcYZ3RIpfuzSl16JlUUEqMvSF4O9QzLPXUvNztndF5vMWsZjXfF7imB7Fd6ni6CHYcmBLXSV5tB7yZKnVhTtmKaXMsIgkOJv5+KNx13ek2Ng62QIfyU/Sdwkfdtn+Rm7jC2xBGE9hqVeW7XD3AA/6uDIMfv83E3E38vZiF7f54LXPxJ5rtE+w51b87hniFD2RQfkmldDI2SImXJW1qxsv5m7IR39VcrH1Uq6zovgV4VUN0ehRO0I7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INt19Obkdel3AZ2+RqMXLoGh5keuIn3cVjPI1bQ6ngc=;
 b=EOQ2A3uH64XuYzcyvEEnxab57dvBjSgz9Pd9YUKq/EpyKXWUA0LQaGq9KJ2t6QTy8+a9fP9rm6atLInzk2o6SVqo5lZPwGONpRQ9p7vkwquOWKG9ED22YSEXCLuvJ1uMAWCQyP6F0xx1PiusjFabPX/yI+vxCrJGBEFFjbk7rbAMulWde+FgD3Ug1rynADCrDj827NVHIIycEDjUb3CRnPR5ea6UhPM1o+IrjSithaoQfJXZah1J9TxAfu/BbQQ68oHZ04Xxh8BTP5ABh+0DBOJvjhrWfX8v2zym0lxekMFaPgOsBpgJxmTq4vvkML4gu87QRhKcAVTaxat7ax8NEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INt19Obkdel3AZ2+RqMXLoGh5keuIn3cVjPI1bQ6ngc=;
 b=ZIBPgGmoUNtidUCvnoEd/i5TiGiLEFG26aEEdVZFInTKZhGk+yHT4UhT338uSUJ9K+ebMWHhJ8saeQoCk0HyM5N0Eidi3SlE49dVj294OdTZmpjGMNorszlnfUER0ACeEW9QSbB5LrKioXSlAR2PdEN36VKGM9PmIX0BxPLwEwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4675.namprd13.prod.outlook.com (2603:10b6:208:321::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:55:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:55:52 +0000
Date:   Sat, 4 Feb 2023 13:55:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 06/10] net: microchip: sparx5: add function for
 calculating PTP basetime
Message-ID: <Y95V0dPC7J46TFWX@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-7-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-7-daniel.machon@microchip.com>
X-ClientProxiedBy: AM3PR05CA0141.eurprd05.prod.outlook.com
 (2603:10a6:207:3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c0cd143-498f-4899-4a62-08db06af25ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfWP/zSrTefUzbGfoaoRfJIWJ2r3WO/jq3a7c3freLLsKptNnqJJ2ZEFPXeFjWPXuBd5xWH+wBXkmZrkKtfnG5hkc7uX9Pav+FLctWbq3WVvHwnndFqRjyNKsXgxsELe1L/Ff8WnKe9PcvPEGNd1lXWEKKIGJV1wEjHokYZN1r8n8xq7FELWd9Ype3il7/oYiI1l9tOsbPdBI3MV3l/ikTKBopp4MSebY/d/zEg0tPIyfQ+YjchwR22DRgLjMzyXwftXSkfnfbBazs8Cra8WtfDq/UHqV5Ro+k7hi79b/Ws+IphJQi05h7p+FjNQkqIY69AgMAMz2UeFasY5dE5ta/xM43/oVNkm2+LaYVV4jBJkra5pKpFzvbx1ccU0Z3VUxFN+aUwlX4JDvGPuHhBCdUTLoSFoWpBkWEKJHnHJV9UHWFa+PtqNHKg3StpgIel4YJWmbcqBG0xKDMYEOooAWiLXcCihNd3OnCGCk56lE3uDWBqG3kCldnJsT3K3AF+Ym2LJI/OKHUHF3aq9pURpq4nTb6fdg0XDCO6hnnEy7NjwyGEMICmUYq9+osYob59eByey1gwZugWRz6Y4b73mIU2xkSXstD9ucSAojiiyj7hL+sSVqrHBkkBe+jVOK36/4tsk+3IbajHAyAxZFmi1cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199018)(316002)(8676002)(66556008)(66946007)(6916009)(4326008)(5660300002)(41300700001)(8936002)(66476007)(36756003)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(44832011)(2906002)(4744005)(83380400001)(7416002)(2616005)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKVPye3MDLlH/D5z3CSl/HFYhXdcijcIGlaUNuvkzzCIsD+7LqfxYXNq4vZM?=
 =?us-ascii?Q?vi49vn9L1cW6RjxYIYqt8iEyaDCgBJJke6R1mInChIKcMV19cFYvWRYQd55q?=
 =?us-ascii?Q?bV2/i4HDLvfqWhn7FeCiA7ER2clJg3wfF2NJ6ycHCfI7L4c0eW4DAakM0eXu?=
 =?us-ascii?Q?hCfTQjmN03hKyvB6YeTNPugjSI0O5k3epUQ+SsmV2qtuyDJslpcXWbIWsGVv?=
 =?us-ascii?Q?Y6ELigjEuwLY/C2oK2zXI3asRIX9H2lx7jvK/NT54H4ya3YeJ5K34R5AGzKI?=
 =?us-ascii?Q?11WT5O8N6A9eYBjVVZ1rIrBLwxEEOY+z5sxOuboY1NABOvadeEgeCZLHCES6?=
 =?us-ascii?Q?kpFZPTGbCMn0Y/Hhk8FACfc2nu8PiUDeFu58GQaUHaAeZcRVrzDySIzbyImD?=
 =?us-ascii?Q?rBHMtRzMkLaO1Po2s8hWywOu96ZBkaxicH0soW9pogif9ZAmnn9xhsQSkX0B?=
 =?us-ascii?Q?Yfv2j4Ce7FOUttxuA3TKVZPfmQzDNMzL3gBfiYTh1sfYFH0pleeD2tilk4yT?=
 =?us-ascii?Q?mP4iO7d9j930vFw/9jumPTQYaS+pXKLasVAUZ84h5FnhHcx9kIa/B/rMnpMu?=
 =?us-ascii?Q?Eqt53CG2WmKQRuKAAbhB7Uohldi9iEZTAKRH+f6t0xoN13J4WP9gaLMRR75V?=
 =?us-ascii?Q?P/SEwUbTWUUVxzfhW+5d+L3LOUrNqcjL/iFwhGyhxUlxLfkvvpdOsBcSHc9s?=
 =?us-ascii?Q?6MupL9KSPNoMzTzr1KBQ6eetbLjGC9Jf+B4N0HrCLQ/+WnrfG9daGITFiemJ?=
 =?us-ascii?Q?iowppFQt5qKK43Qb4G3ElP7sVL7zw9r3OepcUEq6rvMrn2A5sGAZTrQ2DLj1?=
 =?us-ascii?Q?kS4/Gy6cpeYlf2rw1CJ2etH6BqoocY5rWYYZcgyUlPX+sw+UQTe1glKqrlF3?=
 =?us-ascii?Q?ZXs3vbwAGz1pkiiQcglkExI1XSl6jLFoexU2UquNPtOgHT32rkg22WcEttEh?=
 =?us-ascii?Q?RP476tLuhk+gpsvaI5pUKFNvnsiD8yaFn73YJf4I1zENBuc8vo5x2VQRywck?=
 =?us-ascii?Q?gwr9wWuBwJczVQm4Lug4zTZITyJNsEU1f/uKtSnKQ7xuV1YKDJo/xHTShTWh?=
 =?us-ascii?Q?HH39XfdxDwdZ/TRwexgzm1qWdjekqr/nvZasGpEYE3KHmBnIHtOyG5svz1So?=
 =?us-ascii?Q?U4zdEzKIM0t1zPu7XLgKDRhYx8TR8LmVuEm6af6ZLmA60+bVh+N7I8Lmbl2s?=
 =?us-ascii?Q?RvZ7D9/OvYGuWuc3L76gwz2mT0OcBbpcIEuL4YLHZxMQaMqhlfBJct8Hb0G0?=
 =?us-ascii?Q?wFZ8kxmTp+baXcgmBJ1+Myij+ix1RvgB66RE7CiOb62VnA9q5Kmx8kFIPUnq?=
 =?us-ascii?Q?ZyGus3f9YNYfkv2ARa/pB+HAA95ly8qmsThRgUBsr1XeL/vecwFc+FOCYRgj?=
 =?us-ascii?Q?/o6Vv4KnKVR3bae9rxrDnZ6Jde3/3+wihC7xHvpzyyIQ89kQ0e7z4bkYtcLV?=
 =?us-ascii?Q?fYHqXvX8/YCquTxoNNQ/+IuBod2r4n7X3JY+sOH6pGzoOsovHHEf+qE4jnWM?=
 =?us-ascii?Q?SOxNWmuSWPYyUG91RrNMe2F8zTW8tnmyQTxUgKH5BxW3BtmXA7pQPWiw6oV0?=
 =?us-ascii?Q?d7SBiY5puFsoVwN4r/eEJ8phTY0J5/GtWQdhQ2jofR2Xlf86+f2sQE0a+mqK?=
 =?us-ascii?Q?E3+1nCpWyl5RyKObj5C152Njh2RurA0IC0sm/oZoTPJFef12XN5jIrbWm50o?=
 =?us-ascii?Q?7zbz6A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0cd143-498f-4899-4a62-08db06af25ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:55:52.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+4rtfJUu21QgXPrPJsrv+V7vpb+77rcs8YK2gC9Ol8ZGvWWn/fww/oWHdnJRvhUm2ATKcrg50fOycxcZ8uKl9h6m4yXdTkG0atK7Z2aHq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:51AM +0100, Daniel Machon wrote:
> Add a new function for calculating PTP basetime, required by the stream
> gate scheduler to calculate gate state (open / close).
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
