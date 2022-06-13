Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98B548179
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiFMIEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiFMIDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:03:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA5EFCB
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drd5w4s5c4wQA8KVvwQZ8SlqJv3tvYgG2p6dxKJdYs1RF8//LcSdDbKaIMULaPubXcAcPmMVnFcRnpEbAik/wHaq3hu+lNnGR50jtd64DX3FBLj2sueu0zgKtS/mWuvKWOazCd3hgRw7kdWbjuGvIlOl2n4GXpB7ya8hxz0X123JV5tXaUbnRPabBpCmY+V1xERS+h+Ka6RGJPyZEFgVa4T9+UiBP4ayAostSWM9iOIGTL88FY5Ik4zFxYajGtqBtpmxe/ugopRj9L1DkjI+MnZ/oSV5+gX3RNHDTcdcJYB5RYbcMRRCGcAxaXfnJPVXBlCeR5fyeiLVfUoFXQK1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sajMeZvXRzkpEo4NPDnsoMQ+3vftmUfR0z/Fah4sxI=;
 b=TY1ldvxI+Lj9KAZ6WX+goff5Z20DDdlmqsaZaJXJhqlr+K1bvhY5u8jLqN8gCWxaWAaY87FiJIvxmy1/OMGvr3dSZObeqrolRdZLp4JOjFA8UcnOouR9TF+RoP6+ZqojsSK3nz+Yvh2y6qae1yy6XzcnjXui3pUyti3fdtXGt3dsBYwkEShlU/qGeA5TA/p4oRAKDGYaQHxPi8t0boE0nQhjRYbdKX3Na6ixgjyCo8Yaa+G9+afFZQMKYmMwRqkZjz/RnxoreSyLOoS0X39KpyUj139XXrqfgslEaAR/N4siUgSv8ZIopvYSBtFmADSAHBDW594GKcGBzHtgP7eqqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sajMeZvXRzkpEo4NPDnsoMQ+3vftmUfR0z/Fah4sxI=;
 b=fZCxpUXYjWtUoh1Smxgkj7EfvyST9Bki/v7tsSa3QK9z3eauOE7OarOQPJtCVqkE2Vw45wImz3jJjSqqXZ89LvcT8DDMr864izo+quRRZfYeHeDGlgExLm0pqxNSLBhglbp2wrDFm1KEBSSwrqSbd+N6XUyPETCiVHNX9Ttml18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by PH0PR03MB5765.namprd03.prod.outlook.com (2603:10b6:510:40::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 08:03:06 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%5]) with mapi id 15.20.5332.013; Mon, 13 Jun 2022
 08:03:06 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     oliver@neukum.org, ppd-posix@synaptics.com
Subject: [PATCH 0/2] DisplayLink USB-ethernet improvements.
Date:   Mon, 13 Jun 2022 10:02:33 +0200
Message-Id: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca73757b-44e2-4cd1-7769-08da4d1323a9
X-MS-TrafficTypeDiagnostic: PH0PR03MB5765:EE_
X-Microsoft-Antispam-PRVS: <PH0PR03MB57651585EC0F97C972ED008EE1AB9@PH0PR03MB5765.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLONkjBGdVvlu1IwMLnj/6nKXcjAOodbkVmMr64jVKKgeSw3jvTEJIfqDXmlTm5Ogw5V1mSDYP3nh8Sd96bIlbjknZbWAu69PpuJH0YHOV7aM1ZPD47tKcRK92dqAh0MXQ8DSTJ+R6+z7NLyuLMkq7ggnPOcs08A+dIWcTqiNriRJSYMvOQQgmD4Z4DO1Tr30xaSbodg+WBVDTxesUGlgKJdS47Mc7xttdIHWvp5+d8kRRblCvdaDxRZh6pYUTeRsPVne+q39j1MJKhF/tivGpRMrPBpa++9HZIwXtA6ZdbzHWHtXo/6ZY275y8k8XEPTRHdh/G/4jeiJxFxhfsxEUTLJ9P8uUMeNy/AN0Y+WvAMP+91af6fz7+w2RKRQwKr06KXseRcAdWb9tJXrv8O//HO7QML/7+HJwtuOjsfpBbbPpff2UUGWdn5AFYS7fiZwL9fozmEmiH8i1K70r0zwawo6P7qEPrTEDAfxIxFonfPWie2JsvPquKXet0YPgysM1aiEj7v1TpbJ/j8yiji5t6xIvYjG3k626uXsLf3Y5J0NPdHnOsQq6Zk2Wmf6ImHTcoWkGYWunfhgtJq1KaARoMBwZOFfWxDmuO9YXIs4yKLvZqlWINb/6sfzwy4Lrj3YpmjUELnGafEReUGLA71yIv8NW3TNFRzBRwOEr+6jE0gW9Ibxme8J7k2L+MivkjlnJGZsmJXpHf6YDJd6UCK5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(36756003)(316002)(83380400001)(186003)(2616005)(107886003)(1076003)(5660300002)(4744005)(6916009)(6486002)(4326008)(66946007)(8676002)(66556008)(66476007)(2906002)(6666004)(8936002)(52116002)(38350700002)(508600001)(6506007)(38100700002)(26005)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTVvcTRoSGk4dW9TU3J2N1NuNVM0VDFJVVQ1bVI2MWRNbXJUcHVnU2JEV3NE?=
 =?utf-8?B?dGxDUmFoOUxjVzU2RWI1UjlTcG1HNXhEVVRkbmNRQ3ZhRTZSSFh2dU1Lb3JF?=
 =?utf-8?B?UkRNakZKSFhVWjZ1TGlLQnNhNWNiTHhtdVBuVjBnS1BPYzZMLzZQcmFuWFdo?=
 =?utf-8?B?YlkzOWc3cmt4UkhkOVJiSmpKeEtEcVVBMnJHZE9Mb1hxVGVSVFNaYm80M1ht?=
 =?utf-8?B?dVYzMklHb2lPQmM3dGFKR1g2QlpEL2pacnl4NzgrVlFIdGJuVVB4MUVhenl6?=
 =?utf-8?B?VHg5UWtjSTVHQnVWZkN2dlh2eDhqbmRlL21ES1drVU5LMnBFQ1JpMTNzRm41?=
 =?utf-8?B?bVEzQmVrOW9UY0toZ1R5SHdsZzdmdGc4RkJJVjVERVhTTjJ3cmNWNmV3bjla?=
 =?utf-8?B?WCtjeU9OZFR6elFJNDFqY1lRc2lwdWk4SEhQTHY1UFFsWFpMbVg5RnYzYlYx?=
 =?utf-8?B?dGJIM3hwRHIwQU5xUml2QUFJV1h2S2gvN0R0YnEwaU4rTVQ0d0N0S05RdCsw?=
 =?utf-8?B?blNBR1Z1VlU2a0c1RHkyMlJhTURMTE40bHFLSTFVNXJpOVh1Tkx5TnVEWEIy?=
 =?utf-8?B?RVptZmJRMUhWRUNMbDE5UEY4UkFaKzdudXd3MzJMYWxkSWppM2pNSS9OMDRw?=
 =?utf-8?B?ME1KTXdyTmtZRG5URXF5akVIdDJiTFpBOEtnN0tSMHJwRTg4VkZrT1YvQ0FJ?=
 =?utf-8?B?QnBVWEtQNmVNR1M3ZUxoaVpVRTBhcXJRYkRhTzVHblRiZS8vM0JxUytoMFlD?=
 =?utf-8?B?a2ZLVTBOdGtleURJYUl5TEUyWmVJSzh6VmlKdjZBRUcwWXo0eDlNSFZZVXlj?=
 =?utf-8?B?WCtDV0xoanZPcUFPRllUMUdJS1FmTmltS2wyRnJRUEdkUG9CWENRODBtWmly?=
 =?utf-8?B?L2R5K3pSOUdVUS91YWFuanR5NHNtSkwvdm4ydnlxWC9DSC9xK3pCWHJzWlNR?=
 =?utf-8?B?aEdObmRLaVcxdWNUZC9uRFd6MENKRDlpcGo1MnF6dnUwdUFCNDdZc1N6TUNp?=
 =?utf-8?B?c3NsRFhWWGdZSSt4RUZ2UnFQemk0SGt3MXJFaXNKb09Vajk0bFk0c1lQdFNB?=
 =?utf-8?B?a1pWbURNTHdiTDVVRlM4ejRUYUhEdHRLbGdUQkZMMnkxRGtmdnl5amorYkRU?=
 =?utf-8?B?Ry9CWkNESmtZVzI3TnVrNzFsanU1alUyTlNqZFlVYmFPR1ZhQkNSdW5YTkwz?=
 =?utf-8?B?NGRCOUt4TVBhTXVaVHJML29HS2tBelcrVUZFM25ZNUd3RUpSMmN2YnBjK25P?=
 =?utf-8?B?SGRCUEZRRklRT2Vwdlo4SFJmMk9VZi9obUVZUlZycytQM2V3czF1ZWZCZzJZ?=
 =?utf-8?B?RUhrUlBuYVVtNm95OUZmZkc1UWZyY1hmZWFvS2RWWjRrZWZwcUEzYzd3Z3dN?=
 =?utf-8?B?Z1NUQVFCcjBZbEordWZrUE8xOStiVlNZL0lPRFJVa1Q0Y3VPU0h2VVl2cG1Q?=
 =?utf-8?B?UmRmZTdHdGFMZTFtTkR6NEg5a3d4YmhQbDYwWUsrcXB6aFM1M1B3Mkg2V2Ns?=
 =?utf-8?B?WFFNRWJlUEtEbXU2L04yeG9VTks3dDA0dFlaS2JTYVNndHF0dFlLL0hxYXJ2?=
 =?utf-8?B?OWl0MFZBOTNxM0E0Z1JMYnlYKy95TXFER01RVWdSYUF0Qy9lNnVUSUFnYSsr?=
 =?utf-8?B?aGF5V1NBV2NaRnBmZTVYQ3VvYnZoSUdCK0hMWi8vSVIwR01yNW40R1lYQU1v?=
 =?utf-8?B?U3RKa1pnc0xJT3N3bEdsQ2NxSWJ4akdKdERGRnNHOGNHbFlwS0JTNmsvdVl4?=
 =?utf-8?B?aGljSWxFbEhGdU1CS29LeU11RGFUcjdMMUFvUmZwYUVIT2VEOThLNmRQeEp1?=
 =?utf-8?B?Wmxva252TUkwTU5leno2RWI2bjFDQnM0TVV1d2ZLWDFKcjF1enM5MWZ6Z1FL?=
 =?utf-8?B?ZFBIRmN1SVZ0QkFtZThJckhiaWhMREwyZmVLRE5RaUozOWNEM2VlZHNXbXVJ?=
 =?utf-8?B?MjI1c2FWRWl0NFRBZGIxUHRod3hpcDBweFFUdisxTTdXNkZ0Z3BOR05OcWc3?=
 =?utf-8?B?QUVyREdHM0dVV2o4QUEzRjk5N24wT1ZoTGtOZkFVRGIyNUNtcG9lVStrandT?=
 =?utf-8?B?L09HWWFTVGNQY3pnYkFSZ2VXY2ROTzVyNllZRkw5R1pDQUJ1TkQrN0puNE1j?=
 =?utf-8?B?V3grdmJ1VGFNbEdBM0U2dmFDUFM2RUFhMWlVU3FRbXM5RDVXaXRLUDVUdXl5?=
 =?utf-8?B?RmEzSkQ4SUp6ZytHaVJIL0lHZ0FlNHozTXNUa0c3NWNhaTg4YmZiUk1hdVU2?=
 =?utf-8?B?aExwZmJPeFdoRTd5WHpOVk9zVSsydmVQRFFKY05QbUxtRlpDZ3dSSVdCMG8y?=
 =?utf-8?B?dzRIbVR1TEpSdDBXR0JTZlB5U2tSWVB6bjZLdVlqT3NldEdKcVljdz09?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca73757b-44e2-4cd1-7769-08da4d1323a9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 08:03:06.2995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9JXii5O6WJfajZ79GrLjBItYgPZOI9YQSX6GDkIM9i7jHGf8m1FHwi5D6K8JgRNIYI4Ku5ntK7oS0+sRiU4Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB5765
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This are two patches to cdc_ncm driver used in our DisplayLink USB docking stations.
They are independent, however both of them are improving performance and stability so it matches Windows experience.

Please take a look.
Also I want to ask for forgiveness if there is something wrong with the contribution flow.

Regards,
Łukasz Spintzyk

Software Developer at Synaptics Inc.

Dominik Czerwik (1):
  net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices

Łukasz Spintzyk (1):
  net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module parameters

 drivers/net/usb/cdc_ncm.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

-- 
2.36.1

