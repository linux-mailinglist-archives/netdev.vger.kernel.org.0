Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F206B9B52
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCNQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCNQ0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:26:02 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2100.outbound.protection.outlook.com [40.107.96.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A240813D75;
        Tue, 14 Mar 2023 09:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nF4svo5ZkO+utmcnSMg24NPe03/INkPI0354jzusIpnxHIyccIpKh5dMKItBJp+2HdyRKV9Ja/SwVowFa6PYln1HK6qt6WkyTFQj0O2xVYADu6Dc7+SHfd056lcUndHzWAisFLnzsqf+HmUWfuafwuUj4wFj0SHbJzwi8KDlRcPC9jHsb7vXGrzPUcs3aeQGNEwCLF6IrruFw/Grazy4u/onpqjA5BaKJJDwYK+hNURi5ohfIlo4vJ/x2NoQchk9CVOj5hnqhbNjO02o0F7M4hczQjZy2qn38Cbg/Uy/KEk+4rqRQ+eQCQGuXDTOp9ylFg1YndaQr4V/VDalBZhSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zhan3RPVlS6IKSuBSxtImYzMNMek61t4rCYk5QUDnsY=;
 b=NVxfESRww1lb7HeEtFnshxTkOWszTI4/Q9+oEPZZRQzChVtoobJoY1uw76yAsmG1uquTVsne1wKdYj6uxSj9tutMh55ESMFd1hEHTx08u8e7dzGzZAaBjfTUsS9XUlecV2dWMKTVIm87M9q+dnGpRGdp8vezmBDBCrRRZmFpH3V1ukzHbikDYQpcKPQcOiVMuQ512jSwH2ml1VkuWC+nnnB4lLhUYyUGnqbo2E+sqoifaxdeHxvu6TexIjKW2vZLeacXbiuHr5elrufrSzhk5lBIqSmLusxQ7IgSLcbTmHLYVXR3zItSSUnrEqbWMa/2s6TjJ8Byb3sawfg+q/HU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhan3RPVlS6IKSuBSxtImYzMNMek61t4rCYk5QUDnsY=;
 b=JO6IiHO9Bl6nb5iDAyCGx+50PHzlKPgmgk7qy7bN4WLIXoNjYvcEt5UOTqH05WYmOtU8k+wQZ6i45r+ZtFVOMrJgb1/NY6ScFS31YuIlHMDRloZAeGDGndM8ZjYS0Ios+D4E/Dv5WU75DztkUXRwaVRSu6RCAZsJsL/Pb6kLT0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4559.namprd13.prod.outlook.com (2603:10b6:5:20b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 16:25:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:25:48 +0000
Date:   Tue, 14 Mar 2023 17:25:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: mscc: fix deadlock in
 phy_ethtool_{get,set}_wol()
Message-ID: <ZBCgBoLk1G+NZqz/@corigine.com>
References: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR04CA0109.eurprd04.prod.outlook.com
 (2603:10a6:208:55::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 103fd7f8-81ea-44df-f860-08db24a8c4da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jSlXZFUX9/E4pw93AAkCF/6GZZYxFYXdr22nfMJeufxcf0JwlJbXuNYSWPtOIm8yuw/C5tH3Pmz425cBPL3WlMoxLkE8oUJdYzxtsUJCpQCmDQQTd1etdsdtC32N4eFqJGs7Djz8G543LuVpJGQ6osivm4iEZUf3cUAXRRFZgff5lGOn8Uo9+PIKLtRZrCW1fQmzgzZ5XoPs6rTqezGOGK/rydNwK1sv/1mYN/ji5WBVb2Leynikta82KejSN7cW1ZiocmI5Ugxx3/hPc7tkZSFP9uxNNRNECz8ohOVUoCk5WMYmMcpWet3Cp1ZbyaS5gG+7r4X0EaQBARTnrM1ZD680/XvJ9dcDCxIQGBaqAzshr4SkEkrnC0uQylA3HjIt99dmVDO6BOVh4q/jwsUbxHDmy4N8l8pd9pKOWKBpUh+Rmd3xxIfuVCcnrcDNsttwbR874uUybPycxyXRA5FXUKXopn4cBKHyiYQ56zb/VmVrPOVRDPZ8OazgSGIxDVUWXSfpeuC/iszal2mGk12QAtqv3YfFoYMaLDf9tN4sAcA2ybVUoh9WQ2725Pw7HSR+FmJEtL5jH5EvDs71k9qLkcRzf8Kq7XkkoP2eOs2QdKiuMfJpttqXeqduWGFn/d5nZV3d8CR0GX6UCbXCKcWW4WhTVN4Kfz0Q8QFnXK93PLlxU/Ojlp06GXtNHtcf2SSh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(376002)(39840400004)(451199018)(8936002)(66946007)(66476007)(8676002)(66556008)(4326008)(6916009)(41300700001)(38100700002)(36756003)(86362001)(7416002)(44832011)(5660300002)(2906002)(2616005)(6512007)(186003)(6506007)(6666004)(6486002)(54906003)(316002)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OWMranPnME4R8XhZS7AuqbT0jRIEJHW50wGRRfZzcqaEyDqSaAfZzm9fc501?=
 =?us-ascii?Q?Z/wkNEvSlS3dOxTHbbfQ84g8ziaGLfZflLfMQgfM3XKpwQY6sZSVj0gErS0x?=
 =?us-ascii?Q?nZShKgtLsWsSAIon5XaBuV1Y513AvCDM+kP17h4HQazZrKv9q7YPwELMIc1q?=
 =?us-ascii?Q?LLfqilSWZL2yjomFpGOpjMzwAqO92b5OscF0gu9UV7Sm49E+ka21qoOspJCR?=
 =?us-ascii?Q?RL10DV6xOtQIpYMVGQ8wnM7P/URVmBGdjiBRUY+k1SiHxDnX+ca0khk19g/z?=
 =?us-ascii?Q?bv1gWcgRFdgGP1CPWqepD3O/SV03CwAuE8co/ZRW/FLvFWrH0psTi+w67ZtX?=
 =?us-ascii?Q?2aKI0w4jHzI3x9NDSzOcBr2d3CPByDbnnpHpzyXRwklY+9g1hRxglxjF93pV?=
 =?us-ascii?Q?eHEx6gWJi8B5QLbTaI5ZombXE7CzyFRu6eD5WP1dvzsbQA+ONGEHqpkZCuLV?=
 =?us-ascii?Q?1bDrElDlk2kZGFm/sBIEvPoMTgyCpoQCN68uolcBmEhTcIPtTVTHSaI4EpPd?=
 =?us-ascii?Q?y9rgCzWlko2HgkB7rCNIcUV8clbg0lHLHKBdHP+rxMIy+0+ZxwXzb4HlOgs0?=
 =?us-ascii?Q?0kgpt4cV21H+jJtLZO6hU/0sm/X+/5+NN39e929aLe8wXxOBWioWqe4LTaX8?=
 =?us-ascii?Q?1XNKd6g1lxoKv2G5hlqn7XVrQddPGxPCni6NFfer4Pyo/S/B+FyE1goIjIot?=
 =?us-ascii?Q?Ivw/M94nrGKa76RjEpworKJLG67c4A3sTjgG3pVHLqA9b608fucyH516nA33?=
 =?us-ascii?Q?VuC/P9v50SfLzM6+4tDt66fgAv86batyJZle1vNPIi157293D8sY6Ni//AtD?=
 =?us-ascii?Q?Xd2N7/tzXUP0s3QCR0WLY/oY1mmmIUQck/HgENIW5hqfZEgqZoHGYpYrcixI?=
 =?us-ascii?Q?dZWxN0o0UrZa4TRtyW6+E2Z+WWR/dmqE0XzHJuHDA7N7Cbwm4FW7gGXB+9WV?=
 =?us-ascii?Q?v8SijByVe+YryxnjEsvxxtvrT5teyV55NQDipl73IQm+wZEE+Hh2pGH6fA2X?=
 =?us-ascii?Q?UAs3lyKsTK+1g1eP8b4L51tvnXAvuRxi/KBhJGhk/ODvAok24ow7dsH4HV9B?=
 =?us-ascii?Q?WqVk5xTsBKIIqLiTV9rmY856YkWCCi0bZVA3wgS4MfmAKra/0Q5edqKuoa3p?=
 =?us-ascii?Q?jFw6hc0Z2m9TVjXxIWjQABSI9T37XLyQrhx0OM/udnvL60dJDr+rWKtRhkMl?=
 =?us-ascii?Q?XMOCUCYuNahgvVi+XT6vPF52YBxr5DisBrVj5UoK1JIUMtje+zOSHCNsDi51?=
 =?us-ascii?Q?caPY+vsrAwEpQqB4Lpyjfu2K66L+uXtoasMM6lYJkMGqtm9j7hJ9xULTIYsD?=
 =?us-ascii?Q?qSMAFCdrtnw541JSk2vWjPObhKYmMk3Qi7Y0VxsojgVQhW4+/WpIxP5QINFl?=
 =?us-ascii?Q?8q3QSEs2bI0FXOvad2wOG6w7Ekv8OBcNVgGkLg7rWvDEYxNBDTs7XCq/KpZ4?=
 =?us-ascii?Q?wuSP8mfTbnxjGGtrLXdF24wLv2O7Hu4EWcL7WeH8mNPUPp1yaLQd2NbOrbHu?=
 =?us-ascii?Q?Jj7iyAd4qJn2kTSq9m5OHuNJxEw+U5CHgkigTidZ4iba8BWeRIr83V2Ar7pf?=
 =?us-ascii?Q?mFIb91ca0y/TiuIYr9Z32O6FED0qNlY/If1yigK1qO0LnW5ub+IqqlHFZCR4?=
 =?us-ascii?Q?1c1xnTy3XIsuks3XE9y4Wnml9jhO5gVzdXqo6NvUpQclJpPYUghryUBZ0T9T?=
 =?us-ascii?Q?xS1yuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103fd7f8-81ea-44df-f860-08db24a8c4da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:25:48.0409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1u+PZw/TnKiNz66//tcWRgsT6lYeLxAtyRx+NsURf3hyOYmzS5+PbTCgP6lxv3avLL7B1tiR8frwN8U68YzYHM8Q7K0Et1xiwqvMHZXTmqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4559
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:30:25PM +0200, Vladimir Oltean wrote:
> Since the blamed commit, phy_ethtool_get_wol() and phy_ethtool_set_wol()
> acquire phydev->lock, but the mscc phy driver implementations,
> vsc85xx_wol_get() and vsc85xx_wol_set(), acquire the same lock as well,
> resulting in a deadlock.
> 
> $ ip link set swp3 down
> ============================================
> WARNING: possible recursive locking detected
> mscc_felix 0000:00:00.5 swp3: Link is Down
> --------------------------------------------
> ip/375 is trying to acquire lock:
> ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: vsc85xx_wol_get+0x2c/0xf4
> 
> but task is already holding lock:
> ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: phy_ethtool_get_wol+0x3c/0x6c
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&dev->lock);
>   lock(&dev->lock);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 2 locks held by ip/375:
>  #0: ffffd43b2a955788 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x144/0x58c
>  #1: ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: phy_ethtool_get_wol+0x3c/0x6c
> 
> Call trace:
>  __mutex_lock+0x98/0x454
>  mutex_lock_nested+0x2c/0x38
>  vsc85xx_wol_get+0x2c/0xf4
>  phy_ethtool_get_wol+0x50/0x6c
>  phy_suspend+0x84/0xcc
>  phy_state_machine+0x1b8/0x27c
>  phy_stop+0x70/0x154
>  phylink_stop+0x34/0xc0
>  dsa_port_disable_rt+0x2c/0xa4
>  dsa_slave_close+0x38/0xec
>  __dev_close_many+0xc8/0x16c
>  __dev_change_flags+0xdc/0x218
>  dev_change_flags+0x24/0x6c
>  do_setlink+0x234/0xea4
>  __rtnl_newlink+0x46c/0x878
>  rtnl_newlink+0x50/0x7c
>  rtnetlink_rcv_msg+0x16c/0x58c
> 
> Removing the mutex_lock(&phydev->lock) calls from the driver restores
> the functionality.
> 
> Fixes: 2f987d486610 ("net: phy: Add locks to ethtool functions")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

