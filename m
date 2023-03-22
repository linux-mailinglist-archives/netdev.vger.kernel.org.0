Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895A86C56A8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjCVUIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjCVUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:07:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A7F75A51
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 13:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKszL2wDQYlBhnhWKA4gFViGQtgoyKUnUhhhItnWJOVMSNAWEvUbyp2IB2PMczisRmWdZPWVimLJveyPfInIh/BsGjgDqbdDvYbH5mFEr5Rwx4/femxOsS10WTn4ZtPHtlwTBsVRjju5wFSyJhAhPZ8QGUyxCh6DaRFimullRB8Ts7c76m9tRisjTpJXGwgWMAD0BoeLpZxwRJlQleAGYeDJKAlf8D1TIqhdrH3kG/C9JlTw+rdBJVajzDZ56Yr086z1cihOCU+hp2W4E89yVQwtV5YyRbkJREP2Jzj9bYJUKODKwIO3iOJZQDh/iB9T/O/f5FH+C5+aElvHAyZ+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ywoq4HnJSv+hFEJCOC2yQnU53R7I7IMuAh3YRgf5evU=;
 b=QC6oxkdp47LJZFsN2ED9/IfRhISvEYyWHL6jAVqnYHyr1GOuHFcsWq//hAQfzN4HxmxH9beYcZjRUOmv4wl5FKSxeVoucQd+9QRUgVQlM7QKX3kKRmLpAqVfZoUGxuwbOnTQVANGO5lPz0deWD1RtCE/3xzpVzZ09eFGl1cWW/qVBqtMXzRsJbCTvQ+DOahvfp2vrNYbsIaQ3Cdu+V2N30ZSjn2uLiTA595E4v/qpHLi5uAuwxg7WmDamLCeSFEFPSiUumD1I+jwjBGeyX9Nhwa72oURIVO0Rrqvsq+z1fiIYofujV234GvH4IAquduJl7drEGHfCoraU0CeH0Y7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ywoq4HnJSv+hFEJCOC2yQnU53R7I7IMuAh3YRgf5evU=;
 b=P0lXMNWt96CSX2xxOfzVAm/9UoXqaHk2EwQ04+Qh9lhKktsPz5hDh7RsxUu2urqO95l3J86DEHM1C4V4uSmaRlPtKghdVJKmV6YUf8D7Mm3RiDtDGebETvWMJZ9gzvUhWa9Czmpn4V15Frv1jTX0TyQNh8yx851QIGm+sOvYun8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3921.namprd13.prod.outlook.com (2603:10b6:5:2a1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:00:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:00:58 +0000
Date:   Wed, 22 Mar 2023 21:00:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: ethernet: mediatek: mtk_ppe: prefer
 newly added l2 flows over existing ones
Message-ID: <ZBtedOG4W28dKAR9@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
 <20230321133609.49591-2-nbd@nbd.name>
 <ZBsKF4r7bARMFNp0@corigine.com>
 <c6c52acc-0203-f4e5-a368-850d9f459b08@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c52acc-0203-f4e5-a368-850d9f459b08@nbd.name>
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3921:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c02707-4a28-4227-9921-08db2b1026fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1XtoNa4svS9Kc5CNYVim0Ioc6A5hF5WueH41PkJmPwR20L2p8skyhc9OlXFBWzhrfQK9++XkTpZ74j937ahM+6lC6cazaSP/Ck6XTwdVrCblB2JciqioQLT1guMPe4/6H0L1sblz9RQcxmDt3wmMg7nMrQaGZTZKqMYzRLjXlSQ01NZto2a5VXk5lOp4JcX7tx2EKBWwYsjQSzhw9EPw4tcQxl/4rYSQ1fVMgaWxusXiACy16BaFnOtQJBr1BgroFnLxUAdkIl9ye4rWafX76+a+iwU2TkvOGnZyMwsADn7jnuWcLBDjtXm6xPuyNQW7yKbsKyp9Bqm6YE3GqAJlJIrenyDM+mEWkphv/Ijoxo+xbDgB6qZ0J1RuXhiQEmUMfnB89KsVKVKdoMFA40obHd5mWYwO/QBNiFeLnrbxO4c2xnxChVCB1xQuldmheblt1fza41hwfaYKzJ7oMGcusZfP6Wb6ZOcGW3CXuaXC64+mee1RrtZiIhZ+FBR3ucpzx1v24ybKR1Ia49yqIiV9sZP+hjXU3PUzTZnLcorMILxCLj0+btUTn8ZKX9r/bHzB0+bq6fAUkxxRXt9CsyjQXAx0qwryxE8+t8K8gxWSo6KWgb3/ZQSUQSHjMGK/CoKVycyNl1h3KdsnoOiI/E5rUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(366004)(39840400004)(451199018)(316002)(2616005)(6506007)(66556008)(4326008)(38100700002)(86362001)(4744005)(36756003)(66946007)(8676002)(8936002)(41300700001)(2906002)(66476007)(53546011)(5660300002)(6916009)(6666004)(478600001)(6512007)(6486002)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QSOJsg68OqQQhyvr0qKLsZ1O4eTdXKo6JUQ5EGEjzORoAzUZTbS6gg0lEDhQ?=
 =?us-ascii?Q?s0Cdy+isErv4bjdxq0hKEVDPiTuVLz0Ji7ZtcJ31qlsFRyLstY+VcXdqOiIb?=
 =?us-ascii?Q?Cjz+D3leYOqY5+aXnWIAIVp0iObKN9E8qwZDM0sro7BqMGuOiJZ6m6bT4pvX?=
 =?us-ascii?Q?ITiXF3RCV1Z9+pabc0yBmhJvjTRGlP/rBqRQmTWKCN4fNkTUoWlqfIq8GY2F?=
 =?us-ascii?Q?kFnYIrUqyDFettoLPuxXaF5FigHdD5Zj1Nw+YnzSb0S0sH3lAyASszpHY0fm?=
 =?us-ascii?Q?iOj1Aos3w/Ww/o2QHZzthjRMS9UoiJwTLhDC+rmQINAQXNIkzM0L3jMisFoq?=
 =?us-ascii?Q?sjHFFcNPzrLwm82zpvrJqWnNdwkMIozkRcvklc+Q3G1mHbv9+ynQJ/ZxItuI?=
 =?us-ascii?Q?Ru2LNf0ckZIMp75EWdmfYNag81QlzFdceovzAL4ycL6F5uTUZeh3C9ZC4qIh?=
 =?us-ascii?Q?hM62DUZYP6htk3kWc5+orUick+BpAHaALQEYYMnVxqw33NoO7fIMzPFg9BIC?=
 =?us-ascii?Q?gg8D6gWKKP19hKhozFhVTipZ4drrjfxwSnSFAlMbtDPLg2jIxrtjHk0nrPi/?=
 =?us-ascii?Q?5Biu/6OtYq9bTNdlZxromUIbfU1MplXx06IP9CMww8eqPYIVCt7ZiuOuAm4S?=
 =?us-ascii?Q?3GnyE3x2wQfBGvsXK9QDx+pivM8ASTS+FCVVgAD/VMXAgwGrYZDBfcY1Y6Jy?=
 =?us-ascii?Q?pqcbe0s/9JPqXZEQRFuTJxmrkHe8PUTq7jnEUVFGGll8aQxN3yIJ+GJx8s1I?=
 =?us-ascii?Q?1otO54IV34U7XO/87ttYvQ6C8SUjF1S/lAW8D1gXRWoynziYVA1c9Z1VH/Qc?=
 =?us-ascii?Q?UikPbuVo/jmlq6XG4YFeZoq+AqJnem8diPU9bKk5RI91M+MR+oX88ZzOyRyj?=
 =?us-ascii?Q?bOAxMxXoWKun+Xr5GG/dWDVxBrk92k8LGJ6FkU43ARofLIbbHy4ldalRuDms?=
 =?us-ascii?Q?61y7+7z4FPLTVviPvsphnX+oea/y7lAHIbKH5uPYFEC25pfwJhUKTJoG9pEe?=
 =?us-ascii?Q?hLzJYrVpf7HxvNewmJbXxsnHCFSRhiovN/GPZjIZUXGOc3EF6o+mN0h+jIi9?=
 =?us-ascii?Q?yCDudDjqI3J81EBxNSgqz6yhNnLhALvxMtEF3EAECTAUjIvn8PRSHDpu0e/l?=
 =?us-ascii?Q?lA6HOghuiI7rp11AvTIoZrt5Z6RqQOfd5wSlY//SG5TM6PUkXeGJV9xZM3WC?=
 =?us-ascii?Q?nVagw1ap9qqoY8bDhJMkNRsLtbzh8o6V6HRgK/vVyTElySDGUbcXMN1dy6x+?=
 =?us-ascii?Q?fmpKK71aMXpJG0rGTTPwZvR4UMTaEHJZ9YTiAGN2UEEmhYtENwJ/vtpGyJoU?=
 =?us-ascii?Q?KqyTLa7Q5beAvKVE8Yg8tIUSCcfZG9qIt0oetm3SBpflBaOT4cFcmbijdmEo?=
 =?us-ascii?Q?CToqBP1zTKfaFx0Iicslr6oo18otC6EF78lGsnOWIj/kR5/xNx9FdFxc7OsO?=
 =?us-ascii?Q?W6iyljhraxdK6MP6dyRRqPY0rZvVTMQtEafvHUsH6n82uht3Louv4DDTzFvE?=
 =?us-ascii?Q?b4anud1240Ecj4KfAjtTSRehNAXq9VMoXhCmZAKGJDxymM/c2jICHsVBXjd8?=
 =?us-ascii?Q?sc5OKYeUoI9mIT5fhqOFXTEfiBHbMvjAqDzyavC00g9ee7hG5DIH1TtnnXYd?=
 =?us-ascii?Q?MVeYejzockq86YdcS3xD2aUvO6jELt6UmCgWscd5j1ue5hAbqV8G908ycVaJ?=
 =?us-ascii?Q?3hDTVQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c02707-4a28-4227-9921-08db2b1026fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:00:58.0275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gNzdjwBs8QpTT42DkUK0q7R+LVR8ZdTg0YcOw7H9kK/RKe7RdRUQvsfbLtDCBiMdpZLX0zMjtbnhGlHJzQUzsK1p3cWEeeCR78OtLrzh/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3921
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:09:25PM +0100, Felix Fietkau wrote:
> On 22.03.23 15:00, Simon Horman wrote:
> > On Tue, Mar 21, 2023 at 02:36:09PM +0100, Felix Fietkau wrote:
> > > When a device is roaming between interfaces and a new flow entry is created,
> > > we should assume that its output device is more up to date than whatever
> > > entry existed already.
> > 
> > As per patch 1/2. checkpatch complains that the patch description
> > has lines more than 75 characters long.
> Will do.
> 
> > That aside, this change looks good to me.
> > But I'm wondering if it is fixing a bug.
> > Or just improving something suboptimal (form a user experience POV).
> In my opinion, this is just an improvement, not a bugfix.

Sure, thanks for the clarification.
