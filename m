Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED86867F8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBAOIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjBAOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:08:06 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2122.outbound.protection.outlook.com [40.107.96.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AE415C8F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:08:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aas3+q5MDBr0irJ7yMRBRg4gTfrQ6TmxAbCXDflKrx2D4fKwujVBJ/x07wZvgvmLy6hmU2daFeBHl7xuYb73PEHSypaZl6QdWNTYOfLZaQxA8wpmFZ6phiQYdF8g+ADPGJfRj8qbI7Cnx3yOpzE9RF64ejr4SNGjdYkwyPKVJsvgbGpI0F9lI+fl7fdOgDiwn3T6LtnTXDVBnjZul2M1bWvh0IHT3Aeds/1vGP+X0GMOLmQzXm35Mh8CUZF+4iRSlLMz5dvQHtuFAklVWuacHGjAhQuBZdmfop20Si8UGX6rmdbLQDSNXkVenuKPAGwmE+9SwZOZ1Y1CsImYXY+bhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEjT2Y4ylYT2UBpvYpyPteF2bsYo6Qp+KZhsnQtImkU=;
 b=m2EQ0yVz9oY57nFTkakHiUQ11kw84urmASICXhFZ2Bisj4w85JDNLelUuCn8+nGm4JxJ8OxSHPM6EEKYt095WJyTwVrDUP9nreu/czDgmrFwZEXxgJu5gNNqstVO8tamMyZd5bahmpoimUf34cDDaIQYXwLqQ1GGtgkjRr/+62uf69X37Oj+IQAhIXwnc8rj9Ps93bS48It6KofTZK7Klui2lSDlHjFxoDNLj5omGO53TXWX/8kD4AUsGgx7+nUQUE/X0B5Foa02V2tl0d2mqtaVuN8gLxCSvf0pXaT10EKFLjV7ewTQ6VENJdXjChgjXdrPER0HSc6JuIBw2pG8dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEjT2Y4ylYT2UBpvYpyPteF2bsYo6Qp+KZhsnQtImkU=;
 b=cchzf9BnXk7Iqf+wHXdA/Dc9b0jZtKa24Ht+FxIBkQFpi082DZqxQSENdkOKxvgNuM3DCobIjUZxMJoH/0FomxpZpZH0dHymRvtYtzU1k9GIThLMb1xGD+hTH8UaLDiq/Ip9I9sC80rvv6NJDlKsg3rCG9ME8WLgfmC0hjfHlGw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5694.namprd13.prod.outlook.com (2603:10b6:806:1ed::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:08:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:08:04 +0000
Date:   Wed, 1 Feb 2023 15:07:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 07/15] net/sched: move struct
 tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Message-ID: <Y9pyPKHPLuZ7Ba37@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-8-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P250CA0011.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5694:EE_
X-MS-Office365-Filtering-Correlation-Id: 716ecf5d-0f99-4d84-52bb-08db045dbbed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qtiERwGTqIsxgNfxxEY9B7i3lxU+8QVUNHfKnhwCegz3uXX4pYTZGY+gF6yzFwEpiEOgSPKt0XV3aKyZa+RSRJMHB8N+AG6vfxBJl383Yc9emczUP1cVHliacNYCR+AJz+iBITKQWFylY/fmakP+2VWeKLAfggHFCYYuBm8djw8HqtIka441jFnydyqYAdpYCrBiFi/4WwJ+Lx3JXIC7hKB6X//S5evowbbS8kf7GwEwABWv51+kEB7FmsrbAzxz3wzoLc9k7SYGONNEXSrECJIi/IwDd8pAW3e5rvaDRyEdfb/Tc2kW+/yzbAMab20BzYiLwiczYtbsq8YrRMkD83AiBVu2m0vQPA6DP/wA3ZJIpzsHhf3yVl9MSOc6YDTM1x60jL6wTHkx6BiswV+ukbQHG+uuPyVQo3B0SesKeOH4+An2zvdO4sNeXYhjF/eQf4uq5/Xm7X2LKErOkL9RJ1tjMYGbdil3nCdHkyQCRfkAtQR45FOr+HuCuI6RTh+qw7Yon5Hbvsbs63VUJbf/MNAzrjL9MNG19MVsOTZ4jk1fRXj+vbUQKpSEI2PfaMFCk6JBDXHy7shwgBU+zDd+f4mDEOG4seWfeAXy/UHIrul6KlGEvZl4E1S6/bH74d/252ToHsIBRKLZTSjxuUj0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199018)(6916009)(66476007)(8676002)(66556008)(66946007)(83380400001)(2616005)(316002)(54906003)(6506007)(6666004)(186003)(6512007)(6486002)(478600001)(36756003)(38100700002)(86362001)(4744005)(7416002)(2906002)(44832011)(4326008)(5660300002)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96i96S0beFGaZKlrPx4gvjaVIUP/KAJExkbkH+hklfD/FUxx1TAoz98UEEp9?=
 =?us-ascii?Q?8kHzX6RO/ANzqYZUCPxbVfjpdR1AyH8RxNFWLF0FLRyXUPWNzpvMd+/9nSUn?=
 =?us-ascii?Q?zaozYItdcGzre5HAYTfFC4xtZcraFNE71uTcNF8UgcrQdElQA6kusoyFk9/K?=
 =?us-ascii?Q?hRMH3I+pXksXqCmbi48MyUHd3nddu2aUNXzySn8N1a60D0coeOTvKZR45bmq?=
 =?us-ascii?Q?2mUWQ/+jpZblLIVMaLPgXjheKu/SuTmCl8dFSR7o4vlmDOffnyO8lL28r7On?=
 =?us-ascii?Q?VWEy6E8uqMiR3DENEgcaAeb1JDwKmF/7NOfQWnpQxwSFZs3cDn8/3hQnLfp4?=
 =?us-ascii?Q?brzBQKie+ezdpQFzhJD/WfIywX1j9+oNX8rMeJ0sLBtiIgP9jPGgsRaeGsjp?=
 =?us-ascii?Q?WaP5/wykd95wJj40+NpoG4T8gJWX2MqSWKx6uP5jIL7XOls4kUFH8W+0lRDR?=
 =?us-ascii?Q?T9JKL+8ibOQTEoIpzHdDBPrSBRuD790t6BD3nSFEiQrQdPyE1axJqn1y1NPc?=
 =?us-ascii?Q?Btfzp5XZTs3Hbo2u21RGlNRaU1UlWCklTUfEAgLxm6lN4+DZuT0g6BKZsqJQ?=
 =?us-ascii?Q?Jj+RrIV3ny6p20ZXdZOeLP7ngfjssFI8g8l3Mq9tmdTfOGD8gmUog280DZf3?=
 =?us-ascii?Q?SNor+/RGU9Sh2jdWLbgRw+OJ8/0txnPUxMFz9TOzS98FjgNIKNB61XBCy64t?=
 =?us-ascii?Q?be9zliQ7MjiJ3sZTITQEBGZS3eEFz+zbXMMGz2GKHdov8Bg6uk3fvoQisZKU?=
 =?us-ascii?Q?qe2OTyhbWh37qqn7jr6X2VFK3YXaq/k+QenlATVL+jH6OCrT8JZZrX+tkQ+U?=
 =?us-ascii?Q?6Dh5Sw0ZHC6yn4AHSteG+8elfKhcZudaD4nRuqC+QmK5Hn5tRYWHy+gZ3Zpm?=
 =?us-ascii?Q?bC2XX0fG7gYFrdezf64jynUOgGzdp2+bLXdxuKtjlCth+odzgzfCKCKxQqxN?=
 =?us-ascii?Q?FM/n4bR5N4MvDOafwkPvJ8JNIMkAlqneXgrXhq72DmQrx1lgruZDvVUwg04D?=
 =?us-ascii?Q?9vVVupd3TD/R6/iUXF1rw9SkX8394x5oelxU0OI+t9ma8T+4aCgcodaDpgfT?=
 =?us-ascii?Q?rnB/B4iQGU/Nu4BVl3Sla77PO1gFVFLVE868lBLQQKNTeK0+8yk+6w6iS2ol?=
 =?us-ascii?Q?HdzEc60WM8xVv8yLSilgzjEKY2qkrRR7HV7D8edmtK2T1wXeN9oy+hMp62de?=
 =?us-ascii?Q?HgAnDjbT2geqW8Xl9lO0MOLF+I040KFlsW8C4uQb8Bv5nmsD2dtRV5hjMrAp?=
 =?us-ascii?Q?mgE4wOsXIijzXcAx00V0E0mWOUqmSgSTjskDzDCGrEcaFmiH9CKFYIr1Qisa?=
 =?us-ascii?Q?/pz4rbsJKcQ9a6lz8HY4hLTZcioxF3KR7MLsG9DNtR1p2DMMZj1xoh0D0fwB?=
 =?us-ascii?Q?ZPtVuYGhrseDn7VYOWxg9dS5Bcn6GSdlujWVDDnu5g7SSAHWnWeoZ6XdPox0?=
 =?us-ascii?Q?ieBKLriWDy35GkCpdM6nfGsnhmlUBWpiGNKZWiJvD721JnJLlL4C9kbNXhAd?=
 =?us-ascii?Q?SFvdyoMZkOP9/UB1Y/Zi/rZBreDMMovqvbnfphddt0KyCnBqJQDVOWKo0CT0?=
 =?us-ascii?Q?NGXf/adBzd3tBahdt93k7MzrbrdZ7CyRyM69ABBapC7AI8wOuYrFGUpENYJ2?=
 =?us-ascii?Q?9LlADcIf9ZUP7w76ya1T516Q/nKG4KT27MqSkbhey/1OJCqFFxHJfesyn6yS?=
 =?us-ascii?Q?E9oTuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716ecf5d-0f99-4d84-52bb-08db045dbbed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:08:03.9106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1f9JPUSCB1INgRHlfSJvZmgIU+ARH8Ou247c2xMvwi+5KmBix0pHddqXA2sEdQzNeuygbu5BAj33ZAHAZIKk8w8A65r0sFKPgOfum6VjS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5694
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:37PM +0200, Vladimir Oltean wrote:
> Since mqprio is a scheduler and not a classifier, move its offload
> structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.
> 
> Also update some header inclusions in drivers that access this
> structure, to the best of my abilities.

Signed-off-by: Simon Horman <simon.horman@corigine.com>

