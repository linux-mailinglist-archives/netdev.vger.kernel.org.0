Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3E6B0EDC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCHQiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCHQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:38:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E76BA26F;
        Wed,  8 Mar 2023 08:38:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvY65Ulaptizy/VwuIg7uGFxKqZPgg6Go8V5NON3dLXbs+p6FuFG2bTdCp/A5QnFRCoLo919HNC2NCzfykhd7Lk4zx6XZPZGSu19I7G6FDHMgyWAbjFXafwsyLCfJHW0BwFCKxyMwBLGn2si8laGP4ao3Gbc0pL7dNBjVz2ak2uYkFK9XrzxdVR75Y29VEeTmXCo/HLKgin+VWm0qBxcpfi87+/DgbmbBKNy0YblUFSbuaCjVPRflMQQAlC+oQ2MLC1tcSny2JNs/k/y3FhC46JD3qL3aWisSE80jdB+XHanzKpKmYoPIHd6WSBact5YHzZrEf6xX3S5QiGPCeR+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AkMV5RPAOUXMCxwuwJgCfVPQ2hLm0gH8nWU7zplX+Zk=;
 b=MfBUnujwk9SDn+nBlkAtsiwlWrjzCPbJ/rw9x3k/7v/nOLMrOFGML7Pi3n2yDJByj/qzNd0o15uQ9cjzu8uUV8xlVmRhLuaHsBvTsPRtGBWLOJakHzyaOQzYoTbm5cqeBmQM0ZwFKDXKfsth8NOmxge/UusAbKA0h6/apfRhOs3uOMfpaqjaEhvswGzKMY0p/PFn8KLofortAJc3++khCnoD74YakoF8Lp5KJors5tt2f4sgkDqBIxa4C/9RKl5BbJfpgMS8LmzgdMyqg6uHoX9JRlgVzywuBWyKTuvY/urjMSU9LNZFnbAzcyuwkMiEakH7ItsjyXgX00ekjikJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkMV5RPAOUXMCxwuwJgCfVPQ2hLm0gH8nWU7zplX+Zk=;
 b=Cty24eK7jsDBdaiU58Xh1A0mKR/6cmlPdnyjyhee3zycpZ+rrcETG9HktZrNxdzyYD+stq1CJPPTGjSv922F6nr6SmBy0I4XTJsSIxF/3QMcoEAppLomhNCIValZOVU1HNs1GPBVYARW0ZM0hc34Nizsb+s/2cWXsLo3g0FL/3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4989.namprd13.prod.outlook.com (2603:10b6:806:1a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 16:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 16:38:05 +0000
Date:   Wed, 8 Mar 2023 17:37:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Message-ID: <ZAi55mrnHfBGGKAi@corigine.com>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
 <20230308091237.3483895-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091237.3483895-2-o.rempel@pengutronix.de>
X-ClientProxiedBy: AM9P250CA0013.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: bb960821-2427-4e2c-64c8-08db1ff37ddb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h030sTfjBdXkUfWt6Fh4p32rglPTlezjIFS10dh1e4MQ0sZsJzswhDGPJhWUkZUF6eQeQx/j/7ExSI2CfxKO84R+WcXNULUM2V1zGX3+bjRlD6Ue5bbine8LGoo+khAa7Iuty5dbuHExQbMMTOUkrCWVLdmtjntrdEllxJaVQSVdbdHfju7fo6s80aXS85f/dzUp7d61Lbaqzt16g3BXH+ZqC3oI6eKTXBfDCzpscnlKvM5SdghaOWHFnTWORxhsbMosrEzyo4tVhDESTG1wXE/+iTKnotF2AjnT0jvvtvLPiXfLEX5UfEx0S32869Dk7CPfEHW0vZUqrewW2HayzyVl+TbLOYyas8qarAVadOCSm9dwX1pfTsbPyZ3x/Id6Ibrt8LfhwO6UNxFbtUyJAwXSDhpQNIenxWaFAKOg1X/7Mregm+oEWWGH6Abb+EpHl9fsILjDvdKeH6AwujVJa3a06SvyOLXsdypnYLyMqCFo7VzrzN98nTARG5Wo07b+vr8N5d61b3YvbePx5l0ViOrapCib3lbzjngAp4dHErcT54wgVREEpvNm+Ptd9PPc+V7RobD1fBUn2ppQTIROFErR1NX1Q63HsVKSMEV9jX5Uhqt7RZH1AN69v7HGDPlpPAHTsNl8PdAE7L3hHMSALJkZNYmcl2uEHUMARdLKnASJtK52D1lUVKL7YgjoeGqd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(376002)(366004)(346002)(451199018)(38100700002)(86362001)(558084003)(6916009)(36756003)(66476007)(8676002)(66556008)(7416002)(2906002)(4326008)(5660300002)(8936002)(41300700001)(44832011)(66946007)(2616005)(186003)(6506007)(6512007)(6666004)(6486002)(316002)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XzhXKMHXj10lgE+uGc4Z3AQFIlowG/0pLs33Ixn+QtZiIEJpl41DsU7Sx9u1?=
 =?us-ascii?Q?A1JoOGFG+UHBuyrEDXesvUGXKxYyvTmGVrl39frS/TSA4lKWswQemVnSW8Cm?=
 =?us-ascii?Q?52NannnEgl7YTSnZfSc1a/vRNIk2Smf4GmbS8dDNVtigY2TzmEKCq069eZCp?=
 =?us-ascii?Q?LkfHVBjZAow5npUkzNH8bIsWUfm/Xe3ZtginqKtaC4A7rsL4gGEHgOdwa80R?=
 =?us-ascii?Q?5YYo6H9tuAaanSFdpUqcOKPQJ3aoGtM3ldxlJvn5ya80D7t44eWLqYZ6uLdg?=
 =?us-ascii?Q?mumBbzQZrLC2WYxUWGjyMVPXRQt65lT3HMqhxyXb5D6x9I+0N18TxCmO3VRq?=
 =?us-ascii?Q?67R2cQilHZZ8fzcua57nQ6S/sLx3bqaxJzR/fehxKo9nQfe8SProCDgJLtCj?=
 =?us-ascii?Q?zkL/HrnFMexnmYx2vyWUV5Tk93dycVArlMLNNTonPemWoJdBwXSEy0C8PBd0?=
 =?us-ascii?Q?UPSm6QkP3f8pCxELM0vW51XIZpjxbC7UptPFWbJAxucBIIE9XFdfaQ4afvir?=
 =?us-ascii?Q?HZ1lUgGiXXF8Z0VyFSwIpejaxXwCEvO3fBezrAdchVMxm3aYbzSeJeJrvHYV?=
 =?us-ascii?Q?3G40TUT+S0/AL4c6BR4knrHxk0pWuB4Oxs9lLb1GMnIsT/E305ixDuBZUgNJ?=
 =?us-ascii?Q?hT3uc7KpnSKTvgfe5rsoZrxAwcI6RMwzcgdU5aR9sPQGYjki5Mo16LeB4r8o?=
 =?us-ascii?Q?OUvgmxjrwXp5b/9IVaAq6gFyKk+i38tyLJfrwJlrKz5ThhsesLIkiFpOtqmk?=
 =?us-ascii?Q?eksFGkBZ7aG4chvyxxFxRQ7PWrYLQX67v0MQ4/DDBIX9wzfK7J39Wm4yoLzc?=
 =?us-ascii?Q?qnbUok3cNPo9qhtEQa4aFIgGhJ+wgvE7oyNkuPe9H1wccF2rzPQbfvWxOnfq?=
 =?us-ascii?Q?MCPvsN/XrrSAcooXWOpS+tdd+SjNpBIfqCCZnhk0g4KV/axfgOYwOliMUlUl?=
 =?us-ascii?Q?pDwUAdDYvhJ3y3ezu2DCZbTEqpUeq7g8T5mA6F1t+mb2C0BgNdcYxgYXOgFK?=
 =?us-ascii?Q?JEA6GJgyTFwJ/ECmofMAMZSJ+h/78zkSFJa8vA8zZK+USTYSMgXOpE3RAp84?=
 =?us-ascii?Q?H15Mnt4l2k8xwpZHTkzClKb4fdZ0bzfv1giKl2RUyTvMXhw4p/gnq42ZzR9y?=
 =?us-ascii?Q?2K2/5F+3LafIv75EYkmqf5jJzYRj+Qo1+4SM6iUrKxPPcmqyFhTtvFIDe2uZ?=
 =?us-ascii?Q?dXX4nGcxuNByhSaiJVlnqy9PI6HPZLMoBLO2y0dwIb+39GN/fxYmpPq4inlg?=
 =?us-ascii?Q?8HKIlb59nsAkcqyVvOsvDvJi9J4HxPN5iLP/yhPX8ies1hcycK3IawB2dM2J?=
 =?us-ascii?Q?uDnda7767WnFLXJTwTim4GupsNp6fvUBrWroR+dshhgyEBSKBQJK/Ovxox/C?=
 =?us-ascii?Q?CtJKVSzNeDMy5CvCCe4mkavatR00VkQt8vp0shXJCqWiErovOivErPFFjBuC?=
 =?us-ascii?Q?Iu5yhc9/sz8NZpqcovFYtgqSp32kTAQsSpVY59+Giu3cOk4xR/1ZRlyjRNET?=
 =?us-ascii?Q?nAswy+R/sqc64spCfv+c8Amy5VeMybM5bAq7AdATFFp7+Tl+qM6rdta1qQhh?=
 =?us-ascii?Q?JzI+YIO2ElSJk/JzEJ+O0z78z0JkIZmApLvlF56qPgnBT/9FSOdtg8viU1by?=
 =?us-ascii?Q?HkPkZwLWCRFV+Xp9maXyDUoydKV1WOMlvHxuvyYEPritdWTq3K7XpsssmXI1?=
 =?us-ascii?Q?tFbG1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb960821-2427-4e2c-64c8-08db1ff37ddb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 16:38:05.4132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAjm8NlEUJtN4czMI6w7NWHhMPlCKu0rFEohIGKmYUpTgSqHLu34/YAX4VQSGOWSokWJVgluSaBpces/ro9Nzx0xc9UPOBH/PCxSRsOUj0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:12:36AM +0100, Oleksij Rempel wrote:
> Add ksz_setup_tc_mode() to make queue scheduling and shaping
> configuration more visible.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

