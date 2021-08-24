Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8C13F61B7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhHXPeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:34:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:54503 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238378AbhHXPeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629819195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxdH+Pfo+wFYCkY18oJKOpQiuiFtH9huoHqmh3emeJI=;
        b=Zsb1p/OjFM3n3CGHRK3Bt2afuCpqg7bg1xHlwwsyqvlL4fZd4JgnOdPyM701ItucULJDtG
        1jQ3rz5mFpSpbW9W4QAnHFezQxDaoCHz/4tacZi/qjGskLIbV8vu3cXbuxv1qIpyuCGR5w
        CKz4Du7X8QbxPiUKwwp9Q3cGHvvgWHo=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-C_bMIdB-ML2rfRcAGvQg8A-1; Tue, 24 Aug 2021 17:33:14 +0200
X-MC-Unique: C_bMIdB-ML2rfRcAGvQg8A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcNbaebkJjk1YbNcnFfB3mjIyUu7XTUehSNiXqB7feuPjTBaEuiVs7mWxRGyW0hp2Ha7ZLEpmly5VjSQMZIlbai3ojhp8FxO+qgbSL1HOPBEYZIjEPRxViVRp1f4mo3FJDJ/wv4cAWyFRqOjjoE90nu6lFk90orMWseAfp97LWuoxy/4cmh+zjz5+L6b4h1KW96PEh2h/234a8z2c30ZaTAaojoGpgbUBarQUQdIaCGWzWD3Fdh+UJavtliRHkdZO3JJtLQHoT5SK4/V0jmX4vfxzdQYI0ZYB2dHr5NoLuqDH5UayYtXcNtWd3FhfWY2bMxQMqUwYNDDSqnfOK7y0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grb43pyCrH59/LXPlWlJd8f0WK9C0vyJTE4e9+9f5aA=;
 b=PtZw7SNfjYuNVfrYSrp8js6zx/zT/FAMO+pBoeeeYVH/vJMZVXVVT0hGs+ZccW25o1/oRE0O7CE/aclfteTu57olvyMCNEApxeAjfUhH+zzT4xUi8qsceaSHgl9wUr3WbO7Ur6Z7bYLo8Tag0eJ/y+FTi49m7JLT7Oz1469JR4EavgE0f24++NqXjJdRlqA10oRbKJOO9OVjQeIWOwZa2JBCAeQfLNB+C50RRtXpZxdZ9AyT+cZ0uT9a4sRf+rX+wbUYtjhCaEOJs0i0q9EP8jOotHy2NQUqbch9VkxmBxrmBE/DSOZ96n/szA6r16drUK68XVMwa552Dt0PP9td3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com (2603:10a6:208:125::12)
 by AM0PR04MB4243.eurprd04.prod.outlook.com (2603:10a6:208:66::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 15:33:12 +0000
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf]) by AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf%5]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 15:33:12 +0000
Subject: Re: [PATCH v2 0/4] xen: harden netfront against malicious backends
To:     Juergen Gross <jgross@suse.com>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210824102809.26370-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <1f98d97c-1610-6a66-e269-29b2a9e41004@suse.com>
Date:   Tue, 24 Aug 2021 17:33:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210824102809.26370-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To AM0PR04MB5587.eurprd04.prod.outlook.com
 (2603:10a6:208:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 15:33:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce5fcb46-0874-430b-8d5e-08d967147bc6
X-MS-TrafficTypeDiagnostic: AM0PR04MB4243:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4243E45D3D7ACD4A85D589F2B3C59@AM0PR04MB4243.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhJaYRB+oHepym3aZfIY62g5heEvhZqk3mz063iX4EBhZV+pO1rY4W0ykEcH1BnRSZmgpGmw7nFO+oGOxMcDmzAqc1vv4CNgMhwvDmo1Lzm6DEOTh/9tf+MMek/Vnvp/QpD8KKptQj9b3qyzDC3X75Zg3ely2d9GJ3HMgPvoDsnFWcDRJTJJnxmf89+IO7pxe2aiwFwI/t4WAWpLjG4gdGIxiHaPrXAv3tXZQqKhTA1zy3loEzBbc4/BapngF2zwRjsaXf1n06KwEbwZ6iX1hZ5QewMXpSwWG/Jm0lNHU/f7QGn1m1Dkg/g3ISS2sdWL0H9EXbsPHPpzrI7K86itS8+PsspH+sB3F0+PD26BKO1JWYeR3koLneCgmxmHbw4CFrvuKBUoNuLPbuwlN/0Si4jbSQMwOoKqy/0MvpsNgWyXgxka6oXxEpl6Cw8NbH9mf2fqQony+EyyOj+CUcpvG9JonIS2mgLbcKJc0JIgJ8x2DLgXR7ar4RgQqbdGWUOZKOpCYl5cWLVRif8dhJe8+P8dF4U/A/BSTe/6OpA7K+bkCtWUY+f2JFUHSLD6R3rmIUYTgVGYALRgE1UUKCoz+kpSN8ZPDG5CXhUbuEDCg5D3SAMsjJOvjc0PFtiHWpeeoD0go5Op1ziiDFEaZcO/OBfduoflxwJuO4D9OvBs3uq0SUd4jMeJ/EezxYeETaaTLKl9MsGe8QcI1dZmMvO8sUVeV63m9o3KiF+N5sZYTos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5587.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(366004)(376002)(136003)(31696002)(8676002)(38100700002)(26005)(6486002)(6862004)(31686004)(5660300002)(86362001)(54906003)(956004)(316002)(478600001)(36756003)(2616005)(66556008)(66476007)(6636002)(16576012)(37006003)(66946007)(4744005)(4326008)(53546011)(8936002)(186003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Xc5v3u6SFji7w8Xo8QvPxLiF78ZAz5cgpsMB+isIZRBQWluQZPpQaH78Z9d?=
 =?us-ascii?Q?cgmtu0obejJMUJhtlHteCIERtKRPjrZy8UBEFWrb+kW+IvmBFq+KNLsEsZrG?=
 =?us-ascii?Q?9CNI+gIJBnq7vuE5yginjkIpG/EdAiuK8USc9Br1oSwluIUabOqvuyKwhioR?=
 =?us-ascii?Q?xN05P+hb7wyQJfRLaqPZPCQET+W+7qIKfxm9P/dV5zlM3kdIlRTDbAy9zrYD?=
 =?us-ascii?Q?PhKzQ1QX/U2y57uiNC94wg+YiQECm0ybha0eNOwvB6yNBSiPYZ9mPUywPJrn?=
 =?us-ascii?Q?zi+GiagCyoMi2MFldvW2PxRCF+cKVLXM2CaWz9TiFqX4vV1Pg8KNV67MdrRd?=
 =?us-ascii?Q?i+qRlbBACAQR/pAecTBPbc0tZSOLyXLfs4JFA8j84/NXRqz9x2LbeZYgG4BP?=
 =?us-ascii?Q?jduo3Q8pG91uo9kCsWLLx6q5W7v0nAzljPRmgSAolR1/A7HEQMWS9gvYlVRD?=
 =?us-ascii?Q?Ns3E/oNU09TPMvVL6/BlaN4L201klsG42qcC9SX8jIuy5Od/skZl+DZKuFwB?=
 =?us-ascii?Q?hChdeoYsJG5bs33ogYoau011jjbBROxPziqoFFQLQhPYMIO5S1+/qCqFR+Fy?=
 =?us-ascii?Q?5nJhcDz5Eukvy6gFfELndJ4AXj+Gwr1OJgvveAz46c5cJyLSFBjuxfzWpcDn?=
 =?us-ascii?Q?vDiNwAGWQL7oEed1U1b5HpXdEdEMgeqbpIUNle6K9d+LlIp4obak1XKiFbHL?=
 =?us-ascii?Q?sQIa3+Ncwg862gR179TLofAeBz2c5MNgD/qwHcC2tNC45mYzTqj7AjWJPtWz?=
 =?us-ascii?Q?qB21DZaXts2IxEYRvC9LB8mSFSor2P1ZkirtYiWa70XmnefAFSjt2mqgHmr8?=
 =?us-ascii?Q?1Ttnj5CxHV2DaLefB5jC9xK3dk60EKwDHx3Q7aritd329c7dTcRK1UahcLNB?=
 =?us-ascii?Q?bqTgxFbo/jyZAs+6DkdMkPXCcrEbM/UFFCojSZOlHrYsSEGpcKvBtwR/+OtH?=
 =?us-ascii?Q?OIz1HnVXOb2GkQSBc2aMfprcUAq17lRI4kGgBFqY2O+n+3xhIAdShjVq8XUC?=
 =?us-ascii?Q?O+6MCoHEGuZufU0rnPBIRygp19aAsHvkX3BpEp9fdwnesbUiEr85i9zpNITH?=
 =?us-ascii?Q?hl7oeQ5Lnb4ZZI6+zPa1fJAoHHzERU/pVK6uEUPVc1TItmlSL14paK2EERTv?=
 =?us-ascii?Q?qauv2L1Y6dIoGdBLQscOO/bmU0OGP1hQLD1PBQl6a1iYF4vb1ATmFtHbejIk?=
 =?us-ascii?Q?nYv4JEZtA0GDT10PhGVJtEM9Ugxb/vLnICMyaYRwbKkQqbhtSy74Wf2oxsjg?=
 =?us-ascii?Q?FaITvAKDVkHhJ/FUcA6kBJhLc1xvGh9cAonPH4eGmRaAjXIBGXEFZx1S2FFG?=
 =?us-ascii?Q?dblG33bSKTgPKgroqRNY7Oxk?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5fcb46-0874-430b-8d5e-08d967147bc6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5587.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 15:33:12.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/v3wGQw81b+jRZg3DbY7Srn6wfXikLFSZ6wNWwZ16/nEuihKSmwpceXkv1g/9mtsuO72N2c6IIwEIzi4WXjwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 12:28, Juergen Gross wrote:
> It should be mentioned that a similar series has been posted some years
> ago by Marek Marczykowski-G=C3=B3recki, but this series has not been appl=
ied
> due to a Xen header not having been available in the Xen git repo at
> that time. Additionally my series is fixing some more DoS cases.

With this, wouldn't it have made sense to Cc Marek, in case he wants to
check against his own version (which over time may have evolved and
hence not match the earlier submission anymore)?

Jan

