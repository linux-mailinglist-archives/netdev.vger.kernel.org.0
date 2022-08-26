Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8580D5A1DD6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiHZAyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHZAyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:54:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2119.outbound.protection.outlook.com [40.107.237.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0754AC8884
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 17:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzJYPFQQ/a4ovwy4p1HV1Kv0clbqUOP/AWOmrnO/SYDhE2lBDHel0QqmzY6EFvr2DP4YvYXrCTYX8EDE5tsvNL8+xvgre8N3UdnRGE7A1e4jbSFdbiSZtwLPCkdiW0O/mMwwJ7+KVnEm36hghepMIuxjFEhKxIWQHftmaA2zi9mFE1nN13kqiCKQJhrM8mmBD3cuxdvt0MNdxjSSgFJCp7HFczEZ+9q/vNXidQCk7nSXimUob6urB0iB7QtNh2RMfM0K4xfq2jx7WRj2jLRqxj2To/4oL3cBGz2aiIsgb1t8C8R8OTR6zSE0c1E4PNp/pWDnkUstIA10ApWYv+670A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTG0ABxZztEWvEE+dwIM02bkPvZI6Fx2VQ0syqaTb48=;
 b=PciVBP9YFsgktdWJ+0hyRnbJO/iFsRC8R4+kVtX+nvM+4Fl2PnFQ5OkPL1Qkhpy1pN4dyFcyQ5jGg14T79ySXV9pIo3Oa8W3dA69vU5NsVLu4pCXAlmpNbVkV6lxwWaCfXos1cIkzX5zOlhtfad+UsL7s8pgjKCOGLDQ48MGg2dQUkrKrYN+cfUPEZ/rIwkO7D1yAbntQ97K7cflZBD/L58cAql5RxBQoIBiMV6krlsVPiCxBO2LtMDlRqpeAxSVfUzDgNM8s9mh1eeRvepsqWoQiE40W49BEjV2cJPNCRbGlEWdjk6TlZ1ZyON7h3YXYkIy8UeOnsjlBMkckNeISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTG0ABxZztEWvEE+dwIM02bkPvZI6Fx2VQ0syqaTb48=;
 b=q/iihuxEnoFH/ttxLM+Q9rL45839DnocS6hxopwhx2FyKSPpMlL4pDaN4fr12yUDe02xxX5cESGrMhrDtAr5pF7w+mVGfBVIC8K7tMLk4U5vlgzdZf/4YP8yxMMWpgehjuikNNY8xoaMEuESRYQ9k4DlQimWM+Ck1ZrTxAMWKXA=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BN6PR13MB1730.namprd13.prod.outlook.com (2603:10b6:404:143::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.4; Fri, 26 Aug
 2022 00:54:11 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::287b:f749:f9c3:5bba]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::287b:f749:f9c3:5bba%5]) with mapi id 15.20.5588.003; Fri, 26 Aug 2022
 00:54:11 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 3/3] nfp: add support for eeprom get and set
 command
Thread-Topic: [PATCH net-next 3/3] nfp: add support for eeprom get and set
 command
Thread-Index: AQHYuIy/W4rIevAVQkK36zsLnuKrSa3AJ/YAgAAwdBA=
Date:   Fri, 26 Aug 2022 00:54:10 +0000
Message-ID: <DM5PR1301MB2172EA32966B95D195FC0B5AE7759@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220825141223.22346-1-simon.horman@corigine.com>
        <20220825141223.22346-4-simon.horman@corigine.com>
 <20220825144920.5c709331@kernel.org>
In-Reply-To: <20220825144920.5c709331@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3341fdc6-4e12-47b2-9500-08da86fd7d1a
x-ms-traffictypediagnostic: BN6PR13MB1730:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: swf34hotGzNfYON1LO0ChrD2XbYv3B6o2BfhvTqJI2Be7i58msFCtoLdll2zyVpLYom/NPbdIfGIi2479PL03BY+QjispJ9vq9JxGkdpEXvv5LHHdDlvBZIpTofdqCuSMKhEb2gPbuLnkpWzS7oypB1eAfkKXRgsOReTj8OAt3scWQQyDfozAiiD5R5tR4u2TEUzFDl1drGx4EoPBuw+NqJ8dvadOpp4v1d5rUE3NPHIoSzeWbALRSTvHGLCzKoQykBtDl9hqE0h0HIYyirobGryusQc2i/+ZqnDUUtRNMGa3l97HXrV5cY495XyG1s1Objz6VP4nabpA9e6e0cSv21GuFhmEc1hbY2kJGsgNekf0iNJGin1B0juNR2VzkVescOODs2+O4Y1ZyopXHB/c5kwG3cz8JgDXrAs5trFJ4AlSqhEVWMiTmqAhtH+wtfBrgrLzXTZoPQmr9OtLt7gyhE/+lpS/DP4Ty6p1kSwv1sYURkiK+38Svmomku8CvNFQ1HM4vWR70cyl98diKfst3eIjSNm5Qfa+lzbM7owU6+6TbSPFNe7BHAX4qA/stnL3TbSHDLQPRmOInDYc6627AHbaHjewWDgC8IKhZo/Af4pDwhZ1aevvKxYmXdmtcuaNpCPihFkBBVFRMQvk8euiC6eRgRRbWsAe83dO1NzLGIyi0aRveL3MXALbaeb3fCFDm4ri/dl/s7vXssd5hvku29n9b09CPdzOSvPaosQ1PW2VQ1VVfB08hk9Gw6vYQpxjhttqV53fg54mgSV7iT9Tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(8936002)(38070700005)(33656002)(86362001)(55016003)(122000001)(38100700002)(52536014)(478600001)(66446008)(66476007)(66556008)(64756008)(66946007)(8676002)(76116006)(4326008)(5660300002)(6636002)(110136005)(54906003)(316002)(71200400001)(41300700001)(7696005)(26005)(6506007)(2906002)(107886003)(9686003)(4744005)(186003)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3dUak5nYWk3N1dLK0lJUm03YUkvbVpuZExtdWtMSE9hK1FCTmNhdi9MbFpE?=
 =?utf-8?B?VE5oR1lkcDlWSUpDYWcrQS9CZHNNNkJSOGJwUlVnSDhvUTJpcFJHTG1oWUN3?=
 =?utf-8?B?NnM2WUQxMG1Tb0RKVXNYYzF3b2lzRDUvU015NXRSV0JIMTYwbGFuanZ1Y0xt?=
 =?utf-8?B?K2VScmFsRExoZjNpMjNmems0TjA0Z21maU0vK0VUaFVBR0ZJM0J1cHVjcWlw?=
 =?utf-8?B?OVdjakpmUWovNVVnSHY3d1hsdWpOZUVHZlZxdGxNS0s0WERGRDdvTGEvQlg4?=
 =?utf-8?B?ZEE5ejZmSDNwNThhTWQxdnpqVVNyNm0rdmR6OThWQzFZNVVCRG8xejU1Mysz?=
 =?utf-8?B?aTVtVlZzb0kxZHF2UEwwcXZvWlNESHEvZ1Vwemppa1dwUHI4WDdUNlhLL0RE?=
 =?utf-8?B?am9VNHdXc2ovR1B6Rm11Ukp3aWtTOGFqdUxnd24wWDlsak5MczBQT0V2NnNw?=
 =?utf-8?B?bm9MMkVSQzNXVENOM3FMUHdYQkk5dzVyM3IrSDVaVFF1d085QlUydmhWSEJH?=
 =?utf-8?B?V3FaVHVOdG5QNS9WY0hnejlLNWFZU0MzYkdrWDNibjcxZW9NK09Udk1KUmJt?=
 =?utf-8?B?QjJwUzdtWWorc1BDdUJoNG52SERKMThJczN3ODFwZ2twSlRiRncvZlYyTExn?=
 =?utf-8?B?di85c2Z5VzYvSHE1V2RZTGU0VnlzYnR5ekNOYXZweEZacXZTVko5RTZBa0xX?=
 =?utf-8?B?N1BkYkVDSFNuVzgxbHJGRVBEU2ZMbTRQNWxEc1pBOGM2U3FwUEdGYnB3VDNG?=
 =?utf-8?B?TENreVFKV0ZvZmpVbVBEYzZFRzVmRFdUSVNjOFFLeHVSRTdwa29kTG90bXUy?=
 =?utf-8?B?NERoVVJYbFZwUXNpZExvMVRGdDVUVURvdmNmZWQ2aG5OM0FWNCtyR3BrUm9u?=
 =?utf-8?B?d3V6c0VDR0xIRXAxN1VHVVVucjZBVVlzNFRiVTFieXBzMmhZQmpXU29STktT?=
 =?utf-8?B?eUlnZXdRTGdxbENRZnJ5dmoyWjFnblI4T0JTY2pMNkUvRWVXQnZIdkNRay9j?=
 =?utf-8?B?REhvMzU3alFZQWxmV2J6MEpHbTZYeWdNUkZDN0g0cHVqMFY4T0syWk14ZGhu?=
 =?utf-8?B?SmZ6d2F6MnYyY09BT3pCMzdCdHlyZS9hcTdKT0cvQmhTd0t4MWlZMW9qcWZv?=
 =?utf-8?B?RVZjUUJyWUloODhxTGdrT29LTUdKUG1JK0dBckZQUCt6Y0hhM0tLNGxwS1Bi?=
 =?utf-8?B?ajFUUllEU1hydEtMaFcrcjVIeXFGR0N4VlVRSjdacFVBUWlDeXErODZpR0dx?=
 =?utf-8?B?Y2w3emFIQnlDb3FtNUZOVUdOTW9kbHArMi9JbzNZZ1Y5VS9KUTJ2cXlvSGFW?=
 =?utf-8?B?ZTlSUjgwWlNoTXZSSlhZd1ZuazNpTVNHRWhTTk92cjBXbG9xN2Nwa3FXcVFL?=
 =?utf-8?B?TjFPSUNhclNveENuOXFyMW1LQXMwVGpIQjFXOFErcEd3RmxrNEUvMHpQVnM2?=
 =?utf-8?B?b2I4OFdZZFZ6Z3oyMHBYMUhRL1pqNitHZ3dGYlUxTXFiQjhNU2RMNm5SeVNn?=
 =?utf-8?B?RWpKZUdNVDJ0MS83K1hIb1FrNFZIbTRJRjY2ZlNvNkpMQnBGU1d0ODVGV0s4?=
 =?utf-8?B?RjE0WTFXNWxoZ3M1Mk1nM2hCNi8vRHhHRDFhLzU3bHlWYmdIbHZXZVB1MlZh?=
 =?utf-8?B?QnBXVkxVUUd5Q2pQOE9kTkpuVUF5YStwaHFqQ2ZQdzkyUi9QWVFybEVKYko3?=
 =?utf-8?B?MDFGaGFWTnpWRERIWWVBSHB6Q20zRHZtZk1maHF1SHByOUJhRkJjRFdVWGhD?=
 =?utf-8?B?RGZmTlBRVVJ3aytmUkVNZHZIbWRVU3MwaEhHTjArUk5hQ1BMZnlUVU54YXB1?=
 =?utf-8?B?RDg5Z2I4cmwwMlhtSFRPMWRSWmxhWGduOEdlQ21pWEQvS1Y2d2pvU1hueVpS?=
 =?utf-8?B?SURVU0JBQU40cDgxSnJ0M1FVdTBoNWI4Z1RTVksyNWoweUIzamhndkNpbUgr?=
 =?utf-8?B?aTF5eUJOREJ4ZENuQkFxRSt0OXVCUjBtMGJKdEpDcmJPSlVPNUV4aVUzbUdR?=
 =?utf-8?B?R1NocXZIU0dFSnFOQ3g5ditickZtVXA0eXZ3TFlJL1dmUWJNM3FzT0lSUFlP?=
 =?utf-8?B?a0p3bWtqbGJCell5R3poeWNPYVFhWWZlRDFGTU1xYkZnb2kweVNVNmgvK1hh?=
 =?utf-8?Q?ZV7hurGZUVT406lgcBCuvs7o9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3341fdc6-4e12-47b2-9500-08da86fd7d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 00:54:10.9463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABDyQREs6aN0AQa+OHMmNI7fGaG+lOsNtDBU1d1IcJmuw50v6dfqkUFtYrI/YMB0gpwo/INskTl9QZk7iikSy1SdEODaKKy2skFMkSqAPvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1730
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gQXVndXN0IDI2LCAyMDIyIDU6NDkgQU0sIEpha3ViIHdyb3RlOg0KPk9uIFRodSwgMjUgQXVn
IDIwMjIgMTY6MTI6MjMgKzAyMDAgU2ltb24gSG9ybWFuIHdyb3RlOg0KPj4gRnJvbTogQmFvd2Vu
IFpoZW5nIDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4NCj4+IEFkZCBzdXBwb3J0IGZv
ciBlZXByb20gZ2V0IGFuZCBzZXQgb3BlcmF0aW9uIHdpdGggZXRodG9vbCBjb21tYW5kLg0KPj4g
d2l0aCB0aGlzIGNoYW5nZSwgd2UgY2FuIHN1cHBvcnQgY29tbWFuZHMgYXM6DQo+Pg0KPj4gICNl
dGh0b29sIC1lIGVucDEwMXMwbnAwIG9mZnNldCAwIGxlbmd0aCA2DQo+PiAgT2Zmc2V0ICAgICAg
ICAgIFZhbHVlcw0KPj4gIC0tLS0tLSAgICAgICAgICAtLS0tLS0NCj4+ICAweDAwMDA6ICAgICAg
ICAgMDAgMTUgNGQgMTYgNjYgMzMNCj4+DQo+PiAgI2V0aHRvb2wgLUUgZW5wMTAxczBucDAgbWFn
aWMgMHg0MDAwMTllZSBvZmZzZXQgNSBsZW5ndGggMSB2YWx1ZSAweDg4DQo+Pg0KPj4gV2UgbWFr
ZSB0aGlzIGNoYW5nZSB0byBwZXJzaXN0IE1BQyBjaGFuZ2UgZHVyaW5nIGRyaXZlciByZWxvYWQg
YW5kDQo+PiBzeXN0ZW0gcmVib290Lg0KPg0KPklzIHRoZXJlIGFueSBwcmVjZWRlbnQgZm9yIHdy
aXRpbmcgdGhlIE1BQyBhZGRyZXNzIHdpdGggd2F5Pw0KSGkgSmFrdWIsIGFjdHVhbGx5IGl0IGlz
IGEgZ2VuZXJhbCB3YXkgdG8gcGVyc2lzdCBNQUMgY2hhbmdlIGR1cmluZyBkcml2ZXIgcmVsb2Fk
IG9yIHN5c3RlbSByZWJvb3QuIEFGQUlLLCB0aGUgODI1OTlFIHNlcmllcyBOSUMgb2YgSW50ZWwg
c3VwcG9ydHMgdGhpcyB3YXkgdG8gY2hhbmdlIE1BQy4gDQpUaGUgZGlmZmVyZW5jZSBpcyB0aGUg
b2Zmc2V0IG9mIE1BQyBpbiBFRVBST00gdG8gc3RvcmUgdGhlIE1BQywgaXQgaXMgZGVmaW5lZCBi
eSB2ZW5kb3IuDQo=
