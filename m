Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0646BAA2E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCOH6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCOH6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:58:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E791F92A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcpPLT+RNfWCrPODpA6E4jD4W7/RcYcoHkyD5Ay1QE8ZAhCTHU9ueeQY0jw62m976eO4PttLaM//nDZ3AYBi9lTV1ynwPL052a4r0xacSQ208tpWsLyCPmLPdqhmmHW+zcsKzAuyGnVv71CjjwGNOiQJxGba+sEdWCOEe4hqFLaFjosPstllE0zYRq72aZFwnvbHLeD2IOp0OIMq7s/aRbyAhLDxbbzxEIx5GPAy5kv71XzQkBv42dZlQnNLvg9Wh008S/DHvidHsuA4Xs1DXqnHo+qMt+B1LjeieZRitOT5EDvNcluwG5vpxm3hL+OGAcXR5I7UdaN0iVMmmBrh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKWM/hOY4e/8/uwaVsn+F8mbxE/F7u8TOpJ6D+Eyfto=;
 b=leGpcKWTRg6BOz7ggo7u1ytq9Noe0fj55L/ovk9yNGYu1JftipxgamR3GHp8fXVn59B5aHEGebGPUdu0L3PtP6/K0WaVIY74pWAJsef41dctE5UlySa9BajQR74o821bGJLfA+eOw+4lzmGutI05Vgkt+YrcB3SyWjlHa/1gXGuxKoF9G4GKylPiKXCUq2vyO1tMvWf/ExlnBXo6w1NDkX+IP0Fu7G2Q+ebvhhWLxwwC3Iq+gf7HGJbnnTpLOFUVsCgXy1ZLeEXi/mFsYLUe9TuJ/hPjmk9RYuIvpO/vbxZmigiKQuqN42yr6U2tCaXl1h3qEqo19cvDW4PN8G3MWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKWM/hOY4e/8/uwaVsn+F8mbxE/F7u8TOpJ6D+Eyfto=;
 b=mqQCSiQdFtMCNNqeFBxMdMnBXJ5osOTs/FP/G6jcc/iv5DcHcbLE7pyAN2RoyNh6QyJx36UyDnuMZ5XeE+WfBu8AVPzG2pkZXxbK1rxR8CyMb46nNSJGsw79gvdKFpNil15bzlw6r9bQTRfKVhJhL8412ePl5Se52M7LjEhUYPQGYx3oV+lJAe+lljLQB8MPfnPTqwDWOacb8TG5zBG1Pufx+M8o+BP40vjUxRw8U+Da8RMmgQVok2gRPrmEeXEHrvVqEAGNWzWoVW+8tEygd3z8tdykCIxw/lpefAL/6Y3z816Wmj+q3ljSytwiK+6Q7Bt/djcIhUg9PEWN+8pAnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7541.namprd12.prod.outlook.com (2603:10b6:208:42f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 07:58:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 07:58:42 +0000
Date:   Wed, 15 Mar 2023 09:58:35 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 09/11] vxlan: Add MDB data path support
Message-ID: <ZBF6q8zKx1nyW3TE@shredder>
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-10-idosch@nvidia.com>
 <e695257a-58e2-c676-95cd-77df5c2b68cf@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e695257a-58e2-c676-95cd-77df5c2b68cf@blackwall.org>
X-ClientProxiedBy: VI1P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7541:EE_
X-MS-Office365-Filtering-Correlation-Id: bc9b197c-d3c6-4650-506d-08db252b17eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uphb04gKD6TW2XNfBNdA/upUSavO0PT2an6BEJ7gKuYp1gnilTgjjrD/qv6QXXfcyz2U9fw6ELRFdUbxrZXVj7ngsSrJujL20d2uPbXPLRaA9wpue6/bdBRI1Og63HnlFS+XMaAsKJwjC6P7V3bxYZsw8br+W+deCFWR9EE9P6dFeyk0C/doUycDraQbjelzZZ1QFJ13AqxasHqJ7Tev1DfRjkbhvldmc2TMzg10Ie+OV9l+dlDhGp4VMSOqT4PrvCldXZEOHCen35pElW3FE2EWWGZ5JmX7i9gMdaYIJeOsPJhR7/K4NwGrOnLfjzi6bK6Tmkz71GCgTmclJgjtLGRXGIv2k422RGgUR/NRdk8ILwFmx9ni9XrLwi4hUklyFGg9woVM2g3NVhPWYGm7hN7d2Eoqu+HxYCaEULN7UU38TFuycd0iyoSvlfKsLWCwQTqiT4oTSmCg7D1Q6xt0VOq8GoZaeVdh1tgiCmkWs+PXS0h+iwyxDbxuYkGQK8JgbhM2IQ4Mvpuh/AhLYumaQiJHp9Eug065Q5+jtkYEfZO/acbkST/ip6xDIrTNkI5jmIVgPgbN/6BZoT3bAVZT1vTxJzYJ1sXTBT2w0DUcBskqM3BUqE/j32EOWRDEmAmYKzelAM9NeYVIONHslpvYwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199018)(4326008)(41300700001)(66946007)(8936002)(6916009)(66476007)(478600001)(8676002)(66556008)(86362001)(33716001)(38100700002)(6506007)(26005)(9686003)(53546011)(6486002)(6666004)(186003)(107886003)(2906002)(4744005)(6512007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yZ2REXuV+zTDzKVpjTqiq/3eG7FXQau5zLcocdhI5QQ1KdjZO36t0sU0L+Ub?=
 =?us-ascii?Q?nCRpWfN3PfYI+hJCWUgHZk31FLBuZE9ssB09raiZ+umHoiCW9CYdSArv0ohI?=
 =?us-ascii?Q?ddQS51BAnIE6DNvA3vobQ2l6+4Er1Gl035qPZ+UJ0zB20skLXmPgRYZ3yveH?=
 =?us-ascii?Q?lIoGlbRoaIcI0/tkmGwjb5S3LzsxMsjahtJF9Pp1JnomORJjA/gNf2+1Wc2r?=
 =?us-ascii?Q?a27P9aUE7sFw62M0bJKJ2vlknRoabHiE0CY+Xmtdj5nL2Pm71Rar/Vp7tMW+?=
 =?us-ascii?Q?PZ2vCfMdU+BxwIieYqxEqomnAVRhA8+PWXEmkpC7XfPkuZ1Kj5c53IJuVEYW?=
 =?us-ascii?Q?Cas+koAgEMTH3NlOMw2Vr2Gy1pFh6Kxr3kUh7W0lZDG6qVjeewT5fhcR/9G8?=
 =?us-ascii?Q?88tzoDUiuN0SfUm7G+8UTOgWYZDUKQNs5Y6KE5qV/SZuDAFtk+bmpTqBWb1P?=
 =?us-ascii?Q?280xEeRFMV98rCdP/s+dCsYMectgEwT3SYyjdj9GZcKQD4xpLX3VW1eT5xrw?=
 =?us-ascii?Q?2AkNRaFYofVaa1v8g6gDlnA0w4i3J16u2gmjRCjBLD9KzYPmPByBJCoDhLMc?=
 =?us-ascii?Q?xxRi0TvNaooUMqQzRv3k4AA292MMzyxt76DLE5bzaTPQrIaz6Gfcb17JL2u6?=
 =?us-ascii?Q?+R/vgs0OT8xTLttHIqk8B+/1BA7gbGAsP0GR7CF60Ia+1PlpvzP1DgScccne?=
 =?us-ascii?Q?B6dzevn/LlxlmWvp/8qCbRGMOUpdZa6250n2r0OrD+kvraS8a7X0GUm1fkGR?=
 =?us-ascii?Q?MOJm+nVBocG9LrTpk9bquobKH3JVlGFDJ8ZB6QelSwzMIKi2gKkGJm4q17wK?=
 =?us-ascii?Q?LYdpe9PZmU8bfb+HduLgNwsfUr0NwH8sFYC5DTJlbJaP24abAPwhSSR1vbAc?=
 =?us-ascii?Q?AZL9v1HMD51awDuwHdc+6hK3s7rmj8WX9aTx+VxyRKD0CQOGdAu7AvKB5eeg?=
 =?us-ascii?Q?LiFGxbENpc2FtcD4zOI/WsjsAwACpnR0/qK+f4cGzbEpHDGpmTeNhuWWcwDs?=
 =?us-ascii?Q?Hnx+cL+uWlQDUn3q8Oaf6+9wJe2fWUgXTviXaTYXBEpoE4z6UxJ895OobWcY?=
 =?us-ascii?Q?8UzzeLC/EpqMcTYT7DEcy6A457dBErVhPRQI4Zoy9helL4bbZh+9j1FYvNTA?=
 =?us-ascii?Q?H0ttqhehm5Br3JNXbSHgP+Uh5mw9NI2zguq0n5B0TL7JaMHgO+Bs0IJavRZI?=
 =?us-ascii?Q?/cX7tqtJozPhm7kalcRvXWfI6iqSDtnJ3MY5uIeoBtprKIqqwk5j06trDRhW?=
 =?us-ascii?Q?diD5hxH84yhf5jlXi6vQJEF8/DH9aI4A14TDGHXEDfV8gXPd5rqq75ufE+Up?=
 =?us-ascii?Q?+BmIKpR1LwsCHF8FB1AxST8FMwbq26uaieqlPQ9pECYv2AfqrR7Wh6Doxj7D?=
 =?us-ascii?Q?x/np27X1z3Z/o8C+RA7C1X0OGCp289JKsARiCskEoTnUMRmqrQPlI5lOsGQV?=
 =?us-ascii?Q?rLf56Nv/q9WrucChAvwWZss0hrQHpbpdcCu8yYdzkI2FCOwZiFoQMzk7Cc2x?=
 =?us-ascii?Q?pC+y9VHP27b+wc+2MfIQXo8sWB7xTzgNHar/8trLYkIQHEn4oXdIzS+f+Jbd?=
 =?us-ascii?Q?K71cJEpTcypfNfb+0Q5AACRJuT2dMV5+46a/HWzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9b197c-d3c6-4650-506d-08db252b17eb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 07:58:41.9439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7k3UEW0MOvrqZwODEodrzbhZPF46jMqUBZLZpAtpmXS7c4SkzwYHflGOG70JZENlXuq5fc3yPqb8NcBekqMJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:35:08PM +0200, Nikolay Aleksandrov wrote:
> On 13/03/2023 16:53, Ido Schimmel wrote:
> > +struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
> > +						struct sk_buff *skb,
> > +						__be32 src_vni)
> > +{
> > +	struct vxlan_mdb_entry *mdb_entry;
> > +	struct vxlan_mdb_entry_key group;
> > +
> > +	if (!is_multicast_ether_addr(eth_hdr(skb)->h_dest) ||
> > +	    is_broadcast_ether_addr(eth_hdr(skb)->h_dest))
> > +		return NULL;
> > +
> > +	/* When not in collect metadata mode, 'src_vni' is zero, but MDB
> > +	 * entries are stored with the VNI of the VXLAN device.
> > +	 */
> > +	if (!(vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA))
> > +		src_vni = vxlan->default_dst.remote_vni;
> > +
> > +	memset(&group, 0, sizeof(group));
> > +	group.vni = src_vni;
> > +
> > +	switch (ntohs(skb->protocol)) {
> 
> drop the ntohs and..
> 
> > +	case ETH_P_IP:
> 
> htons(ETH_P_IP)

Done. Thanks a lot for the review!
