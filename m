Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3AA6C6D14
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjCWQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjCWQMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:12:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20727.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::727])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D111235ECB;
        Thu, 23 Mar 2023 09:12:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrTt4o5gpGn+fmnnz4casTHSmfIMQRUJ9W7NKw1aCtihAJ3aoz5BjBpNO9NnZ/3OUwJOneWN6mdDlOuc+X2VbprWllJTt/tUc+W7PjpP+rBhTroz3QBjUzQmrqWeF7DSQh+ejaoH45WWC8F2PD2DnHJX/nAdwKvBGP6j/eemIQmO6dYRemdcz0R79BiZ8gLA7R2eAgxqqN9ENuXSaa9Qkzm6lWB/CFCEBJ6VA4kgUClRyWIr0bGezWnIbVN+wEWhYPzv1LcmxG+dIqYofUgs2RPpq1GzpUhzdNFB4LsAwbHjHWD0/zcGtO/Haz97xqmDWWTgCdy66WCnsliSmqA3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BSbPBXEfrhdrl7wMvAfSg3L+M99qqvGt36YvYYpRJ8=;
 b=fs/5PRSVXN/WcDuLp7gBc0k9MkDm7x66eExQIY2D0lFA/DJP32AlHwaBOOMcqrl6Fdm++/mIC1bX7Wat345NqDk2EiUDt/n3N+YDS6vdJr9UtEfwztjJG0rWLf8nvMA8BTkMfl1QjMX5wwvtOrBxtZ7IHhIRtgXzLTkxy4FYPDkIwG97VosQtg5j7LsWlsbWQ+aEYSn2HEsT36cxxdRlw7BEwd2kRnNDdPwLw1fOq0qv16oD47bmVXP9UokPJKiSofxUx4lbYWYUFMN0H8VB6MbY8oaGQmbPDg0JIJhs2n7lzKAcG2SHpGX/H1qeSCroQ2LlAmGRBVn5D0ojSkL8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BSbPBXEfrhdrl7wMvAfSg3L+M99qqvGt36YvYYpRJ8=;
 b=UvK/mEHQqMUenz+Cr7tL2RNKvy0Km8IgM4J+3ExdqqB5w06oKhsKg/shxjjNJQu5wV7Xf5pA5LvMJ76J6ea4CO3eYfBEjNYeyVOzv1cINNvyzEaCP1DngMnzPT4kFgtuF7NLKM3BIv92fptcLURyul7HMCO/Fa1nGw+93zmgF5s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4435.namprd13.prod.outlook.com (2603:10b6:208:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:12:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:12:34 +0000
Date:   Thu, 23 Mar 2023 17:12:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/9] net: dsa: tag_sja1105: replace
 skb_mac_header() with vlan_eth_hdr()
Message-ID: <ZBx6a5KDKbvYBprd@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-8-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P191CA0004.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d17a76-6170-4e81-276f-08db2bb96935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/72doE67oWevrGPlBzJp4cdXz/NIVeyVM8eVYtZfycjLIXiHfSPpunWqCYdTi6lCGHRmn4Wk+GDWuVXtAek31cXQcbjkrzKx2L/bX/advukivPFCmepNq9hK2eBKHUJokaSLP8mwVzB4A8ARfhvf7qdZhhrF465evGWFQ3qmbx91wgcqXDMkFkXbKH8+RKkyvUzvUbGZXxumvOGuqthl9kVWJVbnoKBEI9seTLfZgxobeMpadKtbuGUZD+FZzZNktLyDipO6SOZeM/4RzTai3ZzLocZuA1y6J69qPQgZJ7v0HkAhu+5aUUXS1gaNclw5582HuML2FoUO2fb7vgJkMNaMS0QQpPzV2tgwfKqwWgb0ncKKtlSOOhEWD373ItNOXEcniKLmXq/713XGhCGJj3rx245PCwz9bDEg4wieXrz/s1zKnjFXJ9Mv+3UrdhX8BtyBXMqLJ7Wj5p9urpoTn3DrwyYBuvQRwUB/z+P715pGUtnv8lAf/t/OetYZyTdO3HGXI8JTKazG2Ssfj1GQoHMzdYg0L/u6cOKZrW6d+DJYPbK7p0qIQsk2yQR/2YdC0S6D+hTPoSXDXkGCHOD7t71nWUGEsBoCjsMexnOsnpEKCm/n1/2VDPphDd3caT0MwQCy33emFFc5gsR6K49Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(396003)(39830400003)(451199018)(38100700002)(2906002)(66899018)(6486002)(478600001)(2616005)(186003)(558084003)(86362001)(36756003)(316002)(54906003)(66946007)(66476007)(8676002)(4326008)(66556008)(6916009)(5660300002)(8936002)(6666004)(6512007)(6506007)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?axjQX2OFGtSrkR804pycA8Sb184S/qtZI7KtzZ/OfD6Pyf2UGKrtzX7I2eIH?=
 =?us-ascii?Q?aawdYN/RTcaj23XVE4ITQ4TvWwUcY1CSRl7a+IJImMR3Ws+zIJ6zF+FPd0fu?=
 =?us-ascii?Q?ylL6PxuyzHVxCs0B3Tk9qevg/FcV6cyXe4Bl9bx08+n/oUQKnWerv1ZxofMh?=
 =?us-ascii?Q?muL8gSi9aRXQcQE2R9GgX7/Fle/HMaYQAA04tjgKecM34HvrD1yNqBceRDE7?=
 =?us-ascii?Q?yHPEoDhC5DBNmTUXFb1ZsQ7t2cMcZQJZu+OqmOdY6RxhfAfOW+AjG5WYLDDd?=
 =?us-ascii?Q?UHDzxN9207f78g2BniGRCBZqitj1/p/KPzYBtb3+39OJcBd8mz5LTX2O9cC6?=
 =?us-ascii?Q?kdmOR18Z9+ngVgH/uxj6q8qkDE+GNrDokmb0SZRwryN5RRYof5O89KbFgL08?=
 =?us-ascii?Q?iRut9cn3jSwl/WcDRlVQdOfmpMpMrbV8vVQ0X9SSPtddl7T2qishoBeava9u?=
 =?us-ascii?Q?UFAjOIh/DfyXNABaihCRFY3xywd3RYlQ4yNTueeSnAZrkrFG5diftZrzLYLe?=
 =?us-ascii?Q?8CrR7YEsFzuz191VPVVCFtrTztDt24D7J7NtDyhroymeaqhyLOzfJA6wKPQ4?=
 =?us-ascii?Q?bvmoAoTCjCRROcLZCEs2hbX9V7WIsRpkEEpkeXqptkvC8oh2fATMCS6BnQ9f?=
 =?us-ascii?Q?kzNMBtIjICHqurEwCYgDOpJe1KczpRBagez0SFa+1293laQEf+oIKFxcHvM3?=
 =?us-ascii?Q?i5wQ3CQ/nPTHNbGKug/LdbrlWmq807KhCrAPRszeiDxQSk9yPsvYhZ/Ua97e?=
 =?us-ascii?Q?R7289qjY091V3Tp86J0PpN2dw3ar8vlWplsYv6Fkz7L5k7CvqmvBTtvGVN7i?=
 =?us-ascii?Q?ZAKUUSKiCj6XoNBKLBn20s5Dm+h+pOvQEbhsW25RebXcWmsB4zBWcPiP7UDB?=
 =?us-ascii?Q?Uel6GQcmfzyhbgBfdnzk4hIaJFJ24mbCtTX7+qQ3jeClccBPp0Fko5BpIPwd?=
 =?us-ascii?Q?pz/8C42UWM4StGvzKF4ylzMn10MMGXHaMd7MrhUy5rJgsZcEFsuiD1qcaK19?=
 =?us-ascii?Q?hwQ33jxxQtZoQ1OWHY4N43aNJkNHDNRbVNGu9dK3fkxv/r9kRScbOgX0AONW?=
 =?us-ascii?Q?Oo2xWAjHeDuBsBhYOM3/G2ZmDH7SV96oLqs2LVKVrSuMoj/J6btOz3Hwp8HT?=
 =?us-ascii?Q?lGMQyL781kWJxzzeeqMyRM++HKLXY9QD9abhjvCls9GIvNKrV3aMuVMoDbja?=
 =?us-ascii?Q?IoTPaNUUGmRsOnWLEAqyCGYOvjfeJWtPP8R07ixoa18eoU5mBpTlse5SLI3P?=
 =?us-ascii?Q?ldE/Cj4mHNrhre8yhy8XpGBBnknGTzHgx5iB4iH8j+CS+jWgIm+QqPpfSmtO?=
 =?us-ascii?Q?InJInu5UFl87e2+VbV9pQVj37UiBEMV8bE7jpM1h6pW/IaakjI6GVCHYWXnm?=
 =?us-ascii?Q?SejYjsj0FSm0dRS8jj1Nojcg+trgbik0JdDFtej326y80yt8+aXihEXFziH5?=
 =?us-ascii?Q?Zx3SWqQzfTwA5rUT75waLioIRCnee8OsGBYRtQmizIK8G8sru4BkwwFoXuV+?=
 =?us-ascii?Q?OJqj+k1WYc6y8fsGbRO6BgrvaMwDMO3lEGey2T2XJL3SFBK5pQibZY54p4J+?=
 =?us-ascii?Q?fkQ6TxAjr3gLTyx6x/IVnJ8msaNkOvdvbE5hJnm+00CXHrq+cFBFxLTHqARE?=
 =?us-ascii?Q?TCzqmsqW04A/a88JWIvnYidF72eO4jnsEnp3NIun0Ju1PDGGk2fgSQvC9T5y?=
 =?us-ascii?Q?gsFMsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d17a76-6170-4e81-276f-08db2bb96935
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:12:34.0229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbwW9X63Dh6d5/Vr6oyVHd4P5EkLEb2Iz57FCWb0T/NuL6vnWsx8bBqm+bL8OlNMWdywWgyaiR3/fNvHZqgx58OGyaT5yDFIyrqCxb/S1a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4435
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:21AM +0200, Vladimir Oltean wrote:
> This is a cosmetic patch which consolidates the code to use the helper
> function offered by if_vlan.h.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

