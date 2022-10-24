Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B226F60BA5B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiJXUfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiJXUfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:35:10 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazlp170120005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9910275E7;
        Mon, 24 Oct 2022 11:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5uDABuYpJveAkeZ1B9MBuApp2CosN0lavPlVUjWz9f9iMshNBsFuUQawUxbO2zH8fD7knEMBHqBga62jOZ8brL/fpuTBQsmnJ1XmEhCdyO2lRe2F/rTYeNRb7N2qYGdflbjC4hdCHs5LGs7acqzxy+N9twhU5jcFbGHJnMpLLUm3XKK8WEVaiK+oV2mU0iDGzX0/zXnxrfE2E0qrTAHfE7LLsHJQLZHqkmdX5szD43rZi+1azb+c5329oZGNCu4xIrglrciaeGt71ZLxS1TiqR0woI5EAzMzm5oDtIfV3dTJIUxG93E7p/5gKIy0pZxnN8adACHZlFGT9K9T8Cuvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQXtvSdDsN6n4b5Dppeq6SAUevV/THp4qvF69pGfiVs=;
 b=eV3Gw3jFxT0sw7+L/jfb6CVC4vERKPq6GiKGXdznK4Mu/QIHVCBHbnrzdndxqxW1RlU9PKL1IcILqv/K9idVMBJbRG9Tx159NdnHOGjaFVlnJaJ3ma1zM41mhHbQGXgXCFYQ4o0E8hCaWTS4w5QiJDuL3LndfdMI9GO3Elld0j7+z2XcGJ6B834o7RNv+wbQxF0QtfzxOTHdhGBs4yJUPjv4s3eUqI/OfIPLdGbiCU4PEt72D19+trIOmAh+LvFhggDPNe1WeyKXwzjMmLyxKV/Cw03zhkokz7J2yD4vNrGXZaZ9mK9/uzt4zgeAxWmeH7qcFOoOTYsvRsyLLAWftA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQXtvSdDsN6n4b5Dppeq6SAUevV/THp4qvF69pGfiVs=;
 b=aaWUR3kQw7AZYSWWd9eddbHkC3Ry9vhcJnM1MGDB+XCLiimJIqUKidHX/9FnOHpy0ytDgDdXQunMjtYZhyLzAuV1w3aB5EXun0MiVaHCuGEZHb0XyBBBveA66LSDjp6It6utVt8PM7WX10qJiIolFEpxP33NqwbASJwGByi0hjk=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DM4PR21MB3299.namprd21.prod.outlook.com (2603:10b6:8:6b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.8; Mon, 24 Oct
 2022 18:45:00 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Mon, 24 Oct 2022
 18:45:00 +0000
From:   Long Li <longli@microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
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
Subject: RE: [Patch v9 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v9 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHY5al25GPEQ8/Qv0mDFYQ5rRZUYq4cwkcAgAEhilA=
Date:   Mon, 24 Oct 2022 18:45:00 +0000
Message-ID: <PH7PR21MB32633AC8730AFB4E6C247BABCE2E9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-4-git-send-email-longli@linuxonhyperv.com>
 <05607c38-7c9f-49df-c6b2-17e35f2ecbbd@huawei.com>
In-Reply-To: <05607c38-7c9f-49df-c6b2-17e35f2ecbbd@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6c779de6-f378-4717-b5ce-370484ecd03e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-24T18:36:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DM4PR21MB3299:EE_
x-ms-office365-filtering-correlation-id: 3c6df7f4-c58e-4ff9-81d8-08dab5efdafb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lW4VeZVOP5gW8g/g/2zAtxA2BacQSxY32M5pLprMSTjz82V6TvgxLocPQ0CYrr3zq4P+RJYTC4D317JM3OkfffyKNBSpsh6TwBrAl2XEpiYsVE3LcCu5TJY6uXMZXZ2+etxdeJxvn1WaLqwjEMPzS4HvRNbGNQKXaf1u3x3Ms641lPfvttJx5UYScJcVkbpGTBRopCyFTAaKiWQJvf5BMc6ZpuAySRTrFeij4yC8agYnPQhLGlxh0BdTQAmpJZBJmTKy23JexaCRMSHPql+rlSIzo5CfrTa9p000FLSJ0vaLvCfRO/biqiz22wcSAWcqcDRXNxU2+wNergg6LDVWFRjtDzhq4FO/uTzXgltjuZ9leom6UD9UDNg1b8Rx3skV8Fibpmf3VrMevrO5t/8ZT2SaYsD7tNz5UmuCI4YsIAbbZZgQdsS57Yr0sve3SwttSG7AyAa5uYeNghbYX5Fsd7OmePbVRptN2TV7O9SsRgfCkkWozfD+X2A4sjHd13YEm268omLY4DT1VTCxO16KWvI+sS08Pn0FKwP/uoMBCsa8nrcICu+/NtRYyUsXewk3x/cu1slqRgGpOWoVceIy3gVVVx4ZLRoXoGlXMLbWN3peyZzSEllRjqw2rqW6fLnDU1taqabvCdi7jCww1i3F5yOjE2IYRPCKwurtYgLXm6AgKYMwAfi9wxPHCeWhlCVPQjvAB+AYsBG0oUEd1k0j/cjSDyae9kEp9Y2cNRRGXdHS05HJESRWEaeDhzrZnlcePwjqrOrbhubsRSh5yZZtxqCl8qrgaaaOX/WMe2ZZjAtDutExNE+quKCuxJu10ycnNhV/0GZ4hjHs3yhdQqCVBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(186003)(33656002)(83380400001)(41300700001)(122000001)(38100700002)(4326008)(76116006)(8676002)(82950400001)(82960400001)(52536014)(38070700005)(921005)(66946007)(8936002)(7416002)(66476007)(66556008)(64756008)(66446008)(5660300002)(8990500004)(2906002)(55016003)(10290500003)(6636002)(316002)(86362001)(54906003)(110136005)(478600001)(9686003)(71200400001)(6506007)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTlPVVViNDRLUTRLM3RPZWtXZ2x5aDRSMTF1ZjdaS09CbkZLQ1RDUW8ydnF0?=
 =?utf-8?B?aStGVVAyUTlBNzNHVWNLYVA2c2JYVDZQZTRsZndiOG0xUU8zQ0duLzMwci9H?=
 =?utf-8?B?WitrTmM1cUQrMWZHN2JacDBFd0VVZ05HS0R2K3c1My90YlJzb2xRelhuNzZZ?=
 =?utf-8?B?WUR5SjhuZnY3LzBsNEpVRWx3SVllUjZ3OGdTMERUTXM0MXp3bndkaDU2Rkcz?=
 =?utf-8?B?R1lBbUVCRUg2VTNKL1ErR3J4NmtlbnZ6Z3lKUUZxbFZEOHIvWjhJL2NIWnY1?=
 =?utf-8?B?ZFp5djFDMXRhZzFsT2NtWlRIenRZeVBWakF4Vmx2akNnRlhXU2JVQUIrdElk?=
 =?utf-8?B?VHhKSHZlZGVyWFNscXdveEUxWnY3cGpwbHpqMzlDVVUyWHFXbWZvQ2UwUnNM?=
 =?utf-8?B?UVJUYWsydlhIRG9ZV1ZncG5VTTJoY2JtN3k3cEpRMDdQamZOcjJ4RlFaR2xk?=
 =?utf-8?B?QmZoRW55WUtYZFc3TVkzVWlhZ2dPTEZLTWFZY2NsRWxwb21VcUlMZWJQNElO?=
 =?utf-8?B?NU5PdkdJSE5yclViOElYbnRWUnRzRUhQZ1JWZ09uZ2ZsQUF2ZjhWQnd6TmRr?=
 =?utf-8?B?V2RDK0dVT1craVFuSUJLUUh0VjNjcDZDNWFIU2ZtYmplUDYzUXZUZ29lbzBv?=
 =?utf-8?B?ZFQ4YzJBZFpuN2MzS3JWQW15QzJIZm1Ga0N3UWNwdHFBVGx5MHlEeWVVeUZJ?=
 =?utf-8?B?ZFpIUU10SmdiN0wwTzl6UDRQTGpydVVqVlliUktCQ1BaWFNGc3JxMW5kYi8v?=
 =?utf-8?B?cXMxYkJYckRUYnpyVFo4RnRFZGhVYmxjZ0xBM0p4TW1aOGhBRmxSLzRkRi8x?=
 =?utf-8?B?aEVrRlQ1cXlPWW1YMVB0MFlFMWFLTnI0cTR4dzYzb2dWVVZYU0Q1QVY5NWFu?=
 =?utf-8?B?cXhacFNPMWo4OUwrMUFqVWpIRDdlOG1zd3JMZFJlQStuV1dmbWtqc0VxVGcv?=
 =?utf-8?B?QW05Yk5nSGZTV3VHRFFqRDFQSk9OTWJ1eVU4bk0rYWgzdXI2WnRsU0dFUk9C?=
 =?utf-8?B?ZDZYMTI5a0FuK0gvd3VnRVhvL2NkQkI1clVSdUFvaDNESVpKY3V4V0xqS1JT?=
 =?utf-8?B?bzZwcFJxWUtOZU4rZGJoZE9jMW9hdzBWT1NWejZOQmRyVEFJVTcrV3BIVTBX?=
 =?utf-8?B?WmdlL0VRc2NraktxbFFWM3Z1N01Kc3Q1YVBLbXBFZXJxSkVBSFBJVk5qSk11?=
 =?utf-8?B?dE5JZHU2bzJLM2IvN0FJZUJrbm1pc2VoS210aWFZa3l6VkI0Q2lKQlM3cWtB?=
 =?utf-8?B?Z2ExR210SGE5WkcvVWRYc1VWNzFJUFBKZ0xCMjc3QUpERXFiNkl2QmVxUXR1?=
 =?utf-8?B?ZjV2cjZybWtiN09TYUFyOU1tK0dqRDZ0VGpNbUYyeWFVdFdLUi90Rjl4OURB?=
 =?utf-8?B?WjdGY3FwY1pqRHpDYkR5Sk5GWjlwUDhCRUpSdVhZZ3JZSFdJcWVkd1hROGN1?=
 =?utf-8?B?QUpyMExDUFlOV0t4VEJvbzN5K3plaFBiZFhVanlSeHZMeGphUGlpeGR1aXNu?=
 =?utf-8?B?MFZKeWpUbXlFSzdFNDNFZVdzczVMQ0xHYkFCam1uV091ZE54V0ZBREQwSG0x?=
 =?utf-8?B?dXNIdWowOVZyUTR3QVdSUnUyM2FWMHNXYmVITGNLaVVFSU1EUGJPZjZFaXJz?=
 =?utf-8?B?R0NCeTJsd1hILzJYczBNTlFRbTE5djVCWnozb2pndmdPQlF4bkFHdWR4eHlo?=
 =?utf-8?B?VWFDVVhmOVRNNDdqMjRKdVAvUXNmVGF5eW5HSk9lNXpScDRhQkZpQnBTSmlE?=
 =?utf-8?B?eVdEN2tVc2ZFMUhqZ01nZ2locEdQUlRUb0t4MUc4Sk1kZkVDeDBoWEQ1UzNW?=
 =?utf-8?B?dzg3RnNtNzE2NXQ0enVhOHhFbUZBcCtHcitBcVArb1hPNzY4OHhxS2hFN05w?=
 =?utf-8?B?bEpvd3ZMWmxxY3pINGMydHFHYzR1UEo4cytNaktrM0dhdmFTMzd0NnYydWR1?=
 =?utf-8?B?SHJLaHZIV1IvZW4zdFlxalZyNkF2NEVTYUJUU2NhSU1FSzZMajRwWWxKM1FD?=
 =?utf-8?B?d1o0UjhsMVJIdmVvUmZJMUZwLzltZFRIaC96aC96RkZJUXRoY3IzMGp3bzFR?=
 =?utf-8?B?YnllazV0YmJlbHlWUmV5QVYyNVhXWWtXTGVkQ21iUW5MZWRXR3NueEpOMEVi?=
 =?utf-8?Q?FfqG+oJPu6AJi2f8V9eXJETCy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6df7f4-c58e-4ff9-81d8-08dab5efdafb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 18:45:00.1761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xrIl/1MuQF3UWu3ObXW92qa8yzVcQ8guEFCYhz8kwyIoWxEg0f5tGSFcMi4dSgFWS2UIp05ECdygZ4xtPdD3SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3299
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ICtpbnQgbWFuYV9jZmdfdnBvcnQoc3RydWN0IG1hbmFfcG9ydF9jb250ZXh0ICphcGMsIHUz
Mg0KPiBwcm90ZWN0aW9uX2RvbV9pZCwNCj4gPiArCQkgICB1MzIgZG9vcmJlbGxfcGdfaWQpDQo+
ID4gIHsNCj4gPiAgCXN0cnVjdCBtYW5hX2NvbmZpZ192cG9ydF9yZXNwIHJlc3AgPSB7fTsNCj4g
PiAgCXN0cnVjdCBtYW5hX2NvbmZpZ192cG9ydF9yZXEgcmVxID0ge307DQo+ID4gIAlpbnQgZXJy
Ow0KPiA+DQo+ID4gKwkvKiBUaGlzIGZ1bmN0aW9uIGlzIHVzZWQgdG8gcHJvZ3JhbSB0aGUgRXRo
ZXJuZXQgcG9ydCBpbiB0aGUgaGFyZHdhcmUNCj4gPiArCSAqIHRhYmxlLiBJdCBjYW4gYmUgY2Fs
bGVkIGZyb20gdGhlIEV0aGVybmV0IGRyaXZlciBvciB0aGUgUkRNQSBkcml2ZXIuDQo+ID4gKwkg
Kg0KPiA+ICsJICogRm9yIEV0aGVybmV0IHVzYWdlLCB0aGUgaGFyZHdhcmUgc3VwcG9ydHMgb25s
eSBvbmUgYWN0aXZlIHVzZXIgb24NCj4gYQ0KPiA+ICsJICogcGh5c2ljYWwgcG9ydC4gVGhlIGRy
aXZlciBjaGVja3Mgb24gdGhlIHBvcnQgdXNhZ2UgYmVmb3JlDQo+IHByb2dyYW1taW5nDQo+ID4g
KwkgKiB0aGUgaGFyZHdhcmUgd2hlbiBjcmVhdGluZyB0aGUgUkFXIFFQIChSRE1BIGRyaXZlcikg
b3INCj4gZXhwb3NpbmcgdGhlDQo+ID4gKwkgKiBkZXZpY2UgdG8ga2VybmVsIE5FVCBsYXllciAo
RXRoZXJuZXQgZHJpdmVyKS4NCj4gPiArCSAqDQo+ID4gKwkgKiBCZWNhdXNlIHRoZSBSRE1BIGRy
aXZlciBkb2Vzbid0IGtub3cgaW4gYWR2YW5jZSB3aGljaCBRUCB0eXBlDQo+IHRoZQ0KPiA+ICsJ
ICogdXNlciB3aWxsIGNyZWF0ZSwgaXQgZXhwb3NlcyB0aGUgZGV2aWNlIHdpdGggYWxsIGl0cyBw
b3J0cy4gVGhlIHVzZXINCj4gPiArCSAqIG1heSBub3QgYmUgYWJsZSB0byBjcmVhdGUgUkFXIFFQ
IG9uIGEgcG9ydCBpZiB0aGlzIHBvcnQgaXMgYWxyZWFkeQ0KPiA+ICsJICogaW4gdXNlZCBieSB0
aGUgRXRoZXJuZXQgZHJpdmVyIGZyb20gdGhlIGtlcm5lbC4NCj4gPiArCSAqDQo+ID4gKwkgKiBU
aGlzIHBoeXNpY2FsIHBvcnQgbGltaXRhdGlvbiBvbmx5IGFwcGxpZXMgdG8gdGhlIFJBVyBRUC4g
Rm9yIFJDIFFQLA0KPiA+ICsJICogdGhlIGhhcmR3YXJlIGRvZXNuJ3QgaGF2ZSB0aGlzIGxpbWl0
YXRpb24uIFRoZSB1c2VyIGNhbiBjcmVhdGUgUkMNCj4gPiArCSAqIFFQcyBvbiBhIHBoeXNpY2Fs
IHBvcnQgdXAgdG8gdGhlIGhhcmR3YXJlIGxpbWl0cyBpbmRlcGVuZGVudCBvZg0KPiB0aGUNCj4g
PiArCSAqIEV0aGVybmV0IHVzYWdlIG9uIHRoZSBzYW1lIHBvcnQuDQo+ID4gKwkgKi8NCj4gPiAr
CW11dGV4X2xvY2soJmFwYy0+dnBvcnRfbXV0ZXgpOw0KPiA+ICsJaWYgKGFwYy0+dnBvcnRfdXNl
X2NvdW50ID4gMCkgew0KPiA+ICsJCW11dGV4X3VubG9jaygmYXBjLT52cG9ydF9tdXRleCk7DQo+
ID4gKwkJcmV0dXJuIC1FQlVTWTsNCj4gPiArCX0NCj4gPiArCWFwYy0+dnBvcnRfdXNlX2NvdW50
Kys7DQo+ID4gKwltdXRleF91bmxvY2soJmFwYy0+dnBvcnRfbXV0ZXgpOw0KPiA+ICsNCj4gPiAg
CW1hbmFfZ2RfaW5pdF9yZXFfaGRyKCZyZXEuaGRyLCBNQU5BX0NPTkZJR19WUE9SVF9UWCwNCj4g
PiAgCQkJICAgICBzaXplb2YocmVxKSwgc2l6ZW9mKHJlc3ApKTsNCj4gPiAgCXJlcS52cG9ydCA9
IGFwYy0+cG9ydF9oYW5kbGU7DQo+ID4gQEAgLTY3OSw5ICs3MTQsMTYgQEAgc3RhdGljIGludCBt
YW5hX2NmZ192cG9ydChzdHJ1Y3QNCj4gPiBtYW5hX3BvcnRfY29udGV4dCAqYXBjLCB1MzIgcHJv
dGVjdGlvbl9kb21faWQsDQo+ID4NCj4gPiAgCWFwYy0+dHhfc2hvcnRmb3JtX2FsbG93ZWQgPSBy
ZXNwLnNob3J0X2Zvcm1fYWxsb3dlZDsNCj4gPiAgCWFwYy0+dHhfdnBfb2Zmc2V0ID0gcmVzcC50
eF92cG9ydF9vZmZzZXQ7DQo+ID4gKw0KPiA+ICsJbmV0ZGV2X2luZm8oYXBjLT5uZGV2LCAiQ29u
ZmlndXJlZCB2UG9ydCAlbGx1IFBEICV1IERCICV1XG4iLA0KPiA+ICsJCSAgICBhcGMtPnBvcnRf
aGFuZGxlLCBwcm90ZWN0aW9uX2RvbV9pZCwgZG9vcmJlbGxfcGdfaWQpOw0KPiA+ICBvdXQ6DQo+
ID4gKwlpZiAoZXJyKQ0KPiA+ICsJCW1hbmFfdW5jZmdfdnBvcnQoYXBjKTsNCj4gDQo+IFRoZXJl
IHNlZW1zIHRvIGJlIGEgc2ltaWxhciByYWNlIGJldHdlZW4gZXJyb3IgaGFuZGxpbmcgaGVyZSBh
bmQgdGhlICJhcGMtDQo+ID52cG9ydF91c2VfY291bnQgPiAwIiBjaGVja2luZyBhYm92ZSBhcyBw
b2ludGVkIG91dCBpbiB2Ny4NCg0KVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhpcy4NCg0KVGhp
cyBpcyBkaWZmZXJlbnQgdG8gdGhlIGxvY2tpbmcgYnVnIGluIG1hbmFfaWJfY2ZnX3Zwb3J0KCku
IFRoZSB2cG9ydCBzaGFyaW5nDQpiZXR3ZWVuIEV0aGVybmV0IGFuZCBSRE1BIGlzIGV4Y2x1c2l2
ZSwgbm90IHNoYXJlZC4gSWYgYW5vdGhlciBkcml2ZXIgdHJpZXMNCnRvIHRha2UgdGhlIHZwb3J0
IHdoaWxlIGl0IGlzIGJlaW5nIGNvbmZpZ3VyZWQsIGl0IHdpbGwgZmFpbCBpbW1lZGlhdGVseS4g
SXQgaXMgYnkNCmRlc2lnbiB0byBwcmV2ZW50IHBvc3NpYmxlIGRlYWRsb2NrLg0K
