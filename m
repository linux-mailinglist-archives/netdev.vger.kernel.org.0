Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85A6BC1AE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbjCOXpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCOXpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:45:52 -0400
Received: from MW2PR02CU001-vft-obe.outbound.protection.outlook.com (mail-westus2azlp170120001.outbound.protection.outlook.com [IPv6:2a01:111:f403:c005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5030DEB48;
        Wed, 15 Mar 2023 16:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfH9Ma5tGLSxQXpgEdmWB1CZuW+MAbezYeQYIhZNlB17jSCRkTwQFSIXjLNcBqRyl4BWq1MXqe9dvoUS5BJDq6GeumtYDv7vxc0pUAa17XicXlNAglBjC+h3iTmF1ibK8/E3S3VWVaJeDu9tOt1NFx5xc+5HAzFUESIHtxgu28/9iMaVETi2coU1uT2K2FhL7OuMQLiI5cJvx/sggBZf1HVG3bRoNWehJW2tDfg7LqpFmsssgbPw6gPlKllFtwyUQQXBfv/A4Dw+F1s5FjPWJ5uUBbKcUwty2US6cQR2pFz6c7dTZasDpbED0NpLMvK0a811/o76jNHudxEuukE4Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32RPgAaW1Dx7JZZfZaRiWQ9J0t6MQftMHF/5pHQcdh8=;
 b=ALAxo273nsDUbASqIaAmi0CT4G9pVBq5e7ktsI71po8pMkdSUqQI+q86yx+TmrGjs6hRWm+bPrexZ+WycqEY3jQQ3098wA2FT5PINwGri24+0fqbRLaka1f9NWAmbY7+mOAzrSexyit48Pe+tF8KOJmHhe5B9+QV7P/Rb8Zg2X4a+8qJSy7DtQKyUdZDsGKr6kzQ1wsdi77yLCDw8jaW2pdP6NNgG3GIiaRmrSAGbRsdzb1UVUyYFZZ4XVwkOAH0Agi3uwL4oSNK58rW0XiRCYOC8MyN8AdWsw37cGF026V07bJ1yJF51ifVBTqdaT8v+bjqr0LDvdWkMYWLFf3+Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32RPgAaW1Dx7JZZfZaRiWQ9J0t6MQftMHF/5pHQcdh8=;
 b=1orFfgP6OMpgY79QU4MQPWq/1dMHl8ufv3HbwwR67pe5SUFqQO2Sp5zLbcADF/rbCcHCVzPl5EioCV0PspNmEwSc9c7L0fLLRrIgJiplcZtTDduSx+kgngm5LiVRI86SC2ftLuBZ10d8C+je7REZV5j0PaNg9Kn+wGKOsPnXjNY=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB5846.namprd05.prod.outlook.com (2603:10b6:a03:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 23:44:37 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 23:44:37 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAAgADERoD//5SOgIAAf+AAgADlBQA=
Date:   Wed, 15 Mar 2023 23:44:37 +0000
Message-ID: <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
In-Reply-To: <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|BYAPR05MB5846:EE_
x-ms-office365-filtering-correlation-id: 1117b982-51f2-400b-fc8c-08db25af3cee
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+jqcKqlGFxVPZJvvCewMWFVYYjw95GRC+fuy6SBLOqmeRgEvyMWMkkdRlOeieuh1T/N5s8DUF6D1+PBmdSK5BNR8UCuN8FRNTMQydnp4dT0PGVMTYl8ibCqPCuWjX8N3RfhOzlJMgxf1wV7zEp4jKr/XJZ5n9VyYWkKZVahgiPwT0wy9uEg9WEN2xsjri27DF0O/T6Ynzg/kat/R9J+iOs9DhfxWdzJ8rhwWYzqA+V6pZyw2Uwx4seoSivm/L9mCY/MfO2S7ECN0ge24Z4OYkEasg6dbR968zScspRNHWRStMoEZeB09ytlg6y1Vg7eQyohACR2qasTMwObuQ/Gl3JTlWmex/jRHPv2CddYxu2spUIpgQnVJeDHTDTNG2uvAD64FWSwdfDHjVtG/Ip39GUsJZeKJGrumlMUH1kzkYB0Zx/azxDssmUT6eDG2dtdvtyO9O5/fqq8OIpGjGl70g78f9vKstA+gEWH8sgTfQBVS2bkPNuNoh0r/Npx5A5ovshoR8eVCh3TD4KBGTIYETBMeQ6VXlJ+3BBtY8yPzkDwSzIZooKAaxmduqD8n0kfkrxp2KdL7xAxQtN68hxBnwHzcoICpGwVHbjKtMfeojRagg5ZbSCWuBRhUPizifAQoJ6029Ih9/IUWvVkWi0SSfUDwL5rx/ZEApg1sOTihc94l8GTYTmycf74VL8EYcuEBdIw+l+3S595muy4mlMpGR7RUv5LTuFVqeSj5vSCJoE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(8936002)(8676002)(2906002)(5660300002)(41300700001)(4326008)(36756003)(33656002)(86362001)(38070700005)(122000001)(38100700002)(83380400001)(6506007)(478600001)(6512007)(71200400001)(6486002)(316002)(64756008)(66476007)(66446008)(66556008)(66946007)(186003)(2616005)(76116006)(110136005)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUVRTXNZUlQwVGgvZlJtMGc2Zk1TTnhESk9YMFFoU0JGczZhM0MreXZPZ3hu?=
 =?utf-8?B?SXlvRTBpeENLV0wxcURkenlkTWVsTVJaczRWdWR4TFE3d1VEc1BZNE1qS0hS?=
 =?utf-8?B?c3BLaDZNK1krV3hrTHFjMFY2T0U3cHNEcTQwZ1EySnFORlNGaXBIN0JmbitV?=
 =?utf-8?B?U0xMc3R4eDFBRTQ1V0FKZzBid0JnclJPYjlsQ1pteThRSTRkcksrMDkxRDNl?=
 =?utf-8?B?aU1hUkJsOExyOGFjbGFoZU5XUFVQbVVoU3NoaUJHMjhpY3NmV1V2SXdwMVJY?=
 =?utf-8?B?WlROTTJuQVprdFAxVVJxU09JbitwRGVUMWlsd1U5YnBWSGR2WVFBU2FzZTdy?=
 =?utf-8?B?cmJLd2JYdVM0TmJYa0tnaTc1NGxXZlFoTTR1azlWeG56QUxkazROYk1CdFVr?=
 =?utf-8?B?dkRxeUg2OVJkNmJ0QUhkRjhKZ0Z0dGQ5ellmVkpQeHpESjUvN3UwMUFPMWhF?=
 =?utf-8?B?dlpzMmpvNmIzeHlUMW1kMFFvbFc0VkVzUlhkOHR1em5ueDJhN0VUT0hFQW8v?=
 =?utf-8?B?WE0wMzB4bUpzNG9XY0tXTEx3dDVHNmVEeWE5UG9LOTQyQTNtYmlYZkhTRWp4?=
 =?utf-8?B?UXJJK2w1THV2aDJRbndPMGp6dUYyQjJ1V0xNeG9NbnFhVndueHFZdWFzYzRQ?=
 =?utf-8?B?WXBRTFBXVnN5WW9JSGFXcEpVNGJoOFJwazNrVlpiNG9MaVBkdW8vdGhWWlYr?=
 =?utf-8?B?UllLY1E2R3VHZzJyT0hoSlIwY0s5c0lTSFc4WTBmdE1CRVpkaGRqREh6YnJz?=
 =?utf-8?B?cXppOVV4bTJDcFhhRVdVdUVha2xqTXo5VE95Z205ZjJXZGQzdEZoTnhFNDQ4?=
 =?utf-8?B?Y3hSWUh6alAwb1MrS01UcDNWaUo1K05FNUJHVzFjRWptQjlmMzV2eWYyWXdp?=
 =?utf-8?B?WHp1bkJQbStVOURmZnVaVTlkNXBkQ29NM2J1dWJRa01WQlZJcytYZnlmSFJ0?=
 =?utf-8?B?cWROT3ZrdzI4bm5HVk9iNTlTWC9NRlEwRXZIUEpHU1oxYWw1SFVmdVBrRjlt?=
 =?utf-8?B?cWRDOTNLU0xUYTMrODR5VlFxaXA4dk1XSWg4L1E0UUtYM01kSDNlUnJMZlNF?=
 =?utf-8?B?TzRhZEVnOUNxUW15SkRYTjlVeTZTQ2w3am5VcVFtekY5L2IxT0UvdmZndnZX?=
 =?utf-8?B?L1FleW5Uc21pTkUzUXR1alRneE1RR0Y1NnhwTTBEWUhjRVpraHQrRHZQeExJ?=
 =?utf-8?B?eG1HVUpyRVFzRzkzR2FyTHJZdkxSMS9JdkM0UkM2WUFMT0ZVUE5aVzc2cmVE?=
 =?utf-8?B?MWI5QjdXS2huVW40YXhFTzVoK1N5R3dvcnBtTEovbFZjNlV4c3FSSEdMczJr?=
 =?utf-8?B?MlhzVngrMzdDelo5eXQ3SFZrSitWOThMNTMwTklNd0VCT0ZlZEhrT0JLQnF2?=
 =?utf-8?B?a1c2b3hjQXVwNFlReTNmVmJlSEp2SmRha2trKzdTZldQVzRjbHRrbC9oK2Nn?=
 =?utf-8?B?SHE5eXM1dE9Zci9xdzFWakpsMllwUE41YVlqWHNRNzJjcml1NjFaM0VxTUxZ?=
 =?utf-8?B?bTdTSE5pcE5MRXFhN1BaQ0VwWjhxVVVIV0w0b2JHbW1PMEVQTnlXYnFvU0d3?=
 =?utf-8?B?MVZWbG1kWko4RjdOZW1rYmJjSU9mY0tEOWMwQW81dUJ4YlpIZHVWT0s2SGtz?=
 =?utf-8?B?VnZEQytLb0QxeEdBcUpudXk3NEtlSURUd0VWTmxZNE11akwzVHJYTWFBL3Zj?=
 =?utf-8?B?MlUxenpJcEc4VjZhYmd2aU5ZQUJsZkJZZGJHMlZUdGEvV2hTbFE5QjZVZXpH?=
 =?utf-8?B?Z3lwbFQzUWZjNWlOY3AwU0psQit2UkJzVmFWaVQzUTBxZmdQT01IZHdhNjhx?=
 =?utf-8?B?VG9DNDlDQ01PYitob1pJeEkyTWk0b3pYNXFycjRTUWVLV3RXUlVVM09rUFAz?=
 =?utf-8?B?djcyRFBtalh5Z2tuN0dZajQ4aDJ1c2dnelhMNitEUFVCRS9TZExoelpaTSt4?=
 =?utf-8?B?bGE3NDh6a3N6RXpuME5PeFNQUHN6YVg4M21jdzRmT2pJY1VGNWs5NlEzc1la?=
 =?utf-8?B?UGVHNFdudmJMZGdyYmRDN01aYVU5d3pBSzlOdFJRa0xMVWFqQ21xd2tRUnRS?=
 =?utf-8?B?cVFUdnk3SFpSMjhuR1NPVW1QZlBRZ2s5RG5DNGxzbXZrVHp0UUU1dVVZcnhB?=
 =?utf-8?B?Ym41enBZaUczMjJmM3k3ckZyL0pCR0d5cUJiYk42aTN5RUk5QkQ1b2FobHJQ?=
 =?utf-8?Q?QGnynqQMH35NAmkXxNeStUHMIICvLc3+bpgmaaTNgj2W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <242C9BA368594E42AECA3EE65F2D4A85@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1117b982-51f2-400b-fc8c-08db25af3cee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 23:44:37.4231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+ZyiFK70IaFiNKpp+XtV50fR4j2XUiFmjc5L0/1ceRwqPr4D2xzIKsZ4A3pH4E+mqCUFGUJPYuMnox6eDz6tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5846
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IO+7v09uIDMvMTQvMjMsIDg6MDUgUE0sICJZdW5zaGVuZyBMaW4iIDxsaW55dW5zaGVuZ0Bo
dWF3ZWkuY29tIDxtYWlsdG86bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4+IHdyb3RlOg0KPg0KPiBJ
IGFtIG5vdCBzdXJlIGhvdyB3ZSBjYW4gaGFuZGxlIHRoZSBydW50aW1lIGh3IGNhcGFiaWxpdHkg
Y2hhbmdpbmcgdGhpbmcgeWV0LCB0aGF0IGlzIHdoeQ0KPiBJIHN1Z2dlc3RlZCBzZXR0aW5nIHRo
ZSBodyBjYXBhYmlsaXR5IGR1cmluZyB0aGUgZHJpdmVyIGluaXQgcHJvY2VzcywgdGhlbiB1c2Vy
IGNhbiBlbmFibGUNCj4gb3IgZGlzYWJsZSBHUk8gaWYgbmVlZCB0by4NCj4NCkl0IGlzIG5vdCBh
Ym91dCBlbmFibGluZyBvciBkaXNhYmxpbmcgdGhlIExSTy9HUk8uIEl0IGlzIGFib3V0IHdoaWNo
IGNhbGxiYWNrIHRvIGJlIHVzZWQgdG8NCmRlbGl2ZXIgdGhlIHBhY2tldHMgdG8gdGhlIHN0YWNr
Lg0KDQpEdXJpbmcgaW5pdCwgdGhlIHZuaWMgd2lsbCBhbHdheXMgY29tZSB1cCBpbiBlbXVsYXRp
b24gKG5vbi1VUFQpIG1vZGUgYW5kIHVzZXIgY2FuIHJlcXVlc3QgDQp3aGljaGV2ZXIgZmVhdHVy
ZSB0aGV5IHdhbnQgKGxybyBvciBncm8gb3IgYm90aCkuIElmIGl0IGlzIGluIFVQVCBtb2RlLCBh
cyB3ZSBrbm93IFVQVCBkZXZpY2UNCmRvZXMgbm90IHN1cHBvcnQgTFJPLCB3ZSB1c2UgZ3JvIEFQ
SSB0byBkZWxpdmVyLiBJZiBHUk8gaXMgZGlzYWJsZWQgYnkgdGhlIHVzZXIsIHRoZW4gaXQgY2Fu
IHN0aWxsDQp0YWtlIHRoZSBub3JtYWwgcGF0aC4gSWYgaW4gZW11bGF0aW9uIChub24tVVBUKSBt
b2RlLCBFU1hpIHdpbGwgcGVyZm9ybSBMUk8uDQoNCj4gU3VwcG9zZSB1c2VyIGVuYWJsZSB0aGUg
c29mdHdhcmUgR1JPIHVzaW5nIGV0aHRvb2wsIGRpc2FibGluZyB0aGUgR1JPIHRocm91Z2ggc29t
ZSBydW50aW1lDQo+IGNoZWNraW5nIHNlZW1zIGFnYWluc3QgdGhlIHdpbGwgb2YgdGhlIHVzZXIu
DQo+DQpXZSBhcmUgbm90IGRpc2FibGluZyBHUk8gaGVyZSwgaXQncyBlaXRoZXIgd2UgcGVyZm9y
bSBMUk8gb24gRVNYaSBvciBHUk8gaW4gZ3Vlc3Qgc3RhY2suDQoNCg0KPiBBbHNvLCBpZiB5b3Ug
YXJlIGFibGUgdG8gImFkZCBhbiBldmVudCB0byBub3RpZnkgdGhlIGd1ZXN0IGFib3V0IHRoaXMi
LCBJIHN1cHBvc2UgdGhlDQo+IHBhcmEtdmlydHVhbGl6ZWQgZHJpdmVyIHdpbGwgY2xlYXIgdGhl
IHNwZWNpZmljIGJpdCBpbiBuZXRkZXYtPmh3X2ZlYXR1cmVzIGFuZA0KPiBuZXRkZXYtPmZlYXR1
cmVzIHdoZW4gaGFuZGxpbmcgdGhlIGV2ZW50PyBkb2VzIHVzZXIgbmVlZCB0byBiZSBub3RpZmll
ZCBhYm91dCB0aGlzLCBkb2VzDQo+IHVzZXIgZ2V0IGNvbmZ1c2lvbiBhYm91dCB0aGlzIGNoYW5n
ZSB3aXRob3V0IG5vdGlmaWNhdGlvbj8NCj4NCldlIHdvbuKAmXQgYmUgY2hhbmdpbmcgYW55IGZl
YXR1cmUgYml0cy4gSXQgaXMganVzdCB0byBsZXQga25vdyB0aGUgZHJpdmVyIHRoYXQgVVBUIGlz
IGFjdGl2ZSBhbmQgaXQNCnNob3VsZCB1c2UgR1JPIHBhdGggaW5zdGVhZCBvZiByZWx5aW5nIG9u
IEVTWGkgTFJPLg0KDQpUaGFua3MsDQpSb25haw0KDQo=
