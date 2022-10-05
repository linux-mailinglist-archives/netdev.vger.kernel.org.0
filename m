Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3C5F5987
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJESFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJESFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:05:09 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021022.outbound.protection.outlook.com [52.101.52.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4271EEF4;
        Wed,  5 Oct 2022 11:05:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFi6iVMTpTw+9Eeubgl97EPw6z1kW/4Bpz7ND7Sp2kPFtSjGUEQ68cd9/F5wi+fxNSeuiBzrp6D5uOSzPZlLPCEhbOiTuc/hLu24D7K4dH9qLVIPBLGs0DllsYT9KYsHC0KGHa/4Vgd3zkzIzsGnZp2S7dVqIaYvydxGitbY1J9pFosR4u3yNQTdbGuFWv7pWstPbRYQnD9rUpHoFu1xDsY1Pq7Xve5OkvKm/XZl53Tv3cZjqI4NPrltiXo7mXpu8EsMX4KmA6nq3JgoK/R3ADkq7em5LnjkBN7mWMenpPCpZlyvDl91cEaesWpH7PTgSTUxP2RWj4O5+Ro5QasZbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jd99CkJ7CbBagZTD36qEOzsCN/vvGHgEeqQ2nAlf+6E=;
 b=DQ99kV9cYq13rM7npfv4ZDlhPX/nbTdjJVhJpKla/JhiOFaN6d3C8FqG+5kbOQaxd/rq6FVouce2BbKC/JUjkeqv+XDN9JCMmS8bkjIwm14C2rN4W5s4WBaw69RQADMp2dAP/xgYHwJ6wwwf6EsdSnAUXdWUL3vmcAuKIsviEkSA1I57xBHO41c/2U6XsVgEnD5M2dIyQwhMFf69XiVQ42ePftHNsUPYlQST6D9NeB+8NH5OfenNObVt1nPuHvU8xVjD1+FOHGOoa0ZCCxmkyAIgLI1nDxIJAub7XqWgI0k7B5q3nAfi9rX6jWMsm+05xqcX97AcBiJOQivxlvRSrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jd99CkJ7CbBagZTD36qEOzsCN/vvGHgEeqQ2nAlf+6E=;
 b=W96Fb7C85+MaSONEeeKNwyQBvv7VJxtXvbG9RLHh3wr49AEUV9hknf01PjOe0yHVDtGcDVZz4R8n72JtlrBAG8Ks9+srcRt8lLk4KLjUZTE5CLtes779w6u7Wcrnv1a5gs+plmBBeRNSHHe8uxgxjDwUkYR7xvz7FagEkTbh6nM=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SJ0PR21MB1917.namprd21.prod.outlook.com (2603:10b6:a03:292::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.9; Wed, 5 Oct
 2022 18:05:03 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::f37:a401:d104:7fe]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::f37:a401:d104:7fe%7]) with mapi id 15.20.5723.008; Wed, 5 Oct 2022
 18:05:03 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Gavi Teitz <gavi@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        Long Li <longli@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: mlx5_init_fc_stats() hits OOM due to memory fragmentation?
Thread-Topic: mlx5_init_fc_stats() hits OOM due to memory fragmentation?
Thread-Index: AdjYTuisHoBneYtURaipjhj2oD9KAgAk6L1HAABt1zA=
Date:   Wed, 5 Oct 2022 18:05:03 +0000
Message-ID: <SA1PR21MB133560BCF51CD96CFBB4E36ABF5D9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <SA1PR21MB133523FF1DC8DC92FD281EB6BF5D9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <DM6PR12MB4220914DFD22F1BCADB7FE8AB35D9@DM6PR12MB4220.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB4220914DFD22F1BCADB7FE8AB35D9@DM6PR12MB4220.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=36f8eecc-7a91-4d34-a9b2-39a3fb7ad8d6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-05T17:59:49Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SJ0PR21MB1917:EE_
x-ms-office365-filtering-correlation-id: 485d0f74-bf3e-4aee-5093-08daa6fc20b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AquPi8rz820ZqrFGHBFDe7QdofCbE69cz+TVr4wZBZwZet4hEElCf8pcjSA8qr1I3iHMHNQSVTzgwQR0CJ1MFrO1h1MY3kmOUFuB2zp0/rth1Dp8hrXXbpP5FYNfG23LOdTlhKNIBNXXLreaKHKc0KWigmEMOx3Oman8ANpdUny3tB8ytV9rZAJUSdgn8O+YeWnepL+Fw1gowDC//UOjR1UYF+I17N59Sa58nj5HXjBvFXOEn7JGEUaAvMvVOpr8RlEfefZQs9b+BBfFQvZH6SG/cPNC+Q0YFObY4N5a4KMYaQNv0ylDF0z5eqvQcPqHoHm5SakbqCYmkbjntkZj1Epfm+cr3NJiucLAC5OY+VDcWM61gWCCC3TMCn9GrWKLVPWm4pavNfkOTcorTdhm15HTL5geNnDA8a21CHKniDACOyDwf7S/7uKS7gu8plupAFLq5AqF5Ym20FtYhancu9ExZWSo/cBbHmK2XEYq1KDS6u0QXUAxVqArBVPoM7FnZ6GMxB4RNIvbNVl5qL8GK1TqT9/PTN996cx4RLRT6Uc0kDygh+LSlrmtz1+4s+KzaQ3aPgJ+wHooKhuzAdPoYTGSgyTGlcqbpYV/xCRzlOdtvPPLJGelYYerbMhIqvTIGRkMmyvVffL1KZb+GH24AdeMafAYLtWjYOctaATPZf+cTDDjVqqE9Cs0hd2EPDj6iUSb2a81vjEeD9511mdVWklx6c4k2srvicPlRc5aS5Gmym+YMK9tfpIhyCoTup8Dcv11uf7Wj8TjKMyXs26eXyGyKSt0XCEIk0eJIijReQ9ayTjs8JWTa7KcrvJbq1ML
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(2906002)(478600001)(38100700002)(122000001)(53546011)(76116006)(66946007)(8676002)(4326008)(6506007)(64756008)(66446008)(66476007)(66556008)(7696005)(41300700001)(55016003)(33656002)(10290500003)(38070700005)(82960400001)(82950400001)(86362001)(71200400001)(83380400001)(4744005)(186003)(5660300002)(8936002)(54906003)(8990500004)(26005)(9686003)(110136005)(52536014)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pXBYshBtnL7LF0xz6nSaBcykSeIfwT80cuC8v0XR433ZN9PnK04+ME37d3jf?=
 =?us-ascii?Q?tLojxrHz3IhQpTXbqed6XT/YbWv6gPqUdLVdhEJ6W4RO3tyKrAg8+xtAF2uW?=
 =?us-ascii?Q?Q07xM6O23CVCuULnYQF0KCzTQ2jKjcRUawPQY0x/iP7xqHsNDCc4VwXZC1Ax?=
 =?us-ascii?Q?2IoJ8p0DREejvq/PVPRJXHGmzZDdyOlX2JU9HurxidGOXUWaH9yypypmUBtw?=
 =?us-ascii?Q?8ddZw6RQxZr1uN8S8zJS2ZdI4tURx4+yenQ8iaU74OmyC2fEUd0ms5hpS+bY?=
 =?us-ascii?Q?QuOd2sBfbTJ6/+1E6ycoLUoN0PD072qm6bO6eJyqXqQAG5nv5nyYp05BESnR?=
 =?us-ascii?Q?7Qm1hCPOO/kkCiqTw5fdmnu0KAbpjxlMkB1LfMEI5KYihSVA1P4Qf+OwLRr2?=
 =?us-ascii?Q?JQHtY/Kk/mbziWedN4W7gJ3ipRbObA7DA5meiHroNQYXnUwEFxBPgRyMzK16?=
 =?us-ascii?Q?XGXOqpgG+dkKtiJzKeFLlpgyLLKKmuIK3F36ff0qUA2WJAX/YJoaQ/ZM0bdY?=
 =?us-ascii?Q?iFRRWQdTD9qSlyfT+QCKz3JxdayzGQdZSNVsu6eK0U8ly/f5lhf+gpIiW3GJ?=
 =?us-ascii?Q?JnAD//id7kxsxaiseEMwG7vReeRohTpdf934y0wSl9EYYGrIca99fCIAvO+L?=
 =?us-ascii?Q?LfNT9h6fjGqbnyT1xRKYRbByMXrti/kDLG/7tNCVddMRNafTagkr1u9Wny8P?=
 =?us-ascii?Q?AaFN/5ul6r+aNFURZAwCK9iuyQne7NUzXejqzb3pFU7ZV+t2G2phJKyykZUy?=
 =?us-ascii?Q?aBZz7/tC7+9G7XWGjFEFpRNxtptNvmkG8wDFm85LftiUVzUxQJLGsQjTaVO0?=
 =?us-ascii?Q?dPx3GHw7O7F6muPvEMj/9E3f8PrZlxokQ1CHp4qUu7YEkFHFxHGQ9Be6aG1o?=
 =?us-ascii?Q?eWAorW2aiR9q0utZjbyVthm7OWVhhNyAt+1pEfXawjemuX3l49t+JkTMe/SC?=
 =?us-ascii?Q?ZdnU3XhW46tzz+aDDRjgVqUM9IMfrc8NAzAhjYabBtJInooIGSnm1K7muL6k?=
 =?us-ascii?Q?dC+htu55mrSR0ZhO1+yFe+jqBNI4pMLBrKo+CHMzsPXUXaW9Nm8zvGKH6jHE?=
 =?us-ascii?Q?fM+PDsi8ShZHep0Z3MpzJudpuLVitEkqNbGMLYM0cSmPWYazb+wCCs+b9E5t?=
 =?us-ascii?Q?OlkmlsHrnFRTKzmpsuw76zgB06flLpEoZ0y55MVIDqEcaKY+2arr9fJfVdgy?=
 =?us-ascii?Q?xG/An73aaD0qqQ63AXKFKrPG6W2EtKxUOVA0MUef/mTQ9iulR3n0lqfxOs7Z?=
 =?us-ascii?Q?G6dBAcxkMd/Q/J51HtBpde+S8jOTMaKlsQxkxGz3t7qn4/JGg5FafCAgDaIo?=
 =?us-ascii?Q?R/m8CSXk50FK3lzPhKVvdRPFxcRJJKWrMmfeREdq1e/0PSFgn1mWlivgZLtf?=
 =?us-ascii?Q?A+sxGwS+kR71MZ3NVg/+GT6IjhJeShTcB/UcZk3tXEn5NN8Jomf20Z8M+5Uj?=
 =?us-ascii?Q?yA84eFMzQxBMbdMUEcUup8Mq++oFdAseMy6pPn/v1KQ+wI9+DwzSmY0zzTpm?=
 =?us-ascii?Q?/oz+n37k93P879iRVnIW60PGSeD5BsclhOtkkTXDjyRvvX7m/VNyJsva4RjJ?=
 =?us-ascii?Q?Ldd+CubIQANdpDruoWSt9VRONi6oBbhzQol4AJbL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485d0f74-bf3e-4aee-5093-08daa6fc20b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 18:05:03.6666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njTjuGGTE1gslPLoEytYEJBg9UnrFTOINhgc0HC4b4FvHVwg2HuKXQ937ZQFJWVM5SIp8Cx3Cqqx6WkatkYClA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1917
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Saeed Mahameed <saeedm@nvidia.com>
> Sent: Wednesday, October 5, 2022 10:50 AM
> Subject: Re: mlx5_init_fc_stats() hits OOM due to memory fragmentation?
>
> Hi Dexuan
>
> Yes it can be vzalloc.
>
> Most of the team will be out of office until next week and i am out
> of the office until next month, can you provide the patch, i will make
> sure to submit myself.
>
> If not then i hope by next week someone will do it.
>
> Thanks,
> Saeed.

Thanks, Saeed. I think this can wait. This is not an urgent issue.

Thanks,
-- Dexuan
