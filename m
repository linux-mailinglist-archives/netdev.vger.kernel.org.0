Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CDD15C495
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgBMPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:48:44 -0500
Received: from mail-eopbgr150117.outbound.protection.outlook.com ([40.107.15.117]:26338
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729263AbgBMP0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMq95m2GIaZpNtT3llygZUk+mwuZgsFIMVp1AZj0V51XFG1eBEE6PS7gpvI/OGAOoyzkHgJwf3hTgXuXItxTOLqzcwv9XCqqEUqO94IolcL7RsoBZ87qs0wxsoLuojmyzeg2ecrS33oboYUeYu0Qxy+lr02QLfAx21hwVLH0dEcwurRH09/dRzUnIU2bHBrz7Ccw/lA0aLfiWEHarOA3grwpmSeBz7yAQiUlC4uW9rIWT6CioQZkBRjEpgNy4I5ZHRcMkLlontw3POuyeXcr/fnNh5XDnd788lSWyiwKeZRkkmbOEN1/KNd6sI3lJ2Qt8/NjB7C2idhWtR54O20tlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6V3fLCaQZjk2QzIJjLgb8cfCdwm3NgfCBBHtNbgn8U=;
 b=Oxj8LM9+Se3ZiaAXIm80Pw236jezLH8fcrmc+vu8fNRcOJsCIRGazJfuhOGSYi6BWJMurDIyxegxCU26yHqFbtQooAh/5vZ8gf94ffEpGq3z64ky05LZU+H4cku9W9j9BD5kOOZNXKFTc2FVuYO0b7JK9PLk5tuh2UJ/Qcsd3G5qqlLnSujk2/3kXo9qz3ae1czfuWj1pskXtSbNNQK4SH1KZcPHmjWFbF+bANhKccC+yU2hjyPMBUbANUKNV/rMw6g9FCfqgt17jx//YhnCgFLcmuQ67AiQo4z+2d0XvCahT8Nv0oPgFeuL5K68g/r2CAfXBSBu9sSBS1W9lFYk1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6V3fLCaQZjk2QzIJjLgb8cfCdwm3NgfCBBHtNbgn8U=;
 b=JJ6bKxxI6eH9O5xMk0alyd8N60b/WKOl4+vuJygg+7q+j+NB3Irii9E6B2UMz8f7BgqEDiHSxF8nBjUwR7Zup1rC6qRcB8HOey2fpFAjuunJboDZvjDUoIOr/8SI+IDifqT3Xxeup8o3XxN3pTx82q3Xw7z/fkt/ZxDsGNliJg4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3818.eurprd04.prod.outlook.com (52.134.71.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 13 Feb 2020 15:26:49 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2729.021; Thu, 13 Feb 2020
 15:26:49 +0000
Date:   Thu, 13 Feb 2020 16:26:46 +0100
From:   William Dauchy <w.dauchy@criteo.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net] net, ip6_tunnel: enhance tunnel locate with link
 check
Message-ID: <20200213152646.GA169249@dontpanic>
References: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
 <20200212083036.134761-1-w.dauchy@criteo.com>
 <ce1f9fbe-a28a-d5c3-c792-ded028df52e5@6wind.com>
 <20200212210647.GB159357@dontpanic>
 <cc378ec7-03ec-58ec-e3c9-158fb02b283e@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc378ec7-03ec-58ec-e3c9-158fb02b283e@6wind.com>
X-ClientProxiedBy: PR0P264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::31) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
MIME-Version: 1.0
Received: from dontpanic (91.199.242.231) by PR0P264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.24 via Frontend Transport; Thu, 13 Feb 2020 15:26:49 +0000
X-Originating-IP: [91.199.242.231]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fce176ef-8a52-4873-93bb-08d7b099250c
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3818:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3818280337FB4E0B97976148E81A0@DB3PR0402MB3818.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(86362001)(66476007)(66556008)(5660300002)(66946007)(6496006)(52116002)(478600001)(6916009)(1076003)(33656002)(26005)(16526019)(186003)(33716001)(9576002)(316002)(4326008)(8676002)(81156014)(81166006)(9686003)(6666004)(55016002)(956004)(2906002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3818;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ji+YFzD7Tm/mEPmwSnScveecHPWHEwhBnMKox/3KXXsach/Pcy1xFxmpXFxLEIdDWhcz3IkvnPBtAOK0Js6tmaIAdzACvpvJ+wanV3lnOAOC3gXA2Fd5BWnhcTXyFJWVMMCDIYG/+BehE2Ts5NqG0MOdSbOKjQIVOZWxu5yeDTLTSVD+VklCkC+G3qT/xJvU7VUIglMe8zYkh5yIfO4s3D1F9kUZVtmq4dzSMZHABuUJMkV5wu69Dg1/7SWeNDFVkTKN5AxnlFdWDIitpYlyT3gpz/vd7ycb7vB8+HPq0b6DFc/DOyTr99mUR5EV0q+oicSco04sLuiKob62hbWb0+WzPxqEZIlwG2iMglLnCb4M5pfSidXhOJxbOOSptBcHb6NPlYftaKzqH754LDqfjLg+e6ImqHc484JxFsJJh6rq9S2AXSaRxfl/PLe/IRHi
X-MS-Exchange-AntiSpam-MessageData: 2woSCQiW/OCM1wx205ZzT9lJXhEe6yySf9+PJCODHYMOOcpJBpjWzZVTGem5NVkokXCnoYBgu0mJMdCnYjC5RMJvIictKPyX/vEE1v//AwTPrGQq6QAlSnDxvliDVKzVCBU7/TLpRBZTEqJUw0ujPA==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce176ef-8a52-4873-93bb-08d7b099250c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 15:26:49.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKAJd0G7GpVoJFWr6FvwWwaJEoGWwkZqQ2RNqpGRld+2wjWAyVWJ26UZSiZV3OlaYcbzQzKIRAfwQ0mfSHp3Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3818
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:34:19AM +0100, Nicolas Dichtel wrote:
> > mtu = ETH_DATA_LEN;
> > if (t->parms.link) {
> > 	tdev = __dev_get_by_index(t->net, t->parms.link);
> > 	if (tdev && tdev->mtu < mtu)
> Why this second condition? Why not allowing more than ETH_DATA_LEN (1500)?
> ip_tunnels do:
>         if (tdev) {
> 
>                 hlen = tdev->hard_header_len + tdev->needed_headroom;
> 
>                 mtu = min(tdev->mtu, IP_MAX_MTU);
> 
>         }
> which seems better.

I wrongly mixed the two codes in my head as I wanted to take the lowest
of the two values; will correct that; sorry for the confusion.

> Note also that you patch ip6_tnl_dev_init_gen(), but ip6_tnl_link_config() is
> called later and may adjust the mtu. I would suggest to take care of link mtu in
> ip6_tnl_link_config().

agreed, I overlooked it. Unsure whether I can put it in CAP_XMIT
condition as well.

> hard_header_len is not set for ipv4 tunnels, but for ipv6 tunnels:
>         dev->hard_header_len = LL_MAX_HEADER + t_hlen;
> 
> This is not the real value, I don't think you can calculate the real mtu based
> on this.

understood, I indeed did not noticed hard_header_len was not set in
ip_tunnel.

Best,
-- 
William
