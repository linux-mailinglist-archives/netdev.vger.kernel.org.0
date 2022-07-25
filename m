Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB11657FFC5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiGYN03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbiGYN02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:26:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA0F5FDF;
        Mon, 25 Jul 2022 06:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amF5Bxv/374vKa60RF+18ts3cup0typnRyT8k+8LP/fBJACSY912D8VQ6qJJCSTW3lEkHsO+moeufjRpguRdea3Ya3M/a1WjaYN2qGXngLHsGCSzpCENgy9qy/84onJ5uEMNqjj1k/AntRJTeNTaAAAwMPaYyt1oYPLuV8lIUArzlpvN5tV+AW3WgNP3CD9up2CNqK4jn6Xr9B1nTfcMCLhyYcL55vjowFIF20npx9/4AavT3OzjWS1GWKsFioSp09ROq4+oLRnMDpdnqEFL5NqhGH+cTxQNPFHAOXFv9FmPingFvj9FxgrVQSX8KNaq1BFu/BlNmLNxxILgQ9OOJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32HgQww5tqIWurZgJuUG0QTgLsz/Smkjdw/icqMB/wQ=;
 b=MXSh+5WoHbX/FXk30ji9epxp42BX7qlY9moWqqICCV/GtzQ6ykSmGfFHgowJLf32Fn17ud6dgS2X0dyTGHYhMVMbbF8O4BhJkD40jzy86I8TdLyYBAFclji5tkagW3/Rk0g2QrmMcDeDq27m2SPQtqsloI5nYfEJNklbkBMSqalHXH1+SlxLoP9H7DwFQ54V5iK+HR7/IH8g2+61zwqhFuD1O6m1wCVzMEltTBP6Ig01CBJ/LqoFgyB25sMSfVmKvIRgUaKOpm2IBV5IvDDIz2nZcqpiFC97STv+U69FXggPfXx3b84PnwCaORnnTDr+jLPk2IM4OSHgKgKp40ABQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32HgQww5tqIWurZgJuUG0QTgLsz/Smkjdw/icqMB/wQ=;
 b=0UO7aY9Et/niUTcyeHcEqhw/nZ5aIsGn7iwmM7mdJGjWWksUCyb2H5K9mKd5ByP9k/pkxkhvh6JHQuHJptCpsClFVnQd+c5y5WLeEXA9H1fxN1e1B/xxemy9SN48PimXpXKF7JPAyuCgSRwH/aN3MubgILyyNtVnIh8aGux90sc=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 13:26:25 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5438.014; Mon, 25 Jul 2022
 13:26:25 +0000
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
Subject: RE: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYnaLjy2AcewErSEyspw5q+NWPga2KFWIAgAUDKVA=
Date:   Mon, 25 Jul 2022 13:26:25 +0000
Message-ID: <MN0PR12MB5953AB4EA6E24052A5D95C65B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <55172e57-cd4b-b9cf-e169-0bd543211bcb@microchip.com>
In-Reply-To: <55172e57-cd4b-b9cf-e169-0bd543211bcb@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87e64c07-3f21-4c99-73d1-08da6e414613
x-ms-traffictypediagnostic: DM4PR12MB5722:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HTGp6O7A/N83AFZUl4CBBjGwd47QKk8NmRO+mEmqKnvgaPgiUdhtGWsrw4eUuxkAeqnv/tNw3HAgAqDLN2P3UL1uJzLmgAR9BBkMtoPa4sHObWC8eoSH7tnD8c3Q1RJaHWOJj52fvUdwZBU8tFvVsfXC8piJgL0i+2Ujp/anCmJrINDToHBQg8DSz6LdmKNtZDMnItXl1dPS22VA58Sad0sFFW4Sb1R/Y54nNWgu5UtKr+lMPBUVG31lp7d1FFw+F0MxHZYgq50axOUkuMlMmtQqRCt96UPSxFc1znsh+Vt6n8lKvQmBzaShe1z5iY6xep7MiEepca3KgWb4q/bvfJUhjbDe9GqnvMFinqaL6KvdIEj9G6a0H88sh2fxHp390iAcJR01NliXvrJpCMz6t/x0JUdX2PWXA+XcyJRDU/Tj72LhVMC+5ZFdGdgmtbWFJD8tBmHQWpanqesJPZjm7y/l6FUIJg/gggdcam6vM8c/MmDB+Ji+IGdgwwLQTIp7J5hL6WxfcPYINMoS5d1gXLStIipnp/V0MQKjbORqHXz141gIOzIDMyMWEkuTMrc9FWMtm4yAHWf6LEMEJtsNNRX+1Pj5Omvo2mJR4W5jS+rjEYbD38jQcSTO8+TTSpAUbX5v8ye+CsX6AONwrWKLYjBWYM3CUQqmnDFUIO7p5ar5VF8e29vt9yCaQqKp2BbMuXlWhoov3Wj7kKwcCdEn3QtzLFBYHBdqcSHNpBBKiVX6tosAa/T4OKptoydn4kVeNzzBJkpggpzQOrNH1LYitF7vmpQ74ClTGv2UzMU7gTBBJXkZme1cUzWmhcWpYupu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(110136005)(54906003)(316002)(41300700001)(71200400001)(478600001)(2906002)(55016003)(53546011)(76116006)(4326008)(66946007)(5660300002)(64756008)(66446008)(8676002)(66556008)(66476007)(7416002)(8936002)(86362001)(52536014)(83380400001)(33656002)(186003)(122000001)(38070700005)(38100700002)(9686003)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dStuMThXSkZYWi91aTVxQVpNWmpCVlluTXMvUXB2UjZQNzBXZ1RZRm9aUTUr?=
 =?utf-8?B?UWN1djF3WkltS0p6NjZWaitESnozTlpYNGI1NXhDN1RmZHUrYjBsUnI5SmJR?=
 =?utf-8?B?VDlZQ2oxbmtMaEJBT0RDbHcyRmRFdlJ2UnB0d1g0dnkvVENSblpWSTZJRVdj?=
 =?utf-8?B?WUdDM0g5UEFWNEQySWU3Vit1aXZ1M2RlbEkwdWtRNUdFcXJDZWF6dzJMQ0dy?=
 =?utf-8?B?UGVZRjZFRVVIWEpxSEVzeXRjTkVaMjRGNXNMQS9QS2tBbWVHaTAwOXpRckl0?=
 =?utf-8?B?S2NEbDlDWVNueHFvNG1UZGZOSDRHN1B0YnlXdXhlRFlzZ29pbDdPQjNqZTBr?=
 =?utf-8?B?WnpZNTZ6WkYzYmgxenJRVDRYNDZ2b0xySGIwVWx3cUpKMlFUQWJhYVpuNlRT?=
 =?utf-8?B?bml4SFRSZVpWY04wcU9BaXNzNy91Z2lTeHZlOWh0QnZ6SlVyODExa0kxR0wy?=
 =?utf-8?B?SCtuWWpicEs1Mk9MeWdpS3Q0Q09KaXQ5QVRQaEQweWZqTXRjUlRoWWJHYXhx?=
 =?utf-8?B?NmplQ2pWdC9Lb2FndEx3cHd1R1hwVW15VmtCcHVMUDdvdkNrZThJNC9ndVBR?=
 =?utf-8?B?YklaMTlQWEl2ajlUOWowZXd2Mlc1TXI3aFFSdmkvTmNPYXZvQVdJVGlPQ0J5?=
 =?utf-8?B?TGo3OGsxWVh6QjhtYmxaMXVtK0Zucy9IQVl0OXBFNE1CWC95TTZZTUdWV3lu?=
 =?utf-8?B?am9ZNDhRNU82RkVneFNldkI2SEJ1ZXh3bnFObW85WGp2TFUrMUN4Z3Mydk5r?=
 =?utf-8?B?ejVxSUE4TUMrWG5GZWd6Y2UvcUIvSHkzUWV1MXhwMlZyOVltK0VESnFYR1o5?=
 =?utf-8?B?QW9PZm1CTUExQVpkV3graDlwLzJ5dTA4QmlLcXZqeVU2WWd0dkNvNHBuMGhx?=
 =?utf-8?B?cnpXcjJRTmtQMSs5MnE5WDFQTmo0bk1qekJicTZtbTRKY2t6Wk1zdVh5RlUx?=
 =?utf-8?B?RHFvY0hNc0ZqTHZsZDlEUDNZRUdkbUk4Rk1qZlVtTDZQczU0a3RVMUlHZCtD?=
 =?utf-8?B?T1ZCcC9GbEVKUVlvWnVZbmp4UzlObmkwQm5hZ09Ebit3RU50ZkxlSTdNcXVV?=
 =?utf-8?B?QXBoSC8rK2x1bE5xOGtCRjN6ZjNDVFhjaWRGMTdEMzVKNUdaanRZbTNwMXB6?=
 =?utf-8?B?SG5TWVJQcmc4MmszS2haYWlMekxKYnNVZVFRcnhwVlJWcGk2OFNVUTh2bEJ0?=
 =?utf-8?B?Uk9aWlBSbmZUc203VkI2RnFjNlRhdlFZSjg3TEkza0JzcktUZ3pOS3dVYjZy?=
 =?utf-8?B?U1RqbzBUVlQzVENlOW1ZN0JRWStudUVDdFAydGZ4NldyVForSDRUb21qWlFE?=
 =?utf-8?B?WUNnRHgyZGEzU1prMjBwT1NuMkpWQzhKRGFwYXBOdVcvRnhaSEJGUW5PK1JM?=
 =?utf-8?B?OXoyV05mNDNGcXN3NVZjd2ZvTDdxL2lCczEraVJpWW1velp1aEhmWnpCaFhK?=
 =?utf-8?B?VXJ4cDRhZmNrSjN3aHpNZnh4MG42bjgvM0g0L1NCeWNqSzJqRnpwZFI4QmN3?=
 =?utf-8?B?eml6N3BZTW9yRWhQOXp2NlZBTXhXTS9wajN3angwR3JTTUd6MnZMTUw5VUwz?=
 =?utf-8?B?T2k3QVhFVjJYTFd5ZGZaK1RNNkVUVmFXVzVRZkFtQ3B0RTNoLy9DVFBQcDVi?=
 =?utf-8?B?WXhXZ3VGU09nb2wzd1F6dGowRG1yc2pRdFFlYmtOSUJaWXhieTRtZHRZZXI4?=
 =?utf-8?B?Y2xiTENDMTNPYld1ejlENnNJVm1PMmJRa2ZzMHU1am1Kb29YcHZ5UnZJS1Vh?=
 =?utf-8?B?TzFmeHVZZDRwT0NzTXNmUWJqZE9USEpmd3Z5ZEcxRzBCK05IUVoyVnZjZzdU?=
 =?utf-8?B?a2trMXgycWZHZ2FhdjEzZzB3d3VkdC9ISnhRNWhRMGVyUDQ4bHdGQU4xcm5F?=
 =?utf-8?B?Qk9uUVEwYzdWWFE4enA5TFhNVjA0a2llMEs2L3I3YWU4WTVLeGhVL3RNRDhQ?=
 =?utf-8?B?WjdmWFNxYU10cEs5RzJacXA1d0ZzQnBZcFZDSDlUR05QelB4NC9UdVdNL0ZR?=
 =?utf-8?B?VThHT2ZrOU90QjRZdHFJajJOSmsvbVlmVFFxUzVtVDVUZnBUeS9DeFlVVEtI?=
 =?utf-8?B?SjFWRzQvVXkrRlp2YzBiektXM2FZZFdGbThlbkZMN2MxbTNSSGV4T2UxZEw5?=
 =?utf-8?B?bWJEYTByZDRmU2hNcEJRVHRQbGdoNDd2ZGNrakZ2eCtXQUJPbGRhMVU0NFZZ?=
 =?utf-8?Q?q8izYA8vgQgc9XAltThwKQc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e64c07-3f21-4c99-73d1-08da6e414613
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 13:26:25.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iPC9W5yi0c8+BGVIku/5MWu5JgM8ltTksa0gVLAGBIrbCZ42HzfWzZQntb3huU/I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722
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
LVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDIv
Ml0gbmV0OiBtYWNiOiBBZGQgenlucW1wIFNHTUlJIGR5bmFtaWMNCj4gY29uZmlndXJhdGlvbiBz
dXBwb3J0DQo+IA0KPiBPbiAyMi4wNy4yMDIyIDExOjEyLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGtub3cNCj4gPiB0aGUgY29udGVudCBpcyBzYWZlDQo+ID4NCj4g
PiBBZGQgc3VwcG9ydCBmb3IgdGhlIGR5bmFtaWMgY29uZmlndXJhdGlvbiB3aGljaCB0YWtlcyBj
YXJlIG9mDQo+ID4gY29uZmlndXJpbmcgdGhlIEdFTSBzZWN1cmUgc3BhY2UgY29uZmlndXJhdGlv
biByZWdpc3RlcnMgdXNpbmcgRUVNSQ0KPiA+IEFQSXMuIEhpZ2ggbGV2ZWwgc2VxdWVuY2UgaXMg
dG86DQo+ID4gLSBDaGVjayBmb3IgdGhlIFBNIGR5bmFtaWMgY29uZmlndXJhdGlvbiBzdXBwb3J0
LCBpZiBubyBlcnJvciBwcm9jZWVkIHdpdGgNCj4gPiAgIEdFTSBkeW5hbWljIGNvbmZpZ3VyYXRp
b25zKG5leHQgc3RlcHMpIG90aGVyd2lzZSBza2lwIHRoZSBkeW5hbWljDQo+ID4gICBjb25maWd1
cmF0aW9uLg0KPiA+IC0gQ29uZmlndXJlIEdFTSBGaXhlZCBjb25maWd1cmF0aW9ucy4NCj4gPiAt
IENvbmZpZ3VyZSBHRU1fQ0xLX0NUUkwgKGdlbVhfc2dtaWlfbW9kZSkuDQo+ID4gLSBUcmlnZ2Vy
IEdFTSByZXNldC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkg
PHJhZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDIwICsrKysrKysrKysrKysrKysrKysrDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+IGluZGV4IDdlYjc4MjJjZDE4
NC4uOTdmNzdmYTllMTY1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jDQo+ID4gQEAgLTM4LDYgKzM4LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4
L3BtX3J1bnRpbWUuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3B0cF9jbGFzc2lmeS5oPg0KPiA+
ICAjaW5jbHVkZSA8bGludXgvcmVzZXQuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2Zpcm13YXJl
L3hsbngtenlucW1wLmg+DQo+ID4gICNpbmNsdWRlICJtYWNiLmgiDQo+ID4NCj4gPiAgLyogVGhp
cyBzdHJ1Y3R1cmUgaXMgb25seSB1c2VkIGZvciBNQUNCIG9uIFNpRml2ZSBGVTU0MCBkZXZpY2Vz
ICovIEBADQo+ID4gLTQ2MjEsNiArNDYyMiwyNSBAQCBzdGF0aWMgaW50IGluaXRfcmVzZXRfb3B0
aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiZmFpbGVkIHRvIGluaXQgU0dNSUkgUEhZ
XG4iKTsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICsgICAgICAgcmV0ID0genlucW1wX3BtX2lz
X2Z1bmN0aW9uX3N1cHBvcnRlZChQTV9JT0NUTCwNCj4gSU9DVExfU0VUX0dFTV9DT05GSUcpOw0K
PiA+ICsgICAgICAgaWYgKCFyZXQpIHsNCj4gPiArICAgICAgICAgICAgICAgdTMyIHBtX2luZm9b
Ml07DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICByZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3Uz
Ml9hcnJheShwZGV2LT5kZXYub2Zfbm9kZSwgInBvd2VyLQ0KPiBkb21haW5zIiwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcG1faW5mbywgQVJS
QVlfU0laRShwbV9pbmZvKSk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXQgPCAwKSB7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2LCAiRmFpbGVkIHRv
IHJlYWQgcG93ZXINCj4gPiArIG1hbmFnZW1lbnQgaW5mb3JtYXRpb25cbiIpOw0KPiANCj4gWW91
IGhhdmUgdG8gdW5kbyBwaHlfaW5pdCgpIGFib3ZlIChub3QgbGlzdGVkIGluIHRoaXMgZGlmZiku
DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4gIEkgc2VlICwgd2lsbCBhZGQgcGh5X2V4aXQoKSBp
biB0aGlzIHJldHVybiBwYXRoDQphbmQgZm9yIGJlbG93IGVycm9yIHBhdGggYXMgd2VsbC4NCj4g
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArICAgICAgICAg
ICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICByZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25m
aWcocG1faW5mb1sxXSwNCj4gR0VNX0NPTkZJR19GSVhFRCwgMCk7DQo+ID4gKyAgICAgICAgICAg
ICAgIGlmIChyZXQgPCAwKQ0KPiANCj4gU2FtZSBoZXJlLg0KPiANCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgcmV0ID0g
enlucW1wX3BtX3NldF9nZW1fY29uZmlnKHBtX2luZm9bMV0sDQo+IEdFTV9DT05GSUdfU0dNSUlf
TU9ERSwgMSk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXQgPCAwKQ0KPiANCj4gQW5kIGhl
cmUuDQo+IA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAg
ICAgICB9DQo+ID4gKz4gICAgICAgICAvKiBGdWxseSByZXNldCBjb250cm9sbGVyIGF0IGhhcmR3
YXJlIGxldmVsIGlmIG1hcHBlZCBpbg0KPiA+ICs+IGRldmljZQ0KPiB0cmVlICovDQo+ID4gICAg
ICAgICByZXQgPSBkZXZpY2VfcmVzZXRfb3B0aW9uYWwoJnBkZXYtPmRldik7DQo+ID4gICAgICAg
ICBpZiAocmV0KSB7DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KDQo=
