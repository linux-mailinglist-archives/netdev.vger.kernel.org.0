Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3414857FF6A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiGYNA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbiGYNA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:00:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C05FFA;
        Mon, 25 Jul 2022 06:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lE/zUFSZkCcsKWvQV6GvVA14vISH9YAH7rF5osj+QA4w5+GsLKoWTKi/W2jgK3LZ57tDyAkMKOGiv8P0dglz3kkXmwuauVUgTeGpjSWgGwLdJGo8uOAsCxAAz+yW7Ov1n6nY5s4JXM5zfFcAnHzxQnvYblNPc1zsmbCSyJSdmk7p4W3MHesc21BCzpubpmDFIa2m8RigSHA9oDcsrBv58Q3ut94yoVvUNmTj/BgescFyea66ZlaG2eMhsz2iZZb4sJVh2151vaohCx661hxhksjaxPlDJw5lJY9ITTAOauZ3HnZLO/m6h56TTiYdd7P9aWk/4MBoizkZS/YmUi5Mzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjXDG/IzufNZnxP3XkS4oyIUaPN3I9VLwnBtpgxz7aM=;
 b=LFGgv8kD62BPkW82VJ3nXy+gszdI59KFf2omPk++FlctRiPSIdDXcXC6WulG1jE1AeNJ0iGDu//aNPXRDnpx/dYa5e3TKpwOT7uFtXe1HSjJGlYxkYp69QEqiojgezRd8aoJnJ2yjkhkus7MO+0UlXtGjksE1vXzOzVcBJW/MmGufUuOccTG8Clf4XCMiqhxk6eqWm4TfENDHAvJvfJohONoxS/x9JGU0jFy1dpi8nfpvLFZ7vn0YGmFLVttbBKeuoNQvOG8RifwvJOhE7jd9VrTMJ2BTdQzLBl9n/tzsG1J/necp6AHKemH9MkmWkucrCWvdpce2kf1dFmbvRwwgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjXDG/IzufNZnxP3XkS4oyIUaPN3I9VLwnBtpgxz7aM=;
 b=FVlXXYjz2DpJc92D9h83f0eYHN1y7Q2XDvNjFWrw/eIgh/XNYhXg4xPGq44bIhXC9LOl0Aa7XZOQclirk6Hwq/Wd4gSZvT6brlL5vzkpibD6QIuP6zU2JE9aS+piAXw1Kvj/jWdSBVIIKmZy1OMajxlqgY9QROlhW34S29LRVRk=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DM6PR12MB3979.namprd12.prod.outlook.com (2603:10b6:5:1cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 13:00:52 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5438.014; Mon, 25 Jul 2022
 13:00:52 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYnaLZ+Kp+ugEdK0W0v+CQfoCUna2KFW2AgAT5wPA=
Date:   Mon, 25 Jul 2022 13:00:52 +0000
Message-ID: <MN0PR12MB5953B9185942E6B488FC5C89B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-2-git-send-email-radhey.shyam.pandey@amd.com>
 <0fb28327-46c2-7e5e-dc6e-6d98c8e4b6cd@microchip.com>
In-Reply-To: <0fb28327-46c2-7e5e-dc6e-6d98c8e4b6cd@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a87f2373-a663-4197-de4c-08da6e3db456
x-ms-traffictypediagnostic: DM6PR12MB3979:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pDHG0PQKaFqSDpmE3PEga3BSpKaaY6jEwalqGhOZlmL/r7V2dIJCIiUIhBtcTArq1F29SGjJr/a1EgPziwQNij/ZF8jKTjhui03hSif2hNQYEOaq2ey8b9xD4WxFFdJZTJMPyEvLPBolrToq1l2hCe88Je+nSWrmrEkk6jpuoLXCdZWuKDM4lWWVj73eFQe/R1Y3Xqyo7bzJ0n1fMooAGvVCx4XCYeR7B4uu9YqDJPNyKpe43xdDBdqcWBU0HL7DXa6L1jxTNqS9XG9qpvM9V5N+aZcaF+KdpO7jxl/gKqJgvBIgmSG9LbAN2GO9HfHf30FiRcZbDPHaKdffyki0o1XZhobAGJe26SrIezY6X3bd12OJU4706pYYpMx5MD/9v3zbMIf8d/mDy1eZtRE0pVtb5z9Xf0r+Z2hK4AgsJmTLceqSt8v9CD5zURQ3FjzFPkP95KGnt54Gi4UntxLFqGF2rjaxPxYwbNPEgCGofhlvpP2bj3zSYcv1DIaKMLqL9We2Q4jXt5DrXtNiRx3k4+E6B8jy3VJKcP1YYLW46CK7Ci3PvGlmjAqFh3OSDW7mE3vgQRU/QDbgPsdLnEADdDOGiQOYUcAq9wW3eWzcEnlr1KHmmVsJHz7ni5/j20DfuxqM36JgJAE9KJO9C/sKJSDAcEitDwet8UIONV9f5obpridPPJB6e6aw1KKHi2EMpCMWvu/OgSZC7cDa8qeU+26yQILJFpIo/P+E2fbPy7sIQAuXDvFb9j+045uKnVz+MJeBgzN+T4FbVU+yzhC8YIq/oh77wcCwL7EIuL2D15CY7XAodrnKYdTvTXg3H7P/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(41300700001)(9686003)(33656002)(66946007)(55016003)(7696005)(478600001)(2906002)(86362001)(6506007)(4326008)(76116006)(8676002)(110136005)(54906003)(71200400001)(316002)(38100700002)(122000001)(38070700005)(7416002)(53546011)(66446008)(64756008)(66556008)(66476007)(5660300002)(52536014)(8936002)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXFMOGFHZzJVV0hDanlPdUV4WENQZXBMMklwQXNRNFBRaFFjd01XKzJDNUhV?=
 =?utf-8?B?TDdRTnpNR0dUYlE3d1hwUUZwQ0pOZks3bnlpeDF4Ry9qRmhDTXUyNjBJVytt?=
 =?utf-8?B?KzVIUTBUbmJIRzdGZVo2aUJiK3NXNmlRQ1JKSzZUNDJPWTJkZ2hUdk90VUNs?=
 =?utf-8?B?MnI0WGhvWUx2T0o2eldud2F5UVpYc1M0RTFESzhsUDRyWDNmYUlHVFYzSWk5?=
 =?utf-8?B?UTFpcVJ2MS9CSFQzQURXRTkyb3ltYTlra1FUbHJ2SGU1ZHk4WmsvbUFYRExQ?=
 =?utf-8?B?Rytqc0VEV3pCeGhqV2xteStrb1NnWkpaQzdwU0lYU293UDJrWS9tY3UwR1l5?=
 =?utf-8?B?eVBpUjNzUjlBQ3FzSmM4MUVsZ2pvMEkzMVU1TzZuUHA5ZEhadFVSTlp4cHdt?=
 =?utf-8?B?YmV0YncyamZ6RTBjQTVJUkVzZ2F6amVHQmJGTFZYVm8wTXVrQUx3dlp1R21S?=
 =?utf-8?B?TU53SWhMK3BYc2x0NGpERWREVWhYVlJJdTlOTlNpMDRxcHl5UFFUM0VQWWt4?=
 =?utf-8?B?MGxFYVpGQXo5R3J3TkpOYy9TYXBqbXBQTU9wbEZnS2lwK05GUE1DUlVUb0xs?=
 =?utf-8?B?R1ZEbGdlZWNUWjdLa3NYQm9EZHlWb3VPTGErNVJJSktGbzBDdE4zQzRFOU5N?=
 =?utf-8?B?aEpuaTFsVDVyQzRDZktleEdGTmlNOFRkTEhQejdBTUNiVU1hZExka2w3cmtR?=
 =?utf-8?B?OEJRM0ZtZkNaLzhaS0kwRkt4Vlp6T2R2V2dtcEMwY3RGV2lwWVkxVXJHNzVW?=
 =?utf-8?B?WXd5NWZSeDdyaUlnTjFVRGFmMmpwOS9heFVWTUxCZkJyV0R4b1Vyakhtd2th?=
 =?utf-8?B?WlhXTnBjdGpVaVNCVWxoM3U0RlcvdWdzbEl2UUVnK3NOcU9LUitnMU10Tkcv?=
 =?utf-8?B?T201ZU9QL2E0WURSaWlLakNyWVVuR2JwVmVMby9XTFB5YjloYnFKNkpJMVJH?=
 =?utf-8?B?ellJSzgyakxoNGtOV0xMcW80L0dVdXlsalRZeTlYSFUzSDArVWV3QzB3VVBI?=
 =?utf-8?B?Yloxb3FVUkgyTURyc2l4R3dpZDFVcldqTkNTTitKWG9JZ1J5VnNjRzZsN1g4?=
 =?utf-8?B?cENkcStzNkdhYmpZalEwMnpaUkxScHUxNmY5NnpyV1c1eXVaQzNWVTdCK0lo?=
 =?utf-8?B?K0RteEtteFBFUXRGSlhrWEIzSXhDOHY5Y1lHMDJmVkNxaUg5U0p2Z1lyekx4?=
 =?utf-8?B?V0UxYmdTZEg2YnFZd05JcjV0RWx2cElpZVRzMGxHUW9XZzNBNFcyZWw2eXVP?=
 =?utf-8?B?WVZ0SmtpU2FYNE9tSGQ4b2RxbFE2MWJPQ1JyZ1FxY1EwR2VWTllRTHBZdUJv?=
 =?utf-8?B?VjJsVUpoVzZBUjhDZ3Y2eVJhRkpQdU93UDR0NmNFNDYwcDZ2RHB2TkV0QVJ1?=
 =?utf-8?B?bDhIU0xWaVViOWlnQitEVHQ5WThLWFg5OXd2MDR0UUo5cXo4TFNKSjAxVnBx?=
 =?utf-8?B?NWJBK1Q4ajlPeVoxKzBlVk9OR1VkYlRONURBZEh4aG5CTlRBVnZVUkNQQnNV?=
 =?utf-8?B?Rk9CWjR6Q3dmcjZyVitjaS9UL1hzL25POVRLcVRwdy9DcDV4T25yU1FsNDY3?=
 =?utf-8?B?TFExMTI4ZUd5MEdpa1BCTGVnV1hsMjNjMHFMSUVwcjNldXM2aVVTWFcxK1d1?=
 =?utf-8?B?RjIrb3lGd040SHBYSS9neVJqd0JzRkEwVUk3blZ2TmgwRURVYlJhNFNsSC8w?=
 =?utf-8?B?R3dXcjN0RVBjY2lrb2VZS2JjeDJmZG1Bd2duanB2RjFtZnZCdEZDaGs3VEpj?=
 =?utf-8?B?QjdIN3ZWN2IxTEhwQnUvbkdDM0lQN2dJVmpRVXpBaHVMejg1Z3dYZDlVams0?=
 =?utf-8?B?SG12ZGgxeHZVMVB0NlpOUmErSVlkdGZIMmpHNWdHbFFjUXBTWFk1S240OVZ6?=
 =?utf-8?B?QjhHNnYwZGF5WkRrUTdydDRoN0FzaVhRbjFwODZuZDh1azg4eSsyaFFnalRF?=
 =?utf-8?B?Q29IWENVNFBvUG9XZDhWdGkyS05uYWdYRjREV2Z1aCtUYTZCTGpWd2toUW8v?=
 =?utf-8?B?SWFoSklScEcxNWIyMm42a3MwcjJKdnVJRjZvbkl5WkVsL1plcmRmOWcvaW9X?=
 =?utf-8?B?TTQrTzk1bDZWcjFhNVA2WjlRTVlzaTlOdTVLK21KVEZnWXgyOHpiNDgxcGxv?=
 =?utf-8?B?bWxpQjNSdy9hZEFIZjhsRGhOR3ZyQ1NGTXBMNXJZeVo0aDFuQ0FxcnBaMVBC?=
 =?utf-8?Q?JKDAutm0ltZFRdvQM46brg4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87f2373-a663-4197-de4c-08da6e3db456
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 13:00:52.3686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rsd0cExsg0sULWZxXe5QbsO77lQv35uRldh2sZgMCmaf0AIbYXI9yT82p70/bRCr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3979
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDbGF1ZGl1LkJlem5lYUBtaWNy
b2NoaXAuY29tIDxDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBGcmlkYXks
IEp1bHkgMjIsIDIwMjIgMjoyMiBQTQ0KPiBUbzogUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhl
eS5zaHlhbS5wYW5kZXlAYW1kLmNvbT47DQo+IG1pY2hhbC5zaW1la0B4aWxpbnguY29tOyBOaWNv
bGFzLkZlcnJlQG1pY3JvY2hpcC5jb207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0
QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IGdyZWdr
aEBsaW51eGZvdW5kYXRpb24ub3JnOyByb25hay5qYWluQHhpbGlueC5jb20NCj4gQ2M6IGxpbnV4
LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZ2l0QHhpbGlueC5jb207IGdpdCAoQU1E
LVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEv
Ml0gZmlybXdhcmU6IHhpbGlueDogYWRkIHN1cHBvcnQgZm9yIHNkL2dlbQ0KPiBjb25maWcNCj4g
DQo+IE9uIDIyLjA3LjIwMjIgMTE6MTEsIFJhZGhleSBTaHlhbSBQYW5kZXkgd3JvdGU6DQo+ID4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdw0KPiA+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gPg0KPiA+IEZyb206IFJv
bmFrIEphaW4gPHJvbmFrLmphaW5AeGlsaW54LmNvbT4NCj4gPg0KPiA+IEFkZCBuZXcgQVBJcyBp
biBmaXJtd2FyZSB0byBjb25maWd1cmUgU0QvR0VNIHJlZ2lzdGVycy4gSW50ZXJuYWxseSBpdA0K
PiA+IGNhbGxzIFBNIElPQ1RMIGZvciBiZWxvdyBTRC9HRU0gcmVnaXN0ZXIgY29uZmlndXJhdGlv
bjoNCj4gPiAtIFNEL0VNTUMgc2VsZWN0DQo+ID4gLSBTRCBzbG90IHR5cGUNCj4gPiAtIFNEIGJh
c2UgY2xvY2sNCj4gPiAtIFNEIDggYml0IHN1cHBvcnQNCj4gPiAtIFNEIGZpeGVkIGNvbmZpZw0K
PiA+IC0gR0VNIFNHTUlJIE1vZGUNCj4gPiAtIEdFTSBmaXhlZCBjb25maWcNCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFJvbmFrIEphaW4gPHJvbmFrLmphaW5AeGlsaW54LmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jICAgICB8
IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGluY2x1ZGUvbGludXgvZmlybXdh
cmUveGxueC16eW5xbXAuaCB8IDMzDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPiA+IGIvZHJpdmVycy9maXJt
d2FyZS94aWxpbngvenlucW1wLmMNCj4gPiBpbmRleCA3OTc3YTQ5NGE2NTEuLjMyYTM1YmFmYjY1
ZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPiA+
ICsrKyBiL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+ID4gQEAgLTEyOTcsNiAr
MTI5NywzNyBAQCBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJlX2NvbmZpZyhlbnVtDQo+IHBtX2Zl
YXR1cmVfY29uZmlnX2lkIGlkLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaWQsIDAsIHBheWxvYWQpOyAgfQ0KPiA+DQo+ID4gKy8qKg0KPiA+ICsgKiB6eW5xbXBfcG1f
c2V0X3NkX2NvbmZpZyAtIFBNIGNhbGwgdG8gc2V0IHZhbHVlIG9mIFNEIGNvbmZpZyByZWdpc3Rl
cnMNCj4gPiArICogQG5vZGU6ICAgICAgU0Qgbm9kZSBJRA0KPiA+ICsgKiBAY29uZmlnOiAgICBU
aGUgY29uZmlnIHR5cGUgb2YgU0QgcmVnaXN0ZXJzDQo+ID4gKyAqIEB2YWx1ZTogICAgIFZhbHVl
IHRvIGJlIHNldA0KPiA+ICsgKg0KPiA+ICsgKiBSZXR1cm46ICAgICAgUmV0dXJucyAwIG9uIHN1
Y2Nlc3Mgb3IgZXJyb3IgdmFsdWUgb24gZmFpbHVyZS4NCj4gDQo+IFlvdSBoYXZlIHNwYWNlcyBh
ZnRlciAiUmV0dXJuOiIsIGRvZXNuJ3QgbWF0Y2ggd2l0aCB0YWJzIHRoYXQgeW91IGhhdmUgYWZ0
ZXINCj4gdmFyaWFibGUgZG9jdW1lbnRhdGlvbi4NCg0KT2ssIHdpbGwgZml4IHRoZSByZXR1cm4g
aW5kZW50YXRpb24gdG8gdGFiIHRvIG1hdGNoIHdpdGggdmFyaWFibGUgZG9jdW1lbnRhdGlvbi4N
Cj4gDQo+ID4gKyAqLw0KPiA+ICtpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUs
IGVudW0gcG1fc2RfY29uZmlnX3R5cGUNCj4gY29uZmlnLA0KPiA+ICt1MzIgdmFsdWUpIHsNCj4g
PiArICAgICAgIHJldHVybiB6eW5xbXBfcG1faW52b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLA0KPiBJ
T0NUTF9TRVRfU0RfQ09ORklHLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgY29uZmlnLCB2YWx1ZSwgTlVMTCk7IH0NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwoenlucW1w
X3BtX3NldF9zZF9jb25maWcpOw0KPiA+ICsNCj4gPiArLyoqDQo+ID4gKyAqIHp5bnFtcF9wbV9z
ZXRfZ2VtX2NvbmZpZyAtIFBNIGNhbGwgdG8gc2V0IHZhbHVlIG9mIEdFTSBjb25maWcNCj4gcmVn
aXN0ZXJzDQo+ID4gKyAqIEBub2RlOiAgICAgIEdFTSBub2RlIElEDQo+ID4gKyAqIEBjb25maWc6
ICAgIFRoZSBjb25maWcgdHlwZSBvZiBHRU0gcmVnaXN0ZXJzDQo+ID4gKyAqIEB2YWx1ZTogICAg
IFZhbHVlIHRvIGJlIHNldA0KPiA+ICsgKg0KPiA+ICsgKiBSZXR1cm46ICAgICAgUmV0dXJucyAw
IG9uIHN1Y2Nlc3Mgb3IgZXJyb3IgdmFsdWUgb24gZmFpbHVyZS4NCj4gDQo+IFNhbWUgaGVyZS4N
Cg0KV2lsbCBmaXggaXQgaW4gdjIuDQo+IA0KPiA+ICsgKi8NCj4gPiAraW50IHp5bnFtcF9wbV9z
ZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwgZW51bSBwbV9nZW1fY29uZmlnX3R5cGUNCj4gY29uZmln
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKSB7DQo+ID4gKyAg
ICAgICByZXR1cm4genlucW1wX3BtX2ludm9rZV9mbihQTV9JT0NUTCwgbm9kZSwNCj4gSU9DVExf
U0VUX0dFTV9DT05GSUcsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBj
b25maWcsIHZhbHVlLCBOVUxMKTsgfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh6eW5xbXBfcG1f
c2V0X2dlbV9jb25maWcpOw0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAqIHN0cnVjdCB6eW5xbXBf
cG1fc2h1dGRvd25fc2NvcGUgLSBTdHJ1Y3QgZm9yIHNodXRkb3duIHNjb3BlDQo+ID4gICAqIEBz
dWJ0eXBlOiAgIFNodXRkb3duIHN1YnR5cGUNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9maXJtd2FyZS94bG54LXp5bnFtcC5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL3hs
bngtenlucW1wLmgNCj4gPiBpbmRleCAxZWM3M2Q1MzUyYzMuLjA2M2E5M2MxMzNmMSAxMDA2NDQN
Cj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmgNCj4gPiArKysg
Yi9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmgNCj4gPiBAQCAtMTUyLDYgKzE1
Miw5IEBAIGVudW0gcG1faW9jdGxfaWQgew0KPiA+ICAgICAgICAgLyogUnVudGltZSBmZWF0dXJl
IGNvbmZpZ3VyYXRpb24gKi8NCj4gPiAgICAgICAgIElPQ1RMX1NFVF9GRUFUVVJFX0NPTkZJRyA9
IDI2LA0KPiA+ICAgICAgICAgSU9DVExfR0VUX0ZFQVRVUkVfQ09ORklHID0gMjcsDQo+ID4gKyAg
ICAgICAvKiBEeW5hbWljIFNEL0dFTSBjb25maWd1cmF0aW9uICovDQo+ID4gKyAgICAgICBJT0NU
TF9TRVRfU0RfQ09ORklHID0gMzAsDQo+ID4gKyAgICAgICBJT0NUTF9TRVRfR0VNX0NPTkZJRyA9
IDMxLA0KPiA+ICB9Ow0KPiA+DQo+ID4gIGVudW0gcG1fcXVlcnlfaWQgew0KPiA+IEBAIC0zOTMs
NiArMzk2LDE4IEBAIGVudW0gcG1fZmVhdHVyZV9jb25maWdfaWQgew0KPiA+ICAgICAgICAgUE1f
RkVBVFVSRV9FWFRXRFRfVkFMVUUgPSA0LA0KPiA+ICB9Ow0KPiA+DQo+ID4gK2VudW0gcG1fc2Rf
Y29uZmlnX3R5cGUgew0KPiA+ICsgICAgICAgU0RfQ09ORklHX0VNTUNfU0VMID0gMSwgLyogVG8g
c2V0IFNEX0VNTUNfU0VMIGluIENUUkxfUkVHX1NEDQo+IGFuZCBTRF9TTE9UVFlQRSAqLw0KPiA+
ICsgICAgICAgU0RfQ09ORklHX0JBU0VDTEsgPSAyLCAvKiBUbyBzZXQgU0RfQkFTRUNMSyBpbiBT
RF9DT05GSUdfUkVHMQ0KPiAqLw0KPiA+ICsgICAgICAgU0RfQ09ORklHXzhCSVQgPSAzLCAvKiBU
byBzZXQgU0RfOEJJVCBpbiBTRF9DT05GSUdfUkVHMiAqLw0KPiA+ICsgICAgICAgU0RfQ09ORklH
X0ZJWEVEID0gNCwgLyogVG8gc2V0IGZpeGVkIGNvbmZpZyByZWdpc3RlcnMgKi8gfTsNCj4gPiAr
DQo+ID4gK2VudW0gcG1fZ2VtX2NvbmZpZ190eXBlIHsNCj4gPiArICAgICAgIEdFTV9DT05GSUdf
U0dNSUlfTU9ERSA9IDEsIC8qIFRvIHNldCBHRU1fU0dNSUlfTU9ERSBpbg0KPiBHRU1fQ0xLX0NU
UkwgcmVnaXN0ZXIgKi8NCj4gPiArICAgICAgIEdFTV9DT05GSUdfRklYRUQgPSAyLCAvKiBUbyBz
ZXQgZml4ZWQgY29uZmlnIHJlZ2lzdGVycyAqLyB9Ow0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAq
IHN0cnVjdCB6eW5xbXBfcG1fcXVlcnlfZGF0YSAtIFBNIHF1ZXJ5IGRhdGENCj4gPiAgICogQHFp
ZDogICAgICAgcXVlcnkgSUQNCj4gPiBAQCAtNDY4LDYgKzQ4Myw5IEBAIGludCB6eW5xbXBfcG1f
ZmVhdHVyZShjb25zdCB1MzIgYXBpX2lkKTsgIGludA0KPiA+IHp5bnFtcF9wbV9pc19mdW5jdGlv
bl9zdXBwb3J0ZWQoY29uc3QgdTMyIGFwaV9pZCwgY29uc3QgdTMyIGlkKTsgIGludA0KPiA+IHp5
bnFtcF9wbV9zZXRfZmVhdHVyZV9jb25maWcoZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCBpZCwg
dTMyDQo+IHZhbHVlKTsNCj4gPiBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJlX2NvbmZpZyhlbnVt
IHBtX2ZlYXR1cmVfY29uZmlnX2lkIGlkLCB1MzINCj4gPiAqcGF5bG9hZCk7DQo+ID4gK2ludCB6
eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyh1MzIgbm9kZSwgZW51bSBwbV9zZF9jb25maWdfdHlwZQ0K
PiBjb25maWcsDQo+ID4gK3UzMiB2YWx1ZSk7IGludCB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWco
dTMyIG5vZGUsIGVudW0NCj4gcG1fZ2VtX2NvbmZpZ190eXBlIGNvbmZpZywNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHUzMiB2YWx1ZSk7DQo+ID4gICNlbHNlDQo+ID4gIHN0YXRp
YyBpbmxpbmUgaW50IHp5bnFtcF9wbV9nZXRfYXBpX3ZlcnNpb24odTMyICp2ZXJzaW9uKSAgeyBA
QA0KPiA+IC03MzMsNiArNzUxLDIxIEBAIHN0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9nZXRf
ZmVhdHVyZV9jb25maWcoZW51bQ0KPiA+IHBtX2ZlYXR1cmVfY29uZmlnX2lkIGlkLCAgew0KPiA+
ICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gIH0NCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxp
bmUgaW50IHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnKHUzMiBub2RlLA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0gcG1fc2RfY29uZmlnX3R5cGUgY29u
ZmlnLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUzMiB2
YWx1ZSkgew0KPiA+ICsgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gK30NCj4gPiArDQo+ID4g
K3N0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBwbV9nZW1f
Y29uZmlnX3R5cGUgY29uZmlnLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB1MzIgdmFsdWUpIHsNCj4gPiArICAgICAgIHJldHVybiAtRU5PREVWOw0KPiA+
ICt9DQo+ID4gKw0KPiA+ICAjZW5kaWYNCj4gPg0KPiA+ICAjZW5kaWYgLyogX19GSVJNV0FSRV9a
WU5RTVBfSF9fICovDQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KDQo=
