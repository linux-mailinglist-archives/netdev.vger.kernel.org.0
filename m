Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5D639A11D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFCMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:36:32 -0400
Received: from mail-db8eur05on2111.outbound.protection.outlook.com ([40.107.20.111]:37344
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230255AbhFCMgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 08:36:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jp/MxrYGTcaSymUDQ+A5ArCjc/9ces3W7VxhPFd2P2nHukelThWCUI6WZT1drrrExC2pi/4XP3PL1lXEauDyBoyOL4X7alnXqelqDw3qTZ1aBYMAbcJMime2QSTZ0Ev2X0RZ+dx7wlfCSMbZ0HL6mx1sAfnRN6w40gGKT6ygf05HGHhZ9rToniKFBpH7c+e0cuusiEvVJcWkJQXWAB0iiGc8NvMRUUm/meLZPCJrqOo3XwYLYRFMaPn7uD0NdNftTdDyYk4N3v8rX8BL2ZVWdJN0r7vINuB08T7/BiIcgdvJmRx3S4fHVkvR2o7nUptf6G19TedxBDOA7LvqNsOjMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B6JFwiGt+7D5MshL6kWucsfqMNcQFuWyb45SC0Pzf0=;
 b=Bdswf8XV4sdoViqyQQULDJvsRVnU81dwwOnFKrk8aXreWZnckwxH95Njefmg+1pIhXo535w2x4lpl9A0TMtE3VLTOqX8k2w2i4nzHU7Itopf5SMxB8bnp3tAS0AYDxpItrNvxh/pMib1VaSAN7iqcD4nGTF2ji6MY79qLQEdpLunHWkx/J332SYdRbAiTgKw/W0W3niElY4Hny9cSiFEpwtdEl9tS5FYxl3Ev9Pi9FGz7RSs7TvCogM3FDmx45CPR7T2BFEkrDzXZukbzLWJT6Ws5rEmEOUmov6hwZonftHeTJC6xLQtJ7qAMqmvpl+Hg+EjszKSe5jPWBxCbEQjqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=asocscloud.com; dmarc=pass action=none
 header.from=asocscloud.com; dkim=pass header.d=asocscloud.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Asocs.onmicrosoft.com;
 s=selector2-Asocs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B6JFwiGt+7D5MshL6kWucsfqMNcQFuWyb45SC0Pzf0=;
 b=C9XS61ACn+JBKB66aigMMPohiTXN1reRPmgNfpG+rK5/BJhT+rWn5Ggnut++58oPpLzW0Plyaadv38ey22NjClIaN7k0KtdfA0K9hB5AE9tTHPzSt0MQIVco7RKbrJ0/JBY2L0QAWuB32NGXyc8QV4ragtyzWhedxpNbaRkOVeg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=asocscloud.com;
Received: from VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:6d::22) by VE1PR10MB3839.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:16f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 12:34:44 +0000
Received: from VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e021:4f40:bf7c:ee06]) by VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e021:4f40:bf7c:ee06%11]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 12:34:44 +0000
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
From:   Leonid Bloch <leonidb@asocscloud.com>
Subject: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
Message-ID: <54fb17e8-6a0c-ab56-8570-93cc8d11b160@asocscloud.com>
Date:   Thu, 3 Jun 2021 15:34:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.0.130.144]
X-ClientProxiedBy: PR3P191CA0060.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::35) To VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:6d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.78] (62.0.130.144) by PR3P191CA0060.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 12:34:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da2722f8-11a6-4851-6121-08d9268bf742
X-MS-TrafficTypeDiagnostic: VE1PR10MB3839:
X-Microsoft-Antispam-PRVS: <VE1PR10MB3839CB579D01ABEEF85C1874CE3C9@VE1PR10MB3839.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GIujbMaw7JRzbTWINARQ0/AyqD2QH1xcEyWUaOTnAjDVddCDt6cc5m75BCorUwne47jLRVSEJwLckPqVIq9YV7Rl8KUhewUCRjx2tBnar3VvLlOrwMeSPrt+yzuaS4OggKvv9mTzlUXuI43qNtYtNkK8dHDbEihKdzpDYtsyGu2bpjZ5ok9ZTipfu7DtEiZ6f3i64yAlL7Y0wlDe0Nnoqs7Exdtbijg1V08bkG0bj4t3hywd40h6ipVF9JA5YmnrxIYf3yYnj5SmheLzU5bUTh8WnciPMxyegAIDP2FzjwrHtoKTlRr8n2tyLRYpaYAckEMdu52Nn6Znd6t6PXA21WQWJvXfBtdsI0ZDSW/RjOfRAreuUhCZFUvRlbYpqr4fNyVC2tnHrRycTLlaAhVx/NPPIITC0yDyA5x00BEZJ2AOrElqu/asTyL0h4b1FsX4KwL25d94Zj7gXgZvNnWHbiH9NldBXBZZm92oJuGylX78pMN+ieSp8EXYN/PNgATI3Re5UldvEoKHCvN636TTLCRA/++qNa1Rn4Owg6QSLDKbPwyCxO/+mzRR6JXtPsLdnwW4uOVdu1ZaLvT+fAj1gIOcRoFVepLpicbANow51G9Q3U6hyIc14kIaAYH7IkKGL30AInscJdFWWtod7Eu4skKLqXiq9GFdHwMH9qbixTW/Jg0SvQItiHRxtOyplrfpsfdhVtLFNycIqTt1X/fNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(39830400003)(366004)(346002)(376002)(478600001)(26005)(186003)(45080400002)(16576012)(52116002)(316002)(4326008)(36756003)(110136005)(16526019)(38350700002)(38100700002)(8676002)(8936002)(956004)(2616005)(31686004)(2906002)(6486002)(66556008)(66946007)(5660300002)(66476007)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S0tRdCs0YjR3WXplUHZBeHBldTFqUG12dGVUL2VvMHZGM3FpQUxFOVp2Z3I4?=
 =?utf-8?B?bTUxcXlEMU1ST09FeldGRmFPT3RvQ0V4ZjJpNnJ6MjArL0VJTWs1ZlRxbnVV?=
 =?utf-8?B?QmhnNEJNYlR2ZXQxYzF6ajBBaVhBR0lwdTkrS0dqS1ZwK2RlMVIwOHBSRU5m?=
 =?utf-8?B?ZkVBQzU5NUs3L2FUUWJWbUVsM29NeldJdUw4SHBpTUNyUHZTT1liTnFKcVkv?=
 =?utf-8?B?TFVXV3hkWEs2eUVxYTRCNFdYTm16eFNVNHVXMng0dXEwRDE5WlJHQkhKK2dJ?=
 =?utf-8?B?UU1hZ3hNWDFPSmJjSERueUt6NWp4S2RBOHczVExLZERSTXI4dGwxdVJzaUVZ?=
 =?utf-8?B?YldvQWlGVXZnak9uZWZObStCMG9ydnpQR0pOVytncEMrdXpuZ1BtSll1WXla?=
 =?utf-8?B?aTZJbFIyeXQvQzNRSTFMSURob0lYMGo0SFB1WHFtZWI5SURKejNITWlrMEtV?=
 =?utf-8?B?bGJHdU1DandNK0VjL0pLbjQwa1FnaVREbTlSK0EraGtlZmQ3SVpqd1dwalds?=
 =?utf-8?B?YjJiQTRPTklENXMxY2p5bmxCRTM4WG9RQU9rTmNaMnltZGxKZEZrODlqQVR1?=
 =?utf-8?B?c3I4RXpTb1dNNklEOERJdWpCempWd25BTW1OTmFQZmkxb0pETnFDOCt0b3RK?=
 =?utf-8?B?N0RxYzNLQjdTRzFZaEo4d2oyV1RVcktmSXJ6ZDdxR1JZS1dobzg1UFE2UzhS?=
 =?utf-8?B?NlM2TiswVGZGUjhOMkdtZ0lXVHhOZ2dKZEYzdjRLN2ZtQnJGcEVmREhSbUVK?=
 =?utf-8?B?R2FmS0xhZ2ZGSk5VcXIrVmxCVTM3WFFDUlBQTjFJamt4SUZqZU0yTmhzbVhG?=
 =?utf-8?B?KzZNZ2p6VHBOK1BmVkgvRVNDdHJEbThveUZjVkZFbnNia2NPNTM4OWFLUXR1?=
 =?utf-8?B?NWhKN09uNnBEc1ZMa2Qva1ErbGlyQ1cyOFQ0VzUwQ2pSYTV6MVhOOExoV0RH?=
 =?utf-8?B?ZVk0di90N084VUVWaWlaRHZIQUdzQTZuUUgxaVlZYitJQjY0OThuSStyWHRU?=
 =?utf-8?B?SnlleFFkSjloeUFiREVhejUxRVRFSmtlWHhCUmcvcEt5eUt4VzZLVFEwYVBO?=
 =?utf-8?B?Ryt3V0lvTVlTUVdLeWtWWitGUXg3Z2pIVVROZVpzTDdqZlorOVVtMmprdGNS?=
 =?utf-8?B?VXZRYStrY2hSZVFXSnRxVGRsL2dmcXBEQ1c2bzE2MjRRaXhNcDFNeFBreDI3?=
 =?utf-8?B?bzhrenl6VmdOVUpzOWhjRFpZT3V6Y1JvQ1V5WWJWUEQwNUovOWtlUEhQa3BS?=
 =?utf-8?B?M0JMajFXT3dmbFZQajAwL0tTakdaQm1DRHdVU0NxOG5PV2lRQ2ZpNDZaVWRJ?=
 =?utf-8?B?OGpxRzR5RUlaWTJaazArMkJrcmF3dHBWLzZybWdQSjdUeUt3emhBY1BNWVFi?=
 =?utf-8?B?RlFTWVhTYVluczFnYlh1cklHMFRDZnVuTWpqQlkzV3ZtY0xCelN2STZ3MlNR?=
 =?utf-8?B?Uy9JcG91ODFHVDgzdVNrNlBKcDRqZTQ1RVdobVgwMjNTY0lTK0Q0YklNWTJv?=
 =?utf-8?B?Y3pIVWpsOW95bDNuSWx5TlBnYnA4L3NKT1E5bXFOR1VyZ2ZVNzNTQ0Q4QXJa?=
 =?utf-8?B?bEVia3JWVDBWQWVJUzh5Q1FNaDdXQmMyQmMyNG1UMHhnbVNrUE12dU0yb3Ar?=
 =?utf-8?B?Q0plNDhNS0RKSlJmT3E1aDdiZWdHQ3VYLzlnUVdkNENyV2tybDA2U2Z2ZGJn?=
 =?utf-8?B?K1E3MnpSSlEwczNwS3MzWllaUDkxenl4cHY2dTl3YnU5YzdVZGJUcU5wa00r?=
 =?utf-8?Q?hMm/VNT1v9xU194E3CqoypYCA4oZQ5DB4EWVxoS?=
X-OriginatorOrg: asocscloud.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2722f8-11a6-4851-6121-08d9268bf742
X-MS-Exchange-CrossTenant-AuthSource: VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:34:44.3756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 09a71e5b-e130-419f-bde2-1e8422f00aaa
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPd9uRtUrZwkQrebeMHUuh6LTL117XZW0A6je7kaTRofBi1a0FqKc15SVt2pbnupFrAd1I43WVCyGoYg6QOk6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR10MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When I try to unbind a network interface from hv_netvsc and bind it to 
uio_hv_generic, once in a while I get the following kernel panic (please 
note the first two lines: it seems as uio_hv_generic is registered 
before the VF bound to hv_netvsc is unregistered):

[Jun 3 09:04] hv_vmbus: registering driver uio_hv_generic
[  +0.002215] hv_netvsc 5e089342-8a78-4b76-9729-25c81bd338fc eth2: VF 
unregistering: eth5
[  +1.088078] BUG: scheduling while atomic: swapper/8/0/0x00010003
[  +0.000001] BUG: scheduling while atomic: swapper/3/0/0x00010003
[  +0.000001] BUG: scheduling while atomic: swapper/6/0/0x00010003
[  +0.000000] BUG: scheduling while atomic: swapper/7/0/0x00010003
[  +0.000005] Modules linked in:
[  +0.000001] Modules linked in:
[  +0.000001]  uio_hv_generic
[  +0.000000] Modules linked in:
[  +0.000000] Modules linked in:
[  +0.000001]  uio_hv_generic uio
[  +0.000001]  uio
[  +0.000000]  uio_hv_generic
[  +0.000000]  uio_hv_generic
...

I run kernel 5.10.27, unmodified, besides RT patch v36, on Azure Stack 
Edge platform, software version 2105 (2.2.1606.3320).

I perform the bind-unbind using the following script (please note the 
comment inline):

net_uuid="f8615163-df3e-46c5-913f-f2d2f965ed0e"
dev_uuid="$(basename "$(readlink "/sys/class/net/eth1/device")")"
modprobe uio_hv_generic
echo "${net_uuid}" > /sys/bus/vmbus/drivers/uio_hv_generic/new_id
printf "%s" "${dev_uuid}" > /sys/bus/vmbus/drivers/hv_netvsc/unbind
### If I insert 'sleep 1' here - all works correctly
printf "%s" "${dev_uuid}" > /sys/bus/vmbus/drivers/uio_hv_generic/bind


Thanks,
Leonid.
___
