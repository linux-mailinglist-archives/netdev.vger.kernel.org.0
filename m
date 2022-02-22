Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0973B4BF5D5
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiBVKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiBVKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:30:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2130.outbound.protection.outlook.com [40.107.243.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B64915AF05;
        Tue, 22 Feb 2022 02:30:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9V5JEwBS6orCPfLM2vWSBvFuv1AtXx9JKUSqeGJ1c3Z4mYPUilkZlHE6lXyN75bAWwIp5lnlgDjvUxq3ZlyNTsTxYiUbdmRhnvM0zh58L/XyS6ba5G5NKdv5u4s/ewVnCrIbDqFRTLijWoUqJVId8xy0SHNF2yHu3k7wFDLf01WKk/0K9+J7HiFMlid0GSpMqhmfnUT0g3gkwdxdlgHuUPjFMHtci/iPcMfjc/Grd4FBRYmvTiDj6FayjOl6fZWwevvC+PN3BQXYmdp7HOIQ+vFB1rI1hi/VnxXTTXx9LFzXnh9+RZqr+tqCqUI6ZJQO9EmkaA4F0pPDnU3QiSt4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yjEFHzmDrFOaOA7eQ7BfWh5y3JPOrHwy+4Kee2NdV8=;
 b=SMdv5ZetU9ZMnLaBqYyTDsQAuC5fE8aEmrTkjeTEVaUPqcl7bIU+zfYzrCkI5+Wi8+ePWDqVDi+yCGuhoeOWqv1X+89cm1+00qJuj3dW2eArDiiQ8cPtQR3aQ01lC7hxZLbMsMGtX8rwgkDU9821z3b841HuzpL+68N3UxrPGB47dqHaC4Xi0SBBx1pG3LodlxZmhtSv7ggC2rWHM6AFKqZLs5mdJC7c9yUzh7MhayoJxFS9bzOficxoUyA0Szn1AM2xsz1Ed5epJ0/XUoxyXp3/Wg79FrCZ4lscdAq8E1QhOSMNqlUqA3zxyhIbbcTFzCWHRr9jVaD6/l+pty9fcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yjEFHzmDrFOaOA7eQ7BfWh5y3JPOrHwy+4Kee2NdV8=;
 b=Qb1gVXXlIsJoZsOfnS2DAdM1sL3g5bUtO0DRymiHzaJV2nHQDX2WokAL9bYN3sXZO+TGMoQHVEJg1SBEp8qWTx73pgIs9Dwuw+1MAF97rrM1lBqA6hZaJBXfNiUTrQEz0UFAsF8/aTOH1HOhrnFuFTJ4yQ68FDNQxO5UySE/qeE=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by CH2PR13MB3446.namprd13.prod.outlook.com (2603:10b6:610:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.19; Tue, 22 Feb
 2022 10:29:57 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.021; Tue, 22 Feb 2022
 10:29:57 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianbo Liu <jianbol@nvidia.com>
CC:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        oss-drivers <oss-drivers@corigine.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        Nole Zhang <peng.zhang@corigine.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        Roi Dayan <roid@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Topic: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Index: AQHYI9hpcCPN+jYdekO+59cxkSVtEKyXsfCAgAclt4CAAIk3AIAABDgQ
Date:   Tue, 22 Feb 2022 10:29:57 +0000
Message-ID: <DM5PR1301MB21724BB2B0FF7C7A57BD1631E73B9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-3-jianbol@nvidia.com>
 <20220217124935.p7pbgv2cfmhpshxv@skbuf>
 <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
 <20220222100929.gj2my4maclyrwz35@skbuf>
In-Reply-To: <20220222100929.gj2my4maclyrwz35@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7297c0f4-ed21-404c-5db4-08d9f5ee4627
x-ms-traffictypediagnostic: CH2PR13MB3446:EE_
x-microsoft-antispam-prvs: <CH2PR13MB3446205AFE4A288159A64CA8E73B9@CH2PR13MB3446.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VWhvGd9mTVGOqNy+nNz9aJwXz61rLfi7FnjjLJLN9vlx232RoulAq5leVhYwyS9u9T24Y6YgGHBSBVuvFc205DeQ6ddCNK+Bu6XQwbsVYN3aMqPS6wF1fcM30DKmxgzi4wlf2DvP90AQpifx8+DqXNR64x6OZvXjstY9iYN4gb/kKU5WTRHpPhtJMz587gvr/ViqOrRp7CWaXrCo87xmBLTVu4eZJBsQnLTBsbIpLKdXYGmx8C61WAOoANb1omoL8/dLaMm8lXCno8jX2UokIhIq3OPzhbAERNuwTFR746XOsw5nBMndMu+hLvn6U6I//cwI/EyxvK0ZyaN/6eafzjV1+dpf5sR+q+l++sxWocbVc+rHwNcGtUubzGLFKxMNWFpz3zLqkNlBsDV89hk+3HuOuAlG3Wds/WuRMx6kI6Fu9E+arVXih9AtLxdqZVUpsAnf7UmOb4GiaAtEos2Enhs0YzBNsqMOPpzxT673PTJwV0vHV41crUkdbPYg1sJFzZjZmCpFd8WLgETM2lN+EpYeicsUwJJJ5RT+WG08oLIETfDS5rrWp/n+mdyIrVgO3QGEIZoso3R1XIfOZsK+GtWx2kmcapS/illlYVDN1AOxy12WNtvvG4mL7FK3qcyb2qGY7ioYvf33hJjorlzNuQKH4F54SdgvGiKX+x0F5EVNokf3J7hkT3ujQM1gBQ0fKwv/3z+rdRQ+JqSSi/53rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39830400003)(346002)(376002)(396003)(136003)(64756008)(71200400001)(122000001)(38070700005)(53546011)(55016003)(86362001)(8676002)(4326008)(83380400001)(76116006)(33656002)(2906002)(6506007)(44832011)(7696005)(52536014)(110136005)(9686003)(5660300002)(26005)(66476007)(38100700002)(508600001)(66556008)(186003)(316002)(66446008)(66946007)(8936002)(4744005)(7416002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1FBMGRTMmVmQWZUeDhsUkJFSE9iTGdEMFhpU0wrVFJNYmNaUTVZQkNTaldU?=
 =?utf-8?B?K3N3OE0zVDJIRXEwcnZsNWJkWGk0MWY2Mkh2WTVWSURkaTZhdWhHUEJpdW9a?=
 =?utf-8?B?S1RnOUNtYU9nMVdXWWttdHJVMm4xdC8weVhLeE84aXFLdmFuZHlDbUliTTM3?=
 =?utf-8?B?eVhBalgwSnl2Z3JpYStjdVRMZEdDNnhJV3Vhc0NySi9uYjdOQ08xQnl5U0hO?=
 =?utf-8?B?YzZSa1UrSEhoWUN5RmFzNk1iRExJeTJacTRGRVl0VlgzUzVtZnpPUU1kZEwz?=
 =?utf-8?B?NThhYlhWS3dtMGJ4S3ArbkxwRWlwNG8ySFRlYXIxZmY3QzRkdkVuUklLd1Y5?=
 =?utf-8?B?cEI4V0FmbnlST3pyZVZLVkVWcS93ZmQ1RUhsWE9pa09JRklNVmVUYTZvMURy?=
 =?utf-8?B?Zm9yYmZqc0U1T1lwbWhPNFlOVXhRVVE5WEtVZHBvRkE3eG15OTl2aXo0OXE0?=
 =?utf-8?B?VGhwMW9aVjNnRTE4QzZPSkp5a1lRblZXRHBGdm5LVTBOUWErZjcvamUxR1JM?=
 =?utf-8?B?dTlLdTFtTE1DbTl0aFhSaTBMdEZNS2VEbE5RVkxCZVpQeVc0ZG56VDJsd2l3?=
 =?utf-8?B?Q0cyNm43LzVQUXVMQmI2dWNxUmpyaTVUdHNGVHEzeU5lODhRSGtyT3YzM0hC?=
 =?utf-8?B?ZkUyYnFIL3FFM0JxYlhLSkJ6b0toeXJ0MmZDb2VTWHhaSFl6UDR2YytUMVRv?=
 =?utf-8?B?MXFvRkdUR2JuUk9nNzl3Tk1sNmRoRDBsNFZOTVpZVFRWSkw5RmZqN0swZ3Mw?=
 =?utf-8?B?bW5CNW40Vloxb3NXdlN3R3B6cmFPZUROWXJ4Yk9WeWNNU0lWV3M5QXFrc0RD?=
 =?utf-8?B?TDdrTWpwT3NOem1Bdm1kQjJscXpjWFJFVGdpZWFBNVlsTVRnaEhQVHYrZG90?=
 =?utf-8?B?M2RsSzduZ3FPcjd3QUI1bDJVN2dUT0wwQ3Y4NXg5OXYydWc4NTZRUmdJVE5E?=
 =?utf-8?B?UHowcGFSQVpBVXN0Ykl1YW9NVkZnMnlrNWoxS0ErQ002R1ZQMXI3elNhVkgr?=
 =?utf-8?B?cjNQOHlYSjk1d1J3bW5qUmtyQmpOYitIdzFXQ3pDMU1aZXNiZ1Q4cU1UMDBv?=
 =?utf-8?B?akpJQnlQUzFVTVRQMUk4Z0pqQ0xhSm0xVjVNeUkzOEY4Ly9aNUc4NHRPUGF0?=
 =?utf-8?B?ckVmdml1UDlDeTNiSFFDa1JCeXE1WkRPeEFyV1pyMmFoN005d2lXQXVVeG1w?=
 =?utf-8?B?MGQ4dncxQnFIRkhxeFdweURWQVZJQW5McUNob09aM2JZZTV4WGEvbHRVRlZH?=
 =?utf-8?B?Q05EWi9wSFhsaURSTUk0elRuY3FPQ2F3UzZCM1hlc0hpMUMzMEU5Q1JIcmth?=
 =?utf-8?B?aE5rWGxKa01XNE5IdlVFRENNTGRwbEo2anZualh6NFhDbEhsY01aSTlwZ3dD?=
 =?utf-8?B?M1Z3NDRxUzJiK1JIREg5bHJTR3FtTUgvZ0FoOUNoZTFlZFFEVndkMGFTN1dI?=
 =?utf-8?B?Y2ljMXhISU9PN0pwUFNHdFBJajlYVHlhN0JLYlB6Vzh0OXJvRk1MMGRHTjNs?=
 =?utf-8?B?VVdtN2dOYzAvbC8rVXdibnNpRnJqZkd1dDFITVlhM1UvKzNxUElRdEJFYUg2?=
 =?utf-8?B?TlVSSGVlY1J3NjBrL1NLajF6TE8xVW5tN1BEbzBqNmZlOVVoOUdxY0d2ZTFm?=
 =?utf-8?B?c2tCMERlaGl6Q1JuT0EwRU56RXVFT29MOFV0VFhvMU8zUzZGb3Q5SzVCM1pE?=
 =?utf-8?B?d0V2dlVUbHBFUkxxTjhLSUs1aDZjQmJlSkRJRVVFZFdMbVRIM01IZWRWK0Za?=
 =?utf-8?B?R0UvUStYT1ozaFZpNHlqWUY0amh6bFcvZU1wTk1SeHBuak1GbzZaSHdUK0s2?=
 =?utf-8?B?Ym91YW90MGJ2ZHJNYXI2eXFIS1lxTGpjc01wbzhPQlRyMTNZZ0Vmc3lkeUxJ?=
 =?utf-8?B?enl6MDFpbm4xQzY4U21tTVRxWUEyNTcxbGhXaW44NlBaZVJQT3hoTzdYZWtC?=
 =?utf-8?B?OU1sOWRIUDJVMk5ETk9BbjRSNHBjNGlNbkZRdXhRN0p3NDcrV3F6VU9xaWpt?=
 =?utf-8?B?by9IQ3FpOGdWcGQwcWt3Si9lYkRjYXp5ZGlTRGhPRnBaTVdVa3ovYVJUMmVi?=
 =?utf-8?B?QW45SnBPaWJaYThBMWl2OWlnWFlSTFcyL2xxek1nUWJwTmZOcEVxVTI0MFlj?=
 =?utf-8?B?M0ZNaktCd3EvMSs5VXBHU2ZYM1hMbHRPMGpSK1I0UEtjdVNtRDBmSXJBWU1O?=
 =?utf-8?B?Nm9EUmV2UTdwZWcxcitkOWd5VWFzcmtuUzJPLzZjYm5mbllqWlUwYjFhTlM4?=
 =?utf-8?B?UkRycklHQ2pxWW9yem0ybktERXh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7297c0f4-ed21-404c-5db4-08d9f5ee4627
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 10:29:57.7017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK79RsMFjY7wwiQTX+mjvsi53zjSWPmRNCt+CMN9Xejj2J+F9iINXyJQvfEGfYqBhWQToTpWCs62VEWuLpbUobQ+smCMlRwiEsHeQkoPYyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3446
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2luY2UgYWxtb3N0IGFsbCB0aGUgZHJpdmVycyB0aGF0IHN1cHBvcnQgdG8gb2ZmbG9hZCBwb2xp
Y2UgYWN0aW9uIG1ha2UgdGhlIHNpbWlsYXIgdmFsaWRhdGlvbiwgaWYgaXQgbWFrZSBzZW5zZSB0
byBhZGQgdGhlIHZhbGlkYXRpb24gaW4gdGhlIGZpbGUgb2YgZmxvd19vZmZsb2FkLmggb3IgZmxv
d19vZmZsb2FkLmM/DQpUaGVuIHRoZSBvdGhlciBkcml2ZXJzIGRvIG5vdCBuZWVkIHRvIG1ha2Ug
dGhlIHNpbWlsYXIgdmFsaWRhdGlvbi4NCldEWVQ/DQoNCk9uIFR1ZXNkYXksIEZlYnJ1YXJ5IDIy
LCAyMDIyIDY6MTAgUE0sIFZsYWRpbWlyIHdyb3RlOg0KPk9uIFR1ZSwgRmViIDIyLCAyMDIyIGF0
IDAxOjU4OjIzQU0gKzAwMDAsIEppYW5ibyBMaXUgd3JvdGU6DQo+PiBIaSBWbGFkaW1pciwNCj4+
DQo+PiBJJ2QgbG92ZSB0byBoZWFyIHlvdXIgc3VnZ2VzdGlvbiByZWdhcmRpbmcgd2hlcmUgdGhp
cyB2YWxpZGF0ZQ0KPj4gZnVuY3Rpb24gdG8gYmUgcGxhY2VkIGZvciBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tc2NjLCBhcyBpdCB3aWxsIGJlDQo+PiB1c2VkIGJ5IGJvdGggb2NlbG90X25ldC5jIGFu
ZCBvY2Vsb3RfZmxvd2VyLmMuDQo+Pg0KPj4gVGhhbmtzIQ0KPj4gSmlhbmJvDQo+DQo+VHJ5IHRo
ZSBhdHRhY2hlZCBwYXRjaCBvbiB0b3Agb2YgeW91cnMuDQo=
