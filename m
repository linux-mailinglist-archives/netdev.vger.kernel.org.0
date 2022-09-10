Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5295B45D2
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 11:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIJJzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIJJz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 05:55:29 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11011008.outbound.protection.outlook.com [52.101.52.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D2840BF4;
        Sat, 10 Sep 2022 02:55:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2WxL7BLV0Kl18Q1e1qUBI/RAFdVirMw8hjNcxYuG6Bb6AGrgcwmuWEb1SqATrTE00It6mNIVakKnEWrqV6IFF0eyga9bWGa2zSkDA/Sudlf0bLpzDuxobT1S6zBpxg+dt7NgwfSgJuHi2H7auGIIgsfbw3CUXgLMErRX9mdia9pwgqcwdmlcszK4GcA6gVQSeUVGpJ1UNs/1ApwTjAm42eLe4dLMBwr3nJO8VeqqURk30NykcYT8AaxJCnLf3yAPBLXTtsE31PeCo1sdUp/Xj+Ac2uESriNN5TNqSaXcOu2Dq2AE1k9HgX3aok4rYfrmxJBs1xWdySOLttEFAlhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24h6pvzYjW51k6ss0wUHXCRepe0RJK9h7UmzunIDM1Q=;
 b=NMU0e8wTk9pfBQXWxSWYkyZ+rc149s68SqnD9zzI9GrHv9xbFJ49fPchTB6PlN7v7jZD24ZPvnTg3WTLLoe9aqtqJcGLkiYLO3T/gBAupxp2LATzkMIyLYnH4gQfZvL0ssGXPBssI2XTxWXeIsjx157mFMv6vFxpIsh/u0NX9PX9cmOgLYCnKWPVWBV5hv1xA8SQsOW8BxHIMXsFfebJF2+4+ZvSXZnlKglhwF0aP+8aPjexKb12qLHuCvb1/iLkPTcS+Sat6AQi/TePQ5frAtxlNzj2JJz3W9UV5prYPT+WRpUEVED5334qNWDGvlzksz6fWdaDRwFHrRG62kInfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24h6pvzYjW51k6ss0wUHXCRepe0RJK9h7UmzunIDM1Q=;
 b=RLBU+NZwGGuSzRpBJ+9T+a9kMyaeLjPtygLsUx4TXF/C9xUoKxZSD8q2jdk92wzKRLnqQQjvMmRV4xZ3HMajg2y6sJnV4Y1ARqa43cVFsU/qrHg2gkYhTH5SzUDg4E9TSLXy/8RYgQrOVmMrbRqGsLNhFFRcMWG8nmGTIk792lU=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by SJ0PR05MB7309.namprd05.prod.outlook.com (2603:10b6:a03:280::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.10; Sat, 10 Sep
 2022 09:55:23 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::a8ee:57cf:b2f1:b818]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::a8ee:57cf:b2f1:b818%5]) with mapi id 15.20.5612.011; Sat, 10 Sep 2022
 09:55:23 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Vishal Bhakta <vbhakta@vmware.com>, Nadav Amit <namit@vmware.com>,
        Bryan Tan <bryantan@vmware.com>, Zack Rusin <zackr@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Thread-Topic: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Thread-Index: AQHYwhYOzlGIFKqdX0CelUpsMdVRYa3TmSUAgATZj4A=
Date:   Sat, 10 Sep 2022 09:55:23 +0000
Message-ID: <C54E9A92-9D7E-4761-AF9D-2EC3A3C5508B@vmware.com>
References: <20220906172722.19862-1-vdasa@vmware.com>
 <20220907075138.ph3bbitnev72rei3@sgarzare-redhat>
In-Reply-To: <20220907075138.ph3bbitnev72rei3@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB3960:EE_|SJ0PR05MB7309:EE_
x-ms-office365-filtering-correlation-id: 4cff414a-a5f7-4f53-18ab-08da9312946e
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQhPkB4skCjWZrmFay3bKEulEO9EZFtpQ1YvMeeyqYnlo2dHprMwdZ3k4qynFKADaJw8CKkw9luBrRHq+m5HLcjcGnryMJJYS+T6S2Nm4xQcpyscjghO2PIBlmbFlSSLzLsVjXloG9BF+jj10JTkGY+mOh4Lox08JdQMNPPH+1meZoPlAU/LgN1kfgs3nAZCsqjHFDGLGjsqLeE5y27IKoywW11ZVJ62Zzk+fbgbcoWEGTG4NlcwsSeyhMZoxiNtluC9ZSweWTrJjlxIBUCaXWEFD6rt9dtBsFaeMLAFFwF4c0wWEdaMdd2uFlkoh2gTyWILcj3d+sP9hWkomre896qnn2ZoV13iz5Ulu6Vv0z7Wxpvssp4n7Z4ga/BHvv4YfPl4QXTkdu1nEWjIVMBWmggp6QKSvw6Piq7AFZSUAYs5N5a+ayJLyGzBP3MPUp2IgVFG4A+aFhInX1W/MPjbAbh9ZL7R4Rn1S6gvLcouUX32slxqGLVvEAgVLkKFYqjv+rxhYU2rjcJP+YeqFExos0YogcD3NNeoMw3iXkez/XuMfa4ZUCD+psgCXdCpzN+wKdydsA1ZeHb94VVqxbBAZSUYubKAStNjW3D0YRp7YqoXe+u3NxEEGJifoOJnQIOnlmohIKP6rSS521ypV5IMdx/JjVnoH7G/7qCHFZ5fyRufnYJR7LjFLxs9kX+Pm9ABTQ/W9Si2uwYvNq50KMO2bBmTIS8eKX1xTa8k0F/0E40D0MeQ8sVQ0we6nHeQvfkzOdJTT+4JO+wKig2Hd1wTdi9Zg3XDOVhX0NpAODrUL30=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(26005)(7416002)(6512007)(38100700002)(86362001)(76116006)(5660300002)(91956017)(4744005)(4326008)(8676002)(66946007)(66556008)(66476007)(66446008)(64756008)(38070700005)(2616005)(71200400001)(6506007)(6916009)(316002)(6486002)(36756003)(54906003)(8936002)(2906002)(186003)(478600001)(33656002)(53546011)(83380400001)(41300700001)(122000001)(15650500001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HtCyOLkCFvmgoQbHydftg72rzoctgDZm+JfEI7IoKL7aIUUPbR/qb6Q7lFR7?=
 =?us-ascii?Q?yhw1+QZHbMiSi2zTkiJKfTGE555HbcHP9r6XrIy2UPueDKn5kbO7knqJRO1l?=
 =?us-ascii?Q?4+jC9vN4jkTZaHS9GLI10ZFhLKNbTbdI5HH1Guxm7+mcYRnUsqB8LfFaz7w9?=
 =?us-ascii?Q?RNaN+E4HqLOTg36c4DowQESkV1Q8WQkND1Jawi5UdptMzFJ0Pm1WWJDtV4RI?=
 =?us-ascii?Q?lwh4IT07tBrhWSsbnRJUnS4ff2e97uNr8ATHkyIF2SsGYQ73MP4bup0m3C6r?=
 =?us-ascii?Q?B3uAWLGw5ChlB+deNGIcJ8pvpZXWDOKNWrSU/4Ud/M0Xa2K4qHn9ZH0Y/1fi?=
 =?us-ascii?Q?qtSmcbSccJTNLl6wckbpxvz11c/UM2jepe6G/CmPuYpmWh9WAtQ96apzr3Mt?=
 =?us-ascii?Q?f4/TJ/FCDLj8MNxI+IKx4ALsklwqzC40Tso5fp0oinprr0neQXSS6NZp3J0C?=
 =?us-ascii?Q?epyEtO9qJ8O/28jWuNfVjopuiRH8TVg6eCaYt5n+niqaHFtEOjFpDrpdwzH5?=
 =?us-ascii?Q?oxqaO624BJraC/BH4HepohIC2U5NuoJeJg/cBbc4iqvg519q+inUtEYybI//?=
 =?us-ascii?Q?3dlKBxXyLZm+B2f1DitKEwQyBdJxzHXVhLPbNso8bvtc5a8YoPUJM0mpkkql?=
 =?us-ascii?Q?E+VGWxJP5YAK/UlBa5G+5o5GzX8IvTXFFFIQhHwPEcOPXdMEz2U7dIbvFr37?=
 =?us-ascii?Q?x1vRkbPWKR2rOrA9Dg8MiL+vmre9HYToOOJ9RGR75cGf2m6oCEYEyD/4AVkK?=
 =?us-ascii?Q?cDpZcCO0+7EVxS+XfKMFYaXEYMLP6e0Z9gQvVTMEG2SH+mw0c6IGZktrkssD?=
 =?us-ascii?Q?cxVZ1gJucmph+fHmzxqZL3lfkbFDxefmE5Hm72N1/rtvCQMFV8kPcW3hDiAo?=
 =?us-ascii?Q?tBuqhbjln7qzNcLJQUgKCytQ6VuMVh6dHDsXZDFTB+0na+xetqeaWVhKdyLz?=
 =?us-ascii?Q?dOdEGaOemA/3qaAnwRt7Y4gVxX37FFLPcrxFk/iwvkHy5cCydlqmsBCcnKjC?=
 =?us-ascii?Q?jop5aBhYGtsC1xPiLkLebZqj61LqXSh9XGAweGYRCH528D4SsJyTsAWam0qm?=
 =?us-ascii?Q?OanwC66QAuDuE+xoezVHJcpihBONHcBvyOVi0+4hhxGRLJsVrulNusM5Ca4Y?=
 =?us-ascii?Q?qc9gBG3NLwi2li5hCaUH45MzvKCmAClPJzrANfb8sRQPb323pSTTDvi6EvAL?=
 =?us-ascii?Q?pj/f+Z/T7S40Dy7E4fkzoP3yQRJpQlHMxrEn9cXWkUgwP35bw3097hq+s9J5?=
 =?us-ascii?Q?8gTDj7Bgsd0IrytNvm56itVe9wPYIVvn+RI86G4igIVEb75rOUH5NwfetsQz?=
 =?us-ascii?Q?cyEQxWTBVxEBnriLmnskTPhKVitnE8K2sgcfDdFh2rtXBzYtCz6ACqiKbnsT?=
 =?us-ascii?Q?j+75LIOynmPnhWQ/GfP3LiI9C+0t7d2pUEBV5NI4SXvwTAPZ2VQtY3hOBd10?=
 =?us-ascii?Q?a0qR8SNXgBgeZZZq7349UP2dexTn3EudP3hGKX2bU8zXv0+t3pvqihDI4svc?=
 =?us-ascii?Q?CAtY+XINcpJ07mpIusxyN+AprMGObNgStc7Om2Z839dqReWrSOFjqCP9qkZW?=
 =?us-ascii?Q?yjRlKegNh4CA/+Bo8Sf92LynSiRjVub6wvlGvsPA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B310AC17E83B641AAFBCC9B0F6F2A79@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Sep 7, 2022, at 12:51 AM, Stefano Garzarella <sgarzare@redhat.com> wro=
te:
>=20
> On Tue, Sep 06, 2022 at 10:27:19AM -0700, vdasa@vmware.com wrote:
>> From: Vishnu Dasa <vdasa@vmware.com>
>>=20
>> This series updates a few existing maintainer entries for VMware
>> supported drivers and adds a new entry for vsock vmci transport
>> driver.
>>=20
>=20
> Since you are updating MAINTAINERS, what about adding "include/linux/vmw_=
vmci*" under "VMWARE VMCI DRIVER"?

I'll send a separate patch for this.  Thanks!!

> Thanks,
> Stefano
