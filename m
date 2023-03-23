Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF3F6C6CF5
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCWQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCWQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:09:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B8305C0;
        Thu, 23 Mar 2023 09:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eau/4hFIBoNTgKnPuCsinSqlRXr7GUaL7P1bmEZOZoHZGjfBd4jfskolWLUFm6T6I4tqW/K3urlS1IRJo+BxNk6wDzIzoPbEpnSjuKb6xb5RWTV0Uq7VSf6rdqrPrvCcDIgS6MAsDM0xwgB7DaaR5jd/vpE98euUM0CtdJjwDqsYeA2V2hRQQa6utoMCzfyP17zZi3EDZ2XtolZhHN3A2vDXukSYCO+9/9BaTan0RqWdpSyzP8PqKDg41QPMNaW/s3h6ocaoahTWaJXc2Af5ukB9czMIh1Ev0fLX1h7zd4cC8Bw4OQPqyRswZQyfN4cUHa6cUecrgpnFnv9pdQ3Ouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsls0OOMrnOqDB6LztCGCXp7oVi49UqQYL8fjz1mzZ0=;
 b=ntKKQdmWm4FbtqIDVAYHFTpMXwhg8GOZIKyQbJr//gKEzg1HEnxWU+LMbKXxhY+EmIycjYp5sz9C8xdiWkHQkXBgLLtTfSyz0Byiig5Z4K8Ex6b8AwQH/cOugxG8Bzl3k/bs+P9IQdFKI5bMSXOv17UoOv6bnzMpmj3lQLXr7msG3DgOsT2h7ODx1uzwKStPVNs5HipAo1q8in+vmoRNh5VLw4auA5R/na4mIn254lR7I9Xmq2QN6rE7Kw/X2XsP4sIi0XofbW4lCwyVUFaVUdgc98CMjcl184dYMHgBo8SB0pNsusCsPuC0jZm92skQrxzQuDXscMC4swkhpn5szw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rsls0OOMrnOqDB6LztCGCXp7oVi49UqQYL8fjz1mzZ0=;
 b=W69xRhOxbRPKHpDCgdoBmUVd/r650FMom8Xgk9m6a2BJbEvh/O80an+PokmlA7gCpXqgRkyer/wINZBaG0pv0QdVdLOPNZ/JEY/LmxH0Mw/MOG7jWRh3kf5eUS0K0ssZLB729/hicpW+CN4Dsl8kLokrq+B31M2iKfevSaIyXis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4435.namprd13.prod.outlook.com (2603:10b6:208:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:09:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:09:19 +0000
Date:   Thu, 23 Mar 2023 17:09:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/9] net: dpaa: avoid one skb_reset_mac_header()
 in dpaa_enable_tx_csum()
Message-ID: <ZBx5qH2wb82EcO1W@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM4PR0902CA0008.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 677e3986-4d80-4723-4cfc-08db2bb8f550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpaO3cK+JcOSUTl9NL8GSyaykVCRUdflL0e6cucILpA+3IX9ju055VZrcSnZdc7fVnoEO6l/hzFPsL0e4tEo2Uyg2vS0OEEknIJ+5bLhq+lnLc0C8dthfqlj5GHCCSL6TullUNtFJtLbXLwagNaY7UmFNDHjm4Wc4igVobEOsrGkGCBY0/euxVjVVQs9/ClO27SOm9nqAfHbsxAkK2QjBCoBRrj76247wFyT1thdQoGs44RqGG1r4Ah53Ab5q12STiTPIRbvktp+9I++90+mOdlF3rgUi915LtI7u3z5qluFPExoj1XXoF3ZewXvIJqZGmZSn7a40ETwPnJssoVwH2AJMalFOHjJlj/vkUrnB2YD8sZqTobvLpBhaINQByy3CGwiC0LbJ8uy8xhlDEiHb3YBs9dJJmTlDIUSoeHNQ4vl+FQ0moxRlVo90CzXuG2rdjAJzI+xbUyhoM5bH3sKBFW6p6IR03HsFlk1z2rhXO5k4I/oMqlzPVVuWkZDcfbYsI/r2UccOwxZeyJmyUj0IzcQ1aF0f5OH/JqG0YZOTDXFqO+go1VZ3OGycqx/Uo6/uORvnQ9Y7oiYPrKTBNh3xNIWkVziZyW2N98WG+J2z9Eg3OzyHlHWzynJ649COM6PRWhitfc/Mc71xmv4ghTx3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(396003)(39830400003)(451199018)(38100700002)(2906002)(6486002)(478600001)(2616005)(186003)(86362001)(36756003)(316002)(54906003)(4744005)(66946007)(66476007)(8676002)(4326008)(66556008)(6916009)(5660300002)(8936002)(6666004)(6512007)(6506007)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vFfiVoJFSbk8eB2agFv6XE7qk1Ob4veJNIRhg2mEfUGr2euyckn1ZxRTTSWT?=
 =?us-ascii?Q?F2fdzZARo6VzGZ4fUxF5Kmkzwmi4aDbXLYXQ0DWXe9vaeo/oCXQM4fFF6lPl?=
 =?us-ascii?Q?WfL46RTX+3dTihWXpWGtvSDoxUoRsJwjozoj7yQaQ+hlpfYOjTC8VuzyI6zB?=
 =?us-ascii?Q?ZQQVie7M/jW886daP1+6GSPwAp1jaZcHwGdV9+Wi0i1GtksoteM4fVr/gMmS?=
 =?us-ascii?Q?iSr1JHIJzrIeBm2iUcTGazdRriOo1ii1gNIgEegEbINBm8Z1AvnHnQ3IN7/d?=
 =?us-ascii?Q?YXHN2rWNQYL6aNTQi/xaIP0075AySMutpSfI+dmzyvVumlTqOdBej3q4i4Ym?=
 =?us-ascii?Q?+OmunkutXJD1419J1GRKTpAPLJYIkBndB54eYBimJKrokeC777R++3nmBTvJ?=
 =?us-ascii?Q?g4PfPnNzccrlatXhK7RdN/6CazGM9/V4eGpYAqCkhuTiVdmtXOFXTlH+37uS?=
 =?us-ascii?Q?WqhJutF3VU059MHDzMgqhl6Kfm6+gsiswFJYN25cbYPl6xiQZUgaGMDTdZOD?=
 =?us-ascii?Q?vnDei2EVBluQ6Yt3oyzHbzCqEawH8j4oPVUuk+uH9K/WqOOgT6C7VMYPQ3YZ?=
 =?us-ascii?Q?j7FOvpFs2lub1fiLw1j51mv1YBxkitnEFnyrekDGjxBqvkh8vn/7tt7U8smo?=
 =?us-ascii?Q?SIRCZXpieLlOBY+6a9sbNuXvK9tVjfCzihwEMhz7L/QtYU3a63B2yOh9ngXN?=
 =?us-ascii?Q?4L9DQlP/xikUa7If2ku2ZJA/Uf9TZzJq4qA3/O93VYNxAbYmCc/A8/DFX5ZY?=
 =?us-ascii?Q?dQ5nU7G5OixVxW0LRXNkh4EXSGWJ0wrwVqy7IpclUdfAm7RIGthM3TS5MoKj?=
 =?us-ascii?Q?61WYvj/EOVDb6eaLhjJXTR+Vl3bgdD9JEleBx+DBJr7BWTVeEdgum/sS3QMy?=
 =?us-ascii?Q?I8Rt/sytwH88hUehAVLJ341qlDNfc/LaYyCI3gsHm7yRL9/js/oxIA9/W4wy?=
 =?us-ascii?Q?xz4KS0BfhJH4K7ELR5VCJdCyW8WAXpevTR3VheOsNH1lvkU0EtUAVQ6YNWew?=
 =?us-ascii?Q?3XR/ItL+UXk3rBoFr9NuSIRR/m/+4rZbSC2hRBk4MFnhzEdr2Ftt+DNUGgXn?=
 =?us-ascii?Q?u9M5JkoLDngbQZUK0CM2RhQgSyYs379u2t6r1qYau47xxi3OrYji1KRdKsgm?=
 =?us-ascii?Q?p/cwAFANXUa/wBWZfaMnei9ALTYvnQ7BsuYl5xeXdEfAIICuCgai0tfiM8c1?=
 =?us-ascii?Q?9i/91bvu5Z5ETFe1WoGqYaXaSDVJtCF0TcBvdpGSdNIqgQVz+5Z7N3PIjaGH?=
 =?us-ascii?Q?OWitUGVN0zWfZ7yZIcIJOPBAnN8V6iwDQ56HsS+FKsB2PySc5zyl8SDasZ+C?=
 =?us-ascii?Q?71Bx+QNIogu7B5Q7fGoM952evWlPHF5zSBS0L8PSmlEITIwXcjcNRxCE9pf8?=
 =?us-ascii?Q?LJVujdiNGdLwZBzJ+lcmD5WwkRF4ffwIL1tP+IBwmOuW8kxkWKX/ZUp4RKvQ?=
 =?us-ascii?Q?rM82DpHcqG+y93VsWvyAWGeUhV5a//LNEHrUbYPCwcFg2vb0dZf1j9C68X8q?=
 =?us-ascii?Q?MzIY8eHaO4NHcrwkmfaDey2qAhjfeJauDiK6Xf64RTRYsGo2gE2IRCv6t80b?=
 =?us-ascii?Q?evt/gZC6HR/WfrsfuY1666K+9FdLVum9ZvsD0U8L4rOdON31aMNyGNalH9P/?=
 =?us-ascii?Q?sAM/HHg0pSllfJC5nr0KYmaoeCXvREjVWAfbWFotmNSRmuksCzMbTrPIzBuh?=
 =?us-ascii?Q?sjnxqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677e3986-4d80-4723-4cfc-08db2bb8f550
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:09:19.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDlxKJKuQ9qvoQNdOWLKFG7LFtoWhNC0X3nBpK7QpiVUMfsL/prlMPspjSNc0/F0fJWYd2ImTfj86IKp4xoexlQ67KD/GL1CbG6QI9T6uv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4435
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:17AM +0200, Vladimir Oltean wrote:
> It appears that dpaa_enable_tx_csum() only calls skb_reset_mac_header()
> to get to the VLAN header using skb_mac_header().
> 
> We can use skb_vlan_eth_hdr() to get to the VLAN header based on
> skb->data directly. This avoids spending a few cycles to set
> skb->mac_header.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

