Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A44D31F191
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 22:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhBRVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 16:10:13 -0500
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:21735
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhBRVKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 16:10:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8XKEPCGSh3i63CyKL5qQH09tiIE096jSiWaNF3Zrwbz1genly46urfTVDvCUgP0RTVA8gPr7v89qzyQqUtRK+EgaPoDxJnd982WZsPuzYhfLlHWTpBXMh3jMRFZ0dNR2azBoRHSb9bBf+4Hgl/jzNPXPYg/KT92NBcNkK2hU/VHT+rOHH0e1B4ShcmMcuimSNPHzIi6ya/55AMxZ788uQADa1x7iEU7smPtlFIaFL8qAMrzkdU5TVLv8PIkzhkbR2RrqBNm1oImpvC1MNYWfMeQUBqrp0IvH0ic8MhS01t8MiFgWDhn2oHf/hFzcCnPIn9y2ecqe7NkffDfonmoaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkdTlMFe4y1aRSoIOb+stnA9j3rGMmf3hJmT8Tn1CoE=;
 b=iAlrPw0WUqwtXVHpMA0ntstwGtr73EY0lNB6NaaoFRibi18N5gVMy9Todpk8p0C1dHK28uReEDHgsrtGZ6Z9xhgYEbP6nEM/HwvXVI8vU7ZM9BHguD1oe2TN0aOWE5Tg7IigCVRoEsOVTJQj6lp4vetou+LFX3LFvta1BA6fmjk+nYvvMj41OkNC+DxSzQzP0vqyA70bLz2UzjjONJeumhrXcGrcTyr/4JHeL9F2mg89W9P7qoJohsNln5m43dOrGJcB+JmQ2MXflxJQP9Qv4vvFqm8gAEWGCc/mA46bCQDValo3GxcTkkatR+CgpKBIpw/Cf4US+msDJWfL7CRejQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t2data.com; dmarc=pass action=none header.from=t2data.com;
 dkim=pass header.d=t2data.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=t2datacom.onmicrosoft.com; s=selector1-t2datacom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkdTlMFe4y1aRSoIOb+stnA9j3rGMmf3hJmT8Tn1CoE=;
 b=V/oE7d2vQGewnYEqpg7tccXDMteyCcBlY7y51r5ajlkFNQeNl1ESQ6jx0S+Fjk9NzC+a3umOzvloUO/t30JdTX/qg9XXfCWfnhciEDZr0D0FQrptalN2g001DwPcm/D4badJk0ct38nT8yaVZvywQKVZVKGjjdcyayuWa2hDWaA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=t2data.com;
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
 by HE1PR0602MB3289.eurprd06.prod.outlook.com (2603:10a6:7:17::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 21:09:15 +0000
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb]) by HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb%8]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 21:09:15 +0000
Reply-To: christian.melki@t2data.com
To:     netdev@vger.kernel.org
From:   Christian Melki <christian.melki@t2data.com>
Subject: [PATCH net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <5eb8b25e-f646-ed3d-8572-9b6ef318ae9e@t2data.com>
Date:   Thu, 18 Feb 2021 22:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.234.39.46]
X-ClientProxiedBy: HE1PR09CA0061.eurprd09.prod.outlook.com
 (2603:10a6:7:3c::29) To HE1PR0602MB2858.eurprd06.prod.outlook.com
 (2603:10a6:3:da::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.7.217] (81.234.39.46) by HE1PR09CA0061.eurprd09.prod.outlook.com (2603:10a6:7:3c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 21:09:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871c3549-e65f-4349-c134-08d8d451726e
X-MS-TrafficTypeDiagnostic: HE1PR0602MB3289:
X-Microsoft-Antispam-PRVS: <HE1PR0602MB3289ED62E3D304F3E26C67A2DA859@HE1PR0602MB3289.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IAxXUFdzv4OG9EJBBMKu/iSW1k7PyR9fup0V+pBnYlysgIssGIjEeunFWE/XnlweYEepK8EiWhYQTBjm4JNNzzhFluW79MqYYwPQAGEVLvOaqM/wVUAmd23QMGz1N1u+WMiW6zOV4zhDaWoSbW+vcE8FShxL+SInUowFxFX3VZBhFyekAZ8ArnO8XIV9lMj9amWZnVps5Zb38HNZ3ZiDawtV1eGu5EC1907jIkGAEU2R6nDok3bZCo1AGGUXNo+ARqYHXoxOvyCjVsEOeV28ct53wLY8Oe7Fk3Bl+NEeq3nGERXRfSBcwAC6StVWPoTZ0aaoOT11vm5bhX7piUPZdKydWy+y6pAkPXni7K1QPAoodkF/mY8QTjRi/iOtEIn729ITOGh/u9Xu69XumU3K5LEeLYgZxPzCUjx5t5T9X/QExPYkdS+yfgS2kh0VO60RgOGFFO2PiKOlHmLinAHsdGl+VbPGid+VAqOJ/jajXpAFNJIDac2+aIs+LiOkjw9VAJEYYgTlZERHsvDH3wnvM5sKh0M0LQzpiXk5o6HAbfWBBUrkLESHEbGl+MEPM9leFYmywDh3YAIWnkAYyVOPtHtuu3lkfxgNxZrJc6uF5YY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB2858.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39830400003)(396003)(136003)(366004)(42606007)(16576012)(8676002)(478600001)(31686004)(36756003)(5660300002)(2906002)(8936002)(66556008)(6916009)(186003)(66946007)(6486002)(44832011)(3450700001)(2616005)(956004)(66476007)(6666004)(26005)(52116002)(31696002)(316002)(86362001)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THRnd2JHVUF1V3drNHEwenFOQVpEblVlNnlvd2diQUFzaFB2QWhOL085UVhI?=
 =?utf-8?B?d3Zzb2RkT0grYnVmU2RDZFpMQnlRQ3dRRkhNVEd0SHFwUnFiTjV0RFhqWGhU?=
 =?utf-8?B?MWpqWHNXUGY2SjM2empYRlpwTUhRZ0JvTTBOVXgzcHozNDg1NnpTNzRCa3RO?=
 =?utf-8?B?NktVZUl3WkYrZ2JMT1JCUVZ0UC9rZWNMSURVOGJ3d2JnUERKSlN3b0hlM3Mx?=
 =?utf-8?B?NjlGSWVKSFdveVJrWHJIOVB2SStPMVlnWHRZbVpRWXFid1cyTUNadzRBdC9Z?=
 =?utf-8?B?QTFINkVCc0d3RGo3OU1ieXZxbHM5d29QQTNVUmJWdndLNG1rRTJGMGwvS09L?=
 =?utf-8?B?eXNSQm56SjdOWFJNck10SGU0d0pmWG9wMHI2ZElETUZFemhVQkJ0dG1VcWpz?=
 =?utf-8?B?dXUzZ1FGWDZrQ0M0VFhValhJUnprNzZrMjNJVHgyRDlqTzBKVktkWTJxdlVn?=
 =?utf-8?B?amtpN25LTmNsMnA5eWk3VDU0UHBLUm5uUWYyZDVidmhWeWFhUFZhYUR3clFn?=
 =?utf-8?B?b3liMVk2OUVldkl0VU5sYllzd0FBcDdLSlFlL3RZSklYSHlqK1NaVXM1cTF0?=
 =?utf-8?B?QUhnNkk2WUhSZk50TDM4ays0Vkw1NkozMWJuWlFDTWowbjJLaDJ4ckZFS2Ni?=
 =?utf-8?B?eHd1NlJaNXI4cWpsL012NnFrdmEwNTRtSkhzYUt0VWFkcW9VMXQreTBlRDZX?=
 =?utf-8?B?KzZNRFRmQURqdE1odGZ4eldibGtaVzJGY2xmY2RMSWxEUTFWeGphbjRFa25r?=
 =?utf-8?B?djAyT0xHL2Q0MC9RTmh2RnR6SWV0RXBQQnBJcGFiWXVpZzZnRHVxWkZ6MUFI?=
 =?utf-8?B?WXZzQ3pKZlo4c1NhYW16RnZyRTlnSTdzZEpQQkM4cFlyTERmc0tYWE0xSFdT?=
 =?utf-8?B?WHVpL05qMHlVV0gwOWs2VTVjdFpjYVo4YVN6ckVSNUw3eUl4ZFJVS1UyZFVh?=
 =?utf-8?B?R0dqVCtrYU5NRHplMWRManVYN054MithcE5BcGxlNDltNG5WbGpVYk5ZM0J4?=
 =?utf-8?B?TnA0UTNCandqeXpoREZSalVVWlBNOGN2YmtCUHF0bG1vd2N0TlBLWENxOExM?=
 =?utf-8?B?QlFSeTYvQ3JGTEpyS1ZZZ2hiMkFFRk9zT0xQdDd2a2x3Q01uek02Nyt0K0dE?=
 =?utf-8?B?L3dodWduOHRZNFg1ZUlicnRpa0EzVE15RDUrdzRYR2VYanFDMzQ0Q1Bxb3Js?=
 =?utf-8?B?WCt3bm1YdzN5bzZWTDVtZTRmbmJPWEhGTVZvY0xKbnhBZ1NPRHNpc1phWVhl?=
 =?utf-8?B?K2VyRVlJVmNXSjVCL3A5UXZBNHRuTzlCWDBTR2h4dStzZm5lL09iSVJDUzQv?=
 =?utf-8?B?WGVFMWtRUEZmZEptSWpQYVlVK0VidUszVlFaYXhTcTAzSnNOYkhWUjU4S2xX?=
 =?utf-8?B?VGY0d1JaWW0wYWQybm1IT1ZqQUQ1WlJBVSsyTmVkUTZZZGlRYnpsYVExemtW?=
 =?utf-8?B?cXd5OWhTbXF2cVFHSFZjaW9qd0w5TTRqNzdKaVphcVp3cCsxOHhiYWVjRi9l?=
 =?utf-8?B?Si85VWlOUUxEYkhUdVdOTzhid0JUWnh3eHd6bWlPb2xYVGk2WjBhbDV4YWJ2?=
 =?utf-8?B?YUZOOU5HdDRveVY1WEtPbUlyZklKV2JXS3pkVVEvZ2QvMEdjQ2JZTG5XRyt5?=
 =?utf-8?B?TW56NVhMbjhmd2JLV1hLaE83dnViVHhvVTlIdjRPYlBFakxqZXpFNVlFcXdX?=
 =?utf-8?B?SFBDQzlRT0k3Um4yS2ZmMFF5dDRJVWZobzE2R25CSEtMWkZ4YWF3bHRFblVi?=
 =?utf-8?Q?LQH6ktVpN+FaeDAc34FKuAJbIGMn3kAu9v9vYMF?=
X-OriginatorOrg: t2data.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871c3549-e65f-4349-c134-08d8d451726e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB2858.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 21:09:15.1175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 27928da5-aacd-4ba1-9566-c748a6863e6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3Cgc3FhUjlqANKTwFSy7aDBOys7zfniAMoTcrKAJjeja2u889mOuUi5PyQbALxrDozafOreRINMO1Qy+9XESwdiaWwYsIjUUbVADbpj/vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3289
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not 
implement a .soft_reset.

Bluntly removing that default may expose a lot of situations where 
various PHYs/board implementations won't recover on various changes.
Like with implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if 
it did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
---
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..57f8021b70af 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1295,6 +1295,7 @@ static struct phy_driver ksphy_driver[] = {
  	.driver_data	= &ksz8081_type,
  	.probe		= kszphy_probe,
  	.config_init	= ksz8081_config_init,
+	.soft_reset	= genphy_soft_reset,
  	.config_intr	= kszphy_config_intr,
  	.handle_interrupt = kszphy_handle_interrupt,
  	.get_sset_count = kszphy_get_sset_count,
