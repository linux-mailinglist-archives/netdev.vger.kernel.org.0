Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C6693211
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 16:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBKPqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 10:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBKPqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 10:46:11 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5582427D57
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 07:46:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5sLBOoPNefFc6nTtzDLXxxiRhd1JBZPb3EFi/fa3wYCIqg9KjTK6u3nveEkQfti1ncQZe6G7TEpAkUmiQnggX+DTBJXvMB2cdqKKI5MfTYq2ArbdmWJcGSnAVFXGUaXgp0LHi5oyNNhB7tG1fjNc98ow6uogaxBIxbcDy9+q74jKp2kIK/37uoUm05tjkj9ApalEseX87b10olNGypIyL6I0i1F00U+7xgLX5VEU2m3U1e+j6XDvXcdfuyZYGH2KEFGcawK+0zlMM5u+IFzRbAQNTHTYDFmlnjjNF1TjS+2hIJ9Ke9q3l42KLIBi5SB28FdIje5tZFV0p5GmZ9FWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I1ZeFsKAt18pfXWOdiAh+rpp3hzVgdiHuWjwOHawr4=;
 b=frYB5k7kEIInYv0pFeYS+sa4FC2esYcBMXtae/dwT658FIC2Huk4YLq8X95mC66rBHzYykezViXq2zJcHtVan4NqZHhDmGfIoYdPvgYXqUGdVyZpdNkdom617ih3MnunqeaoW19fbXZMnoJdd3fgv5zhhxtC2FDdvJEszNBrxJQSX11JKfAJrdi4OVlQ2Wu4OVnmVfl/uS3SJSLkFOK6OULZmhorx0+f+5WV6xVqEAKfRTILnK6Ba8q3U6m+UONYOtvtu7jDhK1hk+24PpAATpJWug79IseMGZVthWNYgDM4zCRp3pjcPm/JmJEiRNwMWSl2UU0tsqUTENYEZIc3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I1ZeFsKAt18pfXWOdiAh+rpp3hzVgdiHuWjwOHawr4=;
 b=dFhWlbiH6jzdNHd2kJMyqT0cA0ZWfO6AZ1idHY4q28/AYW8w3YORh3mXJB+04AwSHhiNcEnYwVjtiUh8D90jCi+++QTibR+z+43rMWI5O0WjvXuY6ZqhZyAai/RTOaZWJ8umroGmIzQPjgEjXhe3rpylOIc08iT9o382RAaSQIda/3/OVrU3jOgaXSJkJmccJIHtoPk5H7GpeX2M6azLZt73CadqTm+MBtMwnKO4+mpDV+l6JPlzdjkl3nZFUL9OFUy+GxoqjfA6nSnaCvN/4pScb11q+GhinWbNLDn+vI2mgClbXg9204LwYuEr/A1TSpW0OByGKGneV2U32aFYDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4897.namprd12.prod.outlook.com (2603:10b6:208:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 15:46:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6086.021; Sat, 11 Feb 2023
 15:46:05 +0000
Date:   Sat, 11 Feb 2023 17:45:57 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        razor@blackwall.org, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/4] bridge: mcast: Move validation to a policy
Message-ID: <Y+e4NTGi7VASbm5K@shredder>
References: <20230209071852.613102-1-idosch@nvidia.com>
 <20230209071852.613102-4-idosch@nvidia.com>
 <20230210192057.4927b002@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210192057.4927b002@kernel.org>
X-ClientProxiedBy: VI1PR0101CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::52) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: 0705a123-2cd3-4d49-9f99-08db0c471627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPg4TFBzRL1gocF7x+cSttREtpJQyV5TLLW3rBosAQhPZ/rjfm++Dv+yv94VD44nGA/lB61IM00HwclesGQeIv2+9Sh/qwtsEipDpkDMyqLGKrLjWgYWOR7TLtqjqsKDEN6UUFhUdFCKVvFKm3wpYysLv/2N/31S2Vqm167RYUs8AuurxLt8PbLsh0iGELbF1TPMDJZkzW58eQxyhaJqNM/6WHaUFASmzTDRdLmJuzvGYWNk6WWq6ABJ/HTg7B0loGccQHIK7jPgOWSVT9peXfvJVT1zkWJezwfEcw8Ch+EbOHadRsCtqGkkK3RtgOJ9hTyrl8HMWjHQHtamtL586cUQ4tFo70DhJPxQ2yS/owoWC930ZJxW2zb9T8RNi6VoOP4z691CKl8J0jgaVPU3UVmZN4VbT1tG3ggH4/LqlTBVadlxPb/IM76+wuaj0QsUk4Nxpglb2ZlKD0pvUlS9aSTk/1mablL0068vn3wyHCAhDcDiBkCzZ2/dqm1E3zR/5WefYFF9hSEwhFaz7Epli5oEYmp7LbS5S8wgeP+DX6nP8ciG+J5o3tLmd4MNObiaIDeS6gncuA+Rmeso9lCsQkXPIjbojc4fqDAdqKtD26fAO9vk8YctOKF9IdOwOYD/EP3BsYCTofa4phaGi3cIhWlnkvWsuYaNGzpQOyMDSt+VcmurtzHakTnq+MzqLQ08
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(346002)(366004)(376002)(396003)(39850400004)(451199018)(8936002)(5660300002)(66556008)(66946007)(66476007)(83380400001)(8676002)(6916009)(4326008)(41300700001)(316002)(38100700002)(26005)(9686003)(107886003)(186003)(6666004)(86362001)(6512007)(33716001)(6506007)(2906002)(478600001)(6486002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ksC+0zUWuLBlTMgaSqahIDo5GkzImsp1VC6ho0LO8JJK1GeBzXY3gdFIQivt?=
 =?us-ascii?Q?jbCt5kIgeanyIjWP55sKrCtbMbnUW7xCj3N9E5kqzumOnyq0Z8mEsvFAMwQV?=
 =?us-ascii?Q?qQmCyAWWBw4MwpJEzc/XQklTB7WjKboEMulQE2Aob8fCFSfxiOghqkOTj9vv?=
 =?us-ascii?Q?3ystIUSxK1tvE9aqkQ++gJg7hLhZuxbcpapWtwGNZ4q6JCEEcICWCYKEtvcy?=
 =?us-ascii?Q?niAsFdW2gNWMeY+o+fs46JvRcY3YCD75qXAH20W1LYk777tyd1nJJ5tQOmg1?=
 =?us-ascii?Q?jnbouTvZNJWOB12P3cguw09gKAbEKiYZwXlxvB2wFh4Ot05cqgJhfAdZbNta?=
 =?us-ascii?Q?XrEclpEnSraCZc1f2O/YtF70AacSUO5Drn7akXRzGniFfHqDgt0sMlGVxXZa?=
 =?us-ascii?Q?fB19nOq/bFdEjnjgUgkwGAT5C8X/aDCN7kbM0FzyvttAzpky+a96vyOsRavS?=
 =?us-ascii?Q?781wUsMsaW94AjD0Q7y4ZJr+mpbp7A1sPYiTqqGrZYDYHG4Nrt7hhrzLrbQx?=
 =?us-ascii?Q?IO+GVSOuqhErdWMHAvzMB+tVnkhyO9/dm1G0+fnAkYSS5Jz9Y6HUupyg8YK9?=
 =?us-ascii?Q?uQG4d98se7YczB1h/MdssVqxfjOmjJ1orcUjbtCgsjEoEIQwOI9FAUHW5pTb?=
 =?us-ascii?Q?AFUwd4aSFd4Am0yBUNqXAkGVQ6xX2lVY86Yz2MJSuhxYWoGG1su0BYANs44Y?=
 =?us-ascii?Q?X+fJkOG6XO0rh4H4aQTlCnvNLAwpW8Nwj8mwDtj84MHfvVVThAaVT2pO4q/L?=
 =?us-ascii?Q?RsEWMgoJmrHyqMRs8h72SOLW1qD71Udyw3yAsxofDqRfutGzhYygPVYBXpnu?=
 =?us-ascii?Q?v9jMS8qU1JF8nytVm/7dWFma4oQJd3gHwFVNpqSPP9dAfd1p0ryso3zzo9f3?=
 =?us-ascii?Q?mZrYQLm144tHzCFcUZoQy0KBCkjREZY6717Uqv2wsablytwH4DKkvwTtcSMv?=
 =?us-ascii?Q?vDSD6mayMMIuYyTmCuuwhoGV5SpphkrVR1G+vQUsMZvU7i+AYdcYoY/5sGz7?=
 =?us-ascii?Q?QuQxJsvqaVj8oeEt9NwL7G2ijKN94T0C7Ype5yUHhSh82B2LKJxOixIHt8H7?=
 =?us-ascii?Q?aG32kzYXACgrlBogq27KdO58wY/qt3jY4P+KL9YFqKrIs0IzOIUAEQ9/cnp3?=
 =?us-ascii?Q?+W66J6Fwog10eNDtapfa1MIa+8giqN7If+NSm9tfWqDz/KSATTg2Rh3pwXKU?=
 =?us-ascii?Q?suSGA+1c2gEaQme6JoDbPRLBcIfwsEj4djcNDdiH9y1KzeRPfM0mchhd50Bn?=
 =?us-ascii?Q?WsIGt1keYpQd5DWExVs/4HXjqcgA1sq2w/1Op9SlAD7V/Lg9awPipxZCnY0H?=
 =?us-ascii?Q?Wf4wq2GwBxdYY/2NOOf0NksbQPFA2534FYYoepEvjuM8TPR9jNnSSfzhU1CL?=
 =?us-ascii?Q?lfAd8w1d82FG71QkWG7rE93aG6Ibib5lmCcKsI7+nDjHk9C98/RrQoUPXxLS?=
 =?us-ascii?Q?ox1UUGr60JujMzyXzT3058f1j7OEdzKk2JMU58YuXbY7mxDa95oBfs8bbfJ6?=
 =?us-ascii?Q?co2lvXH8DLE5AxCarTMQUmY3VlVj5h1cwwmx+5XtDAKBueUipJg48yTz8FbQ?=
 =?us-ascii?Q?SaI0YwOyFqYL6QjLIPUzQQWppJ4UYs2p3CWnZ59a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0705a123-2cd3-4d49-9f99-08db0c471627
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 15:46:05.8387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGv4OO1RRkI6VWa3DQcCH9tYSdk3hW38u8FsqjRIoRmDriNdlKs4Llx4JvPl5ZW69JKJ2JHtpmz8ihgYkPtiog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4897
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 07:20:57PM -0800, Jakub Kicinski wrote:
> On Thu,  9 Feb 2023 09:18:51 +0200 Ido Schimmel wrote:
> > +	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
> > +		return -EINVAL;
> 
> Well, you're just moving it, but NL_SET_ERR_MSG_ATTR() would be better.
> We shouldn't be adding _MOD() in the core implementation of the family.

Assuming you are referring to this code when it's moved to
net/core/rtnetlink.c, then I already removed the _MOD() suffix from it
(as visible in the RFC). I can squash this as well:

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c9f878a28d32..491e4231b3dd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6138,7 +6138,7 @@ static int rtnl_validate_mdb_entry(const struct nlattr *attr,
        struct br_mdb_entry *entry = nla_data(attr);
 
        if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
-               NL_SET_ERR_MSG(extack, "Invalid MDBA_SET_ENTRY attribute length");
+               NL_SET_ERR_MSG_ATTR(extack, attr, "Invalid attribute length");
                return -EINVAL;
        }
