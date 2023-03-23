Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B146C6D18
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjCWQOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjCWQOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:14:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2103.outbound.protection.outlook.com [40.107.220.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C26A1ABF1;
        Thu, 23 Mar 2023 09:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaQdDg7uoxuwBQmt4SFPIdH/seTsXdzbOuiYKSP3eSn+WLtl46tC9ikcBLakC6sTuVWDjivHce9PjbP9hXVHWdWo9zwbPUu3eJxPJ4pvBbi6F5NPmonkbZuKyjOUe82GAbP8dOoeHaTyuMG4yb7CuVTWiKertqILQv6CGKTT2vJCwbZpRQ7M5dLJjvk0ULq+2KaFB073rq7rzvgk8YkHjkFB84corcJjqjShQarKYO0YSewOhZ8BPpxSFy6WKPPQHuaSqb/951sVZDzoX/0GBt7wdzbJQPTvbGLHczJQ9+ZflZ/u+0vpoYLkRvsyGD0aQrEseIfs6Q9xQdEDfbVQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEn+a4rjp8fHLdErlbEajM+6ginCLcuZCVDd05eXWNo=;
 b=DLfEZryI1f1C2p7MDG6iIFD+wgerY2baqklUSfBaEQKWGor0oODsFWZ8W4PWHzOb/aMdObPsI+BEgaaR8tKTmUCvM6Y8TzCkSWwMZTODziAduIX7aUEgAKpwLNLgv0jmUhZGSBNMfx4wVLd6cZcUPUB3lqyNzy3X3daiAsFrmlWeSU2YjF2VNrA2hrO59nzSJeNxAvvyXlzhuLvFCIX9crq2lrCD5sKRWktf7bApkuCe4FErBJ5CBuSVwY1RrAkUAtNzpXyK/LPCbVhAfXqW4112PblKE8QtRwkE2I03YssWyl3FYOBPUspaywICAZAM4wOTxIZ9mzgFR9QaBDyNkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEn+a4rjp8fHLdErlbEajM+6ginCLcuZCVDd05eXWNo=;
 b=nHWgxkA/65vTLlG5evFC04R7Qm83J++i70Niof4jrMbmRLI5ZFToldz+yedIc+Y8nlME+6R1YcStKAv5Scq+ueEsaRYwjI5DEG+Bm4WCLVo6+cVhLv4ZejFQSmkHt4D4NRfz6PILIvrRoS7ebgpfzptKAc3vZbxfIWIVZBqKAc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3627.namprd13.prod.outlook.com (2603:10b6:5:243::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:13:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:13:39 +0000
Date:   Thu, 23 Mar 2023 17:13:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 8/9] net: dsa: update TX path comments to not
 mention skb_mac_header()
Message-ID: <ZBx6rVPJwMWzIZ+M@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-9-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P189CA0041.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3627:EE_
X-MS-Office365-Filtering-Correlation-Id: 226f54da-043d-4e0b-af4c-08db2bb99014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNAk61A2Cxb9BlQItY/YQQjTAwV54ha91AuE6sKvf4hvrQEJcuZiaJBNeJfX+0xDkYxdBifb8kuIhZjPWLRLgprcuWSJxfOHoOrgnSjrW6xS5cbi5tzkno37IZf013U9GspV5MHISyQ5b+NVY1/s+BQGrcfa+hDsJvyGmvXXTlY6Idrysh4yKCQUgRBvh5yijoq6PVz2D1Gj3Rpa1vMDdB/xBOl9r7ej3l9lWLdDOXBZ8qhwmFWpUiU03ZgSl0ib7hf/MKKvLAG37rXrih3SLQvKgWDejlUVbfRvPD/VLrc/lDL122vmZr2p9i6SeaN3pArVkD1bsGvHHg090cH7pMPmU3AMNkegRUQ3wpqpotct50k1RrkSCpprnilsQgp7lmjVYWFFjmvOWX+72eSSSoWcoFlNVkSwwjZquI2akpKgNXoOOVNXOxmlg2Hb5rHA+jXXYgKA0d2WH+hwDFctDgcXLVWE074joFoDz29uC24FJzNsWGX2oNfc2N4agvsRLSoFb9xpx7/jA/33Qoqu+TU4ih2+JGCnSbEo4zTUwoCVmI11BoCVG9sT+hFD57Ueayqu8qV9c9M0ToNuZPF8eeRztfMcDMgMaw6BkruJPLMQ1SbnKADzXffMS7JtFbrZd7N4wJtHdT+4zvoDDFOii7ntSbxV3JzQwTyY5XQpOOMggs+rdWyKNCMO5KyU1Oi1w/36YrGpiWkWQrJ9N4iWoAFmqyBoWCr1e53TikJP2zevb6tU9xfK4qKelscA7SBu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(366004)(396003)(376002)(451199018)(54906003)(4744005)(44832011)(41300700001)(8676002)(5660300002)(66556008)(4326008)(66946007)(66476007)(8936002)(6916009)(6486002)(316002)(478600001)(2906002)(6666004)(186003)(6506007)(6512007)(2616005)(36756003)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w3f45VmxJDQktgPHkTBjbRW5Jf83TJd+dOyM8eJTz1IfgV90KUxnhWmw97eZ?=
 =?us-ascii?Q?ReM/QEmUJzFoBxzA9+VNizBLh5I3aw5YadVK8eFWhZSUMxUq1oVQE52250aR?=
 =?us-ascii?Q?p6KLwqP6U7xcBvYXLAvk3gmlbWOlTC0AqqWkSJzLo4F0tXI4uFKcsIRWAOeD?=
 =?us-ascii?Q?ubEB6cOdDqqxqH3/CZwmtEOrtPej2Hh5mf4FoetL+436PtFGuOpGarZldYfL?=
 =?us-ascii?Q?OiVNDgzSNge0fw2d/dGyKKb60Qr89A7o+yzQ3iekrL9QePRdtTOhyO2HL9Xj?=
 =?us-ascii?Q?xWP4o0FI/s+npHJLMh5MTrYx50KccV/sghAIgcH/mf5vrfTcOiZZsmMLvFdM?=
 =?us-ascii?Q?6whR5AB4er29KvR3xrOq5igzJ88FnAa9iUbm15oZzdYv8TyoZUkopEjYaaIu?=
 =?us-ascii?Q?o4d6jGfNFwtQGBZ402n2jWEjdABtULkpRbOkjeRo/L17fAW359GP5vdjmvxi?=
 =?us-ascii?Q?kzp9qHrU3ugwUm9gCbWbkjY54xcycBv0RlVHAzBLjVPOM2q/ZVKviRCYv+TF?=
 =?us-ascii?Q?4jPB1zNnCTHTk8IQL54p11p2x7rSu2ZlSnUz3bCRE6bojubqHNWdSsgjDeu1?=
 =?us-ascii?Q?dNDv9oXmtqk8foAQOEGFLmyZvl6juXIoFy+czy+WoodPgd2WwNigDU5ePGa7?=
 =?us-ascii?Q?RI2RAQ7hqtgKHm8OhclWe4WOUf/xa8dZliv9Jp/13iSjx55q20KL1HJaxl+q?=
 =?us-ascii?Q?7ssZ8CF4apa7feX5ctHkgN9wxrRlgXu9R/JdmHeAK4sRo7LqsCnL1qdrJCue?=
 =?us-ascii?Q?+kYgLEyKS6rC9deM6lwxLbLoV96LkkkFXJH9kIYjFNv2vA5rMTSfxNU9e1Nf?=
 =?us-ascii?Q?SMb8+VS4JTddLgLYEmQfxvbXbJkcKnWORzn8Elh/hI+Ss0h+IySGkL2HoB7B?=
 =?us-ascii?Q?OppkvPV1nl9afKpusLv9t0Bqwn6kXHhogrCMG2v5yf8MCq+1yozym66DzqaE?=
 =?us-ascii?Q?fut9Zgmu8LaUJqWmiAC2hzOZrlaG/l6PfDLcQUbpoY9ysYs5p93Cvpbv7Ca3?=
 =?us-ascii?Q?dv1F+Qr0jLtbP2GiPw/H6pY99xv+n96BqnARAJdjamOa8oU/UXJSSiM1HJV3?=
 =?us-ascii?Q?/SfXc5ubGGTGFTr/zXjYjFGOpD2eqOrr5907qfKbkboiJ8m8jcqC9zq0cV8J?=
 =?us-ascii?Q?koGTF8VfVWw9PxxsQQwBpNvvHuiDbfDr3f4Owik/aqT3k8vKszNLLbD9Nd1V?=
 =?us-ascii?Q?XWFe7T+EthJSoX0TYlqC5so9WtEA3J+WdhCmuIwgorblXFBEgJkUzJ48xjp7?=
 =?us-ascii?Q?vD2mLdS3dUFC8qFzMQMGsOUEdCav4jbVN9+BZzwtRF9w7HhUzCvds2kp9Ynd?=
 =?us-ascii?Q?wrY1KNkKvsUB5a3fh2PbiQ/ZpZeEFwVkwLz7820iyvsrrhs9WeCIuAzSSQYK?=
 =?us-ascii?Q?qsNw6xmsHonoV5fGaVOaa1n3QWZCivCUl3G45NQkrgHsUUAqO64+C26JMSn0?=
 =?us-ascii?Q?1XaBsihIAANeGvG2g5JYQPBy+Y39R+R6u+eOxZj1QEBJ82cOloCoH4aevqnA?=
 =?us-ascii?Q?gySu7G1LFHr6N1T/L82qGXGUAXIeqPcDahIYcCO7mu+ZTINW6R+rI11AGkKz?=
 =?us-ascii?Q?UNT7Q0WNAFOxvwdqefBm4quB10hayQjDycpeu8jtfEbfyGb7PGne0Hy9kVFn?=
 =?us-ascii?Q?9/m5XBZBSEdAeO6KWliTCghVmdMqs8FTlKN/ArEgGsamQ/xMGG6QazJElsAo?=
 =?us-ascii?Q?091kGQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226f54da-043d-4e0b-af4c-08db2bb99014
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:13:39.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cgHuCoDuIe/6YdIJNvEI7yq7Y8UX1ubKZgMbbUTeADuCbBpScZRYRwsR7FuXcfVP27wLM38hj4mJdBRRTgYrhbRVYvIrrgFgcNd22s2xoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3627
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:22AM +0200, Vladimir Oltean wrote:
> Once commit 6d1ccff62780 ("net: reset mac header in dev_start_xmit()")
> will be reverted, it will no longer be true that skb->data points at
> skb_mac_header(skb) - since the skb->mac_header will not be set - so
> stop saying that, and just say that it points to the MAC header.
> 
> I've reviewed vlan_insert_tag() and it does not *actually* depend on
> skb_mac_header(), so reword that to avoid the confusion.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

