Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47776867E6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjBAODY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjBAODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:03:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDDE8A51
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:03:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crHxsbJz0KfqaCtn+5/VDq8PSoEE4i00XApSB/uy2YD+JpzXYHc4bnbS55m5E0KT+EptqrT71f8fZo4/LCP/9Jz3OyxuDyfLfYSyibxrYOU1r8KaMdrHVCW1CdHTGgksgIGREceEY6o4jt0nKp7Sm0Pj+/6YO3d4LVjnDXb5FF/2Cwie8CmCO7PCMF+EsX8opAkjBmbEx51nwABwpZrjDVpEwLjqNxTJGA1BMCSgWUPlYtoCHsk7y9NRXRCN+PW8bJLUMpxyMHBYeq8/e+B0X09JfpAURAWP9bkhglsclW36W9qLk/OZw0BCJn/O/JkxMoPqXCYMmY2/EQzGP9PJcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHUMmQbRTr9YL4qR9fU5euTxtSaBchZCDGMAB/T4Jhk=;
 b=E3+fdC7o7XOu+94xeItOFf4FAiWw9HZ9jmXcZ+nL3xuaX1qIOsAP2DHYLDicnXREaRLrsr8onVQiDssvoWoMcj8jX/fTWE0tX/1DYk+mr3/h59uk6qYyJCbUF8+LFlWf/RKT4hFim0BQkKO6qBNMmTFF1qzluGKs773gepWlN/4ToJ5+O1UfNXD8Qkf3xehgJGlZjUN5SHWUxQYtOSf3fqUcm3Lg0c22c8JGJnrE0+RhrXqt8HD/MEh1DITG1QKgpG7IJ7R9ECCsfiwvzflmtTTsR++4madrRGLDaDPJfRTWJ2LbiYYflQRT/kJV3qu4gutx0l1a0Vf1BEQS17bTFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHUMmQbRTr9YL4qR9fU5euTxtSaBchZCDGMAB/T4Jhk=;
 b=lU6YiW2n3kN/P5/Njkd7leL4V47odFWd1X186fjPg84RwBlYopEEfYMrRoh6P3Pz6CdbGLeabKqLk8TKzCcvCsq8UcqNu6xCoOhZ43Y7TPqUqThxT3K5JdvIQmdDZlxBgpFkvMuq4u8uKlDQsm54lL8EOXpxJTlHHPmuWERLKIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4107.namprd13.prod.outlook.com (2603:10b6:303:2d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:03:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:03:09 +0000
Date:   Wed, 1 Feb 2023 15:03:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
Subject: Re: [PATCH v4 net-next 05/15] net/sched: mqprio: refactor nlattr
 parsing to a separate function
Message-ID: <Y9pxFpuuHw3hs6nT@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-6-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4107:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4d2dd1-4722-4dde-7002-08db045d0c6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdOIU7H8i9JckONx63hl99m2MRJcmN0b8bclURf51AbTjf3y6hKneGgblHuFrcHFaB/bg6BSiH2lKXz3JU+qDCWlvCDV879sMsWphsGrHjx+X0QeiwALl0qjgvx2NTbh2xrtuDWE14XIpnfffXBHRtFHcKfZw90dYCq84o0kB2YIcWerfjA2QLuMuiw9SlEttCytcuzG6xBPo6t0NMeb850n66r5+y1iIAPSs+4TwvfO3Ji0s90eAHdkkK43ooL3lDIENqV/irARwj+8r37vEK9muMoM8iqad9GRM/OEUVnNZ6nIzV86+aLGX3vH9Fq8Op7fd4q1c4W4+qPICZrl3dsH1QJDFwdOnPXZ6gCUDBwpSMCluF72wuinefVnPIxEKSGp8Fb2vdBF6YCtz98661/plB59HBrYJi57rwv4yr4JqfqrwQLXlh4f5KNCrOA7hvLeSlpCWWwa9iJ5IDA1jUwj45HHqwD96YuXL3k59zOie+3G6ZscGSZckW/QOfi0CGbtivXtoz44RE6WT0LwzsNyA6YlFBR/w2FV5t3LAlaFWN3mctjfC+htbLcRo4MkPWtmOOsGEh3YHwhUhUjUrww8hvllwyiydlXx9Y3tK7r8qpfhGgi3Vb2wjvZpXWiyA0YOsnph92gYtrcQBTJ9pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39840400004)(346002)(136003)(366004)(451199018)(6666004)(41300700001)(36756003)(6916009)(66946007)(54906003)(316002)(8676002)(4326008)(66476007)(8936002)(66556008)(7416002)(5660300002)(38100700002)(86362001)(6506007)(186003)(6512007)(2906002)(4744005)(44832011)(6486002)(478600001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VTBBq5M5TbNONUWFG6UeYNsbzCbAtcFqDchxY9Adl6NpN9yo7d+en7ti5KgR?=
 =?us-ascii?Q?snbDQGeWs9+aM4CCmnVG2wpNNjOO+7nSy9XK/FqcUDyuPk3bf1rySSasbiKp?=
 =?us-ascii?Q?jdzin6IuQH/wIX7FTXrtLCGIIloY+4bEcI67N/6xQ4/17Vqt8loUENnqqtR5?=
 =?us-ascii?Q?yUzsl9JTmbzXG2cOVKqIKrLlDREA/qSjszvMASKPkzOsp9ntRFCAT0YeF+2i?=
 =?us-ascii?Q?GJiBSF0f4G/IxqhrODJgGCQbtd2UX7UOYTloP9ymCqLoGRTV9O+XjiNUX7JN?=
 =?us-ascii?Q?t/5iQsX65w2EH5kO/ZM8Eu02T+uUX/GerIhL4zFP0Vrxg4/F50vVDUXAD0iw?=
 =?us-ascii?Q?wSnouuy2Jn4/NPUrrbDRE5SeMnza/kykw0umhQ6OIxpP3F03C5OwmFNGCzml?=
 =?us-ascii?Q?Bn1/1eXuHMTydTktsAree6G7KLfQm8now6kgh4suUYRRGVf9PaKO6H80FWcj?=
 =?us-ascii?Q?419i02xPRZB7iDOF2OHy0QzBFqyhgIcRWnXXdvfeAig7v/L7hsFwj/4EwFXN?=
 =?us-ascii?Q?Vw7gLqUvh1vtAb38iqnB7R23vdMfS8YWpXoyym9Lss9yaXU91y4XzZ4k3WzN?=
 =?us-ascii?Q?xoq7pG5kFAJAZOJc/4DyIIMM9fUFiqYEndB3P6kSpTfHGNhQRVJ+lYUfsb2f?=
 =?us-ascii?Q?1sDOSYJkOGlakWGq7nxRSkiVXnY17IqpyCOHg6RVt5aJSAv7hCjEM2ienP1t?=
 =?us-ascii?Q?geFcJBnrzbJMmZ2YFh8Lbf5x+a3JdI6mkKu+eGMLvDT0yUAqssCvqz+MF4mt?=
 =?us-ascii?Q?aQqFJH/yJ7Ml82A1GHEPUh+qetM45BqUUz3pMjAddna1OR9S8ibQOBlSI3U0?=
 =?us-ascii?Q?/fWZXk9Xsv6jeE3g//dsFPBwZF9Md7UQia2ErVwRkSEVtl0AXVMedB/Icv8Z?=
 =?us-ascii?Q?e5quzehy2RDKQdsywhOzswjY4qNp5r08/o2Z4jO2AJK4RIYgCjFE01aqUNAQ?=
 =?us-ascii?Q?VGvH9e/mJyjRJOtcCdPaKA6xUNBrXG5w3PuvY1Q/QiYr7nQrlvs6UZsFjxZx?=
 =?us-ascii?Q?voD86bH7YOhtx4bAxmgWS8J0BCJWnYydnlO/hPdd/8wqjpR5cjxpjX9K4eJ5?=
 =?us-ascii?Q?FiOouj11CoyqTwrPpdG6ZwJvwj+ZkvC+se2osR0PTLp5ZyhDd1hOsnsl2Im7?=
 =?us-ascii?Q?wiktBgZQobmKtWcp/lIDWjCI4CDH8Bk1vh0y8dtHw6YbYZoMEBJdNIqlw2+D?=
 =?us-ascii?Q?n0FtUq6gJt9cSilHHOorNfeWBE3ulpfz0q6HpME4tQOT2eL2+qRr3tK6ciJf?=
 =?us-ascii?Q?jFSGk8YXaJ5b5Lrb8sXmBUeKClBUppBYVI/hAnkJ+wJ11CMkPQEGxiOcNbXu?=
 =?us-ascii?Q?3G1dFyxAFsLYWhCSGm3xfMSww8ZLBBo6C3EKxjzLuAEYY0Zj72r5JUJ/AxmS?=
 =?us-ascii?Q?dyUhxa5rPV9nuI53FVV1odYH8W2W4JUQrJu8QyYqhkDFayBNusHDccw9GV4z?=
 =?us-ascii?Q?lBfI6kNkYn43X55M0irMrPmJOU+5xiMOnmrHd+q4WgkXYfgcl3PDRZ/Te/MK?=
 =?us-ascii?Q?E0d4akrbVV2Hta431lC1t9J/tdGBhGCoWnIi0K43xAWa019Vlu1OgbFJ9vfO?=
 =?us-ascii?Q?HM1lGA5aMXhNvF9gnZjUYF1JV2wKoKmuAwOJyG0S4XhDYR5ZqUMYEmXShNjt?=
 =?us-ascii?Q?H+XbL5m9or2Jy1KXYHjWWrz16xVmLpL6vmqsIkhUng14grLO5AvwDQI/aXpI?=
 =?us-ascii?Q?uyCwjw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4d2dd1-4722-4dde-7002-08db045d0c6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:03:09.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O868S+wpMmBuBw+DRTOREobZ57Ar2pfRKI/MjOfLQxg2KbJPb1/oxyY432Ts9GwVVbpvDNahbWqHM2R3v48SHU48nWhrj84dbmPXtoiOOPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4107
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:35PM +0200, Vladimir Oltean wrote:
> mqprio_init() is quite large and unwieldy to add more code to.
> Split the netlink attribute parsing to a dedicated function.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

