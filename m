Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448776DD8CD
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDKLFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDKLE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:04:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2111.outbound.protection.outlook.com [40.107.220.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA5644B1;
        Tue, 11 Apr 2023 04:04:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoOTrUrGQdrXkYdS4hYY70Ca/LdlIcQnRp4KEaoTArahWzrwmVG7tWYSLe5uNSkhaT07UY+ZQDSluImAnpURSAA1fkfP0o3zrqKRJxNcsUIDfeW343rC0qqweR2UTKzPK+EtmF63QgVcg3OyaSAb5YyBE6cve90pdoo3tyQ8zJ73pg3zKCDL9xIfrPs17Q3cT7agXIEenBHSyzxMQoKCbcOt8m5XWIzBsYHuP0Di6Byfp1dTfKLkh2m1y57gdqxw2ejM6+dUFKAhtxMSe+SiPLh3KM0MdQdFYp6yLVuBtKa6esYNbb3qsaH53i9NcIYY64ByT/IFQrIdsFBa0HtMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsNoXHXxDD8XSYx8815trC1Os5H/tWtiYX6uEtSZssQ=;
 b=MN6QcQLQPMMrT5MYASzcBtgvfGrEPJkKg+JfmMR20N/3nCRA5iuv93x2Oq6IPzz8oNCUWeGLdmoAYTlgOay6QT6Tf6lKPxnF0zTO4vUfM4Q92s1l6uOhGDutZCnxAomA+QYvUmX+Ru99odnkUdhlhLch8br65tN6NtSXywNtInRY/MHqS+lrnVi9MscJw7vB67cTIvr2jsGjU9j4/9WpzAqHoYX2hIQcbCl8rgFh78Rr/0JZLOY9i5uJlg8doGRc9zE8mt6PJWeJVeIJpuLG8u6MxOrlhYwmgF5wFeDCzoo84Eja/7cH98j0qYcIZIyO2kIphcfVVB90gCPhaZ/MAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsNoXHXxDD8XSYx8815trC1Os5H/tWtiYX6uEtSZssQ=;
 b=TuSunY3C1YmhZpEAHMtSLbnj9N6p2A0yc5tFziMFSZPq6wdD/gJMAUGZ9oe11Gwu65W6n2cZsJFz6CGbouBL6xndCehn4gZ7HlRsdGakNu9NJBeRMJqT4/N3uKFPNEsze6nlG6IEue4noJiFQKZoQz+gW5kgP8lkkoEJms7nUIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 11 Apr
 2023 11:03:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 11:03:33 +0000
Date:   Tue, 11 Apr 2023 13:03:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 5/6] net: txgbe: Implement phylink pcs
Message-ID: <ZDU+f7aXvXcmSqnD@corigine.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-6-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411092725.104992-6-jiawenwu@trustnetic.com>
X-ClientProxiedBy: AM3PR07CA0074.eurprd07.prod.outlook.com
 (2603:10a6:207:4::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f67cf57-9a72-4a4b-d44a-08db3a7c641e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZFalJcwA3KlMS8PiI/v9SUM5rWF1Q0u1rtc6ijyscv2etOQbj4GkQLzqpxMd9XVRQ3PQXNdkk/efTq5vrj0C4+li34pzxoTcHm1xa+58+nCqxwt8HVrNjArVhsPo0KgPO+7QtjhYgeKnR/jDqCEgmiSHFd8aUt5yUCORShLv1zS+jRGTicG71tzkEo2tegiWm82bO3k6uaZSrd9dz9mzBn2rPryMJlAczfIEcAis+uDcoS6YOCPuJtt6j+IKwggjNucydAckFcSwrO5kIEUED6ob4SKXEBSt30X9GNicA6Joo/aSaLSnNtg7Y0nPCxcAmHy7gUNnBEkQ/gmtke8u032Tkxvpg/jfhGwE78AmqoFAbPfxtmm/fuGxz11AcnOu9xjYTRkMH81rly2r6JsSGxehp0hyCfdCx6JMqO/eIKY7P3iV4H9gMWq7KqVKNizaVfPj1eDCotXsLmC7UGE/AAKwS5M+SwVJOnS6wBlinM/6hN3qZxvSA3eQU6ioJdzEvRcDwIUNocVMzwfwXVqOBFxY9BR2cXXj7zKkAckmmmrV35Gd66OVenvblYLgLzAaky00T5lnVoeOZkIHih7Tnsj85Pa+utprjKfBI+0xPA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(366004)(346002)(39850400004)(451199021)(86362001)(2616005)(41300700001)(8676002)(478600001)(316002)(6666004)(2906002)(6506007)(83380400001)(6486002)(6512007)(66476007)(38100700002)(36756003)(8936002)(66946007)(4326008)(5660300002)(6916009)(66556008)(44832011)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0dRJkBcFOU8mVUbp5gopwiNMs41gejNNCn9Wxvs8xq6d5P2ffALas53MPiEx?=
 =?us-ascii?Q?MmQxZF3pRai4OLudALlT2tLS8RJNDcNcquyfcyZcP75yjaoDk9oChMpqRxsO?=
 =?us-ascii?Q?Lx0xa69U/3GmAtM3TOfjQGIPKTjMlrX0eLhilgn8xPyTeUagfol/Tqthwg7N?=
 =?us-ascii?Q?E+fRxPKLiI/XLmfSH5TwYBUwsZnllKWcOuoA6NCrh6/B4uDqmJAiIx0wfUQp?=
 =?us-ascii?Q?I/ZrYb9e6W6bf5pn9xrFRd6cBeOEbFH3LWt58bymLaS6kfTMJN9F4efADPVn?=
 =?us-ascii?Q?oU/f58sUzYVIq1MjwKYdjhefS2JH2zkfo3mhkEMa1/4TIMpJqXx823vnoJiS?=
 =?us-ascii?Q?NnG235AhouW6oxE9qdNu2qw/Qtu1aYKj3V2BYCf9JTIrtu8fbTfyUukonTT5?=
 =?us-ascii?Q?HgDYilDgcPszVcF8UyrpzIptDenVW14FagttGb/KtSZGEHA2M2PAqzT21THs?=
 =?us-ascii?Q?yk1wsIUZhJIniTSdBdyOL4N7GIGelOOR+uSipRDvWRbIXIrz+B/ayiSOOSGE?=
 =?us-ascii?Q?jTwXiK408OqidpEqHhPuX+lNagvhgU53G74eQkdcz9ED/V0QpQ1CCoRbDGIS?=
 =?us-ascii?Q?qsehaFekwydm5N0t9a5OzbUK5ORN+ZeA9eSOTZeZIN9AtEGkKoMX/T1TDnhT?=
 =?us-ascii?Q?Z3Vyucj07u59di1vopiivYhc9D03iXyiLLENz6M8SW/GSaV/6TEkGcK9tnRL?=
 =?us-ascii?Q?86jfwGw+soDtdLcmaFCUh7mBzKxiIhYtOfhCyMXgGSoTK+Wpz11Tx8+OSwgl?=
 =?us-ascii?Q?1fJahp+4L3H272XIiS9s5jSsRhY6FbDIEECDaGe40gCaDyJzJnjFqBj2QtxM?=
 =?us-ascii?Q?Xaghtl0djbexTVVpKyT0dAQQpjVCFDLO6Gcgdh4r6Qpz9rOrZTdZiAg/0Hcc?=
 =?us-ascii?Q?65TEf+SPJ7550gfYRnfTWaAxARzG8sPJOtHW8kWXfzrk0JqMNLNxQ9//akYH?=
 =?us-ascii?Q?+fTsXouGLUT1r0q3NIxy8KJuN2TFXfKZMfvqPYu0S/lJANy3WKLL8Ox/K7hw?=
 =?us-ascii?Q?KFzopk5cWq50J9oe76Phh4E/11DIUpCy4v3055gB++JtlVDH/qkNVL0j29QA?=
 =?us-ascii?Q?GqeKK1Hr/92l9QnumHFcCebhF0a6xk6UTZ5fvAYCnZKAz76dg8/hKB/kJTJi?=
 =?us-ascii?Q?CB7KU4c4MVoeNmZNodPNuAT1ixTACoRk/DC/brYaQ05KzZXioQKYPosvQJdI?=
 =?us-ascii?Q?t50JhzCJAcsTL9yCfxdbL/jjlWfLXCKnzmWJ9XKKcRhSPE5JwVjazy7HjtV4?=
 =?us-ascii?Q?L9DE9rJKB4BIAphOA5qK7T5agx9k+/AJi9l17xQ29vC/veiUxORWL/hkYoTy?=
 =?us-ascii?Q?7NDHLn/64+29VmXirni+qZYergIbJ7vKvTXWPzF8lFp2CbutnGRb12R8HW/n?=
 =?us-ascii?Q?YP/mr/hmCuMr1wtCtiKZlggebY4kkggx87uDuyGFLAvht90PI3xHfYB5lJVh?=
 =?us-ascii?Q?OkRJxlWKIkOHkxanz1lVp1YgAsR6m2HJfToJJwHfm3eTxJXo7req1VWArzkN?=
 =?us-ascii?Q?x9j6Zoxg3Rr8cwMKjIjVRq4ktVm2Hw7hCPjmY/KBp0kyeV53vcCN9h8lEiuE?=
 =?us-ascii?Q?DD5fC8WuLquAlBaSADUPe6++/y0FrjK6pHeUpxpHRQFwhjPTI0DuIXWw412L?=
 =?us-ascii?Q?6bKj8dciUbf97mjs7h3UdjcAN5THRsQ4TjzWNWMu52D+WL1rJZUCGmQ36gXt?=
 =?us-ascii?Q?3/Aqyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f67cf57-9a72-4a4b-d44a-08db3a7c641e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:03:33.5503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Jjr85j7OkxCr65PMY4B6U0AaVxDTwqq+hn5NBnMQRBi0luBwB6Xeys858Vask/3R/eUh8cBBS9oO7/ic8ctH57D2W+Gkb8r1Mt3bd/Ygas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:27:24PM +0800, Jiawen Wu wrote:
> Register MDIO bus for PCS layer, support 10GBASE-R and 1000BASE-X
> interfaces to the controller.

...

> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c

...

> +static int txgbe_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			    phy_interface_t interface,
> +			    const unsigned long *advertising,
> +			    bool permit_pause_to_mac)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +	struct wx *wx = txgbe->wx;
> +	int ret, val;
> +
> +	if (interface == txgbe->interface)
> +		goto out;

Hi Jiawen,

The out label returns 'ret', but it is not initialised here.

Reported by clang-16 as:

drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:270:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (interface == txgbe->interface)
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:326:9: note: uninitialized use occurs here
        return ret;
               ^~~
drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:270:2: note: remove the 'if' if its condition is always false
        if (interface == txgbe->interface)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c:268:9: note: initialize the variable 'ret' to silence this warning
        int ret, val;
               ^
                = 0
1 error generated.

...
