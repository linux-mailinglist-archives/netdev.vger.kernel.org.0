Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C736D37A6
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjDBL3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBL3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:29:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2092.outbound.protection.outlook.com [40.107.220.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C6B1D862
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 04:29:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9Z4NgEOR5ra+SnOXQVNu6r9pLmyQSvab7s9h+GXWOE8RBtQikIW8gMQL7E9/6ellNAYJej6gonUACLjGMKvP3rp9rW2+iNM0lCoHnZExFrJHmSDbcXJ2Uq/FeyaODxFU2FZJ5fNA1vQ/447c/6OyJUPW8WqPUNF6eVZTPY0XAxTAJ92/8XT70co1BGGcaRr06A4/H0EPD3i0OAhoN6tPDHlfetiLhm/WfwE6aPNMN3ZBySoztRVh7DS883LP5x4xlyTnd8X0SyTSORBHPZ50T/ytPZWbGSaAFfFAQRG3agcoBBlp/2Ubbo0lx9aBuc5CEm3wx4jm8mSMnjmsq8ipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v++XYN9I84j2QN8z8LSJfycPYoMXEUvgT8DP+dUOeoM=;
 b=eUFDOr/JwqhnsjkxrbGJnu4pUSEGHmbxuzAB8/GLfPDjIHnFf0oihIscIP5YOr8Xff8AsfJfdpqb5U85qdmwdWvXNSwEWrmdpRWWyAm2cRIFjMihs210bxkHgRABgaSgM8jzvaQdHdhnE9ZNF9eHsPjyhPpsJzX369LsPD1iMwi5/fz8++0hW6WTkEiemOFWWbnHUpIigGjuezvMoLl0W6Hcq2N/y6ZOAs13hBfQF5mTGQ3jK4YRBYIvT+GswxZqO7ielpQft6+dCBY5iKX0qOteKDdfJyajpLuDWF9drmxWCsYV3e0tS4bRKTgIooTlj4X24bvG895/lBbwIAk9eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v++XYN9I84j2QN8z8LSJfycPYoMXEUvgT8DP+dUOeoM=;
 b=dHoZm0i/dAI0/2iKEDgDbzSacZfUqcBz3lLAdeya+/d9ira2BiNpeCEIuf2BvD6jMntf5sTrMwEu8bNn5FhJcEEWIUVyMVRcadqAYENKTTMYG5BC54CrnmU7aHK05om9c7BqN+Z27HsSKefNNmQAQJRUjmfyq3+Ix9ngdf7qwfQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4858.namprd13.prod.outlook.com (2603:10b6:510:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 11:29:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sun, 2 Apr 2023
 11:29:28 +0000
Date:   Sun, 2 Apr 2023 13:29:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/3] mlxsw: core_thermal: Simplify transceiver
 module get_temp() callback
Message-ID: <ZClnETy6m4pFrHyV@corigine.com>
References: <cover.1680272119.git.petrm@nvidia.com>
 <e0cc8a345cb5051aa692422340d8810e99152c7e.1680272119.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0cc8a345cb5051aa692422340d8810e99152c7e.1680272119.git.petrm@nvidia.com>
X-ClientProxiedBy: AM4PR0101CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 0facf496-3d1b-43b4-028d-08db336d8537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xws4IxAJHwpw+mK6Uf+o1Xtr5qXf2kyVMzRi8Ku1Haa3EwSTdYpxgcMwxs6940fGpqJiMxCdmsOCMbwlpd6Rgs3fOW7nvlOYSm0RQOsGbvgi5G5jcpZ6bd5ONuOd2Y5MEiXic8WijLxkH/UmpqeWVu2KTjHGYK+ut+cLKEgalkdYlJJb+57UrZdzNH2U2UTWmtRpploDlLpUbS9eG/lBYlB6JmIaiCxKqDF/Yxg2+IijPX79ZEmoOmqL/Y3WG3M4h0+Xchh3oVHsKHaAPaFc0eGqvNA6sQlhrirL7b2T8EfgF/qSRF4D7HASG2U8vRcN8lWubbg5sKizhpKNyl7mM1ILXrQRPBGHkdy7fjkseFBSMdsMF6f4XRDZK535FReS5UgYyWOG4wzGeayUrSCw3P5VIVXUCZhdCLUKkSKb7YnYck927jS2VZDnUTP3rPJBh/0qggbmUSt1DAfZtKJb/RTv5cr5jrWMIMAQodhSCCjtH4VJcgve3mgcLmP/u0DMj4NRsS11Gr7xQ6ODaiG6Cp88kpIxq9yFR00xbdsTMyRTROqtBq4rVWxMWnPrm2YK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(396003)(346002)(366004)(376002)(451199021)(4744005)(2906002)(6486002)(316002)(38100700002)(36756003)(6512007)(6506007)(6666004)(86362001)(2616005)(478600001)(186003)(54906003)(4326008)(7416002)(8936002)(8676002)(44832011)(66476007)(5660300002)(66556008)(66946007)(6916009)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oixVHRwov63JF/nUayOlIkgFhj9SBb0x/hDezGfHclp9GibblIm6/2bNrhzc?=
 =?us-ascii?Q?5B25crECgIrcURjgi8fUPuK6pYGs7SrG/UkMlqpze+9hQVzRLoQLGJ+4fEfl?=
 =?us-ascii?Q?JGMIP+foFMjv0k2JgeGn5ZmO2hemtOI7YXNhaFxtzW6Bn4KnR4W6bQw+eGJO?=
 =?us-ascii?Q?KcPqyvmIGOzZsiKps019hgfDosIQpmi1v9A8T3noL4KudlslkoUKriM/nZ+Y?=
 =?us-ascii?Q?ultk1lpja37Wz711oSGXc5k7NlRzKrDN4ZCF4F/1KGZb1gUbGIfZYsxESP32?=
 =?us-ascii?Q?b4P1dtN35Tmb15J8SArWwFvhCIlmo74AxON0LEAaEZ/eCsrRpZl6xfOnILTJ?=
 =?us-ascii?Q?5MQ3uIo+tWzW7wPhUb6oqbuJ/PWY4stIUzMfEn7GH26MG5jFHcP1CPQJOfWN?=
 =?us-ascii?Q?GfXQCW3ulNDxuBxLKKY2TRFR8kqXsoX/eu2w5uIkx5BR49M6t15uWn3XMuHS?=
 =?us-ascii?Q?lTY5vIv18VNs8orpikhiOeOvCcgvNYf4J/Unag12WvDEhgMzlIyXDwIN2I3B?=
 =?us-ascii?Q?DHID2ZnP9H/w66rP4E4BswIwAqqFr4Ajweb6+6pqyzq8NafKwvRyTBUJsQHS?=
 =?us-ascii?Q?9YlaWIwcJ528ve9uuTS0/b2SMaONWFGb+sB9NGKPJFXU9TWBwcomOyWh7feY?=
 =?us-ascii?Q?ZRaAdzGv9agCU2m7yyRhP7P/aArRINRz7m2sJfsxnf+gs3YuvmYIu5qVi+gk?=
 =?us-ascii?Q?4CwPFSL0Vt91VQOXITfc6v3LYwUwD6SXh7lplk1fg7KKZUGrlrL8v++9hd6C?=
 =?us-ascii?Q?WOp7kMi01yLC+tmM8feVwZqntWmSXqitjNxdzBtUc6CAvaVj1zWlgQWhgwb9?=
 =?us-ascii?Q?WN2Rj+03+KodtD9rozyZZjxdZKB44RS2136jx/QPIe7XT809iW8Z8hJm/X14?=
 =?us-ascii?Q?Os2cbJ/lPUsOXalb4SnFn9ztoh9tMNcFdL/LOca1VZkctcmcjuWIJ6XyWcTU?=
 =?us-ascii?Q?iobkdOwTV1ewZbF0UbdMw96F3/vTm1+gldUdKHOCuqz4ucBc9/5lQ/2XNXgL?=
 =?us-ascii?Q?xToTJJ7OZMaN1KfGjUnqrgSMWIYz9FVyD6mjlnbSvbspL1oy6wuq7UlTzRzw?=
 =?us-ascii?Q?mOTymGCI3d/qq0hXVk5naoxPFHSLlF9GAX3hpn9v4sf03hIBqXloitqg53t7?=
 =?us-ascii?Q?PHDaJuKnAbGX4yrRm7h4Xj7vQxqEhhi/4j3aZhaTvJN1mRlCQpElhR9a71an?=
 =?us-ascii?Q?ctJg+ZmQzbfquN8NaOZbmbCbESj6n4g/YD9F6fHVyKfR7FaG7yMltRwuGW0F?=
 =?us-ascii?Q?k8JWIl97jnWAhhTmEpn72hmTuPFB+d1YgxeScVp/qxVdbf60zYUSsySRcxDg?=
 =?us-ascii?Q?HQfYqbn6HnlQE+NNaMz4/avfxqxvIS0KWEl1upvu7tEIAQL9R6GXOFNEh0Om?=
 =?us-ascii?Q?qLzr8uqBgmmhAZV8zbigk4zRXfZfTC7Q/+rvI/3wcf38CeiSK/0/CNwoSJaX?=
 =?us-ascii?Q?NocvsCa92ZCKc9wS7bn3nmxHuaqpZL5STe3VxKcRUJ6YAD2B4F40crtFCU4N?=
 =?us-ascii?Q?GSoAwsolUGC/wrYdA/KAvW/tHF06e27rd3Nx+B/8E1udCG7HIt6FnmmIA+u4?=
 =?us-ascii?Q?8mExlnHEJoECRAN5AwCUmh96/paWK0VxIhQW/G432BfyMicv0JcKl2avBvxP?=
 =?us-ascii?Q?3FB0m63JT8nV0UMHNoa2D5gomKUvYTe2cuAYarcT1zRPo7J6Sl1V1N/QzzJz?=
 =?us-ascii?Q?nH8C8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0facf496-3d1b-43b4-028d-08db336d8537
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 11:29:28.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mFKcJx1Qsy7ESYfKZtFEOO6eB2bA3rUtiRtZYBZN64jHp5k8AA3a8LTx1GsN50CW78FX64bvbjHXGUP2f46UCdkxU1oGilVqCZ6V4Tchh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4858
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:17:32PM +0200, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The get_temp() callback of a thermal zone associated with a transceiver
> module no longer needs to read the temperature thresholds of the module.
> Therefore, simplify the callback by only reading the temperature.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

