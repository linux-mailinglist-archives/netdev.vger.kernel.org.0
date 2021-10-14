Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BE742D5A4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhJNJH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:07:29 -0400
Received: from mail-sn1anam02on2106.outbound.protection.outlook.com ([40.107.96.106]:19134
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229994AbhJNJH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 05:07:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK5B5cB07r/HIIq70D6tftpV2EoAnNMTW8RjueQ0DBtJm955dV51gkVXRKaYPf1j6ZG8ojGi0fNT5M1xrt4qsxFxWINKy6tl9USynvyYBOS5Ac7V0ZaImR+JUKFKMuOLEiUQQ8PQG5HAOGOs3SpgMN5yIIphr4LHiJdHzmYxVkne/c8sTBgextY/s6rvAJH6CdLRea3DluTcChVkXIlwbOWNSKyyl/E3eCJ8rCm0PnHePiY6D1XRkfhijzGJGXU3Miq/XuMj47xFJbug0fSmPfxEzzspZJJfN+nsSdzkLX80bO2YYxHy7j9doEl3dnbaiJOa/vQ6QplbuX80RVtB9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7Medaztcjg5jyOAFW8zFBsApUhR+KUfLquwfhFLF0c=;
 b=Ky8qZSkAXQvCvq3POf7HsLblGI5EpeyT0u+BYNSc17bYFoTYDJ6KU4YQdWDSrZwuTQq3x+f5xn2iGVfIOBPEZqqjlFbQ60Fz3uJYHYLfkLdpgSIMzmvF/+bWsYQuhyxAQJHu/lER2RglJ2UO3pQp8lZgZMpuA2GznYvmpXit79hj1iH9cbMMWWFe4TSxXTywEUyfr2yj1Sji4RSXoK3T2IFWQikqSIIXxmbATL1dDVZ3UkEdUVUlRZfxQKZ92UbZGqmkRJT4YxrWhUsmlZTC+zEJygBG77uC0j9uFtE552nZerOJ5Blb/W6knc9GCiMhi/hFpV0NPMb/a4DcZQTolQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7Medaztcjg5jyOAFW8zFBsApUhR+KUfLquwfhFLF0c=;
 b=GQU2Evorc035RERLXnSWsw+IUQezZ01wieu3KMMDi6tSofbV6Qr51xP4hdCP8EVJHVBgX+v0Zd8BdQ6kYUgFtYHAUpAjdeiqcHKsTsD1iYmoJpWwWyPIUylwu6rAnj9fm0DviVj47h+o7ILbsrAKY3gyOg700P5H6ZKRo8iMbx8=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5379.namprd13.prod.outlook.com (2603:10b6:510:fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.13; Thu, 14 Oct
 2021 09:05:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 09:05:19 +0000
Date:   Thu, 14 Oct 2021 11:05:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Grzegorz Nitka <grzegorz.nitka@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ice: fix an error code in ice_ena_vfs()
Message-ID: <20211014090510.GA20127@corigine.com>
References: <20211013080012.GB6010@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013080012.GB6010@kili>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0088.eurprd04.prod.outlook.com
 (2603:10a6:208:be::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR04CA0088.eurprd04.prod.outlook.com (2603:10a6:208:be::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 09:05:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83146fec-b6b9-4a91-eeb3-08d98ef1bec2
X-MS-TrafficTypeDiagnostic: PH0PR13MB5379:
X-Microsoft-Antispam-PRVS: <PH0PR13MB537972F83429C34ABBFFD932E8B89@PH0PR13MB5379.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:328;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/FL7SccpbnawwWMVd94yXC/aIcXEO+Tku6219EiPH9ro/8DzWrBtatwdEtRTbQVQJNJZgrhViJMRpAVzSzl1bS4t2eaawzxQ8uRuOh/gkvDqV1ziO+Cr2rnu7hJyRVrQOplJxyGGy5WyHfcs6KKAXw6XdZyuGLl07Hwhr2VU8JCikwPL9GOhZf3EiHIn5AqEO/qNdUlX6ogk7cuzWsYCobZQKG+8D8Ip0YkcGUhXF2KovI/zqUTM/5zp/5b/29JxANbAR5VhvLx62L37M2mTsLM068ynZCpGHBg7XsMUHho5q1KXKnW7iQbOKx2jeNWOYUF5YrEohWwdQbD9LCbdZ2HRoFUuuEnsOUoYadRTC7YdvfX9fkdi2OKbhgt7VMpg0H16bCK9FgfRwYgnTH4RrqBhpkTyGSL6GUC6iFJTe7AS1ECxWEMtFjMq+ZYIHeDC15u3kGWyyOmVr5dZmKExv0Flj63zTQSprzy4RB8amIZ62sVXRR7WwLwEDIkZDIpvOcpna0Gljj5LPXo8o8KNG0w/u5O4QKpA/Ehg27rO+n60uTAKs1e9hKWghbgjtArDMp7KZcKhOlPOQdasaaksjsSrar0V62Fa9llTPZnHTXs2FY7QfU5T3L5wKtqQxqhjtn72YZLb2nv0f2mZ3NByQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39830400003)(366004)(136003)(5660300002)(2616005)(38100700002)(66946007)(66476007)(66556008)(8676002)(7416002)(55016002)(1076003)(8936002)(508600001)(36756003)(8886007)(7696005)(6666004)(86362001)(2906002)(44832011)(316002)(52116002)(186003)(4326008)(33656002)(4744005)(54906003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UShO+2+VP+9ogvD9NOBoVG7U9C7wPHgldQ1C267BbO90dZqhRveibQ8xZaEG?=
 =?us-ascii?Q?kbUkEqBdtc1kWxi33gvwjSLNuvngrU41XZp/R+K2krMnWyJzRQIbJvTbNtjf?=
 =?us-ascii?Q?2lw5n+GPyuuuwlFYizl4tPXnamAvXELn3Q2VACH7RtsHKbllZ0TOYPsdFPM9?=
 =?us-ascii?Q?OTEhs6+gtOSYZMTZ54vWgQNWioAYV/qE3aPWA79u+kqQVzKXXzHffssTq2qS?=
 =?us-ascii?Q?LrYXqL9dh6SNIWilDwi7E5UzmWm4z+ouiLVY1IPxUMoFivZkr2TmCMdjMaZa?=
 =?us-ascii?Q?1Tr9OVX2oP8NsSHZJzQup5ynfVnx8U/cpzqGinwMsqPcSB8dZxPrit+jhSzs?=
 =?us-ascii?Q?x7PGSyc2P6nJqocVg9cQWP3MhHh820GOMFGNAf+STf3oIQXt9Hnp2cD5x7L2?=
 =?us-ascii?Q?J9She9DGvu3tYU9NK/iVZJ5CEvaKS83bqrakyn8a2bU57RgvvrhhEPqeW/vQ?=
 =?us-ascii?Q?MyoOk3L81xxIAr811K9SBcTBoZZUE9wIXL4ecGJeNlDVs/vvSix1apKB5QOq?=
 =?us-ascii?Q?5dmETR2c/2TeIUCTu04qArTARBZtIYCvinPyXspKbhIPDd5RO8qrg2OgCBpL?=
 =?us-ascii?Q?ysRF33hAt5DoyA38HR3OCaONoxux2e8NjXikjPUh3e7+stRfPkG1nJi1tbnh?=
 =?us-ascii?Q?GV4K5QliYR/vllctGo4EyOMjzIMz1vN7+KDNzGX4pOaJwd2WnU2/1OKkafmw?=
 =?us-ascii?Q?WoP9dUKH1uQdo5OXz9OiZD54Vy4EOzgdtU4Wc2Gsr+hGap/XpAChORb+1TI2?=
 =?us-ascii?Q?KrHjZQS/4dpKW0diWiFC7bjeMszK78H8Or82KGoLm5tgvav/CvzRyFq65s/9?=
 =?us-ascii?Q?KK0aZiqLity7QjxAYUj3bVELmTCRiughPOrGuA69ZPOr3TLCMoSDscPCQuU8?=
 =?us-ascii?Q?Zau0Y36LOFiiqvBS7Q/7JJxNcOqtO4JcSdCy8vC4B9GaJUM9fAJxsvC+CTv4?=
 =?us-ascii?Q?dDxStHD9fS2oPePgpguLJCaRjn9NhCbqAVBAh/3Z7J4g4D0s60S8mlrZu87Q?=
 =?us-ascii?Q?y9d0DE4Hu49atDFwJtWXbcZ8BI0VygH6QW+VyHB0Eu3o0VLhrIs6EUxmNwIA?=
 =?us-ascii?Q?mOgxs70HZuV4SC/IEsTwHvHToR3n7w5xdHcSbfmQPVEe+bWokEfLtQWYrs+b?=
 =?us-ascii?Q?pEwqR3MIq49upJ9y+ZanBqqHV87QQeFu6Xn+akpEzGequXzh7zcBUftc+6xh?=
 =?us-ascii?Q?udpoSXWr7b1AUF1w5BHR6Y6dRWBbPhkH8NuU1i1g7TY0WW8p4rUXSzYh6J3O?=
 =?us-ascii?Q?NCJxCVtlW/33m6TjqOERIX/V22R7Qken8rGKegGX66cLE31MuqypEBsEIJb0?=
 =?us-ascii?Q?8lb66rufA8YRG87TQkB2PR6XolVjaskqRFzrAXcoUjAaFVO5GZBpKWvji17r?=
 =?us-ascii?Q?XsFPFkIYMOlHlMYC80CdNhFo/vvF?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83146fec-b6b9-4a91-eeb3-08d98ef1bec2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 09:05:18.9300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mD0iQj1jbxy9PE24+pZUvCD8LJs8rbLw7BHEiBknmX+Dx1gRbhVZC3lbcjWcef5zy5wDwnURPFxveGHF/GlAfELouUKriKoK+9i30G7vAc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5379
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:00:12AM +0300, Dan Carpenter wrote:
> Return the error code if ice_eswitch_configure() fails.  Don't return
> success.
> 
> Fixes: 1c54c839935b ("ice: enable/disable switchdev when managing VFs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
