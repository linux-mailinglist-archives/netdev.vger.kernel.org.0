Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473D741D65C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbhI3JcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:32:07 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:38269 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349322AbhI3JcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 05:32:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632994222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgMqLc/2CAxXSpqukooo7cR1tG734vgtpKuS+VBBb0A=;
        b=hHn32U3YEVj8Y4fpCzcrhB7W0nSVn/BlUXhxOnOclPBRX5eiFfTVApWhw1jg8bh6u4ezt4
        xBHmWpcTPXSe9Pfh62COX0rr7m55N19Hgcwed1ZMpLhlbF6PUfqjqvsE6sgH5XeOd7Sj06
        6zpjGRImKcuX6UiSKRUgxnqS6pcmVEI=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-zdXEjLdRPCO6ue2D0zizsw-1;
 Thu, 30 Sep 2021 11:30:21 +0200
X-MC-Unique: zdXEjLdRPCO6ue2D0zizsw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDxhHuVyHrpYNB6UQ4ozYVi1EZ37XQ5BHgRxGmjikBvERohn47ETferLAmx+QkQRsnFif+lT/bhvBkW+e1PE+XugmQ3Fl0zyuodfFDkKrGazqvJny2dXwTsfVSjvk23HuGiE1bTb86eQneOWg1/HV12s3GSsP4QTLEQUo5L+vAyYMTl3DOrOpos5ykta57UNyU99xpDJ6fhMizQBZ01sQpR6B7NorU5sCm4WiZys+1ADNZSn2PIwvlzxS658dmdHTJrhYD416Jk3GPCE8AXRVUYc6JI2i8RUV7gED1XpaQ/XfVt3i9GQ6YFH2pNBqUCRli/uFGsdMXZsUbp8cpRMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WA+Wngh51cwpRDWQTKMkMW2yPn621UUyhNrRINcV4GE=;
 b=N+g8BubkCXRefdAq8lXeqOqQWo28zBWaXQ4Mw8SBY5aA5J3apzJTd92Bu3uxyZ1bojHCNVl8TiRR3TrcKefi584QKLhMy6a443/uXfHJ2Xu+6D9N7wXO3E+6IKXY9cEIXtdEzcI2A6k/RraY3eWPPqgDSoJ1RwZUaZq4xRViSLn9ZLBNzEp4iENSKxCpa0SMP71oBSiZAP1IDML1dh8g9lSvUujL8+HNYw1VgvxjxNVAqNs1UnOboH+DkSjVQI9lN9lIS01BGcCowcBqR4PzovC78TmkmN/MonFj8sNkfOL6WyFAKI37iJXI/yfD95wltMuUtV9Xpyz5NWd0xfnRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: realtek.com; dkim=none (message not signed)
 header.d=none;realtek.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB4137.eurprd04.prod.outlook.com (2603:10a6:5:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Thu, 30 Sep
 2021 09:30:20 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 09:30:19 +0000
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
To:     Jason-ch Chen <jason-ch.chen@mediatek.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
Date:   Thu, 30 Sep 2021 11:30:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6P191CA0050.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::27) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6P191CA0050.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Thu, 30 Sep 2021 09:30:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c382a353-cc03-4863-4f7e-08d983f4eb88
X-MS-TrafficTypeDiagnostic: DB7PR04MB4137:
X-Microsoft-Antispam-PRVS: <DB7PR04MB41377695F563D92FB4478FD1C7AA9@DB7PR04MB4137.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H/tLsyWIZCaJTdsYYVXd0gwa85IgqNimJs6DsnpvBj04/jT5ARgNzVXiUmowDBujgdMFSk1QcTiUP4n6vOmZxhPm5FbVPL9/yPPFRYxOzkZwywz6SWt/ikm7s8y1OFo40Y+gZQ379ubUnlPBLpazFn94IESXI7vDYn1QoXmgagdFTwsOv9zzMWQ3/jWweroXBGpEoANyOFY0nEyPpmBsgT8Mffvd2uYvoms9o/IhdBl29HvXFjpiRjitPXLbAwaisBPflY8TKJIkbyPP/eRwhv+VGZLJNFAE6KWjJRorkDdEIDsGKl+lo8X6+CAnNEpKv3ICaTZQTCfmmWdlp+Txp7yox8P3C0hhxssp1kC66vxNelRXwdaLbdltD5O1TNAH1BZy0b5FDKE0j84S10O9E6iI55xhXbtRqDQFhO12hfAjLtycCjyFlsqs37eIk+RFiwU+kMUqtl0f81EQ5WqVTAk4j0mn+KSdKnAEPn+u4uGj9Ep1Hv9h0w+Df6BqnNNGmDbFnpE8y/gSgOwLpoJv2Fd9bJj1nBeOWrrwc8Y7xVKhYW/WMYnVzTSU15yWbUpAV3CvzlRNOrPKPexiY19z2oYUPxWTRT0/Xh06JlySlyWQz2DqK20YEi3euBNTjd0E631UAaWSZ12K2gd2JSe2EILZpLSICKaALtP2ZXHJKAjutpEyaOJOQsh/a4lkPkkf7zLVIXK1wlSPk9yk+sChDbro2G7JK5TKL5jDp6zMF58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(83380400001)(66476007)(66556008)(4744005)(8936002)(66946007)(186003)(2616005)(86362001)(6486002)(508600001)(110136005)(4326008)(7416002)(53546011)(31696002)(8676002)(6512007)(2906002)(6506007)(31686004)(316002)(38100700002)(54906003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rhRK09H2EKEGyIUT8VhgEz2Vv1IYMSeBEVoZbYubnKMGv6eIDVIURGo1Zin2?=
 =?us-ascii?Q?xxGSbO/MR2+N/PDPi/TUzE4fkV3nyfsttcG66mkAIRBzgaHo6HFoAnm1xQ6l?=
 =?us-ascii?Q?s7g6RTfXoE2OFI+N+i7J9/g6G95Xsoqutnf3tHOmwNTMku/ekOPRBdts+Pte?=
 =?us-ascii?Q?RDbMQ+47lKlzeypiQWYoJDpaCf5sszN4D4SoZ2mhVi5rEJ0YqqFc9tBwboA9?=
 =?us-ascii?Q?0uqf2udfJSW3r1qUqYF4Y+zi+yrXZZPr2D3xAQ1+k93BzortBxlF4bekUIHL?=
 =?us-ascii?Q?c+8zJDXT1+gDOL9ACvtkpPafMt2KPPq+qyLxhGVtJAQOKrh1fzAEQzN3qnmS?=
 =?us-ascii?Q?40+ulOVRPznxQAt7nJX+AXkiwrwx/ZBeYXnPviAYGfKqVywK2ejdJlvXswAH?=
 =?us-ascii?Q?sAZgP+m2fA/6Y+oK/22U2qrHLeeIZYkYjnY5OpooGZncQ1QipKlu01iuLN5y?=
 =?us-ascii?Q?5w6tIEgaPY5xXm0uEJSJHBgRb74SZWQ+zqKFYAhNIxxfL6GUKKfFdDXXpAh0?=
 =?us-ascii?Q?1bE9sVywspEweIJLvGgKlazpTS97ZO0HgLDs9LY0xiZcA56gbtU5cGamKbxH?=
 =?us-ascii?Q?snyJaHqx70HSNKld527bm4uA5yLCrvzrrgLO57GJ46dTxZxCgShwz9QqB089?=
 =?us-ascii?Q?n6fMBSEu7cpFIABowE8gdQRxLW3Ubad2R/iI5ea2Nue42Ps6Pv8XmbFmB3D6?=
 =?us-ascii?Q?Zf8CB9U53ooxFi7D/H9WGchxPO9AcaRbrPCdm/kk6Hz8lAleHlcV6YFHOueT?=
 =?us-ascii?Q?xS9diz0TtrRGIJ0Gwvv0DEz2PXgM8MfhAP3nROJM42rrY9v1ao3q5+uN/x2T?=
 =?us-ascii?Q?fGShyfMcIB399l3mI4FJu8s40gt2J32otHZt/bSEu40TiM/tF/N87/5cWz10?=
 =?us-ascii?Q?bqONN/5lfdpmee6llS5uBXJk52HYKPo8x5jbqAqdsUzwdsuFXXuQ5JbHInBx?=
 =?us-ascii?Q?Xg0zuILr4JVAykR1+Iw2XxqsxI+8oiOobBnkBqcTce+viWyaIvDojsOfrUqC?=
 =?us-ascii?Q?tabvvXpuZbWvkN7DpgLTtFTBEUOspP1HMac/E34mnWVt/yvy+czs2dSQgVNJ?=
 =?us-ascii?Q?jy4hDMMfQggqZVJt0y+7rlgWnD2KvkHUD8osR0q6mRjbGcmEeL4Qk5aSrwHr?=
 =?us-ascii?Q?RnwQ8ZiEwh8MX7gvOVncJ0YgVEb3TSpsTH2k+aLH0WoZT5/cqEqWcNbA9CUg?=
 =?us-ascii?Q?6Yo8wAYtozzTSKGiGqOOks8Z4KP47NUi4zAewO2Xm9k8Tjdr9KTv62rh3Dcz?=
 =?us-ascii?Q?DtIKzQEj4Vm9xYC5uqOuay64etyKypfA5RGRoWZggDLo01hH9gvhVgyKrWKy?=
 =?us-ascii?Q?DfBuSP4xifmUw7/x0chkJjTSRo6wVat1Z94Yat0WALzrTVQZfnqmmL9Qt0P9?=
 =?us-ascii?Q?cBdQ8nz11LpAbzA52Habu1gfDyUT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c382a353-cc03-4863-4f7e-08d983f4eb88
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:30:19.8312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oowC6GyiL0nfFj2LEToTxKqklRfTHDMR2Gon4r/D6i/pd5tUz4nV4Kn1ggU4AL/i/TrSUKe6r9LfGMue62U7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.09.21 11:52, Jason-ch Chen wrote:
> On Wed, 2021-09-29 at 08:14 +0000, Hayes Wang wrote:
>>
> Hi Hayes,
>
> Sometimes Rx submits rapidly and the USB kernel driver of opensource
> cannot receive any disconnect event due to CPU heavy loading, which
> finally causes a system crash.
> Do you have any suggestions to modify the r8152 driver to prevent this
> situation happened?
>
> Regards,
> Jason
>
Hi,

Hayes proposed a solution. Basically you solve this the way HID or WDM do i=
t
delaying resubmission. This makes me wonder whether this problem is specifi=
c
to any driver. If it is not, as I would argue, do we have a deficiency
in our API?

Should we have something like: usb_submit_delayed_urb() ?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver


