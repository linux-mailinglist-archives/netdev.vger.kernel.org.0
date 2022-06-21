Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14642553E2F
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 23:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354466AbiFUVwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243597AbiFUVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 17:52:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2137.outbound.protection.outlook.com [40.107.243.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C0C1EAE7;
        Tue, 21 Jun 2022 14:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoGfpTuErRq0AmoVNVbnTlG7d2LK4EAvQ8pMoKXRyqCb3IcwijCK+8y1pKCixfjV0ZrSf2iImOclG++Kckb7ik8Kq8oxYFd1vwjVL8RS5VT/ig62HNxw3TESZCqDW1GLk95WrzB9f6VYxk2esNitVnn52m5F1mWDiHsFCMZ3+Enos+d1IjfK5uRBqpgKrXr5Zu5ux/PE2ZzSXQ0+mPy3r7qK9H3ke5HRNy3quCyxXcHYPts83iC5cl4hKJ7vdbA9MB0OPhK7ufVa6ZdO7fQ/p35N5kB4MyUT6FD9UNkyb3M/wvvfypVdngCIoLh/46DJZiroO52u1W64kJoU5XGb+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5ZiG3UMcP1ddpGYczTySMDn2ThsqXt99isJQTIlilg=;
 b=YnjMTpzwn6MmmBHmEaDXmactVypc787DHWjghO2dvJ1tpMGLQdYcnMe0lzKlhsnNgXW6Hod8Ak+7093mUyFfZa6lRn7KZPEa3giXP8PFaX6qSOHnEL1TgSRT9FlKO75Yh55J4Aje5+hQWYsq0DyNPPqVH0kcEc2iTM3nKezLufNzslnGcEI77FyfGNlm06IFP/gkDzPRJQoUvnsKxV0vY0YsUvPDeFl7WBarZV5RnK3bOxUYb9Zxv3TBHqaxP5clA56IHgnZKx6GIneOIElCw2DRcT10qDHBCTqUs3nJiXRJttMa4ognVcUoUd6oZB3n2Lf6P12j0ReRj1e/bKlNzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5ZiG3UMcP1ddpGYczTySMDn2ThsqXt99isJQTIlilg=;
 b=bzpp9/PB7oP20uuHGju5C3mG88qiDlBhrJ/gEDB1XGaOaEVmYLj1ZQtMh9irrifqGiGPHN+OiuWJXIAd75mlCGKSDPxVZrz4LlSytqJmXKYuS+yPcXXuUNYsPSn0SB4xzH/l746FRrG8zNTSVmD4aX9r7E7s240idSdjd5SisGg=
Received: from DM5PR21MB1749.namprd21.prod.outlook.com (2603:10b6:4:9f::21) by
 SA0PR21MB1962.namprd21.prod.outlook.com (2603:10b6:806:e2::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.1; Tue, 21 Jun 2022 21:52:19 +0000
Received: from DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c]) by DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c%9]) with mapi id 15.20.5395.003; Tue, 21 Jun 2022
 21:52:19 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>
Subject: request to stable branch [PATCH] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Topic: request to stable branch [PATCH] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AdiFuS0gsEA8apHWS7yubgWv6dh4LQ==
Date:   Tue, 21 Jun 2022 21:52:19 +0000
Message-ID: <DM5PR21MB1749E3A19B16CF6AED1A365DCAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ffd59120-5a45-4d9f-8589-6462174f1e73;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-21T21:41:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69f3b211-f5b9-4c38-df4f-08da53d05057
x-ms-traffictypediagnostic: SA0PR21MB1962:EE_
x-microsoft-antispam-prvs: <SA0PR21MB196227FBDFEF22B59816D278CAB39@SA0PR21MB1962.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNTNUmj7U89WEvH8hplXJ9khYDEH/DQpIg9mU1CfFGKVUlAiG62R98nVD9iUbV62THgdOJqNOiTmK57xSzyJ40R258KWAUWWefQEd2s1mMYSfCHcJva3UUs+PbbI72M+N5Z44jtWcM/DIkfCPh9Mza75pdhVQzl0VpTx4AOBrKWTYQ1OozxlHA9pCwqx42wRkmHpUz0YhsZaqa+l9Iex328rMcFN3w1HliJD4Mn5ij5R7q6JVxnbnf5qbiFn1gkHR3mGriDjq99uC+CETRGy0iOX7B3Dfj3yTYNFI9jB5l7KHYuPGyOZGu6wI9iNn5y4CQf7wCsgGO6JtrSUN4n5oDwcls6Nzzc3MKuRw5Lpf5q6GVIv0IEeV1lFw4JfxlXTzSYrNpR8HUDkUvi6iaqcK6p90TD/OpKOhm9IBceGqzicYeco3KZxhOR/kOic58nyL0nF+gI6zvAU0BGzL+fTy1eTK3VQIM6Ofjd7MxWPiT18THDLwkz4j1GguvgW2w0FcFHOLK12wM87N/8gQvrrugONpE7SCXcBDY9opTjUP4N535o8UVcnCal98pTf1nUl7J1w4m3XO5OZcT91EiWjAnNamWtM8gpk6Rn08koahIa/vRT9pA4YasV/NTxvaittIjNAdBCMTLaq469/MbPI1rCV5FqHwpRis1oJQD5+rPnwqcoqeJOK0ji7OU53U9J9aHfBzXvNOVRgnoufPv+fYxAqQ27UkzJC4jO8mZSwh4UVU/jDpR52biRfxNKpHLpf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR21MB1749.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199009)(54906003)(316002)(71200400001)(86362001)(110136005)(2906002)(4326008)(8990500004)(10290500003)(26005)(9686003)(66946007)(4744005)(6506007)(38100700002)(8936002)(7696005)(66476007)(64756008)(41300700001)(478600001)(55016003)(66556008)(66446008)(8676002)(122000001)(5660300002)(82960400001)(33656002)(82950400001)(52536014)(76116006)(186003)(107886003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vUX5xDcbwajaIEUVkfNI4RX4UuOiJHM8aIAIAnHMW+vZcyXkYLRIFHvcb/wV?=
 =?us-ascii?Q?3Y5bn4qLq91Y0NeZX3hVm6owzWqPnQkxVM0EMxEHRD9SWFY5vNdhgKpMCuYv?=
 =?us-ascii?Q?/S9rYfD8enp0xzZoyBM/O4GIU8Nqa71PrOJIRgWi3rSUUkjLcxEIVpy/GkxJ?=
 =?us-ascii?Q?nzZpB0vqQNeUaQ5jkk/2KMpCipXPdgAjUQc91z3achSZrC4CGU1jxnLjB4Wf?=
 =?us-ascii?Q?zkN1+SHDpK93QagxhfkxiQ8B+woNeGL2aeaHTgaFJg1/dQ4pQBlC1B9PqmGk?=
 =?us-ascii?Q?lRcwpKHqtfntjoDDl8vpMAkkF2nOz141DkVYoVqLvKy5DQKM2gV4cu+OCgNG?=
 =?us-ascii?Q?1VBJYxZHemy2kK14dhM2ubTHYcDHoO4MuYFc8Rf+yzFZWVBgu6wYEmj1s/kw?=
 =?us-ascii?Q?/nlZKMiXvL06LaoqWW00gd+DecEKRwr9m5D9QQewi2GrkuMNNNBh0s+8VKPO?=
 =?us-ascii?Q?m8HrkMtDQ/osKBnOoo0js69qY1rsvLuD7RzxzSAin5mzsPxZ8tRQHWGSIWUU?=
 =?us-ascii?Q?0zBpUMwokuyNwsQSW48EHFvKFtEDIagBG1YXbiQdLZth0GW/OiVy0cjlwwlD?=
 =?us-ascii?Q?HllKhOdhLCABMfPeVgmNzWmscD3Ek6c505sReirOZYkFY/Wsg316LzSuVQD/?=
 =?us-ascii?Q?DUccQO3Z3cjNFS8+7QE2+pxlf2QiZjCFE1KODT+oUquAdEyKLaGfRO2+sBxg?=
 =?us-ascii?Q?gKClxd3xhZUK3TnZ/zH+w0uzdTbnZAVuzm27hThBwPsAtN7ncPVw9x0qaEZ0?=
 =?us-ascii?Q?2uSp+13145OmL5rCA/7jbCXvST4jtVQQtZ0DY0TJtk7HELkvQrdYUhs4qHVI?=
 =?us-ascii?Q?B8/8FWbo6OmhiFHyr8/mqDRHi+b2kpYfs/YKrkSxXY/XXiJeiXqHd8B5jcT3?=
 =?us-ascii?Q?Qe7dHFtEjpCBb0c8aj374v16LC0MgogUfz4XI1Qt6d7umrLXSS3Z99iRDu0o?=
 =?us-ascii?Q?oqcTNlKlVrJg+rWSPRs9VzRxOxAmAfymuyodPowbkDiAZ3JYXRnsvC9FK5EX?=
 =?us-ascii?Q?sLczvUvgRvtSEqfr3cYRAAQUhKMamFtcBGUWtHXOzKfx8erxn5e+7L71ABgO?=
 =?us-ascii?Q?XwAKH0Lr3BAuNopH96zmjFGXrN+ecEJIz8aj2lXoLd2B2aaXq1jvUjUJ4Y24?=
 =?us-ascii?Q?m3V4GSxsyz8z077DIOOv3XAaDwfYuHRmr/UQQPRVExDnDF56LYTdyeO2zQek?=
 =?us-ascii?Q?zHwfwa3QqH0+0la/hdv6P8wedxFU+pXDPAFZLN21F+tqp8tiiyb0ZXuBLMEo?=
 =?us-ascii?Q?qsO8mTdnONG2JmxrDhz3m+15g2r5A9ao6BcxTgoVowRV2FVY7remlrL9vzeR?=
 =?us-ascii?Q?fwIdlWFRJkAvZyLjm1kU1Xx0W1pEiPm7+8VJPBDamrz6r/xIe56sz5i0Mlbr?=
 =?us-ascii?Q?Hj6Fj2ItMbBga+FhW0LRE7hqQOpVbWwm+OQPkyvCa0j4nccSVzgCWUJhZLsQ?=
 =?us-ascii?Q?QjNuHMbxUDh8MwXMDmdZRb/Frgk81JxdHGtZsxxlXu0/sF7JQm6eh1+n/ha0?=
 =?us-ascii?Q?ynagfC/WjdPrAr7M1vbgFyQdXEUZRZItBzOXqpQUjutU5fE+9yGmhTSVEiKV?=
 =?us-ascii?Q?nynVoI7t2O3hpmaGMCN0rRbrNrMUhsfN2iHLRo73?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR21MB1749.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f3b211-f5b9-4c38-df4f-08da53d05057
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 21:52:19.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: he0GCDvJKvO0WgvN+T3eSjLIFggefvGym8VtA2VqB2Nsl19tvw0KrbtuoQfMxynZ+b0E7HrKLNFsBuVxukJpvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1962
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To stable tree maintainers:

Patch: net: mana: Add handling of CQE_RX_TRUNCATED

commit e4b7621982d29f26ff4d39af389e5e675a4ffed4 upstream

Why you think it should be applied:
	This patch fixes the handling of CQE_RX_TRUNCATED case, otherwise someone =
can easily attack it by sending a jumbo packet and cause the driver misbeha=
ve.

What kernel version you wish it to be applied to:=20
	5.15.x

Thanks,
- Haiyang=09
