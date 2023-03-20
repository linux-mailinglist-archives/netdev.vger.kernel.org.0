Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF146C1904
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjCTP3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjCTP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:28:54 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020014.outbound.protection.outlook.com [52.101.61.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA95B3846E;
        Mon, 20 Mar 2023 08:22:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuFTlh5y34GnUVvrq8uEsGxH4TABZXCZwsMXLy2PE7XhtZkh4yGk0XX1PSSbSmYKE4WjsyNld0y/ghvzZJJYcnSDYlBKWG3HwjDUQoSTnzeT0H81BVbldfLO6vNHMgKHuOa3sNPGggYYYbNm0Sdb7A2Gtqvl+BAHHEtHrjPrFC4oP2WufnaG83zHj66AZkpGwhSWKTDxNcyrSKDtmyzgt2E+/RLHVrs4rkDuNWahgD8QzDRx00vaE0AVmKDURaEVNpIhU2DUbJ+srK2yC/twGslmmkyts7RhGpmWS3blC6m93suCrBdFJvCZlnRvS/urHv7QIN1dNxfpJgH6Q3Kcsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5H0PK53BGZWneZmjLL40ytiq/WO6fMx3ANBA0k9fYI=;
 b=FLlKDM3/8ylv33ceQJ5mhmH0p//5ib1/X8LZLRn5GExxDEWuQB5KRYYKsSRCHtT5FGA6d0BaSNkyWO/AJQOXT+oLA3O12Sg2fB6DJUsAoTQsjyF1zGN4UWsJdwufIL3fAHdWVbAfTsjylUBwdmlNvHrvReSERjQrrVD3NeQDj7qplQaTE+E07y3xHBIG+IgYbrV2Eg3A0ed0dWrzx0nsV+QwCcXn4hZ3MOAQYq0scxQ6jHeVHZk1Mo7tyVB4PkqbyVc7AF5JDM++YFjUdWBed5eaESARYKW0cNPoKXQzwPlvs66pPa6JxvWap50XD/nFB84Xg8X3XIqUh0QyBJLYfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5H0PK53BGZWneZmjLL40ytiq/WO6fMx3ANBA0k9fYI=;
 b=RfEouolzefzosFjIxPDs5yDJjl0nOfV6NnQYobWW+73m+Gjxp/O4tWpIyRlfqJrWukwRclca31NQs34a+78StgEMb3sqHQyiGZXPDBrjg91k2uw4JRtar8fPDtYrZYbje3Z6o9AZ0EuN5328fkWbvYInsH5j1DWKBibH9NaS9OU=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by LV2PR21MB3228.namprd21.prod.outlook.com (2603:10b6:408:175::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.1; Mon, 20 Mar
 2023 15:21:45 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6254.000; Mon, 20 Mar 2023
 15:21:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Index: AQHZWqm9UOpmxqzZvUOZ7L83A2HDza8Day6AgABc4jA=
Date:   Mon, 20 Mar 2023 15:21:45 +0000
Message-ID: <PH7PR21MB3116E1C8D5F32651FC13B5D2CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
 <fb5abef7-8f52-007b-f058-85f580aefc88@huawei.com>
In-Reply-To: <fb5abef7-8f52-007b-f058-85f580aefc88@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5a7c3e88-eb4c-4929-90c0-fdd0df94f321;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T15:14:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|LV2PR21MB3228:EE_
x-ms-office365-filtering-correlation-id: c7f10f15-bd1c-4470-2301-08db2956d0e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s4DCDq8taTFJSn5ypmZGPahgy+qe1y4F2llhsqG3zWNeYet3t1IzAZFf7jXiLx+jl0UlG4GpmKO9lf9Bo7sGFjLheHAjRVSNXgY17K1Zy0FrCvIOoih5P1TCtB92Uhkwg5Yoxeu7/Fc4l9QGeE2NgElkZkAEKOCmBI7b9IoNVJOT+J1PSNiIJ15n69PVfVZ1KzkIka3ll93ruLfpzhiDG10xqboHN42wn51nArMjJpieOPp435ij3tocjlbRE9C0+gzzCyaga9TI77+/jhppXeBeMBUnPNL31y0/em96XWB7T2L0ntVgW1nEbyB+q+HiaBGb6vma9NsMqrdKp5P6muPaTcpaBTfe8r+yVaUJQj5+sxKC3oGb4oOd0WiakJiwJJuC5ceig2YqIajpQ+7Faz6B1Xdb3wAuy32FKTsBqexHv0O81oy0woai0eazV/oBq0sHQvAoQIscTgxwkHQFJwvBUrr2uKhQ2bnfhY18hLA76zfjGmTJQlz2pAvMqBt2ATiLh8LbUd0GHgdt96eRJWaZc6+yIxyDPLooPHhMIb70Oa9KBYWzVv+dCReXa3DT8YW7/GISc+pb16TLaefwphf8kmJO4yYDut90P9Gn5mnGMWi7+KbrC6uh1IzWfgYbFF14C+ytvJeFYLqfOeiWKd3Y+Y6a6VSInDfFNY/fnhdDnkqjB1A/1KMGOTslnstX8SdwL/v9X5DzU/FsGqvMvQwcaNfK8LPIRsT1eroIJdVYqVK+66jSFakvlp/1U+74
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199018)(64756008)(41300700001)(4326008)(66476007)(66556008)(66446008)(66946007)(76116006)(8676002)(83380400001)(5660300002)(38100700002)(316002)(82950400001)(54906003)(82960400001)(478600001)(55016003)(10290500003)(110136005)(122000001)(33656002)(86362001)(71200400001)(9686003)(26005)(186003)(53546011)(6506007)(2906002)(7696005)(8936002)(7416002)(52536014)(38070700005)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVFPWDFXTDd2V1FuQXYyZHRmY1BWQ0d4MWpsYWwyOXFOaFM1bjJud2I1b1hx?=
 =?utf-8?B?Yk85K2dLdlNjaHZ1ZGoxL1BBMXg0WVpWYlpKRnRMMTJ6S0ZTUTZCbUxlckdX?=
 =?utf-8?B?UGJFNzcyTTM4MUg1ZndFdUdkZE9JWUN0U2xTRklodWQ5a2tRMHV5dzQxc2V6?=
 =?utf-8?B?K01peDdrYkd2SkFEUWRmUHhJOHZpaVFqT2NLMnVtTUNRUjVuQWhUZ3V4RVJ3?=
 =?utf-8?B?R2h6RDFaNlo2OHJZWERna0hsY21ZWXBuVDZPVnU0ODkvMTdZZlg0eWJDNHN0?=
 =?utf-8?B?aUJFTEw1S0kzZkZwK2Q0RHl0NFNpcTFlSnpWMVRQNmN6d3dkOGhoaERaTSto?=
 =?utf-8?B?QXdOalVZcERoR1lvQklmQzRsRHpRRGZxdlAwQlhKdUJkWWdKMHh0VllQKzRp?=
 =?utf-8?B?eXhGVjZwaENDWUN5ekc3SHpIcnFVbHYyYWpjTWNoQVI2VytLY3hYVURudmJZ?=
 =?utf-8?B?MlZkRXV5OVQxN0Q0cWNkd0cxT3BWTHdBckdPMFhGWUFoUWpWU09qMFRkSjhm?=
 =?utf-8?B?MFJYeEh5aDNzZmpwbjBieEh1SUhkY3FwYXJuYlhOcWJsRnVKOFpwRlYrL0k3?=
 =?utf-8?B?Uk9yS3MwWjMrZlp2dWNXeWNkVXN3RjFaNmFMelZSSjZjSWZ1LzcvYVNJOGZ3?=
 =?utf-8?B?MTNmenFzbkdaTUJjUFNyYjlkS00vWmwwY3U2eHk0NDh1UjhmVks1YlhSV1Av?=
 =?utf-8?B?ZHRXek1CYmRZS2J3elNHcFNHT1lpL0VsS2lmMHAxQ1ZiQ2FuSFFFbzBnTzBw?=
 =?utf-8?B?dVF3cUIvNC85ZkgxVDhGSHZZdXAzTWdZUnViZUVtc1dpMXVTMGM5cTdlOHhu?=
 =?utf-8?B?V2JkRVIzU3kxRXhhVy9lNG1Sa2Q2a3IzdTArT0V6eVZ0T2ZENDVBOXNGd2pv?=
 =?utf-8?B?Y3U2UVcyY1BNb3ZVcWJ5cW1DVHdhZU1vNm80bzZwRzFoZ3ZSeWorTi81Y1JH?=
 =?utf-8?B?aVlYbngxNkFTZ05ZbFRzdWVwVWpDakoybHBoWTUwbCtZRElYNTJiM1VXVFFV?=
 =?utf-8?B?azA5anphT3pveUZZVGxZVDdOTkxvS0JJcDArUHRGOWFhT3NDWGZPQTNRb29S?=
 =?utf-8?B?bVVQT3hhRFE2V1gzckhZSWNDclFJcXpDUVp1cm5kT1k4UmxEMmk4VzVvaUsv?=
 =?utf-8?B?MVNKZFNVVUMxRS9ITGtKVWc2TVFldWsyT2lCZ0V3Tmovcy9tcEVoekFOUVNy?=
 =?utf-8?B?WTQxbzMrN0dhemRmQWd2ZHgzT3JhZkdEOGhuQlUzNkdBcGVwMmVjYWwycGc4?=
 =?utf-8?B?WmpMajQ1d2tnNldaRGcrUDY3K000RTk5U3YwVFhjMjJRZHlWK0tEMlBlNUJD?=
 =?utf-8?B?eVQ5SEd4UTdWTmhwR0QxTXpqc2gvRG5aRDVPK0dkb0hlYVdTSENnYXhRRndw?=
 =?utf-8?B?SjlKeDYveVlWc0toR1oyMkN1bzRxc0FpZmYweWk2cmlxeUs0cHYrVVpaVnBo?=
 =?utf-8?B?dGpxRzd0dVpFYWJSa1VNTEprdmY3RFl5LzFqekx3MHFnUWlQejhBWXpuT012?=
 =?utf-8?B?eGppUERhZEM0cEQ4aVVXVGlOZWtDS2NUdjdac056RDNjbm56SDg1bUM2aW1C?=
 =?utf-8?B?OGlUSnRHZklrblIvM3liMFhnMDJ2SzI0d1FmZnJWRml1OXVYTU10emVDVlFs?=
 =?utf-8?B?YmljbWJJcWpSbmtjVW5IdC9rZjFhQ0xXdzdON05CM2RQcS9LZk5ITDZPZDFs?=
 =?utf-8?B?WXMrS2o3Q1Z2clVUcDBVSzNsQ3AvakhQOHVNU00zcWJXc0huVnZpczdSSWZy?=
 =?utf-8?B?aEpJK2NRamdsQjBlWEVYY0dLczExVm5xOXg5Y3pKWGkvaWo4WCtHNUxtZ0RY?=
 =?utf-8?B?ZDV2ZDV4Vm5XQjRNVjZHK0l3RjV4L2NRajlDbGVQT3grOUJUVnZiK0RBSWNC?=
 =?utf-8?B?MVBLdkJicEhOdnFIcm81TjdCVlBrYU1RKzljM3Y5RHBaaHlsejB1WTNYRnVD?=
 =?utf-8?B?STlUbDhZeWJmdEpaRmtPWi9pTjlnZUlqWFBXUE55S3A0STA3V0c0NjZPOGxr?=
 =?utf-8?B?M1Q5M3YwQUxEYnQ5YzhjaG5CSm55a3VXeGFBR2RoM1U1OEZ5QVFRTC9rdk1X?=
 =?utf-8?B?WTJ5MkZRM1FxbEFvaDcyY3Zoc1JEZ0Z3bDFoTlYrT2FZVGtKR0hJWllhWDRl?=
 =?utf-8?Q?LmaC1PTUWMiqRRfkqzZSdGI4x?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f10f15-bd1c-4470-2301-08db2956d0e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 15:21:45.1404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ISSI69HD7de19Jwjks24GcjIN3ICkCy3U2djh3XHLFeEDkMfRzFjEdcvG5tZZsHOcSb0p1NFndjcFvhdv3z6xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3228
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWXVuc2hlbmcgTGluIDxs
aW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBNb25kYXksIE1hcmNoIDIwLCAyMDIzIDU6
NDIgQU0NCj4gVG86IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBsaW51
eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbiA8a3lzQG1p
Y3Jvc29mdC5jb20+Ow0KPiBQYXVsIFJvc3N3dXJtIDxwYXVscm9zQG1pY3Jvc29mdC5jb20+OyBv
bGFmQGFlcGZsZS5kZTsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgd2VpLmxpdUBrZXJuZWwub3JnOw0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5l
bC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBsZW9uQGtlcm5lbC5vcmc7IExvbmcgTGkgPGxv
bmdsaUBtaWNyb3NvZnQuY29tPjsNCj4gc3NlbmdhckBsaW51eC5taWNyb3NvZnQuY29tOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRd
IG5ldDogbWFuYTogQWRkIHN1cHBvcnQgZm9yIGp1bWJvIGZyYW1lDQo+IA0KPiBPbiAyMDIzLzMv
MjAgNToyNywgSGFpeWFuZyBaaGFuZyB3cm90ZToNCj4gPiBEdXJpbmcgcHJvYmUsIGdldCB0aGUg
aGFyZHdhcmUgYWxsb3dlZCBtYXggTVRVIGJ5IHF1ZXJ5aW5nIHRoZSBkZXZpY2UNCj4gPiBjb25m
aWd1cmF0aW9uLiBVc2VycyBjYW4gc2VsZWN0IE1UVSB1cCB0byB0aGUgZGV2aWNlIGxpbWl0LiBB
bHNvLA0KPiA+IHdoZW4gWERQIGlzIGluIHVzZSwgd2UgY3VycmVudGx5IGxpbWl0IHRoZSBidWZm
ZXIgc2l6ZSB0byBvbmUgcGFnZS4NCj4gPg0KPiA+IFVwZGF0ZWQgUlggZGF0YSBwYXRoIHRvIGFs
bG9jYXRlIGFuZCB1c2UgUlggcXVldWUgRE1BIGJ1ZmZlcnMgd2l0aA0KPiA+IHByb3BlciBzaXpl
IGJhc2VkIG9uIHRoZSBNVFUgc2V0dGluZy4NCj4gDQo+IFRoZSBjaGFuZ2UgaW4gdGhpcyBwYXRj
aCBzZWVtcyBiZXR0ZXIgdG8gc3BsaXR0ZWQgaW50byBtb3JlIHJldmlld2FibGUNCj4gcGF0Y2hz
ZXQuIFBlcmhhcHMgcmVmYWN0b3IgdGhlIFJYIHF1ZXVlIERNQSBidWZmZXJzIGFsbG9jYXRpb24g
dG8gaGFuZGxlDQo+IGRpZmZlcmVudCBzaXplIGZpcnN0LCB0aGVuIGFkZCBzdXBwb3J0IGZvciB0
aGUganVtYm8gZnJhbWUuDQoNCldpbGwgY29uc2lkZXIuDQoNCj4gDQo+ID4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPg0KPiA+IC0tLQ0K
PiA+ICAuLi4vbmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfYnBmLmMgICAgfCAgMjIg
Ky0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEvbWFuYV9lbi5jIHwg
MjI5ICsrKysrKysrKysrKy0tLS0NCj4gLS0NCj4gPiAgaW5jbHVkZS9uZXQvbWFuYS9nZG1hLmgg
ICAgICAgICAgICAgICAgICAgICAgIHwgICA0ICsNCj4gPiAgaW5jbHVkZS9uZXQvbWFuYS9tYW5h
LmggICAgICAgICAgICAgICAgICAgICAgIHwgIDE4ICstDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwg
MTgzIGluc2VydGlvbnMoKyksIDkwIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfYnBmLmMNCj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2JwZi5jDQo+ID4gaW5kZXggM2Nh
ZWE2MzEyMjljLi4yM2IxNTIxYzBkZjkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWljcm9zb2Z0L21hbmEvbWFuYV9icGYuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfYnBmLmMNCj4gPiBAQCAtMTMzLDEyICsxMzMsNiBA
QCB1MzIgbWFuYV9ydW5feGRwKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiBzdHJ1Y3QgbWFu
YV9yeHEgKnJ4cSwNCj4gPiAgCXJldHVybiBhY3Q7DQo+ID4gIH0NCj4gPg0KPiA+IC1zdGF0aWMg
dW5zaWduZWQgaW50IG1hbmFfeGRwX2ZyYWdsZW4odW5zaWduZWQgaW50IGxlbikNCj4gPiAtew0K
PiA+IC0JcmV0dXJuIFNLQl9EQVRBX0FMSUdOKGxlbikgKw0KPiA+IC0JICAgICAgIFNLQl9EQVRB
X0FMSUdOKHNpemVvZihzdHJ1Y3Qgc2tiX3NoYXJlZF9pbmZvKSk7DQo+ID4gLX0NCj4gPiAtDQo+
ID4gIHN0cnVjdCBicGZfcHJvZyAqbWFuYV94ZHBfZ2V0KHN0cnVjdCBtYW5hX3BvcnRfY29udGV4
dCAqYXBjKQ0KPiA+ICB7DQo+ID4gIAlBU1NFUlRfUlROTCgpOw0KPiA+IEBAIC0xNzksMTcgKzE3
MywxOCBAQCBzdGF0aWMgaW50IG1hbmFfeGRwX3NldChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwN
Cj4gc3RydWN0IGJwZl9wcm9nICpwcm9nLA0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgbWFuYV9wb3J0
X2NvbnRleHQgKmFwYyA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICAJc3RydWN0IGJwZl9wcm9n
ICpvbGRfcHJvZzsNCj4gPiAtCWludCBidWZfbWF4Ow0KPiA+ICsJc3RydWN0IGdkbWFfY29udGV4
dCAqZ2M7DQo+ID4gKw0KPiA+ICsJZ2MgPSBhcGMtPmFjLT5nZG1hX2Rldi0+Z2RtYV9jb250ZXh0
Ow0KPiA+DQo+ID4gIAlvbGRfcHJvZyA9IG1hbmFfeGRwX2dldChhcGMpOw0KPiA+DQo+ID4gIAlp
ZiAoIW9sZF9wcm9nICYmICFwcm9nKQ0KPiA+ICAJCXJldHVybiAwOw0KPiA+DQo+ID4gLQlidWZf
bWF4ID0gWERQX1BBQ0tFVF9IRUFEUk9PTSArIG1hbmFfeGRwX2ZyYWdsZW4obmRldi0NCj4gPm10
dSArIEVUSF9ITEVOKTsNCj4gPiAtCWlmIChwcm9nICYmIGJ1Zl9tYXggPiBQQUdFX1NJWkUpIHsN
Cj4gPiAtCQluZXRkZXZfZXJyKG5kZXYsICJYRFA6IG10dToldSB0b28gbGFyZ2UsIGJ1Zl9tYXg6
JXVcbiIsDQo+ID4gLQkJCSAgIG5kZXYtPm10dSwgYnVmX21heCk7DQo+ID4gKwlpZiAocHJvZyAm
JiBuZGV2LT5tdHUgPiBNQU5BX1hEUF9NVFVfTUFYKSB7DQo+ID4gKwkJbmV0ZGV2X2VycihuZGV2
LCAiWERQOiBtdHU6JXUgdG9vIGxhcmdlLCBtdHVfbWF4OiVsdVxuIiwNCj4gPiArCQkJICAgbmRl
di0+bXR1LCBNQU5BX1hEUF9NVFVfTUFYKTsNCj4gPiAgCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0
YWNrLCAiWERQOiBtdHUgdG9vIGxhcmdlIik7DQo+ID4NCj4gPiAgCQlyZXR1cm4gLUVPUE5PVFNV
UFA7DQo+ID4gQEAgLTIwNiw2ICsyMDEsMTEgQEAgc3RhdGljIGludCBtYW5hX3hkcF9zZXQoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+IHN0cnVjdCBicGZfcHJvZyAqcHJvZywNCj4gPiAgCWlm
IChhcGMtPnBvcnRfaXNfdXApDQo+ID4gIAkJbWFuYV9jaG5fc2V0eGRwKGFwYywgcHJvZyk7DQo+
ID4NCj4gPiArCWlmIChwcm9nKQ0KPiA+ICsJCW5kZXYtPm1heF9tdHUgPSBNQU5BX1hEUF9NVFVf
TUFYOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCW5kZXYtPm1heF9tdHUgPSBnYy0+YWRhcHRlcl9tdHUg
LSBFVEhfSExFTjsNCj4gPiArDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfZW4uYw0K
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfZW4uYw0KPiA+IGlu
ZGV4IDQ5MjQ3NGI0ZDhhYS4uMDc3MzhiN2U4NWYyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfZW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfZW4uYw0KPiA+IEBAIC00MjcsNiArNDI3
LDM0IEBAIHN0YXRpYyB1MTYgbWFuYV9zZWxlY3RfcXVldWUoc3RydWN0IG5ldF9kZXZpY2UNCj4g
Km5kZXYsIHN0cnVjdCBza19idWZmICpza2IsDQo+ID4gIAlyZXR1cm4gdHhxOw0KPiA+ICB9DQo+
ID4NCj4gPiArc3RhdGljIGludCBtYW5hX2NoYW5nZV9tdHUoc3RydWN0IG5ldF9kZXZpY2UgKm5k
ZXYsIGludCBuZXdfbXR1KQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBpbnQgb2xkX210dSA9IG5k
ZXYtPm10dTsNCj4gPiArCWludCBlcnIsIGVycjI7DQo+ID4gKw0KPiA+ICsJZXJyID0gbWFuYV9k
ZXRhY2gobmRldiwgZmFsc2UpOw0KPiA+ICsJaWYgKGVycikgew0KPiA+ICsJCW5ldGRldl9lcnIo
bmRldiwgIm1hbmFfZGV0YWNoIGZhaWxlZDogJWRcbiIsIGVycik7DQo+ID4gKwkJcmV0dXJuIGVy
cjsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwluZGV2LT5tdHUgPSBuZXdfbXR1Ow0KPiA+ICsNCj4g
PiArCWVyciA9IG1hbmFfYXR0YWNoKG5kZXYpOw0KPiA+ICsJaWYgKCFlcnIpDQo+ID4gKwkJcmV0
dXJuIDA7DQo+ID4gKw0KPiA+ICsJbmV0ZGV2X2VycihuZGV2LCAibWFuYV9hdHRhY2ggZmFpbGVk
OiAlZFxuIiwgZXJyKTsNCj4gPiArDQo+ID4gKwkvKiBUcnkgdG8gcm9sbCBpdCBiYWNrIHRvIHRo
ZSBvbGQgY29uZmlndXJhdGlvbi4gKi8NCj4gPiArCW5kZXYtPm10dSA9IG9sZF9tdHU7DQo+ID4g
KwllcnIyID0gbWFuYV9hdHRhY2gobmRldik7DQo+ID4gKwlpZiAoZXJyMikNCj4gPiArCQluZXRk
ZXZfZXJyKG5kZXYsICJtYW5hIHJlLWF0dGFjaCBmYWlsZWQ6ICVkXG4iLCBlcnIyKTsNCj4gPiAr
DQo+ID4gKwlyZXR1cm4gZXJyOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgY29uc3Qgc3Ry
dWN0IG5ldF9kZXZpY2Vfb3BzIG1hbmFfZGV2b3BzID0gew0KPiA+ICAJLm5kb19vcGVuCQk9IG1h
bmFfb3BlbiwNCj4gPiAgCS5uZG9fc3RvcAkJPSBtYW5hX2Nsb3NlLA0KPiA+IEBAIC00MzYsNiAr
NDY0LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlX29wcyBtYW5hX2Rldm9wcyA9
IHsNCj4gPiAgCS5uZG9fZ2V0X3N0YXRzNjQJPSBtYW5hX2dldF9zdGF0czY0LA0KPiA+ICAJLm5k
b19icGYJCT0gbWFuYV9icGYsDQo+ID4gIAkubmRvX3hkcF94bWl0CQk9IG1hbmFfeGRwX3htaXQs
DQo+ID4gKwkubmRvX2NoYW5nZV9tdHUJCT0gbWFuYV9jaGFuZ2VfbXR1LA0KPiA+ICB9Ow0KPiA+
DQo+ID4gIHN0YXRpYyB2b2lkIG1hbmFfY2xlYW51cF9wb3J0X2NvbnRleHQoc3RydWN0IG1hbmFf
cG9ydF9jb250ZXh0ICphcGMpDQo+ID4gQEAgLTYyNSw2ICs2NTQsOSBAQCBzdGF0aWMgaW50IG1h
bmFfcXVlcnlfZGV2aWNlX2NmZyhzdHJ1Y3QNCj4gbWFuYV9jb250ZXh0ICphYywgdTMyIHByb3Rv
X21ham9yX3ZlciwNCj4gPg0KPiA+ICAJbWFuYV9nZF9pbml0X3JlcV9oZHIoJnJlcS5oZHIsIE1B
TkFfUVVFUllfREVWX0NPTkZJRywNCj4gPiAgCQkJICAgICBzaXplb2YocmVxKSwgc2l6ZW9mKHJl
c3ApKTsNCj4gPiArDQo+ID4gKwlyZXEuaGRyLnJlc3AubXNnX3ZlcnNpb24gPSBHRE1BX01FU1NB
R0VfVjI7DQo+IA0KPiBoZHItPnJlcS5tc2dfdmVyc2lvbiBhbmQgaGRyLT5yZXNwLm1zZ192ZXJz
aW9uIGFyZSBib3RoIHNldCB0bw0KPiBHRE1BX01FU1NBR0VfVjEgaW4gbWFuYV9nZF9pbml0X3Jl
cV9oZHIoKSwgaXMgdGhlcmUgYW55IHJlYXNvbg0KPiB3aHkgaGRyLT5yZXEubXNnX3ZlcnNpb24g
aXMgbm90IHNldCB0byBHRE1BX01FU1NBR0VfVjI/DQoNClRoZSByZXF1ZXN0IHZlcnNpb24gaXMg
c3RpbGwgVjEgaW4gb3VyIGhhcmR3YXJlLg0KDQo+IERvZXMgaW5pdGlhbGl6aW5nIHJlcS5oZHIu
cmVzcC5tc2dfdmVyc2lvbiB0byBHRE1BX01FU1NBR0VfVjINCj4gaW4gbWFuYV9nZF9pbml0X3Jl
cV9oZHIoKSB3aXRob3V0IHJlc2V0IGl0IHRvIEdETUFfTUVTU0FHRV9WMg0KPiBpbiBtYW5hX3F1
ZXJ5X2RldmljZV9jZmcoKSBhZmZlY3Qgb3RoZXIgdXNlcj8NCg0KWWVzLCBvdGhlciB1c2VycyBz
dGlsbCBuZWVkIFYxLiBTbyBvbmx5IHRoaXMgbWVzc2FnZSByZXNwb25zZSB2ZXJzaW9uIGlzIHNl
dCANCnRvIFYyLg0KDQo+IA0KPiANCj4gPiArDQo+ID4gIAlyZXEucHJvdG9fbWFqb3JfdmVyID0g
cHJvdG9fbWFqb3JfdmVyOw0KPiA+ICAJcmVxLnByb3RvX21pbm9yX3ZlciA9IHByb3RvX21pbm9y
X3ZlcjsNCj4gPiAgCXJlcS5wcm90b19taWNyb192ZXIgPSBwcm90b19taWNyb192ZXI7DQo+ID4g
QEAgLTY0Nyw2ICs2NzksMTEgQEAgc3RhdGljIGludCBtYW5hX3F1ZXJ5X2RldmljZV9jZmcoc3Ry
dWN0DQo+IG1hbmFfY29udGV4dCAqYWMsIHUzMiBwcm90b19tYWpvcl92ZXIsDQo+ID4NCj4gPiAg
CSptYXhfbnVtX3Zwb3J0cyA9IHJlc3AubWF4X251bV92cG9ydHM7DQo+ID4NCj4gPiArCWlmIChy
ZXNwLmhkci5yZXNwb25zZS5tc2dfdmVyc2lvbiA9PSBHRE1BX01FU1NBR0VfVjIpDQo+IA0KPiBJ
dCBzZWVtcyB0aGUgZHJpdmVyIGlzIHNldHRpbmcgcmVzcC5oZHIucmVzcG9uc2UubXNnX3ZlcnNp
b24gdG8NCj4gR0RNQV9NRVNTQUdFX1YyIGFib3ZlLCBhbmQgZG8gdGhlIGNoZWNraW5nIGhlcmUu
IERvZXMgb2xkZXINCj4gZmlybXdhcmUgcmVzZXQgdGhlIHJlc3AuaGRyLnJlc3BvbnNlLm1zZ192
ZXJzaW9uIHRvIEdETUFfTUVTU0FHRV9WMQ0KPiBpbiBvcmRlciB0byBlbmFibGUgY29tcGF0aWJp
bGl0eSBiZXR3ZWVuIGZpcm13YXJlIGFuZCBkcml2ZXI/DQoNClllcyBvbGRlciBmaXJtd2FyZSBz
dGlsbCB1c2luZyBWMS4NCg0KPiANCj4gPiArCQlnYy0+YWRhcHRlcl9tdHUgPSByZXNwLmFkYXB0
ZXJfbXR1Ow0KPiA+ICsJZWxzZQ0KPiA+ICsJCWdjLT5hZGFwdGVyX210dSA9IEVUSF9GUkFNRV9M
RU47DQo+ID4gKw0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0KPiA+IEBAIC0xMTg1LDEw
ICsxMjIyLDEwIEBAIHN0YXRpYyB2b2lkIG1hbmFfcG9zdF9wa3RfcnhxKHN0cnVjdA0KPiBtYW5h
X3J4cSAqcnhxKQ0KPiA+ICAJV0FSTl9PTl9PTkNFKHJlY3ZfYnVmX29vYi0+d3FlX2luZi53cWVf
c2l6ZV9pbl9idSAhPSAxKTsNCj4gPiAgfQ0KPiA+DQo+ID4gLXN0YXRpYyBzdHJ1Y3Qgc2tfYnVm
ZiAqbWFuYV9idWlsZF9za2Iodm9pZCAqYnVmX3ZhLCB1aW50IHBrdF9sZW4sDQo+ID4gLQkJCQkg
ICAgICBzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkNCj4gPiArc3RhdGljIHN0cnVjdCBza19idWZmICpt
YW5hX2J1aWxkX3NrYihzdHJ1Y3QgbWFuYV9yeHEgKnJ4cSwgdm9pZCAqYnVmX3ZhLA0KPiA+ICsJ
CQkJICAgICAgdWludCBwa3RfbGVuLCBzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkNCj4gPiAgew0KPiA+
IC0Jc3RydWN0IHNrX2J1ZmYgKnNrYiA9IGJ1aWxkX3NrYihidWZfdmEsIFBBR0VfU0laRSk7DQo+
ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gbmFwaV9idWlsZF9za2IoYnVmX3ZhLCByeHEtPmFs
bG9jX3NpemUpOw0KPiANCj4gQ2hhbmdpbmcgYnVpbGRfc2tiKCkgdG8gbmFwaV9idWlsZF9za2Io
KSBzZWVtcyBsaWtlIGFuIG9wdGltaXphdGlvbg0KPiB1bnJlbGF0ZWQgdG8ganVtYm8gZnJhbWUg
c3VwcG9ydCwgc2VlbXMgbGlrZSBhbm90aGVyIHBhdGNoIHRvIGRvIHRoYXQ/DQpXaWxsIGRvLiBU
aGFua3MuDQoNCi0gSGFpeWFuZw0K
