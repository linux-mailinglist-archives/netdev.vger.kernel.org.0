Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656CE6A415D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjB0MFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjB0MFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:05:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C353F10418;
        Mon, 27 Feb 2023 04:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCbOEzhROl2nXFqGz/Wy/OTXGIm9x5IB07Usirj0EnP6/cHtmR/f2bQ7d3g/YXON0BFVRzNPTks5EYmjoFWin1lC1R35UI0y53jmeIJbBDzMHYQmeFzA/Qf/f7ic7dgBznOk7hthAmbriqxHRjwor0MXl7JGLtV14E/uEwk76u1xCL+vT/gxRvH/mzHtcgS9oLu5nQoNn17KmUqXzObjv+3vCE4KmI6tqRxfItzAtEGXeWpdQtZj5IqIOQi1UKKMttGMUnOppVLjGMGIPmF9UYXf2dLGA7mDhSCKItM1jUsbow418x0PjyrO7bZOwDS0NiesU271TYhJ4S6tCPdYxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jW01qW+X7eb3UABO61kHwp1lDFEQB75fNXGZ+wEZbgI=;
 b=UhwT4X8/21IdxrIWuqWR8kKzO7iqfRMVggrtUD+luzZ2xLpLX1ONjfiVCAFSQ93fdNXRij/Vr7eR5r1mmguoBWqkuvn+stUQk3X42pkISahL7QTZrvzjbZbsI5KwqXjKaS6TfP8YJcDz74hYeY6Kaxj4Ad0i+wgjA+P2AQX1YJh1NG3EaC2ywkEryZic6yEa5Ia9O6x1mWLz1uQGMeApyhpUyPhgCM1iHSyBQi/Qu4P3ER3LskoxKeZmm3Ta7KhoGgnAQe90YyBmGxU2zhR7i1P+NetyB5TyFziMxhweXYbEuRSzSAg3XSjMA/7ugRk/D/pmC9aevuEbBz1+5Se5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW01qW+X7eb3UABO61kHwp1lDFEQB75fNXGZ+wEZbgI=;
 b=aJU4SsdhbvdFNQdw9a/O6CI7kIHYpf0tVv29JXLEzAIU6ec6GkubL25Z9DXrPlGA4xUn3NBklmNZI/IWuvn1GY29rdCmFY6XHzUdyQe27/wAs9nM+T34HCfYVnC1BtgTszBz9wgf+Imb3BCzknUn6xfFzGwr0oUHPJTFbG+Boz8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5606.namprd13.prod.outlook.com (2603:10b6:303:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 12:05:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 12:05:21 +0000
Date:   Mon, 27 Feb 2023 13:05:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/yce88du5h8f4tG@corigine.com>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com>
 <Y/LKpsjteUAXVIb0@lunn.ch>
 <Y/MXNWKrrI3aRju+@corigine.com>
 <Y/QskwGx+A1jACB2@lunn.ch>
 <Y/TvS+D76/N0WyWc@corigine.com>
 <04374e51-c7e5-b1d9-d617-d1abf47ec44b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04374e51-c7e5-b1d9-d617-d1abf47ec44b@redhat.com>
X-ClientProxiedBy: AS4P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a204fe-3ae0-4e3d-8c60-08db18bae664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAXiyPBXv1yxykAUrDCo00OoXI4HpS/WbFUJBsPVzCSepTS4QG5uxCAAGhapmOtfzOaHPmgPX7+NSjvYv4UC2tk4ddmsSQjJ/nWgk7T4OdDmd0OV0GDEyybbVinueB+6MMTgVnfpvRgEgp0gWSis7usnzxDZOPSyFksovhFESi96ycyFLv0vbP2IaxhL3oT2yMFqjjGW0HAYrBDDu0hgX4MVPVJ9SQuA9X2wXXeHF8Fu0PqjK2IOzH+jSb7+vWxZbGgoyWLFnQeMeRPw8ijf2BkmUk9Z9ZUhY6uZZk/wMKPfmMvnajMTw/MN1Rvpvl4zklTmAQgYuL0guNPIKhPVOuBV4RQueKvM+YREljTLP3+GafLAQ+VTkURrz/IespCuo45ija05Re9cKhs/s7+Fuj4ekK52EVafjvY9zH1BYzIGA63rikSUc/OkUb/lDGC24bzDtpOQsBgxRR3sPqWKLjXcLrsT3L43H7Qs2cGN+gDW6ZbzahV1knTkAE8jtecUjF+cBg4hwzdD/iTVvEaTMECFymeTOzpQu0deJ2vKZZbOge3tLv0FRCq+a6kR+bN8CuRFJ4UgIFLIE+rq5bICSbSUuCZ5EhBHvvQLJ+TaM9Hq0Fqri71HI2Q/eqoo67oN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(39840400004)(136003)(346002)(451199018)(6486002)(66556008)(53546011)(83380400001)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(36756003)(2616005)(5660300002)(54906003)(7416002)(44832011)(478600001)(966005)(8936002)(41300700001)(8676002)(66946007)(6916009)(316002)(66476007)(4326008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVdVWExORVAxRFgrVTh2TnlBNHNMQ1hBcS9kL2JSRzUyK1VEWTdRcXRBVzZm?=
 =?utf-8?B?bHArUTJ5QVA3Y1N0anM5NmRlYWF3ZGRhUGhOUUc1SndPdmcvTW8rRno4a0Fp?=
 =?utf-8?B?NVFSamloeCt0RmJLbkZpNXlDRHRhWkovNElsV09yamNJTjJJaUtVN2FLSlA0?=
 =?utf-8?B?U3hKbS93bUU0TU5PQ2ZLbFhtaGhKVysrVDJmV284Z1ZPODAwV2pUUmk5dDZy?=
 =?utf-8?B?aE4rMjU3VGRQbldQT1V3WlROM2puNEE1L3A2Sjc0VE9qWDUzOGl5cktOeU5X?=
 =?utf-8?B?eGJDcEMyMm92Q3czd0F5MDJvcDI2NGtOWnp0aVhBd3BvQ2h1TU1vdENTb0RJ?=
 =?utf-8?B?TkFhTWVENzhsRzFjbGpHQlBEV0dkT3VJeVlLRFNvQjBuaVU2eWZKeVBQd2Fw?=
 =?utf-8?B?ejFZK3A5My9DclNyWVJwMEJsS0Q5bkZhZ3ZtUTBPc21HWlBkeGFpQmtWdHRL?=
 =?utf-8?B?WXdxWkM5OUZkdW9uSXVuLzlQTElTd2Jlenp0S2VKU3QwL3AyTGFrMjdmKzFX?=
 =?utf-8?B?QTlsTUFRSTFWZTZmTTBuamZjY2tGVFBoUi9sSkpNOG1WeXlVbUNkTWFkT0gz?=
 =?utf-8?B?OVZCS2dPbkZIUXFNZXZqN01oUERFUXdNMGVKVjdUUHJMam9DNVBUcWNseWpj?=
 =?utf-8?B?MW9tZFBWZjhSZGFJaVNCZ2VPRVIyUGRoc2szSTNCV2ljVHRqNk1Ta3FnNVlw?=
 =?utf-8?B?a3VMWjVaV3k3dEtGN2M1cXRyWDcwZ1VZMWNYdHlUQkpxandOci9aanVBaHVB?=
 =?utf-8?B?MmFiUmtSRWV5MWZRNXRrakw2OHBWQ3k1Z1c2OW1YaGNxTExOaE44MTN5K1Ja?=
 =?utf-8?B?WXlrVUNVdnZXZW1oQTdJdmoycmxGUWhKWGJQalgyY2hnRDJZaTYrR1NmbUNv?=
 =?utf-8?B?ZEtZTG9yK2VHZTlmTFRSOXppbUFURVlVVFBUU0g1cWNnRlJDWEFHNXBuS3d0?=
 =?utf-8?B?L3g1MDYxVGtaN3RueU00a1ErNDFIV0pGMFFRY0R4L1paMmdnNW9TYkNpdzdN?=
 =?utf-8?B?R2lIcUM0eWZocGNCK0NNdlJ3dmE4VjFSUE1mOTlJbGlja2l0S3NYU0VGYjAx?=
 =?utf-8?B?Vm9xZ3UrRWZ0bzdCVit1MmtGYlNTQldmVDlmdjNpV0pBYXA3NEx6L1p3d2FL?=
 =?utf-8?B?eUs3K2ZlZkUydFRycW1waVlZeDFpQ3RTUVJuZlU1QSs4UEE1dlNXczRKV1hn?=
 =?utf-8?B?bkNIdmJPOU11cEU1TXhmZFhaeGJGTHdZOUo3WXJIeUYweVoxTFE1K04vb01V?=
 =?utf-8?B?bUZRZHo2QnYwTDJZd1UzUzJMNUhOOXJvOWhKeVp2UUwyaGlNYlg3b0lTSUlp?=
 =?utf-8?B?SmZ1QTF6WUc3RkpLZnJDMU1sSmR3TVMzZDRYTXQ1ZnB6VW1VWFlPalcyOEdX?=
 =?utf-8?B?YmhWVEc0MXVZV2NqOG1rY200Y05rQTVPT2x6My90S1NKOS9SbVZCVXRnS0tG?=
 =?utf-8?B?bXdIS0x1UE1ONE92RGNqOUF5b295eTRtN3BLSFY4MGpibEdlUEJOZjVRaUhO?=
 =?utf-8?B?ZEVlb1pFT3piQVc0Y1VqZGd3NjdRL1l0VHkwR3pPQUJJRFdsYnhLME5kQUd3?=
 =?utf-8?B?WW4rR2VvRHprZGpQUGNyUmUwckJEU2d4eWhaUWNKYjV1S0NRZGRBNzRLNzRR?=
 =?utf-8?B?elpvOG5LSXJSdTkzdVl0Ui9weUFXTEdNckVLQnYxeU5iNnR3UzNXb2lzK3h6?=
 =?utf-8?B?bjdqaWw2cDJvcVhvTlExR2JiM3FZVCtCUkg1QWdDK2FXNTFkV09VRWZocXlo?=
 =?utf-8?B?K0NOWTNRblBYL1FNRTk5eU5ibnkzMUdpK056eGl0ZHpRei9pWFkyYzJnaTZV?=
 =?utf-8?B?dnFzVG1YTkdwenZvanNtVzBOdGxQSFVPYU94dW1kZlZyVG1NR29idkNGa2Vt?=
 =?utf-8?B?aTlQN1BCendrRVhLQUpSZ3NPV0wzeHRXVHNxSnlIU3RLNnN0UXdWdFVRN3NB?=
 =?utf-8?B?SEpmbUFmWlFoZlo2d0pxRnN1MFBPcEdoSnB3eXJBSFhhaml1RUNncURwbDBH?=
 =?utf-8?B?MkM2QjNWSC92VE8rTTRUMU4vZmwvQWt5NjY3RE1HNWZsdUxEYmN4YkpYeFd6?=
 =?utf-8?B?SFRRWnJuU2xlWWY5bWUyb1dsdU5kc3lZZ1hySERZQ1dtNzBLQ2pOUExuRk9O?=
 =?utf-8?B?QTBZVlFwVWROdEpZditWMm1JOFVDWi8xRFRTbjBVNE1VbnMrclZMN2h2bkN0?=
 =?utf-8?B?MGNMRGtIKy9RYU5yZjgycVZiNTdSdlZwTTl3RVVnT3c2UzBqdXhMRi9Ba05t?=
 =?utf-8?B?c1M0S3hDNnA2MXNQRUQ2bTBkcjdnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a204fe-3ae0-4e3d-8c60-08db18bae664
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 12:05:21.3588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3BZ4hRw7BBoCcC32t7KYG7Pt57UDg3LO3ACIPSD19A55rJI6t9Lb1MhhW7odv0pX7WLzPRMiFXlOWoFX4t9KTpN9OaVODs8tJR5U+gorWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023 at 07:15:01AM -0800, Tom Rix wrote:
> 
> On 2/21/23 8:20 AM, Simon Horman wrote:
> > +Arnd
> > 
> > On Tue, Feb 21, 2023 at 03:29:39AM +0100, Andrew Lunn wrote:
> > > On Mon, Feb 20, 2023 at 07:46:13AM +0100, Simon Horman wrote:
> > > > On Mon, Feb 20, 2023 at 02:19:34AM +0100, Andrew Lunn wrote:
> > > > > On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
> > > > > > On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> > > > > > > A rand config causes this link error
> > > > > > > drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> > > > > > > drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> > > > > > > 
> > > > > > > lan743x_netdev_open is controlled by LAN743X
> > > > > > > fixed_phy_register is controlled by FIXED_PHY
> > > > > > > 
> > > > > > > So LAN743X should also select FIXED_PHY
> > > > > > > 
> > > > > > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > > > > Hi Tom,
> > > > > > 
> > > > > > I am a little confused by this.
> > > > > > 
> > > > > > I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
> > > > > > But I do not see a build failure, and I believe that is because
> > > > > > when FIXED_PHY is not set then a stub version of fixed_phy_register(),
> > > > > > defined as static inline in include/linux/phy_fixed.h, is used.
> > > > > > 
> > > > > > Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42
> > > > > I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
> > > > > is a module? What might be needed is
> > > > > 
> > > > > depends on FIXED_PHY || FIXED_PHY=n
> > > > Thanks Andrew,
> > > > 
> > > > LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
> > > > describes. And his patch does appear to resolve the problem.
> > > O.K. So the commit message needs updating to describe the actual
> > > problem.
> > Yes, that would be a good improvement.
> > 
> > Perhaps a fixes tag too?
> > 
> > > > Unfortunately your proposed solution seems to run foul of a complex
> > > > dependency situation.
> > > I was never any good at Kconfig. Arnd is the expert at solving
> > > problems like this.
> > > 
> > > You want either everything built in, or FIXED_PHY built in and LAN743X
> > > modular, or both modular.
> > I _think_ the patch, which uses select FIXED_PHY for LAN743X,
> > achieves that.
> > 
> > I CCed Arnd in case he has any input. Though I think I read
> > in an recent email from him that he is out most of this week.
> 
> I was out last week as well :)

:)

> I considered this a cleanup rather than a fix, I can add that fixes tag.

FWIIW, I'm happy with a cleanup.
And in that chase there should be no fixes tag
(conversely, if it is a fix, then there should be a fixes tag).

As a cleanup, I suggest targeting this at net-next ([PATCH net-next]).
As net-next is currently closed you'll need to wait for it to
re-open. I expect that will happen next week, after v6.3-rc2 has been tagged.

> From my point of view this is a linking problem, I don't mind changing, 
> what commit message should I use ?

I think updating the patch description by adding something like
"This problem occurs when LAN743X=y and FIXED_PHY=m." would be sufficient.
