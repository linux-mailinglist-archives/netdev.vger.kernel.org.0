Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01352682C61
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjAaMP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjAaMP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:15:58 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BCD402CC
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:15:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+wHTjQSUDL/7O3Cn2XTIuGDYXkDbJ2W/vsqbUTLzglDjDJKXhi4/6gxWZfGISeUHHU5Q5t2R37N17EWLw+C6oCHGOp1Jiy2r8AtsaDKIbEmkRAvvsyIooZoBgeVKIjpsOotrDGk8ELdPdEyW2yCSUnpiUJXrX9XdFKSgTI1U7gvYU5ybqBKhbDSrtKJ46Ob61U9apIs8Bnu9TyxweM9QwKqoHdZxmuE3/eiPPWbaE8y/BBpUO7ivjLT0ReuxcyXrvLYO/vLNedWQkUW+H3Vre/jtdQ1Q2DO7JB0auOAae6yTkaYQ+FIT5rpSiMQ8GQJJ5Sn9KQrAiLJsen+YyBKLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFFoCEKH5FU1c2EV5mtCvLpRxpIsuGAmg9OZBb9b9Ng=;
 b=JzgdLujSMUIcvZixDTfpzD4ra5oc30tA7KKY+MoacT8vkwP/FR/BCOF1TAhSk1R1c+35jpRASE/ogZn2tFvNB0kc7jVfYhd0AbwAZ3Bsex9ZHeXlrExONUyv02R8/Go73X4AI0hYgeOFFF55sG8H3gBMctOpog7WaocWcugsqxkdhFl9fLbSh56VoPphS/B2gGgII1PthDUs38U9XPnhAxio/NeAuHLg+fqb51cSdzx2I489OxeB3ihlaJ8n3X3fxvQkhp3fwkx21yEqlPij2aJzViS1ibq8/Bg22bObtojpwLhP2/6B5H7qgv/8zqyUFJIak1H62j2kB5cwOim7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFFoCEKH5FU1c2EV5mtCvLpRxpIsuGAmg9OZBb9b9Ng=;
 b=EB7FHBUJYtxa1QVCbCY022iWFlaUqixLyboS5Jwxxg34PFwqLzthkBAQnh75+cvfyA1nXvsTVP75YPGkg6HYkbV664vktRhsAXwBk90irvsWEqC+XUpJ9kO1nRYzIN5tnHkmluCc6dfvAP12Wv6/hrdrrUAukENO3oVPbnKQnqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6059.namprd13.prod.outlook.com (2603:10b6:510:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 12:15:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:15:53 +0000
Date:   Tue, 31 Jan 2023 13:15:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Message-ID: <Y9kGcnKUUO5HURZX@corigine.com>
References: <20230131080313.2076060-1-simon.horman@corigine.com>
 <Y9j/Rvi9CSYX2qSk@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9j/Rvi9CSYX2qSk@unreal>
X-ClientProxiedBy: AS4PR10CA0017.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: c250cb66-ee20-4010-383c-08db0384e5b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UaCy0QSL3yg1ckKzHB9nOVgTPDWfefIchSEaPuympXBD1o+6rwy+yl78kCEQuDVkpG8L9Jr8gAFCLe+E1mdEiVrQ4+nZNPZrIMbQlz+y4Wfpiam3IiiFEBTX/9cz7W/uTUycsbgQ/t3VtZFx1mC8FxxlMu41LwsbaHjlzvK5u+louvAJ0ryfO2GY2EdRRcNZxfx2b/OCBz9zoBkHTLCanQLjarnZeLpsmkEpVjmqJJdLpsdp6rHQ1qTkbqY39fpLhVTusfidhp7HHSMBWNVe4x/UV2ZCQvzo91agKdYZuFZ+JJjdtwVY0WXI9RvF4/KdIYo4t1J9+Nr+Uck0Osn/3yEicrjYGGMMzPU5JyFxqC0er296M68Xq1MvBn6rph6aZsM+QE64BRapV3t45aj3K1itshSKosND09E2eezch1VpmzTzlsJge7Gt+nOSOGMoHE+1M8o0kG9pRUAa+WUBucBQUG4FCtuH3esB6EHkUcGDLwFnHXdR2/noNuI3fxGBRazQKaP4L1GSqy8l7gQEdbHGO3DzGL/Cgm1P0fqmVR3EY38XLB2gz4uEtIrEYv+gvWHRDdaJNCJ70pUfc4+GoCuzMIu7SYpPPLGsVA8v9woKaZ3/0T3frW7GOajM39HZifOdqmZxi5aOdLdbdyzujA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39840400004)(366004)(396003)(136003)(451199018)(186003)(478600001)(2616005)(6512007)(66946007)(6486002)(6916009)(2906002)(54906003)(4326008)(83380400001)(6666004)(6506007)(316002)(66476007)(66556008)(41300700001)(5660300002)(44832011)(8936002)(8676002)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?918kZ1TgFEQX0tkVZscNTAUKeUl3N7jkzUCSI4DkEVLYnZRxf6PU6SaZCW2C?=
 =?us-ascii?Q?KFRYyCnIRm4IUT2VHKZu/f6X4x5q9aLJTFwFwtqOarKk/a4HkM0W0f170ui5?=
 =?us-ascii?Q?3G81KLiPOgDegINpsQXWUsB2NZDRHD9Mcl1njVMtBzUQ/K86uOfzvFHTQ6l9?=
 =?us-ascii?Q?eF7S6rqUEWKQ2G/L2q161898EyPhwKFQClHdMXHGEUqryF4bwb4uGQbu+mU8?=
 =?us-ascii?Q?yN0DbpOYvAnUvA+tPDo3V33DHeWsoveb/PPvI/hRKEY9BiKbPt6SMuFe3obT?=
 =?us-ascii?Q?y5tYJLsKizUqFbUkRkDDUT1mYf0oihInpte8ZGInQlc7X7QCbOojypFRIdxq?=
 =?us-ascii?Q?yV4Y5jj07u2yT5bSW2kCUziUdFaS0QEKu0PFGy4hW41qLb3u9NlEW3rQOD2S?=
 =?us-ascii?Q?rTtBWQno1PD3wCpYFbUz2JmlyXlsL3VamEJ89XuQZX8UyyjckXHHf+JVVbE9?=
 =?us-ascii?Q?EwGCBgRwMBeo5UAJ/JDMHyYkHvvW9cDcfPyrWdukdrov62CGDsEEJCbLfYZ7?=
 =?us-ascii?Q?he42IGuSSzPilPqn0gXDxZy/t+jWNxGGhI+GjwNVCN5uLxJHiPU3MXuazC7E?=
 =?us-ascii?Q?vUnenz2KNaBegl8lMmuaYv+EOn4uzZHUHJFXuVCyycgDeOXtr+i9sjNF3bco?=
 =?us-ascii?Q?9XNohEMVj+N5+KClovEPPiF3yC6Yt8FpxNU3EpOu2vnNiD2JbjZSeADmx2s/?=
 =?us-ascii?Q?ejH1vnn5V/UwirK9dERTTYUz1CbIzUN4ZjbDxjNLP0VInx4gADYGyLk8FdIX?=
 =?us-ascii?Q?iroUOX6kavkaC2IHARxEVgP2tbJG+B6G5R1Co6WXqPyp+WmEr88sVALqND0+?=
 =?us-ascii?Q?Jdl+gW+78SHhgosBshYAsiDKWHzzOxliXAAOtywZn90XCigA2t4nvNlh/m2z?=
 =?us-ascii?Q?7i4hx6IA5r6Z9z5AFhKIRgXb+Isk7fYTK5SSCCs7J438Obt582Im2vPgzhJd?=
 =?us-ascii?Q?UzcPDldDO7a5N7SteCbebne8kUemhmQ21Umh/rsYqyDEfmTfGCziypXkZJE8?=
 =?us-ascii?Q?j3MHVtDQ6aDtRV/kKjw6ZzxlXr615kmwfLxZtH2aNtSBSVWt8IqhX0unFbOm?=
 =?us-ascii?Q?jfP6aQREaTCILMCEL3KBMBv4ki2THocsfIbboi8cXeWpPXZGubY6RrIibkMv?=
 =?us-ascii?Q?riDQDp39Vju7DAdmy3P6ApSFhsp8KfbNJ8mx0yjH8Nup5cK92JciJsnHEgZk?=
 =?us-ascii?Q?xYCZIDtsnADPSPDjGI8GU1aJJqTUAk/ffbpv65U9hDvuZ8bhgu0FLN0l4e6s?=
 =?us-ascii?Q?XcblI2w4dFO3yQfwxY7vyHjOsr77JdF2nNByUEIZ/zmGgGy1bjZD7VgO/I+o?=
 =?us-ascii?Q?2t+Sls4Uc7YbO6SyNOY07/lSCLatxbQ2OniwBXz66EgKqzNNF3P+lGIL23cH?=
 =?us-ascii?Q?4OUXhOUUIK9wGavscYwWZV/RI8hYcqn4r57p/ev8/oI5Vvp7o89sPpNxziYu?=
 =?us-ascii?Q?XO7YoDLnEJzrkbudhaGuLcyZWk6tyUIab40EbzpzMvETJd3I0v/A/ZezxD8B?=
 =?us-ascii?Q?aMkVKnOSR+TjZAR4g04ZKo6i48ITHBI4rpBPbxAku+R6SxlnF6xkKf9L4RYO?=
 =?us-ascii?Q?Rys1d+SRmulrYShsegxQ789bEcIbsL9UQY66wZQyn4a5TIOjH+b4Vlzy+Rjj?=
 =?us-ascii?Q?UkK4Z3V6KgWrmLtv5cbBmLhX5N0Hm2H6lwTqcu8dN+PVd6Cj+DO+EtrYFQxr?=
 =?us-ascii?Q?URv5pQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c250cb66-ee20-4010-383c-08db0384e5b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:15:52.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuedN0NdvMsqciruKbsyejUL8iI2W6Qh4Gqh3+/SJn6qT+SHHfYZSBTEC7Jddfq200mcTucAnUoYfQyVRqX9X2WLlLNvQ4WYH+FHBpt4gOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:45:10PM +0200, Leon Romanovsky wrote:
> On Tue, Jan 31, 2023 at 09:03:13AM +0100, Simon Horman wrote:
> > From: Yanguo Li <yanguo.li@corigine.com>
> > 
> > A mutex may sleep, which is not permitted in atomic context.
> > Avoid a case where this may arise by moving the to
> > nfp_flower_lag_get_info_from_netdev() in nfp_tun_write_neigh() spinlock.
> > 
> > Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > index a8678d5612ee..060a77f2265d 100644
> > --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > @@ -460,6 +460,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
> >  			    sizeof(struct nfp_tun_neigh_v4);
> >  	unsigned long cookie = (unsigned long)neigh;
> >  	struct nfp_flower_priv *priv = app->priv;
> > +	struct nfp_tun_neigh_lag lag_info;
> >  	struct nfp_neigh_entry *nn_entry;
> >  	u32 port_id;
> >  	u8 mtype;
> > @@ -468,6 +469,11 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
> >  	if (!port_id)
> >  		return;
> >  
> > +	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
> > +		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));
> 
> This memset can be removed if you initialize lag_info to zero.
> struct nfp_tun_neigh_lag lag_info = {};

Happy to change if that is preferred.
Is it preferred?

> Thanks
> 
> > +		nfp_flower_lag_get_info_from_netdev(app, netdev, &lag_info);
> > +	}
> > +
> >  	spin_lock_bh(&priv->predt_lock);
> >  	nn_entry = rhashtable_lookup_fast(&priv->neigh_table, &cookie,
> >  					  neigh_table_params);
> > @@ -515,7 +521,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
> >  		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
> >  
> >  		if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT)
> > -			nfp_flower_lag_get_info_from_netdev(app, netdev, lag);
> > +			memcpy(lag, &lag_info, sizeof(struct nfp_tun_neigh_lag));
> >  		common->port_id = cpu_to_be32(port_id);
> >  
> >  		if (rhashtable_insert_fast(&priv->neigh_table,
> > -- 
> > 2.30.2
> > 
