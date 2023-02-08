Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1268EA33
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBHIvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjBHIvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:51:03 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7493545BCD;
        Wed,  8 Feb 2023 00:51:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAa4Q3ZwCSZcKSoUqg9Vcxp9e718iYW4Mikw6O+u55rUEYL3eoZnqPAT++KRXjpegebGF/wrZtHrVuhfq9ivHkMkVmL8qt9j6jYJ3X9zBjP0mxd1Bzp6iN5OuQWzOvFY4kbiQfejkaiq8cOvui4y3biEaULuo3wrp3MAQsHQ3Bsq3C/EMflEexivB7PIDGmA5dy6P0qBM/5lklwJq5kgPLTDdun21DRYo+Wjrvh1u5TB0nqFFBhPqVjxOEkKwCVrv6GAVuSYDx/oRBBQ+NhhlCFNCC1kqhL5MBHFomt8GteNourweOAdW1SPWLyb474vJY5okcPSnUI4TV4vwZ4QXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FmRmWFfp3TnZq3BDU+PJlLYp47FvFf6/PNMfzgX3Zk=;
 b=KIr3pXHJQGnQ/AO/8zNPCRGsvGNavSQDcqDrHvnjXxFrgzfLmAP5pyN1FmsZfsKXhytFMkgiY1L0captPdCVohOrkgtWDzSz3N/2jMGmjTxDOWqwVSelnvRff6FXKWDtRfBoZjxtHazyWa1YB+lGcW9iaWmC4rGgiQBsiJ/ARK0b5fSmN0lILqFELvb9uRYyVdimQwr1yCD1UmFuCV9O3Hce/G+VOeoDpd0EhF/ZkQzSgCez3hSQGF4BtTGfab8Q1Jo89ZoGWgvZUnTlzA46Tk3LQfcNEov1pRaGGcUZviRDJfs5Sr1vNnIg+ybZLfah4Ots195fBXWVfDkepYUTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FmRmWFfp3TnZq3BDU+PJlLYp47FvFf6/PNMfzgX3Zk=;
 b=1HB32IcTJRqSOliwD85LkURqvqH/Cj9Y0TaMWQpPN6vVC+lJoqEyPYgCS0MNvMEDDgcbTH3fwPlYsYKP/Kf8QDaad0D7xUalBZ55vaib3aFk0SBKxjFAv1WTspO9WWmcF/2U4AJXqZVbByoBVp6xziz3J5bafwgHeGaRWi7kYHU=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 08:50:58 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 08:50:58 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Thread-Topic: [PATCH v5 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Thread-Index: AQHZNveZ4AEcUHNqWUuukJHT7qRNu667kJcAgAgK/oCAAStPgA==
Date:   Wed, 8 Feb 2023 08:50:58 +0000
Message-ID: <DM6PR12MB4202498AD46F1112D710E77DC1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-8-alejandro.lucero-palau@amd.com>
 <Y9uoFNFjs1QDHt2K@nanopsycho>
 <DM6PR12MB42028E512EAB5BA1BB8845F9C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB42028E512EAB5BA1BB8845F9C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4910.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|MW4PR12MB7238:EE_
x-ms-office365-filtering-correlation-id: a5c8fce3-317c-4b53-e9bb-08db09b19931
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JeGAuSMkyG/+Gi5D306YFJeEXD+df7MtL1EK5QU5om7vxBXBc99MoDT9UCRE/fMxnjPx1C+HwGXhlbmmJqHuEGFG32vlxb4UgCHG66UTOTmb3z1GeBicDsoRHGjQE2KnkxK1yI0c0ADjScw05U0ph2VxDn1huQFAPKpPFXpUW4TBjMZc6M+pVANGAYWHfGZ+J9F9rm75oLEWof+2mvNMrTBU+hZIdW77XIMRR8seTTP9EsenrGzc93CWbHEqlCQ5PBTYntT/E+Hyn//IXmqZYthG1szlfnNcvumpOaXIjy4wm6bjyhTbhlt11JC3NMlA//047ozc1psNBi/rlAC+y9IrCizgvgmXJs0rCcc2euMru1PPcyC0dZdRjxCK7cZuCJiCFA+omvOxksUn7FbOfXxGKMm1B3QbrjbXE61t4RbhVs4VRN5cB61Gh1I+e7/cp2IT+7vs/u9Xcy0wJKXYOIxWl5uXfLn8OZQcyc8UmPakHnzruQZ2EkW4gLoK8APk2a0N34U46z11GjA+nV7xUJXigbeHMbWxqq0WJRL/B6gUqoW4f/Srt2gjF1MKvXvzBG6ojc2E5mANzmwDbrI/+h8PQW0oODi+2SV5FFrxxSq70+6IFLDmLS7ubD5EtbBuZwj2rcfZyUpXrWHL5sTSJJHeYc6F6K88jH9l5fD2WrvU7rFDXsnu1I7JJxD7xFuVIme2JDh1H4zhQGJ8lFkNXGjpl/lUzp/YsnbdoKum2lA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199018)(33656002)(6506007)(53546011)(71200400001)(7696005)(478600001)(4326008)(41300700001)(8936002)(54906003)(316002)(110136005)(83380400001)(55016003)(186003)(9686003)(26005)(52536014)(66946007)(8676002)(64756008)(76116006)(66446008)(66556008)(66476007)(7416002)(5660300002)(2906002)(38070700005)(122000001)(38100700002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWdFUWk1OHBza2QyK1dTNEdQdkU5N0FzVlp5ODArczVBZHdlRy9SbW1MWEt1?=
 =?utf-8?B?ZEpiL2JBYi9mdjcrVHZHTDNnT3FPanF5aW4rSWVoelVNNzZ1OFNvYkZmYi9J?=
 =?utf-8?B?bXNiNmNIN1NubGJGd2lyWVpxMk51MzkwZXlIVGlJRGE1cDM4WExLYTFYOFNa?=
 =?utf-8?B?Y1hWa3lqK2I1RVBTVVZyVGErNVlNQWM4NHBkNVBGWjZtZ1JvOWp3S3M1WEo2?=
 =?utf-8?B?cHJTc01JaGgraHpiNURJZktrU3NtSUdxREsvRS9BV2lNdTFvblpPQ3hrMzBa?=
 =?utf-8?B?dWhYUUJHMDlIVlpaQ3ZTcWVXZEJqOWFBbFBqQ09DbFFRNU9SRVltTHdKWjZa?=
 =?utf-8?B?WVQ5ZzQ5UXljMVdwdlJzNG9rUTFwTnVCV2gvSldSVzI4WGVuRDlLMWpPVmFM?=
 =?utf-8?B?RXVMQzQ5Mk5na1pxWit0NUE1RVMxRFMwSGphbUUyUFVuVEhNY3prUks4ZTFR?=
 =?utf-8?B?MHBRNFBDTjBKeVR1Y01hWGdJQ1B3UXcxSWZ2TzNncU1xb0ZBOTRCOFExR1Rt?=
 =?utf-8?B?QUJqeHRLQitIVFJSdEgzMHhSZzd0enZXT056cndITU4vVTljc2U2RTNXaGhh?=
 =?utf-8?B?Y2JqS3hVZ3RLK0lWd0s0ZzRqQ3JNMklzazV0SXBKMm1zUmwzWXA0RU9zRFhV?=
 =?utf-8?B?Qm03MUFYdmFwNXJ3MmhLd1JmN0JCQm5hUE9HL0hiUFU0T1Z3OTVpWUR2T1Vq?=
 =?utf-8?B?MjZCOExvR3NSNWc4cVhWY1JYcWJLeFF3VEFhVGpneWl2UjA2aGRRQ0JkVGpE?=
 =?utf-8?B?OERWMDZKWGVhOWNTcUR5akdPYU5vTjF1Ujl1WlNCcm9FTTQ4WFRkUjR6dVRY?=
 =?utf-8?B?Q1NiRkJDallNMWUxRTFIQXBMaHFLQnF2b0sxa2hlQ0ErMGlvb3pXb2ZJUTRa?=
 =?utf-8?B?VFNqWVNla2Jma0REamZkZmNrVzhidVlCTmpXbmJQV213K1Zka2lUSHRXUTR6?=
 =?utf-8?B?Sit5WUQ3Nm10dTE5dVZDNVB4OVBxS1lldWZsZi93azVVZ2wwOGtRZklXWkR4?=
 =?utf-8?B?c0paNU5rblZzbFFXWkZ2bFZNbzk4aHd1ZVZPRXNTSnFDcHBsTENoekI0aU0r?=
 =?utf-8?B?MUFpNkNmNkY4TlZxbnVrdlhTQUdISW1zaThLaWI5U1YwcXhXaUplTUVBOUJG?=
 =?utf-8?B?eTNaKzBJOVNwMTVJZ01sazRiZlpENDJoTVNyZVVaMEhzcWY0ODhPR0wwUXh6?=
 =?utf-8?B?RThGd2RmWDNiYkVaVUl6aFRQL1ZpRzBEU2pUN2V4dFlZaHdBWkM2YXoyTUZm?=
 =?utf-8?B?bzFWbUR1VDZ5aklQRmhQd3ZwYXRQUjQzM3dxNDNWYnlPVXZWMy94RDdEZEVK?=
 =?utf-8?B?ckdRR2tEZm1Id0hWQVJFQ3ZXOXV0ajRQb3l0dlNMVm85d1B1KzBVRjdVN2Uy?=
 =?utf-8?B?UGUwSUlJQ0Z5eU9pUmRuRTdBZk5uRk1DcFRWYWNWL3hCQ2RTVVplbEJ4eUlx?=
 =?utf-8?B?bUV2Y0ZkKzc2UnBIOUNFZ2ZNNEpPckdQUTVQeVFqa0dJWmJpampKUG9WWStT?=
 =?utf-8?B?eDJWdUlMVEJsSy9hY0lGc3B0OTR0K3liNTY3WjMxWjEwSy9XTm9WMFZhZkhZ?=
 =?utf-8?B?bTR6VmsrN0p2SmQvdmpLNXdOWXVUZDdadC85MXQ0TEEybGlDd0t3NDkzNTVL?=
 =?utf-8?B?SzZMaHkvbTBFWnBPcEpoQmNhRFc1YitBUWlPVUc0a0dLcU91UGR3YjkzQmZD?=
 =?utf-8?B?azYvODlaQjEzZDh6ZFhhbXhmY045WlFPVjRMcjBnNDZRQzFDZ2NnSkd6TUZS?=
 =?utf-8?B?VWUvdkVtN1B6dHZrYjFGR01BRnpkNG1rQkxNQUUwSnNCeXB2NDVpZ0FUaGRY?=
 =?utf-8?B?dm1SdjVUT1pNd1o5dXZLOFBpb3M2NTNMYmFFempicTBHbGpFL3Myek5HUlY1?=
 =?utf-8?B?a3ZzRUw5d2tuY0kzUFJVWDVtaHZwd3pFR0VyV0l3bFA2elFqS0s0Y2I2YW10?=
 =?utf-8?B?K2VCSUhBaGJwN21NRkcwN2x2NTkxL0hFV0VYcm56YXBzdERiUmVvRzYrZDRh?=
 =?utf-8?B?S0c1YXhGS0pnbUtncUFGZVdvSXdaWnpVMlVyTXpGeTE2YkFoV2o3ZnZaRWYv?=
 =?utf-8?B?RVlIeVRCN1hmcSsrMnk2eTBVajdaM3F0TFg2RG94ZUZOOTF5bVJxanlXVzZE?=
 =?utf-8?Q?Eu6g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF2E3D003DE8274FBEA5DD49AFA070F1@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c8fce3-317c-4b53-e9bb-08db09b19931
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 08:50:58.6478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+om5YyeOeKv51qBF+5zrVur45bgNqy9TRUphXytF00Hm4LUUxSj1K9zfZc7FCSXbaguPWa6efMev7TweHwYNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzcvMjMgMTU6MDEsIEx1Y2VybyBQYWxhdSwgQWxlamFuZHJvIHdyb3RlOg0KPiBPbiAy
LzIvMjMgMTI6MDksIEppcmkgUGlya28gd3JvdGU6DQo+PiBUaHUsIEZlYiAwMiwgMjAyMyBhdCAx
MjoxNDoyMlBNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3RlOg0KPj4+
IEZyb206IEFsZWphbmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4N
Cj4+Pg0KPj4+IFVzaW5nIHRoZSBidWlsdGluIGNsaWVudCBoYW5kbGUgaWQgaW5mcmFzdHJ1Y3R1
cmUsIHRoaXMgcGF0Y2ggYWRkcw0KPj4gRG9uJ3QgdGFsayBhYm91dCAidGhpcyBwYXRjaCIuIEp1
c3QgdGVsbCB0aGUgY29kZWJhc2Ugd2hhdCB0byBkby4NCj4gT0sNCj4NCj4+PiBzdXBwb3J0IGZv
ciBvYnRhaW5pbmcgdGhlIG1hYyBhZGRyZXNzIGxpbmtlZCB0byBtcG9ydHMgaW4gZWYxMDAuIFRo
aXMNCj4+PiBpbXBsaWVzIHRvIGV4ZWN1dGUgYW4gTUNESSBjb21tYW5kIGZvciBnZXR0aW5nIHRo
ZSBkYXRhIGZyb20gdGhlDQo+Pj4gZmlybXdhcmUgZm9yIGVhY2ggZGV2bGluayBwb3J0Lg0KPj4+
DQo+Pj4gU2lnbmVkLW9mZi1ieTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1w
YWxhdUBhbWQuY29tPg0KPj4+IC0tLQ0KPj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEw
MF9uaWMuYyAgIHwgMjcgKysrKysrKysrKysrKw0KPj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3Nm
Yy9lZjEwMF9uaWMuaCAgIHwgIDEgKw0KPj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEw
MF9yZXAuYyAgIHwgIDggKysrKw0KPj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9y
ZXAuaCAgIHwgIDEgKw0KPj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5j
IHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiA1IGZpbGVzIGNoYW5nZWQsIDkw
IGluc2VydGlvbnMoKykNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zZmMvZWYxMDBfbmljLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmMN
Cj4+PiBpbmRleCBhYTQ4Yzc5YTIxNDkuLmJlY2QyMWMyMzI1ZCAxMDA2NDQNCj4+PiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmMNCj4+PiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmMNCj4+PiBAQCAtMTEyMiw2ICsxMTIyLDMzIEBAIHN0
YXRpYyBpbnQgZWYxMDBfcHJvYmVfbWFpbihzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KPj4+IAlyZXR1
cm4gcmM7DQo+Pj4gfQ0KPj4+DQo+Pj4gKy8qIE1DREkgY29tbWFuZHMgYXJlIHJlbGF0ZWQgdG8g
dGhlIHNhbWUgZGV2aWNlIGlzc3VpbmcgdGhlbS4gVGhpcyBmdW5jdGlvbg0KPj4+ICsgKiBhbGxv
d3MgdG8gZG8gYW4gTUNESSBjb21tYW5kIG9uIGJlaGFsZiBvZiBhbm90aGVyIGRldmljZSwgbWFp
bmx5IFBGcyBzZXR0aW5nDQo+Pj4gKyAqIHRoaW5ncyBmb3IgVkZzLg0KPj4+ICsgKi8NCj4+PiAr
aW50IGVmeF9lZjEwMF9sb29rdXBfY2xpZW50X2lkKHN0cnVjdCBlZnhfbmljICplZngsIGVmeF9x
d29yZF90IHBjaWVmbiwgdTMyICppZCkNCj4+PiArew0KPj4+ICsJTUNESV9ERUNMQVJFX0JVRihv
dXRidWYsIE1DX0NNRF9HRVRfQ0xJRU5UX0hBTkRMRV9PVVRfTEVOKTsNCj4+PiArCU1DRElfREVD
TEFSRV9CVUYoaW5idWYsIE1DX0NNRF9HRVRfQ0xJRU5UX0hBTkRMRV9JTl9MRU4pOw0KPj4+ICsJ
dTY0IHBjaWVmbl9mbGF0ID0gbGU2NF90b19jcHUocGNpZWZuLnU2NFswXSk7DQo+Pj4gKwlzaXpl
X3Qgb3V0bGVuOw0KPj4+ICsJaW50IHJjOw0KPj4+ICsNCj4+PiArCU1DRElfU0VUX0RXT1JEKGlu
YnVmLCBHRVRfQ0xJRU5UX0hBTkRMRV9JTl9UWVBFLA0KPj4+ICsJCSAgICAgICBNQ19DTURfR0VU
X0NMSUVOVF9IQU5ETEVfSU5fVFlQRV9GVU5DKTsNCj4+PiArCU1DRElfU0VUX1FXT1JEKGluYnVm
LCBHRVRfQ0xJRU5UX0hBTkRMRV9JTl9GVU5DLA0KPj4+ICsJCSAgICAgICBwY2llZm5fZmxhdCk7
DQo+Pj4gKw0KPj4+ICsJcmMgPSBlZnhfbWNkaV9ycGMoZWZ4LCBNQ19DTURfR0VUX0NMSUVOVF9I
QU5ETEUsIGluYnVmLCBzaXplb2YoaW5idWYpLA0KPj4+ICsJCQkgIG91dGJ1Ziwgc2l6ZW9mKG91
dGJ1ZiksICZvdXRsZW4pOw0KPj4+ICsJaWYgKHJjKQ0KPj4+ICsJCXJldHVybiByYzsNCj4+PiAr
CWlmIChvdXRsZW4gPCBzaXplb2Yob3V0YnVmKSkNCj4+PiArCQlyZXR1cm4gLUVJTzsNCj4+PiAr
CSppZCA9IE1DRElfRFdPUkQob3V0YnVmLCBHRVRfQ0xJRU5UX0hBTkRMRV9PVVRfSEFORExFKTsN
Cj4+PiArCXJldHVybiAwOw0KPj4+ICt9DQo+Pj4gKw0KPj4+IGludCBlZjEwMF9wcm9iZV9uZXRk
ZXZfcGYoc3RydWN0IGVmeF9uaWMgKmVmeCkNCj4+PiB7DQo+Pj4gCXN0cnVjdCBlZjEwMF9uaWNf
ZGF0YSAqbmljX2RhdGEgPSBlZngtPm5pY19kYXRhOw0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
ZWYxMDBfbmljLmgNCj4+PiBpbmRleCBlNTkwNDQwNzIzMzMuLmYxZWQ0ODFjMTI2MCAxMDA2NDQN
Cj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmgNCj4+PiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmgNCj4+PiBAQCAtOTQsNCArOTQs
NSBAQCBpbnQgZWYxMDBfZmlsdGVyX3RhYmxlX3Byb2JlKHN0cnVjdCBlZnhfbmljICplZngpOw0K
Pj4+DQo+Pj4gaW50IGVmMTAwX2dldF9tYWNfYWRkcmVzcyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCB1
OCAqbWFjX2FkZHJlc3MsDQo+Pj4gCQkJICBpbnQgY2xpZW50X2hhbmRsZSwgYm9vbCBlbXB0eV9v
ayk7DQo+Pj4gK2ludCBlZnhfZWYxMDBfbG9va3VwX2NsaWVudF9pZChzdHJ1Y3QgZWZ4X25pYyAq
ZWZ4LCBlZnhfcXdvcmRfdCBwY2llZm4sIHUzMiAqaWQpOw0KPj4+ICNlbmRpZgkvKiBFRlhfRUYx
MDBfTklDX0ggKi8NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2Vm
MTAwX3JlcC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3JlcC5jDQo+Pj4gaW5k
ZXggNmI1YmM1ZDY5NTVkLi4wYjMwODNlZjBlYWQgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3JlcC5jDQo+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc2ZjL2VmMTAwX3JlcC5jDQo+Pj4gQEAgLTM2MSw2ICszNjEsMTQgQEAgYm9vbCBlZjEwMF9t
cG9ydF9vbl9sb2NhbF9pbnRmKHN0cnVjdCBlZnhfbmljICplZngsDQo+Pj4gCQkgICAgIG1wb3J0
X2Rlc2MtPmludGVyZmFjZV9pZHggPT0gbmljX2RhdGEtPmxvY2FsX21hZV9pbnRmOw0KPj4+IH0N
Cj4+Pg0KPj4+ICtib29sIGVmMTAwX21wb3J0X2lzX3ZmKHN0cnVjdCBtYWVfbXBvcnRfZGVzYyAq
bXBvcnRfZGVzYykNCj4+PiArew0KPj4+ICsJYm9vbCBwY2llX2Z1bmM7DQo+Pj4gKw0KPj4+ICsJ
cGNpZV9mdW5jID0gZWYxMDBfbXBvcnRfaXNfcGNpZV92bmljKG1wb3J0X2Rlc2MpOw0KPj4+ICsJ
cmV0dXJuIHBjaWVfZnVuYyAmJiAobXBvcnRfZGVzYy0+dmZfaWR4ICE9IE1BRV9NUE9SVF9ERVND
X1ZGX0lEWF9OVUxMKTsNCj4+PiArfQ0KPj4+ICsNCj4+PiB2b2lkIGVmeF9lZjEwMF9pbml0X3Jl
cHMoc3RydWN0IGVmeF9uaWMgKmVmeCkNCj4+PiB7DQo+Pj4gCXN0cnVjdCBlZjEwMF9uaWNfZGF0
YSAqbmljX2RhdGEgPSBlZngtPm5pY19kYXRhOw0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYx
MDBfcmVwLmgNCj4+PiBpbmRleCBhZTZhZGQ0YjA4NTUuLmEwNDI1MjVhMjI0MCAxMDA2NDQNCj4+
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmgNCj4+PiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmgNCj4+PiBAQCAtNzYsNCArNzYsNSBA
QCB2b2lkIGVmeF9lZjEwMF9maW5pX3JlcHMoc3RydWN0IGVmeF9uaWMgKmVmeCk7DQo+Pj4gc3Ry
dWN0IG1hZV9tcG9ydF9kZXNjOw0KPj4+IGJvb2wgZWYxMDBfbXBvcnRfb25fbG9jYWxfaW50Zihz
dHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4+IAkJCSAgICAgICBzdHJ1Y3QgbWFlX21wb3J0X2Rlc2Mg
Km1wb3J0X2Rlc2MpOw0KPj4+ICtib29sIGVmMTAwX21wb3J0X2lzX3ZmKHN0cnVjdCBtYWVfbXBv
cnRfZGVzYyAqbXBvcnRfZGVzYyk7DQo+Pj4gI2VuZGlmIC8qIEVGMTAwX1JFUF9IICovDQo+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMNCj4+PiBpbmRleCBhZmRiMTlmMGM3
NzQuLmM0NDU0N2I5ODk0ZSAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
ZmMvZWZ4X2RldmxpbmsuYw0KPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhf
ZGV2bGluay5jDQo+Pj4gQEAgLTYwLDYgKzYwLDU2IEBAIHN0YXRpYyBpbnQgZWZ4X2Rldmxpbmtf
YWRkX3BvcnQoc3RydWN0IGVmeF9uaWMgKmVmeCwNCj4+Pg0KPj4+IAlyZXR1cm4gZGV2bF9wb3J0
X3JlZ2lzdGVyKGVmeC0+ZGV2bGluaywgJm1wb3J0LT5kbF9wb3J0LCBtcG9ydC0+bXBvcnRfaWQp
Ow0KPj4+IH0NCj4+PiArDQo+Pj4gK3N0YXRpYyBpbnQgZWZ4X2RldmxpbmtfcG9ydF9hZGRyX2dl
dChzdHJ1Y3QgZGV2bGlua19wb3J0ICpwb3J0LCB1OCAqaHdfYWRkciwNCj4+PiArCQkJCSAgICAg
aW50ICpod19hZGRyX2xlbiwNCj4+PiArCQkJCSAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAq
ZXh0YWNrKQ0KPj4+ICt7DQo+Pj4gKwlzdHJ1Y3QgZWZ4X2RldmxpbmsgKmRldmxpbmsgPSBkZXZs
aW5rX3ByaXYocG9ydC0+ZGV2bGluayk7DQo+Pj4gKwlzdHJ1Y3QgbWFlX21wb3J0X2Rlc2MgKm1w
b3J0X2Rlc2M7DQo+Pj4gKwllZnhfcXdvcmRfdCBwY2llZm47DQo+Pj4gKwl1MzIgY2xpZW50X2lk
Ow0KPj4+ICsJaW50IHJjID0gMDsNCj4+IFBvaW50bGVzcyBpbml0Lg0KPj4NCj4+DQo+IFJpZ2h0
DQo+DQo+Pj4gKw0KPj4+ICsJbXBvcnRfZGVzYyA9IGNvbnRhaW5lcl9vZihwb3J0LCBzdHJ1Y3Qg
bWFlX21wb3J0X2Rlc2MsIGRsX3BvcnQpOw0KPj4+ICsNCj4+PiArCWlmICghZWYxMDBfbXBvcnRf
b25fbG9jYWxfaW50ZihkZXZsaW5rLT5lZngsIG1wb3J0X2Rlc2MpKSB7DQo+Pj4gKwkJcmMgPSAt
RUlOVkFMOw0KPj4+ICsJCU5MX1NFVF9FUlJfTVNHX0ZNVChleHRhY2ssDQo+Pj4gKwkJCQkgICAi
UG9ydCBub3Qgb24gbG9jYWwgaW50ZXJmYWNlIChtcG9ydDogJXUpIiwNCj4+PiArCQkJCSAgIG1w
b3J0X2Rlc2MtPm1wb3J0X2lkKTsNCj4+PiArCQlnb3RvIG91dDsNCj4+PiArCX0NCj4+PiArDQo+
Pj4gKwlpZiAoZWYxMDBfbXBvcnRfaXNfdmYobXBvcnRfZGVzYykpDQo+Pj4gKwkJRUZYX1BPUFVM
QVRFX1FXT1JEXzMocGNpZWZuLA0KPj4+ICsJCQkJICAgICBQQ0lFX0ZVTkNUSU9OX1BGLCBQQ0lF
X0ZVTkNUSU9OX1BGX05VTEwsDQo+Pj4gKwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fVkYsIG1wb3J0
X2Rlc2MtPnZmX2lkeCwNCj4+PiArCQkJCSAgICAgUENJRV9GVU5DVElPTl9JTlRGLCBQQ0lFX0lO
VEVSRkFDRV9DQUxMRVIpOw0KPj4+ICsJZWxzZQ0KPj4+ICsJCUVGWF9QT1BVTEFURV9RV09SRF8z
KHBjaWVmbiwNCj4+PiArCQkJCSAgICAgUENJRV9GVU5DVElPTl9QRiwgbXBvcnRfZGVzYy0+cGZf
aWR4LA0KPj4+ICsJCQkJICAgICBQQ0lFX0ZVTkNUSU9OX1ZGLCBQQ0lFX0ZVTkNUSU9OX1ZGX05V
TEwsDQo+Pj4gKwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fSU5URiwgUENJRV9JTlRFUkZBQ0VfQ0FM
TEVSKTsNCj4+PiArDQo+Pj4gKwlyYyA9IGVmeF9lZjEwMF9sb29rdXBfY2xpZW50X2lkKGRldmxp
bmstPmVmeCwgcGNpZWZuLCAmY2xpZW50X2lkKTsNCj4+PiArCWlmIChyYykgew0KPj4+ICsJCU5M
X1NFVF9FUlJfTVNHX0ZNVChleHRhY2ssDQo+Pj4gKwkJCQkgICAiTm8gaW50ZXJuYWwgY2xpZW50
X0lEIGZvciBwb3J0IChtcG9ydDogJXUpIiwNCj4+PiArCQkJCSAgIG1wb3J0X2Rlc2MtPm1wb3J0
X2lkKTsNCj4+PiArCQlnb3RvIG91dDsNCj4+PiArCX0NCj4+PiArDQo+Pj4gKwlyYyA9IGVmMTAw
X2dldF9tYWNfYWRkcmVzcyhkZXZsaW5rLT5lZngsIGh3X2FkZHIsIGNsaWVudF9pZCwgdHJ1ZSk7
DQo+Pj4gKwlpZiAocmMgIT0gMCkNCj4+IHdoeSAiaWYgKHJjKSIgaXMgbm90IGVub3VnaCBoZXJl
Pw0KPj4NCj4gUmlnaHQNCj4NCj4+PiArCQlOTF9TRVRfRVJSX01TR19GTVQoZXh0YWNrLA0KPj4+
ICsJCQkJICAgIk5vIGF2YWlsYWJsZSBNQUMgZm9yIHBvcnQgKG1wb3J0OiAldSkiLA0KPj4+ICsJ
CQkJICAgbXBvcnRfZGVzYy0+bXBvcnRfaWQpOw0KPj4gSXQgaXMgcmVkdW5kYW50IHRvIHByaW50
IG1wb3J0X2lkIHdoaWNoIGlzIGV4cG9zZWQgYXMgZGV2bGluayBwb3J0IGlkLg0KPj4gUGxlYXNl
IHJlbW92ZSBmcm9tIHRoZSBhbGwgdGhlIGV4dGFjayBtZXNzYWdlcy4gTm8gbmVlZCB0byBtZW50
aW9uDQo+PiAicG9ydCIgYXQgYWxsLCBhcyB0aGUgdXNlciBrbm93cyBvbiB3aGljaCBvYmplY3Qg
aGUgaXMgcGVyZm9ybWluZyB0aGUNCj4+IGNvbW1hbmQuDQo+IEkgdGhpbmsgdGhlIGlkZWEgd2Fz
IHRvIGhhdmUgc3VjaCBhIHJlcG9ydCB0byB1c2VyIHNwYWNlIGFzIGlucHV0IGZyb20gYQ0KPiBj
bGllbnQgdG8gb3VyIHN1cHBvcnQgdGVhbSB3aGljaCBjb3VsZCBoZWxwLg0KPg0KPiBCdXQgSSBn
dWVzcyB5b3UgYXJlIHJpZ2h0LCBhbmQgdGhhdCBpbmZvIHdvdWxkIGFsc28gYmUgcmVwb3J0ZWQg
d2l0aG91dA0KPiBzcGVjaWZpY2FsbHkgYWRkaW5nIGl0IGhlcmUuDQo+DQo+DQo+PiBBbHNvLCBw
ZXJoYXBzIGl0IHdvdWxkIHNvdW5kIGJldHRlciB0byBzYXkgIk5vIE1BQyBhdmFpbGFibGUiPw0K
Pj4NCj4+DQo+IFRoYXQgc3VidGxlIGNoYW5nZSBjb3VsZCBpbXBseSBhIHRvdGFsIGRpZmZlcmVu
dCBtZWFuaW5nIC4uLiBhdCBsZWFzdCBpbg0KPiBteSBuYXRpdmUgbGFuZ3VhZ2UuIEJ1dCBJIHdp
bGwgbm90IGZpZ2h0IHRoaXMgb25lIDotKSBhbmQgY2hhbmdlIGl0IGluIHRoZQ0KPiBuZXh0IHZl
cnNpb24uDQo+DQo+Pj4gK291dDoNCj4+PiArCSpod19hZGRyX2xlbiA9IEVUSF9BTEVOOw0KPj4g
T2RkLiBJIHRoaW5rIHlvdSBzaG91bGQgbm90IHRvdWNoIGh3X2FkZHJfbGVuIGluIGNhc2Ugb2Yg
ZXJyb3IuDQo+Pg0KPiBJdCBkb2VzIG5vdCBoYXJtLiBEb2VzIGl0Pw0KPg0KPiBPdGhlcndpc2Us
IEkgbmVlZCBhbm90aGVyIGdvdG8gaW4gcHJldmlvdXMgZXJyb3IgY2hlY2tpbmcgd2hhdCBzZWVt
cyBvZGQNCj4gZm9yIGEgc2luZ2xlIGxpbmUuDQoNCg0KU2lsbHkgbWUuIEkgZG8gbm90IG5lZWQg
dGhlIGdvdG9zIGF0IGFsbCENCg0KPj4+ICsJcmV0dXJuIHJjOw0KPj4+ICt9DQo+Pj4gKw0KPj4+
ICNlbmRpZg0KPj4+DQo+Pj4gc3RhdGljIGludCBlZnhfZGV2bGlua19pbmZvX252cmFtX3BhcnRp
dGlvbihzdHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4+IEBAIC01MjIsNiArNTcyLDkgQEAgc3RhdGlj
IGludCBlZnhfZGV2bGlua19pbmZvX2dldChzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywNCj4+Pg0K
Pj4+IHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGV2bGlua19vcHMgc2ZjX2Rldmxpbmtfb3BzID0gew0K
Pj4+IAkuaW5mb19nZXQJCQk9IGVmeF9kZXZsaW5rX2luZm9fZ2V0LA0KPj4+ICsjaWZkZWYgQ09O
RklHX1NGQ19TUklPVg0KPj4+ICsJLnBvcnRfZnVuY3Rpb25faHdfYWRkcl9nZXQJPSBlZnhfZGV2
bGlua19wb3J0X2FkZHJfZ2V0LA0KPj4+ICsjZW5kaWYNCj4+PiB9Ow0KPj4+DQo+Pj4gI2lmZGVm
IENPTkZJR19TRkNfU1JJT1YNCj4+PiAtLSANCj4+PiAyLjE3LjENCj4+Pg0K
