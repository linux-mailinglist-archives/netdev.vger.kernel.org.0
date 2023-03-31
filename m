Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD46D21A1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjCaNpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCaNpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:45:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2136.outbound.protection.outlook.com [40.107.93.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50F9C5;
        Fri, 31 Mar 2023 06:45:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbDmeNn1zqtPAvwLfRcW63Yo2Ni80CRQZvjfMewWZBEBDdzpekMNnrlNAfHaeYf1+WVyz57G/1KwofMA6v3wdU6rMxe7MHyry2alLUwi6kHwEQPBKK5p7E+Wfp2tjnTwOjOLqp87b8IhgBGfWiGlQpE3NN/UcxTTh9IfmbJFJaGyPiG0XMOkiM94mxFMs6VZyL95KAQc/H0Jvws2PyuwOMEoo52/j1moU0+V++OwjqekyYx/HQFRXZvN0QD1VquGdiYECMjDPy7h4cACyNJBvZrtgLzc7+cU87X2s3T2gOMfcj9JP5I9rOi/AAtqpD/CpngZCGOuQ9Be/prwplgEAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m726nRH7n0LL0TQJlkR95IMd5DPMWv53tnFELE5nLNY=;
 b=MxPj4CrgEfBpOfB6m3dj79D72kIMOuA+sWWD4HXSiRZJGTP7q2fFmO8qXQxzy2Oca6aPkASsbMCtfbLnPZ1fStj1nIppaR15tqPsQQmuiyTgKpllsBCINgQtFbS3yUvBdxeWXdS2+CSeZHSjth5J2XBNJhuYiHEA6Cj8mLUsj+1n5xFFwwFzUbBkhgxf9cHOzHbYQHnIlEomcW6F/rw5gxyq1Ieo9cMyyfO6wwPAN3J4UN3gaXCealmVh5084A8dfTTYJqE/w9xQr3ZVZwAWWgfAsMwmFpNN+oJ2rWFcHhRSiussceCcnIHhJrFr5ajQMRHZINcvmvGH9TquatqQBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m726nRH7n0LL0TQJlkR95IMd5DPMWv53tnFELE5nLNY=;
 b=aQHC5Nc+5GBLiEgKMYrnmtQUf4E4pTEdS3Tb8ZBAlncLTRiidg4Mo0+UfJQN72AA0EQYuFOQOPZjqf3pUfmxvqle0PN63ddYCocLAz61Q0GcEYOOooFfUWNq4BGz7Wtm50vK4HWYNzGW5AB35ZvKzX9IMDfBpkCevRzp0Y9NMno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4012.namprd13.prod.outlook.com (2603:10b6:303:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 13:45:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 13:45:33 +0000
Date:   Fri, 31 Mar 2023 15:45:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath11k: pci: Add more MODULE_FIRMWARE() entries
Message-ID: <ZCbj94oDuVYLJtBn@corigine.com>
References: <20230330143718.19511-1-tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330143718.19511-1-tiwai@suse.de>
X-ClientProxiedBy: AM0PR01CA0151.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4012:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b121922-b93f-4c1c-5066-08db31ee3318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZVWOOrzRbCpX1kOT3VZlExV3HqX68gbN01JVEDxQR1TmOcogOI+6PBtahKcaQI6HaBUIX0vdfvCaoaJotlyvUHtlPgLlWAD5EmxJh1SRgRsGv8zyetBBwq1sK92CbDgi2XX93RIWajLdgRbycIb1GOXdLoheIhq0Rg7KE8YiWKq9I9ZZ1mnk3+qo0KeqwnxEqmNApVEhDnFfo/j5QkD7QKx3W27HmVKwjYSvfJw564U35SIW2BHzz7KCN4rrpB6Ev+WQDDcrkyCVs3cIJKoFrf0S2MtN9t7KCGxo4ecK9p9qyv16MzcDhxy1sy0BEMpo4SQ0UCiqIpr48dOjsOVJ2HLjVUuQPzIuTViuoM8i2Tf1lf8foAdvFv3hpGnufGmU1p3GxaOraHG+ptuCY5zkpWCgSV/NoqN+4d93VA0uASPvE/+VeHsmKWJduZXTMak8ZmihgNWHQTM1L2e7IMHr279NoZKqYDjitgNRT5otQn3aYz7H9sRlW+sGZ/uNzfbffhdz70JX7uSh1oF303qQdGc3w7IJKPE0aebhf+dY2f8Ov+r9Hpq6aMgoZyICA8My4s2KxTAYmq/09i2d37Kj43KKikn+XQzlimFpL9C4sM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(396003)(366004)(376002)(451199021)(478600001)(44832011)(66899021)(41300700001)(66476007)(66556008)(66946007)(2906002)(4326008)(316002)(6916009)(19627235002)(36756003)(8676002)(8936002)(5660300002)(86362001)(38100700002)(186003)(83380400001)(2616005)(6486002)(6506007)(6512007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5zbHmNJNctgN+CCAP9cHDvqM5LSu4Wa5mioJZ9oFWXLjdzy93sw6C8YCiVA?=
 =?us-ascii?Q?VnQ4cwpp8coP3AEwCBc0Pc3fE26wOj97GV9KbQb856hoOQeYIypfbFjvqQ9s?=
 =?us-ascii?Q?CswEnUrbes1C1l7DGfZ00FJsrUnJ76jLomdtsksRVK+u1puHrVlLpWaSTU3n?=
 =?us-ascii?Q?t5K5mSMXv3nXDJKz5NKDAMfUhAVj3En0BDaSeUvHeSVbiDCswE8+TqGXoQKL?=
 =?us-ascii?Q?01EZgPMa8L0kSw/nCv7m3mC2uXyGb0Q6JJT1GprdKCb++evRnyHgZ+jy26Ru?=
 =?us-ascii?Q?tU6nrlrqFZQaQieFCUGaP1Uq3PXSECcfrmobgYDEMZnNeYCchRvxfA//lbRx?=
 =?us-ascii?Q?Lseil06untqK+NQ/EQH/EU3uQk0bdLe7/FPMI4qZ0IKnpVXdAH5EKZ1gZFzm?=
 =?us-ascii?Q?QtXzEb3oPad6nOXDnS/6VXKDlFUo+Yi/B2maocn8Wbt4mgx5tuEEVQnJ447y?=
 =?us-ascii?Q?T375PkX/g0BWZ0NK5/r8cMXmX4rS8TuJv7UYhy14EhkULs2y+kGHvaWjHVh8?=
 =?us-ascii?Q?l5KYX506OxCU5JkpdE9FGF2Gw/fzgy19GWZMFiTPVS1D9doLsULemp8Z8Js9?=
 =?us-ascii?Q?KR31aEvCnYtz4/7o9h9j7zhWWzom/DQdalSWaZHUS72mVw6MRCwi1+Y+6yJn?=
 =?us-ascii?Q?J92bloi4uYSibVpA/HEqVivE0v+nvBe4Y+mB5EtkBgt9rz6tAKXKh4lWO2tS?=
 =?us-ascii?Q?cunaqZ2GDku1oQV4ouEWzSBaVWuinNs3sWbfQlg6RMgcoYPvLibtBTR5veVC?=
 =?us-ascii?Q?SHwIeS3FaNmoourIizGTNFP8E9C05Kd6VhPpDWIOMqBC6c79DVtEVuWN0XEt?=
 =?us-ascii?Q?Vzm1P3k5OG7v9ZBug3kn3eAz2dvqGjdIKCBM+G3neFClp64kz22SISR6WAWZ?=
 =?us-ascii?Q?p1wyfGpoS+AVZwtSGAoy6yn+QGk3Wtoe+MezTzREfFBZeUHAeoa/XYZwLMkd?=
 =?us-ascii?Q?+YEdUZEO/rwBU3i949p01A9wI+5O6rajqcHFnSZr1Kdoq4wryWUhuMQe+D6h?=
 =?us-ascii?Q?Q8FaGMIcZA9SDpDD1LCnVJKqZLqbWPRXrFDDXOD7Og/WVWTksfoC+TD2WGsB?=
 =?us-ascii?Q?zoimIWly2qm6Z0UB92X9vCzWvjyL5EqlPU/JS5lUtJV2K4poOmXLojx26Wub?=
 =?us-ascii?Q?FBxaZ+7V78wubVKSjQcYJYId3aeYU3gvv0LyLjVVjXn5Spr/z079T8CDTz/u?=
 =?us-ascii?Q?5xOWv1kAsROblg7/SiJYWgmu5Smlu5aVeJaET7cUiwAf1QAVL+C+wyn0pgfk?=
 =?us-ascii?Q?ZsEqoQZGhT2uEdBxGxYBHjIiPNKoH77Y4NhK0LziBsJx5bq/I0JvHa6Ep/QE?=
 =?us-ascii?Q?JEJrTRlrbfpvAHIEE0xphaWgCl6no4pF+vd2XiTNZY+NDrsAhQSw5LWt5br7?=
 =?us-ascii?Q?IDzYqIByc1nH4cAR1qxysdPB4Ssw/AQ/tgI7ki8o5CYD87tOeGcUJc12RPRb?=
 =?us-ascii?Q?A/wB7/vSYcbpYwfH+Bwfmbh+1q15u1/On+chr+LAHWLogp9qAC9p64gegInC?=
 =?us-ascii?Q?zb6GpHmxZwrXcoIk9ruBIdigXdUcvw4Q5RzzN+IqwBItlFJHL1yxpHWHtEiM?=
 =?us-ascii?Q?+OrP/pTIuga0hdQM8Kj4aE+/WUps8WrSJvMDViqVmNLFP6+9HSSKXEp4J0S7?=
 =?us-ascii?Q?hxqT6+vVtXHqfGdW20YkTwK7K59CBz/gkx0jJ3J0uGBm+km6Bvyv6+2ZXUxT?=
 =?us-ascii?Q?AuE+Tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b121922-b93f-4c1c-5066-08db31ee3318
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:45:33.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ew9LkvHo+5RJaO6elm8azKWbcvKsnLzgjhSqvHD2rxLvI9s/Ucq07J2uU5FYP9aq/NSaZFxIPVII8d4q42i49Vm+I+pobdWskyGa58+b69A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4012
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:37:18PM +0200, Takashi Iwai wrote:
> As there are a few more models supported by the driver, let's add the
> missing MODULE_FIRMWARE() entries for them.  The lack of them resulted
> in the missing device enablement on some systems, such as the
> installation image of openSUSE.
> 
> While we are at it, use the wildcard instead of listing each firmware
> files individually for each.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> 
> I can rewrite without wildcards if it's preferred, too.
> But IMO this makes easier to maintain.
> 
>  drivers/net/wireless/ath/ath11k/pci.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> index 0aeef2948ff5..379f7946a29e 100644
> --- a/drivers/net/wireless/ath/ath11k/pci.c
> +++ b/drivers/net/wireless/ath/ath11k/pci.c
> @@ -1039,7 +1039,8 @@ module_exit(ath11k_pci_exit);
>  MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN PCIe devices");
>  MODULE_LICENSE("Dual BSD/GPL");
>  
> -/* QCA639x 2.0 firmware files */
> -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_BOARD_API2_FILE);
> -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_AMSS_FILE);
> -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_M3_FILE);
> +/* firmware files */
> +MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/*");
> +MODULE_FIRMWARE(ATH11K_FW_DIR "/QCN9074/hw1.0/*");
> +MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.0/*");
> +MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.1/*");

I don't feel strongly about this.

But unless I'm mistaken the above does seem to pick up a number of files
totalling around 25Mbytes. Perhaps that isn't ideal.

$ find ath11k/QC* ath11k/WCN6*
ath11k/QCA6390
ath11k/QCA6390/hw2.0
ath11k/QCA6390/hw2.0/board-2.bin
ath11k/QCA6390/hw2.0/Notice.txt
ath11k/QCA6390/hw2.0/amss.bin
ath11k/QCA6390/hw2.0/m3.bin
ath11k/QCN9074
ath11k/QCN9074/hw1.0
ath11k/QCN9074/hw1.0/board-2.bin
ath11k/QCN9074/hw1.0/Notice.txt
ath11k/QCN9074/hw1.0/amss.bin
ath11k/QCN9074/hw1.0/m3.bin
ath11k/WCN6750
ath11k/WCN6750/hw1.0
ath11k/WCN6750/hw1.0/wpss.b02
ath11k/WCN6750/hw1.0/wpss.b04
ath11k/WCN6750/hw1.0/wpss.b03
ath11k/WCN6750/hw1.0/board-2.bin
ath11k/WCN6750/hw1.0/wpss.b08
ath11k/WCN6750/hw1.0/wpss.b05
ath11k/WCN6750/hw1.0/Notice.txt
ath11k/WCN6750/hw1.0/wpss.b01
ath11k/WCN6750/hw1.0/wpss.b06
ath11k/WCN6750/hw1.0/wpss.b07
ath11k/WCN6750/hw1.0/wpss.b00
ath11k/WCN6750/hw1.0/wpss.mdt
ath11k/WCN6855
ath11k/WCN6855/hw2.0
ath11k/WCN6855/hw2.0/board-2.bin
ath11k/WCN6855/hw2.0/regdb.bin
ath11k/WCN6855/hw2.0/Notice.txt
ath11k/WCN6855/hw2.0/amss.bin
ath11k/WCN6855/hw2.0/m3.bin
$ du -sh ath11k/QC* ath11k/WCN6*
3,2M	ath11k/QCA6390
4,0M	ath11k/QCN9074
8,1M	ath11k/WCN6750
9,7M	ath11k/WCN6855
