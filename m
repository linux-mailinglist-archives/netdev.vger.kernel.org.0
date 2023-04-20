Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7246E9760
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjDTOlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjDTOlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:41:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A355FCF;
        Thu, 20 Apr 2023 07:41:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7ip0VL2iotHQ/AyiVVfIU/7K16MlcmZLGprlhEk+PYMUOL+9hGheB3qJiwn59KaW960zh1zdbYNgkIO9TvR+rsB56llYkUi/kWm0L4zwiDTzyeC1U7ukqS1b9erSUta/HtY1vRUTIPgy/N0sSrbs1spECNdMy6bVtFwakT+jvv+6KfmrN2vzDcLw+Ho+BmBVs6K5QvIIF8JfbdD/LCoGwVcI8D9IQJqiCbBZN/EtH5nJEq8r1rYRgpsYx0wNn9EpTsHmYg+JhR7ivgBvifm7gS72trElMbfa42RZql8kTpkWgqcyr7lYLFRfLvOZPeeCeuqeFqeFKjpw+y6dAlRFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUUJbHcZopKoE0EpeVspzvNU6Yu3A8vzgKnkQad+wa8=;
 b=hAGqfQI4J825+5Vs9Itfu+AcUnkomfdRV0cayWE9j9ICExZu+9u/ea6KOAJ/PYx5pjFGsgnCqmkHX0CLFB0zZ9fkg2HWLNBbqbuqiGm1shGL8OkoY2SlBj7FEOJkmhqwAtK2/KJNSc9XYhubty7ZOni+QTD1X5DBaWG1XJZ85k3pnlci5Tofpcx2UC95+jA4YGjQ1zzKAp/vg8MRg5acNxoSlSWMYet3jGSdPlTDt9jsTcWH7pHNkkKaNS8cdYunZKGxvw9qI4GW3riDgUg/RVq7ul9IdNAtNRrMSrrva+y2x0mstRjnTQdk2Eem7Gna9bzUCaFU/ECMp6utbQv3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUUJbHcZopKoE0EpeVspzvNU6Yu3A8vzgKnkQad+wa8=;
 b=PiMoLxFr33W1zMkf0tNbIelazNfGp9EyNSrE9EqIj5iJ4ZTAhKIHfGtL7SggLB46QbTObut7+i9zl7a6ynyhHGGl4TTci8b1F9SAKE93SM8xlR02QY8ahDqbsDgut+A1icPIBuwOjd+0NfVsOzop0a882b9yv6VULRQSrp3AG9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5792.namprd13.prod.outlook.com (2603:10b6:806:21b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Thu, 20 Apr
 2023 14:41:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:41:08 +0000
Date:   Thu, 20 Apr 2023 16:40:59 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/9] net: enetc: report mm tx-active based on
 tx-enabled and verify-status
Message-ID: <ZEFO+42Qy2sIxwpI@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418111459.811553-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P195CA0009.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: fd9da178-8ba7-4573-1698-08db41ad46ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGgO5STTLNmbJs/0Sd8kmcYd64a1lrLSaKNMLtTovrZ9JXHEmesncFSRUEziuZkpq7sz79+Ps7BGdWxnBPMspyOTXFyu4Rj7mj/GcJiaykiRtRb7UJ4avVtyTadGc4FJPUpm5+PXOjfSKEkOSposXZvCvMJtaBBfzQ/UtubECruKCLyhm+OsD2ZyeaFarrQ4VVVUfumVQVt/LVsrJ75ut3LgLKZGAklBkN6MO1OrPzXsU1H9T67BNB7M6NiyZYdDNZDfOukUPDXJV4h3USAUYM5pUj661guAMrKSCcrzaAMdUXRxPEvJ57OfChFC6MXSd32lb9PcRaSdiqsFyGTUBbLWIlUinMhngOFaCeXf4ifNK2/GEjfgpFiR/GKvtim6C+JcKH8Pn4J1qskWWrX5DQ3ki7laxV50mSJeZ7T0jXh9kgyJ3w5BzZ7gq7zcOwxk+S4zO4X8fVt+VUKXUvL1xe1G6bZC64Fyi4e1QH7m1312UDzWC1AVJxyPV7JFjlvz/PwXfOMYIg0Jdcpo5oOJhPRxdB+hWo/7HdN3HbtEXuP2LuS2pUk5oUxbDc28HfvtePYDr8ovwVOMh0l41ReIoEhZ3GCohS6nrd67VnkB/ZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39840400004)(136003)(366004)(451199021)(6512007)(6506007)(4326008)(6916009)(41300700001)(316002)(15650500001)(2616005)(83380400001)(86362001)(186003)(6666004)(6486002)(478600001)(36756003)(66899021)(8676002)(5660300002)(8936002)(2906002)(66946007)(66476007)(66556008)(38100700002)(54906003)(7416002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pkNHUi9ySC/2lcW8ajP9gB1t4vnjb/o5id09Q7bUDJRp2ybI+ueQHOD2A9Ia?=
 =?us-ascii?Q?ATTrdID/4th3+r5e7rxT1b26r0Idjnj49M3NiVcxMLInt9h/zjvz65UodTwm?=
 =?us-ascii?Q?6Sbp1yWJyL/13gZI8m09IgLXR4txFI3vSnbQtqe1oLwEb3ubxD4FyGV6E4AP?=
 =?us-ascii?Q?+Y5uL8FOsHagH8HPplJ10U8v1cxF0y1o/nmxDbjDx92zyu4K7CjRAH6+8HHC?=
 =?us-ascii?Q?tqx6V7cbApp2lyrnYS+cL/EPgZSKhjCAezvKaVmuq+hbWYKFBj6Na33ciIVR?=
 =?us-ascii?Q?0sZT8zbGMwqu9U4vj5ClT24p2ER7B6wynBM+zYZH33ZoliMvvHli4eslP21B?=
 =?us-ascii?Q?9DdZPoeR101PDCkZZn4A9vpyDlse8/bHRepvvC3jeNMD2xwIJi0JsCNkqxam?=
 =?us-ascii?Q?hXR3tadrEsRyp3wugFHV/I5fF2QRKaAi85kAmRGBAWw2hDXZN/VqAZ85ChB/?=
 =?us-ascii?Q?g2rwSaQodhGUvtiXv9Qdt6TYgD8s1wi0Sx8hNFKmLI3dehbKAom839R1t6CB?=
 =?us-ascii?Q?Yk1BZ34Cvzp5UNsa2f+Htx+Rhjkh5/y8UrCZ9dzQ8fpagGVRlui/Oa0fyIhc?=
 =?us-ascii?Q?JBh55HYr9KzjT2R3Clj7yUsBMFvuHHLnGL3R8FnedeXlkDNWVeZKACmW90jY?=
 =?us-ascii?Q?vsWelEg09vaS4Y/5Vruyzf6T8GkX3a1nyjdAsOn55CEKCCfloTHwiQ8+KX43?=
 =?us-ascii?Q?164UWTipy7OVLF+O3Ou8CpxD20LJJkWWYLpNMa+esooK7n4/nPMv+OhhC5Pr?=
 =?us-ascii?Q?jMbNS8j3b3ZbjlADblNoul6um48j3LtOAx0hZSuA92pm+8JHuv5VY6qvTlzR?=
 =?us-ascii?Q?GLH4C9JD8t56vf7+r7JntDpmZY8gvogkuEfGXuqONu481UbqYiHR/7Dxuqrz?=
 =?us-ascii?Q?xScKF+ErAtSEO9VAI5U21fVC66EG12oDtuImFJhREV1au6TPol9hwtfhdUJ3?=
 =?us-ascii?Q?vZkBiFkCxKHrSSFOdfoWoX04i8tdiLrloJG/3csiZ/hJx6XZbTq5aV+kHLFY?=
 =?us-ascii?Q?NbYS8xZIpdVN0f1p/5wD05WLR6/cRrCjLZBMDVOOd3KiLxoTaazx7IvYokL7?=
 =?us-ascii?Q?ayorqT2cdq3LTGLcnGIOl0A9ZYKSCr9wHYjSsxkBZKPfL38hu5q6pE/D2od8?=
 =?us-ascii?Q?Qmru5OeYqAGc8zdp0dRQhsC4a4idpHXd7TCXDB+2wpKXqlyQyGNDPZk5+Wl1?=
 =?us-ascii?Q?5/oaiMDoNl4h4DCDNCtbrgrQaQIFp2hmJTrrsXg1wTvV2Ib+NWLmb01hx4xu?=
 =?us-ascii?Q?X2cCEcMmMBGv8o+yaICIoqJwtAWgGQL11MgclJlZIFuvT2vfzcTKgJYs7i4Y?=
 =?us-ascii?Q?HtG+JVJZD2VjVSm3b/8JjmjS5OoPfHfcNvcx4Z+wsofWZscSEfIEkw1i1Ukq?=
 =?us-ascii?Q?iVXqOkcmML7hCFZALVn+9cPsD5kHP+76m/C3/ZYeuT1yR+k7IsIfwvdAeu3d?=
 =?us-ascii?Q?IQiVCK0xwCxHNGh+jpOiN9itVb24iI5yI5y4mJFXNgPWgnoGFexgs6iEihTh?=
 =?us-ascii?Q?nzbmDQ8HpNe38lWiqp3VNTgpKi5dQ5YZFv3+LHRfoJ3hSPLD6Jh08CI5f9yv?=
 =?us-ascii?Q?2GA1/idnUYj0aVWT7LTBUfTkneVqKxejTn+4Y+TyHSne/nAOO3fpi4zXVNNl?=
 =?us-ascii?Q?2uKvxiW84aVaLX96r9P+YYUIEb1GGb1VLwjG7GXJKiMY2rGDEmM67/YBIcY4?=
 =?us-ascii?Q?79/GsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9da178-8ba7-4573-1698-08db41ad46ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:41:08.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRjFdk922btCDVHofvRxPZgUfd7+G+9NNGFzhDDI6moDjaLbYfPzzKfGI7EbZmhVXc1Jqikgn18pznUVRr8jUxbJw19M5Qc6tatIiedeXlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5792
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:14:52PM +0300, Vladimir Oltean wrote:
> The MMCSR register contains 2 fields with overlapping meaning:
> 
> - LPA (Local preemption active):
> This read-only status bit indicates whether preemption is active for
> this port. This bit will be set if preemption is both enabled and has
> completed the verification process.
> - TXSTS (Merge status):
> This read-only status field provides the state of the MAC Merge sublayer
> transmit status as defined in IEEE Std 802.3-2018 Clause 99.
> 00 Transmit preemption is inactive
> 01 Transmit preemption is active
> 10 Reserved
> 11 Reserved
> 
> However none of these 2 fields offer reliable reporting to software.
> 
> When connecting ENETC to a link partner which is not capable of Frame
> Preemption, the expectation is that ENETC's verification should fail
> (VSTS=4) and its MM TX direction should be inactive (LPA=0, TXSTS=00)
> even though the MM TX is enabled (ME=1). But surprise, the LPA bit of
> MMCSR stays set even if VSTS=4 and ME=1.
> 
> OTOH, the TXSTS field has the opposite problem. I cannot get its value
> to change from 0, even when connecting to a link partner capable of
> frame preemption, which does respond to its verification frames (ME=1
> and VSTS=3, "SUCCEEDED").
> 
> The only option with such buggy hardware seems to be to reimplement the
> formula for calculating tx-active in software, which is for tx-enabled
> to be true, and for the verify-status to be either SUCCEEDED, or
> DISABLED.
> 
> Without reliable tx-active reporting, we have no good indication when
> to commit the preemptible traffic classes to hardware, which makes it
> possible (but not desirable) to send preemptible traffic to a link
> partner incapable of receiving it. However, currently we do not have the
> logic to wait for TX to be active yet, so the impact is limited.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
