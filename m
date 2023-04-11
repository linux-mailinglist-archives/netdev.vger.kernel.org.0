Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF16DD969
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDKLby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDKLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:31:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2097.outbound.protection.outlook.com [40.107.94.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B535A6;
        Tue, 11 Apr 2023 04:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lewi17DHkF32q1MyMnngF1XpBOQOOKjuN8rKiwsqUUbqwLn5KFiycOQ79cJCHrTq4/NUskofDqNHkdA/wS6BhY+Lkvvg8WM+Qanw3Ze9R0dLy467+BkKbLRjPx6OwemFvGyumoT0ACgJwGvkS6+89t5PtFFD0wCpbMFvqGGy6vENOnwLg8kNr7Aya1qCV0iyyIkTnYwEaRdrkFXQtRToGzNv/UT1e622fA7AVXn6EFo7x+s/j6dB5YravQ1BKoFTu2aN75dyiqGJ9aokeaAtqGYlU2vNEdafHRWVsi7G5amv/yr/wWEdP1OQvpbgedjaTxVzoeyhsf1RO+JrYLr/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=144CTLtC0n8trghsXyT8SvQS6g/oS8OLntO4hvxP2qU=;
 b=X3PZJ7kOBfVjfLE+HOA1+RzTl2OaCFfipRpd4Ei38xkr2XA2hzrFMNxSYhF7vjAjwwEmSKJhKhRbiRarhMHa9nj1JcXzyp/TcS6RX+onVUsWvuZSYDq+jgTa/sMzlTgDS8+nWwZ5KLWWcRT5UP/Lnk9E1C/yvmfb9fM7XARqJXRCvB6TiZ3kiGkZrwqHs/b1LlJTjZzhjo/dQ4GpLBngX9hWzYMBGR1SXidWuKo4QJ35iGnhmdnecumfT01SuV88JYUAqLv1daKrzUEV93Fl9+FBUf59We8cBof/UjN1N+/goKA3h7O8KdJ8oqmHIYHwf3VBvRVv5jGpFe/zIbeIMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=144CTLtC0n8trghsXyT8SvQS6g/oS8OLntO4hvxP2qU=;
 b=A+4jC9P5EjPkmf40CIcvCL3ghU41JF3Mqr5W2Kig33B0JyJI+encfutwaGv8ke0beAWMzs2iLorB1PfNcDlHCJxxNAuTc+GBdazLm+Yxg5zgy+vnymV4pyEGGwrF2bAh4k4F1BEVab/IxpiPNIPcLPwzv0hhwf0menk9nzJR588=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3635.namprd13.prod.outlook.com (2603:10b6:a03:218::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 11:31:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 11:31:47 +0000
Date:   Tue, 11 Apr 2023 13:31:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anirban.chakraborty@qlogic.com, sony.chacko@qlogic.com,
        GR-Linux-NIC-Dev@marvell.com, helgaas@kernel.org,
        manishc@marvell.com, shshaikh@marvell.com
Subject: Re: [PATCH net-next v2] qlcnic: check pci_reset_function result
Message-ID: <ZDVFHe9Hr1csMAgm@corigine.com>
References: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
 <87eef8a06064dc895f183ba2a1cd649c213f3e37.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eef8a06064dc895f183ba2a1cd649c213f3e37.camel@redhat.com>
X-ClientProxiedBy: AM0PR02CA0181.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3635:EE_
X-MS-Office365-Filtering-Correlation-Id: f9617295-d977-4fdb-2182-08db3a8055b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lgwzpmGmu5OfDk9nlrByZupC2JxoSwuZ3vutBlhkSWV9F3CxCKUQB0VlupnlSVate/byP7jbTQucd8+IMZj1Ew54cLEl/EGn4khyhtlz8H+AybWiux2itG0A7cJnreu65bSGF5J2SfgKNZUUDRfeiuvZp3w43S8Y7xTMiJJyONUt/SSapdbzsIpcoyyCBoE9XOkAXJWz/sdR0qTWGMsfQSIXMos977J+Ag0orp+gpCyqU02wYm8x0TlgkHdYpdCN505w+lrF/lVvBhed4rw1KbHqBzBLwdp+HtQVjypMAPM2fMcDu0qniatubLVP/ILtkp83xksFo/0cW8W+NckyJKpzM+/mrySoKINz4uZRQBBSJoLQFfTxBG+fBJFlFXeUBZBwBQ9lhvFtEIgitMq82mTQRw8h8Yll5XSdm5CaK4EUsUGI/x/uQ38gI8Exxzpkdl3Wo3RccWdF51c8E4F8CxIcX+NebwGnT1dZb26JmmG2i3D5ZBj+9JmQXVNFAYf+Gz05no98F0RqstfsBBybcFGeDGjvmvXxMTsMPrJdbUZOxJ16ZuwXfsz0ZhyTDiDB9lx1lZT5V/qcAbGpNoKtT1tw8WtesILFL56B1tdsrrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(366004)(376002)(136003)(451199021)(86362001)(36756003)(6512007)(6506007)(186003)(6666004)(2906002)(2616005)(478600001)(6916009)(4326008)(7416002)(66476007)(316002)(6486002)(8676002)(66946007)(4744005)(41300700001)(5660300002)(44832011)(8936002)(83380400001)(66556008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RjU47hGh9i9QmFOXNXbwj5phlKYWlKqQRtnrxeyWZ4UosUGtOsRuip8jhycY?=
 =?us-ascii?Q?MkoXvoS+lSCUGvTfVTlpgQmNKsBWwur/KcNjowGIhbBHS0BICnLeGF0x8N1s?=
 =?us-ascii?Q?gbpfQ0UF6oMikWq5U+m1a8YRDdqf885YAzX6OBGtk5xMAzx27APdJ3UrC8CA?=
 =?us-ascii?Q?crIN2ptqUofrGdth0I8iWVPriPCB876/6ngZv2sbN0/zn8IQrPJKpDErhHnI?=
 =?us-ascii?Q?U8ov8WgEJKLL+xJ3uHBuG/EN8gH3lJJDIGFGgqp1n8htl61Goi/0VHdnE964?=
 =?us-ascii?Q?jujIC1Zo21CXLyCO6MQg/UgWtAz6fMMooaost8vCpHYpbOocYShFkCK9o9FC?=
 =?us-ascii?Q?DmmJQFzQsiuePldt4u8aED0E7Chh/BN9aCK9e2bYUPdzB3qUu7NGW3WDh5Z+?=
 =?us-ascii?Q?EtBIZAvDhi76kUald5E6qX9u0iZw0fs+phZ7YDiHKkKZ/N/qPPSih7otyhdG?=
 =?us-ascii?Q?aGHOzf26iJySfMkNj+6HjAmFUPxhgUTWxMr1Rum++xXqrkh0DDBBsu2iU232?=
 =?us-ascii?Q?/AASrYaK4GMxsw6Zt/ZeJIoW2Z46EMTR45Fco7E9ulT54ucliPkrEZ9Runs1?=
 =?us-ascii?Q?+ggxovB9JEBA92k1PnXnqbi6YcakIM1g0e75wb48vSpX0AuOufYfqA/YmAwI?=
 =?us-ascii?Q?NaQXcd8bGR/LiK4CaB7+3SpJBO3eKhPH9HWUJz34qmgf4DV8w45PwkjSqp5f?=
 =?us-ascii?Q?xQ5YodgKmiiNaPFH0dk9VDtBvaD6z5/TlhqKP1jsB+KD9oFtnnexJ61aqYYX?=
 =?us-ascii?Q?1h/5+Zfs0YVbB/0l5UlG+Ll5Rx7gvcPQCznYVL/7Na1mkmNO8Y6NhMdsegCX?=
 =?us-ascii?Q?AIld40uHcqVQKJkEfxRtqNTDuqApFmvh6KU5pCejs9j5sl7TP1+mFgFgv1vd?=
 =?us-ascii?Q?1Mh7CLIWSzbcL5FJjz6PbA8xQUfLOiomBoWP15rmAPoSNJHUjzU4OUW8NYKL?=
 =?us-ascii?Q?Y9E2KYwBHD/7RQs8/odMpMzSFPlJ9FRC6nW+b132ojCLxXTrVbtIhTJNqgg0?=
 =?us-ascii?Q?cirHmb9cC7+/Wpx7RJlCPaiL5r/9pNorroT98DBf5f/197WxX/tC6ch2C1dn?=
 =?us-ascii?Q?+vkuo1BIM4+OI5LtahUyQcCudqaqhoRFMnQZD/A91JxpYRE/9H0jFOeOnA+F?=
 =?us-ascii?Q?+GwsmnixaDGEvEy3RNRp8UBl28T35yEUQLR36WwTwZs/7tunsBU8j2E5rB8x?=
 =?us-ascii?Q?00g9BD34jWOxph1+85CFqzJYl1D2fX70qY2Ys2b38POXLpgElmJHXm4z+UKj?=
 =?us-ascii?Q?TUl2aDXvTsxI+p0jX8XdrYasUtpgPL5m6+tZjxByVUzDRIpUomg7Go7NsGK/?=
 =?us-ascii?Q?3wvyb/Rkhzk+Q/IRNJuOOAS4ZIwOtjOEeFWA1TwPYpEdXidaM6Ne5gL1du66?=
 =?us-ascii?Q?8UBG32T5LHDI3P/VQxKUNMNXBmKONlunFcoIPZwUsqFHmmK7DlS3653rUm4i?=
 =?us-ascii?Q?FcGizCtWo6vJhOhN91p+V2y8z5/DNaWWyYXJjrHm0TcJD3ADgy5SueFxqsC/?=
 =?us-ascii?Q?tMP86zYg3/4dJFuveTWDOJEh7e2RjUnPW7X0uRRpsNhdgAWNRp8cdPz5ga+i?=
 =?us-ascii?Q?GdmO7sBcTOZiMwr4rbkAtDjusN1/dceX6I4NgvI1wxH9FSXQXBAX4icxP6AO?=
 =?us-ascii?Q?bh65LQr3YA9NAN6Q0IITliVR8rQrjs+lExnHpJDcfzwW26kkyIJesaL2tO/S?=
 =?us-ascii?Q?SSbPUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9617295-d977-4fdb-2182-08db3a8055b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:31:47.2832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2YjmqBWn8MGTPpiAqjOFGhGR1cbEzINZ4OaJpOJzWjRLWox9aCgUxq7BKrRIjxpGgVCxvKKm9S+e9dSdT32oKwwUlix0J0fbpQfCEoBzaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3635
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 01:24:33PM +0200, Paolo Abeni wrote:
> On Fri, 2023-04-07 at 10:18 +0300, Denis Plotnikov wrote:
> > Static code analyzer complains to unchecked return value.
> > The result of pci_reset_function() is unchecked.
> > Despite, the issue is on the FLR supported code path and in that
> > case reset can be done with pcie_flr(), the patch uses less invasive
> > approach by adding the result check of pci_reset_function().
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
> > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> 
> Any special reason to target the net-next tree? This looks like a -net
> candidate to me?

FWIIW, net would be fine by me.
Sorry for not noticing this during earlier review.
