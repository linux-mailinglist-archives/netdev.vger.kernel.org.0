Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4CF6DF6CF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjDLNRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjDLNRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:17:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B37A243
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huZX8yhV6nLAWhHyezmJYX3q979dkqwzIHw798mfFBzCB9U6vfnJlGgUCdn1rg6LVF3QDSsqeHoAgO0HsaQ3b3f9PHFjqLOg52j+/q5krCDBG/ltly2O4hbPHehic2xhxw6spTOunvrl4+KeHCajonpLcSFhUrQge0UjEA8VP6bS5ZHX93ZLo9hb+w0Z9JSxGovZaUocmbTagGF0sO31NYve3lKPmLy+qIPfrR8gNGAZElvWxvZZ/WCGJVrdL7pthi2nUT3YD6px7HnFm3Hvh97pM9apY2NGaLn936P1x4sHJXTnLVc0hoY4ZH3+xKfrl5mpAyPpKSP92ZMrzMlv7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHWlFv9wI22YJGfwMv2e3gmeUP6cFjkGrZ2YvCPY8Yg=;
 b=MgufOFqpqwC6fT2HSIGLDWHdKGnUvtJDfML+WqTI19zVpveAi1PSu9Jr0Fi0Su9cXOrAVfoHYtedL/gBn/522Qoka/X3n6LvWdfTNNI8e4LJGR0YJe0incUd/NDCvIBrRM4VfSjyJMhpkbquG7JQsjD/HIoe31+Xksw1buIMypkHYJZZMEMEATyo+zNl1NVD2SQUrRC3zEW/AZc8ynoDQPiMAvtYctSwZalu4ZcflROPMN0S7MwFEv/5suE/PVBBb40bi+krRc9SdI13vu8epSA1RCPpG8rAJ3od2bD26VFC6IoiKZm6fqqSrgU65oTHzYTxR759KqEB00rrdhdeGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHWlFv9wI22YJGfwMv2e3gmeUP6cFjkGrZ2YvCPY8Yg=;
 b=q14yiVOi4d9im4+R1bexlnPwEUsAJvRMTp4yImGRW1x3F+dmcDXbqj+tY081aqqVHNe5PJz+hnwrURKnKkaYcl3BCSn6m/w0dWZybCSY8fYd58ch68VNQjdZ+Q2NfUSYuMbnBXxpiQ+DYOsjHcjQ9kgvafd7yemvfwWhbhvutzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8738.eurprd04.prod.outlook.com (2603:10a6:20b:42b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 13:16:41 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 13:16:41 +0000
Date:   Wed, 12 Apr 2023 16:16:36 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 1/5] net: ethtool: Refactor identical
 get_ts_info implementations.
Message-ID: <20230412131636.qh2mwyoaujrgagp5@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-2-kory.maincent@bootlin.com>
 <20230406173308.401924-2-kory.maincent@bootlin.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406173308.401924-2-kory.maincent@bootlin.com>
 <20230406173308.401924-2-kory.maincent@bootlin.com>
X-ClientProxiedBy: VI1PR0601CA0009.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8738:EE_
X-MS-Office365-Filtering-Correlation-Id: d980711e-b6f9-47c6-3682-08db3b582775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MnMekkuo6GKRkHMHl0vbCc77RuuIMz3NiAaRCFAmyRev47kL4oitKbBX1X9z6feX89TsWsf3BfJm4svndUCEfh19f/8VVQ6lI/0PYTTQO0xqFpjeSJ6Wy0TFsL1gPMdWhhgFvLex/tAt8f3aiKqfJRbiJxAKaegcMz9o8Pb4tH+gHXJsEOqXyYaI/xIHmpHB+Wz9MamsGpmY5qkog0PTz30gwvIukM7eKkbXsdl0tbFJIv77dtU5qSiRiUfCpnGE8MR1XS1Ooi8TAOafOMbtf3JbK+s2137eePrm0sfoyPtOtcIUj3XBjDnG7c/VGqFCKSJ2P6PI8K8xEPYn6yIzEx/kdqzW+f3UChUkJ8OkRPtem5vWvH6OIRDrPyLZJquwBqzbGe+GaXOqAEA6GVe5fQvm3GI+w8Z3B+QmfZkjhKHvi9DdSvDV+myq3jAuBW+venVS806a2hPScCBz/+LO9il8vLO/3tGztcOZ9z4BY2Y6Ooy6pGKXu3jatP/RMu9qmILqdQEnoUx8hUFmpG9SoPtHE2r7eLTjkjKclNEaxgBPKBUCD9iSW6eaaBJO5q0v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(5660300002)(44832011)(7416002)(33716001)(6486002)(8936002)(9686003)(83380400001)(6512007)(6506007)(6666004)(2906002)(26005)(66574015)(1076003)(186003)(38100700002)(86362001)(478600001)(41300700001)(6916009)(66946007)(66556008)(4326008)(8676002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?iHWeZBmpwUZJsiEZ2f2Kp78Fw1udvAgoPKRAa+owkGNg4k8nX8MLaVCh+y?=
 =?iso-8859-1?Q?n5ztzGKV0xCim6KLF0MpSTkBky1Goqg3VJGnI6SmWptsnDygLjesU3/UhK?=
 =?iso-8859-1?Q?bkcF/H5gffW9q/zDkOf+bo3F96jfwJDczIy2+mWjD7lC/gdXM+vMXF2Zi4?=
 =?iso-8859-1?Q?eVXO+Pp3xFPo7h/hlUhvfXVSS2KKMn19W4nzZszZgQ0WNUo5VyOZVD6mL9?=
 =?iso-8859-1?Q?1Z3gKdG8UiFx9I+CIMFPqrQAIAQB9uhpWzHUVX0Qf99bU3KmSVJFEB4ZPQ?=
 =?iso-8859-1?Q?GCJzBSNN07VMbcexmVDps8ksKtgKbIKgzZeYkJGYLspbdAbwdfv26os9D9?=
 =?iso-8859-1?Q?QONwoH3mkVa4+uzFdN+dH9qRc3GH3jH799+GXblII0Y6ukbsFj+ppR3gji?=
 =?iso-8859-1?Q?fdNIpA6RNna5GcWN6BbE0wbj0cdjaKdDJvnqksS+DkH2bAzSx9v3IGY7jE?=
 =?iso-8859-1?Q?ceeMpJuSFAabr3kGnDCUHhzq6c85WOpYii1NpMmr3UAMgrET9PEvBbwtg+?=
 =?iso-8859-1?Q?AeBGl1sFvcKHh/BqKeD5TQDwDhKmOdyQd1aGfmHaAtI/+dP8vCppH3jj+w?=
 =?iso-8859-1?Q?jrEHSfiRh5fUnLeNudN49NaGLfX+3KT2HCPHmBzebpap7liXdeC/GbH47M?=
 =?iso-8859-1?Q?oCQt7C7ULCd4bKm04k4PSJT4t0hrjpgPzxo+I3hlDWIaxrIlQhjgXaLPjg?=
 =?iso-8859-1?Q?0tjHr4HWCqmt8ePZ1AI9s0lRWR1NuQPY5uAspm8Ly28jJyQWcGkhTURwoo?=
 =?iso-8859-1?Q?iCbmRrOE5VOwJZ/JkGDtHvGA+IWS7CU6tTTj0U6+I7Kk2Qjusqfefl00UQ?=
 =?iso-8859-1?Q?9TxJgcZiHb6M2zJblqToypthfLKsuWS27PfPQpX6Z+RFRzQMyaFCowBJKz?=
 =?iso-8859-1?Q?+vKLITJU8Y3JD6CyPOUa0zLDdYiR/HuroqUps43XZrBvTBxTFmjEtBraGF?=
 =?iso-8859-1?Q?ktOCEjFEuz2YDoexusHXPmLMPWw4mlPGP6OnEqYLSIg8X/h907UEYrGGLG?=
 =?iso-8859-1?Q?Nc0ws0RU+cdjNOhN0kvQsLNf2XwZXYYvK5O4k+5B09rHIqbMXJF8xdJnzV?=
 =?iso-8859-1?Q?l2M7Fhj/tfxs0YK3zpib+j7Ku3Yzd2XFS9WoHmkLa22fyoxuAkfV7PTT6K?=
 =?iso-8859-1?Q?b9AZmBSVsORgcu3SFQbRSx7mY4fFDJe7sGdaBGzFDcvGAD2+DDfOr6zR9H?=
 =?iso-8859-1?Q?yhMAwl4ERJ/SN9Q/gvBfscwWYt37/QkILHEV/Rtt8Ho8gAc3Zgouql8uqQ?=
 =?iso-8859-1?Q?ZQYlD5xfIyxnJ+Ows4mgxodXE0g4aSQzn4FiokHsHcWEhQrkOrGygBK2n9?=
 =?iso-8859-1?Q?Q8eIIyJyW2Sh5h4qntTC6jlUuKsCvR6BUzC+PkUcf8e+OwwqpdcPmeQ4Kx?=
 =?iso-8859-1?Q?9AMVN8ny3kZx2d0kAUA2D3JNAZae2wIf+iA3mCQvg8O4tSHxO4lGdts50y?=
 =?iso-8859-1?Q?sdW0cp62OctURWXaDZKzINvQhD1W9coEJgbJZwinxMfH0g+TZlin0rRbwQ?=
 =?iso-8859-1?Q?bZcHUCaKew5YdejbtM6Z/KaQaxynjCGWM7Qlzh9tIi8/YtkT/WMepLNwjk?=
 =?iso-8859-1?Q?cnfH98+pFmHyHjYSit3s0cuF8xT8dPLxY8ll2qgo2e56npzSKV9iU4r/IK?=
 =?iso-8859-1?Q?XwMRK6hAsjCuXvrrbHDoOpzzeR3X1spYfqFHL57iMscikTQqSsLGQ6Kg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d980711e-b6f9-47c6-3682-08db3b582775
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:16:40.9884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhopPpMG3EIkgmSk88ViSSdu5vpSilGge6UNcyyzxhpvXBOrrXxtfQcEj/qtvOirphO1BykAscMQY9M1xGkEcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8738
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:33:04PM +0200, Köry Maincent wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> 
> The vlan, macvlan and the bonding drivers call their "real" device driver
> in order to report the time stamping capabilities.  Provide a core
> ethtool helper function to avoid copy/paste in the stack.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> ---
>  static netdev_features_t macvlan_fix_features(struct net_device *dev,
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 798d35890118..a21302032dfa 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -1042,6 +1042,14 @@ static inline int ethtool_mm_frag_size_min_to_add(u32 val_min, u32 *val_add,
>  	return -EINVAL;
>  }
>  
> +/**
> + * ethtool_get_ts_info_by_layer - Obtains time stamping capabilities from the MAC or PHY layer.
> + * @dev: pointer to net_device structure
> + * @info: buffer to hold the result
> + * Returns zero on sauces, non-zero otherwise.

Not sure if I'm missing some joke with the sauces here.

> + */
> +int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_ts_info *info);
> +
>  /**
>   * ethtool_sprintf - Write formatted string to ethtool string data
>   * @data: Pointer to start of string to update
