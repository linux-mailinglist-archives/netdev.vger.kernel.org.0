Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188476BFA8E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRNt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 09:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRNt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 09:49:26 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2105.outbound.protection.outlook.com [40.107.212.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A08059FC;
        Sat, 18 Mar 2023 06:49:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2TixXpZhyGPGXOhDSg8xaMNMirWNOoDxckej+jWYd7SIPULalTc/pq9rQ2odcDF0K91zBj3ogkn8iCC9GFYS4OSA9O8Wv3UWbqrsave2TNwClN2hEdBi4lwAN3OqQdKOwnmFcF+Eag4L1vRa8UGqMOEE6VRwX0kNeci5q+Dig8VA1q4TjEur6HBSw0hUrVutKkRAJZtx6CYbS/z3EHNjqf0utWllRYm3tekkkqvB84aACReoeiEFw0BgN9Lulo5yHBrdVfNjM9bLFaCWSijV81UXD/+FMkTtdjrfw7xasDW6jXFw8rwhfWaewyEbtogTm/wKSoSfR4DEf+HsffOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ek6Kk6wm9kfZZFx9/QwYk09Wl80G3rCE0FAYlTaI6aM=;
 b=m0i3whDSaV/yaO5Vacuw+dYOW4J4un29CcDOts9yJg267FmzXuaaa/PmMDwwC62hFbxnOtdg1zdCW8O2sWo7p44ZZa7nDctt95Rd5bEde8iJ9qFrNesgB/JfAz6tR8en1YJhgWNHlW5af3j2KP9FRozmPxri2lQAoic5owIurSDV/W8GcJDDuGnpns+yCqEpvACvESkgWAVr79oyvSusui7C1RPpK4eTii1mknd91WeXVLe1zgOh2CTnsjAIvgkhDuSOD0OR6hG30Vdk/nGdFHrJ2BuF/UH4AF0kRJ4RBEV76z3m1aM/MoW1WrxdHaDLhZ+hKRwlKEVY+CzWKEuERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ek6Kk6wm9kfZZFx9/QwYk09Wl80G3rCE0FAYlTaI6aM=;
 b=WYjP2UGQhH8SDMCEuErx3AGdxn8ED5MynUMvEAcEq0quDbwta8tYgJNxbW9eb23ZPSgUY4v6xyoNQwCTWQu+mkqCJz7OgyPubqa/krZOVI0PzNJ4b8DK/O7TO/yI+TDi7XiYRF3DxocBwelpPegAOZGUEUYoGmvjrKh/36qR6Gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4059.namprd13.prod.outlook.com (2603:10b6:303:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sat, 18 Mar
 2023 13:49:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 13:49:20 +0000
Date:   Sat, 18 Mar 2023 14:49:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next v3 8/9] net: sunhme: Inline error returns
Message-ID: <ZBXBWnAqsRECYYqH@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-9-seanga2@gmail.com>
 <20230315005149.6e06c2bb@kernel.org>
 <8ea1c66e-e4c2-b30d-b8d0-9740ecb8bd6e@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ea1c66e-e4c2-b30d-b8d0-9740ecb8bd6e@gmail.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM4PR0902CA0006.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: da631662-3956-4ddb-2a63-08db27b792e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qRId8vN2zr6cB2uUrs9hwzy5LhOL31jyhLa9heB039lZ/9sRwaQVEH/Vlc2Ox3fTrLyVHzDyzqk5Dj7U7WqhfZ9NpirgmSa0heE1PHYhBzzjOtyhebqw0BsgC1muyXx0Sft/N8AErea04i8I38G67RfWX66gUZV6ynC4dHQr+3lx6kw7iCthjgxqfD5Y4ybRw6OiLvvE+wgUuQnIB/gnuRITU8NpoL/Eq92u1gvgbXz6h6pBMlGkQ/janhuVoPnvyBq5PaXQ8IbCV/Bbeye9gzuENR6/Z4xdI2kjiqcyeObfrcNL4aA5qp5aPH4xBd9dMGKng8hkUtfcbyyHq4iKaAhKrBCcDvrL3hqniEvBcbMYzdOylkFBWg+0QG9CXdYhFfMy2MnpeqaFto+23o6xKEVqbrFxd1ZT2nEef7i/FZruXTYst/7J19tWIOoDhwr232zOImHJXXXEfPKJqHTNZCnWfJ0tcaSXVL4KoCh0GFYQc40tAf5oy687K+Y4++Le206TwH5O6rjMDYgkGdKsbCnlymJZ1hj2oaVXXSaFknNntwTJWGnw1N3Gy50amfR6JjooQhLaOH2ok+cZwHbNSyXwy97F+rFWw/sGS17cB8qMN60qv5muqDLWvKr6YMPLyTM01/z/mBbxl+1ughc0Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39830400003)(396003)(376002)(451199018)(36756003)(38100700002)(478600001)(4326008)(316002)(54906003)(66946007)(6916009)(66556008)(8676002)(41300700001)(66476007)(86362001)(8936002)(44832011)(4744005)(6486002)(2616005)(6666004)(186003)(5660300002)(2906002)(6506007)(6512007)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGuKkSxqC0MpFbuUWw15rMSeuZJyzBiHl97+eeulkwEjoX2gckKfmsrk/jzJ?=
 =?us-ascii?Q?45K3HAmaAcVwOe7FYc6BNckoszzqXRYQHJG5xcKD9iPKPbxr07vOf8FWqICL?=
 =?us-ascii?Q?OW4mgZ5H+8ZFldF2gNYmjMWO0w8jf/lpJEQNsxGYklut3VYI6rFrnPE1AZoA?=
 =?us-ascii?Q?/Z7t98QWCxwrSOUrc/Y6iscgy42s/I7hm5HcjuFM4+nhF5ktvcOyrjbvikqv?=
 =?us-ascii?Q?jjuVKfsBxJuiOYxzYOlN5GM9zdH55qgKMI26R5maBheQW0ITR2EXp07DgCdh?=
 =?us-ascii?Q?3lMZm9EAubGT1pHutH2HCCjzGPuE/cee9TwsS+znFUKC1IwyZ53N4ZMI8jSH?=
 =?us-ascii?Q?jdNaBKpxrRZakaSl4ouy2YbQswM1TbCZMrJ8SqQ4CliJNp8ZsLLvKRx7Pdm0?=
 =?us-ascii?Q?28nFLdpG6Z4X98TkKmryh2tDtq2xbJUSO0ELmQPmrlysLW1hhaDcCt0iDd8A?=
 =?us-ascii?Q?gydt2JzOjk0GJFYJuzk0ocrF4EVtpgEV9mkjUDbUy9taB+Kx8WKsHBuHkIBK?=
 =?us-ascii?Q?bIgr8txPA9A/5KXbUg06rtdfIWr3eXegncfBn4sQALhPYM7n4TBav9jbEOrN?=
 =?us-ascii?Q?lZMUZ0ukxe8+PlnGybUWFF9S9w51YB9HJRgNJB9bfbKijYrw7Gno13G66mzo?=
 =?us-ascii?Q?PmwTGybg0Sznyn9bDusgk+wKSsZ19cokyDqh/lfhGIzLPpmds3gN+tCBUTTx?=
 =?us-ascii?Q?7zPkacMCKGr1NR2kDLeUIrudJgwbt91+UWTJPBuNzedakltSdmjhHJXjJD0z?=
 =?us-ascii?Q?S5vv0dOqmFs3AI1x90CSP7wELFbBo5/LroH6dkm23uU9+8XQknxBKYEnHHfY?=
 =?us-ascii?Q?6KmRNyVSSwhJrRrQ4APgOhaTkYLQKS+TuwJL45wgX1nHhfi2z+F8AqXhZPUb?=
 =?us-ascii?Q?/oVl4JQkBihc7i2iPiYjFNIge+wdbSI7LCscxh7uQYHt0qBW67HqDC5cVQTT?=
 =?us-ascii?Q?6LmKbLbgQBZaNsbLSFgM2sM8P2tSOCPI2GwrXloWm3RdCOu+RB/X36r9Kcuz?=
 =?us-ascii?Q?/nDXuos3V2prGRB6kDrsiLSu8fMrmqe0BRYWXm+2kJ7fo6daMTWlswEZI63b?=
 =?us-ascii?Q?Xb29o4n3eSH8/J+sIWEusXOlifAGWSmY+Lse7IxH6b90nFZqp3r/APz3goCh?=
 =?us-ascii?Q?fz42O3KFa929sbiktHPRJyhG1yNdxgYDPPnjMH4IoGEGLqT8zp+SjvhPnyvN?=
 =?us-ascii?Q?3b9vaNmdrEwkQZ6v40QL00irxTzwyR/O6m5V0stWh7O4tygJoJ+q+NFr4Djc?=
 =?us-ascii?Q?C8tL6qAFT2wNp/kFkq/xZTLIvO7LCh+gsSusxlPZr63PttA6zDy2K2PgedWR?=
 =?us-ascii?Q?1Mjh1NWEaTstRbEVNc9L5g0Ml6Nj4aCAFYjweWYyZiRQCwm6zTEcfbTA71Tk?=
 =?us-ascii?Q?XEshKGxTTfhJp53xLQBUMWyhpgIJHk/ft3MFGQZ3uJIwYdYNbZri/wuz9NLc?=
 =?us-ascii?Q?vns+MYYupPlH9jWFySuDCVtchpEkm2KlSEMyfZR0Xze59Yp/fhETH10N3uPH?=
 =?us-ascii?Q?4mPkE7X8whAFxD4G2Zd8Y7wJ4ofHBM/09bJCsU2azIREOqeXmimu1JrY0+ub?=
 =?us-ascii?Q?W1Fi4MxtgpRLeq5+VfDQp8qPtB6QOId1AzkQlLC0ZkRn3EdKlOxaDWKn+44L?=
 =?us-ascii?Q?K7c29ljrWDMHiuhfPfH1k/ExsxDJJINMQfYujEZ6zPu+MnzSxjf+YXyQxQh7?=
 =?us-ascii?Q?VTZ3UQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da631662-3956-4ddb-2a63-08db27b792e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 13:49:20.1660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTwIkMEunFHpArnfT2G9OSxm1dLZOLlZ/QLQM3pEbzK/vg+BzTvbbnqbVoIiIorUxysZ6OgMmOn+Y+pDDZMsoI424DoMQYkOzHPrE4DPSXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:36:25AM -0400, Sean Anderson wrote:
> On 3/15/23 03:51, Jakub Kicinski wrote:
> > On Mon, 13 Mar 2023 20:36:12 -0400 Sean Anderson wrote:
> > > Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
> > 
> > No such	commit in our trees :(
> 
> Ah, looks like I forgot this was bad when copying the other commit. It should be acb3f35f920b.

I agree that is the correct commit.
And the code changes look good to me.

But I wonder if the fix should be separated into another patch,
separate from the cleanup.
