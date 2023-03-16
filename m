Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73496BC595
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCPFV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCPFV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:21:56 -0400
Received: from CO1PR02CU002-vft-obe.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A50A8C6E;
        Wed, 15 Mar 2023 22:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ge5oHUQsjYWhF9ObMrVHSGTaAEUft1f/jaRPToWnB8Eke3U0MkeQjrOmZlw9OmfDEMVwpDpRK7+j9bgZQLOsfZbvIrS3BO+DimGvGpAiwq4BmnRdMv0uvm3ynQ+URk18TajBP3E1c43kmen1oCv4mKvvA99PQ4ONVrFepX2Axwci2TxT1OTTtKQUs5rEEOrzIaaEUgKELNwAYnjEldkQeKN6vCM+HI7JgOl9VmmAYGw23ZJPRkjEOyBdY0+lW7TRxiwm9GIlXamvis5xRQUvQJiXsPscm9CevglN0doUNx1oYAf64147V8q09ckfupguiIgC/5IxjYg0EufTFKxG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVuVtEFieLOfY3BpK5pliDfBK7t7VlgyTTe6aSZs3lU=;
 b=bunzY5m/0KezvXZnCKgaRzHL3GJEIFBdF59G7JUmu7ASZA5N7YME+qWi33iHkownYENZ8TFZLaQKYD32VODWxXr4gXF5QNyew2R5q4zPLp+OyLNp3N59BCazOkVB54vb6PBZtKhh9bg48eF6hF+mtX+U+ZepU0GTIE5y0JazV3hN6s8eULDgV54gnRzn7nQHz1plGcUgo2F+C/nurZuECU+ZcN0jOeAN9ZPUaZAE9lQvkcMgSEDsfxcqUsJ/2V3LdmMDXYnbsDN/1x+oYx5A+X9lCtA89P8TT6vuljvceBT/T0H3MOo1n8ACIH9WUB95zFkID0qJdCHbPV6FZRJ9pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVuVtEFieLOfY3BpK5pliDfBK7t7VlgyTTe6aSZs3lU=;
 b=kL1kqxk7FiitNJ+1dn88WWyOpsA3jBTrHVO2YdWpAQDZsDqNwJmx+HkrrsQB/qDFQvZih/8lZkCAqG73tUxvKnY35YfowOM6yWvFs8q7yCS3DcM3Rvhmfrc6iVcBRV8juguDcrzKi2W3bQW0+HpHKvWH6w7x3+wUIP35jF5YIaI=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by MN2PR05MB6591.namprd05.prod.outlook.com (2603:10b6:208:df::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 05:21:48 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 05:21:42 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAAgADERoD//5SOgIAAf+AAgADlBQCAAJecAP//sNOAgAB4CoD//522AA==
Date:   Thu, 16 Mar 2023 05:21:42 +0000
Message-ID: <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
 <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
 <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
 <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
 <20230315211329.1c7b3566@kernel.org>
In-Reply-To: <20230315211329.1c7b3566@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|MN2PR05MB6591:EE_
x-ms-office365-filtering-correlation-id: 34182f4b-0031-4ad8-ff95-08db25de5413
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UUcacrstKTMSydRP4mmU8Ak7FESBtNgUQt9qL9ZjZ9GSd9S9KIDkdf8K0//gAlBqTNIjoF1gzg+tJ1uKHw28cW5MbONOSP5umAlOweDgNUuVfYmyrM/xRUtFCSpuVDW5GeX7rvV9q2U9Ad11WqsEA6+lJZ7tmV6LR7+l3ygumVXfuuul8bH2BSoDC5Jwn5n/BOYYkM9mkGPXzVCoxY5v6s6ixHPYNcR1me1SnNAkOdfazlTB8zQbINRMgWfUtxpnNwzLzE/TgIjcYBNkoz4S8HX4WAAp73uj/oEaKM8bPU7lD0DyTiZ4StHpUpxaKi3iom2TW060SDdbZxb+Ov2189ne+Z7eFCAes0YkbsYGZ94OLlfSwWITOUgN3/KaQxW+l7q/RSp4+KkzfzlCZnmJX1J+BhSqKZlp9jlcJcZbRwa1XdDIfZz9OoJV5ZCU+g2hZvJ6VbxX6e/rcpbIz+uZNLPZmNQx+nfy0X7q6f1jZVid38BjJo6GKaefdB5P1oKUXtc0EwYfOH+HNEW3G0S9hB+YU0A4SY1J7BrFM9iMVKHRQiFxHtrLhU933fSBr0E856NYPL+GFDxzev6ILFjisbKIxzaTbPmVVGbtMTp1nrQ7RhOIy23jHtu1xXEIpvSGhc8R++xX6sIitruF4RNv9SP1Rr0Zw0u/tzpQmNeo4zrCPg0GN40/Sx+jLF7ec62yUoQjUP6978HHcEc3DG1+plQayi4xEy6I61YeUfnXSJZ7q406lzNKWJIohDUUqvIpAabkwqqJ6W8a6BgvXj4es7yJiIseTAjErTELNrX9yMZJiuRkLnPwqEeBt8cjAHqD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(186003)(2616005)(6506007)(6512007)(86362001)(33656002)(54906003)(36756003)(6486002)(4744005)(26005)(966005)(478600001)(38070700005)(71200400001)(316002)(66556008)(2906002)(66446008)(8676002)(64756008)(66946007)(76116006)(66476007)(38100700002)(8936002)(6916009)(4326008)(41300700001)(5660300002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnVSbnk2cUNtSWhsYVZIZkxLOTRZMlRQSmwvaXBQRGFKOUtMNDkxZHF3YThn?=
 =?utf-8?B?NDQwczA3NUMvS0ZLelFneDlPRDBvdUVQd3Q1Ung0UHV5Vk1ETkRvcGhEOUZP?=
 =?utf-8?B?Q2dJTXNxWXdRc0RIazdXU1h5UGdwWTc1cDRPeHNGUEpNcFRHYXFGU2luNklM?=
 =?utf-8?B?aEduWXFrMjBaamptTWFPek55TUk2THRMUk5BRXpwUm9SMWFWMDh6UE1Ed3l4?=
 =?utf-8?B?VXBZUkhCZGxBVURUUGNDcERCL1pOaERDWmtZeHdMVjYxL25YR1lUMXZBT0VI?=
 =?utf-8?B?TEk3NkdVd1hBQ2EvQ2IvM2w0YnFiUWxqVmdyTXRybjZMYVpRbDc3cHlCUVRC?=
 =?utf-8?B?amJJeXgzUmVzOU0vVjRkUDF2RVBhOXpqUExweHJXQSs1Y2lCNk14b2VjQkxK?=
 =?utf-8?B?ZTcxVDZqNVlXTi9OYzBZY1JwZ0pjU1dERlViUElJY0tFdktORm5lY0t2Mjlm?=
 =?utf-8?B?blhTYmlZSk5LODZMM3hWVS84MndvcHJWRGQ5bU5qM0lPUVFGSDhyWE05T3R6?=
 =?utf-8?B?Zm4rMVlVc1drcHYwMWVDOWhZZVBNQnBCbVFMR09PQ2ZtM3VCYWpRdmpidVk3?=
 =?utf-8?B?NHBxS2ZFbTlVRmltQklCYVBjRzA1elZMaHVac2F1NzJTQVhUVEt4dy9pdFdF?=
 =?utf-8?B?ZUgvYmtwWDY2RmFFS2pMdHdMZkp0cFNHZVkzTzY0enIrM3ZVaGdzblNvQk0z?=
 =?utf-8?B?Z1AzK0Z2eDU5TVMwQmRDaTFWZGlFYzd0azdEL0M3ZkJZSnpvdUNYU0Y0UzVu?=
 =?utf-8?B?V2oxdU1hZnhHUjZ5QWlTSHRpanhHY1FOZXEwNUZGWDlyV2drajRQRCtpQUxO?=
 =?utf-8?B?V0JRWHJnS0NvVzI1QXlHRStjTkFpZDdmQzhmR3QyQjc3NzNHV3dTbzJHbEkx?=
 =?utf-8?B?Qm9jTVBRaElsM25CcmlKdHdnVmFnUXRKU1BrZUU2L2l1OG8vVjRNUzdCV2lN?=
 =?utf-8?B?YXBkZXlMekhNSVpuNHQxUi9nMVRCVXNlSU9qaTh1bTFLZzJna1hrVDdYcSts?=
 =?utf-8?B?VGZVRkhCeVNoQmNFWkRHN2xCVDNNT2xYdStmM3lDaUhoL2lDRFhBY0xTSTUy?=
 =?utf-8?B?MHRWemVDNTQ1djhvbHhQSi9OVGgxMHllQnBOK2xIQ1llOWRjay9CZThKei9s?=
 =?utf-8?B?L3Vwd3BWNFYrUkRDL01lVzRLNURYSzBCdThrcnF0Nk4vbW1Ia0s1aGV5cnM3?=
 =?utf-8?B?Ny9HcVAweHBuVTZzbWk1RjJLeVpaZjJtVUtFS3Bwd3JGUi9HSWJDMWxRT2Rs?=
 =?utf-8?B?RHVHTzZOcEtVQnNBRW1TeEZtaGM4NVVTbFpNUDdXN3RndXRxVVZDRjFQT3FP?=
 =?utf-8?B?Y3ZxNmFESDJRaDlNbk1DTXRaOWJjMFl4WGtMc0pyMzA1ak4yb2RGUWhEWStC?=
 =?utf-8?B?YWp6N2g5cmVvZUpXekxhYytWdU9NOGZGREhKU0hDYUdycGdRc1lWU1Ewd2ZH?=
 =?utf-8?B?WmxPSEVGL3VzZ3JlcklGbDJOOTlDY2pldkxTbUZ5N01iK1M3bXZ1VGdnbWt3?=
 =?utf-8?B?cXM5a05NVHlobERNMCtmUmdNMkRsSzZXUHBIOHhjSWtVSEQrci8wR0diZzNZ?=
 =?utf-8?B?VFBEQzF0NHo1UDlGQU56U3g0WHd4OWVjSVh1Y2QzbVlNZ2ZCanZ3YUJlSzdC?=
 =?utf-8?B?SUN6Ty9qWHhkNmtWZjV0SnlkR0Y5cVBiMURKY2VCUnZYbFpiVlA2dzJCTENX?=
 =?utf-8?B?Zkx5bzFVMU0xRWFTV0ZZR2xta216dVVEbXhJS21tMjQ1T1hERGExREZpdTFw?=
 =?utf-8?B?TkdEN29VbWtDend3VkJIRXRQTkhsTmtqRC95MFNlRXltcnpsNW00SERHZFgr?=
 =?utf-8?B?aHIrc0RyN25pKzdpbmgvQjRpcUZmdHNHWjZIZU4vaGFxK3Y4QnlPTDM1dk9H?=
 =?utf-8?B?dmZ5SUQ0VUFES2k2Q1Y2c0ZOQ0xOM21MK3hnU2FRR0YxdnowdnJiM29aNDNq?=
 =?utf-8?B?b3NDK1NNKzliRDBrZUVQWDNiVFdlZmhYdjN1SE1QTWlJVzJpR2hFdStoZE1w?=
 =?utf-8?B?NnluUTFzK0pFYkM0QVFMeWNJU1V2ZHBPeTBGaWNBNS9IRmFzK1RBU3FSR1JD?=
 =?utf-8?B?WVdiU0JYeDNsV3VaK0lYbm9vRmJzSVZ2SjJHRXVqajBDRDh5SlJUSkRNUlRp?=
 =?utf-8?Q?VgyG2/bH3H1H2opndzRntK5mX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EB1E25288B3654BAC2BFCADA6E90A1D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34182f4b-0031-4ad8-ff95-08db25de5413
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 05:21:42.6465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/Qvu0h3Lqjkneu5tdnjMRJRF4sd5+F8/Ej9pvGtPXyrZJJgJCWTtbqqKsx24ETCHcvYwMqJILREHARfl0Yqeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6591
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IO+7v09uIDMvMTUvMjMsIDk6MTMgUE0sICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVs
Lm9yZyA8bWFpbHRvOmt1YmFAa2VybmVsLm9yZz4+IHdyb3RlOg0KPiANCj4gQ2FuIHlvdSBwcm92
aWRlIHNvbWUgbnVtYmVycyB0byBpbGx1c3RyYXRlIHdoYXQgdGhlIHNsb3cgZG93biBpcz8NCg0K
QmVsb3cgYXJlIHNvbWUgc2FtcGxlIHRlc3QgbnVtYmVycyBjb2xsZWN0ZWQgYnkgb3VyIHBlcmYg
dGVhbS4gDQogICAgICAgICAgICAgICAgICAgICAgICAgIFRlc3QgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBzb2NrZXQgJiBtc2cgc2l6ZSAgICAgICAgICAgICAgICAgICAgICAg
ICAgYmFzZSAgICAgICAgICAgICAgIHVzaW5nIG9ubHkgZ3JvDQoxVk0gICAgMTR2Y3B1IFVEUCBz
dHJlYW0gcmVjZWl2ZSAgICAgICAgMjU2SyAyNTYgYnl0ZXMgKHBhY2tldHMvc2VjKSAgICAyMTcu
MDEgS3BzICAgIDE4Ny45OCBLcHMgICAgICAgICAtMTMuMzclDQoxNlZNICAydmNwdSAgIFRDUCBz
dHJlYW0gc2VuZCBUaHB0ICAgICA4SyAgICAgMjU2IGJ5dGVzIChHYnBzKSAgICAgICAgICAgICAg
ICAxOC4wMCBHYnBzICAgIDE3LjAyIEdicHMgICAgICAgICAtNS40NCUNCjFWTSAgICAxNHZjcHUg
UmVzcG9uc2VUaW1lTWVhbiBSZWNlaXZlIChpbiBtaWNybyBzZWNzKSAgICAgICAgICAgICAgICAg
ICAgICAxNjMgdXMgICAgICAgICAgICAgMTcwIHVzICAgICAgICAgICAgICAgIC00LjI5JQ0KDQpJ
biB0aGUgcGFzdCBhcyB3ZWxsIHNpbWlsYXIgdGVzdCB3YXMgZG9uZS4gU2VlDQpodHRwczovL3Bh
dGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZGV2L3BhdGNoLzEzMDg5NDc2MDUtNDMwMC0x
LWdpdC1zZW5kLWVtYWlsLWplc3NlQG5pY2lyYS5jb20vDQoNCkJ1dCwgdW5mb3J0dW5hdGVseSB0
aGVyZSBhcmUgbm8gc3RhdHMgcHJlc2VudCBpbiB0aGF0IGRpc2N1c3Npb24uDQoNClRoYW5rcywN
ClJvbmFrDQoNCg==
