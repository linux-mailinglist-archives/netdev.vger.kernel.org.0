Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE463B765
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiK2Bp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiK2Bpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:45:52 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2111.outbound.protection.outlook.com [40.107.237.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85D421AF
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 17:45:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3R/r1LX3TzJHx2Xn+P2NGFjPo73C6xzdThJahDB5vVVMCO7V+WXHioAuffp/veeygj8eQGc+XMpfWTbfpyEb7c9S0tYT7sciSYWL30ao2+HivS5qvP6H8LeiZhhAsjiBuZ2u9GOqt8wm+dxjZxv4Mc+U9I9zrxL5tYUdoUAM3t0FM4av5KsH2nnpOq5tQcWNh7CLlGpZMZL1lgVqz9e+ooRP5CIyRiHRCYCGnw104UKB8HvVKjGFmI5x+AaPqChibUpYLx8xa7bwNSda1Yp3mZZan5QOxzHCZWGQ/zbSfaxhgTYEL8wt8idTdbvyXmDVS4r9dXxeMX50VSk2R/I1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc3L5gKRr1TB+q6WNj9D+DBp/qJk60bUQjpNoi0W3Hc=;
 b=i6tGygk25o1JTO5BjoOh7TgaHTxP4VuK1Bp/6i7Vhm01+tUBaffAFNX+jUKxYRGAFwDFvWlhuDA3vgMd9IPGjm+6kGGH3XNNo7Xs4zrxpM94fb5eudgJz6FUxoxcmiDeLAQLyKT2suGTAcCbEJa6PSePrvTeY8h3maAP5qyuQcFSb2SE6DzSs7TTopLEM0XBGEi/fXVlyfLU/dBcZ3nblztd3unS9y2e5RJdKoYobB54PjN61+Wcka0I3CSALNR8Hnjn5mrmMRPVwXTX+76cK04Flz/z25SDqY+DEwoQUuD9HfSWwezytZNVjoLFj0Lb7LqIQWs0pDlvjo8aGO5Vig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc3L5gKRr1TB+q6WNj9D+DBp/qJk60bUQjpNoi0W3Hc=;
 b=XdaGYKCKZhl1sQFTgtQ7qv0yZXxtFQkrDSV/OMrPbgm9A9B5s+c0CHiwBkGN7l8Pdg9UVR9m7lKWG3ez2M2CVX3U0kN4SFz+3uoBZz26vyimr8snKVtBafRRDyIMm4fV2hcK9rDGQannPcjgucOIWMm/UOxjTIhXAiEA4ddh3yw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CH2PR13MB4412.namprd13.prod.outlook.com (2603:10b6:610:61::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 01:45:49 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 01:45:49 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     alexandr.lobakin@intel.com
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        louis.peens@corigine.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, pabeni@redhat.com,
        simon.horman@corigine.com, yu.xiao@corigine.com
Subject: Re: [PATCH net-next v2] nfp: ethtool: support reporting link modes
Date:   Tue, 29 Nov 2022 09:45:41 +0800
Message-Id: <20221129014541.33526-1-yinjun.zhang@corigine.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <20221125140150.79646-1-alexandr.lobakin@intel.com>
References: <20221125140150.79646-1-alexandr.lobakin@intel.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|CH2PR13MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc5edc9-ad16-4750-9d7b-08dad1ab70b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R80UaVrKPAI0rj3XFYsZy4wQs+j2XpmQNuPWxhFgh2C36CrM7M53O/riea5DxzfY01sQoACLeE+SfWWTjEqKzy7VpXApAwkXo33s4oY5iBHaIe0aLuY9kLbJvUxCEzIbmTDuidIbaK7t6fFlym5N4syExrVOcTv3Na8WYewcHw0oPzChQvyjyP71w7DVyuq9zGDQGp7yAq0wSAm8TBLiatizeK0hls+xQLxsPoSQBRDyB9Pdv9y/JQaHJLZHv5qxTFMRW86jBqsA1isJOkktdrLVAvC+VilobhmRMW234a7vFc4Xcnf7UKpATTgYMmXrTFjGe0095cO0PTbDMNq1SDS8k5irWFch0nOgp/YOcW8wMgSj50MfzU2hqkefECp3uGn/xVX05+c886JIAq4i1tIRR4WvQuJuDh+v9nwa2hFzXucM2Quby8+hKjreF01dyKnKX5Bhv6eRsKTTrtvyw4x+BxuPqM8fr6vYQRKFt66kpgpfn+J1H7BJcl/ySsKcah5F9Cm7yBYAmSsgLI62tVo3YDZfcUnZoLsbQD9YTYpUGb4s7iUmZa95rXWsmXeuuPxsJJn70VZW5CGkQNhSFKyn6/XrOvJnD/yETo33iEW+DasUnIpHB+6ewqqDzuYdFqUWy5q5vAK+nJw6P79E5PUBrT/nJ/rXDR6dGKQDv9Q6+pztIZhv/y5vJTg590thRQP8HZnxtwPqZ0Tqskrqpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39840400004)(136003)(366004)(451199015)(2906002)(41300700001)(8936002)(44832011)(186003)(6506007)(26005)(66946007)(52116002)(4744005)(1076003)(4326008)(66476007)(86362001)(66556008)(2616005)(8676002)(36756003)(107886003)(6512007)(6666004)(5660300002)(38350700002)(66899015)(316002)(38100700002)(6486002)(6916009)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E6H449L5aPlFI22jAcRAldNrmWDtnYolvqx2ud/eM5CqaHNdnlhOfSuLSdIB?=
 =?us-ascii?Q?WqS0HIJuyRjjwNIMGe6uqKRX+Q49IQ8C8U5gmShb52Z+uowQkzbbLHoM+1pF?=
 =?us-ascii?Q?PuImWtuCmSRWozuSfRn2AMEuRRKDpFlz3ltFcSussXT1auGyicGoJPf08g43?=
 =?us-ascii?Q?xqUzGY3UmgFcB/Q+hXuHg9RBFfPgYTXaZ1S+4stspkHjw0hvoDWGu8s8n56f?=
 =?us-ascii?Q?AvJ2895NZ2H6W89+cGaGSnBseLHS5Ym9MwcOqCVPDYaifETUOT1LbY6zBZ3F?=
 =?us-ascii?Q?KWEaNWWl7CQkmPtWY7XcCVpZ/NXiQm+7oMSQVcMLuREcm1gWRTy+yn5taZOy?=
 =?us-ascii?Q?l9TCIoZgLobTYUtigX8W1dJQWTH1TRv3Rc3TQk9WhSyrp+yLhgJzQPwVmsZ1?=
 =?us-ascii?Q?Gojh7BKS+tZK2Mib0C0TkN0Au9VG1T6JRQaKd7mcWQk5r7iD6saIcBC5W79E?=
 =?us-ascii?Q?8Xw9dmPTAuhR/ynWLF2UUEFuglvkL/uKxe2XvmNnsHM65THDaHc4emcqm3ns?=
 =?us-ascii?Q?Kcvqu6d1WdwMNz/E2wOCvhsl9Imv5auW5QL5VbFHIMqtw2l1anVWZMdgusgy?=
 =?us-ascii?Q?DPGZqqMCGJINeEU0ErMOuOgR37KB65EPsgCkfO14bz2pcZ497CCdMk3Y6l6q?=
 =?us-ascii?Q?zRy7tfLrIbgiGMrprPSLnXW0INMtcKuheWM+E4IX7s6tXlmoucCRWj6szqcf?=
 =?us-ascii?Q?VtVl6LXk/uPscuHyjLd6iT7EFARkzZXK5/w0YgyiqK5CxZ4qJuVLKrMlPPfQ?=
 =?us-ascii?Q?N3V58Kpm3dZu6EqWheHZeRZgQj3MBQKagJnEep3uK3QxqqFXWEMxqBSUMYXo?=
 =?us-ascii?Q?4N8PdMavDT5XBJu0flVzdhRP8AW4+8ZRtHyxs4Dqla1oxBGNaz02gTwuJD1i?=
 =?us-ascii?Q?79RBxAA6AvBo5VVXHClbawd3JiULYmp7ElkJAWkOOtbLVG6hh8sqbbFP7v/p?=
 =?us-ascii?Q?FPGWWhCdPAgAzFtqmPpYFPFW/sqm1dSNvNnwjYOhXIYrypvfzRl7NHCrmBVk?=
 =?us-ascii?Q?esUBkUrfOJzllTsFMakhMpIdkA6LZN4HH3VKVeuLMYtXs0m6apertHS3U1gZ?=
 =?us-ascii?Q?QbS+g/y2UfKF5nVy6Bbwg7/ajXAM0lMGgTC52ew/lXod5ESxHAbT3sPItTFz?=
 =?us-ascii?Q?9/+QdVjQtctTQFNGZMeZcBVwJAYFG1GvrvtFoZChhJ4Gq8Jz1rPn6jrF+9l2?=
 =?us-ascii?Q?GWKtbKfo8pPYaJhSa8dnkhcXHTQBP+7V90k1VkYV8tWpT+S40JC99JjCJctt?=
 =?us-ascii?Q?1oft+IE72Zq6ddhmOvm78srfoV35mgkk6z0sNJinYTtVEwWuwkjBR7DrE1Jk?=
 =?us-ascii?Q?gS5Ej9S7Fi7o4eOn01ZOAJ6dlSCVrhl8TZkoXeocZXUM4lpLFcMBABGjlLvs?=
 =?us-ascii?Q?/tjeozMKJQjbyahdxVqOTLcPJSFmLJmty/cMD6pMjFAJJfHKTEhrh505Bk/j?=
 =?us-ascii?Q?xXgFprvJiIEVndNhb1LxxFeOEdZYWrl8EPm9y8Z2k/iy/k1LjobBGLkZKNTT?=
 =?us-ascii?Q?zkfm7/oorhe8FCELBIk6T46Jp6joM2yS0eNt00qSEGaXEyneLh1sOnefihsf?=
 =?us-ascii?Q?xN7szBAvzl47DH8HDM6L0Z/eqrxJ4MwufU+kq50pYZzekTeC18zbRuehWcNF?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc5edc9-ad16-4750-9d7b-08dad1ab70b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 01:45:49.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +axoW83DyqAogFXlCVSXEZwB+QLzLvtkhhxJx3iN0yUIeQT3xV3XtCscEDtDmxnBxcqR+XeEwcr2TTBzUjwln9aSyvYiaO6KNFeNLBfrTBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4412
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Nov 2022 15:01:50 +0100, Alexander Lobakin wrote:
<...>

> > +int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
> > +{
> > +	struct nfp_nsp_command_buf_arg media = {
> > +		{
> > +			.code		= SPCODE_READ_MEDIA,
> > +			.option		= size,
> > +		},
> 
> One minor here: the initializers below are designated, but the one
> above is anonymous, there should be
> 
> 		.arg = {
> 			.code		= ...
> 			.option		= ...
> 		},
> 
> ideally.

Make sense, but we'll leave it as it is to keep it consistent with the
other similar functions in this file for now if you don't feel strongly
about it. Thanks anyway to point it out.

> Up to you whether to send a new rev or leave it as it is, from me:
> 
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> (please pick it up manually if you send a new rev)
> 
> > +		.in_buf		= buf,
> > +		.in_size	= size,

