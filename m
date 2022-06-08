Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A696542E1C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiFHKnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbiFHKnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:43:45 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A9AB225C;
        Wed,  8 Jun 2022 03:43:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0mNA3BjzCtt0dGQxPdJOTXIsGVGc0c7KQl27/bJMbcDNMGrcR4o26/MSi/nq4LesF0bKO6+dZexOqwhV69UeeWNMBWRy8CK60yS3fmCkkLj+L+lHhpCte0tScacqWn2MENGOl55iHX7Sktp23FEgcYu8AXT7zpj6ZnnsUcoln1eLE4pAZ/kx5TSxd+ZhKky8JKU39O/COpVDwJSYE/bhLB5Rd5Qljw383EQMhxPk5l5+GpqzWh8DNPsmV2YIhN0Frbnulx2TxbRukBNTGeM+wU4ENwmQQMijxfk2/R+kgGbGI8X5tOFAQK5goOMbuGHzOeZCT0GoYLljhonFLNYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1FYxge1N7UtnS2fbmAD3hE6Z4PFQ3jKm5Tf9F5nuiA=;
 b=Lat+wPrNw29gmgxdVMml21SS3bfZ6umV0EjU1hb6TIo+kBnVYrMqteNLXiDNsVKKm9OZeulsnDIQ+1C1LLA6igsuMnm5/oWp4ndP1uBEfGeapsMJvYcGPLCRxaAfcRi+Je7YPxZMOrcj0oQRthrZZA4zeHyg6j4+gaPxuaFYV0aaMtwS5lBmUzGOQUoSzWEN1FAJYqHz8/ArfeTepDO2L3UHp72biGPyfbSMwKo09ibWai1bSLyyFrkT82ttVWU1Sm9xwDNtOJBaX4za7aREgq6Sywo+nl5ovPU8XznRVqLJqVpg4ITiDHnXHZCDMb9MOiBcjeIwxNDrY3w9QA/9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1FYxge1N7UtnS2fbmAD3hE6Z4PFQ3jKm5Tf9F5nuiA=;
 b=Qv2c9IDQLqJSsTyoA54+nLDwHIOWVTfybwxkTzE0GBIs0ohwrxy1hSUKkCkWrq7/gAuFVA7WYbtWom7UCYkctc6FzuxzNyvJu3Ky8zKJoEl8GLrhU/tjexG4PcVbSoQl+eEJdrm5SRux0qbxcxzwMnjcGNcqAewFLW6Tt/mDZHOaFpIakphu1lSNI83PvfXt3b/yglJTI2IzDGBczNxeI/cfLNEnxeJYLsj1x99GGQA1ApGkjTSICnwIgwonl73L9eizphef4vHNhpxQUjNDL/Owhwnl3sw84xvvlMU/Xc5hwrEw9Fb/sH1K2f2oSDx3FPZDqTMZp5/FSvlCKFwUJw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 10:41:45 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 10:41:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Dawar, Gautam" <gautam.dawar@amd.com>,
        Jason Wang <jasowang@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Topic: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Index: AQHYdzWCFlBft4OJgU6WbdwBNZYD461FMSUAgAAlyoCAAAMLQA==
Date:   Wed, 8 Jun 2022 10:41:45 +0000
Message-ID: <PH0PR12MB54814B1D6E884E50E5C26786DCA49@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220603103356.26564-1-gautam.dawar@amd.com>
 <CACGkMEs38ycmAaDc48_rt5BeBHq4tzKH39gj=KczYFQC16ns5Q@mail.gmail.com>
 <DM4PR12MB5841EB20B82969B6D67638AF99A49@DM4PR12MB5841.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB5841EB20B82969B6D67638AF99A49@DM4PR12MB5841.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-08T09:52:35Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=06c0b048-9737-4417-9000-0000701ea7a5;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a76c38f9-8617-4426-8397-08da493b7be8
x-ms-traffictypediagnostic: DM6PR12MB4530:EE_
x-microsoft-antispam-prvs: <DM6PR12MB453033E5BD25FD418F77B407DCA49@DM6PR12MB4530.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YN9tFieIaVIpE0WQXo6qa23HIBpZFLJI/4ccRDLgi9vUNJJcHADpaOVV+z9dQegwZm2xZ246A0lOapWbknvi0DQ6wc9JKqgIAE0P680R0Vsr/KHk/c63NsMdUdpDRGSqdXJm+gksm4ffWqfaAKonRuhJ1HOdsJr71dVXjQ7XTmNMX6GUiwNuq71sxKunSEpgTzERLd50g6fVYKnZD3n+AOL2ZPLXMW2Cml41pNKPgbMHosRwcp5bdxtwq1DSP4dfeKw1zrsSSrfzjrbzFBnTag8uxU0mTVjz7g1XT88X89+lgvGsD5ZiinK7MWQkDH6sAowzUHTPzfwF5eMeYAGEtJxY5ryZbuu6gARLMjnpGPF+EZEhlXytuIvd4h28/LsB51OQkqpfOyflQO3oe8qyK7tfosEP7TbNE64Gf/kT/PWSoxAo8v+1t2a7KCbAi7yjuT3MnTFL/LdTO86HnbJCwShP1C6Eg0tsa1PP9kYR9tn9pxw/83Y2/TdRQLTIsC/apnFTTjKpYmVUGfivAMu/uQ28HlxvWM9q27P/7HAnpA5Ux1AecVtBNwl4F+UACsg5Wn6LGDCAmOxgkbXlH22h8Ogrvd5NWG+5+nOA1IQmcvbVhBj60PCD7Aypd+VQoigE844kDPx0cACOepfztyPbHiwTskb1ZqE+6q67IiWRpzhNANMG2/eghwseOUScMbUwFYuH/7Gx9h6/4f9Xd2wAlJJGYQw/zwuJpp/e+JQZM9BL8E0RL8/Di2SkaVymD3PAkTDXbOxU5cqCrXc5yh2PWjXQFLCS9NDl+AnyFl8B5a4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(71200400001)(7696005)(6506007)(33656002)(2906002)(52536014)(508600001)(966005)(86362001)(186003)(53546011)(7416002)(8936002)(83380400001)(5660300002)(38100700002)(122000001)(38070700005)(316002)(110136005)(54906003)(55016003)(66556008)(76116006)(66946007)(66476007)(4326008)(66446008)(8676002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWkwSDdqdk1wVkxROHdvK3BpNVJMcmVLR3RRYnJRcGR2VjN6a0x0NjltRjdK?=
 =?utf-8?B?Q3VpNENSSGlUb3VmNVpSczlMTW1ENWhXYitmelFnNVFVTURIYzVwTGkzbGpG?=
 =?utf-8?B?V21qbUZSOW1jb2UzbkxML25rOHdoazlDNnJ5eUdUVE1pZENyQk5IbjkvdktU?=
 =?utf-8?B?WXpMWURSN1Z0MGtWeG0xTlcxR1VsYm9DQWFxK1E5aDZFSDFydFhSQlJubXNq?=
 =?utf-8?B?OVY0Q3N6cDN5OTBxRnltZWIvckV1di9tRm0zbmRxaEdubGdaZlg2VzFvdEZH?=
 =?utf-8?B?cjIrT2Jpd2J2NHhJWWRScFFDRlhNSk5QQ3U2cFBiRVgxeW9sMktDMXVtRWxW?=
 =?utf-8?B?N2dCVVhBTlU2cjVoaGNscUwzZk9WQlNjQXh4T21BS1RicitNbnhaN291OEZo?=
 =?utf-8?B?dWYzMDV4VVVubTNlRkRXUk5zU3dJU3ZmRm94L0ZLd1JWMTYrdkFQK2dYVHA0?=
 =?utf-8?B?c0ZEbUtjTmVGNFlyWGt4Vnpad0hGYWFDVFRqUHNVRE91dXhDaWhIRWswd2l5?=
 =?utf-8?B?UTdnL001N1Fqam9pYTZBczl1d0RRV0Yxcm5oTmlRWk5ka3pBM0RjWU1wS21L?=
 =?utf-8?B?VHpKQThwd0p3SHJ0WUNSRHBBSnkzMXdPOVVqYko5d0NNSkRFNTA5c0VnU2cw?=
 =?utf-8?B?UzVIRWo2Nk50bEt0RHRCNTU3Nk9GRUIzM3RCYlQ5ZWNidFRiWGREcDVLbDhL?=
 =?utf-8?B?b0RpalZJM1FrQ1RtSFBmbE5TSFRUejh0bDA5UkdVVnJLRFRpNHFldDAwSXhD?=
 =?utf-8?B?TEVGb1BOd3g0cjRvRVJJbVBrSkZsWm8wOHhKYzJnZjEyYXlWbmVucVBxWU5B?=
 =?utf-8?B?ajYxbGlXTm40NTNLWVA1L2RqSWs1T1ZCNkVHTWFGcVE1Uzc3UUhBclZJR3Zp?=
 =?utf-8?B?bC9WQURodVJrcGQrb3JFVG5XMTdkdVJONVB2UElXT0MyMW10UWZIS2ovT1R6?=
 =?utf-8?B?NWk2bDFqN3c3Z3BwTXdvZnlIeThMY3VaZ1dBQ01UeGlpRTJHTGJFYjhlMUlo?=
 =?utf-8?B?VDF5WWF2MEhDTXg2RXlESTBsazVVTldmYkFldnYvaFY5U0lnY3ZWN0FWbE11?=
 =?utf-8?B?NGY3a2MxVjdrWDRTTC9XK3FIM0NzNW54Q0wvTFRaT0N6TEsxRmxVS0lZSE5Z?=
 =?utf-8?B?ZmVCcVlqenJSTmhHOVJJcm1aTTVlYWh4R0oxUGFYeTlCaWduRStEcWNKOE5L?=
 =?utf-8?B?Q1A4WU95Mk5tNWdYVnBVeUNWMDBMck9TRVFGSTdmYmNXMFdJQmFTc0x4WnBu?=
 =?utf-8?B?ZTVFWGNPT3djdU1kWVlSSERCT2xIOTE0U0U3ZHRXMlFieTIyLzJkUEVIUkRa?=
 =?utf-8?B?bno2QkVUaTZ5Vzd3SERtM1VSamF4Vmh2Z1A2djlUcnRtRVZrNFdzZTVVSlMr?=
 =?utf-8?B?QmRaUHV3ZndQYmtiUW90ejBqUTRKQ2ZFclkwQTRLSUZyQ21aLzRMNFZDMGFH?=
 =?utf-8?B?WUJpVW9pUk9tVnBzMHFNQ296L2pFWEVYMUIwaUJXbXZuMWxuazNtS29IdkJ4?=
 =?utf-8?B?Q0VjK1pRZm5hZk13dWIvMDlhSHdoaURoUUE1OVZ3WEdLYXZCbFBhbEE2YVo4?=
 =?utf-8?B?TmxDQU14empha2dwbUdFeEsvdkVSZTFiSE5uVjhuNlhXZTRJTUxvMlRHRkla?=
 =?utf-8?B?RGtneFN3WWNSMEZEVTQxODBEUFg2R3R0MjNZTks0YXlRTUNnV2Y4OVZ6cHJK?=
 =?utf-8?B?WDdZbTdvNWltZ2t1RXZOSnZiSm9VeFJ6T3A4MGpsUVFXZ05lWXpZNlRGVEVj?=
 =?utf-8?B?WEhQaVZGT0VMMXdlekYwZ0FZamVUZko1M3dxTzREZUNIbmF0eVRMNHhCazBD?=
 =?utf-8?B?RWRLaDdGVTkwRlpHR3hDR1FrNE1kcmUzcjhyNnQvNFZZaVI0Y0Z3R0l2NFZB?=
 =?utf-8?B?ektJUC8rNFNGODJwWVpOL3FjeXhxQkljTENwQ2xVOVRwdDRXNjcyM0p3dWpp?=
 =?utf-8?B?bXJaNHlYTTgzYmE2L1p5SWVpek1YTUVuZUU4YzJMVHRlTEtMQldJQ2lNY0kz?=
 =?utf-8?B?UStyZWhEejFObGZrYnlub3ZxbHhwUzltYmZuTWpvT1lSeGZaSCtLODdhZVdx?=
 =?utf-8?B?cFQxREtqaG1za2lMRUVMcDlwenJlQVFzWEFlZUJOYTFIR0R5RzRlWU1jM3By?=
 =?utf-8?B?OXIycVRtdG9nRFN0SHp5eER0Y0dtNDVhYmg5M2hWNDFrVlAzN2pHRzlPb1JW?=
 =?utf-8?B?bDlBYWVMOEFYMDRWMmdZUTNFYkE3M3RyZ2pFdUhXU01YZzQ3bnF6U2YwM2V6?=
 =?utf-8?B?a3hrb093bDBKbk52aEdDK2NWN1VLL2RTTTEzT2NjNTNzbDR2WlY3ZUZEc1VF?=
 =?utf-8?B?RmljWUcrdWc2NWNMNTY1STlVYVByREVLdUREZyt1c3crVEFZd0s1NVNUdzAr?=
 =?utf-8?Q?xGBwWynNz/zcIRvCi85g0/uYBoHaPT7K7gsqmcdcWGsM7?=
x-ms-exchange-antispam-messagedata-1: l7rROTlq93TA9A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76c38f9-8617-4426-8397-08da493b7be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 10:41:45.6767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wchGuMW2PoOqV9lc44F/nc4bu3Jl1fs8pMcMdcAAiU7cXKeh6u5iPYMAoTboODl4kCzoAyvguVAQDIKl20B7nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SCC_BODY_URI_ONLY,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IERhd2FyLCBHYXV0YW0gPGdhdXRhbS5kYXdhckBhbWQuY29tPg0KPiBTZW50OiBX
ZWRuZXNkYXksIEp1bmUgOCwgMjAyMiA2OjMwIEFNDQo+IFRvOiBKYXNvbiBXYW5nIDxqYXNvd2Fu
Z0ByZWRoYXQuY29tPg0KPiBDYzogbmV0ZGV2IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgbGlu
dXgtbmV0LWRyaXZlcnMgKEFNRC1YaWxpbngpIDxsaW51eC0NCj4gbmV0LWRyaXZlcnNAYW1kLmNv
bT47IEFuYW5kLCBIYXJwcmVldCA8aGFycHJlZXQuYW5hbmRAYW1kLmNvbT47DQo+IE1pY2hhZWwg
Uy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+OyBaaHUgTGluZ3NoYW4NCj4gPGxpbmdzaGFuLnpo
dUBpbnRlbC5jb20+OyBYaWUgWW9uZ2ppIDx4aWV5b25namlAYnl0ZWRhbmNlLmNvbT47IEVsaQ0K
PiBDb2hlbiA8ZWxpY0BudmlkaWEuY29tPjsgUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29t
PjsgU2ktV2VpIExpdSA8c2ktDQo+IHdlaS5saXVAb3JhY2xlLmNvbT47IFN0ZWZhbm8gR2FyemFy
ZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT47IFdhbg0KPiBKaWFiaW5nIDx3YW5qaWFiaW5nQHZp
dm8uY29tPjsgRGFuIENhcnBlbnRlcg0KPiA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPjsgdmly
dHVhbGl6YXRpb24gPHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LQ0KPiBmb3VuZGF0aW9uLm9y
Zz47IGxpbnV4LWtlcm5lbCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVj
dDogUkU6IFtQQVRDSF0gdmRwYTogYWxsb3cgdmRwYSBkZXZfZGVsIG1hbmFnZW1lbnQgb3BlcmF0
aW9uIHRvDQo+IHJldHVybiBmYWlsdXJlDQo+IA0KPiBbQU1EIE9mZmljaWFsIFVzZSBPbmx5IC0g
R2VuZXJhbF0NCj4gDQo+IEhpIEdhdXRhbToNCj4gW0dEPj5dIEhpIEphc29uLA0KPiANCj4gT24g
RnJpLCBKdW4gMywgMjAyMiBhdCA2OjM0IFBNIEdhdXRhbSBEYXdhciA8Z2F1dGFtLmRhd2FyQGFt
ZC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gQ3VycmVudGx5LCB0aGUgdmRwYV9ubF9jbWRfZGV2
X2RlbF9zZXRfZG9pdCgpIGltcGxlbWVudGF0aW9uIGFsbG93cw0KPiA+IHJldHVybmluZyBhIHZh
bHVlIHRvIGRlcGljdCB0aGUgb3BlcmF0aW9uIHN0YXR1cyBidXQgdGhlIHJldHVybiB0eXBlDQo+
ID4gb2YgZGV2X2RlbCgpIGNhbGxiYWNrIGlzIHZvaWQuIFNvLCBhbnkgZXJyb3Igd2hpbGUgZGVs
ZXRpbmcgdGhlIHZkcGENCj4gPiBkZXZpY2UgaW4gdGhlIHZkcGEgcGFyZW50IGRyaXZlciBjYW4n
dCBiZSByZXR1cm5lZCB0byB0aGUgbWFuYWdlbWVudA0KPiA+IGxheWVyLg0KPiANCj4gSSB3b25k
ZXIgdW5kZXIgd2hpY2ggY29nbml0aW9uIHdlIGNhbiBoaXQgYW4gZXJyb3IgaW4gZGV2X2RlbCgp
Pw0KPiBbR0Q+Pl0gSW4gdGhlIEFNRC1YaWxpbnggdkRQQSBkcml2ZXIsIG9uIHJlY2VpdmluZyB2
ZHBhIGRldmljZSBkZWxldGlvbg0KPiByZXF1ZXN0LCBJIHRyeSB0byBpZGVudGlmeSBpZiB0aGUg
dmRwYSBkZXZpY2UgaXMgaW4gdXNlIGJ5IGFueSB2aXJ0aW8tbmV0IGRyaXZlcg0KPiAodGhyb3Vn
aCBhbnkgdmRwYSBidXMgZHJpdmVyKSBieSBsb29raW5nIGF0IHRoZSB2ZHBhIGRldmljZSBzdGF0
dXMgdmFsdWUuIEluDQo+IGNhc2UgdGhlIHZkcGEgZGV2aWNlIHN0YXR1cyBpcyA+PSBWSVJUSU9f
Q09ORklHX1NfRFJJVkVSLCAtRUJVU1kgaXMNCj4gcmV0dXJuZWQuDQo+IFRoaXMgaXMgdG8gYXZv
aWQgc2lkZS1lZmZlY3RzIGFzIG5vdGVkIGluDQo+IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9y
Zy9zaG93X2J1Zy5jZ2k/aWQ9MjEzMTc5IGNhdXNlZCBieSBkZWxldGluZyB0aGUNCj4gdmRwYSBk
ZXZpY2Ugd2hlbiBpdCBpcyBiZWluZyB1c2VkLg0KPiA+DQpVc2VyIHNob3VsZCBiZSBhYmxlIHRv
IGRlbGV0ZSB0aGUgZGV2aWNlIGFueXRpbWUuDQpVcHBlciBsYXllcnMgd2hvIGFyZSB1bmFibGUg
dG8gcGVyZm9ybSB0ZWFyZG93biBzZXF1ZW5jZSBzaG91bGQgYmUgZml4ZWQuDQo=
