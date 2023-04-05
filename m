Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F146D7C44
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbjDEMQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbjDEMQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:16:08 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2069.outbound.protection.outlook.com [40.107.105.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6479B40C8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntdGB6zjCTe0W9OYh6BJl2bW3XAeLuEMgbcynzVjB0Jt3c4li3eks4q5rrVXTEgbI3w8yJgvx/cwqi3o1sjkhIWpQW/0Y2hqjxVBOxdjEjiM0mgyYbYWI6/PKb4g+nBROAlzJdDK7GCtU+07XxghadMvvlabtTIhZ7TYbVCO8khrzZ3EkwinEhrUw/kYsN+cj/snrQB2XpIHQIeN9L4CYeUBayoxkHJ/Rzgw3AjMxg/T1kgR1PrS5TOjjo7UbpluNWaDr39EVu5rln939edXrObbQmSTo5bknS9JtydrsOams1nSrrEVvhao9tJf8MJJxjLPH5PKFOwcFtcH3sWybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdEQNwtAJ6zY/rjOGaJdfqybIlcSbAnxtU+/e944NBU=;
 b=VCS8n3BuXSZCP8czS4TUp6vtP9Tw1F2rEuYIbBN270kUlg8HrKIQe9/ENDAR2NadSD4LX9qoxF6hva3hdpclCbTiwXylxvYWnDnSxA0Q06/UkgzK7gKMF4u4nO2Ko34aH1kCNP9nYqND5XnCT3QbhnPbhVFQBVs5XejrM4d/Bt693HjyCfuUWPB+s2ossEk1oF9FP4+Fnl4vPEhfBqWM9+7NJm/uRvqnukf8BItbAotpzsH5zqQiK8r8UrAkaxj6PHHxfkOMrM7GxFH9uymE14mHGgPGK3U3cwfwi9VpBt3fbXKms4AsNpA2J9bNGEtSJR85qAZ2SnTt09fkz8cJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdEQNwtAJ6zY/rjOGaJdfqybIlcSbAnxtU+/e944NBU=;
 b=qDRWegDUAraveG0ibJTGFE7EAMD0x/SZSXq1yBdFe++0PgM/yu/EONbwyoRoEkdNr7lNRPS/IVFvHGK38mXRQPqlPd4UrZVr5tBsWtSnQTwAt+o+x+M+T1NUNa1GauU3sIkPxN+Wlop+K8LF+ZO7SY1G186g906SnKzI072KLSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB7665.eurprd04.prod.outlook.com (2603:10a6:20b:283::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Wed, 5 Apr
 2023 12:16:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 12:16:01 +0000
Date:   Wed, 5 Apr 2023 15:15:58 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 5/5] Convert Intel e1000e NIC driver to use
 ndo_hwtstamp_get/set callbacks
Message-ID: <20230405121558.si5jstt4knmprarb@skbuf>
References: <20230405063338.36305-1-glipus@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230405063338.36305-1-glipus@gmail.com>
X-ClientProxiedBy: BE0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: f860cac9-f1b4-42c1-22a5-08db35cf8579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nh8X33MYtM1ERNoHTGZ1xZGTHlPKbqYqpxWCBvZJwPkjfTJS2zGZbFt2GjC1+2S3Ft3dfJ2SNa3exMRD+PNDRltseCxlp9Z63+QdtKGEIr1Hc5erfH6wGjr8sjV2rW6Ft0zG23ktY7d+XcZFqhDMa/uad+WattZedGpVYecu65bbc/0/vT2jHhP0FAB0ZvIGaEUGK8MbvMvlEDWaVr+hsFKW7iTu/7DPDtkQBoWcdksQyCY7XusFi7L89hIRjsatsHj6ULDmMy5axCvYUg3CllfYVWPXPII92+bc79AbRRZmjdMw6FBA/haiJpgKa3ZQ922l5IM084MKlxtbNk2E3buqjvgEvRHlXO0qx7PcJtRfMgPFi4cWWQ/7lpj1lxHAk57oAbjKVRM0OHO2CI4U+by3CWYPJfJaKyQ4+PQdJiFadHRGBgphFCzgDtFHV5I8lAkyatTEYY+HweqiR9op52e0P2WEEyMHjj8A/84Sn8vjaGHNTxwf15m0T6x7jl3mf/JXKQb8PeNixA0s7VC4Cyq/FklTsWMAHOOWHHSFaE4BGLfbDpPtkFC/RR7PDv4e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(1076003)(478600001)(66899021)(316002)(5660300002)(8936002)(86362001)(4326008)(2906002)(44832011)(8676002)(33716001)(6916009)(38100700002)(66556008)(66476007)(41300700001)(9686003)(6506007)(6666004)(26005)(6486002)(66946007)(83380400001)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?NUnGNA7osAmbkNVI10NNSxVWRC9Go3mSQc2NTBaXOuTYDh9ZSQL7ID0UyC?=
 =?iso-8859-1?Q?ypdBl/FjikczPHZt2itDGtISrHsJEbqOXDnRnPTcNiM6TKavCtDY5Oe/kq?=
 =?iso-8859-1?Q?iF9EDtjtCIa7iAPwmAvQoG/DKnUYbxEXwICM9sx+FuCkR8TvSx4y7XlIMv?=
 =?iso-8859-1?Q?c4QE4FmwTBzqZc85j6kPj/5hYTe12GnQavtwKXSm4a6ji7aDonVPSCLQ0R?=
 =?iso-8859-1?Q?PlxS7BKIk1Nrvued+uN1TRmibijfjUvAdfB5IIM+RiJoAuCNCrlG0Y0Q+z?=
 =?iso-8859-1?Q?OExBN6U0x/hObl+yRqd7kZIN9JHjNeh++emIeD1YMjQP/MDE0st8EWj2z9?=
 =?iso-8859-1?Q?ZJu3ftVvlDMeAk5bxyvwYAA1auYRQex1Q8MiU+j3FragnGcd7B9lJ65/sf?=
 =?iso-8859-1?Q?cbZIG0+NzhdPnOQMS+3M54weLC78poIE8+a55YssPeTNggMH4YpOw5EKlc?=
 =?iso-8859-1?Q?LkqSijSSHPrdXGC9kjB49J8utRzWcrOpi9d5KBVtBlZXujao56OU0i1AL7?=
 =?iso-8859-1?Q?bSKTr7ZbS9n8T81oiVEekINXCoAdbPJcRHSAj8p9dFi0FI3yabLV9tA0up?=
 =?iso-8859-1?Q?oCmoJKeA0BOKNc0ZmGiyo8h1Vj5zkp85X9AU4UD5ACXk/1HWyesBtqmAoG?=
 =?iso-8859-1?Q?GJ+Eo5sLuW9ISW5SejPnQaAMfGCu6K87SASX3BG3y9qmDpjNqxBx9nVx4K?=
 =?iso-8859-1?Q?pjt4avupmln0nvSPUwJoOO0vqurJtHraf3TlxxeMqT6cm/bF9LqpwTs6F9?=
 =?iso-8859-1?Q?5stBMYqfCTWBQI+mvPoB0MMWJJY4+/udNzWn1mNvw4G1XUgfUUjPwiAZjr?=
 =?iso-8859-1?Q?Qe0YDKDcjrOyyQWYUml8fPckjMLn+UgtaKhOe3Lw1KsW94EbRORK/y7cYR?=
 =?iso-8859-1?Q?0bovre0D62FV4agCnW/7xnsPRltyCtqXYTP8BbiyFp5FDakzUVJo0ibJlG?=
 =?iso-8859-1?Q?DQF9DI5G2JDotPcPJmAcBS8Gg3AEng8JTuMWthDC89ex610vLBQX8Xpwtl?=
 =?iso-8859-1?Q?qG8R2DAeZhtKMipYiOylXxNstzen5JHU0935pbOwLIIoDzcS1iQohO6Vc1?=
 =?iso-8859-1?Q?n50sGJe/72Cqbm/fM5oqK2tyaNlOXgLvfiVSZzhs0GHw+jkNbcAUMOSabG?=
 =?iso-8859-1?Q?pEvT0Jh19/pR2GmwKnx1SL5CBe/W1/7SCvtc2XXMh3LBIOd0ugVsoukt3E?=
 =?iso-8859-1?Q?9kR1VLmepBpmem/Q6QXC2QMl0JPUqz60+YPa6SeR4jqMvBUT9jRgEwYCHD?=
 =?iso-8859-1?Q?CjsPYvik/1JdcVDOzt4pHyaRcOjBKrGwoLp2qmPx9o/0IAkguyzw5TONiE?=
 =?iso-8859-1?Q?PwrHhISZUZ8pfPGb0FBLJcJgMLM4ePapUWWWIMqh+PNDjz6s3tFJUSXc7k?=
 =?iso-8859-1?Q?A3BSEQvzU+R4KpJX1/AAqNf/M9ROsquszcrCJwJkDsJC4S+lB41tu3MElW?=
 =?iso-8859-1?Q?+kOoumqMVKUIFb/D/96KSBrAn0WcLBExz/5YMhWTD409cMC/CqjcPOVRKR?=
 =?iso-8859-1?Q?6xc/JybjaPbPXeTXjnxLq9FxiqdvlAlMegbIUibhnekCjF9w9ZJH+LTO3d?=
 =?iso-8859-1?Q?QW/QCzh6ktc+aLZt4CtqNE21yApkfloqTkH7JhlvML1dyEn2fck6d0Mibr?=
 =?iso-8859-1?Q?a4SBlt1YRUQYlYRI2XHejgqHKbWIp3veVADd2u6+xarFYa+1x51hSJlg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f860cac9-f1b4-42c1-22a5-08db35cf8579
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:16:01.8306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IkyebWFcONkDPn45rpu3eA04exLTACm0jsmjEdubwupDIDVZ1ZGrql2aVOPtmQ3gXgJ2cYBYBDZm/uF6tB8q/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7665
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See "git log drivers/net/ethernet/intel/e1000e/netdev.c" for an example
of commit title formatting for this driver.

On Wed, Apr 05, 2023 at 12:33:38AM -0600, Maxim Georgiev wrote:
> This patch converts Intel·e1000e·NIC·driver·to·use

Strange symbols (·) instead of plain spaces here.

> the newly introduced ndo_hwtstamp_get/set functions to handle
> HW timestamp set and query requests instead of implementing
> SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs handling logic.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---
> -static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
> +static int e1000e_hwtstamp_get(struct net_device *netdev,
> +			       struct kernel_hwtstamp_config *kernel_config,
> +			       struct netlink_ext_ack *extack)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
>  
> -	return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> -			    sizeof(adapter->hwtstamp_config)) ? -EFAULT : 0;
> +	hwtstamp_config_to_kernel(kernel_config, &adapter->hwtstamp_config);

Why don't you change the type of adapter->hwtstamp_config to struct
kernel_hwtstamp_config and work just with that?

> +	return 0;
>  }

Since AFAIU, none of the CCed people offered to test your patches on
e1000, I guess the options to make progress are either to CC some Intel
people, or to convert some other driver where a volunteer does exist.
