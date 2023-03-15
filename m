Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C386BACBF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjCOJ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCOJ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:56:25 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2131.outbound.protection.outlook.com [40.107.101.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283B36A2ED;
        Wed, 15 Mar 2023 02:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQ0OYCfkRwum9pSbpSNaLs4ZR0oITr6+QjCEdhG8352HGGdnVy54XLQBEyuGbaeYKRCZ3L+IZC2GSmXewjJGFrewNijTBofX4YWujIZD6QrlDlMtSyUPCuBLfrr/UW51YIDf6OEup996Sb0l8DFbBq4oxOxOUdxgWcCjEe6rcb1q2csnablQ+FLdFjBa8cTSjXbmLhLxPLDYXhWAr4ED2C0tRTwEOE0kWlGvKdVGva5pofmuUXv2ob1abV8f1v53f2CzVJNIa5vAGmdaUdIGXISO8Yq5DbGD3K2yNgoHn6e4iYb+AbwH2Ydh59IRqfuzwbhGLuwR8LQyZFGM9RZvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hl8gEzjMYoIkcsVWZMYC6HYCcq2Z0l9zRndB36CI1PU=;
 b=JXEwV4l824XnKs9zim/nFEKjh7FqXK6EduF8/6gQ9hShZWeM3TLWTYgHww7iYWa7t+9z9dDesq7sCCMszko3jDnZR0lzIc0hMqSLIFWWurACgr2YkWTvfccbjIEow5o5dMmL5w6aMYyg5oF6TW/wFm7SIvBy5tRNIch+zGev+iYVEUfB9HtTamqgbQGLqqSBiJhjkS7r4lMscuiWFrnqQPJeUPv71QRnPkcdsWHvSXGNetlQQIVxcNQtgnsmGun2O9MqYxiNVw6eD3dzUkoJ0hQ7IuXYaGi5EkU+pTQhNYFPfDOTxPUXNWcP8uBTbXixbW7cvk+XeDvN0zeQY9QLSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hl8gEzjMYoIkcsVWZMYC6HYCcq2Z0l9zRndB36CI1PU=;
 b=E+HUnJWUUyHaRgZcUsS4tHfLpoR06sIzsoJCacc4u9oipXEuTnjmVw1KrocyKCkx/Zft08AY4Lcsta/iYm4JpDchZNE7HArIYpeuFJBGyAbthofa+AkwzgsqCaiIRqcj46W9Jed+pHbv9OIMgtJOmwHbx+Aj3FRwG3n6SlwJIRA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DM8PR13MB5239.namprd13.prod.outlook.com (2603:10b6:5:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:54:36 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:54:36 +0000
Date:   Wed, 15 Mar 2023 10:54:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: mv88e6xxx: fix max_mtu of 1492 on
 6165, 6191, 6220, 6250, 6290
Message-ID: <ZBGV1e00JTncoW3k@corigine.com>
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
 <20230314182405.2449898-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314182405.2449898-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::20) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DM8PR13MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: c0fe7688-477a-4b5a-5a65-08db253b48f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2BZrWCDMY30GTVA/Z04FGoWf5473L7r2rErTNOgzrdgGhcae15fU0J5QzgPj7b1da0z5rUssV8d46nBFAMaTwuzsgiTDHTD97BfVDdzJ4d21xxv0yii390ziyKYWK9a3y5Unh3IBfegW5vsNNEkmwKbxAUSA6n7ElzlVTFbtpyHLwcQE3WRny2Ilwa5FZ52YgG74rtbplAppJx3r526ZBzvTMfCZh80s3YUQmsuCBKwbUt9jQYq+XT7queK7jMHTzxMUKp1Xl03Do0RnrK4Ry651p5Rc/JPbJY1+QGTWWvgBivedHdlWPjnRWh2vImH2/VSXNoV4s3E8BmEUFlCJCQ7K5r+em+kRRtUTICGm2WmDpjPshvCM6QR+CQelYx+t1bub/HasUKZpY4ZVIcHpibUz0K6MigROkvwSfSQ0Ndt60PLnlVNDps92Tdq641Z0AofUIx4BvVuVPmWDVDWzZ/8cZ8AIJA29Nm3ZnYg+gRxzxKiqJhRU2ACbettDH0jwv27f60CYEm5Z8WfngVbJ5vCKhhlLcrkvxKiUIih0255czZQ5F5ZH8vNvCtSqwGluhqTkjb3NVkjvcul0K3QCIe+4S7kU8mmSRcNzqbD8HESF+cWSdCj1Ekq/1IfHicY+w1j/MuzI4+PDLmOmmNnSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(366004)(136003)(39840400004)(451199018)(6666004)(186003)(478600001)(83380400001)(2616005)(316002)(66946007)(66556008)(66476007)(8676002)(54906003)(6512007)(6506007)(6486002)(6916009)(4326008)(41300700001)(44832011)(8936002)(7416002)(5660300002)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aXatHj1eElZybJCctNajc5L8AVZm90LPIKPOAk5L8SD6taD1HyNYX8l1K7Pk?=
 =?us-ascii?Q?KbTBtdwzoZtcp7I3wJHej+a28qjLte0M68ygHbvQubOTg5NnRWkusbgwH7Td?=
 =?us-ascii?Q?BdYgXjL52hg4ll6WDkjHWctGgBN2tDPI9Al050hanuA1X1qgwI5GVwiBuLZL?=
 =?us-ascii?Q?vqRufkKnMqy43IaQlBCWETLNYbuqp/2Nj2jQ8APxAeazZ8zlJxhcOG4X5cTx?=
 =?us-ascii?Q?W+aJPLAb95HpVBRzYpLBmMGZ9957b+XUbgTVi1K2WxWEm2lysWyE37pXXRWa?=
 =?us-ascii?Q?Q0Cveuru0Zf9vnj3bePZ2rIB38o2bcL8QFo8s28y9A6Tx55PZ2mRbxsUXzzs?=
 =?us-ascii?Q?NLwfRF/IZqx6IXaOeqy5k84qofDG+pgvb8nC+emaYFFoC3lu38HswKlZC5XN?=
 =?us-ascii?Q?uJHevXU3DqVvfx1Yu0eOGF6GvbXdy1JQQfaqDYeLBVwtyrlTpyuMru62nA/c?=
 =?us-ascii?Q?n5adj//DVAOGGpYkFTirGUo8Y8WU7axtA4hmlr1Xvcg0HDEXWDqWtibtiAXa?=
 =?us-ascii?Q?VfMQRfNhl72US++HJHVweIK7aM7CYcTnvbI3rbL2pFSOCZLX/n23JUeclboe?=
 =?us-ascii?Q?Bs/KJCxC80OlIs4sWWvPHLaIch43vdQc/HD1JN6SxTEsZ0wMPB45NxLYSAfh?=
 =?us-ascii?Q?At+4KLd6FCDKs6UaVxzpGh2U0dEbLS8rnEPD8rjo/KQI36AKB5pQE6y4bTUx?=
 =?us-ascii?Q?cmFlXMjz1GK4W6KrUkqi4O87ASenSmDAeEYvEKJ9MgtwLE2qLhfitSlhl5nN?=
 =?us-ascii?Q?DpKy3RvK8rAtFlDrmFx2amTrQ2mWCO7zoF+coCYKLLSd74uySgs8jJdl5xVW?=
 =?us-ascii?Q?1yBOFs6UD3JAjuuAniifxwE18ICEH2+ilmfgMwrvpPT4lQlLgZoC4kpVzjFK?=
 =?us-ascii?Q?wWezvnQJj0znBgvujFIFy97Xwxd/ox0OGFsxWXQYyWhY0NVAlor6Oy/uZFg7?=
 =?us-ascii?Q?S7Gow7feCe2Zd2u/0ebm37Z+CnNwOIIOZHsMMND31KFmDfnUTH5ds0RcUoyC?=
 =?us-ascii?Q?4QGB4yUWLHZwcEkgZ52uinsVt2cAaS729MfDkPkqmHbntT1EbKzA4yiBOmaJ?=
 =?us-ascii?Q?ma5RvTMV9D9vm0msyUUYgzbEoRE+06r+B41WUa+312TrYNb4XEHVeS3phqVt?=
 =?us-ascii?Q?Te+zU1m5eV2l9MkF0cZrj2OKgVNZ4N0hPpr+jyekDSLo5N6+DDncAwdMAAbY?=
 =?us-ascii?Q?vYeNwCFYGamt4+4Lmh3p6i02n+evHha+Ez/2ZOqlI74Xst/MnFvB9rs9XRiq?=
 =?us-ascii?Q?d7k8pr7fq/nvw6EuHVn2Pgg9NtQQc3jvD5RlNCxRdM4XVcx5jCehMaaH7PfP?=
 =?us-ascii?Q?/Vc2yoT50xowLn7V1rqTisiHQ0vSbKFD+tP9m2Irhnbf1NAYk4TFj2Kz3n6r?=
 =?us-ascii?Q?dcVeFo86kgE4tshPxEwY7To1X1J9cUVIzcjQ9JyNg6x9xGPQbGpwOpMyzwxd?=
 =?us-ascii?Q?G5unUQK7Z1F0V5jSYJ/0ZUSz/o1Knxb47W163VZSdw162+/nu+gd5Y0huN+x?=
 =?us-ascii?Q?kDVyXiZ8HGVacDPQSRKvVlWhV2wC835jPwbvmi2XW0Nbc6+e0IjD2GcGVIsA?=
 =?us-ascii?Q?HF3lXC2s4/tUQUlIeh12eVIZZwDKgfU6GB3V1f3KvF/YjvyItj6iOuNcycCS?=
 =?us-ascii?Q?9uFVh0IzyLu7xh+vqraW3/HyCl88bNvQWrxGJr0K10VKpIwlRh9aozkkahk5?=
 =?us-ascii?Q?eU+t3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fe7688-477a-4b5a-5a65-08db253b48f3
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:54:36.2762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WK5wLS3KjkNKLtx/SheJEOVzOPYDswdJOAcMV2fykalYkqrliLFIVzIDwlYKh4yc4g51jBz4LB5SmuVG8+TPhdkU/CYKfhoLKskYlDE/7v8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5239
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:24:05PM +0200, Vladimir Oltean wrote:
> There are 3 classes of switch families that the driver is aware of, as
> far as mv88e6xxx_change_mtu() is concerned:
> 
> - MTU configuration is available per port. Here, the
>   chip->info->ops->port_set_jumbo_size() method will be present.
> 
> - MTU configuration is global to the switch. Here, the
>   chip->info->ops->set_max_frame_size() method will be present.
> 
> - We don't know how to change the MTU. Here, none of the above methods
>   will be present.
> 
> Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290
> fall in category 3.
> 
> The blamed commit has adjusted the MTU for all 3 categories by EDSA_HLEN
> (8 bytes), resulting in a new maximum MTU of 1492 being reported by the
> driver for these switches.
> 
> I don't have the hardware to test, but I do have a MV88E6390 switch on
> which I can simulate this by commenting out its .port_set_jumbo_size
> definition from mv88e6390_ops. The result is this set of messages at
> probe time:
> 
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 1
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 2
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 3
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 4
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 5
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 6
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 7
> mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 8
> 
> It is highly implausible that there exist Ethernet switches which don't
> support the standard MTU of 1500 octets, and this is what the DSA
> framework says as well - the error comes from dsa_slave_create() ->
> dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN).
> 
> But the error messages are alarming, and it would be good to suppress
> them.
> 
> As a consequence of this unlikeliness, we reimplement mv88e6xxx_get_max_mtu()
> and mv88e6xxx_change_mtu() on switches from the 3rd category as follows:
> the maximum supported MTU is 1500, and any request to set the MTU to a
> value larger than that fails in dev_validate_mtu().
> 
> Fixes: b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

