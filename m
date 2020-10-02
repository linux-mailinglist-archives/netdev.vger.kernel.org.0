Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E448A281908
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbgJBRTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:19:15 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7068 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBRTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:19:14 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7760de0000>; Fri, 02 Oct 2020 10:18:22 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Oct
 2020 17:19:14 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 2 Oct 2020 17:19:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfCCr7SfraFrwW3GffeomQEIPU9CK3Q1d3AKmddIwDE1F5BLvjo1jYgoiJ2eFOQRYnyu/GJJecZPV85ypXoAT/pEEHXMJWbFfb/Pe2frjfv0Ckw8R+nQm24RIhptyzxDkOGmwJa+OHBvTYeUe9UWmrNaAjUtCWcw3VJX1k3MVPdfMuIadn94dO6LtuiCATuYHsBKt2PtKhljK1q0yDVFj0KKl33FAVUmguju4pfFeea3NoXOMqd0h2oYecmc4AlPEkGiB9tKJiN9GLz67MMTktw7kHlRUEMMSFr2/iY1wjjDyU5cDU4bCOUr2/JVXm3Rip8b0gzaOuGAOy3Ov4Mj4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2CASSuvh6ImnEQoPLZmwxXUSl9QyRRxlFGNcXHr8FE=;
 b=EejLb58VqSwF6V+gL1WiQWfMrtdSSdltL3RH3rDY2iDHMbzAw0Kwi4d1ub8ffypQaSUl/jqo/lZCEJLQ05GPVVH7rA5Sy7+UlrUlBsPKNJnhh3jm/C/LqcoWJQPqLZzbTlMGkXHE9LQBxVcAywTJGEelSXDYG1/bVUWlI6m06Z5JO33h8y03LQTa78B/shZBjoBqJOV9FwU1y6aR8fjoR34cVhg1J5tpJ83DG852Suz9HTCG6E0AATIq4djXBnpJ9LhGTF/6EF3HdQW1YW6XZl4FHnXNacu5jUS3GxkyctvwAbO7QmIaL+u0lGPY1qMZt3M01jS1WRvCH9WpohT4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4473.namprd12.prod.outlook.com (2603:10b6:303:56::19)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 17:19:13 +0000
Received: from MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::2938:f635:96c2:8518]) by MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::2938:f635:96c2:8518%8]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:19:12 +0000
Subject: Re: [net V2 07/15] net/mlx5: Fix request_irqs error flow
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
References: <20201001195247.66636-1-saeed@kernel.org>
 <20201001195247.66636-8-saeed@kernel.org>
 <20201001162459.7214ed69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <99f02abd0894928f09f683fd54b033b03f7eac20.camel@kernel.org>
From:   Mark Bloch <mbloch@nvidia.com>
Message-ID: <e66e2680-cef2-b662-45f6-4c31616d3934@nvidia.com>
Date:   Fri, 2 Oct 2020 10:19:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
In-Reply-To: <99f02abd0894928f09f683fd54b033b03f7eac20.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [193.47.165.251]
X-ClientProxiedBy: FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::11) To MW3PR12MB4473.namprd12.prod.outlook.com
 (2603:10b6:303:56::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.0.138] (193.47.165.251) by FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend Transport; Fri, 2 Oct 2020 17:19:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371ad7bd-527b-44d2-8783-08d866f747fb
X-MS-TrafficTypeDiagnostic: MW3PR12MB4491:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB44919CF2A77E3942324FE529AF310@MW3PR12MB4491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qga04GZa3ke+4mL6VdpLzZw0OeAQB+ECWugQOUBlAxXMjU4H/TbaKQVamOkuFbII1QgrA0dkIOlxmujD4YyVNs7Y+vIvCJq37v/NSyHpC4p07NDfqKT8MeDX/ktLzHwI74T83EpKVNvGvGKDZgb6u4H7G2UTzytb6yajQDfQYw7M2UHSGRdOEUPrGh5QMpa1cTYpXW1XhybZOYu3Lf4q+QiI2OI6bmv0IMKCtzr/Jtf8EBv5WZwvaEh/KL12gXskY1tv7C1ydMydu9hPHavOqsW6ZWSkMZHTPF9vvRBUgzfqz6qeQAxt53V8XoqETsEe+btqaj8zCsAOdqMaIHKrmLRBdvSMuLsbfrOqMnvHPXKa2nVgSGo/OGPhdGwBVVwp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(5660300002)(4744005)(86362001)(16526019)(66476007)(66556008)(66946007)(31696002)(2906002)(36756003)(31686004)(8676002)(16576012)(53546011)(26005)(4326008)(54906003)(8936002)(186003)(6486002)(956004)(107886003)(6666004)(110136005)(316002)(478600001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XaaghPaHyyTUsgUEQcq5bimK0YYKXfokRnzK2MCZMvNJY8DOj6YLdi9ymOvaMYQRGcY3b98BbPa9nMBoLMJLp3J6pK5y7pGwpVCj+Jqo+QyvCIcJPsu96wXks/FblleY9zXB5IgOdy5bRgmR5HwZf4UKdn2XFZcgJUeTxRKFVGnqoeRjoJdtaw/pNPASX119ohdI7w7ELkfB6XsnKNPWxrS5J4whJeWuCKmoqurswRQXcCRqot1o64dUy9PbjLri0LaPa2IGowgSS247tGzhxUd7ac3NCl9nS+dUF8PpKDOX+HD2YN+fjU74HH0AWTVc1LOWTm560IorYIYzg5cFdJVtPS8qIFzjZPybNdaihabmIFWLGfcKaHJd1407e51sUMRYT10mxf4dI2kh518JpJ1DZJca6Im+xxKJJrp7LVRg+KJZvF7j0wco7cu4NAF6LK1aw4oetctdTXChvIcaTJOAhzSVDbj50ewLGvfYE5Z4kCXpM4xv+AE/LAjcpvYygVbxJIKcaC83MboDR2eUEdhTSkBc9DqlYfA93ef9QSVCnnCStyZLINjDe9JyaAl/3toPizMklxakNzVR7YoQ9buE9bbD7s+KP1r+4u15/mvGcUWljx1rhE9bC6b4I36IEkwub3oTIM4Ofb6tDB90iA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 371ad7bd-527b-44d2-8783-08d866f747fb
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:19:12.6185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suQ851b/Exu5Wjt2Dz2NQmh70ivluBIWEqm3JwlcdE20879kLJqAJWevKnRhi5QfgiHUjnutCbL+y/Hd2XgYaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601659102; bh=o2CASSuvh6ImnEQoPLZmwxXUSl9QyRRxlFGNcXHr8FE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=jM3EdQC0gYNBiXlHdERSdq6vxjtpx3rLIh5KBO861exBK6MDz2N2qJFyz9sLsq51e
         n35q9XdY+9yaYyOURKXJYlibM8XmTdiQ6w4zp37Db4y3G14al0iC7/nkdJwQ1qv8mk
         qhIsmtaxJ2fWxEt9Z9jlrEsBoTChoA38I79PRc+VL8pQ6yI5mp75OCoJzQd7ezN3Th
         L3VgNKq0Rjp4kpLs4Ef42VgBqRwi//+dWpRyEaKCfG/wKk9/qySnWvAY5vOyhpVguz
         WleSaGwv+mFBPXOmC41LqgNiiIdFrfmba1zblFXK97+oVCPz+sLETihET0Yip66duL
         bA3ATG1l5gIsw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2020 10:05, Saeed Mahameed wrote:
> On Thu, 2020-10-01 at 16:24 -0700, Jakub Kicinski wrote:
>> On Thu,  1 Oct 2020 12:52:39 -0700 saeed@kernel.org wrote:
>>> -	for (; i >= 0; i--) {
>>> +	for (--i; i >= 0; i--) {
>>
>> while (i--)
> 
> while(--i)

It has to be: while (i--)
Case of i=0,

> 
> I like this, less characters to maintain :)
> 

Mark
