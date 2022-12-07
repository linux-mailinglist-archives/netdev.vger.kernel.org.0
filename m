Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8137645A1D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLGMsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLGMs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:48:29 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636692C641
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:48:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+XX/rj8p15et+XPDd5xKH1KpPwxEjVAbKgu04OOIzEZX15zZegy2y1+ieUvOQgwcNH+0pBh34SV8ELru287L4S3PnIMxdIO94tHWBEH+0YkHShax/FqXIDuJ1gYpaDwhqiM6qhHAECy+oAiLQzxTr/yjfUXQPpfdGm9gM6+N6jPQkAnrPK+NqSC9RsYr7ud7peiXEYnKvUIUNiG3HnbvDIZqTmHVG0R322HQ18tnwXGRiWbj5+KIxe7in0xTzsNwa1YWCEyWFu5wD4PyHum765LKz0r966pJfZX06bSxbr6bIFi+dWk/rTRo8e6qMg8i3iBjP8iIn4m/l/cvfrsPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4qKKk+KDNi4qGciPx8cj5B0yhDDvE8FrGDFALSVRAQ=;
 b=iuClEQbXneAVVdxuiMet19p1fsqyjAvkafBq7VDWlPkPYhkGWe+1kq237C9JPilQe7+p/HJjfFsPtWFyK/l2XMUurHhUKzB2vyJrpij53hFp3R/ytuLwnewKqf0O9E+mAJqZhnoeXV+7n5LSWraZCK6aAz3S1pi62mlawMR13qZx4AHFX97nt+OIOFu6Noc7kR3afvSY3zlsC0BRHmwjeYV+fXQ9AmHNBjbJWwNjvaBIzUCwPew1Xr+n4MLE3JmOAonGxliesQg1pzhjFt6Lc8XOiHHS8V2pH2JF4gXupbVIYu58tlNGRWwTzvia6nGlzUa0x4F+UTKNi2TDvs1mlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4qKKk+KDNi4qGciPx8cj5B0yhDDvE8FrGDFALSVRAQ=;
 b=TFlYkX9EaTR1EN1+C+MWLF4DQoFvtr47hG4kZk6hqnXIxsXMaQSFFlSoLK1w8ya6stQOXkvtpH/zHfSVhg2EvcSTnnPi0N5XkjLCGki2iEfNJ7Lu2mJjPuFj7x8rYX2gDjOrJMiK82xxS4cZjeNVfGq3blv2ZyQlqG6xI3QcZTjNiAR+KhVP+wex+ABOnd5t4BkG2oGPG4dprlznqXelxlfxwFmlN12wZwGjWQySRuXlKNvvl68ie7app0x6XDnKl71idNYI5Gt49P7JNcP3WXhOnQKkwNh9czF3sjcBUk7VHX3NQTNJP0y7Ii3vRinSESpMiDGCWa+EiLHCp+0yEA==
Received: from DM6PR12MB3707.namprd12.prod.outlook.com (2603:10b6:5:1c1::28)
 by DS7PR12MB5960.namprd12.prod.outlook.com (2603:10b6:8:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Wed, 7 Dec
 2022 12:48:26 +0000
Received: from DM6PR12MB3707.namprd12.prod.outlook.com
 ([fe80::a78a:1514:2c4d:b81c]) by DM6PR12MB3707.namprd12.prod.outlook.com
 ([fe80::a78a:1514:2c4d:b81c%3]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 12:48:26 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH net 0/6] mlxsw: Add Spectrum-1 ip6gre support
Thread-Topic: [PATCH net 0/6] mlxsw: Add Spectrum-1 ip6gre support
Thread-Index: AQHZCji3L70Xhz2PfUSA+sH5vtzlba5iXw+y
Date:   Wed, 7 Dec 2022 12:48:26 +0000
Message-ID: <DM6PR12MB3707A92FE5BC70218ED0ECB6D61A9@DM6PR12MB3707.namprd12.prod.outlook.com>
References: <cover.1670414573.git.petrm@nvidia.com>
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3707:EE_|DS7PR12MB5960:EE_
x-ms-office365-filtering-correlation-id: 46c7573c-8f6f-4725-1cb2-08dad85155aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ey7dPIkkHH4js7wDd63bY/ZHozQ4zg3nMUpBfr314JsCLbwxTA6h7pr5wYJRYEHlVn/RUFuK9g1tL6noS/7wCctY8M+FfHhA3JlzlUbl6s9OIMeLV55+RBy4zdxTMha2K3fo3qZLbJOS9r7uJ1YVQt0SMSctc6a0e+Sx7XWskqwzYruoXfXeIdSJ6VNlgxE3YOBsD+GZtqWqNysZD+CDjM4rpaqrxqWmk/5OKwHclVJbMq3bB9f90nweFFzWwpq1uKzdSpgXBbohNzVl8YsMZMN4gpyhFYaKrGAa3UU55+m6WuHsQgTPpdVFyk6g1+UBMBjd/S48F9FPFgZ/T9cSl5un7aPxd11nJZjJD/UQuzUzfhxUYq7hFYyfChcZB4sxGqoFUXeMce84HgjuetYqlHZjS9gaPdcduxUd/y48IaQKRJHcPCcdfpwrrVb8Prig9aJ+AAUgRmR7JwzvMhZstF4U3ZujUb3FPYu2QkEEVkh1B8LAkpHK1AQRfF2OJIXS2xD9ZGwxvOXkgUK5CKUFD6HgavpfOgkom2YFgJjsmfArtQkzNclkhJW3KJf49oZyh95O2zDhLF65TunK2++MSCEHL1lVp4DRIsjAJhQfrOKoM/XUo5kLbNyD4u8xQLnlj6WZLOZNywD1rpQ20wKY8xD/SWbWCjOWIZWNSRYTicr5zaIflpkp/d1/STKcTQ7G4xvoiiDyq6bSIbG1VWSAK5ZzkwQcF3OiV7EWr5dxNCo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3707.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(2906002)(76116006)(558084003)(186003)(55016003)(33656002)(66946007)(66476007)(41300700001)(86362001)(91956017)(9686003)(4270600006)(26005)(110136005)(38070700005)(52536014)(66446008)(64756008)(316002)(8676002)(122000001)(66556008)(4326008)(38100700002)(71200400001)(478600001)(5660300002)(54906003)(6506007)(8936002)(107886003)(7696005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?qawTzZ1Ywa0vPmctUSaHt0WoKHw+d3CxiKER9/s1/sa+KZNNXGh5eYeZmN?=
 =?iso-8859-1?Q?revWnDd4ZpWyvfkHcrQ/RB7KMlJFqSodJzlWuK8fkgzawUevjb9rEXpj/0?=
 =?iso-8859-1?Q?hfns1DZf/DP668YMni3L+LDtr/mrY9p7Qc/9L1Tq8L8aksCM4/+og9lv7V?=
 =?iso-8859-1?Q?L9/9ZAycawxqTE7vgP3RGl5cYgdLV1OnE7Sh6mY+Kr+rnEhEDNrHms0cbI?=
 =?iso-8859-1?Q?GBECvujJfVLFu671e2kkjo2kN4ZP9H1tjyaPiO0YwmD7k5+Hjk99zJNsRa?=
 =?iso-8859-1?Q?w7/EHlqftnd6HKZfsAwrvn5i8qUQmTRiyqTdQ3bBJSDYvO1eM4DQm2/X3k?=
 =?iso-8859-1?Q?+oAUOmFschKNIOWvAhLfB5nVp50QvW1JBRmQ1H+2SyA0E0dFluOaGH27+i?=
 =?iso-8859-1?Q?K+ajAXE93uiMkxP44x3AIn6xTpmhlMao22udE2JCAbCOEH+d+vAE61XOKk?=
 =?iso-8859-1?Q?lgSb2AfuuaMuXyVt2+zU5ogYdz5BpVq3OnGLGmkJeHm1uAlk9zdlHTxKk8?=
 =?iso-8859-1?Q?+0ziNXccmnZef+dJwpV6/5SIQa/r9/eFR9vCiOD2Ffeo+NdGSSP+2FEz8T?=
 =?iso-8859-1?Q?srjCclFmxE8ZO9eVE5vSUpFLyLyo6hmchxg+FhEtg7N3nZBGIhSORbjy6t?=
 =?iso-8859-1?Q?PZ4c2fUcvGUDzk9KS9OfnsgINQI5X47Il1+zd+psaDR9AAUYbbhajZcfKA?=
 =?iso-8859-1?Q?Zpz17YDEjMuMbms/DdcePIDSQ3DXlm0JGrg5EWpaInKbFQviRf6vRMw1fz?=
 =?iso-8859-1?Q?FjOs/JqI5ujNjjsISYD0XlIAWQxlqoeUuHnvh/bo5m0LGHN+m6Flk6boCf?=
 =?iso-8859-1?Q?jJ0ziNmYUl3uDeoPUsFuh5/pK7+oU9d5VOE/h4Po9lsAQt++W9quhzGhj1?=
 =?iso-8859-1?Q?se9oGUYQW9ascjQvYKKJW11RTyxdRahBrFqjpRgHCTFaNjfxywGM4B1Dmj?=
 =?iso-8859-1?Q?GvgstXz2FJEgrJXMkaW0WAYtCiYaO2vUrzaSl+9k8qYX2yZpTGPpSgEosE?=
 =?iso-8859-1?Q?jXgITbRwE8UssiBSN0nGzjOhLJiiAevGZiRccNh0Kp3j8YXovvdzjj15Cc?=
 =?iso-8859-1?Q?OdSwUaldnFSFZ8/fxThECvaenjmry94N8zmdDhUjK6DgCgX97jJdLhb3oQ?=
 =?iso-8859-1?Q?Pj2ESA07xu4PQDAmzn2NQmF18x51/kIZkHe0trJ7zZvhngVGwyXjud1ZIL?=
 =?iso-8859-1?Q?yqXLI8WIhTuzTIrbnDLodtvzIgU52n5//z62mK9Doem2oU0brnhK/mJVTE?=
 =?iso-8859-1?Q?0YcemDqeIrCYiDq0+Pav1y1wRTo82m8KA6IQhUuRv660hRYBHYjcQf1I8J?=
 =?iso-8859-1?Q?NnkFwooVDidgmzE6mAiaSUhv2uQHorTbo3zMP4mpEjOcd4X9fk7SGLjsJJ?=
 =?iso-8859-1?Q?HBZc+pEVW/3i7K7ql2LG4tzRbCCv7iH3oIWLMtMTB9GwNPrsapap7wRQLa?=
 =?iso-8859-1?Q?RdSl0HMGjZc2MBgNri3Zl31nK8ZnqnH7epwAVUh2+PvlrYiup7UBXWgAQx?=
 =?iso-8859-1?Q?HmrA61wi3+WMkfsfiSkVwN+0E9nH+JMK0EgiwYLjvCpuIvbf5lDAj8z93O?=
 =?iso-8859-1?Q?M+HOPW4HKARSdalt1arOM5R02BazPtQXQYlEjPAZHzzxGt9qg/UXqh63je?=
 =?iso-8859-1?Q?XFQDOSv1ItE4w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3707.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c7573c-8f6f-4725-1cb2-08dad85155aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 12:48:26.7352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJUWKcfYFANbbGsyoO6yBSOZ4Q/llj34Q42haQzqEQpDH9vT6jFXxOlAUB3QkK+iJ0Fs+c4xOCP0ulF9D/rolw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5960
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, this is meant for "net-next", not "net".=
