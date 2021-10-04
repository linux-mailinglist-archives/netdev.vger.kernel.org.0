Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47808421A79
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhJDXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:11:49 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:54658
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233517AbhJDXLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 19:11:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR70ipO9UD/+lZDFu0Wzl7KFAPP/ziC+DLlDxJwr/feA4ncUEpZ+W5mM7aPZGIQ3wgJ7Woyr8RJd5O0Sl2wA4iFvrNozSBJyGQ9uDkIOITKbzt3Is3KLu84WDX6RHLUe30zJMv1R2n5Jc0eO5DG7D49LEE3Ui/MkeX3YwPQeqQPW0lYnE0o0HLBpaWQdyJd5+jywpQZ0XiYQBwZZGOI5vIqPZ8q/KzRdShoMJL+xT110DWec/iWhAHFwbXr0lB6ZpX0l2Pdmxu1Lw2H0a0mLFnQT9vuGR8fpX+Rq7bRisYHpiyVX5/aaFz1QMMWTkRlEGnQBLZmiDf1QJkifyYlclA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JfzmUxh6ji2jnl6YzXl0inhN3hpR7ySyxG6Hxn8FGs=;
 b=nd/H4jXop3n9hGh5W0tWfw9FI2YSAg+C0tWVwScCdwL20lGgdNZ6maR9Qh01UtV9A/iALDju/+NJ3U0ngQZscC9ixTGrViScvVZ3b58MF7XukEixNd/3vltcRO+Vz19qGJ0dg+iSoOD4d5SmyM3QEjmcBejwiwOd7sqI19dA6PIEnnvAUqQ4AfXrddQ20az7yM84jC0xDBNdFoJ2RI2P07l2x79EwGGyS9wAWA5Gj6Zqyn5Ai16PnBrN+eYT8SwyXOLzAovtG3INo8djmcSGtsU2JZZqVFWtjwYq8JhmHVkGhdqv9/5hzWCrALAtbPQqevhICzuqZpgXCeGcQrkUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JfzmUxh6ji2jnl6YzXl0inhN3hpR7ySyxG6Hxn8FGs=;
 b=NPMDCi62s0+YTb46E2a52eDJ/BCcNmzEY4ehQLvoERRS0TzIt85ybVNd7eHVYBS4Fuzf/LXG7DPvnrpv2An80ocTDag71nLe7siyN3YDekIlCyrlUE73HH5IxkzVFfgwL+xxJzcf0m81MSsFKinJIIjdv4FhVm+ZbJXSnFwt0ps=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR03MB3046.eurprd03.prod.outlook.com (2603:10a6:6:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 23:09:55 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 23:09:55 +0000
Subject: Re: [RFC net-next PATCH 09/16] net: macb: Move most of mac_prepare to
 mac_config
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-10-sean.anderson@seco.com>
 <YVuIvHZ6+AHvGPoe@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2b87ce05-4c10-3644-0df8-fc7b47d74e50@seco.com>
Date:   Mon, 4 Oct 2021 19:09:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVuIvHZ6+AHvGPoe@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:23a::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR03CA0009.namprd03.prod.outlook.com (2603:10b6:208:23a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Mon, 4 Oct 2021 23:09:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 814d4df7-89d5-4ffa-c6c0-08d9878c143c
X-MS-TrafficTypeDiagnostic: DB6PR03MB3046:
X-Microsoft-Antispam-PRVS: <DB6PR03MB3046FE63EB10664BB68B4A6296AE9@DB6PR03MB3046.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnSNHK//tbmP6IDywsVFq2UCqOXeH/9pqWy22qsdb1PY7kp0MZn/vIUIMRo1nAmiKbz5nYQNEmJYxgu3Xf3Djnx1qRNg1+7Hs7HKTkbLq7FXo3TS/kDST3xweSrfi7IMCKAAa7hvu0GTZ8fd/KhTUo7IYVhrGMb/wDE1TEP4pdmhO43sgidTolRCGX+HP9nQpma6nLb7fwBD9YD/U1UlisabIfMOl0Zgy/iH8qIJs3XsT57iFmb4JPD4cCTXv+HwARPDCk/W5At/rFOtoK5wpjtb70/GCSAbBlZ+BDQluR8vljJxGQVTO8EEYmCQKq/o8/ej8cQ5LA3al5TNHd/LDwGJXnYniFEGlTs5wt4cBff1yE3er6YlUaxavRIK1mjCtV1gma7HM6YOZ7RzhM0wOrgNPo2uJtvZoIcqiC1Q+swhOVSxmGSupnjQgfS4ZCgCITjvyumDEzM7OUZ95A3eHN9o8Dc29aB5+LU/N7CXW9yzXaDhhWcy1hu5Z9IbzGM11JMjUsw1Xu3HaMyTtIxSh/1fUDi+HFc3Oh01bUpMzMiOcSgnNEr2GusS7Bu8+zvBa3GSIb+mXP/5YRTnWFioiI89SISGw1xxORCKNclV8mQVZn2UNgNwAiasVpEizN6ZI+UNKry0uhPfHeVo4XeE8h/P4ic7cxbypmtQxUBhvBbhc0qqdeKo5qEhodZZ6npmpuCTBOd+GWCgiDN+0U2VWb9+F/n/eB1Orbe15+3BeZ1ieoly25sGF+rgen73YpZVYwc3tO/ECYHKSHQQIIQAeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(186003)(6916009)(44832011)(38350700002)(8936002)(38100700002)(31696002)(53546011)(2906002)(2616005)(52116002)(5660300002)(4744005)(26005)(4326008)(86362001)(66946007)(8676002)(66476007)(66556008)(316002)(6486002)(16576012)(54906003)(508600001)(31686004)(36756003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEFQMW02Qm5mSU9kaEwycm1MbEdEa3RNUGJSYVBsd1VJNXRWYXBRYzRxMy9H?=
 =?utf-8?B?VnNsSmRSZTJYQS9tOE5BZ0g0bWNSWXJkcENybG1maDNzb2s2a0ZJL3NLZk83?=
 =?utf-8?B?SWVnTEpydU44eTMybTFrL2xla0lyOTFRODBFVllabmpPemZSUzN0b0dYNHF6?=
 =?utf-8?B?VUM0bDNmY3VodTlrNFQzbVBTUEJTd24wc0hiS0xYdmIzV3VORzZTSlVMajFq?=
 =?utf-8?B?RFE2eGRoZ0JaVnRQYVJXSDdlcHYxMTNoWks0eGtpMCtxcVVvcW41eVRCZmpF?=
 =?utf-8?B?cG9kcnlSbG50Y2hsVFo1YWhIOS9vQ040dWxJR3NTZTFnWTJtYU1mU09YQ0U5?=
 =?utf-8?B?bFNXM3ZmUEJoUGdlS2kvTGVvQUExdHdTK1RmYnlEL1JnOCs3emlhYlVtTlFM?=
 =?utf-8?B?bTdrTCtWamI2TzRiSzY5OWNNcVdYc1U1bU9neWM5bEpDNHNObGcvUGVDSFU4?=
 =?utf-8?B?MnQ3M1liS2pWNnphNG9zR3REbFlIR1EySS9ZNGJwTitvYWJxQkJmbGk5OFRy?=
 =?utf-8?B?SEM5MzZrODJGdmwzNjBMYUFmZ1NIRWdBSjVCR3NzbFQ5bnh3NDY0enQ5N1Av?=
 =?utf-8?B?VjNWQy9GZUsxUDdiRisyTUlaWG1FSzRYTXNuaGhhYzZienFienNrYUdDTERy?=
 =?utf-8?B?M0Y5QlQyMXpiVEZqckI5cC9uaWZxVWk5NG1VWFVyZHVVanBCTmJLWkJ2RnBJ?=
 =?utf-8?B?cWk3Q1dDYTdtWGZrcFBNNmNjczd6a3QvTURrUXhuSlpFOEpERWRXU1pMb09R?=
 =?utf-8?B?NUloTDU0bHFkSnE0WTdMcWZxemQ4ZG85VzNxUEJ4cDN0YjhtN3A0TXc3M1NH?=
 =?utf-8?B?azFucjNOMm1JVEtFUTZUNEpWdG5ac2REOXZYNWlXV2pNTWk2cGZtZU9WRGhD?=
 =?utf-8?B?TDFJNDN1K1Q3ekhXbUdXT05KVU1FNkpxWWFsY05OcW5kTmJ2K3pCc2U1OGNZ?=
 =?utf-8?B?U1lTYWJTcUdMODVSQzF6Wmd6dnRDR29VNi84V3lXUi96RXFDQXBkTFEwblVk?=
 =?utf-8?B?a0RwU0ZqTW5kaHBDdTF2d3UxbkpweHpzc3VPbFlCQlJGbExsM3JZdVRCcTJY?=
 =?utf-8?B?aG5WRHlObmt6Ky9lSWJsNVBjQnJiR244aDl4cjJPQnJyRllSeEtYeHZMN00r?=
 =?utf-8?B?UVJsZVJ0RElWbHRFeUpKaTVlVjM1NEN2dUZVTXdDa2t3UFZEcG1vUWxQVCtn?=
 =?utf-8?B?UldWUy9rRVB1RFZEMWQ0TXI3dlNDN0JlZ1NaaURFaXkzTmNjYlBjVlA3bkxx?=
 =?utf-8?B?UC8rcTBmTDYwMzB2QURkZU9pMmNZanYxMlpQUVE4bUl0eUZvMFU1aTl5d0pv?=
 =?utf-8?B?eXBkc2pDRTRDK2VrbGFNMUNIZXZhcmxkcnZOcDVZTFVEZW8rV25MWFBrRWhz?=
 =?utf-8?B?NkFVUGUyMVhpZFlkVTQ0UFdvM29VQmx6dlZBbGNKczlLL29IeGk5YXVLQ2w1?=
 =?utf-8?B?STFWQWZjOVBjZjgxUXNlMHVSazBBcDJOZmZTS25yekkvRWRFT1U5QzNvL0NM?=
 =?utf-8?B?MFNpVnl3Z245NW5RODNySVFJaW56NnRwamhSOHREb0xaeFcya3NkTlkzZjZr?=
 =?utf-8?B?djFLaTIvSnBjcXZ2bGhrQXF4M1lRVHdTR1p3MkRwU3VETEd1dWpOQnQwUmtF?=
 =?utf-8?B?b3g1TlRZRUtXSWRDNGdzN0h5ZmlSOGxTSjF2eEVWUTRzVzFVQi9YaXBRVzlU?=
 =?utf-8?B?TldleGZTaTBBRkhndDVQalhkUCtYcDY1U0dJMWk0YzRUTVBRa1hYRDJYYWpi?=
 =?utf-8?Q?EPvs3yRTqhzQHxeur3iyiv5QAuCMvt7dxNbg2yX?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814d4df7-89d5-4ffa-c6c0-08d9878c143c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 23:09:55.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YnbIQf04B5IhMpy+sg2ajEKJPNqQfgj7S7O8tAlzbBm3j8gJThrmq4rijfw83vE8ShTnGeB+yncGB5onkf+Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/21 7:05 PM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:20PM -0400, Sean Anderson wrote:
>> mac_prepare is called every time the interface is changed, so we can do
>> all of our configuration there, instead of in mac_config. This will be
>> useful for the next patch where we will set the PCS bit based on whether
>> we are using our internal PCS. No functional change intended.
> 
> The subject line appears to be the reverse of what you're actually
> doing.
> 

So it does.

--Sean
