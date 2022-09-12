Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D545B6324
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiILV4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiILV4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:56:11 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9001929814;
        Mon, 12 Sep 2022 14:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVaRNfJ6mHFPobMU+V5EXvv+k7lrnyt+HPltBVHmkYBAykmDEe/UVt5jkZ6a3JeWbi2kITBssEdDmbs583oDjZFfFBx4Vex2gX/xR1AJd1PWCGq2FSTKubRwFbMFf6QKP7ARWQ87m/QwRdBtA8/jYiD/N5OUtDRwXx91NU1515yqrgBryBGdZeSnl5p4ABrqRgdJxYP9doyaPsXYLBEF3VUhw4/VMBglegPKRYlrgv67xkGp/WMB61a/vWWNCT9kdyZwMI51BEauCv47w4K9oU9wbDq3WtqL9gAd2CU8aL+1LsFWICp1LfRD1DQrYK1otrDFso+Judro+cItDwQxXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bglgwPraIJOH0KI3SmoKtjD8K8u9ZIdUm0UsE2LqErM=;
 b=BWhJHAtOxUvXl2c/z5pjxqJazi7B3Tozy2n/cdKSb/DuBd/CtaX8YxUNVtNP7CLkWuQIidn0OAu1H1AR+Qe6S48UFexAu0mfCzIsCmpDBwHARgxeOGDQEHQC13b649TxAep45RNsYdngYxNKH/6KYUEyy3AMQvMKHFJ+ksyoBRymcWhffijG/hY/SHMoTwxSasrAVF7BbWjKJ4gN+faYYpt6H1OHhEgE75699qczB6j+xdeLcFcujiXM76cMV3I4Zb1LwiL8f3/QbHsdjITEhtG43S0vHw775FseFXI3GCa/nVc/5TorI2yuWlm3dJ462uD7qTj0j6vfoV1wT5Xgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bglgwPraIJOH0KI3SmoKtjD8K8u9ZIdUm0UsE2LqErM=;
 b=DTBys87LF31m8I3ZjOpkeZdD+PuX+M1s7mZmJVlVXbL44JmpadKWdAHhT4k5oHWGBZS3uvG6P9jzvMrLr1scyUqOuW+2qASCiDu0ZdPMmZb5wcCbPCjBQ4er0odyL4DVIGPBErmEl0JkqZX3LzcLJafKLCGqXJJcqrMzT5pZPUw=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH0PR21MB1959.namprd21.prod.outlook.com (2603:10b6:510:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.4; Mon, 12 Sep
 2022 21:56:07 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e%4]) with mapi id 15.20.5654.003; Mon, 12 Sep 2022
 21:56:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Nathan Huckleberry <nhuck@google.com>
CC:     Dan Carpenter <error27@gmail.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Fix return type of mana_start_xmit
Thread-Topic: [PATCH] net: mana: Fix return type of mana_start_xmit
Thread-Index: AQHYxvDdDef/VwTQN0WYjedftyXI263cVlgg
Date:   Mon, 12 Sep 2022 21:56:06 +0000
Message-ID: <SA1PR21MB13354FBDC96B7196CE3E46A5BF449@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20220912214357.928947-1-nhuck@google.com>
In-Reply-To: <20220912214357.928947-1-nhuck@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cb639ee6-6c79-42d5-aec5-7f2c52ad0f8d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-12T21:53:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH0PR21MB1959:EE_
x-ms-office365-filtering-correlation-id: dedc0983-958f-43ad-e00d-08da95099862
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Thfb8T14tWp67XCVjpw43PHMQoB2KpR9PqNdCj0yzxhMF1YfCEhepbKIjG0JVJQOH47ZfyWp+e/vpi85D67FlCTpbstU8t1edFxQAfHTBYnMXQkL7vOXxOlUl0vOkxuL7GDIkVtLBnFTEAB+CAEP6+MsZk3l3MNUUXkmLS1RLiLx4ZtJdl1mhIi36rqVedohyrCexLUm1vNKv1qss92Nh8W9hF6wH/6oq8g1+BSuQ8ZgcYmjSuhm+tVid9ZNsuxHqDDcM4w2DIrm+hQ9aGJ7Gg+OokVtV7mOQt3wkqnjMCgMwA9FNbw5OVygZsz39LP3u/rOWqNOEsRLaQqXzcMRHUU9VZoPYl5NHj7pftZA44iWWxEjgjbVlXJQFYCggIt8Bd/fCy/FjRJ6e/chNACJqtzZZEA+sQ6x9i/BXs94jDXeCzDdailS4mgykb9e165Isg9/bHJyCvuAeW7v7RxoZ/+3jfvlwURrIK07Uq9B1vaZJLJ2/nEOoFhr+6YOpjhblRzZ7uEk9WwJ2pKeiQ6tqTSQSe+9mozgKR96DQ735YaPF+XInpQcz2NtiCrbJZC6BbxmuuAUhNvLncDtimbY3LdScFOBYsw8GKdQc6UAUkxIBAThkLmXFwpLnelkcnmDjxN0FXu+eD+I62mUwWcUgplurTKV/GpJg/7MfU7icX7OynOA91SI6lv6u1ijckMmkcPXCZJKSKBmf/09IZGgJ4MDb02Vwv6A1jyIxsGxDCKSs8dxcKsZYjMcJFneI8tRN2u18rgeDAZ4XFae5b3N+uxDoHtuE4pHYp/dlYW7OA2pmiL5+dHkiItw4g+bvyI/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(66556008)(66446008)(8936002)(2906002)(82950400001)(52536014)(478600001)(38070700005)(86362001)(54906003)(66946007)(4326008)(38100700002)(5660300002)(6916009)(186003)(8990500004)(7696005)(6506007)(122000001)(316002)(8676002)(33656002)(4744005)(64756008)(26005)(9686003)(10290500003)(71200400001)(76116006)(55016003)(41300700001)(82960400001)(7416002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ouk4wtNwbkmitqpN8RObRtNx++k7gVCCnY7KAyZHrhKTPw29WSROX0kH3g7V?=
 =?us-ascii?Q?cSCmn2JkG3kZ/Z5Efw/4ZzwC1T9AnZgfzgsulSu4sPZ5pD+nRAEFgC1EHtJW?=
 =?us-ascii?Q?KwZLF4BitcnGFUCe3MYgCCT50Jq64O/2cc0GguL+21RNlMT0fn/Nwvm17CUc?=
 =?us-ascii?Q?rfopoA2OZ6pdM/f9dVx+JymNz+vKrWayWGPqnTi+fS7Nl4eo7Xo8gf0SWonC?=
 =?us-ascii?Q?5XIwnAtZaG9PeqIX4pXtfmpjMy+K/QZ01EHj6Z89qhpFQLZs8KKLoqvMrPHp?=
 =?us-ascii?Q?R1RRqdYP8aiBfy3bmAoC0xfg4xxWmBTWiNgTGgFDtdK9V+iAIuRs3hec6mgS?=
 =?us-ascii?Q?NDJ9xTQO33gsB0BmFmJxk00y36m8rMClST5cnGLgfJ/qyusmI7sqot2c8YEb?=
 =?us-ascii?Q?VukBcsAeV81OHxy1q+aqhGUpeB/x+nyjWb1btaOEEpUQJmGEE1enxcdJl5a/?=
 =?us-ascii?Q?Eds+peeu6VAPk/WRzg1PtNQ68JB6IUbZnnkXFuWe+kVN5PPPu6Xpu3jYsDQm?=
 =?us-ascii?Q?UcAhPRLwxKRxi341POImBAIw8O3ixnOGQKtb/d/XeUQFr0O/nl1/DMLKTOxL?=
 =?us-ascii?Q?fTLyhSPs17iKwVLON6yuC4e1Pf3+URPEdgH4VIKTqpOP0e3awztwfXumFucX?=
 =?us-ascii?Q?4+yqKFyYfnQyqv4M91Y+0DG3CQlCyuB+aTY0fJHfqUacxax9phaEcN7fVihm?=
 =?us-ascii?Q?5EV95IzhN+9/usl10gZIJKbqzGeXbE6GRqChxJKt1YMTVqRFyDHAAZVJMkTB?=
 =?us-ascii?Q?qylYNshzTecNSydY6Ahj8Y3QkP2ZnLLg13ghj1L36ox+1z/8BP3NopbIzMVL?=
 =?us-ascii?Q?GS8HtnSufdYgMbvdP2Nf4OygTyz+Agczo9SqpzCCM5jsrknIItj1qPKOh47L?=
 =?us-ascii?Q?F/Uh2kH7v38nYhNcaFdCKvqKsZh0ev/Igc532ou6INwfF//1ycYNMTvZoEby?=
 =?us-ascii?Q?+tsDF7xv1hK64piuAAhagU86S8k1jlrE/3Hvj29/y8BsaHyaUyIOOO9xGOxv?=
 =?us-ascii?Q?z1/ZVblwnOifhbWR/Cqh44saW7SCT9Q91YYuyyfCovNI2Ts909Y3brnf9Lq4?=
 =?us-ascii?Q?O7jRB9cZ95EMk27RgBgpDljJaXco/E6RvHw0C9HqHknJ5oOxX9KDdtP0EFOi?=
 =?us-ascii?Q?qy/xzpkFOeIgzsmctqsu9jQZXQwyZJCnk7378cGZlzJ2LGohWkMxfa+uLeim?=
 =?us-ascii?Q?VdLN6ZJhpS13McL4+K2yB2MW2fX+EzO8U++J1URndyS8iNE5iQf7jKv1lXeX?=
 =?us-ascii?Q?deQBNm4mlUd87sJr2gCUqeyX/LdHwnJv6Kx4sSNDRnkIG5dnVo4fU5HMmtRW?=
 =?us-ascii?Q?+SRxKLcT7y816MdMGL8te+QQD8aY0F49TTRG2f3tHYJVog/Sqg3XKqJgDO97?=
 =?us-ascii?Q?w08PCCEMh8wnFONZprp+hTPkCtPfqU/gCCVMaHMXuyhJgDYWB8zdltSw/nr5?=
 =?us-ascii?Q?laB/CB47PKalMqI77TnKpEYx309LAZh2zSj41c02uqf/lz9xFLMbiQpSX+iZ?=
 =?us-ascii?Q?lmNgbcuAC/HpsgJ/z09yC47ODrjuCWAMszTjg7LV8Xe+THMeEP5uavRd1KmZ?=
 =?us-ascii?Q?kdBRuhUm8yX5QVC1+PeHli6p3yzuZ8ru35pc8H2G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1959
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Nathan Huckleberry <nhuck@google.com>
> Sent: Monday, September 12, 2022 2:44 PM
>  ...
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev=
).
>=20
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>=20
> The return type of mana_start_xmit should be changed from int to
> netdev_tx_t.
>=20
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: ...
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

Thanks for the fix!

