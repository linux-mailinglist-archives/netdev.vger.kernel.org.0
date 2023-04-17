Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57A6E4A05
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjDQNf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjDQNfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:35:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2138.outbound.protection.outlook.com [40.107.95.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD77683
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5CaYSACrHRVS0bccfiWlReDrWyqxobB1hJ7kYD42XP01HBQC2x0n3TmFay4XLjHqCwa9gleyxF1aB65T6jaSXrK61uURWiqlyx1Is7CLQqRbACfFP96vyMaRhPxwbCImIAfzF4vCWqEh5ooq/y/Gz5xq1NjJtQ108mL1M7L4ljnIhhgKRmY96aGt5/E8vqQUQ1f7pzLEaMCI7dukLU3dv8sVweYQFYBLuoaXsPcCRJGfkuJNJKSL8TUwRGaNptPOEZHQ0H0ojh8OFvyAejneLAqEY7huyGzZVakdlPRyEiQj5jHHXA/fLdDg8ZUNjGRpdxt6D0oYe3TX4q0oOGcjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsvDm3JU4yW5qTwuAMMB5KRhF2BzeYVg3DYEbap38nQ=;
 b=dcyUmwSI6BlHdalo2r7snsND9NtJ+IUE+tH99bYtikcbX2wPtQrdOK+fCRQFwgeMoMWFykfIkpcQdHmX/wNv1Pw/PogB/4JkXPcMR7a1w7tp5KTlcIg2OnVkSoq3+JlIrR6MPyrK/fJNai2JAkyHCgS9zjrBR8+u5i0+QIgurXS3FbuO60EI2camVpE/VoZVGQwgqeyfsGciZuX9o6xLEyEJOTawsOZL2G5shzItYLikqGd/Ui9Wea8dLApct5Pac71NC8icyM/UNYp2irJ4ShRYOzztC1kaZtGy34p0epshd4IP+WVWlSTBEpxhGV+FqtgezlTDwSlg0JirwchXyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsvDm3JU4yW5qTwuAMMB5KRhF2BzeYVg3DYEbap38nQ=;
 b=j6KDsQNaMvR47OQqNrMMcqHuUjtB4qCBMAebqu6yN7sfyXh8vXomYIXct8wO8dXaEdrEERIGnofO7VjVGJEFsibSrjhvMqLJt5xiYoKJx86C/QL2/0Nv4S0++MA7DnvZAfOPCXhb/Bmfg7vA8Qe+pa2gcfZaqq9DzUXYblcjaOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5857.namprd13.prod.outlook.com (2603:10b6:8:44::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Mon, 17 Apr 2023 13:34:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:34:47 +0000
Date:   Mon, 17 Apr 2023 15:34:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 08/10] net/mlx5: Allow blocking encap changes
 in eswitch
Message-ID: <ZD1K8NtWTmKkhfUN@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <47dc63412a5c0b8b60ff4127a54d709845b4e4de.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47dc63412a5c0b8b60ff4127a54d709845b4e4de.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AM4P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: eed38281-6b1f-4df8-7cc9-08db3f488346
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeKCGY/SK6aMkcDfzrYAjgcKF4O/rX0Sd4uFg4MUtZX50mBnR/8HmqiNtASR5iECfO3AXTAUM1v87uC4NZzD5BM2sqE7Z83cgztcVvIoG7GXo8rtrNzE2sNna7Bolkklk5XIdSnipWnOeCVk0cX9F3QOVlyBh/3BsIQaxT2oZTcdLntiWiEv51YcL9PXMu6dVyQnHx1Y1MbZDf0/XbCoII+WMDs/afH/R5LDceceA/VJqg33zO5/VfLrEg6WDvdltr0q0Wdrp5KXUdFmGJlvGVedLF4Bvuf676ZdL5FwfRMMkqq9nnnpKIoOJiQWmMG0mSmTBJT3dJx5NurVpapGkZzcsfY9X0k3r9kRKRznvDaPV+HSMAaYo1L2tJIpeYt/jChkzZ3Us8uek9Ah94KYODW4T+SIqeBwoo2Ic5v+CHm2B4wk7B44UBAOlWcZGXIFhUxlFBmFhQuU7NtJtRl3Vkc3PAe7cGVkWaWTQWs+1EF5+i7T16EOc6/YwY6gOVFA0OUVOh1fx5lH9qSfxkQ/O8o0wpx0Vs2Uh6fM89H/Qxb5KG/qICeQxfDVRlcZBSqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39840400004)(451199021)(5660300002)(4744005)(6486002)(6916009)(66476007)(66556008)(2906002)(4326008)(66946007)(36756003)(44832011)(7416002)(86362001)(8936002)(38100700002)(41300700001)(478600001)(6666004)(8676002)(316002)(54906003)(6506007)(6512007)(2616005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6FOcb5/wzeAx5yddlBQ1rfphOFfX+RawojaaB/xMXa2keAQhg344IV07PXE?=
 =?us-ascii?Q?KvUu6V2mwr1DOWX7NzoW7kjWUvQe7azGplMVcCpMAGsrSp6gUzvYhile2Svb?=
 =?us-ascii?Q?tOE4QiX5R60ShzJmGkcnHkidE/1eVMsvuh48apFFwxRMieAl0H02x62dWe6s?=
 =?us-ascii?Q?qdwPoxKaHw4jXmglzm1tKGzvI5PrTBF+rK8Sz0EhxPFRbaRivI0k9mEa654H?=
 =?us-ascii?Q?HOPIOC3oEqQmrMy0RbZ5QgY+z8O99coSZrp8iZENdb9RlV+cev7ioBlh3Us6?=
 =?us-ascii?Q?FPRvxNOpjC/RkNzgVEd2eG+NL/eikArAJkPvzCMykNK/aXEqSHAv8uNXTDds?=
 =?us-ascii?Q?Uhmv3I3BpsIq1njYe2Y2MS4t4dMRWSu48tfjRll1NN3YnQ6Mz5lT+b6wuOvg?=
 =?us-ascii?Q?755fLXa2CfjadnyBed6w5RVTOZ2H32wrSnw56YSw2wO1yAXCamgattdGfte2?=
 =?us-ascii?Q?wgsMwZ1siH1iiH+2YC8bnatfdpx0AT/xLK6aIHBlNFKAkwMLhvkla/OkCckC?=
 =?us-ascii?Q?sWmUexvdLRezYK+YDpHp3Nq58XrNIJj5wrW/JuIuKbsIaSUA0Q6wlb1qv1wp?=
 =?us-ascii?Q?hF/fL9ErGP+xV3rPB5kHSu2CAmUnO2xetGW2JTUy4kPDDhB1tByB0BN0ytkK?=
 =?us-ascii?Q?H4IJexXhLTE+GO0a1nX06vjXmpanPgABq2XzmNlHkaraGxK2u13fHriFEtud?=
 =?us-ascii?Q?vXY8BKVI6WjhXYrcmzkaJy7ni83sOq7bV2HH47IyHIBey0KHG6E7cfcMiTHh?=
 =?us-ascii?Q?RCJosJAva/zC6JSg/0N2YXFkivMdUh/AEcoGx2MjtVkoUJwTqVoOlQe2YM1Q?=
 =?us-ascii?Q?T6n6Xxe9IJbrhMj3zMOwngZtqHmpUZeptm81pRqWWwYs9qPvT92OzDaWrFid?=
 =?us-ascii?Q?ahcXHIP/EpGnZTODTMZr+Hf5KVifE5Ml4/cee0U3pgAgdtlgy7miBInEtTyk?=
 =?us-ascii?Q?Sjjim70oB62hoX+GTAqYvlPlzCTF+pcH4HS+l2XlPBf3VUUjwBs4aK7hCpq2?=
 =?us-ascii?Q?XuL15laxedBQX4GApci0zpK/Sm//A4v/9WyteuV9Det9tShSBdyWjRqBOHvn?=
 =?us-ascii?Q?0WD8lLYAUewhJr6LhpkhFvHrrSTPNFoK7twhhvi5rXqtMcZpYNq8ItNetMEO?=
 =?us-ascii?Q?KJWd/iX/C8T8nP+Oma3KsylOprxzgU3s5SFWQ+7F69UZdekHs1BU027LzhMk?=
 =?us-ascii?Q?b5NXj48jz6pMgBgXKkgv9FZ9KG65K7E6fZcQB5nFjgFsm7JnDcaVjOWMQQ/3?=
 =?us-ascii?Q?VfTWoNkBbsDMXZP7tCaOEN0H2Gzwcqkc4oTFqycGs9CS/apsPKlybVVRWucJ?=
 =?us-ascii?Q?E7qbcmTAWgqT6jXlSQBvJH2xEm/VV7Raeq8OpykFPTV1pbrIKPyQJ5GNsW/w?=
 =?us-ascii?Q?nj2UkaomKwIbA/cAwBQOMgG9vIT7jm/w8PKronwgKup1Xtb7urXCEWh4hzJL?=
 =?us-ascii?Q?anMdIQe4fFjR0bsv5H0s2UU8IbEWpkOCRrNsKO1vvAc3moNoZScK2RR1U99U?=
 =?us-ascii?Q?uUgBNS7FJ3jPiawUzWl2OuricjHKoW4zn8h83hOabqqz9Fe98mfpVUmuNvU/?=
 =?us-ascii?Q?9K1e9trYf5jFEJ5YgNoWQskt5ZTiLAwZdct6TDgznuhdc0/zBRBIdDSJnhz5?=
 =?us-ascii?Q?N8Ns3P1AqGViPsfectdfaIQE4V8BpCbINefK1ByW/8bv///LRxEZyjzVJqoc?=
 =?us-ascii?Q?yuIkHw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed38281-6b1f-4df8-7cc9-08db3f488346
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:34:47.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw0O7uYKChCfcq7y+pdDF1pwDC4NQ2Hxn2rfElM5F6lZptelLSyMNWvCPIwfZZkkRI6aGgG9lz4CCl/Gdg85GUHh/9QtY6Bfvv57edy1Pk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5857
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:26PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Existing eswitch encap option enables header encapsulation. Unfortunately
> currently available hardware isn't able to perform double encapsulation,
> which can happen once IPsec packet offload tunnel mode is used together
> with encap mode set to BASIC.
> 
> So as a solution for misconfiguration, provide an option to block encap
> changes, which will be used for IPsec packet offload.
> 
> Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

