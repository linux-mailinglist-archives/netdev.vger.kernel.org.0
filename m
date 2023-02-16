Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62BA69917C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjBPKg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBPKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:36:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8581C54548;
        Thu, 16 Feb 2023 02:35:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKNx7eVgXFTUcTqc3xbaQf8PWpXkeFDM68QA8JDuvyRS+RHB1GfyZBZ0VCTPfe4od1SthrZvfYdMeym8YMLWT4ETMAns8CdsVctlfmUyexXSR7quxYm2NDCjLBqN6b6Qnj63zZRJ7dFVYSSG+Zf24QRPfvIX6fzu+gy1r5A2xigpUVlTnTNNrRM9lrk1m1m4Zb5mQRobQy/onDAjATkz8QB2rtgafnZu/rXfLkqh7NfFImmUBYccUcnQ/e3keoRSGBXMa1HDz1vBmRVtJy5RoNAeR/Vaf8FTFl7Mg1K1w2qkO1HiH6QZmgFLnFcIQh1nYJdgNuN2MXrjrnQ+/wXFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL48ZGgYux8+zO5FlOizRddNkYha10BOrREUm2fTlc8=;
 b=IW855Oypr6r2i1/U7f0SjpOoHwkPYfxLPPg1Tq2hWTR/5eDzlkJEjnQVYf3QvMKH8Czr1ixOHoE0DHKBJuOLSoAeaApFSp6dzbrS8UiESmwo8xkQXqLn0t1DMyNHKcmMpX3qYwV5nqM5PrnV+OKi2XE1scVeprLRuxFUqfDITsMVElRAZoeB+jvjks7vs/yjkksUvqqCa3/KJ5CVOW1xrA6RLSFXnmiyV1jaRKEUIR8qFWBm1ZrS6N7Vb7OTb/s2hD2zWOgNi8Nza8HMUMBQipLIzuonHrtmL+nNDZJaXEHHRM1BpXPNochIyF7CRa8CNHQejL/4yeMD2qKxXtMgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL48ZGgYux8+zO5FlOizRddNkYha10BOrREUm2fTlc8=;
 b=qsYSFQrP3Sz0snTFq791b6AmAH/tL0tFwdpDQpx1qvoxPGDqpfhbitS8D+0V0akhvsfULRmmHjBjurI0NvKf9HFtiaT9o0gAV4+qXCKk+oW3SGmDBUpCwYE06uBYUSwkIo47qWy5qgMBQqGsZm6IYyYwdo0gh2kIFG7IulDAk1o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9591.eurprd04.prod.outlook.com (2603:10a6:102:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 10:35:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 10:35:40 +0000
Date:   Thu, 16 Feb 2023 12:35:36 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/sched: taprio: dynamic max_sdu larger
 than the max_mtu is unlimited
Message-ID: <20230216103536.abju64jbpucfyqir@skbuf>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-4-vladimir.oltean@nxp.com>
 <87cz6aot67.fsf@kurt>
 <20230216102914.wat37qsih5xx3wk4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216102914.wat37qsih5xx3wk4@skbuf>
X-ClientProxiedBy: BE0P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: 430c287b-7158-4d17-d987-08db10098c9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNbYAMUN6W61LTld0TmUqRe2S+VEJKd4jDHCJ6Es6yGyUZ1uwonsY+uSAaNHgMrgHNVB19wREyQDzVzrN771zRCa9ZCm5IRUms9W1QZJx8ddIi5F6tlOkz4CgvjMjDdoqLkkn8EviGUozzzGwp54g5mAft/FQ1/oOU/tzWT03cc7GEyIvDz2tqXOxYpfgVspn9o3GIokthYEKBOlGHolPXMJuTFmaTE+eG3zqdIGiVNGPgEzSbSvO9k7c0ISPXhgPkQgDFwXH3C1mc5Uv1eVqmR+D4C1HSoqkSRa4QEpXZ9IguuBLvaVUVo+FsID6mcEBrnMkSiiplNbqidmoCso/YH12PHa2Ekj2c3QLVD4j7hh9Ka319HNO9f9b4Jz1oj81SSIhUWzOvwaJhE+zbr1PtHelaHC1WSpn4gMm3gpi1zXOBGivL7dIPOU0rMw4ZACyEbiMidfSSZj65dPAQDQmcG4AuMyayxsO9W7Ym+4GdD2im4SqjirPmhkkZxL/bnTa7u+MAYeSWDdNPjISrjRJDd9Gks46bcNdjKM3JHoe21dB/y46gz4Nj8mPmI0xh6hB7J71GaGNhtIqa1Nnw2IcLJdaXnDhFEwSX3mJFBbIXhN37U5+drqj8lWt7oMCk1FDpiw4LU5IAYcAw9ys2ng+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(83380400001)(6506007)(33716001)(86362001)(186003)(1076003)(6512007)(54906003)(66556008)(5660300002)(26005)(8936002)(9686003)(6486002)(4326008)(44832011)(8676002)(66476007)(6916009)(66946007)(41300700001)(7416002)(478600001)(6666004)(2906002)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zyVDrr0n733ZHaDhuNQkeG60ldW14qgs8pjQJWXAf2tpuoLPAulKBcEHv8Oc?=
 =?us-ascii?Q?JEJROOJckxi/JqAf3+Jwh5w61gfaI0F/QYF8mzC8dRrOEo2XF0xLGDIqKQAv?=
 =?us-ascii?Q?VVYPoPa/W0hev/VoQgDAgG6KCNmnazFT4gaQ7HHv7AKnDLLvw20vOiOynBAZ?=
 =?us-ascii?Q?AyRbk32C/V/rwFS9vuY4v1ymF0/mMHYEE94sTUoGBqjcIJUY6fw9xebI70oV?=
 =?us-ascii?Q?3vRB1imK5jnIpQhrUMhJkMqTs9kc0/p4+k9wx0JSBc+B4MFZornMhPMGR1pc?=
 =?us-ascii?Q?FpMxgK2Id9SGbUt+/4Bg3KngOxpN8N0fGXj23gJUXCmaPL/M/jKcMX76dusB?=
 =?us-ascii?Q?Z34j2O0w0hQv+VBlc+rGvpCiWQnlCKIgehxn0RUFcn51YOtkbeIKQAJeivVH?=
 =?us-ascii?Q?2PeWG+viw7IXPr52YTLF5Yft397JtHdRpuyIqjVjxVAKdbYQJ/6HOLHaMtOQ?=
 =?us-ascii?Q?PxUhqu5p+fV16sn4pEb9tv676MNRV/JLID82Vu4atyKxvQlq2W8nUg3YP7qt?=
 =?us-ascii?Q?CuToxWwRknSdrL3U1Cb9WMw4965pXptX9VoOQJD1MeDRmN3n4txpvuAoFJmq?=
 =?us-ascii?Q?rSg9gZP0LX2/ZB6EzhZwt9msIlsrcR3ad6mjGV1y+Y8ZvvQzvnYkKAY6oWVW?=
 =?us-ascii?Q?6STmflev34yuCF7AT0BAOFlm0HyNgfShl3rG7Eraezc4jqyb/8k/CkFsCuWe?=
 =?us-ascii?Q?l6Mg4iWIgHO5jctnSdas9V3zQwrwqOVuqQzkcvfVNxLvAV/QhPzLJxAKFlJw?=
 =?us-ascii?Q?xx3GpebwNri02+uzZaVFCMy+dy8we6gcZZ5JuUNQU3vbXS8fIZ/xwwbzgJ/o?=
 =?us-ascii?Q?vDzJ2CG88mwoV+Q+JB2IWG4PHYxuMlP2WO0zeQNfk/7OKW2zNw7rQoaKHrbV?=
 =?us-ascii?Q?H3rgTozJ9Bg3D68i1njH0lVYHS9zD9EFThz0k/5Cha6SxZUiSI4rXwrYxOy7?=
 =?us-ascii?Q?DVZzLX+b/h4+L9z18bi0QkKIseM9at/wRyJBuHXyJSn/1Q8amID4EzxwQA1i?=
 =?us-ascii?Q?QcFkMzDkvK3xBngHoBBb151cys5zLDpJVg7zuKWg4Pk7skghhXwjlFl1YnQE?=
 =?us-ascii?Q?hqYaGC2YshUGzK2p5bywna89VONQxFj84UKjQ434O2RW63jf06zesiBncYTP?=
 =?us-ascii?Q?O8CIW7gED5760ymRdLPmcFxr/cVtU1L3t0qaYjkLyJ5zGsHnGx68WcdFdjAA?=
 =?us-ascii?Q?QQAjKXpPYbBVGqcJ67nPx9IrD49trs1QguUhgvXKeEbu6R7taWfEN2c7ypIV?=
 =?us-ascii?Q?0bM5AuLPWjk14MKagE3Y8xlaOlS9UdF8jBk4Rk29Dv1nu9P4QRaDoCR7kXlK?=
 =?us-ascii?Q?Rm/EsWwnzA7UjM3+zcp/4aMYNfOA0IrQE256ZQcr91qFp5yQU0e3WN33CMwm?=
 =?us-ascii?Q?Zc8vAM+8++aN0wqwzMlmyahtOCGB/3IpWM2pCJkMJiNtRqe4N9As2mr3/9x0?=
 =?us-ascii?Q?If+s93UnYuJaMIMA91IL2OKONqj0p5sfTsT910yX3RqdCKPguYCpgz3WlUCc?=
 =?us-ascii?Q?jzta/bb2ZixVMfPGM16xmUkzcEtViGJW5nc0aT5atwBIIIOA5OKOeg+VjhPU?=
 =?us-ascii?Q?BITKGKRN1tyjhQA6BQyqPqqwa4VLOEQCQrQoOMJbYFMrkT6aNZqkFhffH+KA?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430c287b-7158-4d17-d987-08db10098c9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:35:40.4433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IGPOOg8KCLYuUqzxj43nzYjrw8BhkISmick+G/1lXgHlmGgHmGGqfK6KtrJROPCgqkLFX12gWtS1YKfDVWdaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9591
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 12:29:14PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 10:28:48AM +0100, Kurt Kanzenbach wrote:
> > On Thu Feb 16 2023, Vladimir Oltean wrote:
> > > It makes no sense to keep randomly large max_sdu values, especially if
> > > larger than the device's max_mtu. These are visible in "tc qdisc show".
> > > Such a max_sdu is practically unlimited and will cause no packets for
> > > that traffic class to be dropped on enqueue.
> > >
> > > Just set max_sdu_dynamic to U32_MAX, which in the logic below causes
> > > taprio to save a max_frm_len of U32_MAX and a max_sdu presented to user
> > > space of 0 (unlimited).
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Doesn't this deserve a Fixes tag as well?
> 
> No, I don't think so. It's just so that the user (and later, the offloading
> driver) doesn't see arbitrarily large values, just a simplifying 0. I guess
> it could potentially make a difference to the software taprio data path with
> TSO, if the max MTU is comparable with the segment sizes.
> 
> Anyway, with or without the Fixes tag, the patch lands in the same place.

I should probably clarify the term "later". Right now, taprio_enable_offload()
still passes q->max_sdu[tc] to the offloading driver and not sched->max_sdu[tc],
or in other words, it always passes what the user has requested, not the
value postprocessed by taprio to take the current speed into consideration.
