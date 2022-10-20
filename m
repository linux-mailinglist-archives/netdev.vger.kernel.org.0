Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD6605512
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJTBga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiJTBg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:36:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9981D345F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 18:36:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZVFg3n9qKP+9SbGklzqaAfIpspLUYBaGTbJtzZ1I3Ph4yMaIGlrrAKHAWS/4bsgbv/C/F/+k3pwL04wUwN7+Jkt7J1g58tLeLRFjc5H+vi57UHHLcd/imoSJuck1phlpucbYeWa74EAx9AOhM3zmEVaf6AeTFr2bt/mKjpwqWkqUiS3e0A85D+ZU0carmt9Kpn8vyq1qouVgRFKT4J/9bEgeSda8eoIvkm+erq+dlWR83nz9kmrQjo0R3HFald24hExGYnM1a5IVFBrLeX/alHoF9LfPVGyUuCB50LVhnwitGvIZbmKfCgoIITSTeQtODushNNxHpvWnHJnrC2cnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2ymToaAg03xQNevjPTbFItcVgb4UwpWIGYxbn2Pay4=;
 b=Qujumy4Rdy0w3J7qXoiuRwYYS7TVHvk6JgxvDpppyihsEkdidEn2m8MlnxRuEaCcjsA0mRfBOp25DiT+qOSBRThKfbQpTTvdyc0cVadzEDraQIVCA0hsv9W14RYJio4tjTuAhiII25DhWZ9NQTVT5cbqqFHRxdDIYKEC+tZdOOpWOBt33126jXlMPhNmCHFMM/lW/txs2MiVHfcVFplV/aOjqE5E6bYdq25MW/oP4SWPfaTAac7nKzcBEKBuTxJDtZZTewazq66S9XUamOl7+EDN1Q18LHaoLyumMyvWJ3dhKh3LKJm0t45yWLK9s9epS7t55C2WR1UKAlqWBY4M+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2ymToaAg03xQNevjPTbFItcVgb4UwpWIGYxbn2Pay4=;
 b=EfSPnTPPd+6Dl10sZxPWUxyXUVK8Ijk43v3w/2EpmMf1r/o9pNcrAYTzjOpruAnTzxLQraGEp9yL10irftGxoCQIGeOV9PnwsyHoZ63Kgh6+KnT6kntdFZS3IG884X66xaF5X3OGgEvSNrOUxcdLD13qcrnuiYF7pY2uKgpRaXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SA1PR13MB4911.namprd13.prod.outlook.com (2603:10b6:806:1a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 01:35:34 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5723.020; Thu, 20 Oct 2022
 01:35:34 +0000
Date:   Thu, 20 Oct 2022 09:35:24 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Message-ID: <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019180106.6c783d65@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SG2PR01CA0134.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::14) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|SA1PR13MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: b97980b2-1af1-4ba8-2360-08dab23b61e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6hMDRkhtCSSL6BbxhbAN9yi8RiGCfRdQv+Oxq5gX38SBA+25OzvEauWSe95OMp3k7Lxq0mRv+2M6OfxNNPxz0RBynH4093yfxmdh8EYttRgcnaMSquA8PzE5/zN6FymruxXdq+BH7RZyKeql59SkvXAvmj7OaXcH78T3IJADbQrnNwqMwmc9x3By9jVe3aqaCG3+l7VCcVgJ7oyIiWDp9J5EZfYkRNeUjMJN615qJZ3jwDUOpre6QxHNyyCBHvdRA7t/h9SWqCOUyEsBIFdrPTm0+9Bxs8800n0I+Drcw1BQqe82z/IGBW4VuUcFfRU/pL/V63kjhK/pvoYg9b+6SF8HOUad7HiMugVfPqa9WsBAgzA2TQAgCFkNM6iIxTCbyaXluyecQ9fUrdLS+tBc2DoyefFgFFOZVnHCZeFhsDoOjZk3Y8CfVF9uy7N3utpzip9ZCLp/kdHn0rtIEOMFiHOjWXry1zoi4TZn0TqNnqL/8suoTeRIMAhjBy7PTpVoDZWJMxsNwqAkRKYhASqCnMbMjC1vWB1LosRz9BSzx+J2kzLsUcyyr1DndOd33HMnK+CorJRJUTL9Oyz4x5hk3hNUF5RNkClh/bOG06E9kcOiHfYns3/pUQepbc1Iy9A5dX+KQ7ozlT/wY/cvkLZq8IT9PvcoWmYkIuwX54S65FgW81/vE6j5ytVCP9JlBh98AlAyRBBIbby9lHbqyEWAo6d23qnr9IdV3Vg5VNGpUmEXoDrUegPKAxjYIkcIvQNW7Zy00hdfKQVQelcyoy2WOr5TlzfQBvmz1iNOt+c57z8SxUifUPyEzsK1kIEu/OY97vyZy5nUgh56xQtHi2asMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(376002)(346002)(396003)(366004)(136003)(451199015)(316002)(8936002)(86362001)(5660300002)(1076003)(186003)(44832011)(4744005)(6512007)(4326008)(8676002)(6486002)(966005)(478600001)(6916009)(26005)(54906003)(7416002)(6506007)(33656002)(2906002)(66556008)(66476007)(66946007)(38100700002)(107886003)(38350700002)(41300700001)(6666004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JIyZm6vIzxYkPWNX1P2jVFuMmfLA1TBofLrdhKa9DkGHdCI5CEilXQYrA7YV?=
 =?us-ascii?Q?ocUNj57LcGEMTCL5MejxDAoQA/xjhXkWoj2j014m+pOPWAXBcwy+GnayCLLL?=
 =?us-ascii?Q?fKSG2UTNJKd0dS5u9H/M6JAbxtaXbWDLR5U1YavhxiKYAyFexG0n8y0/aD2w?=
 =?us-ascii?Q?N9Eco8qtT6HNifJIRqqvcwK0/QlCAGCY2VZPUx6fNiGnSU2dHBpLby5eNKfJ?=
 =?us-ascii?Q?oPEJOQYM78SEdsAdzAqqmT6E+KUNrgGjh2ie5M0729dcCjaBaU3iBAn/A5OS?=
 =?us-ascii?Q?91Vz5xuzDEvwlC00XAiQTAZM+sc8871M6EslETp3KS+x/+VB1AcmNWciyWLJ?=
 =?us-ascii?Q?XMtgF9P1e2I7VzgC8WPTd0rOsQSRck+kPPWrcIvPAgacp96JN6MV701cX7xR?=
 =?us-ascii?Q?NLnOOpV5Fr1PF/srfdfOfz1J4dGesc+27s2sCPovx6QjMmqLU1R0x9qQ/gC9?=
 =?us-ascii?Q?fyJH5NffN3z1SYEiSfWB1s9ltXdc+uxvUHsLokisIHIHV2ltT1yWYBK0Jkna?=
 =?us-ascii?Q?3ukVPlpwYyl3Hsz9boWZO1Z44KNkBNuoJ49HgLwnKI/JwZ8091FC5SdugJzh?=
 =?us-ascii?Q?PhBAI0YXrGRLzBWEf0Krhj3RGcWi3Q30bZVWyijg1szrjW0wC8eYO0EpFawq?=
 =?us-ascii?Q?pReUGnIqN5kGbKyXKz5Zpk+M0QKT+HnQLqufC92fLdtPocy69HjDg3mWi1po?=
 =?us-ascii?Q?RNbJ6if6e/v6We6RLl6oQRBZEzadG58Schv7x/TdFLvf0Z7FO/4ykbC16cK6?=
 =?us-ascii?Q?XWvWZAvSvM5epL7BiF/nlGSEXr6zPF2IoFFXchL34USjaL3s4+xwG4nqlWX1?=
 =?us-ascii?Q?4WySeJTEmrBa6cMmHfXT6TpAO3Si84MdB9yqXz5VWzy6WxWavShz037nzVeo?=
 =?us-ascii?Q?z8rG5W1VE1T88osxZ21RcN8Q1GFt6bTGDiQ0EeA+YNNzmDArLHrSNT5fTuTV?=
 =?us-ascii?Q?8Yebtq4oepjqBX989cWbsSSx0QhmdWBkCItPOuR7DxI4rc/HiNa6zipO1VM9?=
 =?us-ascii?Q?h0Ft7mzQXRpNC5AcmM+1S6B1TSTR94ldmEEcQzCbyaD03vlgNv4lArPHK3G3?=
 =?us-ascii?Q?JKJhVxYNbMbiC6bfhcOnc9P1dAX45W9qQpaw4/qyVYPRtBIQ2T7bakxPTsJD?=
 =?us-ascii?Q?WFSCeH6annJz8Ix8h+StxEsrVN4AmpmcIlZDenY94fjYHyp186bwxdVnjAHs?=
 =?us-ascii?Q?346jc3IvrG/L+2CzqzqvWaD9asxWiZq4sD7STnPhcj7GdW4cytOs1/ZZ6uem?=
 =?us-ascii?Q?8N5JZ5r8FnGiLBp4ppIuRVnRIFUEsECuPj/eMO/YnGqfg+Iwvd2TJ4umhBhb?=
 =?us-ascii?Q?Kp5Fiz+FWvnoPaPeLmBKTFfXWWTPVfb0D5PySYr/JuuItLDaI9pllFhdNnP3?=
 =?us-ascii?Q?dRxNA0vE1C463K43agU4+JLv7s94czg2MaQlRvsGT0cDL7EaNkB/n5JuhrRs?=
 =?us-ascii?Q?/dGNeSV6RXFvEleAYjwOtYiw+Td9kpI/J/1OVgaztMGTWPyvrdD8EALp2P97?=
 =?us-ascii?Q?LjvVC76bqthKzDD70yvXSfTcT3kmoF4xGi+f/R0wESuZI0AKz1NSlgKUIO6S?=
 =?us-ascii?Q?1M8xjr8yGr7wwTOLMFon6WrVH8bo0mYCWghrHksQ78YVsSE/YFIygxkf8Wm3?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97980b2-1af1-4ba8-2360-08dab23b61e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 01:35:34.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMlbHIT/s1YluzENSrqq1mOE33C0QVO6Qf2+eGWK6kv+0j0bVE6EY+Y+/OCuSlYB1lgLWBw9mK33GTh72ZLmYQQPHj6zVwIMdN+TL/Odwtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4911
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 06:01:06PM -0700, Jakub Kicinski wrote:
> On Wed, 19 Oct 2022 16:09:40 +0200 Simon Horman wrote:
> > this short series adds the max_vf_queue generic devlink device parameter,
> > the intention of this is to allow configuration of the number of queues
> > associated with VFs, and facilitates having VFs with different queue
> > counts.
> > 
> > The series also adds support for multi-queue VFs to the nfp driver
> > and support for the max_vf_queue feature described above.
> 
> I appreciate CCing a wider group this time, but my concerns about using
> devlink params for resource allocation still stand. I don't remember
> anyone refuting that.
> 
> https://lore.kernel.org/all/20220921063448.5b0dd32b@kernel.org/

Sorry this part was neglected, we'll take a look into the resource APIs.
Thanks.

