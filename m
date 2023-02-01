Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562D96867FB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjBAOIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBAOIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:08:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2103.outbound.protection.outlook.com [40.107.94.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEE544BFE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:08:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ilhm4AiY8Mz7Q1C42tic17w7RhSv5d0/5mQcC3kJ0mffRpVpKJGYdUw87UyUUpdLlQxPGHTbjty/JpEvH/FO50bp6cnI1TVVJcq/V1tbBgL7eGxZdvU3grm3dTrmGEZW9UY30xIgoXEo5axom2J5uJ7Si2zqjh+2AL8bujRURlWZDerN4QKP6ep6sBABTFOv+/teYoSS7NDOmx2cX33mqgP0q3xwqwzgVuMyreVRSTvdbefkvVeAJTN62K0ALDHRJHBsoWklT0nu9i8T8Vh6L48VD4zsatq4SAPAIZu38WoANH9GQGJoRwAkPEzgWyMQ6g5s2fCRkH4dGML7n6cp1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26HGdaNADhfMLr/VXR/PA9jl7WJS6CxV33NRm+uwuCQ=;
 b=DBzePmwNmCR+KgfhUysZX1eCis04Rif/k0NMqcQ+lbORbp33cLtdqz4I26UK4cgOmi4GRABgtrXDO8zuA4A7PMlLO4QzMv7y0oLBv/8FlSJX2sUTGGqUL95285XeM7tYeF7cqdO9LfTfKbBD6u6vhTDSYkG3mXmrhvbbfxN9XySokVDZOQUWV2/eW0BMu3Lqwc6E9garYIP0PfmsK6H+8Fzyg1T1mGjt4SDIqg+zn3egHL0BwUCA9YYGFO718yf2Dgcm1hZEOKFsKMGd5O2oXjI8gsXTMotAshghBADwxKTgfypJphQon3CKsQoTD+MBoXXCslctRtsEZVj1L/JEmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26HGdaNADhfMLr/VXR/PA9jl7WJS6CxV33NRm+uwuCQ=;
 b=nuIET5waivO7PZPISf+zmAQVso2OcRf7AMXKmu9TYRCGigmN9WwInVgMtrVJDtjMgEyCpGKjLeImLLDXuJ7EiJawYxkaCLf3j+Wi0M3oOrzpJkZy+C8CvqOVN8qM7iTZMruXeDuSpei6xPQprVOdd/mIaSlxAOwOiZzblunNgEo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4861.namprd13.prod.outlook.com (2603:10b6:806:1a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Wed, 1 Feb
 2023 14:08:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:08:46 +0000
Date:   Wed, 1 Feb 2023 15:08:38 +0100
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
Subject: Re: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading
 drivers to request queue count validation
Message-ID: <Y9pyZgIt54tPGMPW@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-9-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4861:EE_
X-MS-Office365-Filtering-Correlation-Id: f6762614-390d-49a9-cb0a-08db045dd554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JREXlYORjxd5SoyLbeSqYN7OTROHuIvvoLWGksUYDxmkWylSvoY3/nUD8RavfbeWOwh/IX1QPPAQ1Ifiks28+/cIPsOuxqVHruRbFlPojsV4lZw9SaplwjcTn4jmqFQB6r4/qa6rCrgqALY1pP2QBz24xiq/PEGo0LNK2WSaqbTOkrp9GtJpiBtbE08dMKvOIqRKyoitEj2uazMbRAs6kIfKn6E1Xu3Rvt7iXkosAsJT9H/q7S3k7VcXzzllMwmqBjjafJ4LwEJSN5UXJXR4TSL75UZyLMd3FPualLnhlOgkQLOMTBB6nMXCyjOlrlZW5iBI1QmcgSakoq5wblbvrEPOBhPjwtPbMXhgJedHS2WDgLOC1YKdtDltRtYg6n8BNpZNenQ5AMGilgdAEQX+OcASHaFH0mn9fuY3e/KwMU+JXsCH7ELQcDLPWwZwmhc3xSkxcDvo0eiZfil0SUH8ck/ODhnw/oVAIVhUZPo5hOTKtgD2ZqiHfrMcpLmyl1By+WCdbcDwtQij6/60WnraI3yQhgNM99jNRFQ1Ys2a6tufcNK3nYVMKe6mvG+3aAw09awtDPpJH103AMeplWcDlZFotzh9Clp8MvHlaPzmurEkIvZZhtE33fE2IXO7rU4cjWgy3MoEa5EZeEhsJzoPlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199018)(5660300002)(54906003)(7416002)(36756003)(316002)(8676002)(38100700002)(66476007)(6916009)(66556008)(41300700001)(66946007)(4326008)(8936002)(478600001)(2616005)(6512007)(6506007)(6666004)(186003)(44832011)(86362001)(4744005)(83380400001)(6486002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aIHP7p2YP5MGB/Ca5R3z2tHorTJ2I8gXNbGWevn//2okQgNzrRUuetzfMaea?=
 =?us-ascii?Q?I5wYQiFFuXfcFFhXMTzOg7S6VieN2OaYM7jQsUZbSfMTODe8T8nOCkqSyqa5?=
 =?us-ascii?Q?0Rb66fWZ3LnpAb8Z/znjEiBTGqtWznZ0aKYh3tyMsBn4/SSVSrsXwUScQv5/?=
 =?us-ascii?Q?DO9sI/ItwnDVHA7i5KtcE2AmQasjDjEwZUsS5GUNYFRZOU+WJanNMN4/z/xb?=
 =?us-ascii?Q?S/niPte9oqEHU9r3vmS/H3p/pPX9fbHXWG5QQ4UWwmaB4feUD0tfC6ACtvBW?=
 =?us-ascii?Q?C1bFdak1A6OvX8tkt6rRacVXMTFrXIzAgmFs3P1X3UgTwW0SpLDHImAjiORj?=
 =?us-ascii?Q?lun8XqMYE3ROUcLGvTezxuVz2kXGkpMV+98W61/HcTo+K3jBVd+TgtWGsxIy?=
 =?us-ascii?Q?Wa5PPzHPR3VLZoWfuU4C/YOp8DnbDe3UA8VW6BYRQ+LkuIg/2WtPNZ/UFm7C?=
 =?us-ascii?Q?stsQMiVGsELqJ4VVSMZtk2vzQ/LsHfUuHN8ctvXbckKLnxOk1uFSOWAJErRq?=
 =?us-ascii?Q?8IZZ46O439cj9kHJoIA3+PPWDAxQMLxyXFJtsds9w8q+fKucOe0v/qmY0ujZ?=
 =?us-ascii?Q?D6W0l8bCIB2D2lPbplaUKGleuQ3xXkm7cfX53WUYTdNjb3jQUZdE8gGHdtft?=
 =?us-ascii?Q?k9+GSFxC5a9YlNCNeMsuCx9TNtqk1S8bPw/pmegeyk3dIw9bmhnV4Iw4dkuS?=
 =?us-ascii?Q?jRKb5SDH9uN+gIUOk4eaHCqPP+pmvZKISjy3FksyMFpcRJqp0ok0ejQBdQqO?=
 =?us-ascii?Q?PlHDYsIpab9l1o8xM9fZ23bU0ILHB04ihLa8xlAjy2TJfg6Hrsjzc9Us/tC0?=
 =?us-ascii?Q?zEz2sDZjZHChcjhQ/0jgt2MahJ1KVNEJWXJS9lQjjEsbDndE83NcGXEpm3Ta?=
 =?us-ascii?Q?hMWKXQn8/rZ74I3EuEoWDX7lQ2aCPFmvdprWBnvQmQhqZoMfI6pKkrZx/4rv?=
 =?us-ascii?Q?6vKS9q3jOdnx9WFsmKBO7FXCVcmFuyKodZ0d/LhjyGckUfdm8ueoOo3FzB9F?=
 =?us-ascii?Q?wqDCI6USmfoEN41OIQs0ETg1FpmK8mGRKqgNqM/P5lkK1x7lWvE8yiFV+q9S?=
 =?us-ascii?Q?Vi6tbbzkXpfZxCYEy2jkBDJxPTTlkK6dERNF2DNu3lfljDO9x9AWlMm8pQQU?=
 =?us-ascii?Q?c8Xwiip4/sooT2zit37sVBmGXhwRXK/Ehx08WSWbRCKkZL11inGd2nevbv2b?=
 =?us-ascii?Q?uXZDyhdSWYmlp3+qpUH0tH/6eedqU3dbyAayBJ97T524USynNE5OQvDtlFJD?=
 =?us-ascii?Q?kVRpow6TyEC+v/iOtC3G22A71ecruK7LSNdwfsEqWW72I4qhh/0q9c3hLKRz?=
 =?us-ascii?Q?jGZzqB5OMSoAHuUd4deRO0PFRa1CJWzbTAtfoklAPlW1RXo/MtlSiOGrq9+8?=
 =?us-ascii?Q?cvbWr1q0PUgwjdPmPliV9EoVzcnFYISajbDUaejLhFOLEof/4LvFheaFk7hO?=
 =?us-ascii?Q?ZAp3NH7kpE1TAcIy5AVKgYrqvxBrDarjL0dWxRh5DjxeISIZqP034+QojLIf?=
 =?us-ascii?Q?a5iURxbvsKpeQG32oa3BdS9UkzaLje37xMdmzUMkNGtqbib9UnVghFqH724z?=
 =?us-ascii?Q?tot9FWv62qRl9VOCfZ/kiSnk+P5x1brIbrUAaZPqp5SXbzjbYbFbVkwn0+q3?=
 =?us-ascii?Q?/ewliiJYODRhFDX8W0QN7uBoR7XoeikqSBA9DYo8FqaLkcCcSYsLzwp6CqWb?=
 =?us-ascii?Q?W8caUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6762614-390d-49a9-cb0a-08db045dd554
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:08:46.2660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHEq0GSum/tiLQ9JkCemVrdLhnmVIwFWPckeXPKFqMn5bvAjQbo93uufJYO4cTFTiUiEAUHJiTBzixf6Y17SidfObvGZrEbNfcUds6VpQdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4861
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:38PM +0200, Vladimir Oltean wrote:
> mqprio_parse_opt() proudly has a comment:
> 
> 	/* If hardware offload is requested we will leave it to the device
> 	 * to either populate the queue counts itself or to validate the
> 	 * provided queue counts.
> 	 */
> 
> Unfortunately some device drivers did not get this memo, and don't
> validate the queue counts.
> 
> Introduce a tc capability, and make mqprio query it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

