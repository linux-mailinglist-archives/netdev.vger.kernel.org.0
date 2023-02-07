Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2BD68DCFB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjBGP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjBGP1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:27:04 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2091.outbound.protection.outlook.com [40.107.94.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D8F40DD;
        Tue,  7 Feb 2023 07:27:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFKqXE5K2bOrwEAjGU34YceAbySFFAwRFtC76LHLxeteoon9AO7+tATbxDJW59DFVBM3YRQusbK/ikVnJVpuwxknrbo0Rwumtsm5YHoD/S32H1j3eAzpgDY31DXA5m9V5/0v2Q5fL+vUGYhu/s+TBj868ZFAfThpMWfgJgvV9iG4Wafkyv0Cp2LB2DJ1Yj4BmWvYZVlMhsx/bhCDqZ7qTpz237YqYLZmS9EcDsK80Ao0OX98Uwy8AzZFovKnGHq6o8279JgIVHZpr7yD/PSnTr0cSty8sIW//+VtIXwXqY6vLIgrXkQ/Pp5jztf8guhH5t+D9rsI40sL66BpUWkiSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kBQMDrWKpV2zmA+VlfvP3qlCWAhKs0q8vGmJEJsPJ4=;
 b=HpN6iZKqkzzhztqHL8CTCmRoRUz7iPKMVnLAluaVmzRHXHbGzO24U+9UBaBkKX6YSvZSdkETRqQeDc7M2QgP7h2qadLJ9P4vtc06mbSxrc8liCheIPCUtAU2/8ippjSEOlNv8mU/+R+iN8msCjxEDA7Fk+o5rBA8Tz0Pmnqwc2ZkiQ2l2Y//wfJWHWLitwwRPorwjiwZiXmflwPzcNQKxzPdsvWSBeqgeq70S8Skv9NpOzs22IQZ9G8XXMftyUTr6NIz8ooAVeF7bf2hONSrvE7rmJcOewJcerCrmifdkWAmeORPmXP75t9iuH9eto/YgVWCzVhXlVvduMopa+XfaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kBQMDrWKpV2zmA+VlfvP3qlCWAhKs0q8vGmJEJsPJ4=;
 b=EIq5yDA7Pcyr0fYq8L/nbaoylVfgnLO5UfjRvcBDzSlgFX90t/R3XgKINbkfz+cHglJgKOaiOjyVx02N2hTiZnG+G7fJEj9n7wNFbjfl9n025BhnkRiEzC1eL5vfC4ECaf+RJkqMGFSAPfoMaxrGG3h5yDXD7VyXu7SdBXOnHGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3713.namprd13.prod.outlook.com (2603:10b6:a03:220::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 15:26:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 15:26:58 +0000
Date:   Tue, 7 Feb 2023 16:26:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net-next 2/4] s390/qeth: Use constant for IP address
 buffers
Message-ID: <Y+Jtu63kIIs9l2+V@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-3-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172754.980062-3-wintera@linux.ibm.com>
X-ClientProxiedBy: AM0PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3713:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a1b5df-065c-4b59-5de1-08db091fc051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jDHn+xYWm8kl02AlMfOycwzwN5qp/31R2+sYdlU4lhSiw6Tx8UwFBEcUOqW3iHhq53gPzCVl1+/WTQckatlW2MMptG2iipG+gC1NKM7zGoiF+KIWZ1sja/wecJarYVXvwXziZHqmP0cQrbtEyWqCFp77YqmIjz2Nsj+96zx05thp05hZ399iuBsNQlsNMLnamPup11/7HN4deNOAAu+MjQpj6gfje27Hm8jxbS7Bt8gU+petiBUpDBGRIZzzueV+HWG4gy9Ju9Yv9q+nsZCBCpeFvlijf3ebtujz6bOmd451H7Sa2c4LgDDETjnzxwDm24DqcNs5pdsA/pz2UDsUQ9+e3v5YNy3B5EQpFDSQ4RNwqqYTd2hf9dK6By21jtYBTOaxAoFaheHkRLiJks9px/gNjJZKLdK0iiKkg4JzIhAQkgfJSAHLRb+6zL4V7W/DJkZJyWa+65OrxGE+IKsI0wYRhrsMX12YUT44fN10e0nu7rgftc4Gss4KaXOqLFpZPvI/5h+oHBnqpG3A7lCuHG7946unhNKhS6/8uLK5HMsvUti43jn0eLRZtfBq0yjOkKaugZlg+G0mTwK4cc8EKgBnQBGFXaoXqrK064VkxCMd3AcQS/Q8CffUHUmrovd2BjJGivcfCAO2NJ5sK0/GNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39830400003)(366004)(346002)(376002)(451199018)(66946007)(6486002)(478600001)(4326008)(66556008)(66476007)(8676002)(6916009)(316002)(38100700002)(86362001)(36756003)(6506007)(6512007)(186003)(2616005)(8936002)(41300700001)(5660300002)(6666004)(54906003)(44832011)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RqfrjN4AnvWgeEqeVoeg9GCLKLnWDUiVqIj1oAkwIYooDvkyRsElAse43A95?=
 =?us-ascii?Q?JEUJzXho0lLjubMdOTaN4iSXP3x0+lOf6fGzWPYZ+NnBVpNpADnJemD2wUv8?=
 =?us-ascii?Q?kA27WscHCFGgTxLaw6tcmulGqlasyHikMzd6EombaGlW4ETItNDMQOTXGqAu?=
 =?us-ascii?Q?ctnBanu6AlTb0YL8GKQC0fpNX/V33vMlyLAfjlpo4tJIZpqDQi+MC6zAOcBA?=
 =?us-ascii?Q?r1DKYTjXMnb/3Dn22NG56jbqkALxgHeA/hVEYVEfL+LiTWxiYms3ukxcpTzE?=
 =?us-ascii?Q?887mumVeM2hP/KZnLzTQO+Mydxa3OCQqNmD7LBWrRYVQdMvUe6ebC/A0nlho?=
 =?us-ascii?Q?DdgiPA7klqfA9M5AMniAm4NaTUd4AB2vDbvvnXORLO+YnOSlnCpeKtOX/oeO?=
 =?us-ascii?Q?ZU4nQGhkL8R/sCnprP2v3uw3H0w7cy/pWbpWQlO7cybRwFKagSZK3qWawNOx?=
 =?us-ascii?Q?yU/SAN4acy8eUNPuadk9DVJC2hTNk3gEm1t4fPb2sQtMoXSV+kqW6Q4gh+ka?=
 =?us-ascii?Q?A1TIhmO89VNdcKz/5CNTZ7cAh08esKra6Zek9P+XewYWYwTi93fKNkLk1Ezb?=
 =?us-ascii?Q?8jKi9POwXDRkQ3l1jNMBaj+/Go2ePdDMaxFV9bFbq1GdbOyexGQkMyPl6yGv?=
 =?us-ascii?Q?WVXWQ+wbwweFFle+NT32Do+zDB9Ip6PTNfBOMyM7Qez7lkYeTM5JHML0WAB4?=
 =?us-ascii?Q?BzRu915rb/WR4VuBpHwdQEtHyGygQaglqFxTas2PRESCjoX3/cvVv9Tp9Ksn?=
 =?us-ascii?Q?Dz0qNZDQyNrUtK+m5MtDCy3ASBUgjNBXkbJPwTJMI4/N4jUe335whwORw/b8?=
 =?us-ascii?Q?NJ0qLMSfIh3QnoEelmDNxrfZ0Ei3PSdo1Uazr+fAhOmsHf7clhSvyIcYf8VL?=
 =?us-ascii?Q?2ws4q+H794p/bsyVmo2ygrn26AgpX5JnCSa4Sfz9hlqItQsM+Hm5HQxKaQyo?=
 =?us-ascii?Q?xUVF5XbLyPQAuRRBg46ddeH19y2rKxnonud0TOC+g62YlUrHdUa8Ugl1YhBT?=
 =?us-ascii?Q?kf5o5LIzPCadKuaqtpNFGsUXti+5kfosv6a2VRuBFR/4teUrXIa1858uZKYG?=
 =?us-ascii?Q?Mcl1hkeRiTnGxsaide4ygskFoV1XIWZRnvRjBW0bFziwmVYs26M13whQR9BD?=
 =?us-ascii?Q?89mChBPh/k6a6al6leaq74D5RKNNAauwLjTIMiiPgZPgabg4m8FN5cR0SqRk?=
 =?us-ascii?Q?XH4m61nvR1ou6yPHCy7ncej/G4U+lVAsFtdDzx4QbDgw/e4csf4/EGJigyBl?=
 =?us-ascii?Q?Xb9J1JqkiOAMgQt9c9ewCKuZY1AIS7qFx5rQYOFjVsFzvA8zUHL3NXgMtMDy?=
 =?us-ascii?Q?BRKELXTTGketOT66d8eYrwCh/pll5cWQTtAXCIwF05q9kuT1eUiU+GOy8F3T?=
 =?us-ascii?Q?HLcG47W7WnJEtYzQalw08wGmQAkMWeylLkgk2prsgyvSW/QwE4x0jQ0te2Ie?=
 =?us-ascii?Q?Phnwcpz1aFmWzJgs9ddVKpRniVTE9ss8cqSITOSL1tFv/r0udDi3pSzM4Zo3?=
 =?us-ascii?Q?R1/EUjA/WqnLNqNWpANjO0bOuiUhAjmobhKjlDDb+tMTiUJrF9jALyUR9N+/?=
 =?us-ascii?Q?5u6/gYEd1xZaKBvM2nqWJ1VGlTRd1mo1mEHRQbPavSMsJg99tiaLB1F/talb?=
 =?us-ascii?Q?wSB+2TVCQ78RyJe2jaIl1UBMXRTSDMV04xWrUv8R4VL5cD+c6qtOerai+Lia?=
 =?us-ascii?Q?ThYcRQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a1b5df-065c-4b59-5de1-08db091fc051
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 15:26:57.9657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0K2f62ZEgp3q2DziWIyj2mmkr0DrOdSIA6SnGJUWb2wIy4l2d0nETccdu3obrF5vnav9ULK7s6ZHeYnSBtpR7WOXSsjpc5uFotOGI4laCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3713
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:27:52PM +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> Use INET6_ADDRSTRLEN constant with size of 48 which be used for char arrays
> storing ip addresses (for IPv4 and IPv6)
> 
> Reviewed-by: Alexandra Winkler <wintera@linux.ibm.com>

s/Winkler/Winter/ ?

> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

Code changes look good to me.
