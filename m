Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798045E7EB0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiIWPnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiIWPmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:42:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C4147A03
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:42:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZ8FR9SHRmBmVMm2RVkiRB5X1EiZM+TfCLUOfbjwspgOBXFXCKzSVMALYrqKD7AWhcAnJg0rrN0fN2cf/RYKPfjg8h3nYArY7ipI5PQBPgGLdvfWoITeSo55EVYKQaCFN65a2ZZTRBnAmZBsoWVMpYSnLXHGsQN5BU/evsCe9lxHczGAU9OPoC7x9t8VhvdrWH1mShfSGHCfL0s2e1w+4AsruSzpUN7tw7CYAuF8GlmfGKeKsmXDtFtP05rpOwkahBys1/q3vBWlM8aOs6zokEiq88tk1dRN4nMwzg+k/cJZl5h/WfhzJ5t4ydCqDlv6AUgonXKVac4FKwf9vG3xEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jbWXK/f/Le9cMXgBxDC81G/G/AVhDV1MUFLbqFO7wM=;
 b=aewKxXTjB/Snt1fRh26LFkgAXxTLce1JslU+Y9h8zGrATmwm/fQWUH4TwW4fN4HskaT3K97sNmIBrzC92WV2WYND5o++8ehpZuqGwoEr6NYP70QZK8rq/acEp7NE3eLCgRBxpTqfWCWaDqArLP8vcr4x8OM6737Y5oqvsMZiQOSWf6fAtwp90qUMtewhIWENtyyrgWdTU4w3D2NUJWIynWkivCD2nLEw4ZHra13jzqT/cf7q/UibzAELFjP59m8uaZeDW04k+i8VZ2oM1oxfvFvTD/BG/H6WmCEoLO6ViR2ZQlqOTMBvE/Cjg3YkCaqQt2Hy13xYEn1+1MtN5aSiaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jbWXK/f/Le9cMXgBxDC81G/G/AVhDV1MUFLbqFO7wM=;
 b=L7gkVmwEoQpAsPc3S29B6rFK0wm8RlXBsULukZH5fiynxhD4KDvN84MdhAHbjZnN+U4yNVjV79sjzZ4vJCDkxsqpFVuYT2WhApnlFUbIT+j94n2NOvi7aM7tR/rSjvo4+izeAHbP3HrTl9tJ6H79aekAP7wMTbksvl/rO18oH9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB6005.namprd13.prod.outlook.com (2603:10b6:510:d8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.9; Fri, 23 Sep
 2022 15:42:06 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.009; Fri, 23 Sep 2022
 15:42:05 +0000
Date:   Fri, 23 Sep 2022 23:41:57 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
 <20220921121235.169761-3-simon.horman@corigine.com>
 <20220922180040.50dd1af0@kernel.org>
 <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20220923062114.7db02bce@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923062114.7db02bce@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|PH0PR13MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: 980a7c2a-62dd-47ab-1196-08da9d7a2ae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MosYfYC0V3s9V9Q/gU7I0/TPjNLCuIE5UpR9/2cl3EYSUuDRdCzYZm86WCYNSPT9jJFZLCjBbtuJWHxTrbFf166QJW7W/OYfkfw+Vwe8ilSYaFhcefvRZk2zszbalejRDw2YTB9GQeQ6B7D9UyB3G0zIhkqf8O3FJnjZm9i9+Lh7udUi8PObE4rcmprxT3BEExtD9R6gLcP6OuA5A8LzR8E0JWzvWBHjY3/TwNqNGUKRCJTv3Suy07VEffgLXWVElwDib46Om/vi7gYVSLiwfCgkjOhhdVF+lc0S3SlK55pA/iKeEuD5ndXWSHZO2jpPyj9Fy6ollE7+02eRLqcLfLf/Pgr7Da8H358JboikOVPuxJ5b83cMucfEJzn0rB/2fW1XCHEMHj5deRQ0o70xIeLUAsKIMZovZzUzpf9p9Oq9AsM2QSDNPW+LhFXjKWYPS+9dPNMYAYBpEs2puj7nam3Z5WqYKGREkBnnC0YzdzQuwO6epUwpzi5x0dRDitXR7WbAgRprcWIZ5KrZ7n4C6NIvY//yKAi5UtxX3hGbOgHhE5yrHWrQCai9QV9DrqTgzaY1Jw6ydNRQvGMqhRkRV6ITGFHVFmS3sPFzMHOl/h39SghyWWhrcZf3mRfMSxkU2NoMD/5OyEBiMmsmjWfhyJYxCHlk+9z2nSyzXoTVEQaIVgzVtzjPnllsqJ+ucOBboH40HdZaSKRg1dqtQXZSrs5WnLZRx+la6reb1F/dUjqUuZz5scB4qfpwYGvaRKb/MmnBIASMsXwMIXLfoH8fHem05y6DNnznldZGdDzu9iMcMwaQl0rEU+HMoh+PXh4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39830400003)(451199015)(107886003)(6666004)(41300700001)(6486002)(316002)(66946007)(8676002)(66476007)(66556008)(4326008)(478600001)(86362001)(1076003)(186003)(83380400001)(4744005)(44832011)(8936002)(6506007)(26005)(33656002)(5660300002)(2906002)(52116002)(6512007)(38100700002)(38350700002)(54906003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZuqIITXTSDXea1XrUktgIl2Dti6SYoJUQYZMmIbWjG+v1kuziRqvZJnfNbr?=
 =?us-ascii?Q?W0bcIkicLPoyoo0uEYKe4PmUV8u8iqKyR7GuiGcOftqLB99aD+PHMPHW2hE1?=
 =?us-ascii?Q?dDeWWbQ2SN39yIzxIDdRIID2KPwVeCmOpM2PhqjducEWPL9jZ8mMSdwdbwyN?=
 =?us-ascii?Q?8mIOa+jyE4XFq6LkWLort+ac4UozC+THkJYrenBRBtqjIor45MZCZW+qbyZy?=
 =?us-ascii?Q?TEzkI3PICmw6phhkw05Y/GJ+bf3AjvvjNi3rWRJFrsbqBteZxJUthO8qI1kY?=
 =?us-ascii?Q?3cTaNC+GgSztyGQlHu+jHzN2sySaW0deBEoU94kBhZl+h1dIfFHMdX1idWAq?=
 =?us-ascii?Q?2urIydnpzEnT6IhoQBUtdH+EQD5QRnLMfvu7MlRAAnAbIM+laFhP5/Wdp26k?=
 =?us-ascii?Q?45oHOd5hgdB9slEkDZ5zplZrKmE2BKJWo15kzPTjzuqTXm7OoxVs+xXFBEP9?=
 =?us-ascii?Q?A7HkNUYpcKaVp1E+ykexRrpo5PRwIffyZiVRopE2nA2seoDpdLSm+NgHSPMn?=
 =?us-ascii?Q?ck28a00sbHRY37kYqy1uFfhCGq3R3FBIkmaC0QEs7fC2mbmiFeCjjtwgVRXX?=
 =?us-ascii?Q?4sTN/v/1br7WDxivisxdh4KSf/pthkzIB0QPdy4uGBSJTtXZriWK8BM8LCJu?=
 =?us-ascii?Q?apcpA+CAP+SO3Mu9HeanLo6flFo34zNfilXyE2k5fK3wthxT+oqWJ4bKXtop?=
 =?us-ascii?Q?S3y9XzOi4CYUGcalbQAPKVjYtmSEH5a80BFzy8qRVDBERHpBEBsh5lCgE7iE?=
 =?us-ascii?Q?eUXroZaKkYBSy8+sd3zQ2L64ydXQtzWmW1BG0Z1pLYYp4LIjWEYBpWv1vAh5?=
 =?us-ascii?Q?o6TPBl0E5JnJBTHHonINbQksoOzG1MOYKTLt5fXvK/3pu7MaLE1hEtepf/oE?=
 =?us-ascii?Q?xvuRAnpHxpuTh5x8TaVkWaCPovJ9edvxasyXSbeXAjkIJ6vp/eDGZOoD3CF/?=
 =?us-ascii?Q?kbxRrxvxwLRyDOQCGzRvCrHKqRg9gfDhH4Ob6iTwQr+6O/diWW438s717whI?=
 =?us-ascii?Q?e2YqGmTA12ueNc9QelMlw2qUZZPeuMk3g6xMUczOvG8vF5JrswgJd93CJj5h?=
 =?us-ascii?Q?TYLsrpvvpK9e3h6hSR/NaU8yum4Xd5P9FMY/dIP6xao8UPn9pYXEnEsLg8+w?=
 =?us-ascii?Q?BxsWZzS7syLn29AUQG8AK3QBQYDBLEoZgArA+VQdbhVjAYPp37qVYdJYWcDx?=
 =?us-ascii?Q?axGHi9q2WKjkKxiWBmu5urwoybRYwSeZyo7JAglLiH4mGAiViRMtj8pt528X?=
 =?us-ascii?Q?DM2TeC9E5aQd5um/79PQTpPbIixd7vArh3/9t6kT+1T3ngH/fSd0GEusbXQh?=
 =?us-ascii?Q?knKm7DXBO9z+OKOrt0UHH3nk8/noMtPfmlk2KZHuVJpcP/nmuUHC+fuX1zjB?=
 =?us-ascii?Q?YitxuMG8AmATvn1HWNBoGaDwgVVgfWTi7Z5BjYeniUqg7rbBYgQ4SmSQAVn4?=
 =?us-ascii?Q?A3/PrCHkjUuRrc5EdHdSrLwx2V8O+43twY+b7kUgMPnop41U7tS07xNy1Jwz?=
 =?us-ascii?Q?6lpshomzUjpCTbUJR3NiftZ5YRIT8+q5Xrs5qsaWzagWb2YL+I7yKhb1xa4C?=
 =?us-ascii?Q?soeoJ53QZgowOt08sK24bnrPEDWKNPFzlxjS/3FKGDX6TAw14FD+KpfIv4Uo?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980a7c2a-62dd-47ab-1196-08da9d7a2ae5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:42:05.9192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VklA6/PyquN/4z5IwvTV28vOK3sTjDEwCjPyiyw6JgV4bJask2IRaJXX741MXSshM/BJSgxleyGYI9CV/H2/kxGdK2FMDsEZVxVOK82AK3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6005
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 06:21:14AM -0700, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 04:37:58 +0000 Yinjun Zhang wrote:
> > > I can't parse what this is saying but doesn't look good  
> > 
> > I think this comment is clear enough. In previous `
> > nfp_net_pf_cfg_nsp`, hwinfo "sp_indiff" is configured into Management
> > firmware(NSP), and it decides if autoneg is supported or not and
> > updates eth table accordingly. And only `CHANGED` flag is set here so
> > that with some delay driver can get the updated eth table instead of
> > stale info.
> 
> Why is the sp_indif thing configured at the nfp_main layer, before 
> the eth table is read? Doing this inside nfp_net_main seems like 
> the wrong layering to me.

Because the value of sp_indiff depends on the loaded application
firmware, please ref to previous commit:
2b88354d37ca ("nfp: check if application firmware is indifferent to port speed")

