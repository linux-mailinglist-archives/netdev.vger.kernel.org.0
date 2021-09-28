Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA81B41AC90
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbhI1KD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:03:26 -0400
Received: from mail-dm6nam10on2126.outbound.protection.outlook.com ([40.107.93.126]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240162AbhI1KDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 06:03:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSZl6uBiZDdkrVFjVinimQD3QKKSlFbohkXO0W3BXY9j5bUvSWQF3ibv0sU8FRSW3n7kPH6cJz0HsThrwcUqN+Emc5s+lr9kBy0trQMqpKMVmpIE+0Xwo5An/pSiJFASLtPIFmzM1bBO14QiMx6+E3M5kkxZ1tTK2Hnh9kEdpFfE4oBa+FSnKGkSwaNsjuj99ZIT19oqQiW+36toL2/II34eKIoms2HVxOwSyKUdOXWgDpKVwZ410ff+rqGu0KbCikQPPY+FNO6MSyKSSOc/z8gXqRea0q3yibxHHdPqsOmXzc+dXWHlHVet3Jtr7WjGqaySEMSyMgknMRrdwPe10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yH5vkAI5Px3m4awq6KffP6O/fSPpqgMT8c0Poy2KzA0=;
 b=Sn7fi+4G2C58dF6B1nkTbONGsLwzQc5RWGRFs/CC5knT5P3BDIHIpFCeuUGNifoCRBrMoQcQsqZsFEPTBV3EQPguvSeoBkkR593JyutfaZ3NPBXdWoXwQt6sIo69AyUotuSiD6P/9rVaH41akC7y2f2nDqAYF0Q+hAj9a7v0+9OPomCiT5ideXNldFzM6BJqaBkRdstU8hp2tMswdLrWUZTlmX8Ehmmg/G2QvVCyCMnp54/oBkEbpWn8bmaKhqglHVj3eUVEh5Z7+QYRjCdTVDn9eGUrkJl/oZz5ltRMbvro7xJtxLpNz1NIm8vqhdguvQoioGkfkkyKCvZubXD1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yH5vkAI5Px3m4awq6KffP6O/fSPpqgMT8c0Poy2KzA0=;
 b=SyHuixymTOWaU6I+iPScPuCXWMLNOOFJn8goPQuZjjt/Wz4kWz4x/tKXCeMa/lfnzeqTl4m4u7SW4ajn5/D+JePq8PlQGeZvoom+kw5kS/zkIzP8wp0CSF2dbEg3uJZtXPedjmmEsAeBRlZLUjWuB8gILeGp7ALh78btSOo/96I=
Authentication-Results: kleine-koenig.org; dkim=none (message not signed)
 header.d=none;kleine-koenig.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4874.namprd13.prod.outlook.com (2603:10b6:510:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10; Tue, 28 Sep
 2021 10:01:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4566.014; Tue, 28 Sep 2021
 10:01:37 +0000
Date:   Tue, 28 Sep 2021 12:01:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210928100127.GA16801@corigine.com>
References: <20210927204326.612555-1-uwe@kleine-koenig.org>
 <20210927204326.612555-5-uwe@kleine-koenig.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210927204326.612555-5-uwe@kleine-koenig.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:200:89::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM4PR0202CA0014.eurprd02.prod.outlook.com (2603:10a6:200:89::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 10:01:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da31f8bc-4b43-4aff-f1c6-08d98266f620
X-MS-TrafficTypeDiagnostic: PH0PR13MB4874:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48742306D04468D083E45271E8A89@PH0PR13MB4874.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG4AgYxyZuUheIV49HC58vtrbMs1cIO1B5B+ToaBF6etg357VIFB4WhEfdBDYSEGrs0nneydEX9FbYLNXZknentIVi4E5lzE6xert/BMHsiYHlSxQw5BM57F6dkGJvFLLXrF0bPb9czV5CuPg+Frt7hNRE7GSQ6ETdy39sNPJ5nXtCyjDgAHq3Mnjs097B7d0Pii/36DJ5LtUKMr1/Ov3rAeMmnaC1zMr6kdMOXprKUjwF0YYwMzzPTuTkI9fcVuJ0XQo+AnvDrtCry82cOw63mR7rEOywXCbxvRiUQlBREo9Q0wdWTpJiSoaeuIR7ARIy1+Fz1IoSgFsoOLrH9mdPUrLVQcPdDfODnIZURFMXUpcT9SauXvmFR0ldOK9s4qyU07t4c7sndSe3I5bCUP93XO7MidVJBOxXx5/em0bkFE8nLJapT5+lTm0Of1vjQ/wDQhY302x5PgPQlvoLBNA3RMWgRWLT1GD1jxseh7GKgEqrgZ9h8Bj1BCKCeLzlHW620Qa966AQufwp6GKiZFslPnnBta0mkE4N8lZd/V2yVtInHfCVYuICGqG8ns8CfFwe8xb1HCzWQYv7Lk9O2ToXIWQSGU0pi4yAvWPsDBi6NhpHLXtnx8+S21mEbTVx6xkWspeFwadCwC6iJneMfMNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(136003)(39830400003)(66476007)(55016002)(2906002)(4326008)(1076003)(107886003)(316002)(186003)(66946007)(8936002)(66556008)(33656002)(7416002)(36756003)(38100700002)(44832011)(6666004)(508600001)(54906003)(86362001)(8676002)(8886007)(5660300002)(2616005)(52116002)(6916009)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFNVbGVUNFBkMVc2eFdHYzVtRmhtVVl0dUtud05TSUZacWlQQ2d4eXNkelN5?=
 =?utf-8?B?blZYbndTR1orSVhqamFIRitxeXBQajRNcW13VkVJTk11U0hCaHJOc0hqRVZv?=
 =?utf-8?B?QVREUHVrRFZXTXRBS08wYUdHTGVmWkNQZmhhSGVFb21PWTEzMG9GRjNKM2ZV?=
 =?utf-8?B?OHBFWUp6OWhiUE04alNydDdJZm9qZW5QQ0IrWjdTQVRwRUFHV2JJYWsvMk03?=
 =?utf-8?B?a1BiNXpNYVNXVnVqZmtCRUxNcVVoNXppT2swaTloV0FmNnRPWnFoZzI2Z21a?=
 =?utf-8?B?ZEhZWWI0b3NEWlUyRWl6SVY0Nmx1NXhaTVhtQmtFbGdLNHZGU1JkV2dPV29N?=
 =?utf-8?B?dmlkK1plQS91dFJBNDNObDJKN2tTRmthL21JVFZUMm9qejNBN1hRb05ZTDNB?=
 =?utf-8?B?QWVrOURjbnZ4amd6Z2JLYlJOZTNaeFNVVUd0WXRKaEMrRmlXV2RBSDVXVXFM?=
 =?utf-8?B?T2F6U0MrSm5VSmFHM0xYR2JyQmJnWVBlR1d0RnhhSXBHWmVoUXVmZFh6OGd0?=
 =?utf-8?B?Q3NSL1F3TUhSaDhFNmFZb05qS0JNSzdyaWxyZmJ1VkFxQ1FGNkp3UFJCelJI?=
 =?utf-8?B?bTJGbDlsc1ltcTJMeUhRa1l0UGlyOGE4Rm9aRldlTnA3bnZPeUMvVkZ1SnN4?=
 =?utf-8?B?dVY0SFQ1T0t4OXk2NjMvK2lJZDBSeFBnTkdheHc5Uy9YMzFRY0hoSmFtM2ZQ?=
 =?utf-8?B?K0pzMmVvSGRVSHBqREtDSERWZGwvSUxUZHNiYVZBRVJodlJJZ09PYW1VNG1G?=
 =?utf-8?B?NzBNMEs4RmliOUY2dFVFbHk4WEZFV1V4VFNaa0dndVErUjk1bXFwZU1qclBs?=
 =?utf-8?B?SDd5YzVJYUJRREt5VE95TGJiTk11VmdZSVFFK1B2YW5iNzBmTlJPdDJWU0Q4?=
 =?utf-8?B?WlBybTl1K1c5L29kanJ0aG9RSGY4M21lVExaVVNDVjdITnlRdTFtWkFjYlcy?=
 =?utf-8?B?alZRNkZqQWFxdEh1OU01SlJkZDMxN3FIVnU0QUp6NTdndFZpbnJhKzAvNGh2?=
 =?utf-8?B?NWdReGdKWWZ5RjZwQlpiMHZFczl1MmIwQ2E1VERrVFJCaWRRN2ZmcndPdlFJ?=
 =?utf-8?B?Z1hpUThTNlFTbXRIOU9PSmlDUGF1UXRubmRMWjM4UWJ0YXVpS0tZQy8vK2JG?=
 =?utf-8?B?a0t2ckFnM3Z1bDk1aDVZUFVBcFE0OXUzdFZmT25ldHUxUWh6djlNZjZ4dUtG?=
 =?utf-8?B?Q1JOWGtrcU5mL1FvOUxCQWlGRm5LWVJ1OHM0TEVWdGNzQVl6TEVQSHllWDlj?=
 =?utf-8?B?aXJteVRkcHBRQ2tEWmc1WVJvcXFhTzdBV2psSWw3TGRHczlXRDJVNDFtYmgr?=
 =?utf-8?B?RllkZ3ZwUXkvT2wvMjVPUUpCSmkrczhLQ1ZHaksvM04yaElSZURDclEycVIx?=
 =?utf-8?B?ZFFXUWN2WWpXK2RvYjZpMm1tajN6b3pUaXNveXBGT0d3eWs1M1h4QzZvaE1q?=
 =?utf-8?B?enUwblB0QUplSWVsQTF0OGtuNU1oeHlhZWRTVnZ4end2STNWMDJGUkdJVVAx?=
 =?utf-8?B?YzVYVE9oOGZIaDdjcWxDQ3NYaU1aUytBSnBMQjdRU3BmQjBEUEFCYU1ySTcr?=
 =?utf-8?B?YXNJeGg4c1RDaWxJQVUvd28yZVpUSnRoUXhjc0c5WUk5cnM3U2VFeWdIcmVV?=
 =?utf-8?B?cWk1dlgxOTJIRG0zZ0RDbkJQQlp3Ynp3RTlUNUliNzNDNXhFYWxubGllWjNL?=
 =?utf-8?B?QStadWZ2ZTU5MHFDREZtbG1lNGZ0bnAyaWc5RzZaYTkyK2ExcWF3OHJJUFZO?=
 =?utf-8?B?cUtZNVRIeXFUalIxT3FkY3QzbGNwVHhnREkwM3JMQWpLNllKWnQxV3BBMGxN?=
 =?utf-8?B?eVNZSE5DWSt1NWUwRk5SSW82V3RWbm4vMUtKYU10VE5RZEExUHQrU3RLOVFE?=
 =?utf-8?Q?+lz76RkJCkCL+?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da31f8bc-4b43-4aff-f1c6-08d98266f620
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 10:01:37.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aU5GMswdemP/aKf9Sr4rduTxFNIblbrSz9Dhk0zc5gk+r6UPeGLdxqulZZlW4FMkJPyvZwNph1AnuQFlhsjzrJE84ZE8SGelj8lFdZTd7PA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> struct pci_dev::driver holds (apart from a constant offset) the same
> data as struct pci_dev::dev->driver. With the goal to remove struct
> pci_dev::driver to get rid of data duplication replace getting the
> driver name by dev_driver_string() which implicitly makes use of struct
> pci_dev::dev->driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

...

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 0685ece1f155..23dfb599c828 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
>  {
>  	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
>  
> -	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
> +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));

I'd slightly prefer to maintain lines under 80 columns wide.
But not nearly strongly enough to engage in a long debate about it.

In any case, for the NFP portion of this patch.

Acked-by: Simon Horman <simon.horman@corigine.com>

>  	nfp_net_get_nspinfo(app, nsp_version);
>  	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>  		 "%s %s %s %s", vnic_version, nsp_version,

...
