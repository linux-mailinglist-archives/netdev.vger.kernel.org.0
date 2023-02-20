Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1820C69C887
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjBTK1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjBTK1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:27:06 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8235818AA9;
        Mon, 20 Feb 2023 02:27:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fnmbzd8HRvFKEmnCvblnkBkhIC6+OeTYmnq+MGP8BJcAoLLKL0AjemHlWShT2ojI8BXdq9H9+0nXiZEE/ofJcmurtXy9OySpWmYDgw6mWOjsRqp7WdpbCarkGiBUFt8eVuMJMPU0A7n2lhlE3g4io1KiLP0bI3eEyEZssmfE36u7sosghCpJSyIWoKqnFt0qi9tJQ8glrZ/MtDRl35rtQCsr5k5jlqVnfb8cjCl9TBRgJVd6rXOXUY/dZwdVKGF39cAil3LvpyEPjmR57REpmtWUOhUc83EDPLiRKpz+MPw4FCsTw3bz7t1A7gxu0SSWPnhi4joABieljU8RE0azCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQJwj9bSn5m96Biaai+kN/YP1GgWZjxnYTdtJkfI8to=;
 b=RoQHSI4vReN9HO+lNMoETCP9CjJobE4K7KkLyMX9z6wiqmDlSHZ8uOy9Oh9CWTJfFjl59lM3lZwRruezzqhmmGswZ0QsfjvaWFpd7HAtknHDHCkagjD608ToLX4i9hanE3eXCtYUyVL7qrKfBQAh978VmhjqT+MFbV790k+FF6csw4fm1jqAn3RRtpezQGpvlrh3db8C6l8sYuADfAgLGUtkAxAwEEIHBnG9s+PU2lIo8ZTFe4IS+ZMfreRUgWUPVPPYwo5hwDo4vGf4fQemy14JHNYbBOninyGIcru0zZxSplPD47nmRueWRAof4TjttPAyZgLnZz9L36kOVSu7IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQJwj9bSn5m96Biaai+kN/YP1GgWZjxnYTdtJkfI8to=;
 b=AYohG1nxgD0oQUbhQhTsENiez893++LKHWW50FE524rmlIosNQJuVEUBwy0PPs+G4MVhS5yc+YxIAOhK3vPRwjW9x5BTbJVt88qIHo/3JNf8JInk6RI0PlPbpOHwS2MGJ+BohmPfNoMN7VeOonrxM5HMQJtlcZLSofGjYst5eqM=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by PH7PR12MB5619.namprd12.prod.outlook.com (2603:10b6:510:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 10:27:01 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 10:27:01 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Simon Horman <simon.horman@corigine.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
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
Subject: Re: [PATCH v3 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Topic: [PATCH v3 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Index: AQHZQzPdj7KqV95FHU+oV9+EapzcpK7WRK4AgAFgegA=
Date:   Mon, 20 Feb 2023 10:27:01 +0000
Message-ID: <DM6PR12MB4202E745A9383463723518E1C1A49@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230218005620.31221-1-alejandro.lucero-palau@amd.com>
 <Y/IjIlQSaX6iSmWc@corigine.com>
In-Reply-To: <Y/IjIlQSaX6iSmWc@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4201.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|PH7PR12MB5619:EE_
x-ms-office365-filtering-correlation-id: f24ab5ef-0daf-4a6a-1bd4-08db132d0103
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P0V5qBevRWMtCMd3/Rw5a8gTcDkukpIhjzkSL4NU9W0M/p6B0kx0u/04Ur//Ui5MlVJwLLJ8BZmE3VyPFe2vk2Utx/TYpe+7ByQPMnxlzsVYFPe9zqRpjm5NPqfn67S82geamEbo95dVnYDEWRGqElArGWWCSLjktP3U1cFbASv1fyaZicXXevdKrM1THPQVwRKxy8NZhx0644W3PSH/ZwX+bWTjDTeB/bqOKsKbgVQ+OnkXNzf78GPsZkZtJSS1bCZ+Nh7m2W+lQKWAJ8u4J+myH7yuTzyZpgRV38fuMk9uo1427ggAa8XmrrlEO7Ub2QsilG9bO2P9Ac/mqXDDZXkNLXUcm3G7OGTUpV+4J2ISvGle3zzTP7tUBF1QlxeQqx+1jTow4YMn12gxxJPyHSNiukLbqa/3hjcnL7Kt81GDHa8XiN0p3bQ00u9Frb6bco34vjQ+AeiFXKvhU2RpcTnUYDfRAHvZJQQwJHRTLfg9pIV3X8Bo9nNWbsaw8Ruasxp3sW/28TYGPyjM7CgNxzc0D6N+GmJ09nPllBHg7sYT+NKEO/R0f0/CYkLUfYK9ErazK2d+NaZjtJ0CHN2TAcYcQ30OvQ8UIyxHRxjiuW/ZHsiQFQi9Hpj0ka7DvHNOVUcxYW3KHTts3I5hSvCMDbpBiz+X5WsJ/gq6UZ7kehF00XS6LiSxJF8l5qDBZKJ56C0CBR63wKviYWdpZs3GRXMkugBi4wS7NBwPCcbYqxXyNzG7Mh9j4zKaM7hKZw2E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199018)(110136005)(52536014)(8936002)(54906003)(38070700005)(53546011)(6506007)(6636002)(478600001)(9686003)(38100700002)(122000001)(186003)(26005)(55016003)(83380400001)(7696005)(5660300002)(7416002)(33656002)(2906002)(966005)(71200400001)(41300700001)(66946007)(76116006)(66476007)(66446008)(4326008)(64756008)(66556008)(316002)(8676002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1JIU1VxWTh3UFUxcm1oSkg5b2RWclZIN09rbktsZlFWaFFTR3dJTFYzcVhq?=
 =?utf-8?B?bE4ya2NDdzNqd2x5ZE9uenZFcHd4WUtYMktOVFdEeDlncCtLczNOUEFiMGdi?=
 =?utf-8?B?ZFNwL2NMT1Qrakh3SWRBQVBJU2lPUU1CM0NBRFVrVEIxdURyKzNWRUxmcGoy?=
 =?utf-8?B?bjhEMkdTbGh5enEvaVhYNXFqM2JRcXdKVTFPTElMZnNNNURQWEduY2FJZEY3?=
 =?utf-8?B?WHBDYndERFhNTkJsSDJIWGJ6U3dLanZNNWlEQVFyRmprR0xRZzhZeXRmTjZF?=
 =?utf-8?B?V0pJbExucEo3T1hLNUdkdXpOa3oxYks0N3ozZWRkTm9KOEwyK0hhZCtOZEZE?=
 =?utf-8?B?dDdBaHZmNk5kZVVuR1h5UlRxeTBUb0NVOWcxMFNGSDN6eHFIOWd1ZWV5NWY5?=
 =?utf-8?B?dEQvT1d6YVZkaUU1eWREQ3V0a3locnpPMHNabWJoZm9ES2ppd2RoWFhveXA5?=
 =?utf-8?B?Tm04NUd4bjhyWVgyZnl3SmRVR3h4V2xxbHUzaGd3ODhzOEJZQ3E2eEtxMks4?=
 =?utf-8?B?bWYyQmlyUHdkRTFpSUR1ZU5xOFI2UjlzdTFFMERhWDhORkpXMVNWUXRFdkV0?=
 =?utf-8?B?TGlHeDAwcHNHeWZSZm5sRDFnSHBtV2dBdlNMWnE4dm1za0VXRGkyb1JXZkds?=
 =?utf-8?B?cjlVWURGdytMQVU3QmVFK1ZrWEUrNkNZTVFCZlpYNDhUVkhsNG82TG5xYVZE?=
 =?utf-8?B?dk9kVkJNRmo1OThJdmhpQStVclljL2Noc0xucE1XVEFtQTZoNjU3UmFkNi9v?=
 =?utf-8?B?V0l2NlRxUmhRUDVQcENrWmNWa1lPQ2dSMWZwaFkyN2FJbkppQ2NMbG5sbnhT?=
 =?utf-8?B?SHdtdmNKMnJJdWNBbklsam9aYjJVTDR4by9XNEM2RzlvWjkxbnJrQnA0V2xF?=
 =?utf-8?B?dXBCeUpydEJwbmhsejJaS1Y1MjhFanFCdzNpNmVmOEs0WTExUk5SU3oyRkRz?=
 =?utf-8?B?dk9UWWVTV0JZTnJqRlpUdjhwTi9GUXJHelE1REQ1WXdhY1RFZzJVZjNSY05G?=
 =?utf-8?B?bURGMGNFckt1NGlTc3Uvc1NuN0hzd0dHM09va2FuUkpKamFGNUNFZkpyem1i?=
 =?utf-8?B?SmtQRGtiZWtJUzgwQ2l0QktnWXFNWmdZZGx5L2hnOW4wZnphQSs2Y3ZzeXVk?=
 =?utf-8?B?dkFZc0V3Y3NrZy9KTWNhRElhR2ZNWGVYaGI0NkozaW55VW91R3V4TXd3Uk5G?=
 =?utf-8?B?aFp3Y3pRbGRhZG0zdWcreG1KU0RHWGNNYU5xR3ZBTEluYVJXQ1EwMEtjMk5s?=
 =?utf-8?B?SUZxRkhxOFlyL242aHlGRXduVk1GS3Zpb01DOGd0NUx2UW1lS0REZC8yd2FM?=
 =?utf-8?B?R1lhZ0hoTTdVelphdEtGS3RkYkZ2NWpBQm1KbkRMUmdjMjVGNE1WSENCanVm?=
 =?utf-8?B?cVZvMUtHaCtTQkhsdkRiYU55VWlweURrcStjMkpuY3ZvUDBmOTFVV1I4Uzc5?=
 =?utf-8?B?aXUrRHJUT2hnS05xM1haK01xNVZOTW9pUDFkT0N6ZWx6eTVoNElId0xURytS?=
 =?utf-8?B?WWlMQzdWQktCRTdSOER5UTFlQ1h3bGYrK3lvUnlNZVJNVldNUUordjBnU2c3?=
 =?utf-8?B?SVczdzhEVVM1UEwxdDhaTmZNdWgzdDZYOUVLdmN3aGFGWG5COHpWQStHVitI?=
 =?utf-8?B?ZlIwWEdQdVhCQkxkNHJ5NmVjOHNQUmV1dVRXYVN4NVMxQVBYOVVaQTBSMUZC?=
 =?utf-8?B?MFRnc3EvTWVTMXF3YjA1cHZiNG9RR2lnM0RjYmV0QzhOcTdmalZzem1nU3Vn?=
 =?utf-8?B?OTZnVTc1bnJTZUI3WFh1dEQwcWNtQ0thR29KQXlwZDREb1BjVGw0b0VxNmFT?=
 =?utf-8?B?cVROWjg2YUF3RnZFNzhsb1I0UFhTS0xybXE5c2t5aU04dTZaVnVKaFZBcXN5?=
 =?utf-8?B?V0pMRXVMZlF2MjRwNmdtekc4NTlvOXlzUklFV0NKKzREWTR4aGphVkRaOEFs?=
 =?utf-8?B?dlRuTHhCbWFjZ05jVzZMamt2OFMwQUpuM1FRcFFkTy90amJQdU1NeU95OHRL?=
 =?utf-8?B?dnNmei9Tazltb09sb2ZmQmR5THR6dTBybFlvaWp4RnprRnM3ZDc5NGtEanlR?=
 =?utf-8?B?bTR6Z3FScVZzT0hrcmo0NGpUbjRFSGdVclhWcFA4MHNkZVNUZDY4Y0FkVldu?=
 =?utf-8?Q?5aoA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5401A9B96DCCB246BF5B681FAEAEF6E7@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24ab5ef-0daf-4a6a-1bd4-08db132d0103
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 10:27:01.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJExJ5uGBRJYWxRcba9lX7QPAOEmUchRMkqFJT8FpqiI2erl0xJ1nH7W3WpVEePvNkk0EY1W8iaSpLXHA9A2Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5619
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE5LzIzIDEzOjI0LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+IEhpIEFsZWphbmRybywN
Cj4NCj4gT24gU2F0LCBGZWIgMTgsIDIwMjMgYXQgMTI6NTY6MjBBTSArMDAwMCwgYWxlamFuZHJv
Lmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3RlOg0KPj4gRnJvbTogQWxlamFuZHJvIEx1Y2VybyA8
YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPj4NCj4+IEFkZCBhbiBlbWJhcnJhc3Np
bmdseSBtaXNzZWQgc2VtaWNvbG9uIHBsdXMgYW5kIGVtYmFycmFzc2luZ2x5IG1pc3NlZA0KPj4g
cGFyZW50aGVzaXMgYnJlYWtpbmcga2VybmVsIGJ1aWxkaW5nIGluIGlhNjQgY29uZmlncy4NCj4g
SSB0aGluayB0aGlzIHN0YXRlbWVudCBpcyBzbGlnaHRseSBtaXNsZWFkaW5nLg0KPg0KPiBUaGUg
cHJvYmxlbSBtYXkgaGF2ZSBtYW5pZmVzdGVkIHdoZW4gYnVpbGRpbmcgZm9yIGlhNjQgY29uZmln
Lg0KPiBIb3dldmVyLCBJIGRvbid0IGJlbGlldmUgdGhhdCBpdCBpcywgc3RyaWN0bHkgc3BlYWtp
bmcsIGFuIGlhNjQgaXNzdWUuDQo+IFJhdGhlciwgSSBiZWxpZXZlIHRoZSBwcm9ibGVtIGlzIGJ1
aWxkIHdpdGhvdXQgQ09ORklHX1JUQ19MSUIuDQo+DQo+IFNvbWUgYXJjaGl0ZWN0dXJlcyBzZWxl
Y3QgQ09ORklHX1JUQ19MSUIuLCBmLmUuIHg4Nl82NC4gQnV0IHNvbWUgZG8gbm90Lg0KPiBpYTY0
IGlzIG9uZSBzdWNoIGV4YW1wbGUuIGFybTY0IGlzIGFub3RoZXIgLSBpbmRlZWQgSSB3YXMgYWJs
ZSB0byByZXByb2R1Y2UNCj4gdGhlIGJ1ZyB3aGVuIGJ1aWxkaW5nIGZvciBhcm02NCB1c2luZyBj
b25maWcgYmFzZWQgb24gdGhlIG9uZSBhdCB0aGUgbGluaw0KPiBiZWxvdy4NCj4NCj4gSSB0aGlu
ayBpdCB3b3VsZCBiZSBoZWxwZnVsIHRvIHVwZGF0ZSB0aGUgcGF0Y2ggZGVzY3JpcHRpb24gYWNj
b3JkaW5nbHkuDQo+DQo+IENvZGUgY2hhbmdlIGxvb2tzIGdvb2QgdG8gbWU6IEkgZXhlcmNpc2Vk
IGJ1aWxkcyBmb3IgYm90aCBpYTY0IGFuZCBhcm02NC4NCj4NCkhpIFNpbW9uLA0KDQpJIGFncmVl
LiBJbiBmYWN0LCBJIGRpZCBub3QgaW5pdGlhbGx5IHNwZWNpZnkgaWE2NCBpbiB0aGUgc3ViamVj
dCwgYnV0IEkgDQpnb3QgYSB3YXJuaW5nIHN1Z2dlc3RpbmcgbWF5YmUgSSBzaG91bGQgZG8gaXQu
DQoNCkkgZ3Vlc3MgdGhhdCBzdWdnZXN0aW9uIGlzIGxpa2VseSBkdWUgdG8gYWRkaW5nIHRoZSBS
ZXBvcnRlZCBhbmQgTGluayANCnRhZ3MsIGJ1dCBhcyB5b3Ugc2F5LCBpdCBpcyBub3QgZGVzY3Jp
YmluZyB0aGUgcHJvYmxlbSBwcm9wZXJseS4NCg0KSSB3aWxsIGNoYW5nZSBpdCBpbiB2NC4NCg0K
VGhhbmtzLCBhbmQgdGhhbmsgeW91IGZvciB0ZXN0aW5nLg0KDQo+PiBSZXBvcnRlZC1ieToga2Vy
bmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+PiBMaW5rOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjMwMjE3MDA0Ny5FakNQaXp1My1sa3BAaW50ZWwuY29t
Lw0KPj4gRml4ZXM6IDE0NzQzZGRkMjQ5NSAoInNmYzogYWRkIGRldmxpbmsgaW5mbyBzdXBwb3J0
IGZvciBlZjEwMCIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5k
cm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc2ZjL2VmeF9kZXZsaW5rLmMgfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhf
ZGV2bGluay5jDQo+PiBpbmRleCBkMmViNjcxMmJhMzUuLmM4MjkzNjJjYTk5ZiAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+PiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gQEAgLTMyMyw3ICszMjMs
NyBAQCBzdGF0aWMgdm9pZCBlZnhfZGV2bGlua19pbmZvX3J1bm5pbmdfdjIoc3RydWN0IGVmeF9u
aWMgKmVmeCwNCj4+ICAgCQkJCSAgICBHRVRfVkVSU0lPTl9WMl9PVVRfU1VDRldfQlVJTERfREFU
RSk7DQo+PiAgIAkJcnRjX3RpbWU2NF90b190bSh0c3RhbXAsICZidWlsZF9kYXRlKTsNCj4+ICAg
I2Vsc2UNCj4+IC0JCW1lbXNldCgmYnVpbGRfZGF0ZSwgMCwgc2l6ZW9mKGJ1aWxkX2RhdGUpDQo+
PiArCQltZW1zZXQoJmJ1aWxkX2RhdGUsIDAsIHNpemVvZihidWlsZF9kYXRlKSk7DQo+PiAgICNl
bmRpZg0KPj4gICAJCWJ1aWxkX2lkID0gTUNESV9EV09SRChvdXRidWYsIEdFVF9WRVJTSU9OX1Yy
X09VVF9TVUNGV19DSElQX0lEKTsNCj4+ICAgDQo+PiAtLSANCj4+IDIuMTcuMQ0KPj4NCg==
