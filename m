Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E275968DBE6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjBGOny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjBGOnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:43:35 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598DE7693;
        Tue,  7 Feb 2023 06:42:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQJ9LiUsGa0SaCmaAyayCbWFoSMc3UwqNjbyd9xgg52G4Tu6kiRVnhmiDEvcOVM5CaL9ChDzZ7e4ePwKdgBgcpOiBLOQzAEO5+ULG+mkMBqVQI2u0WRNi3JPl4nf3cZ6Up2PEZkEa9W37BkG1TWPPhgiUCmM2qJqQtgJg+NfyPJjFBDAvBFWGwpxMR5vOR8nWi4bEL8H+XzPqhPciEBOksVNBQz1bv7irdhwxYacWMLJGYFiVt9JNaZhV+aZ4TMAxgHtzt3WlN7/nXA7VZO44/UQ+vLYCoa7GSIBHHx+eIG9jXivHr4XDSd3wwY6m3h7fJ7UvCS4DM/UoGheJgOZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1UFt7xbvvsQ22L8nLhpDCkxurfWjd69+KCmUxaH/dw=;
 b=n0C9ipVY+YkJpx1lmKp8VGtd2lHBMXWnRFpVMj1ahAV/oqo0G71siid8fbxRODTl3fp70jX2cfRVKfVMHL6JRLpXNQWSAkocCBLxWB1ctyuKLPTpnIKzMLHdrc2+G9eu74OEUt8Jw45TDZyKz62npsofu7grIQ4kD9Rxf9P3SeO9kPuvlJe9ToYUA9tzzoNk9DXn/t/rHvbO1C9CuWttkf3tTdsCnLeQg4BnUYFF9jmyOXoXxLMH3taQacil23ueQaX8tbZkKNZLyqdX7rfSWLQQul+eleREIqf2m/SEnkCK9Koka1WdnDOUAzq0d5qwn/02pMWd8tu7ITdyvmvK0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1UFt7xbvvsQ22L8nLhpDCkxurfWjd69+KCmUxaH/dw=;
 b=QoV0c9Q6Jh/bNpeH+eZ+sAOo/X/1/2YjCYKMr8yitJnPVXRlZpWsVxrGCoos0MffBQSLxn7woF5XZIIH+EgaXydP2MHOdbnLQB/vPoprpHvkF6Gq2v4za64sdKLhUgDkeW3snErsYwnnsXrpe01mXqhrTuvm2s9SZ30oqvKYDWc=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SA1PR12MB7317.namprd12.prod.outlook.com (2603:10b6:806:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:42:45 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 14:42:45 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
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
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZNveRaZV2migBBki/Fbor0TTGVq67jUyAgAgJY4A=
Date:   Tue, 7 Feb 2023 14:42:45 +0000
Message-ID: <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
 <Y9ulUQyScL3xUDKZ@nanopsycho>
In-Reply-To: <Y9ulUQyScL3xUDKZ@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4202.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|SA1PR12MB7317:EE_
x-ms-office365-filtering-correlation-id: b21a1555-bc8b-4b88-9e09-08db09199374
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uE2PcMzF59wYFvxnhVv6yY578ZfcTCsjyBLDb2ON7fJqQplFxtp8N1ououQVCuXLU3AjlMh3thE/eXffqF76jjfiOdskwTgEpTATCKj2w21Ks/+IW2LuvyyWvC0yhDB85SFc/UIW2rwFD6Jqqop/t1Jx3WJlwJkSPZRx9ENou/Em+CFJbzWbG+/R7nNPLMunVEy2DejpHh3Lrw0n8kgWkfHtg4RQhd1pk5cT7N2F8eSFNByxrutsQl4by7xbLuaECSyCRCjWGiTbGD68Kds4AtDtsCUXfbkxY+2hYAkPgCgnUR0ADecRyk09kTbryPjQvl0qXc5KvidJCP+W/6+7U1/8F4/rofPHeS7ozju3i/P4ERR4+NH9NlJivxdCujehQigh7uSIM9uUTarnxAPD5D3ijIFoNO3CUJ+RtoC/V2ZZIY+yKw4wP/VASNI8wjKtIi9vebiSmyRrhPyY7/CLtJ6r0KD1gk2/eFabXdSej+rNgw1pWYMAytp7Sw7fXyZEKjtLD9KzjTuz/rvQzLAYmK5D8ngNs3yo04dbGYP4aOdDfoZ0NRXEuzfMmivsPgNn+QP8RTeHIipZmG+eUXCk7Ca7z6FhDE0TszVI5BpQvtVKAZtROuemujoNVVyKJYqL7GRECjwMHgVsNlWygur4lXpd96NEnY8nB1sBBb3ELrescuYlnT5XKeExWJ6rK9U1OyyK5gUyfUicFq9PFYTYA/Y2a9u2lo7ZUPUJSoaMPsTn+Hj4rMCxpe1hnzEdHziA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199018)(122000001)(38100700002)(71200400001)(2906002)(7696005)(26005)(9686003)(186003)(53546011)(66476007)(41300700001)(6506007)(8676002)(316002)(76116006)(64756008)(66556008)(4326008)(66946007)(478600001)(66446008)(7416002)(54906003)(110136005)(8936002)(52536014)(5660300002)(6636002)(33656002)(38070700005)(55016003)(83380400001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTYxVVNXYWRGOVlZOEZqQytKVE9TQ3VMcmJ0TjdXOTlkY0kxVFZVV0pVNXhR?=
 =?utf-8?B?Wm10UDMwdGMxWE1aZHJ4TVZkUW5ReUNmUXVvRE5GYUNJMmFBR21XcVVvR3dM?=
 =?utf-8?B?dit5OGt4cGkwMEhPbG90UHR3TW9Rdy9ad2NPc25pZ1JpRHB3alRtSVpKWDZ0?=
 =?utf-8?B?bStheFdCd2ZxZjRBMjE2Q01PTjdjV0tkRjF3WVBTTVcxbUZDUXd2aE5FdXM2?=
 =?utf-8?B?ZHFRYmlqTExERDY4WEFZbW11bVZXTEhqbTFLbFR6aWFtaWxnWXFFdlVsQ2Nw?=
 =?utf-8?B?VFYrSU45TUlMcVdMOTJmQnR2ZUQ1WVZGQ1BsbjNiVWJLQllYaXRkOTZMVlgw?=
 =?utf-8?B?ZytXTlcvMEs4cHpEblFtcnRyekVIRXpvSUtkWVhiNG9WbitLWGZzZjZpbitn?=
 =?utf-8?B?eHk3Z3p4eHkzd09BL2JMQmJxaDhtTCtCcWVrOGk3SFd0KzNJNTYzYXQ0MGJn?=
 =?utf-8?B?Tk1FQWlIMUh6U3NjVDl6VVhPTjFOZmhaWk5mNU9weUVyNlhJenNTaUQvdG02?=
 =?utf-8?B?Y2NUWExXMEFmRCs3TEQzdVlmYWM0VUQ5eFpHZ3FsU2RCNmc3aEM4dUNYTUJ1?=
 =?utf-8?B?dXhzQmNMSEpPb1E1a01XMVQ4SFE4Nkd4SmtCdncxLzljdFBGS2dkdkhjcmlP?=
 =?utf-8?B?VVprQ2pMNnJmVjlFRGlMVktJd3k2UXFXSFk5YzZYSkQ4Wk13dlczTE5qT21H?=
 =?utf-8?B?MGREZmxIemwwdG5zcC9oSHkrVnRISWhLNHpCakpnekRqMElBWmRWNWhyRi91?=
 =?utf-8?B?czBpWjdRWVEydFJlUmNmenJVZzQ4WlF4YldaRjVORGZ0b09WZVI3VVJnSDNR?=
 =?utf-8?B?ZVJiRDhTeTRWYjNlR2tlYmNVWmF0MHFiZFUrbm5wbUFacHV4eUh1REoxRmFp?=
 =?utf-8?B?OG0xZCs5Z2ZxYkpySyswc3IxUStKcE5lcUhPcmdUZzJwRXZBRWF2SnNQWEk4?=
 =?utf-8?B?NjlrajNwUXRVUkFvVDJLVXM0dXFuSWJvV2ZmSU11bGNIOHliSmN2Tk9SclA4?=
 =?utf-8?B?VldPWDJDa2JIclFraDcxbVRreUFiWmM4eE40NElLa0tVSFkxRENscnNoaHlj?=
 =?utf-8?B?U3ZBZXpUMUZDZnlmakZBQUt1VGN1cFluQ0Fnb0sxNnJrU0Fkbk92MHlVdG1u?=
 =?utf-8?B?d01KVkxIYy9Ka1ZLbno5TXpvSGtSeDE4aWo5bnRWNlVIYTJGeHRvbUNJd2o4?=
 =?utf-8?B?MDltTlhUdHl1a1ZKcWR6VWIzcTFLZ3R6Zkc3cktkQUZPaU5OUmphQVBTUzMx?=
 =?utf-8?B?R0FGVGJUeTVmOHBML202cGQ3RzJKK2V4L0wxNS9VcW1ZWEEwSmJmc2MzQWpL?=
 =?utf-8?B?SE80ci9LRTlidnhpSVEvNy94eUYwYncySis0ZzdwZVBuWmc1YlNoM05VRVlN?=
 =?utf-8?B?RHkxYkJLQk55Tks1aG1uNW94RU8xd2NWaURWNUJCSGwxVVQ4cVBUMDBPeGFw?=
 =?utf-8?B?ZEUwTHVreGd0TnI5MkFJOFVUSDlGS3dkTjYwUEp3Y1JHYnU0Y2dHYUdvUXVK?=
 =?utf-8?B?NjZNK0NMU0s1NlF6TzVUTGx1d3NWS09tOWhQQTFXc1ZsUUk1dWV5YmVYZ2ZX?=
 =?utf-8?B?Zmx0TU5CQUZmSE55TGg4KzU3dUlxY3BweUVxWUFiZkFkRXhPZnAwNURCVUFP?=
 =?utf-8?B?VE0yWWp0Q2ExSzRGSUFVOXFBT1FHMTIzVzBIYXAxYUpKWjNwV29zZjJwNG9x?=
 =?utf-8?B?ZlBZWWwwZit6SEplWFVlNmFjN0E1VDRhUGVPcC8vV2pXSm90dTR5aWR2OVNw?=
 =?utf-8?B?NEdrVWlvT3B2VG9mK2QrMkVFeGRxYXVTb2dGcDlGdUZ4bFFONzRZUldFK2dT?=
 =?utf-8?B?NVcyTWdCcFQwK0ZpakhDdG5LVW8wZ1NmRFREcG1oWS9HOXV2RUtENU0vVFZR?=
 =?utf-8?B?RU1wVDl0bzdtSkFtS1FPVW5vaHVidTVkKzAyeHFtZmp2Q2ttRGVpZmptZDAv?=
 =?utf-8?B?SWp6bHFDaXUyUXErUkdwVjBwczBKWk5rV3MwZ2FYOU9iZHByTllSc2ZPeTIx?=
 =?utf-8?B?NXNybzA3RDRJU2VrelAveDd1OExrVC93VXhzTVNtaFhjeHgyaHhacURKaVpp?=
 =?utf-8?B?dUpQdE04MExWdFJLTTJIZ0ZOa1Q3eS9ud0VnRHpLSFZmYkJZNVRtZHdUa1l2?=
 =?utf-8?Q?8BFM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F812C03E7F9B384DB9BE8608C9079EFB@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21a1555-bc8b-4b88-9e09-08db09199374
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:42:45.5626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d+vcbKjOPi5fhuae91ZAxNi3NbHB1JXQuLZhO4rjNTIGRM+CYl6KM1SJxJJcGiz4Sy9+b6IpHKEiVtjji/I/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7317
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzIvMjMgMTE6NTgsIEppcmkgUGlya28gd3JvdGU6DQo+IFRodSwgRmViIDAyLCAyMDIz
IGF0IDEyOjE0OjE3UE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5j
b20+DQo+Pg0KPj4gU3VwcG9ydCBmb3IgZGV2bGluayBpbmZvIGNvbW1hbmQuDQo+IFlvdSBhcmUg
cXVpdGUgYnJpZWYgZm9yIGNvdXBsZSBodW5kcmVkIGxpbmUgcGF0Y2guIENhcmUgdG8gc2hlZCBz
b21lDQo+IG1vcmUgZGV0YWlscyBmb3IgdGhlIHJlYWRlcj8gQWxzbywgdXNlIGltcGVyYXRpdmUg
bW9vZCAoYXBwbGllcyB0byB0aGUNCj4gcmVzdCBvZiB0aGUgcGF0aGVzKQ0KPg0KPiBbLi4uXQ0K
Pg0KDQpPSy4gSSdsbCBiZSBtb3JlIHRhbGthdGl2ZSBhbmQgaW1wZXJhdGl2ZSBoZXJlLg0KDQo+
PiArc3RhdGljIGludCBlZnhfZGV2bGlua19pbmZvX2dldChzdHJ1Y3QgZGV2bGluayAqZGV2bGlu
aywNCj4+ICsJCQkJc3RydWN0IGRldmxpbmtfaW5mb19yZXEgKnJlcSwNCj4+ICsJCQkJc3RydWN0
IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGVmeF9kZXZsaW5r
ICpkZXZsaW5rX3ByaXZhdGUgPSBkZXZsaW5rX3ByaXYoZGV2bGluayk7DQo+PiArCXN0cnVjdCBl
ZnhfbmljICplZnggPSBkZXZsaW5rX3ByaXZhdGUtPmVmeDsNCj4+ICsJY2hhciBtc2dbTkVUTElO
S19NQVhfRk1UTVNHX0xFTl07DQo+PiArCWludCBlcnJvcnNfcmVwb3J0ZWQgPSAwOw0KPj4gKwlp
bnQgcmM7DQo+PiArDQo+PiArCS8qIFNldmVyYWwgZGlmZmVyZW50IE1DREkgY29tbWFuZHMgYXJl
IHVzZWQuIFdlIHJlcG9ydCBmaXJzdCBlcnJvcg0KPj4gKwkgKiB0aHJvdWdoIGV4dGFjayBhbG9u
ZyB3aXRoIHRvdGFsIG51bWJlciBvZiBlcnJvcnMuIFNwZWNpZmljIGVycm9yDQo+PiArCSAqIGlu
Zm9ybWF0aW9uIHZpYSBzeXN0ZW0gbWVzc2FnZXMuDQo+PiArCSAqLw0KPj4gKwlyYyA9IGVmeF9k
ZXZsaW5rX2luZm9fYm9hcmRfY2ZnKGVmeCwgcmVxKTsNCj4+ICsJaWYgKHJjKSB7DQo+PiArCQlz
cHJpbnRmKG1zZywgIkdldHRpbmcgYm9hcmQgaW5mbyBmYWlsZWQiKTsNCj4+ICsJCWVycm9yc19y
ZXBvcnRlZCsrOw0KPj4gKwl9DQo+PiArCXJjID0gZWZ4X2RldmxpbmtfaW5mb19zdG9yZWRfdmVy
c2lvbnMoZWZ4LCByZXEpOw0KPj4gKwlpZiAocmMpIHsNCj4+ICsJCWlmICghZXJyb3JzX3JlcG9y
dGVkKQ0KPj4gKwkJCXNwcmludGYobXNnLCAiR2V0dGluZyBzdG9yZWQgdmVyc2lvbnMgZmFpbGVk
Iik7DQo+PiArCQllcnJvcnNfcmVwb3J0ZWQgKz0gcmM7DQo+PiArCX0NCj4+ICsJcmMgPSBlZnhf
ZGV2bGlua19pbmZvX3J1bm5pbmdfdmVyc2lvbnMoZWZ4LCByZXEpOw0KPj4gKwlpZiAocmMpIHsN
Cj4+ICsJCWlmICghZXJyb3JzX3JlcG9ydGVkKQ0KPj4gKwkJCXNwcmludGYobXNnLCAiR2V0dGlu
ZyBib2FyZCBpbmZvIGZhaWxlZCIpOw0KPj4gKwkJZXJyb3JzX3JlcG9ydGVkKys7DQo+DQo+IFVu
ZGVyIHdoaWNoIGNpcmN1bXN0YW5jZXMgYW55IG9mIHRoZSBlcnJvcnMgYWJvdmUgaGFwcGVuPyBJ
cyBpdCBhIGNvbW1vbg0KPiB0aGluZz8gT3IgaXMgaXQgcmVzdWx0IG9mIHNvbWUgZmF0YWwgZXZl
bnQ/DQoNClRoZXkgYXJlIG5vdCBjb21tb24gYXQgYWxsLiBJZiBhbnkgb2YgdGhvc2UgaGFwcGVu
LCBpdCBpcyBhIGJhZCBzaWduLCANCmFuZCBpdCBpcyBtb3JlIHRoYW4gbGlrZWx5IHRoZXJlIGFy
ZSBtb3JlIHRoYW4gb25lIGJlY2F1c2Ugc29tZXRoaW5nIGlzIA0Kbm90IHdvcmtpbmcgcHJvcGVy
bHkuIFRoYXQgaXMgdGhlIHJlYXNvbiBJIG9ubHkgcmVwb3J0IGZpcnN0IGVycm9yIGZvdW5kIA0K
cGx1cyB0aGUgdG90YWwgbnVtYmVyIG9mIGVycm9ycyBkZXRlY3RlZC4NCg0KDQo+DQo+IFlvdSB0
cmVhdCBpdCBsaWtlIGl0IGlzIHF1aXRlIGNvbW1vbiwgd2hpY2ggc2VlbXMgdmVyeSBvZGQgdG8g
bWUuDQo+IElmIHRoZXkgYXJlIHJhcmUsIGp1c3QgcmV0dXJuIGVycm9yIHJpZ2h0IGF3YXkgdG8g
dGhlIGNhbGxlci4NCg0KV2VsbCwgdGhhdCBpcyBkb25lIG5vdy4gQW5kIGFzIEkgc2F5LCBJJ20g
bm90IHJlcG9ydGluZyBhbGwgYnV0IGp1c3QgdGhlIA0KZmlyc3Qgb25lLCBtYWlubHkgYmVjYXVz
ZSB0aGUgYnVmZmVyIGxpbWl0YXRpb24gd2l0aCBORVRMSU5LX01BWF9GTVRNU0dfTEVOLg0KDQpJ
ZiBlcnJvcnMgdHJpZ2dlciwgYSBtb3JlIGNvbXBsZXRlIGluZm9ybWF0aW9uIHdpbGwgYXBwZWFy
IGluIHN5c3RlbSANCm1lc3NhZ2VzLCBzbyB0aGF0IGlzIHRoZSByZWFzb24gd2l0aDoNCg0KK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTkxfU0VUX0VSUl9NU0dfRk1UKGV4dGFjaywNCivC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgIiVzLiAlZCB0b3RhbCBlcnJvcnMuIENoZWNrIHN5c3RlbSBtZXNzYWdlcyIsDQor
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIG1zZywgZXJyb3JzX3JlcG9ydGVkKTsNCg0KSSBndWVzcyB5b3UgYXJlIGNvbmNl
cm5lZCB3aXRoIHRoZSBleHRhY2sgcmVwb3J0IGJlaW5nIG92ZXJ3aGVsbWVkLCBidXQgDQpJIGRv
IG5vdCB0aGluayB0aGF0IGlzIHRoZSBjYXNlLg0KDQo+DQo+DQo+PiArCX0NCj4+ICsNCj4+ICsJ
aWYgKGVycm9yc19yZXBvcnRlZCkNCj4+ICsJCU5MX1NFVF9FUlJfTVNHX0ZNVChleHRhY2ssDQo+
PiArCQkJCSAgICIlcy4gJWQgdG90YWwgZXJyb3JzLiBDaGVjayBzeXN0ZW0gbWVzc2FnZXMiLA0K
Pj4gKwkJCQkgICBtc2csIGVycm9yc19yZXBvcnRlZCk7DQo+PiArCXJldHVybiAwOw0KPj4gK30N
Cj4+ICsNCj4+IHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGV2bGlua19vcHMgc2ZjX2Rldmxpbmtfb3Bz
ID0gew0KPj4gKwkuaW5mb19nZXQJCQk9IGVmeF9kZXZsaW5rX2luZm9fZ2V0LA0KPj4gfTsNCj4g
Wy4uLl0NCg==
