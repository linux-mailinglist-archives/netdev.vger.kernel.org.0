Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5506D4C6B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjDCPtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjDCPtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:49:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2125.outbound.protection.outlook.com [40.107.94.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1E4358A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:48:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3Qj2GgMRyRxIwnPs2iQ6KODGUR9veBe0Re3DuAucj0KBN6i2ppDkgR8ero3/jLJQyQARaBI6d8c0nFFnki1+OvMm8pJPDBCRev2qlZpOS1nc9yHErcHQFTcLhLGaD0DiQz9vOBR2ve8GIUYn6cX0Jp1nPrjhb2xANx4eRWkg6cctnPoiyQYO+shEpCz/m6UDz/uybHvlJc0c09VVQFP5gT7XeFgjE1/RozF2fVtsBBxXwAs8Ov/7vKD+nJg19Llw/wTJJBc3Iedd52+TPqdK993K4ndWQ5AHkdVeLmen2NvMSXzo+HFAqcqT98hbrrKKmBsgS7A/c8xFooXbXkaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bP/iuuWcXNcVtdbaEVFWAJnw6ZWzIQO8UWC+u1BPos=;
 b=cQ7i5lUKSSkM+H6J0+1GKgmlM0D7ni6f7kz9k+uTEhCHrChZtk1igDn6aOIGFnV1aOK9vHcZ74XRxQKfk5h2ax0FkNrV24W0RiWtEob4fQlg29BVD/cqE+CPDG0FFtYo4yo/9jgE4bDcWtrdyaGckTxhkCtE9ahWAaY7im6sRd/X8Puq7Yzj6EQCOHdtrWm2psJbtCHCFbWj/i/ZlWRpDobOBokTUPrV5lBkdWx1hB8KAOo/VJt+3eSMs5GpWIRT6REzifQydMTAcI4l/JpRTL/Gk1NJmYVAXiEfXGqy/IxW63IYdZspZ/+tv9TpRjv/N1FHl/BTKCVvxXUZYPRhJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bP/iuuWcXNcVtdbaEVFWAJnw6ZWzIQO8UWC+u1BPos=;
 b=LheVRuhsJzSN5AuadmteBvZjiWM0GM/CtsTCF1rWWPHPamSpWhWsuZM6JMucecet36LzVoJkpzjF6UHPF0gOXKSX6Zr1TX/IbVKC1iO0lOhNC5ajhKrxhCInH2GJADp1ru+58PGZ7bL97GhXk2Zd51MgDDfJLuZl91PLC5o8VzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5880.namprd13.prod.outlook.com (2603:10b6:303:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Mon, 3 Apr
 2023 15:48:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:48:04 +0000
Date:   Mon, 3 Apr 2023 17:47:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 03/11] net: stmmac: dwmac-qcom-ethqos: Drop an
 if with an always false condition
Message-ID: <ZCr1LXCiaJoImjmJ@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-4-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-4-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM4PR0302CA0021.eurprd03.prod.outlook.com
 (2603:10a6:205:2::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b977b9-3d33-4fe8-4972-08db345ad017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/jYzplNpE4oPBbxwqDWRV/uUXZ1zn0MF3qe78gtxIGx6EuuegL2rarkGxQLCmPvTVGfdZQk7UIWyePcHtqWs7t3Eq6jDfk2j4zU5+A/RNUfTmLTCmNkZd6hoGnZGnSHbncP9nucbmBQq+/XdRANn0Hf8bf8a+fJSRqP6MunbTzoTzNulViUfEDlNNOgegrZrUoegGbLIxrYqR3ACRygLCLlYUXnWWZKohla6CC0vS41C17tb3Ztzil+jWLPrSXPTCHGyG5EhZ4wH3wZhqUQl1shCzsbzbInhzeSIKmXxpoH6ytl6Qg3mYZDXNP/bnd+OJbfDaI0wTDl14C8ZCfZ53GenILySqolI1cODGpaSmcgfdCS5zoYNTyQmfIN8CcxLvi4C4xKZFI+D0QZJdtb1iBOByxxlMEyrOTb9AiMDGiz+lwme4AMdvJYhrli/oh3jvAZMIVmhgxyvUWpjRWofHoJP+uMCoQYD1GkhOWmeo17m/WZ2/a7ut2XmhU6ilGuLUAGvbRS+ksR/4hPAPU6vlK1YKA1yI7D1VTpzK0lR9hi7AU7x36zHfOtb1Sdq7dXFGDp+mmUf3vT0Mk5unF8VAe7DBQgMrPV6ruHd5yyFAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39840400004)(346002)(136003)(451199021)(36756003)(8676002)(66476007)(66556008)(6486002)(4326008)(316002)(66946007)(54906003)(6916009)(478600001)(5660300002)(8936002)(41300700001)(2906002)(7416002)(4744005)(44832011)(86362001)(2616005)(186003)(6666004)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFE3SnUrRVJVUFo4bSticjUzR0tGMzFnQlFFbnFxeDdMcEcwRDVPcGFqMUVY?=
 =?utf-8?B?RXdhTWV5bytoVGhWQ205SUQyc2Q5aHpVYkR2VDVDYzc1dTk5eTYzeEJVTHRN?=
 =?utf-8?B?MzNmUHd0TjgzRUlRalpQYjhxeER1RE9CYksyVC9LVjR5VFFiMmRDV2MvRXBm?=
 =?utf-8?B?QjltS1c4UmNVL3pqY25XTktaZGk1ajl3Z2JnaUY3RWVhNm5CbEpybHVWUlhN?=
 =?utf-8?B?ZENyekZMNWROY2E3S2NlalRRM3YzczE0dHpSRmV2OWRFdEJxSjNpdUF6bGRw?=
 =?utf-8?B?YmpFK1lWdUx0Z2tMc0MvcUk2N08vaFNqSXdjZ1ZZeGx6K25JZUlRbllseHl6?=
 =?utf-8?B?NHVBdjlNMVpBVFJIKzZFdWFpTkk4ZGpNUmdKQVUxQmhuLzBEZWp0YUpDdDY2?=
 =?utf-8?B?Z211WjdJbGh4VktycTNBQTZESWxLWVFrVnAzTGVIQ1dhanNkZHBjazlBUUhs?=
 =?utf-8?B?UmtQampoeUtrR0h3dW5ncUFBYSt4SERjUzQ2dVRuWGZkdW5IWVpiTWIxM243?=
 =?utf-8?B?UHFzY1l6NmxIL2hiVjFFQThiRHV3dEhZcWlMR3dxTmthbFhMajVtTzdvcysx?=
 =?utf-8?B?UGp2WmVJQXFMTEVRbG9oRDlTaElNZmpRYUlnUHpsbEJQWE1OUThLUjk5S29u?=
 =?utf-8?B?Z21PanBSQXFna0locjJ3aU53UGpyQVJOaDZ1ZmpsSW1LV1VwNHBQaHQvTEtB?=
 =?utf-8?B?ckRCcGJWL0dsVEJjSDBaTVBiVU9sWVJ6Vm5qRitVNEZYZ0R3eXBMOFR4VVA2?=
 =?utf-8?B?QWxhM0thd29aOThNNmtwWGlLVlQ5cnB2V0VYMHlHcFFDOEJJRVd0MzRiK2Q5?=
 =?utf-8?B?YXZZVVBmb09hMG9STXdVSFlTWkh5aWdWMWwvVXBlcGNzV29aWERpY2ZRamRt?=
 =?utf-8?B?TlQ2Mlk2L3kyMDN3TEhvc1VZSjR0MTFPYzV4NkYyaHBOeHVRenFYZGRKV1VO?=
 =?utf-8?B?NDJtbGlLclN3YmpZdXBGZU9NaDU5YnFnVnhtQUFSWUV6djNMZ1B2UFFyZnMv?=
 =?utf-8?B?TmNIYngxODB6Qklsdi8zU0dkeG5aMTBCK1lUZ0k2anlSQitLVzI2SGs1ejFJ?=
 =?utf-8?B?YW1Qbm5UZG5HOVh0dEZmSDc2MUlLWFJiaGl5SXVnUlQvMDdTVWd6bjI2ZE5Z?=
 =?utf-8?B?NXpaaDRFV0VOd29RVzNoZGloSGd4VFlLS1R3VnJ3MFhZZzAyNjdOOFdFSm9D?=
 =?utf-8?B?MlZ4YlpxVkNoR0lQQWQreFcwZ1l0VytrdVNFaUtaaHVCUHErSStHUXdtNGJX?=
 =?utf-8?B?OFNHR1Q1aXhvaFVkaFBEVVBWYXYwTVVTZzQvaUJ3eFJLazRWMXlUMzc1WU9v?=
 =?utf-8?B?dWRZL25na3BVY2xOQ1pBREJsVWUxQTNsZVRsM1A0Uno1MWR3dlUxckZGTys0?=
 =?utf-8?B?SENGMTllcUU3SEl4OW00d0t5QlhuMS9yM0tSLzgzNGJQelYxUU50VEJmTk44?=
 =?utf-8?B?R0lVaGV3djFDeHo3U3c5bytkdllhRkxraUJxc09ERjV5Z0wyK2YxK3hmNFFv?=
 =?utf-8?B?UTRkVjBBcWhMV3UrNWJDS2EwQ2F1MzBEdW5uVmFBcXhkdG5CeS9KeE5mZjVK?=
 =?utf-8?B?REVDZDYyZ1pzS1Y1SWUzcmJYN1p2MEpydFIxWm1veTRBazBQZ1h3OGpEWjZr?=
 =?utf-8?B?TzVCTWxORzNyMCttYkxGandkYVBQVUhrcllVWXFQU0Y2RmZoUHZOVlFxRFFl?=
 =?utf-8?B?ZWp6YUtMQ3NuM1RRSlk3M29oNDl5VkFXZzRZek1taXd1UzA3OTFpS1hZZ0Zt?=
 =?utf-8?B?TkJHUzRsTWt2U2JybG9FMnhjVFdscnYrVjFJWjdiTTV6cHI0REttNEtmeXBr?=
 =?utf-8?B?aTFrVHRkeXlLTXVPT0Y4aDdXWUY5cEQvSlluYStlV3BzRTYyU2ZETkNHREox?=
 =?utf-8?B?RjFSa2ZwVXAwZ0JmUCtjRzNKZkdHRUNqdU5PcWpFbmxMa0hpNnFlTTE4NjYv?=
 =?utf-8?B?OFdsejhRanR4bzNPY0pvWlAxL0xXYVFFdmJmd3phNnJUT3p4dHNaTUhNaDgr?=
 =?utf-8?B?dHliRmI3OEtVV09ZQ29CZ3MrVUVHOFBHMUo5aWxPQ1JGS2lZci8xc01DMjIx?=
 =?utf-8?B?Y0tyNGR5ZlNZNXUrRXpBcUsyTnM4bTFYRFdJWk5DVkhuSVNnRzRFVjFHS2xG?=
 =?utf-8?B?cTUxTFBDa1JaTnYwSi9qelIyRTROVUdoZlVjaTRrZlFMcjBiOHM5V2Rkb0Jj?=
 =?utf-8?B?RVRsdXhId3FzaEdjbG5XbXNyeXhTS3lkSUY3UEx6VWprdmRNdW10NEhBWnZ3?=
 =?utf-8?B?WGwwbXA5Y2F0WGg3ZFkwWDZCbXJ3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b977b9-3d33-4fe8-4972-08db345ad017
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:48:04.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVERzCDBaIb0V5T9fJHYydJET+w+1ZoGAwi9BKuM5TUyAkfW697UYByD5cawsT87JshUbxVTFpd28xGZ3NCqdHJM2u4xe2nUCPOilZ409fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5880
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:17PM +0200, Uwe Kleine-König wrote:
> The remove callback is only ever called after .probe() returned
> successfully. After that get_stmmac_bsp_priv() always return non-NULL.
> 
> Side note: The early exit would also be a bug because the return value
> of qcom_ethqos_remove() is ignored by the device core and the device is
> unbound unconditionally. So exiting early resulted in a dangerous
> resource leak as all devm allocated resources (some memory and the
> register mappings) are freed but the network device stays around.  Using
> the network device afterwards probably oopses.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>


Reviewed-by: Simon Horman <simon.horman@corigine.com>

