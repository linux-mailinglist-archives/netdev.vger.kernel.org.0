Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E02F616ACC
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiKBRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiKBRaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:30:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020023.outbound.protection.outlook.com [40.93.198.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146842792A;
        Wed,  2 Nov 2022 10:30:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL4EilbDg7nKbYcijj6urMSEb+sS4YUiqfEO++1bhgAuOw5F5SsH0iHoGGemc2/y2KbiuW7RjFKrsI2Cyi+yOkK4Lb3Sq37hFzUWj8KAAadRQ5hB6IphOU8qQb8b7xqkERuB/86heFwVjLBQGAEbSSJ+ghpVNYxApLWMyB/MdMLjyhG+ZwqFF49T5v1HRWzr7mBzykcOPkggTO8Qp6II9NupanYr99Kf0oimJXZL5n3q7MWoK0Q14h61BUMH1vEv2OH27QXMG0eCaOxRWfOmDOHYwqItLX9kVvpkyGGcaj9+K7Ev9zfIGMEmmT82cf+BEf940N38710llfn+u207AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4tp2kqtaDncQNX7BEOkwokXjI18liTXMJO4UwulqAc=;
 b=EwEyyjQJlrfq/jbpumUgNnIKvkdijDZZJG9+YRcsGI/U48CRLIjoanZTMBkoReV7V2d9qeP/294itXaIQq82jchu8fbF5K91bhD4iDj9cjkZlI/KljAyPFRyhEoML5oHGhp/mns4J58p+8tmxfBHv+E3RfWIgdQwNW2hViJchW5otrlSIFw0G60iZ3XSZUbQ5IHjZdvMT7Qis30Iggiqu0Oav5yy+pYZDM2jy/mhRxwFtXWMrcIZMYy5JnZ/tt6YmOwL9qglGAqyzoeeiXgA76vlz4xyY2sVnidamRWkxViZrNwV5KUUaNWiasce3SMMlnEkxJkSsgzmiSsKiwcZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4tp2kqtaDncQNX7BEOkwokXjI18liTXMJO4UwulqAc=;
 b=OXmsWKKheSSDxzrqku2HB5CUa1RLrq/M+I+DGBV7YWMtTTQHigjsEFH2/H++rRt1aTqbkUV8NzX1xr+iR6bSi+tAoshne9uzsVruNkg3Wn2xw70i3NyeQhrl3lxvaev3Hg85oaPF3Evprcb/4PEVaYt1S7qUQWF/74dSiJ89o5U=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DS7PR21MB3342.namprd21.prod.outlook.com (2603:10b6:8:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.10; Wed, 2 Nov
 2022 17:30:26 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::600e:e49e:869e:4c2f]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::600e:e49e:869e:4c2f%6]) with mapi id 15.20.5813.005; Wed, 2 Nov 2022
 17:30:26 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Frederic Dalleau <frederic.dalleau@docker.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "arseny.krasnov@kaspersky.com" <arseny.krasnov@kaspersky.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Thread-Topic: [PATCH v2 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Thread-Index: AQHY7r9g0MIEG5jZSEmtohhEC/mZlq4r41VQ
Date:   Wed, 2 Nov 2022 17:30:26 +0000
Message-ID: <SA1PR21MB13356DBAC0EBA48518A53DC5BF399@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221101021706.26152-1-decui@microsoft.com>
 <20221101021706.26152-3-decui@microsoft.com>
 <20221102093137.2il5u7opfyddheis@sgarzare-redhat>
 <20221102094224.2n2p6cakjtd4n2yf@sgarzare-redhat>
 <CANWeT6gCfXbGVVySyiG9oQi9EXS2U5aEdN38z9qz1u91vCetyg@mail.gmail.com>
In-Reply-To: <CANWeT6gCfXbGVVySyiG9oQi9EXS2U5aEdN38z9qz1u91vCetyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c4c45b60-5175-47aa-baa4-96ae89ce242c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-02T17:27:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DS7PR21MB3342:EE_
x-ms-office365-filtering-correlation-id: ffb00eef-f5b4-4ac4-43b1-08dabcf7edf5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rZFYotMHJO58R+9zTMMfEuDoqdre97rHGp2KG7tw0eZC6In7PTBmTCdjAjyoG0+N3Cf6v94GB/J/e4o8fdMe6SmZJduuote++7ULyNlDZ3/J3uCE7f4K3YGtYxkMRyfBilJd4OxoWLiJWrFQcDmSrXRhkCrcK9UNXPMfS8mTPzt0bccLUM3RztSHAUL2V057e6lEa4l8aQ5rH/b3NTYJyY0IdVoM8v35ZRQP9Y9VYLouKFZsF58w/aRk24HnYXT09khzv30KnAuOx2dceKnGVRLgSQqHVUO/rhkEMatc0yXBMN1fELQZ6bYyFmPvpdbcfsQhS9nD++n23M0vxhPYEiXPIoWmPAfFya/lEuUS8fkmSAM3L7sl6u0J4GLr4CnNaD+Lcd7tL5I33L+BkAh/VrNpVd9BRxm4LsCuiYWNt/QeL5rLVk3lAh7uSS/qnwWSmnE/ojqjriEgmlAqEsC5EkctxpX7gyk9nphJgiEi7dWBOCWkw4Tgx9MdRPFEo4xaRRJFMXXHLzJbTLpK/lbGhKCzFC9x6qWbPC0b97ZkkQ5jLKUUZJKPzgZfg2jrgwMOB6pdQ/Muy5cLI9CXZNrI4mKqL8xzLZK4ZFoXPKtJRUT6nBeeQi/bjOQ71sJKE5/Wgiil79f4GS6ZCeVyIbC6PpE18GoQZlp9wuDqo56p2V+2dNRtnJDOY3HLLpNzlT9DDkoPIpCnqt3GivChE95SlHHbkopysyEklybBDNJOJUiw45UUHlP60TsmUEMwN27QQblvlohwcItOnY8aArh2Lvn9Eo9v0wA4rQGz/dLSljRIRS8droktzkYZ9CnCuPSA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199015)(26005)(82960400001)(82950400001)(7416002)(2906002)(4326008)(8936002)(122000001)(316002)(38070700005)(33656002)(5660300002)(558084003)(86362001)(9686003)(64756008)(55016003)(54906003)(66946007)(53546011)(6506007)(8676002)(52536014)(186003)(10290500003)(71200400001)(76116006)(7696005)(478600001)(38100700002)(66476007)(66446008)(8990500004)(41300700001)(66556008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?84qwRAwJhXg05ZUkha+vrm9ZYIdfMhzuvphcdp8L5SiWkWUDg/2nociVOv?=
 =?iso-8859-1?Q?jReCnjoF9646Kt5xEip3XeeNMTDgImdWAb2ck8Cep+9CgeE2AxNmmzR55y?=
 =?iso-8859-1?Q?bYtKiOEy2vAR5hF/UQGu9eVu9TmIhKdUr6rzbkfqBTQKh9imjENDUA6isl?=
 =?iso-8859-1?Q?SebWDtW7eOPzsjdw6ukvy2PrUqTV3V4/glCXVcpMSJH2ZC74i9C/4tlA26?=
 =?iso-8859-1?Q?VkJ6dPPtSuxD0lOua0cNE8NnL4qi/5pq++jlBLfsiedCTyscZOCxx7lyvF?=
 =?iso-8859-1?Q?C8/PoV0yZ4XOZC9Kp/clL+j9FRyQVqA2svrBVqHCdwkYiLtTtaAXY3KK4H?=
 =?iso-8859-1?Q?JbrGWdFoG//mQs93bE23O2nfwxnf4ste+uS2bvQQp/vQxebhAXp9cspAg/?=
 =?iso-8859-1?Q?++K/8aT200zQSxb0h7fzjOVamcXCLUPuT4FKC64di/9p9yQKYT8niQwCQ8?=
 =?iso-8859-1?Q?I6bR2fy8OVDIqw6DJTT31afrt72m1dbb00cbK3l0qplXGqwjg0/H7jdsPw?=
 =?iso-8859-1?Q?m7ZsSF6oJgGmGX8ovnLXhC5tC59l0IC/liAdIOTNIDGMWcb8K/wtPYQasF?=
 =?iso-8859-1?Q?PW5Md3yWrSbUp3xDZM7vAQc38X2+pzj9P4ZGCFIdy8tfztQGjkpgQ49ORW?=
 =?iso-8859-1?Q?07FAgNzLQcONjnefvnjFuq2LTI6fWeBP+xsrlEhzmTTmGNtOHqPZWdSUNl?=
 =?iso-8859-1?Q?KZ5OReGIOiiLE3ho/qHaVH7nfDjzBhYq8uZJRq7APz1U0zByHPFVisuBL8?=
 =?iso-8859-1?Q?r3H0vtMfF6xHAlDtLVI66Fd7NHdlfCoFBcNgdTH5OGZsyyw1spvYBGnqGs?=
 =?iso-8859-1?Q?GFS0EX7k6Z5NtDTu8d8yQRuZGtKL3Ix6amLY62DPAG7OXGNhTmOMSS6+g2?=
 =?iso-8859-1?Q?A/4Uu0+sUo5oejWhNMCbmV3j2IEL7zapiFdPhEYts4ZDFCLi4AzAmmzkWX?=
 =?iso-8859-1?Q?t7E0gHnVGT0CorV5X8vf4YppRHS1IxKBm2YeH76x33gSjgKVOJb41i/K9Y?=
 =?iso-8859-1?Q?7qY9lHkFJCcYVR9PjpmB9vTWzjD2xdSSrovvtR4QXVh7y3Fup7wrqPmoma?=
 =?iso-8859-1?Q?1/oSTpiw9dE5aLBDD1eIBydO76dOzao/cwSAg8r3/KiSUdDmz/CcydtxQQ?=
 =?iso-8859-1?Q?XRM3kxlND431bHao8VMw2n616c82+ihQ3UTXvn8Br3yzYhNSEqm5JDMI38?=
 =?iso-8859-1?Q?hWyBrXcPVso2WXFreVlyHjYK0lkgvSmdoQJqh1ttuxdPuhQacCUFvdhyHx?=
 =?iso-8859-1?Q?7EPBYGkDFiNis3JMxAhKBVZiFrV8egNcxnzUFrGYATbyUYBAitNOG5bGaR?=
 =?iso-8859-1?Q?mymynzMvVauJZg7l5nUkr4D5eEgrlfjN+qves+DK5MRX1aO2kYvQqdZkoE?=
 =?iso-8859-1?Q?kT8cEqdbvC32z4eK9egOzlLy3QLKeEEtTf8icR/tpArDTc4LgAoWsrSH/3?=
 =?iso-8859-1?Q?r+DtD5cPVBCQPuRPUslQV1tcIU6DjStCCmhk7faYKJjrFOMSMtop5Y5f5r?=
 =?iso-8859-1?Q?Xt0zeDBCRL0Vn48jubS+rIfrltxjZc/zWzTT3UUxW/D5PJEFrmajKIQaml?=
 =?iso-8859-1?Q?A+Q71GXv7f+VIl1zUJYi9NdjEuDv/3WIVg8PYP4T1PNIB5BdHituzlokFq?=
 =?iso-8859-1?Q?Z1AnvpLFIo0G8CuoHyJOxJV9kq1Xr2j0Bc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb00eef-f5b4-4ac4-43b1-08dabcf7edf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 17:30:26.1095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cta5sV7tx5/KmSNRiSlAILCZevzZuyPmeIRrAUhje4MR3K3s+cY40cQGCcc/hU7+LGKRw+KHCTlwmJvWopLgQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Frederic Dalleau <frederic.dalleau@docker.com>
> Sent: Wednesday, November 2, 2022 6:31 AM
> To: Stefano Garzarella <sgarzare@redhat.com>
> ...
> Hi Dexuan, Stefano,
>=20
> Tested-by: Fr=E9d=E9ric Dalleau <frederic.dalleau@docker.com>
>=20
> Regards,
> Fr=E9d=E9ric

Thank you, Frederic! I didn't realize you posted a similar patch in Aug :-)

Thanks Stefano for reviewing!

Thanks,
-- Dexuan
