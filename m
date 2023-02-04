Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5068A9F0
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbjBDNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjBDNLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:11:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B48EC59
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:11:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrnxKkmjB8COIs/qY7Bm8AhJJLNivCOzzHLWRX9G6vzBx10VaTc3mENOk3vpaWssqCBUKG0k+OnYMRLu8IwNU7rPVnqXKKbP+S72iL0jWer8IpmbPglDEbs5AiLL1T01/4vEpFu2/CmY0mYQRm7xHiX+8umI3f1vnLC8bUO3CtjlGGnRshsRnEeAUFGAJsoqxaEFTvybiFvq/j+tFs4sg1krU24nAJCjQ9th+M6NshkaQYicDuB/fgOweVV9CenWkAZnGsTwsk0TkqrorMSWoW4ghFe42YlugUynQhDd9Rl5DaSZgFkgdU//gTKaaQQelbU7J/lAcPZr+L/DcxrW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znWLWHy2NU23PGSdGKBnlRxx6O64YmrQ81GxAwXxpwY=;
 b=OrErV+tRKxdwAcQCTxTdK6aKGpuILiqW5l2JffebeREzBW3JdTRK/s8splAAtTG4jv3ab/tGt5x1PifZGFkSF7MkMSb/KgYwKoIXVToRTdaoN7pgyYqla1bmHdOG2FrvKHGkILN5LtNIBkHxIMUocS56sOlFL/yFH2H+s1bko610E99jFibeCjkO0O43MCWtpIf0h4ss67kAFq0bOiZQyXTlMvs4EVcWGRcIrtVXvVVtxR4T+UQsbhZuXCbTbh6F58vRd31TzLLOgsFlmVjv/C/j5XbQ1nFBL5svonaxvFocDNCY0GIdJnqjjKpaBMSFd3CdvafFY037yHyT1UivVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znWLWHy2NU23PGSdGKBnlRxx6O64YmrQ81GxAwXxpwY=;
 b=CejGALBzBOPdztKjYft4J/7lTZcmwwdQyKjBFf2tidZ+pAxGt/kL8wAr92LRlVgM48sQZB61RDm0HLL471+lprQdyxdvFDL9m+0vOPRB8CIJuFJXTDOmzaLbr0o4eH00PkbxPc7YEgypwmrc3/60tk2TQVBdtkVF1qE/EhHEid4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5223.namprd13.prod.outlook.com (2603:10b6:5:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:11:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:11:41 +0000
Date:   Sat, 4 Feb 2023 14:11:34 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
Message-ID: <Y95ZhmHw207JvReL@corigine.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
 <20230201054932.212700-3-Raju.Rangoju@amd.com>
 <Y9qdRsS5txwu3MND@corigine.com>
 <52212a21490af8e45588bd0e17ffc54655d44b87.camel@redhat.com>
 <Y9zBL/3GdBRRRh+i@corigine.com>
 <325a736b-b6b1-9863-3efd-c61f4ca8ae76@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325a736b-b6b1-9863-3efd-c61f4ca8ae76@amd.com>
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 35e5de1e-7da3-431d-b424-08db06b15b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mbHRPRg88e4hozYRx9d0VhyIiTvRJjk4LE63W0KB7pzX5lpokj/v203doLKgNRHjNzkyBwndkwpps1aEPzUf8vqC662duIBHpfrhIQnBq7XexUdLWVG4apKmnrHdKKbXKLRDWhS/7NhBgpwEF1bN/I/C+GL7Vqe+kQ9LAIt7gyAMAdlsKErCbG18aW4UVG6hNZIM4lnH3cOQx9Qt1D9EYwX+hXcjOSiaM3hVgKVEPfi38eXpwRRTcikNJRR9lX75h1eEX3DRAzIy9umanER9/4tgbShJITADR8T4Q6IU8wiuXQKCuRt7LD5Una+x3h5vQj0HCLANspl+Jy8WA04L9YrYstq39kWcNQ0LDK6uDwk/knwXd1QcEjgR2btzIyveTrQHlxarVKJpbsRgGTae879ALxs1YPRAVKkrCswunWfJb7EzrWSWFKDjM8U4C76XAkdg1Prt0HudtbsQBjxfuxDzyYLjrMp87Nt9NdTVBsKlzz/764QzjkRqmUO6acoGDTOansaV8Netb4LqR3JWU59jXwa1FtblVVe5qdL35e+Omjr26qZ0HprozU4IxU3KQ/oucVKaJQwf79KYeJPFT5Wa9fcNF2yjrYKHdKURmpZoVQjSeEuIvMta4GHnnv7WpQqWDtq23xgyL1WwAFfr+jbsi3mQS8TaihvXtINkgxeRKXK7iQlPbr0p5o6vUnu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39840400004)(346002)(451199018)(36756003)(5660300002)(86362001)(66946007)(8936002)(66556008)(316002)(41300700001)(66476007)(8676002)(6916009)(4326008)(38100700002)(6486002)(2616005)(478600001)(6666004)(6512007)(186003)(53546011)(6506007)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RdCaM5EiiIzpHPFu3mQHctZKbdRZcb2P00WXNs4Ac/mgIu6QgAX7jpKh/rZL?=
 =?us-ascii?Q?ba6WD+oKoXSdyWqc0/EzvQpf/4TsIEANSXqcIqjkwnR3Ne41rC+l7JlEmomg?=
 =?us-ascii?Q?fz5MX0E4qx4ztpF1EagDGNmVf9wm3SFklOFTiBkWhnmCbK4mCEO1vfl02LlX?=
 =?us-ascii?Q?B58Ds56zQwPKsTxWtZl5II1n9cDzJ9W3k50IL+YQESmodsGZMNdvESt/EaCX?=
 =?us-ascii?Q?T4E/vHS+cjvoXau2S3dI24lNe5Yzh5lnQdVW0eGHXvp34HQ+/Bcb1DjXq9Vr?=
 =?us-ascii?Q?zo6TaYjbct0/i/0p9/owxRUhSCyyf1ib4NdNduetNlY3nwxVWKiimU0ead74?=
 =?us-ascii?Q?u8B0bdiG9JMG3Xmt2nIrQFATsb4ohwRKHMG8qxBTX5Ypsc6EZYylCTByNhzj?=
 =?us-ascii?Q?Tkubsvu4zcoE6Xo+EBqK0lcTuYl91UK01f6sh/fFouibzxaEPajqWJQXD2l9?=
 =?us-ascii?Q?9+mHZk7XeOSZEyH25I20556P+kXkjTwfBG/Cscu+3i/VSFvhlE0ilgry2hcz?=
 =?us-ascii?Q?ZBXs8TAbnakv9W/LIE/ypXR6e4rNqWK1HcGKPplJxj3wCKQaOG+Usp5UPprO?=
 =?us-ascii?Q?nEN8z3rMnvPfSdh0sbxzfAx4JQFo3KdnInfIPczLOdYT46uu8e7F6TuPO7dd?=
 =?us-ascii?Q?Im0DLV/lT7yO2wVIAqcSY+Ep9qFfZ/jen6+QNDLraCMrudQzVuk+TubA2mVT?=
 =?us-ascii?Q?tvVmdYkArR2pLjOPijiuz9OJhYgbSf8btqBfxPP6EIuNW4JoIjqDMmdPJlK/?=
 =?us-ascii?Q?lYoky8nWud9oQ1H/R3KgRN6ueblJigJS3fvJ6yhwSQymAay2QPIX6MwSR/Af?=
 =?us-ascii?Q?ANcLkw3oqxn4GhDDhQhH2xVqY0ASA6IEmAzQFlzgeax2ePaduQR9Jo2Why+S?=
 =?us-ascii?Q?5W0cT5sBfvg7rF0mnKJxdXhbnN4YwSgT4zzb51hE65/npM/8clblFEBx+mR6?=
 =?us-ascii?Q?pY9v9y1EPbY9e4zyxWjuASyONi6EKVwYdEOuztT2/Ko+M0eF/4UJM7V5/3YX?=
 =?us-ascii?Q?7C2dhH1SXeLtohI43PKfVqKu/0ka31qcpalDFC4km8tIV+kTt7rWm0t8/3Lm?=
 =?us-ascii?Q?mfTByZXLN/zeiKYiuUOHtiEgtYlXI6zA9SXp1u3/ic5vM6XOJEfrA87zN0cD?=
 =?us-ascii?Q?U47XD9+Gzkelb37CJKTrclrPMo1J9bSU4pmHdFdzRl2MLIwEemff+cJVHsAb?=
 =?us-ascii?Q?4T+xoPZ6mabVYzry8zVuWI3HzsnS7RDKAjd9VGJ1zPpgKqXrL1ntHUEsZCYr?=
 =?us-ascii?Q?Ox85zNp5oE2ECqmPNLIkMQg6R6ipT7wpVpBQGRVpQJtn23//jj9r9x8VNxFC?=
 =?us-ascii?Q?u/fFIEajvpiV9g150Pd8dNAmjGLQ+OIririplBGpa+ypMOz5vhnB/J8BKvtI?=
 =?us-ascii?Q?wpkwH8c9SXvXZWwKUFHAvyMulMWbbtda13TRbHTQG+EIhebAzMp6NmD+il61?=
 =?us-ascii?Q?sqODPQo+DmXNR8bEDFEQ8qYjqQO4Jgq4srQlHlhbrXCzC0TOK3EVzKoi4WfE?=
 =?us-ascii?Q?s4IsPJ0SYUHQNW214EqzxJsGsBwKJRSep9yaXHIrb6+n2acbEwuN6xCmibyX?=
 =?us-ascii?Q?REiwelVp8JCe/JSPE7x4QS/mxv9bU5c0Kounzd9flbbEGllkbt0igJ77pV3B?=
 =?us-ascii?Q?ohd8h3ulAwmJ7+E3TJaHtTcg3E8OmhNDJeQoodRCZuaUnov3MF8TZDLgNrsa?=
 =?us-ascii?Q?uZvvzw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e5de1e-7da3-431d-b424-08db06b15b5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:11:41.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCh3hA6KosimjvFz/BRvxxjllGJWfpqkjhw5iLGt7etN826oWNLlv70P0Z1dN6cx/ATAyrttZ4+FBmUIRpLliagXhWdyKEGwta+20gpC2Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 01:49:01PM +0530, Raju Rangoju wrote:
> 
> 
> On 2/3/2023 1:39 PM, Simon Horman wrote:
> > On Thu, Feb 02, 2023 at 03:16:50PM +0100, Paolo Abeni wrote:
> > > On Wed, 2023-02-01 at 18:11 +0100, Simon Horman wrote:
> > > > On Wed, Feb 01, 2023 at 11:19:32AM +0530, Raju Rangoju wrote:
> > > > > The existing implementation for non-Autonegotiation 10G speed modes does
> > > > > not enable RX adaptation in the Driver and FW. The RX Equalization
> > > > > settings (AFE settings alone) are manually configured and the existing
> > > > > link-up sequence in the driver does not perform rx adaptation process as
> > > > > mentioned in the Synopsys databook. There's a customer request for 10G
> > > > > backplane mode without Auto-negotiation and for the DAC cables of more
> > > > > significant length that follow the non-Autonegotiation mode. These modes
> > > > > require PHY to perform RX Adaptation.
> > > > > 
> > > > > The proposed logic adds the necessary changes to Yellow Carp devices to
> > > > > ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
> > > > > AN (CL72 not present). The RX adaptation core algorithm is executed by
> > > > > firmware, however, to achieve that a new mailbox sub-command is required
> > > > > to be sent by the driver.
> > > > > 
> > > > > Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > > > Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> > > > 
> > > > ...
> > > > 
> > > > > diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > > > index 16e73df3e9b9..ad136ed493ed 100644
> > > > > --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > > > +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > > > @@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
> > > > >   enum xgbe_mb_subcmd {
> > > > >   	XGBE_MB_SUBCMD_NONE = 0,
> > > > > +	XGBE_MB_SUBCMD_RX_ADAP,
> > > > >   	/* 10GbE SFP subcommands */
> > > > >   	XGBE_MB_SUBCMD_ACTIVE = 0,
> > > > > @@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
> > > > >   	bool debugfs_an_cdr_workaround;
> > > > >   	bool debugfs_an_cdr_track_early;
> > > > > +	bool en_rx_adap;
> > > > 
> > > > nit: there is a 1 byte hole here (on x86_64)
> > > 
> > > I think even in the current form is ok. The total size of the struct is
> > > not going to change, due to alignment, and the fields will sit in the
> > > same cacheline in both cases.
> > > 
> > > I guess the layout could be changed later if needed.
> > 
> > Ok, I did think it was worth mentioning.
> > But I agree that it doesn't need to be changed at this time.
> 
> Thanks Simon for taking time to review the patch. I'll try to handle it at a
> later point in time.

Thanks, much appreciated.
