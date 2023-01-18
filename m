Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D4C6717B7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 10:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjARJ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 04:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjARJZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 04:25:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C495B475;
        Wed, 18 Jan 2023 00:51:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThbJw0NVN+gb74XrjIYjcamA/OGPRQTxbgLs39j/cmeKUTLF2iadzQNQqSjzSXQnXb2MUhmGjuOaFnxpQFbpitOgdrktfzNGO4n00T+Jo0kxIWkOaRDRlenuYzn5x0WbgNSMG+QZxlRghN/qwDpdKXK42CBPqK1p3HV8l/VW9D3Sm7PoNLzqAca4EAFN5tlo4+2bZHaQigvio6VnabN50OPOIvBs8hzBsJJQmcv7e4SCubw9Uvtqc84Y2V23zlrpQDQwCgmkYz3YeeHkJgflesUop8cfFMZOf+aP2LeA2U5c+/3hFeICqd/zrxNLM86o/E/U/W7czMHUNZVick9hTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNPNchCe3qPJwRBtuDTPPZ5vZFfOWodutanIKrZso2c=;
 b=BEEt4fthH8ZNg1QJV1wNoNtlgFpmyL6DUG3GnrvnWuzlAtLi2Cy+2xiagYSsbS+zFcmHMEOZQiMAI+SSJxH18mea3CWcSTZBtWhV7ByxOTxuuON8QiFHptmv2SAxjKP+qNOIR0jwiTO2vrM0xEsvMLuLwrttNwx/4zL2S425XgHPYXz+XjGt/ZjFq1cKc1dEAtklC1zLXVdhUWG0PnB110FatSBr5Rdp21i/oGZXViQ6P0I3Lb+wGqyNIgpVNBqj+uGjcdczEvEiJxWy5R/BqYtLxXaCm2WLC8dWjqyJFQWjJcSaDibi/yzHx552bRjal9B3Xm3D+tnDKNeY3m8xew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNPNchCe3qPJwRBtuDTPPZ5vZFfOWodutanIKrZso2c=;
 b=vMYHQ7CiwOZbBvr0hw59pgRDQ8JiGtCL85+7NMqLoKPwkpGwx3BvAm30IYzxYXl80jzgZRy80N9v3ChKsNl2wlytgz6ioChVq4+xAUA3/Y7U60zpN+VZbSKwFATR0B9+dB3jrD9lJYEJxeQOjP11zHBLz5lXzAPPVipZxorPsoM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com (2603:10b6:a03:3e2::9)
 by DM6PR13MB4049.namprd13.prod.outlook.com (2603:10b6:5:2a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 08:51:09 +0000
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0]) by SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0%9]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 08:51:09 +0000
Date:   Wed, 18 Jan 2023 09:50:53 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <Y8ey7Sg3BcPfsU9d@sleipner.dyn.berto.se>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
 <Y8czKD8/yXywbl+f@lore-desk>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8czKD8/yXywbl+f@lore-desk>
X-ClientProxiedBy: FR3P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::9) To SJ0PR13MB6037.namprd13.prod.outlook.com
 (2603:10b6:a03:3e2::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR13MB6037:EE_|DM6PR13MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: f2bbde9f-a473-47b3-031b-08daf93124c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4XaM9lp+GFn7RTX2ceMQD9SXfg3S4CB9o2CFtk0lFBd0NBDoCS0sjQjR4nweEb1WFOQsSBIw56C/Ds0h7cyvynZQWVmmEXgKVo/Ks/83S4/WBZcrFu/jr3a3eV11bMQe4G96e1bsqMro4NkpgL2RBDNxcMpH1tnvANXnOgqaO2h4E6B9XnZ8SJgdz5ejpYQFxET9diCdDqw3/nfTf9AwbNqjG3Clh4um/3hcQRA3ib7VjdtAjsTBae2e+fAkiOrbcxsGM7P1oCsjKsyaZmF29YJI9fw9UjdXBmzY7n97ERowvLo1Hhkt6ntSP+N0RcfqwbKVS/HblBpUzA0ZvMLCEFo781HBDeji9s+683+3AOeST1Fww6Y3UmttFxDP5fug+N3db9GF+xl3t8fDsvCUxlhN2C+6RP4si/r1IMCb369HLpn+aJxIkCSkyNs/p8Bn/z0mGji1+XMERGVE8L0wG3phhfs4iXkMD2dEntdtCvX8BhFwRc12nNs69nViChx5pCgeCy/RVzfOH09FnJBks1rAYSqwHUYoW06UsZV8UAUrlOStJiQW0Jw7BtvbToyxtL99BxD7Z/H0ZwUsDx/3m678S890/pRt0rogZUmJEKDl5bEHHF5uEwnhV6ah7M76cKM89XvC8n+485r9n6lw371CkU7xhNCSpKuImVRfEPEg7jBdiOFTV0uNwxWDRdu2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR13MB6037.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39840400004)(376002)(396003)(451199015)(478600001)(52116002)(6486002)(6512007)(9686003)(6506007)(6666004)(2906002)(26005)(8936002)(53546011)(316002)(41300700001)(5660300002)(7416002)(66946007)(6916009)(7406005)(4326008)(66556008)(66476007)(8676002)(38100700002)(186003)(38350700002)(86362001)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+q3sNeG7ICGrdWyTiPIYw2pw5O6FxNOCfajs6uikLmH+OIR9K9K7bkvO1Z?=
 =?iso-8859-1?Q?JZegmjl54H//vV6qw3k54KwWsdoYOIlZM7zXABI2Xiksel2Miq4wDmleFn?=
 =?iso-8859-1?Q?N+c36ssboenBeexUnv9I4sJ9tkqoyAh4nVhqfnZqLQp41J2n37UBRS6vP2?=
 =?iso-8859-1?Q?Og0K/asxl5qPiSABgVVmj2bzrP+8c0ZPZXxj4pP39dRqvmYbSBk7N7oALw?=
 =?iso-8859-1?Q?GzFrx8wTaP/5O97y+SgSIBYSo4yu32DWZp6zpkXDYBGvkDfbAmKeRPTLWg?=
 =?iso-8859-1?Q?ZAlIg0fstzIoQRxofGAoRwa0ozP5by/f5/PmpCuDyomGDa0AnxPadnZ2VH?=
 =?iso-8859-1?Q?UBRDRF5FP5yizMJG54h5OQLUjXPzwJ8+ZW8zNxymncWFYWxgZUBVf76ElD?=
 =?iso-8859-1?Q?MdlwIwGOBRKSeTJW1J0YalfLUTtvIHA0Yk9iqsxiCG2AEq+gsI/MED1IgR?=
 =?iso-8859-1?Q?THLB+jgdsHdfGR8wZnIM9SZzfcaZ0hNbIPzYaqP+ZFzkbaYbLfCp38G0nV?=
 =?iso-8859-1?Q?xA5uH1Trha5iCvR5ymCf9fjMvlEccmEqaxqGEU0cf9KWWLq+dBXbC85aYw?=
 =?iso-8859-1?Q?2Tau5EOkZw+f1VvsntPZgwFLmWK5Rkvp2CLO/yv4nSCErDeH6xCFrKsBkX?=
 =?iso-8859-1?Q?juE9YoCHOTDjkFCSe4zlrzm4xUYIVbl9R4JS/1mT8DY0NHaXOGK8jVxNbW?=
 =?iso-8859-1?Q?v8vSE5qXcy2U+s5/XXZI2vxdHcPmG3EXOIpLtsnTQLQmuDxMLJnj2JdqvU?=
 =?iso-8859-1?Q?GyctlF/MO2zI61xMFuzH+XpsPHgiPcFiaIZw7wAsSaENl6G0tGCyQGmzU2?=
 =?iso-8859-1?Q?GK1iDY5w9tcLe4CfRsw/PQrx2cHw4PJMntGR/6FxGQ9XduudWybLe7QFPw?=
 =?iso-8859-1?Q?o2r4mhg9wF7/piGBGvKK+E7/pu76YZOI/h3XT5X3RMgNZBSFtdIl5/DeMP?=
 =?iso-8859-1?Q?XrI/hWiPmcsrCNnmUq/j/TA40VM9LwvDXLfLmfCdsmxAeEQMj4Bxlq5Jiq?=
 =?iso-8859-1?Q?GA1KQNXI5ZpVODD/ekWwI8GnRlFv/mApR6PSXZmD6Lw0Rew1Tvj6ZZz4q1?=
 =?iso-8859-1?Q?CXlg6U1Bt+Tm613NAvwcfRHB7T+mHFYEL4oruWaVOdhghkFewZ/+sjQnwr?=
 =?iso-8859-1?Q?47u9MoSGp4cBj5BZifHMVtH/Z35MwBDLsGuROMdH9cQU/AsNSVfatlj/lB?=
 =?iso-8859-1?Q?2ZJXbHJ29qMTxNTOADTuMFZmEaNHjm7mrx/UL6TMVy2QNoRUB0ZiLDTzgS?=
 =?iso-8859-1?Q?HEZ0ipwDUZ2pQuhoe161Buc1Vn91/PivX2XXIfqNuEiAND59gnbgZ2RcMF?=
 =?iso-8859-1?Q?GijGWH+Lc4RpAKdYODxek8Grd///iEjyeLn9UGUA+zZxhnyqNStkIT66qK?=
 =?iso-8859-1?Q?6nv6p2FNv72H5dj4mWiI14rhOsdgMy3vIUUQpMDma0DsvsfDkisPje+pM5?=
 =?iso-8859-1?Q?4qxbgP+ax8zd/b8ZTX8d+1CEZjvbHRzdubmEADtzcJz7pnTqWbBV0+Mvgd?=
 =?iso-8859-1?Q?Bhey2IcOz8ovV3GbgZocOcvXLnHZUy9Qr64yLm/hkHjdznQLo7BzMYZfQF?=
 =?iso-8859-1?Q?Q8O5Iju+sfYGauf5drI9bvHEY6O70sDOgCCYe5RRlpfsie0ke7vGFGRgBa?=
 =?iso-8859-1?Q?KEi/sMDGRVJL9y2A5VQWzOTVAIuRPbat02mhNApMCmkDiJic2xNR75+A?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2bbde9f-a473-47b3-031b-08daf93124c9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR13MB6037.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 08:51:09.4556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8UVxIGA7uXee0xu4r9bCkl6/pNtPzstziV1/OtXoxoPM7UR8L+jTsTcQYcyohVo3VNnjFO3Uzyc+CRvGtRdVQZGvMlrosn4lh+pxiTeSCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4049
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On 2023-01-18 00:45:44 +0100, Lorenzo Bianconi wrote:
> > Hi Lorenzo and Marek,
> > 
> > Thanks for your work.
> > 
> > On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
> > 
> > [...]
> > 
> > > 
> > > Turn 'hw-offload' feature flag on for:
> > >  - netronome (nfp)
> > >  - netdevsim.
> > 
> > Is there a definition of the 'hw-offload' written down somewhere? From 
> > reading this series I take it is the ability to offload a BPF program?  
> 
> correct
> 
> > It would also be interesting to read documentation for the other flags 
> > added in this series.
> 
> maybe we can add definitions in Documentation/netlink/specs/netdev.yaml?
> 
> > 
> > [...]
> > 
> > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c 
> > > b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > index 18fc9971f1c8..5a8ddeaff74d 100644
> > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > > @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
> > >  	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
> > >  	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
> > >  
> > > +	nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
> > > +				      NETDEV_XDP_ACT_HW_OFFLOAD;
> > 
> > If my assumption about the 'hw-offload' flag above is correct I think 
> > NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmware 
> > flavor is in use.
> > 
> >     nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC;
> > 
> >     if (nn->app->type->id == NFP_APP_BPF_NIC)
> >         nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_HW_OFFLOAD;
> 
> ack, I will fix it.

Thanks. I have just been informed from Yinjun Zhang that this check is 
not enough as this function is reused for VF where nn->app is not set. I 
think a better check would be

    if (nn->app && nn->app->type->id == NFP_APP_BPF_NIC)

Yinjun also informed me that you can make this code a bit neater by,

    s/nn->dp.netdev->xdp_features/netdev->xdp_features/

Thanks again for your work.

> 
> > 
> > > +
> > >  	/* Finalise the netdev setup */
> > >  	switch (nn->dp.ops->version) {
> > >  	case NFP_NFD_VER_NFD3:
> > >  		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
> > > +		nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > >  		break;
> > >  	case NFP_NFD_VER_NFDK:
> > >  		netdev->netdev_ops = &nfp_nfdk_netdev_ops;
> > 
> > This is also a wrinkle I would like to understand. Currently NFP support 
> > zero-copy on NFD3, but not for offloaded BPF programs. But with the BPF 
> > firmware flavor running the device can still support zero-copy for 
> > non-offloaded programs.
> > 
> > Is it a problem that the driver advertises support for both 
> > hardware-offload _and_ zero-copy at the same time, even if they can't be 
> > used together but separately?
> 
> xdp_features should export NIC supported features in the current
> configuration and it is expected they can be used concurrently.
> 
> Regards,
> Lorenzo
> 
> > 
> > -- 
> > Kind Regards,
> > Niklas Söderlund



-- 
Kind Regards,
Niklas Söderlund
