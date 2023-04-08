Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB106DBBAA
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjDHOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjDHOoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:44:06 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2100.outbound.protection.outlook.com [40.107.100.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DF610278;
        Sat,  8 Apr 2023 07:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmYiHrKxMJ2jjBVFCWirXhSmBEqB6uAbI8d00XMDaRfoAUHrA1wk4Z/T+8vFKx/fFznbmiKBXiJt74TfIk8WtSw07/aepcVQ6H9VRqi++gePTTRqwQQlc1pY5xWaCy1ve4P1IJV4zwb0d/M7NW+HtdAGiqs+ozMmDxbeKOhjp51yr4AjWZkdXilGyHiTQukFwOgKEE2voXGT8AWv4+fY9GpCKwWxsBK4LAmbYEsWAOwGPq+ROxEOdCK+jweKWRR0rQsjzSoulLgZQV3PPl2wvVOrDZ5Bz3eR26HLU549X0pfzR3UWrPkFqFJuv/VHxA8cLFYajsdMFJNuB28weMFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/Kq44cudZ+Z3p4oKEYw5Unp8aC3OVpP6zEw3zlBxqU=;
 b=dEhge518sNgUgxslMKuod6LEwbeCuEXMkRZ7xJqQmUIIxa9xoZu/NdXNdCnLOhbkKV9zORKkvdMFCn8ADlRUOOgQEnbdVCSP5BWCNKCuaAsqSRlzYp1kB5XX1RvGJqXS5OM7eW/DZt28g5l3tDdKCRDHXAwRLX71gr4WuD+55UsUySkxRfdIOh0wJoN6TkaTdu+qomp8oZ4hcxATnNhYhoTiCUGYu193CtUkcMr8xYsxntgBx6BXKNa+Vs4+EoIU/oXk7PXjMfz5YsHy617vzFpcAZc4UwQdDJ6M5xqamzY8JogohQWa+DW/4t1u8kiYf4TGDFJzG1xszpOEj7o+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/Kq44cudZ+Z3p4oKEYw5Unp8aC3OVpP6zEw3zlBxqU=;
 b=a1OekvGqdh0n4WuELVolai9yvlFKNqzSPmBkX243rQbgGzqxKes9mPE7DE8AHkJlt0PfFrIfVJM77oM5aKWALzF92YlRtmVeI4dln+o7mOeWYFTPShjwvR/6bhrXHLFy28+kd9wx2lETFxr6B8SS8FBXKnBjbAG0goKHQM4u0Ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH8PR13MB6289.namprd13.prod.outlook.com (2603:10b6:510:254::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Sat, 8 Apr
 2023 14:44:03 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:44:03 +0000
Date:   Sat, 8 Apr 2023 16:43:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net PATCH v2 4/7] octeontx2-af: Update correct mask to filter
 IPv4 fragments
Message-ID: <ZDF9qY31VKfcigSx@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-5-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-5-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR04CA0030.eurprd04.prod.outlook.com
 (2603:10a6:208:122::43) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH8PR13MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: fc54eca7-c366-4d83-9a44-08db383fb249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aybla+sYZsRe2uIkGqqF6lARiLYSvZRCNCYzsgy4hyHNW9Qx9XK61X+EUnlt+Bui/Cm81bGpiiQrCWK1tOKMcKt8fg4CaUCUXijFzRXk1Ykn0iKt8I4phMKKp4Qzp1FF3+qnF6cDcGpGL30YSCXD+leWybZs2ausZ/R444x4tILD5KxoxxMk9i/Hf0/bUWmhH7tkJeIamjp9ePAivwiTBpmKfciCS/GvPvnGHAoTXB2hM1HfopT+sBQBEwP4oZPQir93sKT1Y/csarYjRPDTXyVbq5cBzTGgkChYHz/03rX0T/U9UBPwErDFz/kP8+pO8chUgjSC38o3O33uDq1q7lP82duBt8A4apfzZ9h/NIr8t0QMn2Jaymj52RKLPH58zlHc4jjIR9h8vMGQSuIs73npPoop7AKdr708bBh5Rieew0u1Y6NZnlW1GwmzqRx12k70/wVx2cf/4AwpuOvl+RIOiUOP56GK5lT46u2M/433aC+odTxb6djNAZUSWW54S47aGFKeKXq5i5xfz47G/A+WtivqtRMgqLEdjy0gvx2hyCR1KouS9RW/9PmpMn2HwdVIzmy34OK8wgwlBPwWAdGkX6xZNwTc6pqJ8Hj8+Fo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39840400004)(346002)(366004)(451199021)(7416002)(5660300002)(44832011)(86362001)(186003)(83380400001)(2616005)(6506007)(6512007)(38100700002)(8936002)(4326008)(478600001)(6486002)(6916009)(8676002)(66476007)(41300700001)(36756003)(6666004)(66946007)(66556008)(316002)(15650500001)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vx4B/brMtL4CSZhtq7emYk6pQ4zAYgEWF/UQDesJUGB5DOM8XEZzt4rO4fED?=
 =?us-ascii?Q?zSg2CheKEjrWhsL5EDt8fPlbbAotOLI4LGyCZ21QUYsNLMszIKndGY88Uq2k?=
 =?us-ascii?Q?on1GWdRkAWI3RDcN2qfWQ/I2HW8JCmKSCiAFS847U2mEkv9iaCagyskifIn7?=
 =?us-ascii?Q?JeOYznlhmMIxGR2jw3McO+0GiDk/ccK6Yliaz9YOrHzCWG9bL5Y6C9qirRe2?=
 =?us-ascii?Q?eTTjAy4FoxA1F0x4CZGX2nztP7I1/9OCB+EcbC2ViwArYGY4OL+izOhv9zOY?=
 =?us-ascii?Q?l5el6ebDTUsRH9pFx6vqPvIp1MbTq9O6lKZ4ZuCurGNGPeCBB1V6kdAxr+fp?=
 =?us-ascii?Q?LpacUVEDSRZUZ2DAOVZIZNqHSkx+IxbF3jV7zyG6WljdX5PoWklbh4UnbxmF?=
 =?us-ascii?Q?piC+JNm3xuorYGOK3YmxmxeNFDh3QZdGhMG0JYSuoLUx/NdPojWkJEz71hRm?=
 =?us-ascii?Q?g4DH9zaYIkUHmv0yZDSgqKD5yWzqVFMleNweIyiOvHUuEbad2CYdYtXT2tkI?=
 =?us-ascii?Q?yLW5lj559J2WJotYAc0yBmXxvQB5MXqQ//qJkgz623vi8GBMxDR8Oj7k+0OE?=
 =?us-ascii?Q?xCbzEOYFZygmHcz5zaa4pxJvbt9Qz9NuBbgpqYF3Q1gcJe+Q59SNFPagkFug?=
 =?us-ascii?Q?NDMcjvK8YckrJaPRorpdSgwAiaNhGG46QesnIpAXnTSugfBhfSrHPvvP8y4I?=
 =?us-ascii?Q?Fzhi3pbcsgFhXbsGfi0aY/PQSkTDq7Hoy/F0iDKVglt3+XVZ4JYNZkLZdGYA?=
 =?us-ascii?Q?6GEdyNLYHv5pPukq8TvfEutnvbQF3Do2Js2ZLodJfyGZrq8rYHxpt2M5V49b?=
 =?us-ascii?Q?jNtGk/Ao04JliQFAh62o/iaofRdAciOs5+cwhZlGvrYqniX3AnsrZ9Je5h7Z?=
 =?us-ascii?Q?RYG/8SvITqleWXELI4+Vre+KZqtCgdX1XTP/bZXVIyMlDBYCuxNUow5eO3q6?=
 =?us-ascii?Q?/qRSprgj5k2nHyNUSKOzTAiqsYYhgKByL1vCVkgmT3Degi6awauYHYk4iDzg?=
 =?us-ascii?Q?FN8pFwoCX/uEIBuprjAemE8AfCGYtL/TMaxUyx2bQKgBDAsxvK+XgOUS7HLe?=
 =?us-ascii?Q?YaMYQ1dKJqvlOu5bPGXwbleH7T/MvMyy9P/GOj2mYFOnem5/Azvlr0JVWVsa?=
 =?us-ascii?Q?H/fqA2tLxr8xS/TmBl1YxfWBbHI4P+66ZQvDAWhVACuXtP+SnzgqFRrt7NyB?=
 =?us-ascii?Q?yujvqSiZOX4zHZg4iu6zz3pLwoLxM8NFRsKSf97KZDKqYZeb7+PXFVsAQbrV?=
 =?us-ascii?Q?McyIfvzaY70y310io4CX/VvKjAQlGzvVTY1teb4enSZcELMPFrKn+l5S5oHA?=
 =?us-ascii?Q?ZQP+f6uXR88qvZhEWDGOX6ITOK2bHb4iN8IudMWXuWMQMXjPPivNmi09cmCD?=
 =?us-ascii?Q?pF9oTekJVOHswWf+fGqoUrIWIjmc9arCvY6sZWyl8s9K2E6XRG/LU79Xj+ky?=
 =?us-ascii?Q?azz8Lw6bRnUaMccvp58YRPbjYZ7NTFsYlMibsXIDyZzucWtjvGxJrERMfYNK?=
 =?us-ascii?Q?1wqcT++/+KCzpP9ODk9tExevsph4MXElRLl2zKJYqnxvDghs6K+DTR97Teoy?=
 =?us-ascii?Q?/Y7VmFL2MzqdknaxKNtc0cG1EpcUe9othsTmyqKxxJLGN5YvdwDEGNOzS7u4?=
 =?us-ascii?Q?Op1XahQFWe6gbbvxwbnptNq3vqmda1sCsH82v5aauuWyhqCLNibQ442+88bf?=
 =?us-ascii?Q?QjXh2Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc54eca7-c366-4d83-9a44-08db383fb249
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:44:03.1922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myT80Su9COvlEMSNjOJbcRMACRVTidXwOD28xfOfGjV4J9OAwDOzT8tSVYjjjcq01e9vDgKl4Btgvj+5PvhnsxS9Gv1uHD6l2tE26EFTduM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6289
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:41PM +0530, Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> During the initial design, the IPv4 ip_flag mask was set to 0xff.
> Which results to filter only fragmets with (fragment_offset == 0).
> As part of the fix, updated the mask to 0x20 to filter all the
> fragmented packets irrespective of the fragment_offset value.
> 
> Fixes: c672e3727989 ("octeontx2-pf: Add support to filter packet based on IP fragment")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

