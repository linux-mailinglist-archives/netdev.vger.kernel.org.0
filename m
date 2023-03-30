Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7C6D08DB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjC3Ozz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjC3Ozk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:55:40 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476D5CC14
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:55:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRuLy80Cy/274VugYqCNhjlLtpy3fSu5XhDdMaofirmJV2h7WpdJB6QoeSHcyB8AXnI8QuZDf0fcoDB7SWpV1d4ZvTznhvVXccOqPIN9YXZ1/A0q7VPepI1ZV1GLIxQhAa1kHNjZDMqeCj0PU0VKqJBS+G+s/awWAlyfcnqeGdFXFz6iyO0UVeGADkEB8QiZUArt1JPjf1bgdMBmccHe1IfIvi42BKaPbcxRZaQfZJgAcWLhH5fkEX10VrdaYsUBPDKL9N7YX0GRJ9OAIg/HOLwroFMZ/SbL6DTBXHXXbfLBlPdN1tre787toVb4irhe6xea/yXP+zv2rTTOIZLooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2ahSZjD93Km2tacfjIxgcYAP34m2Rj76RsrCzNllYw=;
 b=BJrxTL15ExsAL/IejZv1Yr795z5O5mvmrTTbj/MMlzuvoW7BCN5Sjq480J/PZJjB5WAvXYpDVTJrnvfudu/Zvszy4dWHeBehUvcKPLljsXtnC55CQSPSnFz2Pt0NGR+sfcc4ovjC0EcATkuZ1NqF1ws+aLroaAZx+GtZQ9v6NiEXwxjySCpCrxrZDlsW7Jnv1TnEMIeGdUCWxVdeLaMgN+7AjNf18U/vGp+KWVOARVRBVZiEmjUilY1JL1QkXnCKdWqKODyaEho2QNkAzlSzzM2Fw3hu6t1p2GpMFsCnws2VhqcvTi+hngtR2zXKOd2i94MW1gMkOJpB6lwrZVKSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2ahSZjD93Km2tacfjIxgcYAP34m2Rj76RsrCzNllYw=;
 b=i2yyeaHHr9+gbtIxkh8EwPdjMebIEO3TlfPYs6NFJpyYMqTu/OPqug2aKSNbO7T/FY4X2+aYvJHN1hSsWVxJd4DJ5UrQT9IrCJZEQJmrzlgZsoRiPGcNMGWXqLTUecp+MxwQwwqZEyQYZYvHdoULwuuEFXIeVHESsL8XDkm9z/A=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM7PR04MB6872.eurprd04.prod.outlook.com (2603:10a6:20b:106::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Thu, 30 Mar
 2023 14:55:03 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::44f1:b40b:b801:9a3d]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::44f1:b40b:b801:9a3d%3]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 14:55:03 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [PATCH 1/1] net: stmmac: add support for platform specific reset
Thread-Topic: [PATCH 1/1] net: stmmac: add support for platform specific reset
Thread-Index: AQHZXCi2zg+P+kQ+XUOXyeY0vvUeuK8Tdq+Q
Date:   Thu, 30 Mar 2023 14:55:02 +0000
Message-ID: <PAXPR04MB9185649FB402ACF46BF47434898E9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230321190921.3113971-1-shenwei.wang@nxp.com>
In-Reply-To: <20230321190921.3113971-1-shenwei.wang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM7PR04MB6872:EE_
x-ms-office365-filtering-correlation-id: 6ff12126-81f5-4d6c-34a8-08db312ebe0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YVLVTHCoR7FIp/56rjjI99JQoH4hi2tax31putPlr1xFJtb+1vWXlRJo+CWwcCjB/ES30iIBDGeb1Y+UWApgxY0mdfa4zEXoRkn7h9R0/7fPApnL+nVcLtKJuK3T3CP/47Xi7mhLDmcRtyWzGt4m9R+aN+3VuJbXFOfodfQlLCAYbl0Rtku1Mxo9TqDz1JaDhNX+WbZuiG8BiwUtJ2F12q7YAcgQJo7yQf6EEPNiV2bFAVHETgwgVETKAMLZu7EviQOmMcAzZwMS2RmqwmY8lss9gwj5WXcE1XkRgg/C6DzEEvYDRMZaIQHcAaywHafwmaoGuoIFqPaRZSwu/5wSSo7MbDB7Ypl6+TDmIG/iG84uxzjqi0dfrs0HSOa8o+/FDCcpHtitF8350S6NXv8RVh44zYE//0xiBmp5PNnG7wCFETmD/jtckt0zTb/IsDGuIvF9b7OX/6ETPkPi4tq2vuydMLkcNg4ZbkvnOdQMrbRZvcQ0YC3XOXbzztXW+sHBQ5lEVzvTYaX1rxI9Zm3mB1PvBs9SjvlsOevlbvrGPTtb9Y8CWGQb2xoCVmgYKvsq30sGCum08fNbMuC949vKJXF0/Tr6qJFaCuN+V1DLuztO+9zpaq6kJbZROwcDtDo8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199021)(7416002)(5660300002)(44832011)(2906002)(8676002)(66446008)(64756008)(4326008)(66946007)(66556008)(76116006)(66476007)(110136005)(54906003)(316002)(71200400001)(7696005)(478600001)(26005)(6506007)(52536014)(9686003)(55236004)(186003)(38070700005)(53546011)(8936002)(6636002)(41300700001)(55016003)(86362001)(83380400001)(38100700002)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0FrcGZEa3RCU2xTaisvVkRYeUhtc3ZJYVdjenhpVjg4Rkh5TXRUNDZRQW53?=
 =?utf-8?B?QmFLZk9IZ0IvMHQwMnordE5wb0NoOThqenlYdFZudkNNNFFZNzhROXlaKzRl?=
 =?utf-8?B?cU9iTmJSUTZPTUhzWDNhT3NxK1NlL3h3aDR1ZEdERWZiL3hTckIwRnRSK0NV?=
 =?utf-8?B?UXRmSFQwbm5iOUpuUWd6SkhjUWxxNUwwMnVza2QxNG9tRVJ2djVCenY1ZlJp?=
 =?utf-8?B?NVF3Y3ZpRElwS3VDR0hhWDZxckRCMGlqajg1QnoyYlhvcTZkUUlnMDJxcFJr?=
 =?utf-8?B?T3d1RmRzcU1rSjltMGR4UnVpcWxqTXd4V1BrK1hTaCtXUm1kSjc4N2lsenov?=
 =?utf-8?B?Z1R1U2p6Z200STlSbU8xOEw1VWJEaTYwdGtoSmhFeWMvR0VvQThZaEpOLzl2?=
 =?utf-8?B?U3R0T1NmaksyMVY4VGpoOFpNSUNtMW1FSnFZZ0lDbm43YXF6cGFLcnl3cGlU?=
 =?utf-8?B?QWZoU0FZOHN6QlJQdDZ4QWNBUnMySDJGMm5ha3hKOXJSai9HOHoyTktadnFy?=
 =?utf-8?B?Yi81YngvM2FTOVhPc3QzUmxhZjlIZUxGeUM4RXN0K2JQaHB1dUNQVzA0WjB6?=
 =?utf-8?B?RFdmUk4zVjFGT0R1MVA1THEzTFJmblBybzA4ZVJjVzNLeHhzQTdPbDhwQ3ZQ?=
 =?utf-8?B?c0dIVUt3dEhPYjNac3Rzd1F6amR2Unlwd0VQVGd2S0FjU0J2ak1aVEIrdVll?=
 =?utf-8?B?TytzZnd5TkcwVk9ML0pCMGorVjhydmczOU5DWUtsZHpEdzd2aWFaeDBja0tt?=
 =?utf-8?B?eFE0c0NTM2hIZDZhMjdwc2VUT1dFV2k2MUtxMVhYTk9mRWhxQ05pSmdVUTJk?=
 =?utf-8?B?WjErdkdtV3RlTFlDcG56ZXF1bmVrcUdicTFTbnFkdWY2cHkwcVllMmwwRVVq?=
 =?utf-8?B?anUwQnNrd3ljS09OaXBmWm02WDBxRHNmQVJPcVR3NHZMaDcxWitDLzZYREkr?=
 =?utf-8?B?VmQ1ZjBHNFpCbmw5b1B3WkFtRThKN3BTTmRIOHFYSFdpUUFnSm04UzVGdWxj?=
 =?utf-8?B?NnNXYVlaMFFGT2hTNkJJQ0RnaXZUZFBWMDluYnZSeVRuWHNqOWM3SWxCdkdi?=
 =?utf-8?B?Sndpa2xRTytxZ0NYUDZNeTlxakJrRzRrdkd2ZU9rN1hZeFc4ZmFsUGtGQUN4?=
 =?utf-8?B?eEVZbnk4Mmh0K2dEQ2Y0NFdyT2ZaOGNhNkJKUmxQN0oxTWw2UVowUHgvdEVX?=
 =?utf-8?B?V0ZBVG4zYmNWKzdNQlUyS3VDRU9IbVBYZENUNlhPZHMvMGd3UGFmZ0NoUE11?=
 =?utf-8?B?cHpRVnVHSVJEUndXY0lWUk5qR2FqOVA5Zk82VGE5RDMrRm43cUlkYVE5Q21S?=
 =?utf-8?B?bFVCd3pVQkpQdEVBeWxDZmQ3M1pwazJNR1haTVYxNTlZa21uUFVYWnNzemVQ?=
 =?utf-8?B?ZEFWZ25Xem9Bend3Z1RWU3VJM1lHQUZwMzZGRldCUWN1TnQ1MzVOdTZ0aEha?=
 =?utf-8?B?dkJhVmx0a2EvVmZhR2hzbmRhM2V6cXFwa1phRm1hSDNBcmdhQ1dOcHZzNTNZ?=
 =?utf-8?B?RkxkTExJK1JrTi9XTkdxYzZ6eEh6UkpGMDBqVTN5aGJWTjhNOVYrSkZPMVhh?=
 =?utf-8?B?VXovNllSSnZ4cU1SUEFJeFg3RnFnaE1pTmx1bStUOXd4c3pndklLRVcxRU1S?=
 =?utf-8?B?c1dNQ3RFbzN0ei9sWkI4d3lvR2YyK0FuL3lseEwrRjk0Sll6aDRoalpya3E3?=
 =?utf-8?B?ZVgxZDh3N05nQjNPditib29pWWhPQnltVEo5anprbUJwWkxOckNUcEJzd0Zn?=
 =?utf-8?B?VitoQVRvTlR1QVYrZVFpRGJCbjJvWEhBRzQxanA3YkV2WHNQVmRDeGs4UmtV?=
 =?utf-8?B?UnZSNWdxS2orT0hmanhvcjhvSDkzdWh6c0JDb3pZcU40bDhOcTArNVNlWEpF?=
 =?utf-8?B?OHNEYTlwTElJQlV3WFBkRUFnZEhGdXREVWJKMFhMTWRNbVh6a0NsTHhMS0FP?=
 =?utf-8?B?dGlYcXR5clpRRG4zeWo1d0xsMUhEZHFoaW9mYUVoTS9EU1Z4Ni96TEk1aGhG?=
 =?utf-8?B?dUlZU1pBU3o5Z1lXVnYwVnlvVFl2NXE3UHkvbG4vTUJTQXFGQVFwVjFYRFJN?=
 =?utf-8?B?R28xNzNYYjlUbW1tWHJKbHJMdTVFaUxwNmtWeXRTUE5adTJFNG9nellJb2xO?=
 =?utf-8?Q?ynCe90QvY61jbR7qNaRubieEH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff12126-81f5-4d6c-34a8-08db312ebe0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 14:55:02.9747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: motvR17gA9CALR4aYFIBnK22k48tkNLX7Dv8VDFvgN1L3M+HZsl1rY/otwsoeQhTvL1LbAEQRf2YD6bz6/gnjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6872
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hlbndlaSBXYW5nIDxz
aGVud2VpLndhbmdAbnhwLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWFyY2ggMjEsIDIwMjMgMjow
OSBQTQ0KPiBUbzogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBE
dW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IE1heGltZSBDb3F1
ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbT47DQo+IFNoYXduIEd1byA8c2hhd25ndW9A
a2VybmVsLm9yZz47IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IENjOiBHaXVz
ZXBwZSBDYXZhbGxhcm8gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+OyBBbGV4YW5kcmUgVG9yZ3Vl
DQo+IDxhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tPjsgSm9zZSBBYnJldSA8am9hYnJldUBz
eW5vcHN5cy5jb20+OyBTYXNjaGENCj4gSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+OyBQ
ZW5ndXRyb25peCBLZXJuZWwgVGVhbQ0KPiA8a2VybmVsQHBlbmd1dHJvbml4LmRlPjsgRmFiaW8g
RXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPjsgV29uZyBWZWUNCj4gS2hlZSA8dmVla2hlZUBh
cHBsZS5jb20+OyBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT47DQo+IE1vaGFtbWFk
IEF0aGFyaSBCaW4gSXNtYWlsIDxtb2hhbW1hZC5hdGhhcmkuaXNtYWlsQGludGVsLmNvbT47IEFu
ZHJleQ0KPiBLb25vdmFsb3YgPGFuZHJleS5rb25vdmFsb3ZAbGluYXJvLm9yZz47IFJldmFudGgg
S3VtYXIgVXBwYWxhDQo+IDxydXBwYWxhQG52aWRpYS5jb20+OyBUYW4gVGVlIE1pbiA8dGVlLm1p
bi50YW5AbGludXguaW50ZWwuY29tPjsgU2hlbndlaQ0KPiBXYW5nIDxzaGVud2VpLndhbmdAbnhw
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXN0bTMyQHN0LQ0KPiBtZC1tYWls
bWFuLnN0b3JtcmVwbHkuY29tOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7
DQo+IGlteEBsaXN0cy5saW51eC5kZXYNCj4gU3ViamVjdDogW1BBVENIIDEvMV0gbmV0OiBzdG1t
YWM6IGFkZCBzdXBwb3J0IGZvciBwbGF0Zm9ybSBzcGVjaWZpYyByZXNldA0KPiANCj4gVGhpcyBw
YXRjaCBhZGRzIHN1cHBvcnQgZm9yIHBsYXRmb3JtLXNwZWNpZmljIHJlc2V0IGxvZ2ljIGluIHRo
ZSBzdG1tYWMgZHJpdmVyLg0KPiBTb21lIFNvQ3MgcmVxdWlyZSBhIGRpZmZlcmVudCByZXNldCBt
ZWNoYW5pc20gdGhhbiB0aGUgc3RhbmRhcmQgZHdtYWMgSVANCj4gcmVzZXQuIFRvIHN1cHBvcnQg
dGhlc2UgcGxhdGZvcm1zLCBhIG5ldyBmdW5jdGlvbiBwb2ludGVyICdmaXhfc29jX3Jlc2V0JyBp
cw0KPiBhZGRlZCB0byB0aGUgcGxhdF9zdG1tYWNlbmV0X2RhdGEgc3RydWN0dXJlLg0KPiBUaGUg
c3RtbWFjX3Jlc2V0IG1hY3JvIGluIGh3aWYuaCBpcyBtb2RpZmllZCB0byBjYWxsIHRoZSAnZml4
X3NvY19yZXNldCcNCj4gZnVuY3Rpb24gaWYgaXQgZXhpc3RzLiBUaGlzIGVuYWJsZXMgdGhlIGRy
aXZlciB0byB1c2UgdGhlIHBsYXRmb3JtLXNwZWNpZmljIHJlc2V0DQo+IGxvZ2ljIHdoZW4gbmVj
ZXNzYXJ5Lg0KPiANCg0KQSBzb2Z0IHBpbmcuIPCfmIoNCg0KVGhhbmtzLA0KU2hlbndlaQ0KDQo+
IFNpZ25lZC1vZmYtYnk6IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvaHdpZi5oIHwgMTAgKysr
KysrKysrLQ0KPiAgaW5jbHVkZS9saW51eC9zdG1tYWMuaCAgICAgICAgICAgICAgICAgICAgIHwg
IDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
aHdpZi5oDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvaHdpZi5oDQo+
IGluZGV4IDE2YTc0MjE3MTVjYi4uZTI0Y2U4NzA2OTBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9od2lmLmgNCj4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvaHdpZi5oDQo+IEBAIC0yMTUsNyArMjE1LDE1IEBAIHN0
cnVjdCBzdG1tYWNfZG1hX29wcyB7ICB9Ow0KPiANCj4gICNkZWZpbmUgc3RtbWFjX3Jlc2V0KF9f
cHJpdiwgX19hcmdzLi4uKSBcDQo+IC0Jc3RtbWFjX2RvX2NhbGxiYWNrKF9fcHJpdiwgZG1hLCBy
ZXNldCwgX19hcmdzKQ0KPiArKHsgXA0KPiArCWludCBfX3Jlc3VsdCA9IC1FSU5WQUw7IFwNCj4g
KwlpZiAoKF9fcHJpdikgJiYgKF9fcHJpdiktPnBsYXQgJiYgKF9fcHJpdiktPnBsYXQtPmZpeF9z
b2NfcmVzZXQpIHsgXA0KPiArCQlfX3Jlc3VsdCA9IChfX3ByaXYpLT5wbGF0LT5maXhfc29jX3Jl
c2V0KChfX3ByaXYpLT5wbGF0LA0KPiAjI19fYXJncyk7IFwNCj4gKwl9IGVsc2UgeyBcDQo+ICsJ
CV9fcmVzdWx0ID0gc3RtbWFjX2RvX2NhbGxiYWNrKF9fcHJpdiwgZG1hLCByZXNldCwgX19hcmdz
KTsgXA0KPiArCX0gXA0KPiArCV9fcmVzdWx0OyBcDQo+ICt9KQ0KPiAgI2RlZmluZSBzdG1tYWNf
ZG1hX2luaXQoX19wcml2LCBfX2FyZ3MuLi4pIFwNCj4gIAlzdG1tYWNfZG9fdm9pZF9jYWxsYmFj
ayhfX3ByaXYsIGRtYSwgaW5pdCwgX19hcmdzKSAgI2RlZmluZQ0KPiBzdG1tYWNfaW5pdF9jaGFu
KF9fcHJpdiwgX19hcmdzLi4uKSBcIGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3N0bW1hYy5o
DQo+IGIvaW5jbHVkZS9saW51eC9zdG1tYWMuaCBpbmRleCBhMTUyNjc4YjgyYjcuLjkwNDQ0Nzdm
YWQ2MSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9zdG1tYWMuaA0KPiArKysgYi9pbmNs
dWRlL2xpbnV4L3N0bW1hYy5oDQo+IEBAIC0yMjMsNiArMjIzLDcgQEAgc3RydWN0IHBsYXRfc3Rt
bWFjZW5ldF9kYXRhIHsNCj4gIAlzdHJ1Y3Qgc3RtbWFjX3J4cV9jZmcgcnhfcXVldWVzX2NmZ1tN
VExfTUFYX1JYX1FVRVVFU107DQo+ICAJc3RydWN0IHN0bW1hY190eHFfY2ZnIHR4X3F1ZXVlc19j
ZmdbTVRMX01BWF9UWF9RVUVVRVNdOw0KPiAgCXZvaWQgKCpmaXhfbWFjX3NwZWVkKSh2b2lkICpw
cml2LCB1bnNpZ25lZCBpbnQgc3BlZWQpOw0KPiArCWludCAoKmZpeF9zb2NfcmVzZXQpKHZvaWQg
KnByaXYsIHZvaWQgX19pb21lbSAqaW9hZGRyKTsNCj4gIAlpbnQgKCpzZXJkZXNfcG93ZXJ1cCko
c3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIHZvaWQgKnByaXYpOw0KPiAgCXZvaWQgKCpzZXJkZXNf
cG93ZXJkb3duKShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgdm9pZCAqcHJpdik7DQo+ICAJdm9p
ZCAoKnNwZWVkX21vZGVfMjUwMCkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIHZvaWQgKnByaXYp
Ow0KPiAtLQ0KPiAyLjM0LjENCg0K
