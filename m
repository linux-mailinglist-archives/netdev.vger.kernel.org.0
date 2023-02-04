Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBB768ABB6
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBDRo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDRo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:44:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D16F25E21;
        Sat,  4 Feb 2023 09:44:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8FDizvJzFF7v8FsBvIjgaAKSgaTlLsVFy2ncWvOcohWTDCLxBae757BI6NL85wG4/BlIj0KIwKhXr3d4LuoKoXMe/LB+SzU0mXBZ4JgIlQEHrUeU70ibTL4xBmqOX9sfq1xNwV436VibXJiEueqUG3ivly+/w7PHTVbDjKeHYB2ZFSAFtgQnFBTp3YTdCe2+Qfi4Vj87z9q9eQK5o9Z8ZgWM9DK+03PnCN3YkAMi6sMV91GRoSOoVOVHUG5PrgZro7PXSThu4IxoAhD1oHYqoF1hSPSKYcyxtMxcJbfaLgNOe6M2HQcfFjjuWrQAwQ7cWrXkeKH4zGsC8y005YLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pk8dH7FMvMp/yw6nKHeyqMtrSCU68uwgJ8djsjrdS2s=;
 b=UG+U1wT1Pc6hdaF4CvppD75UPOod+f4rxjylwpkDNXcK/nMKgxgXQ2OvCn9YByIHakTnkwtpGiRsjHtmT9Sh5YdmR2r6648VBdjTYMsfcPPWAaPFdpWkmlR+chF/yYXmUjUfScLyVS4BxvaCmvHsPnjjWXHiaPf9VpLWsbJjiiLRAuKWc76ka27hdjn5ZxKb0LobVNpMm4huqEARNkIcSOpUWfiXYi6LDppJuTH6BhTSla7xnlDx7mSQ3rPdAqNjrGBo+K6r9YLl43KjIxPT0BsKcyzMzvxMvAm7p2JtFTe/KciMS1bVuWroGzSyP1mC/v3P82iatfWo5auk//VIuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pk8dH7FMvMp/yw6nKHeyqMtrSCU68uwgJ8djsjrdS2s=;
 b=nWESAHz/F8+VYw+PPUQUknSzq3lPyNwmDoWtEUS/ccm3GnOP7SZUHyweZiDCySnE6cOcPC1HNT8uzx8xWMf+YhxiDq7wCx8ZNOTun5ri0ihdngdJd2OwM05u5zR8j3Ql1Mzor1DFe9TolzipyaMpEtYed1cZWAG3oFubhJzIjvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ1PR10MB5953.namprd10.prod.outlook.com
 (2603:10b6:a03:48c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.9; Sat, 4 Feb
 2023 17:44:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6064.019; Sat, 4 Feb 2023
 17:44:22 +0000
Date:   Sat, 4 Feb 2023 09:44:10 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
Message-ID: <Y96ZahikcXqYbOnf@MSI.localdomain>
References: <20230204001211.1764672-1-colin.foster@in-advantage.com>
 <20230204013439.4vfag2kbrwpwvnpr@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204013439.4vfag2kbrwpwvnpr@skbuf>
X-ClientProxiedBy: MW2PR2101CA0023.namprd21.prod.outlook.com
 (2603:10b6:302:1::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ1PR10MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: a8fe098d-3355-4045-369f-08db06d772be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LapNHbwsGLIO9rQkOEeqlpwpCOWefgvLLyspe/mKFa1ZUBK+Ctclz0wmOXnFpWZNHeUL+dcTzL4+RhNIlTxIP41irhGnP6dkP75FNlvtH5sRbn+qETYzSTxcxNbCFiUMpYzX42Rkd8Z6VRxb1lInu1DOVqKgQY3cNRHaWEGWwzVsZZWFrhu9Uc9Ue2G92MyAuprvDV8fxUFTjokhs85gMKJLNFtq/Xt27RG++EIH+zdZYdkqF0m5hT7xiVVDD5VssFzt93vmrB6mEa69146v/aQVWPdHQciw/pj/IqwkdtLtd8R+ayPFsIXq/EA3XVV6Im7hHi7c5Vq+MMh9dfgrOBk/luZ2vqBHZ/zAAWz6qEBwubXgqUKg0jrAhMOj/ffcMaePMdZP/OhblZTRz/XjthRtX/lfs8X4rmUiB3CkGjhJUgo3uEQHnJ1C0txvfuJPuibA4zCcJ1ACxtuGWyP8ZYZq5RN95+9Ijfjba3A8PqtIMoQiAf550+Ed3MpZhwtgdAu9QJWIw093nF+e14QcsL2CooHgizxzCSyDuBeUCZAUlQgAomvYwF6yK6wh3pCesSNDJ71l5606gW+MkIrjvvdAreUfoRI50BJFGo0uJnhwkKDbomS3qhW+QWNdEm2+MgfiFg5Mirf7mSJEzW7bHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(39830400003)(136003)(376002)(451199018)(2906002)(44832011)(478600001)(6486002)(6512007)(26005)(186003)(6666004)(5660300002)(9686003)(86362001)(8936002)(7416002)(6506007)(41300700001)(66556008)(66476007)(66946007)(8676002)(6916009)(38100700002)(4326008)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vuMG0wy3YRA3YNrrBOR5XW0coG4zpKYsVZooQejIApf/eTRElvQd3BD9YMYN?=
 =?us-ascii?Q?upDOZk6qazBaYEFBYrkVYTGtJD3PZOUqs+5H6qNvuAw/KEUp7kRXqaYNBrkZ?=
 =?us-ascii?Q?P2peDE5XOCz1YOa37VjtBKeR1accPYhQ7PI1ZPzPlkycVklf0OgbtcWXbYzA?=
 =?us-ascii?Q?7NzLtQfTVwoZbx/OCYHFIRkEhzIIlNgkZX/xoMaQkUJriV44euKsax7krjnc?=
 =?us-ascii?Q?FlGb6kzt+Ans8YS+733zQdK4EVQeVaeJ9ZtLHfR05m0dUTBtWPDx021Neo2B?=
 =?us-ascii?Q?e+rATD/rf2PvNVubqjs9RzFlSsoY5Yjf9E6VzfUP1d+tlhPadCAwdS/AJWqd?=
 =?us-ascii?Q?2EU8c05tk5bx9H/C/mRUlxaOj2LUcWsSDqGCEu3znweCK4iuKKIW0Y5ggxZa?=
 =?us-ascii?Q?oJLq4Q6Y3ZgmjPg+5Fw37aKG4lNZfpw4nu7IhwOeA3eY9uU98ItyFcueEBEi?=
 =?us-ascii?Q?iTuHgJcAdN9uZLUTmnngDV4RVS3LL/yio9OuclKw4B75LyY5w47add+07OVq?=
 =?us-ascii?Q?dTTO/DG10jjfv5T8iq1fGYOtbO+GRahBpN6Mr2UScUmkZ71nEhd9BzrVgY8Z?=
 =?us-ascii?Q?f+kDWqD+oUzrqUM6Ypsbb6TkMSoa1fDHTu+xA/AqHl1TsDsiKNCQnqZbMAY9?=
 =?us-ascii?Q?E4ldykxxmmxhNpjepY0LCrlgTT7Daf/CnROXWJxnTjoD58kcCTrdax8i3of+?=
 =?us-ascii?Q?84A8LIHlL9O87YJh3f0brOaGMGPlXEFseSRTI2e0VJc1BH2e+e9+VHb7VRGQ?=
 =?us-ascii?Q?/H2cU7CHAWAGP2WAvFv3i9XhXyEiU+GhhBGXVkSwaXR+eKwOJNstdNjVbXR4?=
 =?us-ascii?Q?wuUm8KAhPR6NwvTslOfwFWfW5N+xlmJzxqulrI72D+f91fbPeWR6Agp3k6gM?=
 =?us-ascii?Q?7P64YCpM9T+aBs8/n+2AEd4mSnpR0NNk/zBAYSk3SWaJpRbTvdF2aNJqDgFi?=
 =?us-ascii?Q?3OIt9RaFU8AUTHR6avJJBmAl6Zc2Lk75w21M9tg4keVjskGaDldSN2f9nLOC?=
 =?us-ascii?Q?ZEMlf6KJGpQ1q5tdM4PoIvweYheYMTe4S1O4Jwq63JndY37omrDRt2EN9u0h?=
 =?us-ascii?Q?cQC/d1ZhkmUxwmUcSOavb2rj4ckyeff0LR9IXj4D8xQe7z9OkdX1QsNyIV4c?=
 =?us-ascii?Q?AE6mmfJaoVNNZnsNDolfzZKyRrqWyFsMQ/ecV+ub2pHEn8lHFsdS9DwMf9I2?=
 =?us-ascii?Q?DzwjWXTS/YkTaSx+4vMVWMPBP5AKS9fNCsDyBuT+9pnbQ6Sl4hHBwSYdUQjo?=
 =?us-ascii?Q?Q0UZy8EovUVYn2xtKJgBWXUdnSsIpCgSE9q/QFNFviOFmG4wlL05aAg1tkNW?=
 =?us-ascii?Q?+k3CA2SMsrc10uiraSjhvSpuYR+c9XEkenLWDRmXDcvIFVm+1l7EkPcBnitl?=
 =?us-ascii?Q?Ubdg4GQSXmc0iWRq2jiqEHLMjDWXCydYU/WY3O8p7EiHFBRB7mLqtE6OTq5u?=
 =?us-ascii?Q?S+0FMU/jcXsseNu64iKRmryS/vbWt23DBg6qKGtl3pOoBW5yIMC2tKS02feH?=
 =?us-ascii?Q?LEr9gNhvZ+RqJymhQ0fAtCd6jrbvPIseo8pKHpUFrXSM1dCVhSObo/wCxz1A?=
 =?us-ascii?Q?12TNnvWm8Iwh1hk5lOTGcD+MjsVTRIELmN2QEveWmXyzCqQoGyO9olyl17eP?=
 =?us-ascii?Q?Mb8IxsnhNpQubs6aMuOTnBc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8fe098d-3355-4045-369f-08db06d772be
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:44:21.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Oh9H5T8xF/q+0Wf+M24tdExPxVXhn/wjntkI6+wX4QubuKcrq+2K0pKIxTZFx0tuXimGQ+hpCfkm+QELYPk2kOK/aOyTWX0gunyc5M5G7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5953
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 03:34:39AM +0200, Vladimir Oltean wrote:
> On Fri, Feb 03, 2023 at 04:12:11PM -0800, Colin Foster wrote:
> > There are no external users of the vsc7514_*_regmap[] symbols. They were
> > exported in commit 32ecd22ba60b ("net: mscc: ocelot: split register
> > definitions to a separate file") with the intention of being used, but the
> > actual structure used in commit 2efaca411c96 ("net: mscc: ocelot: expose
> > vsc7514_regmap definition") ended up being all that was needed.
> > 
> > Bury these unnecessary symbols.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> 
> These can be unexported too:
> 
> extern const struct vcap_field vsc7514_vcap_es0_keys[];
> extern const struct vcap_field vsc7514_vcap_es0_actions[];
> extern const struct vcap_field vsc7514_vcap_is1_keys[];
> extern const struct vcap_field vsc7514_vcap_is1_actions[];
> extern const struct vcap_field vsc7514_vcap_is2_keys[];
> extern const struct vcap_field vsc7514_vcap_is2_actions[];

I was as positive as I could have been that I'd grepped (grept?) and saw
those used in Seville, Felix, and ocelot_ext yesterday. I'll fix this
up, and thanks for checking!

> 
> I guess we make exceptions for the 24 hour reposting rule when the patch
> has been reviewed?
