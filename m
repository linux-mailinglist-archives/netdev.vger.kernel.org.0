Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD8B5858AB
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiG3E6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiG3E6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:58:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED2B2F67C
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beAhv/sCGMWcq6qK9DWrOye1jzel2w1f86mdld19UiVg0yUuXjElhez0c1UUI5c2mpyWXTDlTbn6StSIelwnOEQDEsZZxuyOiafuEvzAWLGqBtyK8Ktdyf8XoC85ILLYCleqNkxPn4dZ2P75Q4pqNR2edvrxFtpPSB/5QxufKMyXIgfr6ttdSTWtObfP8giSFeYvbfyWhgR5+LPNG6lAgeY6FG66M/6+tVVXcugFzp2cbS4FnRaRY499zxEnwQdzVCy+GnqmFQSYud6S197lvK2l1qpBAQqNHlhpnNd1M6aT/HWiTxKMA1CsdyO/4IBZDjmdPoy5mgktPv7mhLHOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EcWUXJo3eSVN5oCsNKO5hm4PXr6FOmVG1Y2lQwWIrg=;
 b=XcIYIlyq6zrrzx7J5IvoeU9GsvZKxOWblIlH2FD4vzeBOqK1c1Z1w397Slqrq2I0F4KZjbHXdQcBWw3HF57MicZkGhiPDTZc+i/cIi0n1GJO0BtG1bt5yhfs4qnOmhptaCTJ0JkSvs72i6a6fBMM3p7w4PJHr9PJRwK5chK+dYrDLEbvhemOQAMXCgPnrKC26jaugMoH9FHj/f8hV7ygK2eE2IZfK0yNizpKtyam0JVzaIs3XIU5KmaYv6PIW9xpiE7edtV8dRn2NyMsXPR8hoR1NyjFLkjE9wnWOJW4Z9KklvxKHcLsppoXXXYtXLrDXd2eQjw6Q/67nQ7oN8UrHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EcWUXJo3eSVN5oCsNKO5hm4PXr6FOmVG1Y2lQwWIrg=;
 b=E+AJTZ1ioPUusvqlHV+QygqnHZkO3potjCKbGH7vpuG1NVm5Vq2U2reqwwU/qON/613HebVdNrawLLfDbJt2pNWLjqS2ZV4t+eX+YGsz4smRmPklJs+61/zhjzJB7RKWoSkTA2uOfilECDcNqMlyqJcxqj+a+zxYWSdX5Tp0ECo=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by MWHPR13MB1872.namprd13.prod.outlook.com (2603:10b6:300:133::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Sat, 30 Jul
 2022 04:58:10 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::548f:58cd:8519:9785]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::548f:58cd:8519:9785%7]) with mapi id 15.20.5482.002; Sat, 30 Jul 2022
 04:58:09 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: RE: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
Thread-Topic: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
Thread-Index: AQHYowq3iT0aRGebi0CUT26zO1oYaq2U3s+AgACx5ICAAKnHAIAAH3ZA
Date:   Sat, 30 Jul 2022 04:58:09 +0000
Message-ID: <DM5PR1301MB21728958DED2FF52C2FF9496E7989@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220728205728.143074-1-saeed@kernel.org>
        <20220728205728.143074-7-saeed@kernel.org>
        <20220728221852.432ff5a7@kernel.org>    <YuN6v+L7LQNQdbQf@corigine.com>
        <YuQP+cBUkyR1V1GT@vergenet.net> <20220729195844.23285f4d@kernel.org>
In-Reply-To: <20220729195844.23285f4d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 620c3d6a-f4d2-4034-b0c9-08da71e8194d
x-ms-traffictypediagnostic: MWHPR13MB1872:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sSBGeMI/Xdtw9scstlU+i3RzKatfC6nMLkZ9qYY5yeIlv6jH3sug0o16P4CiWxX7fGjp4EDbh++wRi+AN2n+/6pNQIE0UfaWubMZt7V4h/Zc0R+WhsaBKtPlPxAEMxnEtZTh9DUWsVML8jAKk5CxNJbn4xfNyaV1nhrgSesVLQ4Z6XuPOIs3zqol5q/6eJwomevr6W3vCtAcn/ArPhfuIrwZ3AZv1kEV60qQaq68xa8Rq1C4eFEsHkXUi7Rix8vQxhdC+mMDgWuNzOyM5uN4/VzVBnghDxSlP1h7AHDpa/iN92LvVf2OSJpFLuzs1ZCX34gy0cfOFZ1EokRnIZ5QNum3mddpKDh9+Hc7bf6V+IRqYUIsYVtb2AWVlvhJzRCyvMh2K/28nuOhyFfks0jtSmyOPI/eCeP14Y/YSzdYtTZAhw1CS328LjYh+7Y+R9Oaa9QhJ+97QDVp3k+7IG1py3K5HI/IEJgtlXl/ydDRF/ytFpdCBLNCp5EuMz4m2xBomoY2i0mb8ikDA2fDKBh+qHmz+fRkX53+GlgxR2XNvNDjxvsc+xMPK3kK1eqXWotQXjMNhkibsmmBS6NADtZMj4sonm+cmRCYyhQir5V7766iCO38jByvjygOyxn+VEtmDHjrghEFzfItOWL4VadsN1sJrC/5dnLT0gNbo9+RqNE7azzQ85oQBB/wm07ObqIABszI8tYc/lIZjtBRvvoSYUM/ZS4C0nK6n6TCme4/YnOiTIL95J6DQ+szGskQBziTsn85K4GMQ/u7bqd8TDjw927vEgPiFcqOqY4Ibsmc5su/QZu+MHo0aZPqobi1lGPUkvp3nysKjMuW9c7n2UVHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39830400003)(136003)(396003)(66946007)(110136005)(5660300002)(4326008)(316002)(64756008)(76116006)(38100700002)(8676002)(7416002)(52536014)(66446008)(54906003)(44832011)(66476007)(66556008)(8936002)(71200400001)(122000001)(478600001)(41300700001)(26005)(7696005)(186003)(6506007)(2906002)(9686003)(38070700005)(33656002)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jpSXKzdl8W4hirfYr4RSf5+WP+1Vr4ouYY3F29+YvsqfrHIl40/o7iB+Y4Dg?=
 =?us-ascii?Q?r6DCu+iVXdNK/abqNs3VrMhEufK2ZgSwZYFeNGnwleWZEftnK/Z6jTrrOAxo?=
 =?us-ascii?Q?owwzt42mKHtR25l15lqX7A7wQm/TMif4pcs4qaeZHHtgnP+le/hwK75K+Lff?=
 =?us-ascii?Q?u26XOFJfZQihHlJWCp4y2nAISIDY3WJ9RT9FryyANpAKUr8mKH++WIPOKdeK?=
 =?us-ascii?Q?31D6eH33ejH4wyWAgk31RwPA9MriKzNv+sngPTUlcni4jKvKxKjX/xoUp6oE?=
 =?us-ascii?Q?kBKw5ze2Ravqk+60FM9lxFlZauV/vvF783y6GrN0G4k+nj+MXVACpvqDyjGf?=
 =?us-ascii?Q?7BizHuWNCeqMmNxmd7g/V6jE8SNjnqXdi9FZ0RxFGx32CoLsb+ekUzpIJR4W?=
 =?us-ascii?Q?IiKOEVQ5HxSDi1BcWL71otvo5+5Xy4kwRhG4q9TQAT1zNRk7zxRmKh9D9zR3?=
 =?us-ascii?Q?pXVf9LDGv/peSbgv/dRQnu5wUdMSYAat8OAv2LXvno5T3OkSg+vtO+JqUqdw?=
 =?us-ascii?Q?3oSFS3M3i2BROS90TvpbdDqmLeH0H1CLV3JKr0g0iD1QL0L1lMhCwPePh0o5?=
 =?us-ascii?Q?BTIvSFgwt+XeovOvKMBWsPR65xhhOZXXWmXIOTsWLb9V1tSvsZkrObJAGwD5?=
 =?us-ascii?Q?hCb6iSl3FjtBTsvTvY6nisdJ2GI4/jwMSd33uXUUAUxoRTnROy/3ZWZ98dNp?=
 =?us-ascii?Q?rjQ2aRO3o8vkltrkC9bAEafcPzOsej2Dq/kdfYqhHIgXwVyU6bHQRCbrAwTS?=
 =?us-ascii?Q?41FlQaEIk3oyH4H8qthIW9c16cTMWyCqSCgubDEirGb1QZMYkbQ7it0ZgRUO?=
 =?us-ascii?Q?5nV4Wawp8UvifFfWro7J7q+58s5wpm953JnTqeyXheVZdXXw6o19w8cQXqjF?=
 =?us-ascii?Q?ZG9eK28jiJ8Pc3bMNwyCOcQuye/XR4STkaEcsOoHVIK3wdS9qQ9QUGVPEK8T?=
 =?us-ascii?Q?kmcH0fqvB0RBEtCZeLISd8gNckQYbhGncAWuWtFEF+PfZA8oBqNB1k7f7CUR?=
 =?us-ascii?Q?oWtPZKSsSB6BGgzfqrKMFxry6mwMvA4ySpyuSmQhpTRFGQUEMkyVc63lzKzU?=
 =?us-ascii?Q?ZcM4sp1ZfkfPoPYFCLGdCe79g2AieXB6esby8r/S2xQSaNU6kLN6VFBp1VO4?=
 =?us-ascii?Q?D4iU8WN71NpFj4V/lr4Td6pf7VwDjyAqvbB4e8V9ZorNe3qjPDIFsCoH6WOQ?=
 =?us-ascii?Q?Hbn1GG7yJCtlTIQV+pWz6yALMbgdLcH7zUfDunj0jLqNWV/5uFP3rgQsdZdG?=
 =?us-ascii?Q?S3heA6pVGvL6I/siRJZ2xBDGDvH4rWkerWxlEGlFG+W3s7cZnBY/iqpiYC8g?=
 =?us-ascii?Q?kM98VcstXwdfdxd+DIaqNL+nUvku9Vfh5d6BCBzl/x4yreTY2vDxFS/EAZBu?=
 =?us-ascii?Q?CLWdSYt5mCLD2HIQYVCx1bEh2XFhgrt9/WSYr8RfoohJd7jfi0sMUGrtOrvR?=
 =?us-ascii?Q?dPeDey6muTpcNYlPKUNWVHXCC8qEDfsqJq/JsY47k0vaWLDoZX23YWWAJ25B?=
 =?us-ascii?Q?BKoSjTOnffN9srO1l6Bn6wxZHWVHC6acB31P8+2rAuzI0WshWBTu3EfMDfv8?=
 =?us-ascii?Q?XwwFRyX0tDBNl95Cl5j/osg7i/HHoB7sU9ulo42t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620c3d6a-f4d2-4034-b0c9-08da71e8194d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2022 04:58:09.6594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bfjIdvRpStKul+KWWpr/avOB5bGsgmDc+esoxLBD4Jv1cAZdmF5hOlQ+1aMckCbVVQXn6wujPQMNpy/XDB3y7MHbEiyxpwJs0jn8jemBEB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1872
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for pol=
ice
>
>On Fri, 29 Jul 2022 17:51:05 +0100 Simon Horman wrote:
>> my reading of things is that the handling of offload of police (meter)
>> actions in flower rules by the mlx5 driver is such that it can handle
>> offloading actions by index - actions that it would now be possible to
>> add to hardware with this patch in place.
>>
>> My reasoning assumes that mlx5e_tc_add_flow_meter() is called to
>> offload police (meter) actions in flower rules. And that it calls
>> mlx5e_tc_meter_get(), which can find actions based on an index.
>>
>> I could, however, be mistaken as I have so much knowledge of the mlx5
>> driver. And rather than dive deeper I wanted to respond as above - I
>> am mindful of the point we are in the development cycle.
>>
>> I would be happy to dive deeper into this as a mater of priority if
>> desired.
>
>Thank you! No very deep dives necessary from my perspective, just wanted f=
or
>the authors of the action offload API to look over.
Hi Jakub, thanks for noticing us about this change, for this patch, it seem=
s good to me.=20
I just have a tiny doubt, since Nvida just add a validation for a police of=
fload, why it is not applied to this meter offload patch?=20
Since I do not know much details about Nvdia meter implement, I guess not a=
ll the police action result is supported, so maybe validation is necessary.

Thanks
