Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B00686E59
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBASrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBASrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:47:01 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36D76D5E1
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:46:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKwSILCN3jN/ULCuk6Sw+AS7FrBZuYV0o7jTdg1KzDk/5WYCyhd5923J6aAtFM/MN9IDEsWTev5Vk1vpzMyclJrKOHvr8TwHdISdpNpuYgveD3hnB47bGVcSnqsvOGiiEsBYUq7qCGxhhGKGzKW0GhGK2NX5G1dF0epa1x+uwndaYp31+2Tc1jaEDvr38kXKKlp8Si/CEGCHORP5bueuNtVFZOmQcYsNwBOg1u+MMEhz/O+jitOQGRzWdeogDtZnsa5VX0IYp+/qcErv7UMX4bN7UvFztfpMPGv7Z4wk1TQtjHPsgM0Npq/BpvDwECEqG/Ii0BgJG1GKKBQ3/gQ70g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyBGLH/PYI5mhQJrtG3KAYDhCj1hudvqVxdd1RaxkMk=;
 b=TcCK4vbgbcnKanAEtokTZLyNjwpbgoE7MjML9UUN0+WsxZjGS8SysZB00L1jdBhzZO+2kTCn31fD4uvr4HLoQGQ0cIURTGfSz1DwpQjLQ4uw3suRyhiDFeJHj2un74Aat3/ILeT5B8w2cGNde2hra1h8BljyPT/X7u5hlKaFId/rDO63Hq38MAfkrVj4K2vqaVR7F4TnT745i7+9ZoN7Oj4qL6PDFwgEmKUv2HogX/8ep+ma7g9+DgqxXCarFmnTduNXzufQTQzUewDzyKG4FSsJwcFV/SO4kTnv+AV187m+czMGOIoqCyp+VILHPIB4z9yC6ED3rf2oc/6ezTwodA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyBGLH/PYI5mhQJrtG3KAYDhCj1hudvqVxdd1RaxkMk=;
 b=A/afH7fNevoq1OYpdFTiEbUcOi7H166i74gk/RrvBBABeh07kXKfzShfAaQufjIwDoca0dOFp+xH3uv3Rg+uIvYMV4C9LXmn0dU61VhZzbooJPGwdwh4TPYzBXU/43gty75NqQyHseHyhyrnyztjDZiWfjtl/uNPUVfJmKfIuSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 18:46:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 18:46:57 +0000
Date:   Wed, 1 Feb 2023 20:46:52 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
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
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 04/15] net: enetc: ensure we always have a
 minimum number of TXQs for stack
Message-ID: <20230201184652.fvlb6kgwcnfwknxh@skbuf>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-5-vladimir.oltean@nxp.com>
 <Y9pskMNnHKFAROIl@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9pskMNnHKFAROIl@corigine.com>
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8397:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cd7390-8d51-4f85-df8c-08db0484b167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SAbLYUik1RjLDu4UzR1slJEWdrSE4I7qXkdmaAXnz+gbHR+y6kwGoWXSTvS1Rd0zP0QfwbpLGb5unE8ycDWMdLgazgjfgPGXkB217H00bw3q/8zZ3PG32UPaP7qlXPIiJItM+StNhaVsNv6SvowvpibooG4iL8L1cEZLqtg96+4v/jLnRtdgcX/HgA251jC2dpcceJND/TcrYMYpL+4ACnMgrtOxQNOhqRHzTQ5L4ZzqbHOwXX2uoj5y4/6eO2Je8Hpda+TEtL2oYXBt51PmQpV9gSjI5mj2JXinWnsMKdARIPrNQvTfwkS5AhCS48FRM/aIxZSn566B21fYQk5UpPDFyLqffu/6nbaZ4ewxoDS7nbPMavAZY1pRWDMtWipjqv5QfeVrjvLDuDdV42Snk2yEJ03c/8Cd5mNH6dWTIwuIOTElicqIEv1uGyjcDVQl4IekCoU6+9BbxBdJ9zNpQfXSVEpc+IaF4h2dR9/+j1yvmz2RLViufKLFFTVUIW9D9woyWnUQPEqOuUqx1eZglqpEqfrGDuCHMuC3VRZcg5mPWiA/3kV0KiM5oRkVTcdZnx11cV40zGYTFDTv97fUJfslJ3nALcDXcliBKf5zjPsxkTMQDok4n38Nxt5/ndeKWPyqcurEoQDu0/MtedHA8QJIxSnQRv+GkItA3ZNiYxf7LnQSznUBl4Kf+sp30hzv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199018)(66946007)(83380400001)(6916009)(66476007)(4326008)(33716001)(8676002)(41300700001)(8936002)(66556008)(6506007)(186003)(38100700002)(7416002)(54906003)(5660300002)(316002)(9686003)(6486002)(44832011)(6512007)(1076003)(478600001)(2906002)(86362001)(26005)(6666004)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?osxOy4bD5sXDS+dAXInQ4XbPX8uxACgi1V9SuwTyzmWWm5gWoK0sNDHi8KLw?=
 =?us-ascii?Q?Gm7Uam0ZqRooN9OcUPFNzFrwbrT8Zz+w53DGN/q751kCDtwutTCkFH2/N2xm?=
 =?us-ascii?Q?aR1vHyEzNphabY8Bl+HoJrVKyIsesifj3vDwclL2zjKLMT+HyRyN4c3rqIHR?=
 =?us-ascii?Q?xqlTjvA9XupRqU5dbsnfPSNMPMltWtWCCBbvVocGGgQpdWfHgr39et/IxSPG?=
 =?us-ascii?Q?+b9420nYSVVgr2a4koDHLzd0wJ+ts55J7TH3bEtK/rZJWeiQOYk4SKyT00xc?=
 =?us-ascii?Q?3uFCRAcvx+nSS7YwCJykDTULNUyX8waPxX7hZCjZQmdFMZXPnTRZoAAtULo0?=
 =?us-ascii?Q?fUkrm41Wur5qmzObNO73EmlYJBCHx70aPsIcFr5VXwXEHfwF4SU4HcilR5VF?=
 =?us-ascii?Q?lUOzummIYycMyFIERaFvpSGrIqLr49gghzt0GocwJV+5Zuk1NEhxcvBZDxDN?=
 =?us-ascii?Q?JsAWv9sPLUfHfMyWJvqnaeXW/VZpgQ8TaBZj3yxm5pfN39qFGSiDEWg5bEJ+?=
 =?us-ascii?Q?wEDlNky0irHZFXms0VBA+eI4QyVGYIP3sUO906kNx+Jrbq5V9+zzPhh0+MRT?=
 =?us-ascii?Q?jHPVMfGfczjGOudJQ8wM6bGC1885EwbEQxanLxR7Nj0N46K9jxhFJDas9A6K?=
 =?us-ascii?Q?hhUCR6yTTEJU0J6P6dH8sluXxbkhgzdZh+PVKSx1XnCXrjqfD3ZqXwCNhILf?=
 =?us-ascii?Q?I7w0qV3XbYTT50TXajYCKQmnK7hpU863lAQu+pFMO2EucATHeeF72iqV4IHA?=
 =?us-ascii?Q?UpDkIFACRrGorV32QxXZKdekHLm+ltvHuY574M2toWb8/MzBrOcNGnAEVYIq?=
 =?us-ascii?Q?FV2PCuCfjmQmMzGANA5ZrPC19vWeO0Qc+PITV8F35wr7Ul5zenQMFTWsgUR3?=
 =?us-ascii?Q?2soI45NWhz9BwDWK3E/dJviLSG4QDOnWFpWxpzmxTbRVGnOfRjjMLkrW2BBh?=
 =?us-ascii?Q?zqvXrwLVQD8j9bci/NKvh+GGIVPHQnE5POviA6eHI1HQ4lt2OEAw/UhVNX/c?=
 =?us-ascii?Q?8tS+8ADPacMN+uaH7zMay47Dcx8uDQpV0so1Jd3syVRSsqv8BcVc1+LpZApt?=
 =?us-ascii?Q?bJHnlhL3Vi8r5OiMqGuHCORe+247JFYHOu1JLzzFwigpMRMgoetF3PKG81du?=
 =?us-ascii?Q?HiS7GPNjlS5htual8r23YGAPGJCznEmeDvQ56sCDfAneVEjKuCDV6jNLAdI+?=
 =?us-ascii?Q?utP8J4efm74bPwPS46LGMKD8q01ZG41fc/UqoZ2IOyuW6LW/YGrKChrdsjmG?=
 =?us-ascii?Q?09PEQE/PI2+QnRjkDwjX043bJZbRDPBeC/cimukMsgpOqa86IJpenJ+m9QiG?=
 =?us-ascii?Q?KtM0w29NwXwV0718h9DwdEK96ojwDuIrW+dM80QeRRnA85So+cVyWeM44OCd?=
 =?us-ascii?Q?/jnnx7exKTZpGu3Qvr2LUI6IlET/74BSHmpWXvw4CMjhtzp/8Bq9zkzPdSJB?=
 =?us-ascii?Q?d64X6WrBEvZdWm9x46xxbcjTHWudqQQ/IpjMdV9ZIennyVFqtjasqxZlVQ4I?=
 =?us-ascii?Q?SKacW3eKgj0oI9y+tnMdiD2v7TtYFBE5mFd8DPZko9SZQLJHHMRXIAv/5zJp?=
 =?us-ascii?Q?grRGofoMRuznLUqM03n6o+HTbS+han7ehdlsLFNjbbD1GDAeNoVMWhSHL4Qe?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cd7390-8d51-4f85-df8c-08db0484b167
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 18:46:57.1000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPQj58OnWhH0tGVDW5GfPbZvBgk+Mp0kB0cyA4Qck6Srax5Zq4NWnlgfAzh7N52oA7y8EdDo/tMq+fPxyN41EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8397
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Wed, Feb 01, 2023 at 02:43:44PM +0100, Simon Horman wrote:
> The nit below notwithstanding,
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I appreciate your time to review this patch set.

> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> > index 1fe8dfd6b6d4..e21d096c5a90 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> > @@ -369,6 +369,9 @@ struct enetc_ndev_priv {
> >  
> >  	struct psfp_cap psfp_cap;
> >  
> > +	/* Minimum number of TX queues required by the network stack */
> > +	unsigned int min_num_stack_tx_queues;
> > +
> 
> It is probably not important.
> But I do notice there are several holes in struct enetc_ndev_priv
> that would fit this field.

This is true. However, this patch was written taking pahole into
consideration, and one new field can only fill a single hole :)

Before:

pahole -C enetc_ndev_priv $KBUILD_OUTPUT/drivers/net/ethernet/freescale/enetc/enetc.o
struct enetc_ndev_priv {
        struct net_device *        ndev;                 /*     0     8 */
        struct device *            dev;                  /*     8     8 */
        struct enetc_si *          si;                   /*    16     8 */
        int                        bdr_int_num;          /*    24     4 */

        /* XXX 4 bytes hole, try to pack */

        struct enetc_int_vector *  int_vector[2];        /*    32    16 */
        u16                        num_rx_rings;         /*    48     2 */
        u16                        num_tx_rings;         /*    50     2 */
        u16                        rx_bd_count;          /*    52     2 */
        u16                        tx_bd_count;          /*    54     2 */
        u16                        msg_enable;           /*    56     2 */

        /* XXX 2 bytes hole, try to pack */

        enum enetc_active_offloads active_offloads;      /*    60     4 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u32                        speed;                /*    64     4 */

        /* XXX 4 bytes hole, try to pack */

        struct enetc_bdr * *       xdp_tx_ring;          /*    72     8 */
        struct enetc_bdr *         tx_ring[16];          /*    80   128 */
        /* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
        struct enetc_bdr *         rx_ring[16];          /*   208   128 */
        /* --- cacheline 5 boundary (320 bytes) was 16 bytes ago --- */
        const struct enetc_bdr_resource  * tx_res;       /*   336     8 */
        const struct enetc_bdr_resource  * rx_res;       /*   344     8 */
        struct enetc_cls_rule *    cls_rules;            /*   352     8 */
        struct psfp_cap            psfp_cap;             /*   360    20 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 6 boundary (384 bytes) --- */
        struct phylink *           phylink;              /*   384     8 */
        int                        ic_mode;              /*   392     4 */
        u32                        tx_ictt;              /*   396     4 */
        struct bpf_prog *          xdp_prog;             /*   400     8 */
        long unsigned int          flags;                /*   408     8 */
        struct work_struct         tx_onestep_tstamp;    /*   416     0 */

        /* XXX 32 bytes hole, try to pack */

        /* --- cacheline 7 boundary (448 bytes) --- */
        struct sk_buff_head        tx_skbs;              /*   448     0 */

        /* size: 472, cachelines: 8, members: 26 */
        /* sum members: 402, holes: 5, sum holes: 46 */
        /* padding: 24 */
        /* last cacheline: 24 bytes */
};

After:

struct enetc_ndev_priv {
        struct net_device *        ndev;                 /*     0     8 */
        struct device *            dev;                  /*     8     8 */
        struct enetc_si *          si;                   /*    16     8 */
        int                        bdr_int_num;          /*    24     4 */

        /* XXX 4 bytes hole, try to pack */

        struct enetc_int_vector *  int_vector[2];        /*    32    16 */
        u16                        num_rx_rings;         /*    48     2 */
        u16                        num_tx_rings;         /*    50     2 */
        u16                        rx_bd_count;          /*    52     2 */
        u16                        tx_bd_count;          /*    54     2 */
        u16                        msg_enable;           /*    56     2 */

        /* XXX 2 bytes hole, try to pack */

        enum enetc_active_offloads active_offloads;      /*    60     4 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u32                        speed;                /*    64     4 */

        /* XXX 4 bytes hole, try to pack */

        struct enetc_bdr * *       xdp_tx_ring;          /*    72     8 */
        struct enetc_bdr *         tx_ring[16];          /*    80   128 */
        /* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
        struct enetc_bdr *         rx_ring[16];          /*   208   128 */
        /* --- cacheline 5 boundary (320 bytes) was 16 bytes ago --- */
        const struct enetc_bdr_resource  * tx_res;       /*   336     8 */
        const struct enetc_bdr_resource  * rx_res;       /*   344     8 */
        struct enetc_cls_rule *    cls_rules;            /*   352     8 */
        struct psfp_cap            psfp_cap;             /*   360    20 */
        unsigned int               min_num_stack_tx_queues; /*   380     4 */
        /* --- cacheline 6 boundary (384 bytes) --- */
        struct phylink *           phylink;              /*   384     8 */
        int                        ic_mode;              /*   392     4 */
        u32                        tx_ictt;              /*   396     4 */
        struct bpf_prog *          xdp_prog;             /*   400     8 */
        long unsigned int          flags;                /*   408     8 */
        struct work_struct         tx_onestep_tstamp;    /*   416     0 */

        /* XXX 32 bytes hole, try to pack */

        /* --- cacheline 7 boundary (448 bytes) --- */
        struct sk_buff_head        tx_skbs;              /*   448     0 */

        /* size: 472, cachelines: 8, members: 27 */
        /* sum members: 406, holes: 4, sum holes: 42 */
        /* padding: 24 */
        /* last cacheline: 24 bytes */
};
