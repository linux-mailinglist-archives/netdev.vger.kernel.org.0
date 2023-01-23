Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE2677C3A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjAWNPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAWNPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:15:54 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2104.outbound.protection.outlook.com [40.107.101.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24392412D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:15:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1ZE9SFVN+3nlXQH0cyFk0M8HmL3Ruk6yd+XYEd/51LCHCNx4TMPcub6qCz+v4KIzfXOcwsZmldxH0UMxu+fOqmfgFWaqIlxW/YhJ1a7XeCoa26CQSqPmVSZxq1064UVdHH1sB+gfvGbV4Z+cQa6QnpC7mrorFVXznc88Cy4ZbPvjKBV0KM5btemKj8n5ntWyM9PNYRIxF3Kd9ru8XqQUC33lZpQvdjjhlPYck4CtLOxqyp5sjaEcxRRiLWFjMwjcT/QYMabDLzKdDjvE8MO/AyepX4bssoE5aMM0phBoaDYrmtYQHmpMVcCdqerG93B3WpaMYQq7ZfHWYac8TXAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebRtVnwzIoumouEZOpD1q88WEDqhjxNXjYb+tvzv5Eo=;
 b=Mre9wnJV+S8p8ioXVdrbizWdb7+yRk52yFrhT/di63FK5HcgQOEobMd4tbNFqLMsdVwJbXBPUcVQ+Gk7FUZa/qOZexy8GgV7s41Wi1SMRrg/+LZK3JS/BdqKrH2/oS58aZh6Z2RWc2j2UDa+So5H8n/gP71zWyxJBsrSx04sKN9lFq/R1J6rNmM50YKDOjb4DrvseCOs2jnayMqEGPD55HjP6HulEha639vrSC2+FhCD9c/poiH0oslCSXSfbOmID78Ko1D/i4WVb5qSG+HlPCUhqmQjPNn6CHboE+k7EN4doRUi6jIvsjsHVKhUjbYSswWyc7pGVX+MFkLj5KMpCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebRtVnwzIoumouEZOpD1q88WEDqhjxNXjYb+tvzv5Eo=;
 b=f+vs7hMyiar8MRji6dwh75jlUiV+7iQ5z1khoYY+jG+3T/IcFxZHxrTkVEBPvkm938PA2w7ODsgo5Ex7rFynh5ZMDg37cvG/KqF+RyjPBLs6xtAAIbcMD/gGKEB8hnBucgpChDoIJbw2Ac/BJm3AulpGVbbKZgRIHZekj4jjqE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5774.namprd13.prod.outlook.com (2603:10b6:806:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 13:15:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 13:15:50 +0000
Date:   Mon, 23 Jan 2023 14:15:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: support IPsec offloading for NFP3800
Message-ID: <Y86IgKLKITyw0K9E@corigine.com>
References: <20230119113842.146884-1-simon.horman@corigine.com>
 <Y8z40Dt0ZiETMurg@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8z40Dt0ZiETMurg@unreal>
X-ClientProxiedBy: AM0PR01CA0138.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cdee97a-882c-49b9-e0f2-08dafd43f28b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfsuCH8FpQ5Rl78/onrIk5c50hqqHBOFgclGbTHAcmW72snFFqlCIeki6ACFY2F5aQ+xqlQJTLAcYCBrt2hXKzh3TEmFzh0YnJJ+qC0RGtwWnbZUx/zu5raARqt64ZhSpp1Mf5XC1xGJTn8R2dsLSO0AzSWPtCjMGrciXzQ6Y8lh1FcHj3T9TA4XklNVgUP1Blzh4gvqQtPhu3WEHYurNYsjjgkCMk6/xPMsYMLme2yA4V2x5IJglOleAhUlgLlqk5dtCJpTVze8cp9S6sXKq/6ZYaxYZ7BF57e6x3biJ39xQiDaejPb7XfW4MN6TsxVhKNTbJR9zaGNPOQ8YOcldweeCT2O2fjLedjACqcDijewKX/8Oh6yeChTpEpZEpejVCpZXFGRij5kSJLT2v/MveFeWQPRjeGqk+uQEYPW0/TDL8zVK6965fnvNFQBirD5p5O+Q2pgxF1WT/n+JZ7uIoX3zy/LX+NQBbboM5BQluwb5Y3NC9YRGjVMQQi1559gEMUDu5Q/nQIbXYxEnBsc3uTAlJbMsWXqotVr19JgBKEKrBVRPTFmo6saZkZsrPBbLrJjizUp6Ft90RZ8aU1M92kltREwPBzSqRCWntK8adSsbV6yYepDZbSPgVo5Arz+/jNvw0qvl450jJfwXVPCMFDqP0mitP2lvHIw44XvCi7KVX0jd1XM+qEQv+oZuLKBCR8fyMgWBpnB3sj3DozLKfggHdZ4+8jjcihaAL519Vhsf+hVdRNWwuyUYstN4vXt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(396003)(39830400003)(451199015)(86362001)(6512007)(107886003)(6506007)(6486002)(478600001)(2616005)(186003)(6666004)(316002)(54906003)(66946007)(4326008)(2906002)(66476007)(8676002)(41300700001)(66556008)(6916009)(38100700002)(5660300002)(83380400001)(8936002)(44832011)(36756003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TEag04/djuo3AcfIQjTJn4xepHXXFMrMS3qNNz9HKW8Aq+BTZftTPTudmKa4?=
 =?us-ascii?Q?LZLKEFX/BghzWttuEUa3tLVmR4RTEKd/JVu2DdUdeUxl9k+YTPcvFhDV8rTN?=
 =?us-ascii?Q?as5Y98HG+hJ9613jIdQ+cB9ZmYRtmXKrtKV3RGhkr4IO3KGqSpbrFD5JuKUl?=
 =?us-ascii?Q?TTFWfMVuN/w/bIi86RU+L8dj4hOi11W324QR0N7+UCbZ7lewZC6cslvdKgYa?=
 =?us-ascii?Q?IE4QmaJRCDlsR5slteiXhZEyxk9oCy59Jmtrf6VpVsdhm5WDOiE6LQJWEpv2?=
 =?us-ascii?Q?5ks1Caf2kDX6XeA2g3K0tIn8fuBn0gZ7VJo/LHJccPCiJBOPQcAQdHb4ZMxE?=
 =?us-ascii?Q?/s5sWPZuxSs2RrGgmUmP3b1MnhqqrKJfajYoi01EeDWbPZzwXVHi2zG/SYGV?=
 =?us-ascii?Q?zr3QumUeWGf01fwyNIMf3RT2VQr0kq5+mSWALfRMRDArxiBDQ1EfBs5rb5WH?=
 =?us-ascii?Q?hUM+MoBr15dYqxc+YLjyJsO1Vm0z6faEznhspmbp2tcmX1xC8LCpLwixJZSr?=
 =?us-ascii?Q?wlmqEeV+NphyjPpOe/hHwtag8lX3aP1ZFAL/iNJ/IzU1oGnDCcz8R71NvkMj?=
 =?us-ascii?Q?lmJyyEO1O8FqIbNkUwlRk57dUGK02zf4YrF86P8Hh42C5P1Kr2+0W/vanlUM?=
 =?us-ascii?Q?L9m11CEzllUQ6aXcIKD6AdJ64lSqLplatI7ejN0+05IOu8EKyxXw7DmA+Raq?=
 =?us-ascii?Q?yTNmbt4JlLqhcFBYVDao/3fjLCSoUtjiGsdDnTtL01syBwrG8tK0AbU9TAsc?=
 =?us-ascii?Q?Rj1hCO9b/RVJP/LMFLS5ydi6fPSEQvhsW/ErlYgvFkrXp3GqsGtN1UPZC2RO?=
 =?us-ascii?Q?BlFLDmik7TBQcS3ZI+JjXyQhF+X58mxT5CVrksoHGWBUg5rCVp9BYg+byWPZ?=
 =?us-ascii?Q?4ZXw+9W23n32N+xDvqJNY1JPtQNu45KpAqJVxtq9tP5yCmm32g1RWJ9rgYw5?=
 =?us-ascii?Q?Z7Ql1scJd+T7GnbJyeb1eNefTJz9jCamrg6H4NaBkiHUsDI+PGn2xuTXnDrV?=
 =?us-ascii?Q?cPHujbne53Irr4j28c5JrStBoygrqiU/Y5eli3H2seXuJB7Xwqo9igAwCyxC?=
 =?us-ascii?Q?mZjYVnnsGrLyLcjDhwS9j6nVJKrPs86k2mluv2r94TKVJv+/R/h9MH2P2db9?=
 =?us-ascii?Q?GTgxK6Gmif69INY0O+k8ZSmaB3P0RPDP82sSl8BkAEVM3cD9G1ifyMpwaWFy?=
 =?us-ascii?Q?nKouwBoMTkfoLu4qLVs4BgUVT/eECBLYLvVRHoDIDVfV8pfFu+Hi/wXwpzUP?=
 =?us-ascii?Q?oTV3USOgkf61ujRx0bzVgHS3G0LjltcHVc9yxY59NzrXtpcGSvfc0Qy4y2ll?=
 =?us-ascii?Q?AQI46L109NNwj9ueZir1uBcVeiG8CVFVI+rcx2oXfp8IJF2ke3VjInDmH0z3?=
 =?us-ascii?Q?Mhw76CDHwQtRahjzln5pPdpciIHpE2HeG8dqPT3/3HsZR8mN5acesBjA205p?=
 =?us-ascii?Q?2wZKMJU7EMzhdoRtc91oKgY4c1+Ba+1hLpvGC0GO/G6UoixsVsPe1TMxp40N?=
 =?us-ascii?Q?3eJ1blGVRgWeYYSsMA303ememAbn5LdZOGt+YjL1O3ZWliEKz6vIIPJicG/l?=
 =?us-ascii?Q?GexuMpjwLYjplwviyF5v60euHNXmCtNjp3gPNa5ZvceauP5kohw272MptfJ4?=
 =?us-ascii?Q?xps4zOyPfTWjkZDGRy3XzrP/j2f1Ed+7r057tvda1j54pZisZt2ZvgqMOU/K?=
 =?us-ascii?Q?rnvd4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdee97a-882c-49b9-e0f2-08dafd43f28b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 13:15:50.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELsPXtqmiYTotE+zcGl8QOSZbCz9OmV6pKh+l2tMZ3t6SsNBxoZl9YooHvO1bJ7C6gqQKC77HOW9wnW9fYtka6kYLxz6Wcc4oUK5lqqI1J0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5774
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 10:50:24AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 19, 2023 at 12:38:42PM +0100, Simon Horman wrote:
> > From: Huanhuan Wang <huanhuan.wang@corigine.com>
> > 
> > Add IPsec offloading support for NFP3800.
> > Including data plane and control plane.
> > 
> > Data plane: add IPsec packet process flow in NFP3800 datapath (NFDK).
> > 
> > Control plane: add a algorithm support distinction of flow
> > in xfrm hook function xdo_dev_state_add as NFP3800
> > supports a different set of IPsec algorithms.
> > 
> > This matches existing support for the NFP6000/NFP4000 and
> > their NFD3 datapath.
> > 
> > Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
> >  .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
> >  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 +-
> >  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 47 +++++++++++++++++--
> >  .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
> >  .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 ++++
> >  6 files changed, 79 insertions(+), 9 deletions(-)
> >  create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
> 
> <...>
> 
> >  	md_bytes = sizeof(meta_id) +
> >  		   !!md_dst * NFP_NET_META_PORTID_SIZE +
> > -		   vlan_insert * NFP_NET_META_VLAN_SIZE;
> > +		   vlan_insert * NFP_NET_META_VLAN_SIZE +
> > +		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;
> 
> *ipsec is boolean variable, so you are assuming that true is always 1.
> I'm not sure that it is always correct.

Thanks, I do see what you are saying.

But I think what is there is consistent with the existing
use if md_dst and vlan_insert.
