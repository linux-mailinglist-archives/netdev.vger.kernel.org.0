Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A540655EC67
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiF1STt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiF1STs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:19:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2122.outbound.protection.outlook.com [40.107.92.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567441FCDE;
        Tue, 28 Jun 2022 11:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOa74Ff0amq6EX6/0k5vPbzN8CU0B+pSWWHVFD09hGUuCMkgrDF8Y7GEkcDOc+UzZGaFdAOAdKOXzqyXRmX10YGuCtkBvBYlNZ08uo+MRyiZsyT+fP5vHTy3Gh2+CwMfSlLnRo1eWKlfmUkzqHbkUNpmvZYOAqRHhXCeRE8LfP2HDywKIbLEdaUtzdm+ZpY38sGRhjiRF6v/hyVy0mikG50v0uaRBmHcUK084Is+Hi+uAdJrK94D0KKUMV5TWgS1FBaPrNc4+94d2RxmS9VR8MnUUygv35aJwPbtpZrS3m+Vh4By5e/W2BL8H+QiWq1e4eq7LjuBxfeRfM6477DOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68Tn3syQSNHAzYgfisTy7wwfmFmDmwdkOBUOo90JhTw=;
 b=fDgY8YvFWKyGBzwtVWo/JXPnfuy+FiBnKma2j54pSNzHAh4gkdQeVX2l5QxcD02I8mwHoifrqJpbAIcZ9nYYGYqD21MZ112YTr/G8SNzWBJlJEpwoe1J+OpU11yElLY2tY/eoJ6AygLKDzgs8Fg6bLECJP+fderTSH5S9DHfzhUO23wk2vR68Y6S9EexVi3j4KgkSAlxKerzDjGLdejW7xh3+D7OWOcl/nr0xgpkZH4Q5COGC4t2pgl1pnEu0ShLI05ac8vdgqGUHi1EXMB+aNKYvwTRoenMS9wqmFBvr9GBeZfIyYlfQTrrmQak0qkG/yqt2d/K6ojJvJeMaQd03Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68Tn3syQSNHAzYgfisTy7wwfmFmDmwdkOBUOo90JhTw=;
 b=GBupDAGq5Pf6epF2AAu8djte1LzlmSszNSqiqabmEdzpVR+sIDw9U1TpVUNkY2IDUXaaH8+wnal1oP5z96eU8/avhyTTFs4DcN+xIB2qUcG9CxTdzcJj2MhGskLSEJPS5FOSABM3zR6Mgb5ReNPTbYFLQAZJcl+P/IAQps3xL4k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR1001MB2282.namprd10.prod.outlook.com
 (2603:10b6:4:35::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 18:19:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 18:19:44 +0000
Date:   Tue, 28 Jun 2022 11:19:41 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Terry Bowman <terry.bowman@amd.com>, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v11 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Message-ID: <20220628181941.GB855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-9-colin.foster@in-advantage.com>
 <1656422123.508891.313744.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656422123.508891.313744.nullmailer@robh.at.kernel.org>
X-ClientProxiedBy: MW4PR04CA0129.namprd04.prod.outlook.com
 (2603:10b6:303:84::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c81e1dbf-3cee-4084-85de-08da5932c690
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2282:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcnhyPt4oBYztCMhB19KeFZhqGqZtJyEBQp2t2zQXBDhvzbU0bFOwWxgUoqelFqBq1afdzlCTFz0+Nn+H0fnN8vuRoZ69U8gCjPonzc9wWaCQLqQKedAZlCdiWSViaPF9B2d6SQJvV4c9YVb//PH0dHDViC0FfOvEhNPbH82/VziBB43fP9PJb5Kw203RJTsHkhnB7bcbxkYcFe/vV+gMC33YK1wCU3XsC8/YYlfxBBtliTQoMrUdS77a9y4CZgJKgcmDg9DuhjKmFK9oBKJw5EF68Ayk/yZ6REIZpMzJCH+/bV4RJgsmHmg8Scfjoeyo2A7dM3BVwrK+5Ziq+8gvRAztKnUsjXzvKqyy0PW0IlQuu5yCjaioSWmId3E6YbPBY41Lzwel6K0QTiT9w8vJzq5On2z1pjsj8lstOLgouJ3CkfKI0ShRWBvnR25xrlkOVjFWUrZEgYw5PsM86cg/sxW9UQaEB+MJ5ywbCFPX/ri4dGOk3r1i7Yyf6NWiwziwxcM9t7E+W3uaMfNWKgUT5fgWK/vCYEPr3+v90dieiEraAg4DL2Wzryog007L5Z97GIs7VF+0SZSw6e+ITQ470rC5XWsvqLc7s1rY5Jn8bVQgxkHBZL5PCuWA0caIqu/s+Q0FCPxU7EpfuWQ0O7P1XhZZyGxF0HPNy3/ejC8N9vypaxGvQUF6U6RVHXOwpFBKMMNpzCO4qmATAIdUpBLE0fIBJtFd2knb4DT77UiKnq4vPuIVUl4ul4bDE6K31FyfY4UgOEXNg2WRDRp99AzZoZggGV5+KoD8L4fPQ8mnO9b95FGzaUzS6SAE297WE0KfqkoT9o2U3++76SHgpXU1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(39840400004)(366004)(396003)(346002)(376002)(6512007)(66476007)(26005)(66946007)(186003)(1076003)(33716001)(38350700002)(9686003)(38100700002)(4326008)(86362001)(8676002)(8936002)(41300700001)(83380400001)(66556008)(54906003)(6506007)(478600001)(6486002)(316002)(966005)(52116002)(6916009)(33656002)(6666004)(44832011)(5660300002)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kAn1G1T4BqOuMHowswDmZNuJ3SglB/MayEO+Ro+88jgJzz993b771+EXdKZU?=
 =?us-ascii?Q?bhC/9mwTfH7li3CGKHETZCkCnjcMgRrCYzwDl+0TobDlO2omb1g7Jg/uMxUt?=
 =?us-ascii?Q?+d61Ud5cjPrHqyHj0UxNOFoyCRcmXW/678oUgUbNUdnsadMocGvwI8Zl0LzC?=
 =?us-ascii?Q?zsmolmpSS98fb9tdhjxd9bcjQsKPQpzjSrFfdEHn/lCBCWAvTvqOUgs9GZb5?=
 =?us-ascii?Q?vO2fUgNywgQwBalrv1RLf2vg5gSci3l4QF73nJBTRAl57l3PpeZb/9Fm8W0W?=
 =?us-ascii?Q?KdQzkxIzGaPQcHFY1Ahh7M6hKxoJBZDdh+jDLeIsWClfc6CBkzXM0A5TuZT/?=
 =?us-ascii?Q?N8Bdd/cpPDKZd1iNCUvtVjVsAeIXlJfc89pqOB90yzqUfgkNLwbizUWaBL4b?=
 =?us-ascii?Q?EovaUE3eT5e1e9ub3UYiTPA93F6W/T+81bhj7+liTdSpmnhcPwoScJr3r8hs?=
 =?us-ascii?Q?q6OGxVV0NQC2eymJ+uvZ82XHfTQFLUUnLfgf2TT5ikphvGog7iIJkWlvDKDC?=
 =?us-ascii?Q?KM1D8UaIA0V5QNdK2/jOvqZEvVHQ0Iuar8qOqltvLuZR1f36xUBuOGq5/F2i?=
 =?us-ascii?Q?0FSkZZIsHIKSebGzhFVlnXtUjPMjh8B+EImXeJp2ZlSkGDGvtNmldAPh+GM7?=
 =?us-ascii?Q?UX/BxHhjbHVF/qF+JBOeSXIfSaKQrFNEl/M6IJITUFYnL5Jo6B8EidNqZhTb?=
 =?us-ascii?Q?aJhmEH7E/R1x8KdjOTRXIpOLaHGbrgTcwZAqiY1LLXY44hyHUu5qsjvyH8xc?=
 =?us-ascii?Q?F8U2dlhTrS3/EhNkM0x8599rnAs97CcdjpxF5d01O9nHZSdTmo7QTyh6CPLo?=
 =?us-ascii?Q?ktk08YSmb/v3pwMdbqbERbdWsQMFYqsGOoLrq7pcSEWQo1EBFL2Z3aniP9Ow?=
 =?us-ascii?Q?Jn9hEHgaWjfzO2avQJ3NG11OYmeBEWYkZ7LQptq7dagOSLrm5B4fjCsRuNiV?=
 =?us-ascii?Q?vKBmq7M5jgvhDKU0m6a/rCbf07g7MTit/RDJUWa7jEkj3VAAWqvvcfrroBaz?=
 =?us-ascii?Q?FpVPWj9DUr8w1VqUwgBvDIeBCrM3gYp9DAmr+jvxh2CA8BmSNyc6wd6VYwmV?=
 =?us-ascii?Q?gtny4Mjt+NC2Il6lafRaFzvjtY0sqJk78mErWQoZc5/kG3mxC4fEaLk6d4Jr?=
 =?us-ascii?Q?0Pct8SXRXPFMxQYLK1xqxAu1EC893esAUIxtSiZoZgZhxEtQV+p1pYPPxxW+?=
 =?us-ascii?Q?amG6GuRKQPouY7hZM2TC4wljkm4oQppVIi1XGre9eZD2zNdIDROq9yAFHDxZ?=
 =?us-ascii?Q?MadKTm8OKuYI2ZmKYnSW5I9uKmJCsWtgRLWiHRhZBcIiHLayOVgHJSTFJvJV?=
 =?us-ascii?Q?rwftb+UzmxIZH3vmwUILaXCF6eF35nyU75wS0Uq8gwNnD+Pa7jnQg1hQQXmz?=
 =?us-ascii?Q?AaPnt9PM3KT0aNfdzXtpd+64B1FNSk+YP8Owl/V1ERHqgGZikVFWfxKDg2d5?=
 =?us-ascii?Q?gdigTXc6g6yJaBPlCCipdRC/laathH7yIdLru+VhOvm4ruHdicH0n5smcgZj?=
 =?us-ascii?Q?g3vA4cSpQhiC43bAtzCLkJmiZZt+d+RM2++3eErJ7mfAgWZo0LA1ojWOb4sy?=
 =?us-ascii?Q?Spz+4dMpP6EaCSDO0kWeg/4qYXw+jmKJBz/L9ySeff9lxz2zmBfshatbipWW?=
 =?us-ascii?Q?0ctx9F6mxACwsEvEOx6FdEw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81e1dbf-3cee-4084-85de-08da5932c690
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 18:19:44.3443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/INzni9K3hj4jtZVtPG90PPIwrr9NzBbX56YzxLTcIE/kZFoeuA1OSY/WmdHbBCywS0iqiEUXVMRm2iFZiSAWMG1+Ld5Gjy0IAgYnxgB3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2282
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Jun 28, 2022 at 07:15:23AM -0600, Rob Herring wrote:
> On Tue, 28 Jun 2022 01:17:08 -0700, Colin Foster wrote:
> > Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> > VSC7512.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
> >  MAINTAINERS                                   |   1 +
> >  2 files changed, 161 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> Documentation/devicetree/bindings/mfd/mscc,ocelot.example.dtb:0:0: /example-0/spi/switch@0: failed to match any schema with compatible: ['mscc,vsc7512']
> 

Thanks for this info. I'll run this on my end before the next go round.

> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/patch/
> 
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit.
> 
