Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF56D5B88EA
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 15:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiINNPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiINNPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:15:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED5A543D2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 06:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1Rz4J0WvQRWsRjEO8SxyrrlJURSm8eoP/VoROJbYsg/zvY/YXkurJNyLdMEF2X0hVt3AUKQyutnX2/y0DkoVWdRrsZzvm8r5calR8NzfWxFtsxS468F5c4XnN36CNiEL66RccAhgQ97SpgtzNS8Y8bfol5udjLheHheGD26bxyI1RuzdlYhEpB3f1xLsHzZSZeq1ei/yEKlln4UP0k4QWTqQS+rjxqN4mtS6o2U6nMWYOVMT3iTBR/4S6yyeHnM0MMVCLU2l8644bKlRK9W/Cqqb7zo1VZbtQyos3WsWsgp+acvRfcWA4YYHE4teI62HAltA3O2nwambkFzKa3hIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lp02WKfbVk8d2sc6YoeWCNqY5ig1IumMWH7vwmbcpt8=;
 b=IXBQID1UiDOF0ZVjXmcikHtNVma840v/NMpv6UOPJEP3SZB7z677tFW0XnsH7YTHo+VB/pXWjYTK0leS2x4ZC6YrsQQ4XAzw5vAFYYNe3cxyaJZ0UFYDu7jYuRxCw7eO4mmsv7PcDeF71dXpI9vu6Wg1+0vmTRbe0ckuDc7c2VG7W24fwLJh/bmGIdq6fKMV1Eo9cOTH+zirfHiHlbJ4SizUMGtq2HFxDqC9yTjUNGHhnG9n4AfzRL58Kj1wI/rFI6O9vkCqpuDvPH2/YBcW+3wBEmzC1tkcARQ8a+vsZZZ7zoLPqkSDz6+nEMXXQHAe1F959cRe+QfjXChnlzvm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lp02WKfbVk8d2sc6YoeWCNqY5ig1IumMWH7vwmbcpt8=;
 b=gGIsOHaRHuxK2GlFbJr/5DRVtl3wBiQmeT/GeLrwV+WW6nWIqgYpQ3EWTf7HN8wvpGdDjRv56AVnsMsPtFXW6GcMglNBwgzuEHeVT1RfiFJpPEd+ORN/QGVzLwDv0JZMLYr1COtX9QixERSRD7TWodo76xAhPQUkNfpfoOPBkVE=
Received: from MN2PR12MB4607.namprd12.prod.outlook.com (2603:10b6:208:a1::18)
 by DM6PR12MB4186.namprd12.prod.outlook.com (2603:10b6:5:21b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 13:15:11 +0000
Received: from MN2PR12MB4607.namprd12.prod.outlook.com
 ([fe80::2de9:74ce:6dcf:d668]) by MN2PR12MB4607.namprd12.prod.outlook.com
 ([fe80::2de9:74ce:6dcf:d668%6]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 13:15:11 +0000
From:   "Cooper, Jonathan Stephen (DCG-ENG)" <jonathan.s.cooper@amd.com>
To:     "ihuguet@redhat.com" <ihuguet@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "tizhao@redhat.com" <tizhao@redhat.com>
Subject: Re: [PATCH net] sfc: fix TX channel offset when using legacy
 interrupts
Thread-Topic: Re: [PATCH net] sfc: fix TX channel offset when using legacy
 interrupts
Thread-Index: AdjIOa45EBxkjbI1RJ2NIfbG16b4bA==
Date:   Wed, 14 Sep 2022 13:15:11 +0000
Message-ID: <MN2PR12MB46073A1254BD4B8B91453781B3469@MN2PR12MB4607.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4607:EE_|DM6PR12MB4186:EE_
x-ms-office365-filtering-correlation-id: b0c28e55-ee8b-4251-9181-08da96532787
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJcF73ib42uWWziM7usMyDofiGsFWtz5C+2/TS+xMxhOifvQxZI+4QwCQAZUUoHtezfUt8XvBW0nd+4gOo6ZCFj14pV8A+GLk/cwx98hBxuHLIBHoqV6jE8WiXDg/THNMCaqz9S/2yOTxXV4RL4Uj+6PCiYTcfyqQpjrgdf9kmpDyozkT2dgqCgPIYAlA8n3aNml6nJ6YmrBCAeXk0LMeHHIfwA/M7NSXy2WXqwmjmUCsYaKammDE0A8PQKJwhiJ6SydQfMeC05ck3SHdIYTzHv0d9zRbPf/6727Pljg4EH+CcY6fgaLpPAQBtMcAyxi8bugu7qSExr6DJUHH6ubAMuJY9MGASmqrTPhbEUj9vOKcJ5Vk3y68HqcJKDLb8xHn9pMbSh7zNNdAHlhL+sokFIix/CGP2e+PB+d3UMemgSnuMWvW0gc6wf31LIm1KBIYB0Qy6d34u6KY1C4PKNviLCjf83iCqxmZCeqJgNOuy2yMctbEtrXEqsnKeJxg4rzryMqBcHLV+gDOoUT21S6qXPoZaGDpNUjmygwTz0q5qWcT5TP6138ZKDkLsXPEvWsLTsDmLvGiEn+WiP3LtOJ9ZEU6gLqLHb8m8Gp5JgnPMQ5MYzLRMJQgvt0m+eW/OHdtWePrb76wiF8JsNVkrgnHs9hI3M0Gqlivzo+o3J6raW6B7/qstApEErzZ3y+EwLbZWZsqCl7mgHiLSUsViujaWXjFINUU8lGyYvD0k7QMSaRPqPReEk2r/6ArR/xnjksfRiqkzP8XebGoiajE3JTxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4607.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(33656002)(8936002)(26005)(8676002)(66476007)(64756008)(66446008)(66946007)(66556008)(6506007)(9686003)(122000001)(76116006)(55016003)(6916009)(4326008)(54906003)(316002)(41300700001)(2906002)(86362001)(7696005)(5660300002)(38100700002)(71200400001)(186003)(38070700005)(52536014)(478600001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tCoj9mPG4OgGqyz+5IcECS8i1YFbnvqHwaIMWXxOzsgAXcL2Xx9AZS/oeV?=
 =?iso-8859-1?Q?Ay/BFsW1r4bMlE3HpcXcCIijKvgggmQ3GVyLKJv6APobu95wk/lUfUwjMi?=
 =?iso-8859-1?Q?eMpDqL6T5lWnGM7YUB0/wGZTf1WDkHIzAbr8MLiOCq+Iq85roTz3870hJH?=
 =?iso-8859-1?Q?zvjxhXx2eqpIQApBOZOVp/EFsgRPtznAQ7PoN3Dv6OSAG+57y2JRRTt/mY?=
 =?iso-8859-1?Q?FweprKy6dcITp5Y+eSuY5zGiqTbN8tlY6H5T24I34vpuuOQWgFfhlJ/3xr?=
 =?iso-8859-1?Q?yicKXC0LQA0RBudrmSOkzAwozFNg9N1Su+plx0qeXy598R78ySgwrox8WB?=
 =?iso-8859-1?Q?rBFn0xmSeYMspMOkX2qrcoSiytBMMC3bw1dxb3NOIfo7FiTWR6YCfwAClC?=
 =?iso-8859-1?Q?nv/AeSRJkUOOezPP+1iP/sjYcgN9l/Ggpb6PB0gjn17xRMjgFB/nY2juM6?=
 =?iso-8859-1?Q?mJFFAJHgalLxJMs78p4O3eiGbT0d1jXPIC0QBm7+vWk/zH9PLu3g8FZ6oc?=
 =?iso-8859-1?Q?7jygWNhZJPRdRLptEsupb8OOvOxzEE+hkGTN6SCXZVayartu4MvI9huYSC?=
 =?iso-8859-1?Q?Ogghn2ZN8DvIOf9EeGL831T4ewHA4EzbdheddmzYrIIiAJ+VmGFXhebl1L?=
 =?iso-8859-1?Q?TDrw7DBUoGnoUz+uxuI/SdBXdifgxifY9NVuIXlJsQAttu7yuvVLsZ/dI7?=
 =?iso-8859-1?Q?CMz3j2YXpbWqDrzORoMtdk8THXfp1HZA/B14J09H44It5ELbvktM42B9mU?=
 =?iso-8859-1?Q?2cWgTJJk2Z3Tpyxk3TQXcbrVKXYkOiLlTpuXKCCcUvPSj+nEjvLc4o02cd?=
 =?iso-8859-1?Q?tfN0ujGbYzxmtRtH1PuxqsX8runLNM6w7ecL0FIFwLDLmIvYNS66QHgY14?=
 =?iso-8859-1?Q?kzIQ09z9qUUKNT8GpIOIQOGLkZB5TKlxi3STlfBAj8chrqUAlFRkVLM5oA?=
 =?iso-8859-1?Q?iX9sv37fV7oYTMeA360UGS4ryVCSYYEEWgtE3CFOoXHcRU55tTHHOOJSz1?=
 =?iso-8859-1?Q?MPYgkkfFsO+p0VQEzDG8YnMBST39jIeelEgReV+YsUCiMjgMbpC+tCBebD?=
 =?iso-8859-1?Q?YKgXKPgeiCtWu/fmlhHNwg9hsGyqeQ9/ac7tdaofadg1gadUQ3MLVzwpLR?=
 =?iso-8859-1?Q?UtiBIr11SfK2U51U+N98VhBzrketdNxdRKS7yTqMcC7uysoxREcXfuOPIT?=
 =?iso-8859-1?Q?hAKUAVu3kQf4p8XWn67m2pkWnmWAO48kWNx89nvqKVe0ZQ6RYVHT8i95Me?=
 =?iso-8859-1?Q?cemEjh9qjpxOcG0ArA35uQdzLQx+BLjYgYn1CeVVDY+wnWfeIUw+zuHVWl?=
 =?iso-8859-1?Q?fZBgSH7QLbMVWky9TPBMQK2HAyUl6Mbvwc1uQHy5o2hYldO4hDK0Hv3gze?=
 =?iso-8859-1?Q?gGW+/juvOH7Oix0/8+JcRjhV28jQ4Akj/7PpplVnOVpt4jQSwfdwV2zyy2?=
 =?iso-8859-1?Q?UIU8SMh0sXDfVAHgplzg/u6LSaJY8Nk2lyxaNZMYh7kc1Mr6FTOcGE/Ktf?=
 =?iso-8859-1?Q?B/haK0lxsQIBCWB9vI9M02J7g1+q/z8RPyK/O5YF07w37HTDKwkUu/po/8?=
 =?iso-8859-1?Q?vMdI9yh01CU4g5cK9Ha63A4Gso7EeguoGzVBc87nOpaj/IGBBw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4607.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c28e55-ee8b-4251-9181-08da96532787
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 13:15:11.5525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mnq/gKObgcd1YIn4gfpbrt519LUDTVQTKyC1DrjmgrvW24E/SGvddfLaTldLZLrK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4186
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In legacy interrupt mode the tx_channel_offset was hardcoded to 1, but
> that's not correct if efx_sepparate_tx_channels is false. In that case,
> the offset is 0 because the tx queues are in the single existing channel
> at index 0, together with the rx queue.
<snip>
> Fixes: c308dfd1b43e ("sfc: fix wrong tx channel offset with efx_separate_=
tx_channels")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: =CD=F1igo Huguet <ihuguet@redhat.com>

Acked-by: Jon Cooper <jco@amd.com>

Jon
