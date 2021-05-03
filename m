Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF35C371635
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhECNu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 09:50:28 -0400
Received: from mail-vi1eur05on2114.outbound.protection.outlook.com ([40.107.21.114]:19809
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233400AbhECNuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 09:50:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LICuNU3SfG21nmf/ewxAhSsul1NXwHvLv14TEaRGejGOARoRaz2BFC+6SbxUIKyHaWTbMToriyo+7bknTtvl1ByogxLzRpJBmXQBTeCSNjV3FRDRNDh8D+Y8tFzGXkEK1xojjGDIqeWIPh2oCVwK/ez8P0aRlpZ9Z9FtGVqo35wCpn3xPI1pSIq1zUz8r24Wlrt3yGqTelohe4YQ+dE3F+NfVs0OXzY2CMScbhz7481Z5x1egyiSxVz9nVBZsd1j4d4hj6NcSlgxlljG2/2UkV21vYEqrjfMgyieMVzE99wBrhtqVN9ASDmwsKWJI+RaCb8OudKqJezGxiIINZtJYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhzAU1rs+VfvzSRDKfv4sz6gbt/8jZCDw+wleWqAWoI=;
 b=LcJqzMsW6AcMO+nQ53gULY4hmT8NOqpGf9F+Ta/ERzfwmlWLVgR53hwGU8GVQFfY3LQ8bLTHzMiDeK34tb3K7vmMzAB4F1Aab7vE1UdR0eIXqV55aqWTiT0ikSMZuLACdnZAQT1BWzoYgi8/csfvDLq7b1aOX4rbiZujrfCSTHf18HWcbFJsXPy89UWrIH5UKdCDJp4IpOwyD8lhrCcqfxIBTN2/HHAN2KF9F3yvdRN7muA2F7Xx97yoIoQFGpWz+HFWyz26kYm1J37Zqdj0098n9GPtobFR9x6Vv7hklKskQnsZvz5YhiUM9xi86Hz0CK562OI+MXqzaE+x/CVK7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhzAU1rs+VfvzSRDKfv4sz6gbt/8jZCDw+wleWqAWoI=;
 b=UdnYBdDiJq1VqtfOXAm4u+8sUG7VXRXC/bhz0pIqJDWNbC8cMZ3MfAeeGIveV89N3+wxZ/NGvUmeueh6xY3YjaqBIyebFWcfAgaqlKt1d0c8GrZg/eHEkeUH8kcDAH4EtjJljrlHlDY2S9G2LR6A935RIbzmFRKxJ4Y8xU6QC5E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2356.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e4::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Mon, 3 May
 2021 13:49:24 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 13:49:24 +0000
Subject: Re: Null pointer dereference in mcp251x driver when resuming from
 sleep
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?Q?Timo_Schl=c3=bc=c3=9fler?= <schluessler@krause.de>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
 <YI/+OP4z787Tmd05@smile.fi.intel.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <8dcdeab9-80f1-5961-6d55-82b4904cbf14@kontron.de>
Date:   Mon, 3 May 2021 15:49:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YI/+OP4z787Tmd05@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.250.134.29]
X-ClientProxiedBy: AM7PR03CA0007.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::17) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (109.250.134.29) by AM7PR03CA0007.eurprd03.prod.outlook.com (2603:10a6:20b:130::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Mon, 3 May 2021 13:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88a1b94a-f2a1-404a-a50e-08d90e3a431f
X-MS-TrafficTypeDiagnostic: AM0PR10MB2356:
X-Microsoft-Antispam-PRVS: <AM0PR10MB23564153CD1B02DE4999C794E95B9@AM0PR10MB2356.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EGEBFegLI/rwmL4kj64e/Zh9Qhs5W7yyxfVUR+NFB6Y4S7Tf1Vt3LqdGqxczWKxnqkRZzz+y15MNlekeQJh+p04IxZhGTwQylFyrS3pGPZQ6sGg05rpIZJ7DIv9sj1D1YcrGGgJrdisQP7Bnn9zRWVLIyj9Q/BzVqxWPiZ2j1iP7YdJcDZymPNG0AMLbznLBWrHfhfavtx4Aa6LmSlnmi6LAsg8VH9/z+5Q3Imc1Oka7q+/3hxmX7vpNqlWPC+JedIDmhqLv7ZPSYaR0GR28cboZuCicQO1Q31yOChfpJfHbvieIdApCPdWw7cu1OhhzEN+eO97e2UMYCsvKdIZzew084w9yrsG+z67VBwWl79dg9eMoNn3SGw83Wzgk+wz13H497hon7d3HaT5sJpqmx6wNGz0rGknmCi5wS+uZmu5OxuzZ7luTga5g1YNmwC5bu5MzxkoGm+Q3lukBdoQrhjisjIWV+mK4WS/iA0rCA1zJqTNEB+pbJoPcKNXFZKvODm4lkmTp6S1AL8n3AvRpbKWjbYVm64SCW161diTd2xuC3e6EGYrW0z3IyrOx4osove/goAo8dxdnSj+BcWPyGHF1bVt8BmZHbxmk1xPOoYN5DWKx9d1hJZx6UIAsiimNkDPfCrrmLk9UJk/Cf45gIlA4DXONOLWXxz1Hrd2whwlW2JwwGNBndKFgg2XoxDKj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39850400004)(346002)(366004)(66946007)(66556008)(2906002)(53546011)(31686004)(4326008)(6916009)(66476007)(16526019)(38100700002)(2616005)(186003)(86362001)(31696002)(316002)(36756003)(8676002)(4744005)(7416002)(8936002)(54906003)(5660300002)(44832011)(6486002)(478600001)(16576012)(26005)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TW1jUzdPYXdtVGlnZGhvNDFNcFg2YXp5Y1dUSzNGY0lIYTRFTktPQVdjYnJw?=
 =?utf-8?B?czg5Z3gvVEtEUDFyY0lyenEwdWdwYW5hRUROamZ3c0pKbTY5V2ZCZTA2TVFv?=
 =?utf-8?B?aDJ6L013VmwwQ1F0cUlhTC82TmtNTnpXWFpRNkk4UGlSdjZTS3N2NU5MMGtn?=
 =?utf-8?B?a08vWDdtQmFydG4zMG5TcUpiYTJLWnNOQWdwNVhOOVoyZy9aWWlWekpmQUxW?=
 =?utf-8?B?RURLWmpmU01NcUZlY3hRTVF0SWMva3BOTStWMFQxbjVVdTZLc3dSS05UVnB2?=
 =?utf-8?B?dXRpQlZvM1A3UWROOTQzUkp3UytZNElhUk9FbW1QWE45OVZUNjEyL0VCU3l3?=
 =?utf-8?B?MDJaK0xkSzQrUU1iaHhOa0hxMU5IQWJmSHFVN1RYVzFmbHIreWkvdlBJNDRz?=
 =?utf-8?B?ZENzcUltRUVpdGZrbS9ZYm5ncFhKa3NJK0FwQThiKzBTODFNT09SaCt3VWti?=
 =?utf-8?B?eWRxRGROcnorT3I0dGRUY2dNdURoVS9zOUJpRU1acXJCTHVSRGV4VVZqYjRX?=
 =?utf-8?B?RVp2YW1iUkQwWFFueEZTNjR3TEhPdmFPMHpHUFlqWURsZDJMSFJOZVFPanoy?=
 =?utf-8?B?VVZsU1E4VzQ4RUNrY0EyTGdpYmRSZDdQZXlqVUxWazBERTFBYVlXT2l2VGls?=
 =?utf-8?B?em9nTDFjdU9JekVQZnNOalZMcnJoelhzaVEvbnlLa2YyU3ZSOWIvUlhSdkNo?=
 =?utf-8?B?QS9tblFkdml1S0NuOThRYnpmZTIva2tmRzBYL0JFdVdmTnBPb1BEQmtvSURZ?=
 =?utf-8?B?VDgrbDJQai90M1pqZ201VStFRHo5aG1tbUVqVzduTnZMMnJWbFlMcmh0YndG?=
 =?utf-8?B?cFJ5UE0zU0VLSGhhY1ZUNm9oUEx6UHFuN1ZHSUd2UlNTUFBURUljc21qZCth?=
 =?utf-8?B?eGU1RHNING9YT29PblBvbnJLaW1xV29OYTl2TDMyNW9pbzlkRWVsT3lueHBS?=
 =?utf-8?B?NjE4WEkxZ09lelVPWnIrcWFiWmh3VHFCdGdKZ3FSajE0WWRScGdrcER4UExh?=
 =?utf-8?B?SHJmSXd3Y09zWldBNC8zb0xhcEVTelF1Ynh2TjJMN1FrNGhHWXErUUsyMHZL?=
 =?utf-8?B?eDVTYjhjM3RlNkg4bkNJanM4ci8xSE9DY2w0ZFQzdzk0Vmo4K2lnd0FCcmlJ?=
 =?utf-8?B?R2N6dDRobHZkSW5OdThqRXVnN2J6cnIzYzNQdHNjVmJqYnJHNTFFWTlHM3Js?=
 =?utf-8?B?MS9qZmpDUVBiNTdFVlZqM2VxcFZtbUtjWDZpZ3J6VHBKUTl5dVBiZVFUQjNP?=
 =?utf-8?B?djY1THVQTVM4UG5wZzNOczE1NFgwYUFyUExsTHpXYzlmdHd5UXhCNnFuQjBx?=
 =?utf-8?B?L0lyZjh2cTMwTWRwdjhuRDlMZEsrUmVtUWhHb0N6M1NiNWFVdHJRRFhsREFX?=
 =?utf-8?B?WFhQeHBockt0WWozeERhUFk4RHk3TTdUUVo3U0FUVkJoY0xBcktxcVQ1T1BX?=
 =?utf-8?B?K0J2SEpYa3lxVGFHaDlpUHN0SVZacVB2MWZaQTUxSzhnbXVhUEdpRzVhb2ZK?=
 =?utf-8?B?S1RZNmdoaFZsV0VJYTB6R1FYaTc3dk54RHdMZklBNlNlZnhjaTNHSDJlSVVj?=
 =?utf-8?B?SE1CY0NRcFpRZUt4TXpvUXB0enJsZ2ZEQWVNTjNyTnJrYnhRK0trNFRnbWx5?=
 =?utf-8?B?OEN4TTJuSkhpdHptRjZSRFo2a0ZnYUM4elNMdFlwSUZ1OHdHaUdaMitHTko2?=
 =?utf-8?B?Y1U4bmQ0a1dCazlpalZuR1RrdjRYOC9CejJzYkxBY1NvSTkxRUwyTTVIeTR6?=
 =?utf-8?Q?MA4fM/ijdnlnLKpHM5O66NbuI0+xRTDXe7WhpOm?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a1b94a-f2a1-404a-a50e-08d90e3a431f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 13:49:24.8004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQTY+O+gSaeX6WHgMPC+dtWztEMT+sIQgnNJL8p0YBAlXyD3JdCjYHgCaJNq65Bcqp77h6sLlIa9sIVyJLwuaDWSauk972jaknc2Y7weN2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2356
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.05.21 15:44, Andy Shevchenko wrote:
> On Mon, May 03, 2021 at 03:11:40PM +0200, Frieder Schrempf wrote:
>> Hi,
>>
>> with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference
>> exception from the mcp251x driver when I resume from sleep (see trace
>> below).
>>
>> As far as I can tell this was working fine with 5.4. As I currently don't
>> have the time to do further debugging/bisecting, for now I want to at least
>> report this here.
>>
>> Maybe there is someone around who could already give a wild guess for what
>> might cause this just by looking at the trace/code!?
> 
> Does revert of c7299fea6769 ("spi: Fix spi device unregister flow") help?

This commit is so new, that it is neither in 5.10.x nor in 5.12.1. So it 
can't be the reason.
