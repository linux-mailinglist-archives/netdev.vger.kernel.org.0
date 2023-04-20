Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A816E99A4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbjDTQf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbjDTQfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:35:55 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF33A96;
        Thu, 20 Apr 2023 09:35:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDxcdAO3qErJR2OSSuK+JYMCUeZRs/QzZmTG8fiLmHthraTvHQBjOf45ry1WyAJRP5o5ipslpdRGf/OifF6XtLDEJa4s9K6c7FuK9SSHYr+5sg5k0iZxqrBEOETUxpur00eC7jcD4lV0bwcPPnmt7sApQkaw/soMvBYX19E1Qx4FRU0guu2SYspX0j7huPJlx6rDtf42pSeT7kvhSIL92RBczEt32aJ0NUE1pJQW6YFmeGGN068koMBWd5/8CT19N4pvotblQJ7jmwPowFtmSfny4E/g7mX9fXd6aErlvXubSJWYJkNMIM1eNQ7jedQ/qMAEJnsQeJibgdeUI9eGEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pxq1bS5G7wtLEfYRkor+7MNDvVUvHqzlAFOZZ5bToeA=;
 b=AcGIXPj1g5Fn9Wh5Z/t26hs9CCLIK/mtIVJh84PivOr8plxa9dbVRUb/CnU26mBYViltqBW34a3n6F+1l4EJKpaZdxv1QstcXuCYJAVCoT04RWLNDniW14V+0wOiH8XS0J8o9SfiOhHPX8u6qW5HLu5pQ24sTb5ziTEcitgXOmKAWuxYbkMKMcMe3keCn1c/lxXmQRaxhgiIZ5POI3V+ulygWZ4Cft3cUiqT43dG7P8uMkIxdjAHhO2o/MmA7kqB1O4I6ej+t8+ddraHidu57kToIGHlmrGyEtFarrnygRIfnMbbp6FC2I3ZBepMAcMcgcl3tmUC9GkhKZnOz/S2Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxq1bS5G7wtLEfYRkor+7MNDvVUvHqzlAFOZZ5bToeA=;
 b=AJyChnm0PfhdGcHiiji5c6WYDYaqfInCIksven3PR75t7f6m3eeupcuZpIkT06XjqFPCNsN2DpeGuDZes9LBm33mUiRor6VZ4Ai4KJrN+517A6LKMavrZ8raHpYnHXXCAEhR2fjix4CCVHF2lF9veplZ3qp+AKp8NkDWcDmZeaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8695.eurprd04.prod.outlook.com (2603:10a6:10:2de::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 16:34:58 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 16:34:58 +0000
Date:   Thu, 20 Apr 2023 19:34:53 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: enetc: only commit preemptible TCs
 to hardware when MM TX is active
Message-ID: <20230420163453.4moc7ie327g5rgfn@skbuf>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-4-vladimir.oltean@nxp.com>
 <ZEFPbNCNDWy0c8eK@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEFPbNCNDWy0c8eK@corigine.com>
X-ClientProxiedBy: AS4PR09CA0010.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8695:EE_
X-MS-Office365-Filtering-Correlation-Id: 752114ba-04f7-4c50-495c-08db41bd2e55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTmwaMOpJUoFCjonQ4x+V1r1y/8W2WExkAxSH299Kt9gdLy2IUfS8kmNIndwkrzb0VSN22X3rXgpisVL/dPTJkZ0FKf+83/Wqy5lDxYtN6fJlBS2GeVKOVEKFsXIJemjVguIdtpGZ61OlR7d0owrQWTxKZ16bffbK2RSpfPz7wpCiSfV74FN3iGd8C2mg1HpVIgWcyd2HoUOzYPSMB+5yb1+UBLg/6xUeQW92UeALyIiWsuUJPG2zNuu1teXgwDu7ME3nNL9aUaHrFKzka6Ud/YgnSwhjl9ygHAM+He8g/mFazwyRxdDECM9CMY65o86bnfVquhkhdEHBPBJ5aeY2Kip9u4lzPfXbgyoZ78vt6h6Ij1XW50A9ZTk+hsfCvoRac1Jp1IEYwA60Mzz+CRMIfv7iQ6Whc6ikS9W0sI5o+oIGqHHnW27RwvXCn3NY0PP5HP9cwFvXP+dn+fLhv8HWSCijlHwSr/F3+f1LKTh5YGF0dJQb+igdj9HcWBgP7orT1uU/HAFFTjiu08yRBaSsEHsjGhdudaRf0pX/W7pPvJ1623ZRtZU11NUSnVPruGH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199021)(2906002)(41300700001)(5660300002)(7416002)(8676002)(6916009)(66946007)(66556008)(66476007)(4326008)(6486002)(316002)(8936002)(44832011)(54906003)(478600001)(6512007)(6666004)(26005)(1076003)(6506007)(9686003)(83380400001)(33716001)(38100700002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zHKP/lCj9TvPWUqECB4MeBU3vZy4mZNRBbb3xA6dUUk4ekwWr7vGHuXu59lk?=
 =?us-ascii?Q?HFBSO6ZEzRqGwfxUqQFaJBxcU0K/XqgGhI2iChioagapHPI+G1u70dMGF5xp?=
 =?us-ascii?Q?frxjS1ArcGCdP6/5PIrt3+ecJXiDD8hFXV8yR5KxDIXM3VQvAKBuh3skhFAI?=
 =?us-ascii?Q?VmoQNSzDVMBs6sGjZK7mz51Dqrb0iBdrTzeJyn+gnrfQmT1Ffe3WMwVT3ENi?=
 =?us-ascii?Q?JuoedACW9NyPj+pys5nVfK75LVS3o5nQgg314H7sh4upaO/lFIudXF5RrxIN?=
 =?us-ascii?Q?IWgkCfZFIC9FhW4CoWDLp6PLhLQKmyWE1GXrrJodzzYHcX4XFubsTO9R88q5?=
 =?us-ascii?Q?a1dLl2lqWD9Jw20jutvAiJTX5T03thKTcKYfIBzlOk/iuhT/oQTW02i9oOv/?=
 =?us-ascii?Q?r1oQL7/qFiuuA33vl0HSWodukS5MhabrzTNgxlEkRejPUqYERkWivSxbOZgK?=
 =?us-ascii?Q?0GOGfZrUpknUmwgj/7qqbmjTRVeU0cKrDgmJ148t/DNCNPA6QlD+NGcZZKjs?=
 =?us-ascii?Q?8ewzRs5FD+Sbb4Fcs9VhLBJJp/ujkOfS03KcK1bx0k+9xiA/x+vnFIu/uTFv?=
 =?us-ascii?Q?C1sRz2kNpAriL7cdmEPeO0NNobbkgOGj+1gDGKMo0QIABcPUTli5UDfD3ivF?=
 =?us-ascii?Q?OG7z40O+NFZKtgxPZxwmmIgm2v7DsaGB+XdjnFwNudNPbnoVs8pv/WxfAA6n?=
 =?us-ascii?Q?IyApagv+AowMa7DKAubHx0gIRhUOzVTG25KFFjCbcrEsjzWf3DeTyd1N6Ye+?=
 =?us-ascii?Q?Eojzav+xOmmSehrUAUd2dj2KonWJiw+3eU7zhZsAuSu/2LHuNq4dYXEmZdTM?=
 =?us-ascii?Q?/MXfM1u8fzh/qurn38hlZjUtfGn4rSrZda6/y3pqulx5p0wOHrfomxY4KaiV?=
 =?us-ascii?Q?axDCx91biwILjS7e6qa9Ph2TExrC8O7csa0BA3UKJ6dShf993ANqyi3s9u8+?=
 =?us-ascii?Q?mx+8i1jivovdVolSm/OkzZiB5JUequ/aqcOtdVKvQX6tMXIByHUPKYPia6bE?=
 =?us-ascii?Q?L8TCQqJmO+uMrUknDxcLEOZE+FYLkGabJJ2qLYNjZrVWwp9WRccFLL8YUix8?=
 =?us-ascii?Q?O6B/QRqEPDz5FwmR1gM9QSS/aMtM3fN3fBc65u8kimI1TGY7rVYhbUw309tM?=
 =?us-ascii?Q?S+iRDbfDnMKla1EVBEwrc9L2IIFQ6BJLUNp95VJk+moT6BprlCDgcXGLwFW7?=
 =?us-ascii?Q?3eAid2jjbFcAlwewVJnnZJMngWS72rfgMdTipEiS9I2eO/W1SGbJvwWQsMMq?=
 =?us-ascii?Q?bR506peY0/J9pZqmDWd8oNJ805M9PM78NcJGzQ1iXVuRxEUdK3WCipYynOZ8?=
 =?us-ascii?Q?aG+JYF5urNz+rKHthMnyWbhZ+ifcM88lmxUDqw9CRBdGJrF306DNf1Yi49ER?=
 =?us-ascii?Q?JZJGNFP4/ISlIMuJmd3GTvcOYI9CBGRpmSpLoKVYrdL0CyjIhGP1+ivlz9HG?=
 =?us-ascii?Q?3f4RMaYX8K45DmfSSwLkxZuwocQSR8SsarF7WwwTkPrrk7YAeWOwDtZNqdSk?=
 =?us-ascii?Q?eb+BGx/z4SBwyAm8LyAivxIgHQEqhy1Q1U9Jg1lWTf1DI5hJTUH2IUU/XTZR?=
 =?us-ascii?Q?QQMj2WED9H8rtSRnnrJjOLF+ClRZJsaK2S2RFQmlGGoZRRqmsiLz5OQ6mIhZ?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752114ba-04f7-4c50-495c-08db41bd2e55
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 16:34:58.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvoYZr0CEZIOvfP99zhyo8t7Pc1zLkgz4G9X6tkCXGJ+FSw5c2a4ie9eCYttcbA+cW2oOMAfDSHJqEnxXunnmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8695
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:42:52PM +0200, Simon Horman wrote:
> > +	/* This will time out after the standard value of 3 verification
> > +	 * attempts. To not sleep forever, it relies on a non-zero verify_time,
> > +	 * guarantee which is provided by the ethtool nlattr policy.
> > +	 */
> > +	return read_poll_timeout(enetc_port_rd, val,
> > +				 ENETC_MMCSR_GET_VSTS(val) == 3,
> 
> nit: 3 is doing a lot of work here.
>      As a follow-up, perhaps it could become part of an enum?

IMHO it's easy to abuse enums, when numbers could do just fine. I think
that in context (seeing the entire enetc_ethtool.c), this is not as bad
as just this patch makes it to be, because the other occurrence of
ENETC_MMCSR_GET_VSTS() is:

	switch (ENETC_MMCSR_GET_VSTS(val)) {
	case 0:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
		break;
	case 2:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
		break;
	case 3:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
		break;
	case 4:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
		break;
	case 5:
	default:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
		break;
	}

so it's immediately clear what the 3 represents (in vim I just press '*'
to see the other occurrences of ENETC_MMCSR_GET_VSTS).

I considered it, but I don't feel an urgent necessity to add an enum here.
Doing that would essentially transform the code into:

	return read_poll_timeout(enetc_port_rd, val,
				 ENETC_MMCSR_GET_VSTS(val) == ENETC_MM_VSTS_SUCCEEDED,

	switch (ENETC_MMCSR_GET_VSTS(val)) {
	case ENETC_MMCSR_VSTS_DISABLED:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
		break;
	case ENETC_MMCSR_VSTS_VERIFYING:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
		break;
	case ENETC_MMCSR_VSTS_SUCCEEDED:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
		break;
	case ENETC_MMCSR_VSTS_FAILED:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
		break;
	case ENETC_MMCSR_VSTS_UNKNOWN:
	default:
		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
		break;
	}

which to my eye is more bloated.
