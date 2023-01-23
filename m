Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53F5677CAE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjAWNj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjAWNj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:39:26 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2090.outbound.protection.outlook.com [40.107.223.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A6AD529
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:39:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfjQBg1VvBSr9Ls44lap0Bk0ylX0r/xeSj7x6bQgpP2IRq/cT/UY6gykUFqsuhlKu34aQSkUWuVmzPSOMeyk9gwOiv1KO9qO8OMB6xkKBL+6XfNHJ70SRSUbgdTcMLuh0gQHV6SL1x+ObbD+ovEFuXZZzc66TKsmO8tGzbHE5XN325geroRuN1kTXJLwopCYzssrDvjvNAJB9VvUTwNrGiQWjKRKm0noTXFDsOBwh6lgefbNNNbqVYIJXIjDTyfplmn0huzvzjXQnUqLYWIrcsCZpoL1nBBUsTdVGH54S/LM1FDuhKGR3DQBHiyPY6qT3OS3cd63t5SVAQQ2XA7GCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pryfIPLbQ5BAjKj+hzJ3h9uxAX+dkOGdds07eWbhOK8=;
 b=OiKXN/2Q4kMd1CuFzpIR5+P3bliGTaPPS2/ZW5cyURdKpcY81zl4DPXltt2Iey4X0z32HsT6lU6yPTuAUmKuTkPV2Us9+9/xahM+XpXe/+02i1nhnV6bF+ZQyd663mhYY4GAKaVoZcQT4epRVGtbqoU4WhhkTEUhWp/Hnuv94z4k3pMlG0JZNjdKjN3uB3iZT9qXh+pV9sIRItt8mBZMmZIaIRkcgNdMxrtwuO3ENJ5kiPhK5huXN78lmlQ4rQ8pmpYgNE9KokqS/sYvmyRiRRjQ8ZzJzi35JcBS6NqPRdY5U8SGoqEFyYbLSlLnDC/tt6osg2dGn5QF8Xh7sTQojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pryfIPLbQ5BAjKj+hzJ3h9uxAX+dkOGdds07eWbhOK8=;
 b=vY5DsohnDSckLMg3j0YX5Fx7HKx9eoetW+pmpArx0pVadu0AbPla8FDOc38ZnsS+2Tq4ZQmK5NKrB+P8dYXWfkb+KyXmlz5GynWSMccQid6NoxG4P3BJajz2vW+M6p1WssHcnkqSNO43yLFv/ta3C5lqsl2HrRMKTv0roekUglk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 13:39:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 13:39:22 +0000
Date:   Mon, 23 Jan 2023 14:39:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: support IPsec offloading for NFP3800
Message-ID: <Y86OBBkLltTIorQT@corigine.com>
References: <20230119113842.146884-1-simon.horman@corigine.com>
 <Y8z40Dt0ZiETMurg@unreal>
 <Y86IgKLKITyw0K9E@corigine.com>
 <Y86NY9MVcfgO1PPs@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y86NY9MVcfgO1PPs@unreal>
X-ClientProxiedBy: AM0PR01CA0163.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3907:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d1c9d28-dfe9-4e33-0ce5-08dafd473c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hENaQQsSpbz2N2a54kPXKAXN8KiohYpfV2JLjIUDsZYxHLc5hfQWUoZxCxc9Cn3gjjNcjz/19ORbcgyU20L+yo1bbMZNNDEXP1NJ74Kgnv89I/HSC5bZtQXB4LB1V7XDIcfuReMMyd90ReDh+gT3bPpWXjsVU8sat05FajFIUU5492n/K4WsYwOFcdqCRrYVfcXdHtEr1QQJQWljNUGaI9keXqTLbq6EEU73ksaAc9JFnqjWZAxJa4Wxm0trYOpPSsIeSGt4QovLywx6jglrPsGKWO6z5720+jo2l5r8nKbzqDcvrZaMxk4GsRtv4NjbUyr8OkE6cLeA1e82c5siRKbISv3uBiObbd+d69wo74i0RMMeB4LaoFmKBCNFLJWfSHanaeAaHviMFh7DBguIy3oXWJzSjildqkT2e+2H/nanbYVhvPo08+7IP9mxhthsSxMEG/oASF6TfK0djgdVfn574dtZRAPuc1BZ5KUueE83O1/ePWmwUSG526EZM6i1qJf4laTEL+shCmF+pSPVIgMZmsJaikZwsk5TvdW4+BvpNrzyQ0WZXuH1xBAub8Ui5yhai78poE4+TRCV2HZwjI+0oCTHe3kUDCSCYDte4ICVesTXtmeRZrsMnjGvXJCxldrMWUNFuOy/hB+6DgUnS6quJ3/beMq9ZMelraijj1sgaxsi3Sfkj/wBG2CQSKvTbQeBM/2kGoM+AMGnAHAdTbh41lEB4zful+6lPgY7wy2YWU2xhEBg4BlRoe/ft13c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39830400003)(396003)(366004)(451199015)(36756003)(86362001)(5660300002)(8936002)(44832011)(2906002)(4326008)(41300700001)(83380400001)(38100700002)(6486002)(478600001)(6916009)(186003)(6506007)(8676002)(6512007)(316002)(66946007)(54906003)(66556008)(66476007)(2616005)(6666004)(107886003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W5ETl8f+9G8cct+z7Gkfu+B4V7ET0h5TEUhBFV9DYqOPraSxokgUKQqM3jUd?=
 =?us-ascii?Q?r/ZucWiaYyCyaQQnAHYddK32+Gj963q233pHUH7A5saZMXw0W2e7MFwgFBGD?=
 =?us-ascii?Q?zINslvjXO3GD6UvrlumhUP83u4tyTn6vY8fe274ZStgLmx0/YkWnXjh7vNgi?=
 =?us-ascii?Q?/+orIC2KG97V2DrCjwO0jXFvc0EYtPtn5psJeuaBh1f/B2wbNb1btzOOqmEk?=
 =?us-ascii?Q?Mu1Lv7PGxdo8MKkfx+G/j0jM3FLG4O1bQqybW838p0iIkfMZ4pVWMmHEQSlB?=
 =?us-ascii?Q?XBn9a/ju9IFJP3fLFAWs+sbYSTRwqDGE+3vDO0OxoZ/PlQEZ5MTTH1PcZgeR?=
 =?us-ascii?Q?gIHW4DWBeo9gDwxKv+YAFeurY4L2H2/D1GnG4PrRU9MohAjADW3t6iaIvvHm?=
 =?us-ascii?Q?lrMyfXbC7MVGuwusa1kfPkufTggFf3x+md6CvvzV3S+WemsgjM8NbSwa3mgj?=
 =?us-ascii?Q?RM/7gBD0GFoZ3OI4B5+wicb3mJszykJhymx5Y8/5X+c3p6zcX/PdkGRnKOnq?=
 =?us-ascii?Q?tvz46XDgrWdEAozleQ+HeKnSY50V2WmtEmIaoj4LGPKj31GVxYJqHsBLDtXp?=
 =?us-ascii?Q?dS/PW1yp5TZSDHyBgprvLaGmQUYrUOOag2sbiNY+mPHkbwBoUaGOHkRe3HSY?=
 =?us-ascii?Q?kESbwbcXTAuqzkvDYpKhhYqNlkU1CiB9BEzM0vQUxjonGCdlfxJdmtFIPRiS?=
 =?us-ascii?Q?9IeBHPcl/DSMRHB2RTyeYwqoTxfWzz37m51p2JJxr2D4y4wf2AfoAbAkXW9O?=
 =?us-ascii?Q?uQBZ+8M0QMHXVZbx9fLzv+8aS8UzQWtMr2qmPknJD3LudKT9tmLdmnkbHIR0?=
 =?us-ascii?Q?DQ585si75C0SeOh5o+1pKKkpsUlOlHA7Ukj8EgsXtL3Uj+WYqpm4k2c+8d+3?=
 =?us-ascii?Q?99fFw2tQepCciYdQ4yDWaI8dZvVrkZc0ragQfm+7HWC0ytnmhX2kV12UGwjN?=
 =?us-ascii?Q?eienlPu7U0OHwWd3Fj6DLGgR/QDVkpLhI2hCHV4Xugl9wNKKhk+zTokW4Y6X?=
 =?us-ascii?Q?+Ywj2yokQtmrcj2viwZPA6PdxkMuSDYdXJpQe6e/0BXBr0WRmDD/nyI9xjgp?=
 =?us-ascii?Q?ZDOGoCyv0M2QAKiiUd/FPq4GZCnhYpmTjRFF61wLH6jIKtPN2BXg3o2JDVN3?=
 =?us-ascii?Q?kBs1jNtYh9h612m2Wx0t0aMjH+ojeNbfCosspSiSa/IU5+QwnXpS0oTUpUEJ?=
 =?us-ascii?Q?0Gf+INhj/5wrhBd9sh1wxJ0JgQSKrdgw8o1EBT4BrNaXVQYZkoF8X72yOzav?=
 =?us-ascii?Q?AjtSpMgoj2B4osfEAs3jZkqNiqQZUmjK111Nmx6VKjBTJTPOotee1Gpz/Z+4?=
 =?us-ascii?Q?1EMeLWt+zVG5d9In85GkObUPCzOB4Y4WAIsPluFPXAa9jNhruTHe9u6KKQBA?=
 =?us-ascii?Q?Pq3s2GHdkwimd9kAmVe5xz0EHviV060rMfiEDIHvCs23HDQPQ3gjNHFU4gBr?=
 =?us-ascii?Q?j7YjBx3FhI75lkVcNa+O2odsGePMvp7CiLQLgyjNtaqye9KSt/gDHnjHgIcQ?=
 =?us-ascii?Q?KwA2LNUT59ms+enrGHYrjWBs1dxBIDiaE8gJSn9KFUkBJuZP5OvdvSHUvIbi?=
 =?us-ascii?Q?z6jrW4CoToCqzD+wH3F05rJ11Qy+bzgqOKsbt3n2APNWxSIGWIsdXseOXA7C?=
 =?us-ascii?Q?yH8rZgudFkQGH8uG0VI/cXfO8e5chOVnYE3/xJrivsJXIOwQDcIaPiizADtl?=
 =?us-ascii?Q?SaE0EQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1c9d28-dfe9-4e33-0ce5-08dafd473c49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 13:39:22.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ois6PgciYO+vCzcK8wdFJ5KC1yon9libRo5mf956AYL+2py/VkVvZOT16p5sXASM+dj6GASmqVfHTDpFqDEIc9hhiDm76LmQ+vGwYo5X7Rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 03:36:35PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 23, 2023 at 02:15:44PM +0100, Simon Horman wrote:
> > On Sun, Jan 22, 2023 at 10:50:24AM +0200, Leon Romanovsky wrote:
> > > On Thu, Jan 19, 2023 at 12:38:42PM +0100, Simon Horman wrote:
> > > > From: Huanhuan Wang <huanhuan.wang@corigine.com>
> > > > 
> > > > Add IPsec offloading support for NFP3800.
> > > > Including data plane and control plane.
> > > > 
> > > > Data plane: add IPsec packet process flow in NFP3800 datapath (NFDK).
> > > > 
> > > > Control plane: add a algorithm support distinction of flow
> > > > in xfrm hook function xdo_dev_state_add as NFP3800
> > > > supports a different set of IPsec algorithms.
> > > > 
> > > > This matches existing support for the NFP6000/NFP4000 and
> > > > their NFD3 datapath.
> > > > 
> > > > Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> > > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > > ---
> > > >  drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
> > > >  .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
> > > >  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 +-
> > > >  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 47 +++++++++++++++++--
> > > >  .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
> > > >  .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 ++++
> > > >  6 files changed, 79 insertions(+), 9 deletions(-)
> > > >  create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
> > > 
> > > <...>
> > > 
> > > >  	md_bytes = sizeof(meta_id) +
> > > >  		   !!md_dst * NFP_NET_META_PORTID_SIZE +
> > > > -		   vlan_insert * NFP_NET_META_VLAN_SIZE;
> > > > +		   vlan_insert * NFP_NET_META_VLAN_SIZE +
> > > > +		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;
> > > 
> > > *ipsec is boolean variable, so you are assuming that true is always 1.
> > > I'm not sure that it is always correct.
> > 
> > Thanks, I do see what you are saying.
> > 
> > But I think what is there is consistent with the existing
> > use if md_dst and vlan_insert.
> 
> It doesn't make it correct.

Ack, let me see if I can improve this.
