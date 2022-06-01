Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4C539CAD
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 07:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349673AbiFAFfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 01:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349667AbiFAFfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 01:35:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15599E9DD;
        Tue, 31 May 2022 22:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgFmkrboEj/hSwQrAKZuFPym2dPe3sDyQk5jNhduXIwN4BzK674PJWAyX2dS7GvylghaIp0ySMv2QZ/XDwKF807hnSOGvFrVbCM2ydw4IQ8LwX1fGehyQsqN5ZlOrsGLUFmEvk2NgVCBUb47fGFTEcnCtfRhvaGKqw54j15XSdXTHQCVrVDM0FZ2G8fMp0jwGbOI9t+qLs9i17354hLgFHdDiWSo7D3i5OzxLNfqNo1i8DCZKVRDIJK4+9WC7vySfpStpWUcRTKLimSZsfbRpLDcmyHe+6df4a8qCj7wwxOPyB75qXYmWehCfm2D38CWlx34PlVcL0/Y0L5IyDpHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0JD2AsvCfTkW/MJD+b3wed5BEMAQ1JyXoGUpS60vl4=;
 b=Yp0hQAqGpTLki10oNkk78+UIkQiXniXSY/iNhSeAM4mVJ4QNZ91q95f9tq29Ptli85Q3ahvf322Mc+QHhpb0Adbm+yyr2PtSM8fl6TDadFFmMTpG0rKQfJZM3DN2BAvDndDsCQP/4H0MU8NmRddTtZRtOqmWtBupRWv6tOUmrhmC6XTmfVMvPhWPahhs92/8ZYmedBoYXYak+QgWi0bUWQ/q0HuGLWzSqIpbZyeq44pGXnqTE6GN6timRxYnQ08+rj9fUbx+++l7aXku2b6m+YR38EWDeBWe/JkIElMq4hNt7VoEPxrxU8NHySiDEf3c+HWomsiEd7lDAWt5PF7eLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0JD2AsvCfTkW/MJD+b3wed5BEMAQ1JyXoGUpS60vl4=;
 b=lSr/jlp7WwToLrSQPtIUdYfLtb54YsB36MAMvs9uLO+n8yQKK64yFTFLS/x7mQO0BvjSlvFmwCkmf5dDn+myA5ucyItftiqXmq8WrurruC62FIS8l1UswWkeRySpjB6a29Npa7AiJxUSo4TPE06FLlchpTyTZCdRSF6hEfYmDEpfe2TvVQGr57vSdKU7hpUIMghJnybE1RZhGwxVDfl0vck1EfKEG6W0KbWv8oLpYIBoZa8zzbDopkydha/MxZn2RVwIUrbTMiDf+gwOvnAwaxa4w/Q+Ou57UzdbAC8w5JJD18GcR9fqaDXzRZxZc2fvih8EUu9eRQS1sIwy+nV/7A==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Wed, 1 Jun 2022 05:35:02 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::a196:bbcc:de9d:50a5]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::a196:bbcc:de9d:50a5%9]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 05:35:02 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 1/4] vdpa: Add stop operation
Thread-Topic: [PATCH v4 1/4] vdpa: Add stop operation
Thread-Index: AQHYcP5EGEH7BNSbuEefe5Ty4AkMiq06EBbA
Date:   Wed, 1 Jun 2022 05:35:02 +0000
Message-ID: <DM8PR12MB5400573627EEB71D774892C4ABDF9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-2-eperezma@redhat.com>
In-Reply-To: <20220526124338.36247-2-eperezma@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79fbff86-35e6-44f2-af1f-08da439079a3
x-ms-traffictypediagnostic: PH0PR12MB5433:EE_
x-microsoft-antispam-prvs: <PH0PR12MB5433C258963B445576AC1266ABDF9@PH0PR12MB5433.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6yS1daGATVlCzj7XHUlS3ByDwYG5JoPt2ZqRZaPkj/YeEao+KwxZByO5z1VeCcpq7jEHybXA85+wH1dJ2smd8Twlh3wSLLgSCOeyJog/QTUnuupi8xdOJxezbyH87su3Xe/mmfTY++7mEDPcTTaQ5iJs2kdY/zqh7DqaQySp4/HYCpFKvu3A8Nhs2wggftklh0bLqltaSdIZ1eTLr/FwlLIiThBg1UWYy6yFGbvPk36Omnw901bdyNE3PtIyt8UAMBRn04zHRm9KaxWDdSDqFGDIqR4X66gIKyhwC+ZE+UmcY1CKjoiRLDmX1jl4evXS6OubwDcYum1pMnzRWivDP+yTQ81ly/8epwR1vZMaU1DpIImSadRHMhBc1s0fCkELAYoFD8xxZtVc52pcU7fm0biLAUy+EmGtr6h2zzooOXe+L+X5hazKv8KoDFQBrQiEfme6n5vHkfRSUTyOXHM7p+eCmch7RqczUqFVRfrAB/wp/oxAejCFNPVsYiPjvDIOLNd2zghBkajqTkqX2kidZ66tVdcElkeylOxghdwviuspglGU2P55qSlQxwm+TQKneZFdJCxY4kbueXZURGKZpS2nuevy8Rc7WKF4lQM5IADGbw8PgX9sufQb9u7fcS59ohYZofmrttgkAxJ1oBmF/Tjx7bkcFdI1AtU3VKFrEkXRXwIMXEJC4IWy6vMEXUKGrj6fjtv+3em6TZfRbG3O8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7696005)(9686003)(53546011)(26005)(186003)(76116006)(66946007)(66476007)(66446008)(66556008)(64756008)(8676002)(4326008)(86362001)(71200400001)(54906003)(110136005)(55016003)(316002)(508600001)(5660300002)(33656002)(122000001)(38100700002)(7416002)(2906002)(52536014)(38070700005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDV5U1Rmb3dkVEUyMzFYV3VtQmtuTlFlMFhXR0NhdUd3cnd2NFVoYU1YNi9Z?=
 =?utf-8?B?dFpCOEJJZnJib1QyOVJ3TXVYVFJBNTE2SHYxcXRJOCtXOU9EZTVjeHQ1MWM3?=
 =?utf-8?B?eVdMeWdPNld1MjFXdHFtOEUvdkJYS3ZHVStWcFdINzc5eklIRDQ3TmRqV0Zn?=
 =?utf-8?B?eWZFUDVneFZ5bjZLSklTODVoZkJNQXVSSzVXUDg4OGdJQmt6R21LRUEvYU5H?=
 =?utf-8?B?ck4ra2JzQ0ZsN1RBekI3M2lrb1BmLzVZVE9GdlBvMWRITU5qK1NGRXZaNm5D?=
 =?utf-8?B?OGl4VVdaN0Z1TTNQV09pSUR5ZUpDRjBPMXJpSjJ5OTVDYkV5a2FFQ2sxZHVI?=
 =?utf-8?B?YW9SSlc5UTdkeS9ldkNjMEdUQUZEOXhDOE9UNGoyelgwQzVhVFpuSkljUE9Y?=
 =?utf-8?B?cm9QVEpmc1R3S2hYVmk2TVU4NVVRamhNYXNza0dmWGkxWEdGVnRXR1JTZ0xs?=
 =?utf-8?B?bmlwYnlUMklEeDl5ZVB3S0s0YVNwdDNEdHNaNXl0Mk92aEwxZVcyR2x2OGxS?=
 =?utf-8?B?RkxnQzAydlA1a2p6TkFjM0RGeUJHT2RQWlJiMyswM2VXRENydHFtcXlGeTZq?=
 =?utf-8?B?WWNjVjdxVHhYbXBtWThUODBOSVA2WURVdnhoNTBrNmRZdHdLTjJvMG9TZFhh?=
 =?utf-8?B?ektOSjhDMGt4dW1yN1dUbUMrYjVhVzczeGFZNzlSS2R4ZTgwVzdueVhNKzhE?=
 =?utf-8?B?WFMxWGxEQ2hnODQ0aWl3L2MwUWZpeUxBdjd5eFJadkVqWjBjaUExNWJydnRO?=
 =?utf-8?B?Q01uRTg5eGtpUmtLVDNyMGt4NHVhNTBTd3dRclRJQkJaWWhTcjloanF2aXVN?=
 =?utf-8?B?TFJTck9IWDV4cUs2d0dEL2M0TDF2aENpSDlTdEE1Vy9laldVNkNGZnFrS1lV?=
 =?utf-8?B?dUF4aGlOd3h5TFJKcGQ3TDM5VlZNOFlwNVZQTlpoaHVpSmdNZHU1SFFpeEtk?=
 =?utf-8?B?R1B2ejZtNElqZjVhcGdZdjBwdlNPREwzcGdESTQraHVhTjJyZTE2NVJXbVNY?=
 =?utf-8?B?Q1gxaHExNEovV1lsZHFLUnBHbHdJSmFaK2x3d2VkZ052MFFBb3BpWDhTSjFp?=
 =?utf-8?B?M1FKaERsTUxpMnVHaVpZN0dXQ0JQc1gzOUdJeko4SFNBOVNhNEpWNUdrQm90?=
 =?utf-8?B?MjJhZllaOEJVSFRTWGVWUC9ZR005c1hBZHBKRG1KdlhrcExHK3JuVUc0blRn?=
 =?utf-8?B?c0l1eWVsT3JDUVpHeTJKM0xENE5mVEU1L1Qrb2hVS3hpTm9RY0ZLWmVkMTJS?=
 =?utf-8?B?OWx5STZtMXYvZ2QveXFaMkppOWo2RWRBbHJKTkF1dVU3YXZaMFFtQ3I3Qjd1?=
 =?utf-8?B?dElFNnhOd2FYT2RLYzAxd1pkS0prYUg3YnRrUDBoVVBKZTl2cERqWXZYU01z?=
 =?utf-8?B?YWMxSHJNK0ZieDdQUEJMckpwOVZuS3UyNWRGWHZhMVF0RlpsRS9XNVhMWlR3?=
 =?utf-8?B?SlVqazVDYllGckM2YjViRFk4bmtYYWhKWmdDdXlMdnh5SmFBQ2tMSGxDTzR1?=
 =?utf-8?B?Wk15TUtUaXFkOG44aU0rNUorMEljK1AxMUlMSTdNR1JkT1YwVXRzMkdnYlRq?=
 =?utf-8?B?NFJYNlBPQURRd2lyT0czUGp5OUJhaDcxK09od215SUJxMjVsTG93b1FUbGc3?=
 =?utf-8?B?ZnRsNFRwQ2xqcHhyb2xVYWJWWHZOSllydXRYdjBNRjVTT1o3RmZrelExM2xQ?=
 =?utf-8?B?alZ1MXVCOG5TU0NCZFg4ZnIwK1NqeUxTY0ZlelNCVmcrK240NXZrNlR0SXRp?=
 =?utf-8?B?c0hFTDE0V3ZUSlBQQ3doZmJGbWVESzRKTlNlS1pvRnMyUDE2NjgwUmFJaWJT?=
 =?utf-8?B?UmVnQVVzYkg3bS8vZW9Fa3JuZ2RBcXZCN0RFY0NmQThwNWlIQ2MrNHhrSnBW?=
 =?utf-8?B?bzY0WnRsZy9qL2NQd3daQVlCU29uTkFacTZuVURsbTNGclFTaFNzM3ViUEpP?=
 =?utf-8?B?RGhrMmJ5SDRhWm1tcWtoTE1yakNOVk5Hbm5JcHRiQmdaWkhXUzlvMWFxRTFk?=
 =?utf-8?B?Yll1Sk5iK3laTWh3QXZBanZzSkJ3dldCUThKYWsvWW9BT0Rpd0tmeWdycUFW?=
 =?utf-8?B?U1NQSnhpaW81ZnYwSXg4RnMvY3J3a2hvUHFOWS84QlZMMHp5NDU0NEw3NS90?=
 =?utf-8?B?eUVLVno5OTlkQ21iTUxiemtMZS9CS0tPa1o2cFRkTzVzU3V6RmxIbCtPL2M0?=
 =?utf-8?B?QTdESFd3aC9wa1RXMW0yaUl2VXVhN0J2aWF2QnNtYmtaanZuRzZxdGgvWjUv?=
 =?utf-8?B?VEFodElzUE1pdmFLVzVxbitLbWRTd0NER29rRUhwcmxPUjlQRTBzSWVzNGYy?=
 =?utf-8?Q?s+3lIZRsewvpa2puCP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fbff86-35e6-44f2-af1f-08da439079a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 05:35:02.1156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cKm8h9nA58DVjDbsZ/bYYhVeWpI9rmvC1JoMRAj9rV4CPAtLeET+TVyfHv6PRwWJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBFdWdlbmlvIFDDqXJleiA8ZXBlcmV6bWFAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1
cnNkYXksIE1heSAyNiwgMjAyMiAzOjQ0IFBNDQo+IFRvOiBNaWNoYWVsIFMuIFRzaXJraW4gPG1z
dEByZWRoYXQuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6YXRpb25AbGlzdHMu
bGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IEph
c29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+
IENjOiBtYXJ0aW5oQHhpbGlueC5jb207IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVk
aGF0LmNvbT47IG1hcnRpbnBvQHhpbGlueC5jb207IGx2aXZpZXJAcmVkaGF0LmNvbTsgcGFibG9j
QHhpbGlueC5jb207DQo+IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT47IEVsaSBDb2hl
biA8ZWxpY0BudmlkaWEuY29tPjsgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUu
Y29tPjsgWGllIFlvbmdqaQ0KPiA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+OyBDaHJpc3RvcGhl
IEpBSUxMRVQgPGNocmlzdG9waGUuamFpbGxldEB3YW5hZG9vLmZyPjsgWmhhbmcgTWluIDx6aGFu
Zy5taW45QHp0ZS5jb20uY24+OyBXdSBab25neW9uZw0KPiA8d3V6b25neW9uZ0BsaW51eC5hbGli
YWJhLmNvbT47IGx1bHVAcmVkaGF0LmNvbTsgWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50
ZWwuY29tPjsgUGlvdHIuVW1pbnNraUBpbnRlbC5jb207IFNpLVdlaSBMaXUgPHNpLQ0KPiB3ZWku
bGl1QG9yYWNsZS5jb20+OyBlY3JlZS54aWxpbnhAZ21haWwuY29tOyBnYXV0YW0uZGF3YXJAYW1k
LmNvbTsgaGFiZXRzbS54aWxpbnhAZ21haWwuY29tOyB0YW51ai5rYW1kZUBhbWQuY29tOw0KPiBo
YW5hbmRAeGlsaW54LmNvbTsgZGluYW5nQHhpbGlueC5jb207IExvbmdwZW5nIDxsb25ncGVuZzJA
aHVhd2VpLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIHY0IDEvNF0gdmRwYTogQWRkIHN0b3Agb3Bl
cmF0aW9uDQo+IA0KPiBUaGlzIG9wZXJhdGlvbiBpcyBvcHRpb25hbDogSXQgaXQncyBub3QgaW1w
bGVtZW50ZWQsIGJhY2tlbmQgZmVhdHVyZSBiaXQNCj4gd2lsbCBub3QgYmUgZXhwb3NlZC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEV1Z2VuaW8gUMOpcmV6IDxlcGVyZXptYUByZWRoYXQuY29tPg0K
PiAtLS0NCj4gIGluY2x1ZGUvbGludXgvdmRwYS5oIHwgNiArKysrKysNCj4gIDEgZmlsZSBjaGFu
Z2VkLCA2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Zk
cGEuaCBiL2luY2x1ZGUvbGludXgvdmRwYS5oDQo+IGluZGV4IDE1YWY4MDJkNDFjNC4uZGRmZWJj
NGUxZTAxIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3ZkcGEuaA0KPiArKysgYi9pbmNs
dWRlL2xpbnV4L3ZkcGEuaA0KPiBAQCAtMjE1LDYgKzIxNSwxMSBAQCBzdHJ1Y3QgdmRwYV9tYXBf
ZmlsZSB7DQo+ICAgKiBAcmVzZXQ6CQkJUmVzZXQgZGV2aWNlDQo+ICAgKgkJCQlAdmRldjogdmRw
YSBkZXZpY2UNCj4gICAqCQkJCVJldHVybnMgaW50ZWdlcjogc3VjY2VzcyAoMCkgb3IgZXJyb3Ig
KDwgMCkNCj4gKyAqIEBzdG9wOgkJCVN0b3Agb3IgcmVzdW1lIHRoZSBkZXZpY2UgKG9wdGlvbmFs
LCBidXQgaXQgbXVzdA0KPiArICoJCQkJYmUgaW1wbGVtZW50ZWQgaWYgcmVxdWlyZSBkZXZpY2Ug
c3RvcCkNCj4gKyAqCQkJCUB2ZGV2OiB2ZHBhIGRldmljZQ0KPiArICoJCQkJQHN0b3A6IHN0b3Ag
KHRydWUpLCBub3Qgc3RvcCAoZmFsc2UpDQo+ICsgKgkJCQlSZXR1cm5zIGludGVnZXI6IHN1Y2Nl
c3MgKDApIG9yIGVycm9yICg8IDApDQoNCkkgYXNzdW1lIGFmdGVyIHN1Y2Nlc3NmdWwgInN0b3Ai
IHRoZSBkZXZpY2UgaXMgZ3VhcmFudGVlZCB0byBzdG9wIHByb2Nlc3NpbmcgZGVzY3JpcHRvcnMg
YW5kIGFmdGVyIHJlc3VtZSBpdCBtYXkgcHJvY2VzcyBkZXNjcmlwdG9ycz8NCklmIHRoYXQgaXMg
c28sIEkgdGhpbmsgaXQgc2hvdWxkIGJlIGNsZWFyIGluIHRoZSBjaGFuZ2UgbG9nLg0KDQo+ICAg
KiBAZ2V0X2NvbmZpZ19zaXplOgkJR2V0IHRoZSBzaXplIG9mIHRoZSBjb25maWd1cmF0aW9uIHNw
YWNlIGluY2x1ZGVzDQo+ICAgKgkJCQlmaWVsZHMgdGhhdCBhcmUgY29uZGl0aW9uYWwgb24gZmVh
dHVyZSBiaXRzLg0KPiAgICoJCQkJQHZkZXY6IHZkcGEgZGV2aWNlDQo+IEBAIC0zMTYsNiArMzIx
LDcgQEAgc3RydWN0IHZkcGFfY29uZmlnX29wcyB7DQo+ICAJdTggKCpnZXRfc3RhdHVzKShzdHJ1
Y3QgdmRwYV9kZXZpY2UgKnZkZXYpOw0KPiAgCXZvaWQgKCpzZXRfc3RhdHVzKShzdHJ1Y3QgdmRw
YV9kZXZpY2UgKnZkZXYsIHU4IHN0YXR1cyk7DQo+ICAJaW50ICgqcmVzZXQpKHN0cnVjdCB2ZHBh
X2RldmljZSAqdmRldik7DQo+ICsJaW50ICgqc3RvcCkoc3RydWN0IHZkcGFfZGV2aWNlICp2ZGV2
LCBib29sIHN0b3ApOw0KPiAgCXNpemVfdCAoKmdldF9jb25maWdfc2l6ZSkoc3RydWN0IHZkcGFf
ZGV2aWNlICp2ZGV2KTsNCj4gIAl2b2lkICgqZ2V0X2NvbmZpZykoc3RydWN0IHZkcGFfZGV2aWNl
ICp2ZGV2LCB1bnNpZ25lZCBpbnQgb2Zmc2V0LA0KPiAgCQkJICAgdm9pZCAqYnVmLCB1bnNpZ25l
ZCBpbnQgbGVuKTsNCj4gLS0NCj4gMi4zMS4xDQoNCg==
