Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889756C21E4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCTTtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjCTTsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:48:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2110.outbound.protection.outlook.com [40.107.92.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DEB2D5D;
        Mon, 20 Mar 2023 12:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOJd4lrqi9bAwudglYefkzXTkCWV7JY+cwyAK7NYNnipVkNvUNLLNIYINwK5yQLG5JTAU6mTm7GOb/5k1EWLLcq+kcMuwko2XBPP3XJGg71RIUwv7Se92KKiSifT2Kl4FPPatGt9/1vuZDe+F61bTunE+vFCKYldbn2rTNR53DXmDlvLGjm5EcCBCD+gGpKBLvGXW4ny1S0KDAeDAPXROIYzestYOUcXfxkN6/+eSsibPVauMnOpCFU1nQlVofhoqLTtlEjCpGgy+6yHxuK7dulGvSnlXE1T3+zXd/32xr1awYeFOgSaUYdhO+zMuXb7FfoA1jRj1VNBej6BiqL5ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1SI/TSBVox1neoU3J2W8VdQJnClBtb1ObX83Gg6L9w=;
 b=eurwq7RJUYIpYTUTbSWHzBSVMpdc/NxdjsMrBq3WiaeSf+OGExKD8eMpfEjz6zb/wmTATO8hCPyRQqNmPztixbhEiIelH+pLqgzIsVaqh1v/R1lmNvNkve1cbSrvULglhSRhw0RTKbVqoiAlntwTNph1fxYlfoxgjvZWhI8hOpXCTfEOPaASiVQGBfCll5uzmnyuh5O/k0Uy5Hki4FLMecTQolb3oUDMBVocYmiqeqsviGXfB181WYuROR7JJW8PmDefo6rUQFUSuxrORaZmXn46YjgKcnDqzID7eKwaZF7CLmbnbDNE4UtBOugoPCnzPoKJZSpg21GyZrmDhMy7Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1SI/TSBVox1neoU3J2W8VdQJnClBtb1ObX83Gg6L9w=;
 b=XzFaawb0L1WZ9iC8QRLWzS4BzWJmm2MOy4Fwtp1h7YIkI0AVVScWJMqroZSrdNAV9rHbU7r97ua0VDB++qMN0ZGn6C6hwPS54Ocp1or2MHitvpIQrYJ/mObsQ2KdDpDKiD4xKUNAfyHF8KJNkHaJLrBBfRSGeq/vQwHUBBFygUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4627.namprd13.prod.outlook.com (2603:10b6:208:330::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:48:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:48:31 +0000
Date:   Mon, 20 Mar 2023 20:48:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mt76: mt7921: Replace fake flex-arrays with
 flexible-array members
Message-ID: <ZBi4hv5Q6lp2ooSV@corigine.com>
References: <ZBTUB/kJYQxq/6Cj@work>
 <ZBh0NhaNFnttWRz8@corigine.com>
 <ZBizeZ5DaBT5KKXN@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBizeZ5DaBT5KKXN@work>
X-ClientProxiedBy: AS4P195CA0022.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cb63400-79e4-4001-cb89-08db297c1529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9Xi44CizEqlz81eqWzDKHxwCCPTQG8WFPd+lK3orFn/S7A6e8qq28KRIXrp47Yc3iXLtbUOilGXZo0ku4O0ngVfYDLBRNl1gx6FiRuQ3jUeDwB/2WAtErft06LNG9ugdpPWaFBRNHIDqT3ONE3VGMuoiE31DJVlgKzE2CAxxws9qSI5WJVGU72N1gRIBRUNBf+d/Gucf1pdl1w8zQ/kGBDgS/2G6j5hoxtbc5XChawnEcLfebEh0HHnjtsKCiIPZ3CxM5l2gTbPYI5tbqODP+pJK1DzpfCVrgcFT5mK8FVqNuuj4G8XLuHRzLpCOpCPvk4KGF3VPcX+qnUKbzJa9t9qvrvGJ0vr7B2ImTLzSk1xhbz77vaRLzc67m7ZteiB96/iSJs+NAGL/1XjHm3oYko6X/5k1iRfeOTh/+B/JMm3OXQlU42nT44JWqWeXN9sBpYQE/AbOGh9fiiT0CIVCx+CX3/J3oSAAdGKSJN8hqhpfhCX/pB59pf9JMPsidkZyrZrKUXPjzBnBa2R89Ao8dclo1iGardRUxKTNfXh+0UR7j7q2y6+94h7KissvM5EDkGHc35Us5HspMOYuvoN3UnrXPGfC8ldL/skSptoK/3gNMh+Ykb1tzI9t1cqtoo7u+7p1R6N+4c4gthaeI39lw3NkaDoHnxpgEG0S7BjtGx7qeJWe7w+DPVpOyF4h1zZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(136003)(396003)(376002)(366004)(451199018)(2616005)(186003)(6486002)(4326008)(6666004)(478600001)(54906003)(316002)(66946007)(66476007)(6916009)(66556008)(6506007)(6512007)(8676002)(41300700001)(7416002)(44832011)(5660300002)(38100700002)(2906002)(86362001)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YAcB6ZOnkfPYruBa9aCaCPYg+QyV7MZXpPRJpRILMh+a4f+7DEmyN7pp8E3?=
 =?us-ascii?Q?fpjnOUZgeUd6wY92z+5NIglvwqX/dEiZwPOtTkgxcPKNhlx7tnY0Xm64VlCO?=
 =?us-ascii?Q?RH1Kz2WzYsw4WzoEHS6UUHd0al29J1yfdpKZv5T1F92YHmAIui+4FV8w0jgu?=
 =?us-ascii?Q?8WedqaOfSleLlsvU4+H3623guQSYvyq8+7qcXFkbAaeGl0+lKMndbCtk6Q7Y?=
 =?us-ascii?Q?LACtyFU372jRSVFDVomB/M9cG3+GatmJzpxYb6SylP6LetIdD0ODiZhIniM0?=
 =?us-ascii?Q?LljKUiSJ/zdCXT6Rfh6Bd14/B1QSDM2Hmn3Wb+GH/+4HqCgGmNypnhH+PEzP?=
 =?us-ascii?Q?7cxDyrH574gPN8cXjY0wCOhOx7Le2EeQna4djPvb9aY1vX/0/Gd9Rnzmu0oc?=
 =?us-ascii?Q?CSkruVRBYWiZKf3FA4IsWGoaPcUt0Tc6qohg8BOwLSnHMkEyy1hYwP5R4he5?=
 =?us-ascii?Q?Bcr4ArqFlf9HytyEcdfpqpqMtorEPrwPPZpkrE0hGc8T4uu0/L1r2Hn96CDO?=
 =?us-ascii?Q?oa6iKq2f0ayp5edkKCtpmYPIGTs0eIJHXHC8UyS1bzadQ0/Vxpbcm878oM+B?=
 =?us-ascii?Q?Ixl/W1b2oc+k+yYVUVNf3eCsQ2MhzLqVvAEeIkzixOzHz/fm1KTZnDJj0+P1?=
 =?us-ascii?Q?hQhnyMukH/lnrZ1JMh1hq+WfcD+KY3gdL8fH17l7aQ1OdotlbhtCEaZBXd+F?=
 =?us-ascii?Q?BAKMtJb4hBigfoyAYU1KzUL4VU58BdbGAs6nP20uNhio8wqu16KWb4AfOPZ/?=
 =?us-ascii?Q?8zSDAB68HusESWgYRPuZPRGA0DFOSIa3Ac56RuG/25rT8Tpbnx8cc6bLePEc?=
 =?us-ascii?Q?MQGR1BcAirGCbEBnRAX3g83lQZfD8CkMYQTx3sqimgdKgl3H23E4AOassWlV?=
 =?us-ascii?Q?lwi+VD7Vs1LZ6y1DQZZJP2NUBg7Ib8H6gApULdmC4I6t/4zo2qjeqQPK/29U?=
 =?us-ascii?Q?awoQ+TT6UJmgOWZ+wknvaYO8AziA+6zwrylNItl+vGgM6bd4VfK56qWwvq6K?=
 =?us-ascii?Q?TNAs3tdkLcgyH9dScyCcouf7DU5Ab8YbSknoGsdZ4KBFAVLZqTnIrhlPlEsM?=
 =?us-ascii?Q?nWfB89HW9gS9BtADY1it6zjcifyJGxcXDvSti9DRvScaooi5LkHjxzzL3H+G?=
 =?us-ascii?Q?Ptuc2HjsBoE/B7Sxi7DUVKlCm4AVFw6ECpdKvTnfIU9sZ8nWw27zVrjTvZLI?=
 =?us-ascii?Q?nA/g06X192j+kd8fT7N33CjLtxnBF3LCdMu8OfLKC7mC+5Iz1Zfg1hKGcvJU?=
 =?us-ascii?Q?Ya3jVjS3fRegw+vnxNYGfTc/HWjmdPE6SgJZzpF4xPC8v+e57Jr0y0Fjr6ng?=
 =?us-ascii?Q?N/ZQp3os5cOw7LnWdCEi4X4HWzhfAynn/UMF6EYB8a1lBHI8F3zQYGHG+8Rr?=
 =?us-ascii?Q?3Wu3BSiRKzROxQUQSqsnJ6lw8TCvEsjgq0kEYCpKQVLgfWrb68otZNVhkeR6?=
 =?us-ascii?Q?nF9HxK84U4qwMCIeSM3x6fmzdG1zN2EnFk7gz7zO5hh6Oblkgj4jrn0e7WBE?=
 =?us-ascii?Q?XKKQpnVlCEpDeH0zQ8uEbyCYv3pu2iqBkOh4UfS3DxDqhjWNNDHo5Y6a1Svt?=
 =?us-ascii?Q?Ka0B5ye5ErUfGW6L/iPQezhH8UmZnPLc9rgqdGN+Uqp32mior3gEnFtu8K/l?=
 =?us-ascii?Q?SyW0hBjkTzK+UMVuWFV26vBKN0K/uhLcxF5Fxavb4j5RP3Genol+oEBW0iRY?=
 =?us-ascii?Q?mYs/Jg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb63400-79e4-4001-cb89-08db297c1529
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:48:31.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xG4DCZOyCEl4zpGVduOPChKpSpevOvrhdzlzS2/D/LZgdtz1NCvRSjDPGe4QRIUsAp7SSEfLN3zgELcV6T2VKY7AV0ZopOp9G8P6QWT+rWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 01:26:49PM -0600, Gustavo A. R. Silva wrote:
> On Mon, Mar 20, 2023 at 03:56:54PM +0100, Simon Horman wrote:
> > >  struct mt7921_asar_cl {
> > > @@ -85,7 +85,7 @@ struct mt7921_asar_fg {
> > >  	u8 rsvd;
> > >  	u8 nr_flag;
> > >  	u8 rsvd1;
> > > -	u8 flag[0];
> > > +	u8 flag[];
> > 
> > I am curious to know why DECLARE_FLEX_ARRAY isn't used here.
> 
> In contrast to the other structs, there is no object of type struct
> mt7921_asar_fg declared in a union:
> 
>  91 struct mt7921_acpi_sar {
>  92         u8 ver;
>  93         union {
>  94                 struct mt7921_asar_dyn *dyn;
>  95                 struct mt7921_asar_dyn_v2 *dyn_v2;
>  96         };
>  97         union {
>  98                 struct mt7921_asar_geo *geo;
>  99                 struct mt7921_asar_geo_v2 *geo_v2;
> 100         };
> 101         struct mt7921_asar_cl *countrylist;
> 102         struct mt7921_asar_fg *fg;
> 103 };
> 
> The DECLARE_FLEX_ARRAY() helper was created to declare flex-array members
> in unions or alone in structs[1].

Thanks for the clarification, much appreciated.

FWIIW, with this information I'm happy with this patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

