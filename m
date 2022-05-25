Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F754533B9F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiEYLXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiEYLX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:23:29 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954488D6BD;
        Wed, 25 May 2022 04:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmiiBCCwd8VnqvIv4n09xG6IqoUTZY1zU1k6n9hqX/2cLpFfq6HcKMWYIl18DkM0iNF0ii8xXDQ4eU+rVc8wU/Rp1uWHUr4OFAe0Jn+5L6dE180YdvWaYvPWJy/VahczjMvj3LOdLdEAssCVALGyaK5E9SKC+sBdBaz4pWGHBzft7nJHgXellaTwXRIZ5ZfmtAxKA5iEazPcpywwHTtCw4h7NO7Opjy5iGK/9gre8GxD4pxvijyrcd1WemoEGE1Dl19D11bQUZ0uOsm58GNMGWycntf198MLDH+LsdcN+EksrcThUL3QHVFiRDUIsmG7SP4sddo4OpLsnY1OS6Zi8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUdTewmOSiBxaO91F1wuzTFevDDDVBZ8WexDi+0Mnf8=;
 b=e3cqVUDDiH8lDuvBmryyeJL+El21TFPwj6GOo+gfJA9deNLILXVIjLnoSMjkCDwt73YB5yrcnr2/MzjbokDaMz+4wGiOibq9m9TrWAh0SCDlRmXhs4AEYkwMbr1cXltEOC5MWvyOAVeYuX0wUs/noCoXktdyODqfg02uZ2f4jXo3D0BSJQ3Vb2NzOUmD2miT7aoavUqauypikAH4QuUIcEkKQZsoAA0UoKKzOoTO8B39kedO7bGWQi/ZfNGXLghCizylDUmvHvCiHg/1CwG+9IQGEHSE3otbP80PdhSamepr84E8o+TlXPv3Rh1APi0tI0HdAZylPbuzsYGoCpgSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUdTewmOSiBxaO91F1wuzTFevDDDVBZ8WexDi+0Mnf8=;
 b=NXRGZgV7LMrhg80bcnyIb03SSSR4XeNOxI8qu2aMb1r8a0Dc3Phwbz+kFsQV2MK+FkVOG1OpWqeA+MeOoZ+p77dpwtu4/mEsv6u7KdGjZuBR4u13HcvnJSPX+lzdPFSWEK/qmPUn7plxM4WnfRe33blpPdJ/5cQSPoLuCGK5ajY=
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by MWHPR1201MB0238.namprd12.prod.outlook.com (2603:10b6:301:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 25 May
 2022 11:23:20 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6d64:a594:532e:8b84]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6d64:a594:532e:8b84%5]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 11:23:20 +0000
From:   "Dawar, Gautam" <gautam.dawar@amd.com>
To:     =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>
CC:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Subject: RE: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Thread-Topic: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Thread-Index: AQHYcCaejZ+EcmRq3k6Nyj6LKxIuA60vcvXA
Date:   Wed, 25 May 2022 11:23:20 +0000
Message-ID: <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
 <20220525105922.2413991-3-eperezma@redhat.com>
In-Reply-To: <20220525105922.2413991-3-eperezma@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7568f509-c684-4671-8f9b-000072b9f51f;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-25T11:21:52Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87a1fb27-8108-4c7d-49ed-08da3e40f902
x-ms-traffictypediagnostic: MWHPR1201MB0238:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
x-microsoft-antispam-prvs: <MWHPR1201MB0238178972AC950FDC78A8F299D69@MWHPR1201MB0238.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dr4fj/ViAAFcqDr6O0+NRp88zvePh+gLMWnMifqbRysmzc/ks4DANtOFOna2RMYxcaY/X0lkYVvqhJ+4yT13epr9uM+OpKENS2yp7LONQkSinjYTGLj6hzXOwy39bVlh3+n2cwdBOOu2ExCjkKQewiYQyfJ8ZS50YwogUxVcxHT3Y0zEYRTSvwlXOPUPggxWBfsu7JjnSk1fRt0bS3bgKVhA260Y8oarZd5pmDIK2VM02KSjz56f7FbjbnUN7PRujzXoSpCK9M4iYGGOhXdwZOP6xbx3WLDABomgM5/AVSUzfK1XdBO6EB4f4WSwIrZ7B/6Ppm5I89YBHpBj/UMvc2NSEPsdwQ7AP6cseuEbeEY5EMNOv35J0sR8RGOyEaGpasiyUs+/t7VKxx/fYXX0EP1ra1CFBNR2oZmm0IvtOkXfeytQlDfGE9vcObvrPFmpnGye7dg9DQ4uNNjbLADRpzMXADIsCbo3XhcHu0XK+hhFWRDXj8Uno0LQlHiJQFiHpXoGEVilrkOS4A/Ib11JPB4tGinNHUU5QUCOoRgLh8d96g4qNljQ8uqBQ4UQgIb/cKLKEQz5oSeKzzTRyIYZEQBJv9N5MPxiFwBlYYnkR97Wo7lnBKdRwLs4otuPKcM06PBIGjS/tje8EljkhpLXHWU6Zpz7c9SEJPEz/valhG8hFeRZinddRRIg2vya8vFvTUXqLMVBEJLEg8H8XyrXJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66446008)(66946007)(66476007)(66556008)(8936002)(107886003)(64756008)(7416002)(53546011)(186003)(4326008)(33656002)(7696005)(83380400001)(5660300002)(66574015)(71200400001)(8676002)(6506007)(52536014)(54906003)(508600001)(122000001)(316002)(55016003)(38100700002)(9686003)(26005)(86362001)(38070700005)(2906002)(110136005)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVF5dEd0NUNtQk1GQU1oUkxjR2lGeHJENlF3RHBJU2Fvbk5UbEhmVzdUZlVQ?=
 =?utf-8?B?bzNlclBIaDQvcHJsbm9VTmJjamJjSW5zcnVxUXVqYjZwNGZWdzFRSVFjaDNs?=
 =?utf-8?B?SUhTR3pTOFE3WTdlZzRkaUVwUmNDaTlsZlg1SW5XMG92VTBtdDYvNnhNdXZq?=
 =?utf-8?B?SDdoUjJ6WWJMMDVXSytybWo5UmZPNitiVmlqSTc1VldiK2dqamo4ZkxxeEMv?=
 =?utf-8?B?ZTFPK0pEWUdqcXI4b081eVhDUGhPbWFpaGlMeGtERmpoNS90ckFFNmVDT2pB?=
 =?utf-8?B?VDc1Yms0NnFEY3UwenpvOFRHTkNxcTN6UzRKWjNHRlgzRS8xenRJWVZBRnlF?=
 =?utf-8?B?WE9OalcyOTJ0OGQ4RVVPdW9WRThVTi83dzczVUxFUlBkVG5jUk1SV2Mxb2Q2?=
 =?utf-8?B?MjU2SDh1NmxyVjluMDNCdVV2RHlFODdkSzcrT245VWpPeXlZT2Y4c1g1b2l1?=
 =?utf-8?B?WFYrbjhaZS81VmdVSW9GbXh0OXlVRysxYmFTcFJWdFNhcitlU0NYdVZIKzZL?=
 =?utf-8?B?S2JHeUVzUU9Mb1lMcitFZzh5c3h2V2ExNm9RQWhvdUNkdFVEbjNjczFnd29Y?=
 =?utf-8?B?ZXRzd04wbENvM2ZPNUo1Z3ltSExkaTRkdko4b1hucDZLMDFlM0lPSWYvY3Jz?=
 =?utf-8?B?RytJaFFlZGV1bXRDUkQ3b2JKWVEwNHo5dlZveUduSjBDREZNd1dMTmlibk80?=
 =?utf-8?B?Q3ZsWnNlMGUxWjJQVXA4YnlQM2hNdUtTVmdGTGVaVDZFYWpLb0t3Y2lxRitp?=
 =?utf-8?B?em9TdXFxK1ROa2MwbFZXV0pvSE5YOThPYitKNVNlc2ZmWlJzN3l2UFdmUlJw?=
 =?utf-8?B?NnBGcHE2SkRreUF0ckZ5elNiTi9XV2IzRnVNVTNhbDdiNDN4TmNwUWVjM091?=
 =?utf-8?B?YlIwVUh3bE9ndGtrOGtScXVadXZZMGczcmY4VndZS0JnM3NmWDFRRVFaVmdJ?=
 =?utf-8?B?UkVkU0t1VXJZMTA1bko5WnpBZ0ZkRDE4OHJZYU5qd25XMHVQRzVaejlkeE9V?=
 =?utf-8?B?N3VYWlh3RTdaV0ZzRm9hOFVrazJkOVRUOHhIUTFEREZZWXFMTFB5UG9Tak1k?=
 =?utf-8?B?VEVhcXBtTlRkeVBxaGdjTlVydHhIMG5lcUloNkwyOG5ZZFl6MDNac0tLK01l?=
 =?utf-8?B?OTZjbGNUMXRPNVIxbmFyR3dBdXlwRmpveEhWd20rUE9UTzRqVnhUd016N0Nx?=
 =?utf-8?B?aW85bjNHd1hicG1HbzFhYkdHUHd6OTlzNXVCZ3BSRGdqcXcwcitrMG9TenZ1?=
 =?utf-8?B?b0lZY3I4Y1ptVmQxZFJtTWFiQVRYc05VTDYvb2JaZTJnRnlTS282a1ZNd1lh?=
 =?utf-8?B?RW1xYXduOFpscktXcUdKaVpDbE1ZcWZRT2J0Q256Tk1TYUhlK1FOa3FidWRq?=
 =?utf-8?B?ZTkrMThpUjMwN25MdUx6KytnZHVENkkzQ2NxbE5LWFNLTG9iYlFEcm9kU0p6?=
 =?utf-8?B?L3BhcWU3SXFrYmxoOHlhUWVJUG15bGhqdDZLM1BVZktuN2VsV0dCSXZiSzhY?=
 =?utf-8?B?SmRFZjVoWkE2dG1OT2VpWVBsc3V6dW5OWjdqdi9aOXpBSjZnWFpjSWhMU3Bv?=
 =?utf-8?B?cGI3WlptcXRINXZPelZ4SC8rSXByUjlTaVMxUlA0ekttK0hvamRjS2RwQlJx?=
 =?utf-8?B?UDB2bUJuSHUvVHptMUM5V2NXbWFKcUo1emdCMEd3NzY2OTBqd295YTk5Zk03?=
 =?utf-8?B?UkYzNm9rRkVHNDlUS1ZTOGNXQ1RscXJBWE1nNk9MZ3E2VWZ0M2F4MzFaWUg3?=
 =?utf-8?B?UjFRKzBBZnpFdzZBTXlGdXpYbE0vTTg5MFdYbXFOeHNnV2ZlWVdYWWczQWhJ?=
 =?utf-8?B?Ukl3TTBUNWJmT2NjNlFuNzl3UUdYNGZVVjFhUmJVYjQyK3NpZXJCeU1qbmhN?=
 =?utf-8?B?Z01JaUIxZWxCM3JIbVFGcHJ4blFsQUExQkdWQW4xMk9rY2F6aXFTbkhURUh3?=
 =?utf-8?B?c3NJUjAweDF1bmNHZS9RMXREZW1XVXQrSG81YUVLTDBnWTNmVzdDQ3pnc1VE?=
 =?utf-8?B?eDRSZk9GSTk2WWJ6aUlPK0lZWDhtbEZpV2pIK3ZYQXR3SWtZL2g4K1dtT2NX?=
 =?utf-8?B?THlvUmExTzM5QUpOQ1RmbDlJT1Eyak5NbllGcEk5aUZnWkNjYWVycHdvbE5N?=
 =?utf-8?B?RTdPL0JPdnp2SVprN3RTNGhHOVNIcW1kNEhGTUNVMEN2Y2QvQTNFUDEzQWtX?=
 =?utf-8?B?TTFJK3Z4OXNtN25XbFlVU3Z6T25XZ0czRVNNNmRSS0FpWUI4UHRGMXEyOGhk?=
 =?utf-8?B?TkZ1dzFydEVVTEoxa3JlUnlGeUlZTk1UcWh3ZDFvK2wrTC84NVRhckRNUG5W?=
 =?utf-8?Q?AIaKzrV7KlAeeFmE/j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a1fb27-8108-4c7d-49ed-08da3e40f902
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 11:23:20.2383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejP3jE6SS33PU26aKheF9TT1B1UgFwsmnzdraJkXvdq4lHJz9s7UjZE2jntkySEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBFdWdlbmlvIFDDqXJleiA8ZXBlcmV6bWFAcmVkaGF0LmNvbT4NClNlbnQ6
IFdlZG5lc2RheSwgTWF5IDI1LCAyMDIyIDQ6MjkgUE0NClRvOiBNaWNoYWVsIFMuIFRzaXJraW4g
PG1zdEByZWRoYXQuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6YXRpb25AbGlzdHMu
bGludXgtZm91bmRhdGlvbi5vcmc7IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQpD
YzogWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPjsgbWFydGluaEB4aWxpbngu
Y29tOyBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+OyBlY3JlZS54aWxp
bnhAZ21haWwuY29tOyBFbGkgQ29oZW4gPGVsaWNAbnZpZGlhLmNvbT47IERhbiBDYXJwZW50ZXIg
PGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT47IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNv
bT47IFd1IFpvbmd5b25nIDx3dXpvbmd5b25nQGxpbnV4LmFsaWJhYmEuY29tPjsgZGluYW5nQHhp
bGlueC5jb207IENocmlzdG9waGUgSkFJTExFVCA8Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28u
ZnI+OyBYaWUgWW9uZ2ppIDx4aWV5b25namlAYnl0ZWRhbmNlLmNvbT47IERhd2FyLCBHYXV0YW0g
PGdhdXRhbS5kYXdhckBhbWQuY29tPjsgbHVsdUByZWRoYXQuY29tOyBtYXJ0aW5wb0B4aWxpbngu
Y29tOyBwYWJsb2NAeGlsaW54LmNvbTsgTG9uZ3BlbmcgPGxvbmdwZW5nMkBodWF3ZWkuY29tPjsg
UGlvdHIuVW1pbnNraUBpbnRlbC5jb207IEthbWRlLCBUYW51aiA8dGFudWoua2FtZGVAYW1kLmNv
bT47IFNpLVdlaSBMaXUgPHNpLXdlaS5saXVAb3JhY2xlLmNvbT47IGhhYmV0c20ueGlsaW54QGdt
YWlsLmNvbTsgbHZpdmllckByZWRoYXQuY29tOyBaaGFuZyBNaW4gPHpoYW5nLm1pbjlAenRlLmNv
bS5jbj47IGhhbmFuZEB4aWxpbnguY29tDQpTdWJqZWN0OiBbUEFUQ0ggdjMgMi80XSB2aG9zdC12
ZHBhOiBpbnRyb2R1Y2UgU1RPUCBiYWNrZW5kIGZlYXR1cmUgYml0DQoNCltDQVVUSU9OOiBFeHRl
cm5hbCBFbWFpbF0NCg0KVXNlcmxhbmQga25vd3MgaWYgaXQgY2FuIHN0b3AgdGhlIGRldmljZSBv
ciBub3QgYnkgY2hlY2tpbmcgdGhpcyBmZWF0dXJlIGJpdC4NCg0KSXQncyBvbmx5IG9mZmVyZWQg
aWYgdGhlIHZkcGEgZHJpdmVyIGJhY2tlbmQgaW1wbGVtZW50cyB0aGUgc3RvcCgpIG9wZXJhdGlv
biBjYWxsYmFjaywgYW5kIHRyeSB0byBzZXQgaXQgaWYgdGhlIGJhY2tlbmQgZG9lcyBub3Qgb2Zm
ZXIgdGhhdCBjYWxsYmFjayBpcyBhbiBlcnJvci4NCg0KU2lnbmVkLW9mZi1ieTogRXVnZW5pbyBQ
w6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQotLS0NCiBkcml2ZXJzL3Zob3N0L3ZkcGEuYyAg
ICAgICAgICAgICB8IDE2ICsrKysrKysrKysrKysrKy0NCiBpbmNsdWRlL3VhcGkvbGludXgvdmhv
c3RfdHlwZXMuaCB8ICAyICsrDQogMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYyBiL2RyaXZl
cnMvdmhvc3QvdmRwYS5jIGluZGV4IDFmMWQxYzQyNTU3My4uMzI3MTNkYjU4MzFkIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy92aG9zdC92ZHBhLmMNCisrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQpA
QCAtMzQ3LDYgKzM0NywxNCBAQCBzdGF0aWMgbG9uZyB2aG9zdF92ZHBhX3NldF9jb25maWcoc3Ry
dWN0IHZob3N0X3ZkcGEgKnYsDQogICAgICAgIHJldHVybiAwOw0KIH0NCg0KK3N0YXRpYyBib29s
IHZob3N0X3ZkcGFfY2FuX3N0b3AoY29uc3Qgc3RydWN0IHZob3N0X3ZkcGEgKnYpIHsNCisgICAg
ICAgc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhID0gdi0+dmRwYTsNCisgICAgICAgY29uc3Qgc3Ry
dWN0IHZkcGFfY29uZmlnX29wcyAqb3BzID0gdmRwYS0+Y29uZmlnOw0KKw0KKyAgICAgICByZXR1
cm4gb3BzLT5zdG9wOw0KW0dEPj5dIFdvdWxkIGl0IGJlIGJldHRlciB0byBleHBsaWNpdGx5IHJl
dHVybiBhIGJvb2wgdG8gbWF0Y2ggdGhlIHJldHVybiB0eXBlPw0KK30NCisNCiBzdGF0aWMgbG9u
ZyB2aG9zdF92ZHBhX2dldF9mZWF0dXJlcyhzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwgdTY0IF9fdXNl
ciAqZmVhdHVyZXApICB7DQogICAgICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZk
cGE7IEBAIC01NzUsNyArNTgzLDExIEBAIHN0YXRpYyBsb25nIHZob3N0X3ZkcGFfdW5sb2NrZWRf
aW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLA0KICAgICAgICBpZiAoY21kID09IFZIT1NUX1NFVF9C
QUNLRU5EX0ZFQVRVUkVTKSB7DQogICAgICAgICAgICAgICAgaWYgKGNvcHlfZnJvbV91c2VyKCZm
ZWF0dXJlcywgZmVhdHVyZXAsIHNpemVvZihmZWF0dXJlcykpKQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FRkFVTFQ7DQotICAgICAgICAgICAgICAgaWYgKGZlYXR1cmVzICYgflZI
T1NUX1ZEUEFfQkFDS0VORF9GRUFUVVJFUykNCisgICAgICAgICAgICAgICBpZiAoZmVhdHVyZXMg
JiB+KFZIT1NUX1ZEUEFfQkFDS0VORF9GRUFUVVJFUyB8DQorICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBCSVRfVUxMKFZIT1NUX0JBQ0tFTkRfRl9TVE9QKSkpDQorICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQorICAgICAgICAgICAgICAgaWYgKChmZWF0
dXJlcyAmIEJJVF9VTEwoVkhPU1RfQkFDS0VORF9GX1NUT1ApKSAmJg0KKyAgICAgICAgICAgICAg
ICAgICAgIXZob3N0X3ZkcGFfY2FuX3N0b3AodikpDQogICAgICAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gLUVPUE5PVFNVUFA7DQogICAgICAgICAgICAgICAgdmhvc3Rfc2V0X2JhY2tlbmRfZmVh
dHVyZXMoJnYtPnZkZXYsIGZlYXR1cmVzKTsNCiAgICAgICAgICAgICAgICByZXR1cm4gMDsNCkBA
IC02MjQsNiArNjM2LDggQEAgc3RhdGljIGxvbmcgdmhvc3RfdmRwYV91bmxvY2tlZF9pb2N0bChz
dHJ1Y3QgZmlsZSAqZmlsZXAsDQogICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgIGNhc2Ug
VkhPU1RfR0VUX0JBQ0tFTkRfRkVBVFVSRVM6DQogICAgICAgICAgICAgICAgZmVhdHVyZXMgPSBW
SE9TVF9WRFBBX0JBQ0tFTkRfRkVBVFVSRVM7DQorICAgICAgICAgICAgICAgaWYgKHZob3N0X3Zk
cGFfY2FuX3N0b3AodikpDQorICAgICAgICAgICAgICAgICAgICAgICBmZWF0dXJlcyB8PSBCSVRf
VUxMKFZIT1NUX0JBQ0tFTkRfRl9TVE9QKTsNCiAgICAgICAgICAgICAgICBpZiAoY29weV90b191
c2VyKGZlYXR1cmVwLCAmZmVhdHVyZXMsIHNpemVvZihmZWF0dXJlcykpKQ0KICAgICAgICAgICAg
ICAgICAgICAgICAgciA9IC1FRkFVTFQ7DQogICAgICAgICAgICAgICAgYnJlYWs7DQpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgvdmhvc3RfdHlwZXMuaA0KaW5kZXggNjM0Y2VlNDg1YWJiLi4yNzU4ZTY2NTc5MWIgMTAwNjQ0
DQotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdmhvc3RfdHlwZXMuaA0KKysrIGIvaW5jbHVkZS91
YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmgNCkBAIC0xNjEsNSArMTYxLDcgQEAgc3RydWN0IHZob3N0
X3ZkcGFfaW92YV9yYW5nZSB7DQogICogbWVzc2FnZQ0KICAqLw0KICNkZWZpbmUgVkhPU1RfQkFD
S0VORF9GX0lPVExCX0FTSUQgIDB4Mw0KKy8qIFN0b3AgZGV2aWNlIGZyb20gcHJvY2Vzc2luZyB2
aXJ0cXVldWUgYnVmZmVycyAqLyAjZGVmaW5lDQorVkhPU1RfQkFDS0VORF9GX1NUT1AgIDB4NA0K
DQogI2VuZGlmDQotLQ0KMi4yNy4wDQoNCg==
