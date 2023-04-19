Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EBA6E77BD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjDSKvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjDSKvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:51:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2128.outbound.protection.outlook.com [40.107.223.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAB26A4E;
        Wed, 19 Apr 2023 03:51:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC/WdebH1rGdHCpX6gjyIZ5bg3m4htqdpLh5nnlc/hE1EI1kLbK2xMd0hmN9s6w6G3ctglRBQgt72e2wuBwz5nNF5GH01Uz+nPIF8Y/hf6wMNr0zerNhrjbJJUFiPB0L2/SGv2sk/b7ZGlhCeFBrBR7QQZ+i9diLY7YClW8O1wwTcojvPSWSNUDzQzBsa2EOhwF5+UtRikBtEn4PTHFomX8lXkTRHn2nRhJZGxTL3HwsxXielfQawr+bjrmUxYYAgDCK8F2j4GCLmgw6X0SvSSzXdyD2IfbC4NK3vatQ49zFle2ojMR/surMc3KCd681wp2i4uNmJYYYFD+91wxC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYK6EdBatvtbVUEZi46ijTzzqswddwCZk+GyUrCiuYk=;
 b=ZotqgWvX4M/gI8u3HEK4bWvqmR1tPqJFgYli9Y66KiLqXMDSPKJck7VHIX4wgKomfuT/Lgb0YY4GYMoghaskvTulDM48WIGshUMzFFBV97BOjaKzXuWpkSXEKTX+lYfw1bRE4JselLzRugeNa7yh47nckjtqWATwaxNQVQn8CNwkeYXSIrEjtCNKtGq12eh0pacGhORkWxTkYMUqywUoQYTtkRsIb4gmm5XLD3kSoJOQq1L2kxhHPxMsWYBTBJu9dkgR1Adx346GEuBGo7XqZxtWJqzB9f9SWzTFnOwPkyOHa+iLacEDXPG6pJAfRKaF2Q/SXfpIveeRygb8UWMyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYK6EdBatvtbVUEZi46ijTzzqswddwCZk+GyUrCiuYk=;
 b=k2fqxMW2bSYK++ZMa/UL8Gcci932/gzUhZqTbxVSrpn4ZBecci19+42b+rDhMIMFwMt5l8oGswI0XSRkyettCMV7nAHqbWjMtNZm0hb+YTDIL+Sqwv7IkaeSYdaJ6fWnSckA0sZZQwYiaQ/cB5G+ZZhyWz20t8H80SzHRwtzXj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5678.namprd13.prod.outlook.com (2603:10b6:806:21e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 10:51:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 10:51:18 +0000
Date:   Wed, 19 Apr 2023 12:51:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 09/10] octeontx2-af: Skip PFs if not enabled
Message-ID: <ZD/HncVvuuDIlHXv@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-10-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-10-saikrishnag@marvell.com>
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 878e734e-225d-4e22-a164-08db40c400e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wg72y9nsO+vXU4+7xAtVEweqiIAs4fTLA0YDYYTk4zkUqpHYBDSUsnK+JnGsUT0xAMMAohFABz504gyOXBj9Rr2qN/eS0Ph4vW6yWZkVXWjhhldUmvvjBuJSq6+QT0HVERQN/mIq1oeXu2M0lT2CbLRFyigOMSXvjHe+ZGxywo8/sAssVBhE05kcdhyc3BYQzXhiTN8Wo53xhRVbYcUJt4Qs5x54X5b7nHeaAqEECH/HKP2ULtejTNVymT8g353SsmNetJK2Am3arkEHKN+DBjoDdHdpWeNlZPDuC2R+RL+M3q06MEConXMfX0CkteDzU9MNkTYjSiFvGxwNMWAMbDef/jLfmk8sGCDg4qoiPRNIma7gCdEp9MT2Xa3viVszeORkXzkgeXEDdHB3f/LCrGgGVuPrlJkFrzA594lutE7og/WwqIkxdGX/Y7E7iirKw9q12JTFXjmudEx+KJMmU8K1W0WxfoZFSzoSVENMGWehHZ75U7icfsGaoLd9eLCWHXNLDNR9h40iEke9HMd3giKTgYJanrM7J70nJcwZs7RbBvMAAVG0oSWyijZCyfT6cJKhMDnGVQFHplspvvXI4PI69hH6c5cLicfhUBAdLNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(366004)(396003)(376002)(136003)(451199021)(36756003)(44832011)(6916009)(7416002)(38100700002)(2906002)(8676002)(8936002)(41300700001)(5660300002)(86362001)(478600001)(2616005)(6506007)(6512007)(6666004)(186003)(6486002)(4326008)(66476007)(66946007)(316002)(66556008)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4rT4VDlzZGk4r2ICNCDpYpr5Z3ODhKYElSJb4ZTQbONsjcqGqnxXUB+cQ0iY?=
 =?us-ascii?Q?yOGjHuf+mjQPQzeQvnhGWUWq8lNOaBhx2S8lhi/OOpWQRZ0ZXOXL25pywa0W?=
 =?us-ascii?Q?AhnBldX0BS0eQ7AcwD6bJxOgPg420Z2atw5lPuOvX9urIV5UUPeLD2KrsLh3?=
 =?us-ascii?Q?pSUl562ux5UNmFSNSpz0EcZ2L5PhkhIcZfElADLr9ZntSxiNmnnAVmbsloud?=
 =?us-ascii?Q?7j9bpVB0C4h7LLtGelRHLeEI6IcPFcC4GlbjYv2HTP9gSUlT0BASZn6Jzw9X?=
 =?us-ascii?Q?HE/GDMdKbVVOx+qOcNBeIqmhlJi8ze137gOLoDblp7ThrqbkI+n4dmHwCsFh?=
 =?us-ascii?Q?Cv5F7PfbnX5IAfeHvH+cXEhOaWmjtjW50ixWYoHSBSjAGcnhsCBk8K3WqfRp?=
 =?us-ascii?Q?+wiuq2gu8CxlhqEkq4BC7jjV37841KFJDjtBhAx+jTqTNtqjPeXCaacv6WbW?=
 =?us-ascii?Q?Ll0Ncu84ZH9rfymEGRvUoV8LovO4j1p1jNbNXjUeXPhrCwl/qAbCpNdsDj/U?=
 =?us-ascii?Q?Za4UF6zXrwo8W35rX8SMdIvAoURjxfj//ttaFDHeC79tCAo/udkcwUQFc8Dn?=
 =?us-ascii?Q?gBhvzwmYCPZa1gUVPHfDa4lTUXmhuVtFKLGsXOhSMKfTty33bGRNl6uZLhbH?=
 =?us-ascii?Q?orxb5fMwHuFY8YQmxJMjGQ8ZxSC8r4MNcF5RA4unlCmwz4HYpN09VvPO/ZLW?=
 =?us-ascii?Q?V2vGBPsHarKRy+K1Jteu+LJmWUcKKfFM0hDCNGQECcx7V/NoaDBe+eQSgVQl?=
 =?us-ascii?Q?mF4iw3SnaupXvWubUTFr99xGWZl1HQQDl99oGzc/ugdYCLSXOU/IUXBWPYro?=
 =?us-ascii?Q?pNOhwQajNWLpDkK/5z5tJm+jENWCftsEfHuMlbTToyMB5itRy0ldnJqtOgcJ?=
 =?us-ascii?Q?NjrBAnkwjwxVs9nFR+IHG+Fh0uDtwPXuPNAHZeZHacOnbEwcbguSCWoX9CYT?=
 =?us-ascii?Q?WMXVVG5wIskzUCkD7ezGxDP8oRp9xDCu8V5QD89UsGY2zTw1iN00XCB3E7fk?=
 =?us-ascii?Q?JYfGkJSD4bVqYHEYlZIYkVKyLKAzAIS1nan9azkbZ8r13zW/wF38+OL0L81X?=
 =?us-ascii?Q?NWc/Uubb2JWHKMugz3uh4A/scaGbLXCV6WPcmevdxjc0dkywFKHg58le8Fs8?=
 =?us-ascii?Q?64o2Nq8bnXQRY9iYEe0g8Jc3b48EA1dhW3Wie5XsoMEiWOgi8ODidDHBftBd?=
 =?us-ascii?Q?Kecr3r6db/MSdt7fep9fRe+bIWAVeq9whoyvDbhNgrT52zgFP9balU0XDW7k?=
 =?us-ascii?Q?ttCJZveyo1WETm9oyZJAsPJQAebRqun94tPC1tyFghTpvFSok/mQLNF0JkMF?=
 =?us-ascii?Q?jdutTQbIHpR+tYlX4uWoFoNk2Ieu7AUAASL1f+YrkVFCscumuV6H/3J7w9JB?=
 =?us-ascii?Q?2ampoA+9YEPFu7lSQU9Wtr8vndoob1Xbg5KMIfjhiiODCg1iZGMlXXkeKNxj?=
 =?us-ascii?Q?nSwNPzErZM++A+pUhVdin9WC+uQpLWAOJD87ikB8Pr3Mfp9pc/qqTPKJKnhO?=
 =?us-ascii?Q?kic7Goh+RfNOSo/lfSAvOcSNmoz1xW5u/CElV++D6hGvSpxDJYyHYahobDy8?=
 =?us-ascii?Q?Y8hQfA6aa2A+HwKx13F3xJZx9QnGZr3Ynodh7gGioyiQUJfcL3uNOUS0N5UF?=
 =?us-ascii?Q?9sWtM1fQHd2YZDDbmTmQFCsUo1wvJ2JQfIpFD/w727WU7DZ+agQcdr7b8jKO?=
 =?us-ascii?Q?qTydsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878e734e-225d-4e22-a164-08db40c400e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 10:51:17.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIZ1Z4fG8yR1z6WQFpHFwLIDW1A7xPwS7BijO9psT2oLwWpTaZ2BVvu1Z/9RBZHJiWmDEUsCzBrPiUK6qVzXFTAvZXSlP2hCgk/env6MPwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:17AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Skip mbox initialization of disabled PFs. Firmware configures PFs
> and allocate mbox resources etc. Linux should configure particular
> PFs, which ever are enabled by firmware.
> 
> Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

...

> @@ -2343,8 +2349,27 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  	int err = -EINVAL, i, dir, dir_up;
>  	void __iomem *reg_base;
>  	struct rvu_work *mwork;
> +	unsigned long *pf_bmap;
>  	void **mbox_regions;
>  	const char *name;
> +	u64 cfg;
> +
> +	pf_bmap = kcalloc(BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);

Sorry for not noticing this earlier, but
maybe bitmap_alloc() is appropriate here.

> +	if (!pf_bmap)
> +		return -ENOMEM;
> +
> +	/* RVU VFs */
> +	if (type == TYPE_AFVF)
> +		bitmap_set(pf_bmap, 0, num);
> +
> +	if (type == TYPE_AFPF) {
> +		/* Mark enabled PFs in bitmap */
> +		for (i = 0; i < num; i++) {
> +			cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_PFX_CFG(i));
> +			if (cfg & BIT_ULL(20))
> +				set_bit(i, pf_bmap);
> +		}
> +	}
>  
>  	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
>  	if (!mbox_regions)

		I think pf_bmap is leaked here.

> @@ -2356,7 +2381,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		dir = MBOX_DIR_AFPF;
>  		dir_up = MBOX_DIR_AFPF_UP;
>  		reg_base = rvu->afreg_base;
> -		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF);
> +		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF, pf_bmap);
>  		if (err)
>  			goto free_regions;
>  		break;
> @@ -2365,7 +2390,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		dir = MBOX_DIR_PFVF;
>  		dir_up = MBOX_DIR_PFVF_UP;
>  		reg_base = rvu->pfreg_base;
> -		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF);
> +		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF, pf_bmap);
>  		if (err)
>  			goto free_regions;
>  		break;
> @@ -2396,16 +2421,19 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  	}
>  
>  	err = otx2_mbox_regions_init(&mw->mbox, mbox_regions, rvu->pdev,
> -				     reg_base, dir, num);
> +				     reg_base, dir, num, pf_bmap);
>  	if (err)
>  		goto exit;
>  
>  	err = otx2_mbox_regions_init(&mw->mbox_up, mbox_regions, rvu->pdev,
> -				     reg_base, dir_up, num);
> +				     reg_base, dir_up, num, pf_bmap);
>  	if (err)
>  		goto exit;
>  
>  	for (i = 0; i < num; i++) {
> +		if (!test_bit(i, pf_bmap))
> +			continue;
> +
>  		mwork = &mw->mbox_wrk[i];
>  		mwork->rvu = rvu;
>  		INIT_WORK(&mwork->work, mbox_handler);
> @@ -2415,6 +2443,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		INIT_WORK(&mwork->work, mbox_up_handler);
>  	}
>  	kfree(mbox_regions);
> +	kfree(pf_bmap);
>  	return 0;
>  
>  exit:
> @@ -2424,6 +2453,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  		iounmap((void __iomem *)mbox_regions[num]);
>  free_regions:
>  	kfree(mbox_regions);
> +	kfree(pf_bmap);
>  	return err;
>  }
>  
> -- 
> 2.25.1
> 
