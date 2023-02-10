Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B23692312
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjBJQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjBJQQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:16:13 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C46374302
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 08:16:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPr7JuAu/w4pWzrclR3TdQyUuDPkB5uRmuctBV2aa4ITWcLFYnSkC18PoMLzXyEtfEml000s10WMvIPe5pO/BbjebnVerZSEle/1dPOMX0mN2hbG/MTuwraTAjyFKhaO53LwCMPSGiTLZ8i8M6hlgrGSb1qxAWKKiS7GO5S9KXGl1v27MkO22h9sYIgrSaYRaxsOsTkmg8ZH7QrHWJ2ZbIDQrlfgq6uOLUNbL3rYJQBN5xHSHA/GEn1BysySTuTP1GM7vOUvv2a0LRX6wIPRlarYMFs905f9N864tyo0sIy1Dq4CLLWbLB70O5FOjyfCtFU9st1wRUC4YvlSxVAVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43pvgYuy/RbWrFLWQY6Jhp1womEu2K4D+q4lZQRshqc=;
 b=ZHSl/zcLeD0DUArTTtuv/bnwMH65U4aBgHf+5+xQyq6VXXoqd3I7bJq20lyH3FXWA8nW3j2j7CnLfGKM04E2vijB6b8yHfwpm+D4grcrzJ/rgjiJTSnxRzpCCD4C1ymxtuMtEREEg0uh0LTGwoGbjoMwvudR83RXinbkuKzfIWd9m6g2znWSoDTC3V9HAnTN017hA+wtSn7+eKfkPVKwvPOs1aYMvOGGvb2VOa3gsgHXDcgSQBzva8CfpKCSVvoGjro1bTJfm3x5HWkKoKZ1J6tSmc3YIvi5BReaBZb2goWDMuaSHTKni+Gq7duMO3oQtsAyr9ZyBFCgsiHhh7tlbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43pvgYuy/RbWrFLWQY6Jhp1womEu2K4D+q4lZQRshqc=;
 b=n+DpotGA82UCxLpK1z1JjdIYXRKI2SuFijZ8AL4+ei5Kt7qoRExFk1Mngh2PTwzko9x099RH3ZanB9UWc713jTGGCxXHpwtZsDhxtHxbOPxfi0pDv8T960XuXwSv8PBPJ8yLGYiV6TQhDXGf/tv0OcWP5SqGAYMxKxmdcDW0uMY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7278.eurprd04.prod.outlook.com (2603:10a6:800:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 16:16:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 16:16:04 +0000
Date:   Fri, 10 Feb 2023 18:16:00 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next] net/sched: fix error recovery in qdisc_create()
Message-ID: <20230210161600.grt472jhup6wfkbb@skbuf>
References: <20230210152605.1852743-1-edumazet@google.com>
 <20230210152605.1852743-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210152605.1852743-1-edumazet@google.com>
 <20230210152605.1852743-1-edumazet@google.com>
X-ClientProxiedBy: AM3PR05CA0134.eurprd05.prod.outlook.com
 (2603:10a6:207:3::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VE1PR04MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: a25858ba-b043-49a9-7af9-08db0b821be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TufZw2a8ahRocfZSMtsK4HxJ5IXUKjYbvzvsau7t3HDXEdRIGIAbcciKedgS6XEI9RqnaUP3WaLsJsJnEF2EOLJvh2L6+NrEF7NFlcjyk7tuQbMoVjqYyt6d0c57YpBY7YXUCFKUofxOpwEczghpykChOn5dlEfL5E397decfYRbz1cvvSQG0wBqkRDhhduLjHTjXP6ZYP6g5kVGaJjt2mjxg6Vw3RCG0jcxQr5GWkpwCbX2joA/318JU2SnzJQkcQ06z0Fkm6VHDyvXwDIXEZ3P6oqdpXHSCYfGs1Dy8HihFy0dXUHWN3zsvnLzWZoP7/w8y+/jLofSoPEKYWmBtumkHnHEJy7B6B/ebXj/2iIGHCLLpmjyRs+eyTjzW5/vu3rkDkwo1LpieeEZlRdXsFrd2sDXklhfh2ii9nmMZGyh/EHzu6aCjxLbIOdyaYtmfMX8sgYoxwEvWQVUBztlcHEbSu9+lrPxv+STR4+50DUkWT5hxTU7DsU4H9/2S6ey0T9eY8ozwpbr8KUxjRBMbBvk7AoYBg6kY9+rbVwuuYe0r6aBb5yTm/iElu32QSl7rD+LiFJfQV5xoiRZJjYegrX9eyr3PPW/GZY6UJvUob+F0UvdPYKA2UYglhbhvhkZDCRWNJf3cMJDwojPiOt+Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199018)(4744005)(2906002)(44832011)(26005)(6512007)(7416002)(86362001)(8936002)(9686003)(5660300002)(6486002)(478600001)(1076003)(6506007)(186003)(6666004)(6916009)(38100700002)(66476007)(4326008)(66946007)(66556008)(8676002)(316002)(41300700001)(54906003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VwPkpED2+AP17VgXA+mTJoc4HGrvmKlgK6HbQv9j1x4sinGyKScrhTFCqo15?=
 =?us-ascii?Q?hQJXqMDC0FSPGzU3jACE6NKCcjHBG960/mcOx/PLsUODzC1xqkYz4RMsiOaF?=
 =?us-ascii?Q?MTHI1N3i7P4vEzoAdN77CZJlbAiFKLqT2E7K+LUb8LA3bC5Omn4ELkg94Xf6?=
 =?us-ascii?Q?VJlh7Jh34dWPmQ30+NP90lLmKk3K/UjNn5ImsHdNMSlIn2jS8o4OaK/VVclo?=
 =?us-ascii?Q?2ahfwdVeLdRqchBkWpDlZV3uS02ToflvtyFnahnUXZhXTVLQxT1/3DDgBfLB?=
 =?us-ascii?Q?8k9sep/6qwMCmIkGVH36vEIwYnAPfW6EJ64gNDwHTUsigWfh5S3TMrO+72xh?=
 =?us-ascii?Q?mXKjJJ4NjZNTpbS93d3/pLS4p+l70iUE34m0XP2q4dZ9sxC251FCqcFPtSO7?=
 =?us-ascii?Q?5U5AU7e5OKGylyflC9z35wYcCS6R94B9mDgVlbF8D+U0YPStM5hEWiJUmDc0?=
 =?us-ascii?Q?vjij0dGMEetftOD0x7jr/e1nzy6GRNATzCdlebvj4SAwm6la7KxWGdR3tI7n?=
 =?us-ascii?Q?ybUsySkM/8B3lu7LWA1deIJjmlBMEy742ZKB4W1yVLfmJ9lEHHV/MAnfmT8H?=
 =?us-ascii?Q?/h8Jld0ZbAA6eXveSrtcL/ymmiuRkou7osZmLSMvnEHobTzhmXZ6+e38qYeP?=
 =?us-ascii?Q?E3FRlg1yF8yzfDYMYa4k0HDIzUZsf0rD4VBXx7n+A18+le7iyx4pzltr2ioy?=
 =?us-ascii?Q?q1v9mZBIwdtKV0D3vMo16jmf7rkdQWquHpgdLaekRa/zg1AgoD2tPGOvXtv9?=
 =?us-ascii?Q?0Z8FVdbjGdrIqcxREg+xzJSMWdP/b86/f+lulkx0dB6dVqvBMdb29aAU3H3a?=
 =?us-ascii?Q?KCpq2d0nxcNusmvTfVA5Fv/0F/IWYpq5BjdJwmsMygfk2x0/LrTrWhsvgGNj?=
 =?us-ascii?Q?WlkEZdawvY9cHUuboUvyndD4z3SAG8fCBsdChGshPRvfVkgmPkdFJJu8KsXP?=
 =?us-ascii?Q?9vw0gVYwFCoAdrCblSayz5qiLHoBh8dT1d7gjMli2V/MLwbZ34MfVOr7jK0E?=
 =?us-ascii?Q?mmkloYCSxXI+V0ijdgF0m0wWv+Ly5zSiBgziVUyY8uFIakoG0t1VPvNh3za6?=
 =?us-ascii?Q?FDjwHfyvrEWixTdP1EYI+KqS14RygH6IFn06kBKlpPFu/oKnsDA1xmYaUwx0?=
 =?us-ascii?Q?XhvoyHFyCcLo0HSw3WvTWIqa05VVaoFCmE5O0vH21oT2mhVp6cOS4sciu6SN?=
 =?us-ascii?Q?MPbSOTVx9J/eDQ5Tt1aQphOy0Tiq+knaKOgPT9jgoD5EhFGwBjb5Iq0k+T3V?=
 =?us-ascii?Q?27ory81qSci3h/256+p/GipRTGQVC4D87GaAE0lSIs1OJLTufh8CHB7PDBBr?=
 =?us-ascii?Q?ZbPCrQdtZUzBbuSTmGlqfZOERP4FWUF8XadN+nTAiOSj1RM+p+cjTNVCD1zW?=
 =?us-ascii?Q?VMEsZ75RYm0sP7xo2iSoreQei0D8ZT7nc3NESySL2DAEGYi0GCsZaPzXPJYA?=
 =?us-ascii?Q?TYX19r8PrKKVE0oB4HVpCMl14gRlW1NNCy1yjOiClXkZ/81MjwtJ3iebBEtf?=
 =?us-ascii?Q?bYI3yqNsTb52k2yYG6yriHTAEc4zAGmyaBFY2yA/skaZC7NWD+/kU/0FjRO1?=
 =?us-ascii?Q?b6XLdkSnKvpdokT65abh1Qkl5JUuWwAU/b1vHVQnOs35WNHI09hyydZ/eAHE?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25858ba-b043-49a9-7af9-08db0b821be2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 16:16:04.5944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6uDx8qik80q+oMe6TYfM05Max3imZNGGJN4RDLL2m6kF1/CaYu8OTV6b77hIl8G8ndETLpRr1MtlTUznYj+2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 03:26:05PM +0000, Eric Dumazet wrote:
> If TCA_STAB attribute is malformed, qdisc_get_stab() returns
> an error, and we end up calling ops->destroy() while ops->init()
> has not been called yet.
> 
> While we are at it, call qdisc_put_stab() after ops->destroy().
> 
> Fixes: 1f62879e3632 ("net/sched: make stab available before ops->init() call")
> Reported-by: syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
