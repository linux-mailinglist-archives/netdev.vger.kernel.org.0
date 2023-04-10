Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8646DC428
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjDJIDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDJIDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:03:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2136.outbound.protection.outlook.com [40.107.92.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA40540EA;
        Mon, 10 Apr 2023 01:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifN6FDdfR4DzqDCZ8Xf0kBOlCzBKTdw+l92MzXaot7ta+dI9ybdg4DstpzSD93BE4KNyRxJ2/bRQrJPvcj6s9dEwZGKtJDMdrM+ckasflaNZ6YBqi/FONuPqPmVNo0O8AB1w0DelXh3/tT4y5uU2KKDlQ3v7QbdbTrCw8lYDBGICc+lJZPIBHbF97jnJjXZzyLJmwZ6FhYPSa1LY81St4dLYUVujRSDUn6DbttL1Ah2bqBlfJPFWov8qw+BDunJH7RNQeLtvu4/3tCWEGjZSJkVa3lZYjSdsVMDuxROmwnngFat+DooK4p18pl+jNYLAYNIhtoXfU8UpjaFT4LAjcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rzQaAz2nuTRW5MwOg4TLWMAOE8UpvF6OT+HcO+3dlo=;
 b=Qr4T8C/0pnKVuJWKVdnZ6+rGK3dvosrwJWJoDD1pSFN2ZVn+CNb28TiHgpy+/7Fmjhy+QiTgHk8o+1QNW66uy5VxOpFHF0XLmGlIGfPgmbXbjd72gsnBz6HqpT13cWkqmyB9k9xLmVJ7KDEH98wlS8+vP6lfBtPDB0Ey31BqccpUH5oH7wlPcanUxj1eE0MFF+zFQpuJ7IM37mgoewkETUkUhucvgef5yzUl6p9TYDP+YGT9BPa5wgGSQwYk2WpzzMDDuznFN/8I0UVHbplq34w2iJE+pPvRYZ043OW0KQW78FrV+m6fgdhZvn3L8UNG08z6JS0OAN38MMv/jXMz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rzQaAz2nuTRW5MwOg4TLWMAOE8UpvF6OT+HcO+3dlo=;
 b=gw48oIdSoGdG+LZmoxYI/L7XhQYa4qM66Oy/d5iWq7byHSs4qQnirRC0AGGvSIFHWRfavDucKMMEKYRStJ05FLjagZ2/CGP6C3nwzE5SStTOdS8vhV3n/joL8Z6n3e5c8txag+oeuZ+FKQQEDInIyx1EfLOsiZMSXTr0m5KDxlg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 08:03:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 08:03:32 +0000
Date:   Mon, 10 Apr 2023 10:03:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Lanzhe Li <u202212060@hust.edu.cn>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bluetooth: hci_debugfs: fix inconsistent indenting
Message-ID: <ZDPCztXu+B8N6hqP@corigine.com>
References: <20230408164542.2316-1-u202212060@hust.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408164542.2316-1-u202212060@hust.edu.cn>
X-ClientProxiedBy: AS4P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e09a44-c32a-470a-5254-08db399a13fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pi1hkU3UH42BLU8Cl0IQ1N7TJUnSsi+V37G3D6MQGjJ8KGV3ve2N6dmrP7c44TcMAUG82LG2bc9y5DCiWG6QEBLJCuBo2DLEuRpyQnRg/f4FHlC9yYi5hYYqinmJ95DOEiuUVoe/Ul8cAa9QaAmPIH4JdlolRXBcUN+vHEYeJ1rwZj2/XKPV+BZiqG0HIa9NHDs8f1CBZD+5eUB2MD9f/5oJyYPTWG4AETNJA6iQ3f1XRQAFe+elOTdvxl2jYZ+HY849vOu7NmoNGkEMkDDTeBEmwUqDfQ7q+706sDAcDZwsfMOs2Zcj8YVfHUxqzTPYN3BoJGg9SNcuhnq3JpG4AV37dytLj2RRE7668dbsprzKtQIOQO6PlXbv9q87p7dyvWbe047c83BtQUFFpxXyVWAU9nRU49A57tgWpWsp0mhU4TADBa+LI6rvTbv9Xe3hyTJCcLJlnTJSr71b8+pPBz4sxHpbrE30wdpZTE6DJMChHQqZyYbKSugoevSBC9Gx0gxtp9CkRlrhFc00mGpDrLV5C+9UVCxBEl/+i9mCijkICLH+XjKkraL803yW+1iVKfvsJ0BuN9MEF8Qi28ea5oz9YOJsjJitjZoZNriyZc29nOjpKEKsP+P6jRCh9l8y47kpHaPKJ7EXnRReyyfwp4WI+vdRk9dueuqgOkbBJBM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(346002)(396003)(376002)(136003)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(4744005)(2906002)(54906003)(316002)(186003)(6512007)(6506007)(44832011)(7416002)(66476007)(8676002)(66556008)(6916009)(41300700001)(8936002)(5660300002)(4326008)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mYGQ+JgMxdvWRr1ZOZ2Fk7baNd/qEBRReUwv/YxEa3Px2NIE1sL/LZLer+e0?=
 =?us-ascii?Q?Qo4tjO243Z6+RJuhSfTe7LSByWfhhotaPG+m3EFpfu455urq8azkgPrLiVjz?=
 =?us-ascii?Q?JwPB5/KPoomgMwatXSzFQqUl72KgDylRs2aHLHCkn1Y7EhCBJuiFXtMz8+9f?=
 =?us-ascii?Q?7qNQPEj1JZNEh2lE2bipoVl4bRDWkma/T2EEpqH1NTXmBvG0//UvXr8KJEt6?=
 =?us-ascii?Q?sWTphvo6hOKEoCRiTtmS0Kp8yo1oXjTxEBzGs1/H7CrsCZ2wlRnhmW0CWy5s?=
 =?us-ascii?Q?IzUSpGlmWZHaSUElvQJOrHoI1xHidmuN4c9+k8YI98d4AQG9XYzCnmNs/iSP?=
 =?us-ascii?Q?Bu2b7M+5rt3toRF3Hb628srcs28fEncSx39SAPedfQRXGJlomEXLYSUapkgY?=
 =?us-ascii?Q?5GXhNRUJpJ9x8t9PgVbabxkQukepJR1YkRhRG0ajj9NWnolv+RmmGj9CWK7a?=
 =?us-ascii?Q?SKX8eVM1KaJp1pxddZxUa9bAFqeRKRZzMHj2fO+jEpFZT7Qjo7rs3AX/gbVC?=
 =?us-ascii?Q?FdQyzHkWdFtTQyEdP2SpZr5juGE+JX7XC5bjdYyR0mE9yXWHuXXIpb09mOEp?=
 =?us-ascii?Q?QGD6KIT4+cj3QBDLE7YVetMH5xUz10ktAlCVred0AEHvsN+cQS+N+cU0+sH+?=
 =?us-ascii?Q?qzBsl7DQhfGRXav+lx9u51LTqpmlOkm33DJyGTx/I0arI/b1x+q/70r3Vmf5?=
 =?us-ascii?Q?VVDpFwCldEFcoxSeDiZ/nwB7RfY+TZxpV0btB+9W7bbhae+jhRfTnD/QtFlQ?=
 =?us-ascii?Q?M6Jm3CgLQ5uQw0HNYXg80zkFXlmWLtoBl5OLNOd3ip2AHIblneD+X5oWCN72?=
 =?us-ascii?Q?KFIAkPKm8XOoxOugTT3dItuOOR6M1JmSj3KzelA98aash69tGhBzijblQ9cX?=
 =?us-ascii?Q?s++jyw7LCBjwdP//jyaTlpTCIlHOn/dXfPwfIbyIiUpQbzOpxUOaYX5SO3PA?=
 =?us-ascii?Q?arCFrVxEjpJ6lOMVFMVCNbcesYnhP8WE69H+Sf47zBPBVE8ScsAETmbSFV+K?=
 =?us-ascii?Q?Bi4kVOH0gAjwQt0kTJpsYjOnrb6UySYgBqf44NIZH2jqVWND77LMO/5FHk8G?=
 =?us-ascii?Q?3KhdIAyLl+TEX/vwnwXO67iXXvGjX5w+Gf5ZU6GKFeXAVIrL03FAe4dy5iWY?=
 =?us-ascii?Q?327RkagvQAaUhZ+wQw/00IJHq4kA2/Xb36aZdEFEUdabLsXdR72hQmrIlqHf?=
 =?us-ascii?Q?D/8WDW7ETcAYlOLEzhr8syGDewiOE23yWqEwKy69vlil+JazC4KMGEDUZxgA?=
 =?us-ascii?Q?rah0H32EljxD8WSiEkjO8hk7F6qCiwBXAO+i8XFOxl/tjc696QLc1qXEjSPE?=
 =?us-ascii?Q?FfASU5KeLSNDeuPkLZURPY9EQ3mYt7zQ6RXy+WGEPVtifxNT61x0Ok2RMCJX?=
 =?us-ascii?Q?L1UO69FJ6bhK2fDomnOYt4fCWAlmN6SMNp770Zb1rhKqK0G5KOreQRigoJeT?=
 =?us-ascii?Q?cQ5+a2igAP5IjiTCKTIqW8kZ66Ywji5opmycnaIr70wn455S4VtoPaa7Nkaw?=
 =?us-ascii?Q?0Hljp2DKETHd84NDTQ5arpILmXS2GM/DIfcgHnSzlLf7zkt9FPz7qxfKevIt?=
 =?us-ascii?Q?itE7ukjq6dKkHckTJlYoLRqu3dqrlkr2VLz7W2UmB5Ve3d1ZTJy/nqUIWfCk?=
 =?us-ascii?Q?U14j02W+POEKL2XImWLKxiF6qlpajCDIyrlwUtUQRMf2TIrhpfq2xHdNX8nV?=
 =?us-ascii?Q?ld4c+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e09a44-c32a-470a-5254-08db399a13fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 08:03:32.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2Sw6mSYhvu3SxylidektMKxEFrrSztaZleLHRklF0tmP2paFGmQT02srNcr3PFZLEGh/veFosxydzxz3PE8Z3MSGNNy5/jDZMM9mEmTgHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 12:45:42AM +0800, Lanzhe Li wrote:
> From: markli <u202212060@hust.edu.cn>
> 
> Fixed a wrong indentation before "return".This line uses a 7 space
> indent instead of a tab.
> 
> Signed-off-by: Lanzhe Li <u202212060@hust.edu.cn>

Thanks,

I checked and this seems to be the only instance of this type of problem
in this file.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/bluetooth/hci_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> index b7f682922a16..ec0df2f9188e 100644
> --- a/net/bluetooth/hci_debugfs.c
> +++ b/net/bluetooth/hci_debugfs.c
> @@ -189,7 +189,7 @@ static int uuids_show(struct seq_file *f, void *p)
>  	}
>  	hci_dev_unlock(hdev);
>  
> -       return 0;
> +	return 0;
>  }
>  
>  DEFINE_SHOW_ATTRIBUTE(uuids);
> -- 
> 2.37.2
> 
