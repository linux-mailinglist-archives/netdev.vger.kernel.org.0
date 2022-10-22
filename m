Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C2A6082EE
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJVAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJVAij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:38:39 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022014.outbound.protection.outlook.com [40.93.200.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4AF2B4EAD;
        Fri, 21 Oct 2022 17:38:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BadBo7+J/ne7od0YxMgkOCbGCIJrfHsQ/S5F7V1jgyQifu5dSDav6XgYNDaO2goY28H4piV0VC5fYkGGpxobCaecLAAl5XCHvYB6a6MDT5mkGO6CJVmf4XQD88Q8UMRlAeg0ky6lJ9nuhBaPNuWNqqg98PTDWBYD1v8s3jJNPh0U/vodrGMPWi/ktxfJfCH5Jw85KF0UkqbD0ffox+Q9HPjce3nMl6NmKOlsEBY2W9W4Fz4JUsxWxXeztKr+YC77IDG8GrrhfuoMdoYxDtlq0cbxJ1vIkimLcFrla29o15XNGvaN2M/jNyzo/76n6u4WDULFKroArMYOMOdjPC1clA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGCY2cep5WuPqOgMsLE5FePPPfvwAjz3rJ8KBDyaADY=;
 b=hryS5EojxNEg6/vuphhbwOT6YlaJ6Y/usvKINturW6mpKk5vvH4ephmTQtRK/GrlAgAn7EdIW+rM7sMG1yixTk8ZBccGHkpzIEFAxLrEbKjP57d4qzn6P8wOT6wqPKCvpqLNgImzXC0AAJPNW9Q6JWmzRW8uyA3mlTn8glLnVfcIT1p/VJeiR0N1XhWQJMK7S52Kj3MNLBbz03SfVCggMWhZsVJ7OTS4X91tKzhTkqjIDYLmaATno+qA/2zxMljC4/NXyc27h1U7PWY/S4rAcNG/0+8sSnJzCtFcNQYaWpUiHW+vLaYRwkxzhPT5KIzKGQZwKjSmtP4xGkxs5AGGXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGCY2cep5WuPqOgMsLE5FePPPfvwAjz3rJ8KBDyaADY=;
 b=eeFVQpqTBpnXlSi8HzUFyJtpep8vj6J9iDBvq5h5pCLQZbq4XRQfHlhcBn7M9UDrErw3EYG6X4UudzTJHwMst/ThYULoiqgxN0xI1vkjJSHOwrfx6WtePWaDXnbo2BzJ2LhWtzXwwK4Ka+1YZlro9M9QAHMca2FjoQPhf1CVVz4=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CH2PR21MB1494.namprd21.prod.outlook.com (2603:10b6:610:88::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Sat, 22 Oct
 2022 00:38:35 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Sat, 22 Oct 2022
 00:38:35 +0000
From:   Long Li <longli@microsoft.com>
To:     tom <tom@talpey.com>, Bernard Metzler <BMT@zurich.ibm.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5AmQQ427gtVraEOIJ5+rCERFPa4XHQ2AgACeAYCAATEdAIAAAKcAgACKjjCAABy+gIAAAHfA
Date:   Sat, 22 Oct 2022 00:38:35 +0000
Message-ID: <PH7PR21MB3263908FB7410B98F29490DECE2C9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
 <SA0PR15MB3919DE8DE2C407D8E8A07E1F992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263A40A380B9D7F00F02529CE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <b2de197c-0c5b-c815-23c8-3f90c2e226ed@talpey.com>
In-Reply-To: <b2de197c-0c5b-c815-23c8-3f90c2e226ed@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e24aea1b-78fd-4f48-b579-1bab022d25dd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-22T00:36:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|CH2PR21MB1494:EE_
x-ms-office365-filtering-correlation-id: 060d4a62-ffa2-458b-6b28-08dab3c5c12f
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eNa9+LqlapohMR+aBlgsUBpo6KIi7vuzqsXeROIWfQmskHj6tYT0buPEwlXYoxnnQvVBIDiMc9yj8G/LsY0vxWvI8SgnC1JNcu+Ielo65Lz5iGCjjykzNSA2oKFbxxfp5G6NIqer4jxXsjrVUFmjHrs8XtFDIUgBqLci+j9vPeSK5vTrn8HxT9qyxGSjqWhUqCP00Fs1wI+UE5Kx6mvJqY5aqMVdrGSuFlKMmParpjwMHhhvVtnfUUHmjZUfBNsQ6kfnYP04QY/kCzCMXD/a4PrpNhuhbZGjz1SbCpNw7I4dMRWXvxy88SJ2KmVS8dDFo0puWXlnmI6SGK4VNIsDNx19d7yoERxqMky7QSCj/K+j+CO6Cvy9vC2ft0AVaakz6B3PV6SSi+FsrLKwvVhZPLDZFMinGAxPr0DxVTJvNSSEKn5Kbtg7Vk/xCyaHzR8P0ElXEmrhBvMtvtDF6MbEogF7EYRWCPxF13OJk2UkNZQzHCsqkT+WalKFyYQY2fYyD9JhEMFJ6nTbGyEmxNFziwvPGFY/zy+Lak8gG8VvuZ7IHw5bZRVUnhw0ia3POgt4dst5aHH8jO1OU3mdp6qEeVtpdE9tpq8mDP/sVxfyGZO2sUSHIJM//iza2tE6o4NMLsO9nlRtwTTiMXKM5QMqK+DmHgKQdzg2yUIt7DICf09p8qLotHdEzpet1j58OYXE3dYStvY8gDEGyZV7HUkMMUm/Fx3KMiFEfqsbkaHKEcJjwgjHhXThTsvI/lU1ZdCa5Cfhye8pr6qK39igQSpS9R0gnrWpAjLMFVRPqzCeofB7uj4k7MzaBChJt2mhUpt0oGuDX3k2PvhQqxIkcn+E0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(47530400004)(451199015)(5660300002)(186003)(2906002)(7696005)(6506007)(38100700002)(26005)(10290500003)(110136005)(316002)(82960400001)(53546011)(54906003)(86362001)(6636002)(66556008)(8676002)(64756008)(82950400001)(8936002)(41300700001)(66446008)(8990500004)(4744005)(9686003)(921005)(7416002)(66476007)(83380400001)(4326008)(52536014)(122000001)(38070700005)(55016003)(71200400001)(478600001)(66946007)(76116006)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWpmSUIwWTdTbUozUWtSajZzcmhqMXRkVWp5VzkrZXp4NDlNR2htam5kQWV3?=
 =?utf-8?B?T0paN1ozNlNSUWN6eTd1eWk5czFCczYrTFNXbk43TmlCcGJiTjBGNE0xMVNn?=
 =?utf-8?B?bXU3ZndFeEhiVjNTL2hyVHRud2RMMjdnRSsxOFJlYzRzYVZrbWZ0bnp3V254?=
 =?utf-8?B?L1NrZUxURUVHbnRiMVdwcTZjTGpvZnloWm45dEJMcE04ZTVzSmNxUm5sT0d1?=
 =?utf-8?B?YjVnOElTN2I3N3lFU1JOSDhRczRnNy9OcTBHL3JubXBRQnR5bmN1cUtUeW5h?=
 =?utf-8?B?bDdGVHdraXVRb0JVTVZZaXluUlFpNGk2UThVTFdsRXBUQWxHQWdmM3p0VCtD?=
 =?utf-8?B?eTZoTnhXYW9IU1cxVXF1bVJHTnVRMUllQUlGSzQwSE5OLysxWElwYitUcGtt?=
 =?utf-8?B?a29aSmUrZUtJZnZjQ3Y3UC9xSVJ3dWZRY1MrN0hhRGJsZ3hOQzMyWHVJK0l2?=
 =?utf-8?B?VGUydFBld2RJUkN2STJKNE5qV1crNk5XcHJqU1psajhoT1JPQ0piME9FWnVT?=
 =?utf-8?B?L1V2aURNM0VIRlY2SEVRTVZtTGpxdE5Sa0NTUFZRUVJwckRFRThxOWFreGN2?=
 =?utf-8?B?eFN0amlpTjY4Zm1nNG1pRFdCdjJtTkdJTUJsR21mYTJzNUUwQ0JiU1N2UTN1?=
 =?utf-8?B?RHZUSXBUc1RuV25nV2xVeHBXRjFwOUNSUUU4MGZtcERhdnpiYTFtWDk5T1Zl?=
 =?utf-8?B?aGFkZlNXeERtNHBSclg4dmdiVGNrM21MZGZWSFk0SUpHY1RaMEhlS3VyTEhQ?=
 =?utf-8?B?OHdqeFlUZ0VCTml6ODhvc2QwdDFvdUd1NDh3REd0MnlHdnIxL3hZMitrdVoy?=
 =?utf-8?B?NFZBVTdxcTF2U01kMzlIdVEwRlljb2d2MGZac3oxWStkOWFOYm5Kb0pRTTlv?=
 =?utf-8?B?ak1uNWpZK2VZQlh5dXJ4TzJ2dXJMZCtxbHI3eXdkbEVmN2ZmZzNzdnZoNm1Z?=
 =?utf-8?B?UDBxOFAzWEJiR1J4bEhnWXE4SnhqNXpqYlhVWERpY3FVZDFJNEFSV0YrcTJO?=
 =?utf-8?B?RWVpdGZ5N2s1Mnp1SlI4TUM4SFVkVXBXSldITytySWdzc3RUcFVLMlNrNjNV?=
 =?utf-8?B?eFRicXRDWko4NHNndDIrMFVhTHJWU0duWE0rSDV5UE5rdkhiaFFjdVJjVHVH?=
 =?utf-8?B?dTBaMnZBOE5LQyt3TTk4ZFdvVDlqTzY3QWxLdlBySnpPWDRmRDJQeXhBQ2lL?=
 =?utf-8?B?TzdiLzhtaTVyZEkycUo0Y0MyMHdXaS9tNmtOZ3dQYTkrbVRRbUZTVmFZTzdF?=
 =?utf-8?B?YUQ0aGZ5OWdtTk56YUVsUmdTWmpZZU9ZTkxRSUJpRHhGQnJnRnZNTHVReHhI?=
 =?utf-8?B?elFpUEhyYkF0QzlEOXNDb1ViOVdwMGtJZ051UWFRQy9NbGpuYTZMV0Z1R1Ro?=
 =?utf-8?B?ZVFSMDAyb1FabTRucTZJMVlnZDJnYTJrdXgrL2lsN3M5NWJwNG1SMjNFaEFi?=
 =?utf-8?B?QkxQZ285T3pyQit1WFBTMzFWR2VVc3dYVGJ1SEQ5SVljSEIvZmVMSnFWMWRj?=
 =?utf-8?B?LzBYWXhoTTR0aUpVYjNrdXBwMER5Mk1XMytVUk9LY1hQTEpoUlJMWEI4MUVy?=
 =?utf-8?B?bEc5U1NqaHdPTC9Fb015TmNuWEcvaTJ6eUhieG0xcUI0bHhTSEFYMGpTOUxW?=
 =?utf-8?B?b2xFZ2VQWmUwYzY0S1puSnIxL0hucTlhMmQ1ajl3MHBwa2xkbTNhZktRVi9F?=
 =?utf-8?B?OHBsMUJ1R2dYTTZjM1k4em5QMVAyWThsS3h3NWxIQkRUYkY2ZjFicm9pTVlL?=
 =?utf-8?B?dGh3SUZmeDBodVRaQStkK0podDdPRTBGWUxyOXpxZFZLV2lncDZ5cFZqS2ky?=
 =?utf-8?B?bkprK0l3WG1Ob0dOV00xcVJqRkMwUlFvQ284RGtxMUNzMFdjY2ZlSUlsMFJk?=
 =?utf-8?B?cVp2L2FYelVwY3MrUzFpaFhzZlZyVHZTR0hRd2FZb2MzZFRYTXBKUUphYUts?=
 =?utf-8?B?YTJNdk1JdndIMlFIazE0cDhlYytSYUxRUVBvYVYveEtLcjJYcGtlNGtBb0ll?=
 =?utf-8?B?NVdpcWhFM05QYWN6Ylh3UzBPdEJ2bm5WRW1JaWNucEFRR3VYcCtmdlZ4SXZR?=
 =?utf-8?B?a2NGWVpha1M0NXpNMFNST283MjU1WU8zeFY5cUZxQ2JJVms5WmJRYUdWWXNs?=
 =?utf-8?Q?n9IVW/Lew9hMVvbXC/LyB9ioc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d4a62-ffa2-458b-6b28-08dab3c5c12f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2022 00:38:35.6917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzjucHIjYklpmj3bXcyNjol0JpPtA/iv9GMBN3oD1JygV0TCDnufN4Auy0R2abMom55ZVYcmVsQOB5ackzkOVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1494
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BhdGNoIHY4IDEyLzEyXSBSRE1BL21hbmFfaWI6IEFkZCBhIGRyaXZl
ciBmb3IgTWljcm9zb2Z0DQo+IEF6dXJlIE5ldHdvcmsgQWRhcHRlcg0KPiANCj4gT24gMTAvMjEv
MjAyMiA2OjU1IFBNLCBMb25nIExpIHdyb3RlOg0KPiA+Pj4gVGhlIHVwcGVyIDggYml0cyBvZiBh
biBpYl9tciByZW1vdGUgdG9rZW4gYXJlIHJlc2VydmVkIGZvciB1c2UgYXMgYQ0KPiA+Pj4gcm90
YXRpbmcga2V5LCB0aGlzIGFsbG93cyBhIGNvbnN1bWVyIHRvIG1vcmUgc2FmZWx5IHJldXNlIGFu
IGliX21yDQo+ID4+PiB3aXRob3V0IGhhdmluZyB0byBvdmVyYWxsb2NhdGUgbGFyZ2UgcmVnaW9u
IHBvb2xzLg0KPiA+Pj4NCj4gPj4+IFRvbS4NCj4gPj4NCj4gPj4gUmlnaHQsIG15IHBvaW50IHdh
cyB0aGF0IG9uZSBjYW5ub3QgZW5jb2RlIElOVF9NQVggZGlmZmVyZW50IE1SDQo+ID4+IGlkZW50
aWZpZXJzIGludG8gMzIgLSA4ID0gMjQgYml0cy4NCj4gPj4NCj4gPj4gQmVzdCwNCj4gPj4gQmVy
bmFyZC4NCj4gPg0KPiA+IFRoZSBoYXJkd2FyZSBleHBvc2VzIHRoZSBudW1iZXIgb2YgTVJzIHRo
YXQgZXhjZWVkcyBVSU5UMzJfTUFYLg0KPiA+IFRoZXJlIGlzIG5vIHNvZnR3YXJlIHN0YWNrIGxp
bWl0IGZyb20gaGFyZHdhcmUgcGVyc3BlY3RpdmUuDQo+ID4NCj4gPiBJbiB0aGlzIGNhc2UsIG1h
eWJlIGl0J3MgYSBnb29kIGlkZWEgdG8gc2V0IGl0IHRvIDB4RkZGRkZGLiBJJ20gbWFraW5nIHRo
ZQ0KPiBjaGFuZ2UuDQo+IA0KPiBBY3R1YWxseSwgMl4yNCBNUnMgaXMgZW5vcm1vdXMgaW4gaXRz
ZWxmLiBEb2VzIHRoaXMgZHJpdmVyIGFjdHVhbGx5IHN1cHBvcnQgdGhhdA0KPiBtYW55PyBXaXRo
b3V0IGZhbGxpbmcgb3Zlcj8NCj4gDQo+IFRvbS4NCg0KVGhlIGhhcmR3YXJlIGNhbiBzdXBwb3J0
IHRoYXQgbXVjaC4gSSBkb24ndCBzZWUgdGhpcyBkcml2ZXIgd2lsbCBlbmZvcmNlIG90aGVyDQps
aW1pdGF0aW9uIG9uIHRoYXQuDQo=
