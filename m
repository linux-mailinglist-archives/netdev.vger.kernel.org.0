Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE046A2BA9
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 21:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBYU2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 15:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYU2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 15:28:44 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312C1026A
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 12:28:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGrrvwFahMq3xxmBjhVnK6cP+jQmiEXi2PU/g4ssje+u0rfn/kp93bYx0SkjBbGJJurMG+j9LrjghqZLGfWykGoRD3FYkWluUoT4f0hBagReXyBtJxBRlLuNWTzGyF0ZjLoHelZNj0TzlmVClCYqoV1lcSNALBKEXroUidlzNLhWVcCFJqaYHklwGTxY9xu+WuQfI1amae4LcxgOt2jlWKRwrXxOxbfHhzyYIAVWdh1vYJktbR5FI04+azIgTO6ylO8AwsJOq6ELBXu8BmaWq/81Uds0/Dh4zMPy2dHQ0lLNNeF4tC6SG9z5DU/bzLC/6PviiW5HWI80VLDX1ROQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuIiNdD2iCCEToN9PYuyVmL96dq5XGVQbaKjVstBoYE=;
 b=Txl0Zl3hIuwFsrFOCpwo7qW3ABFnLIFXGu2Phg2l7K9AC8NK3WMQvJeT0gF8nnjUHK69plZ+GvLickmG+PdJehoT9xMDu8HdrPM09dTVbuNlAu/vB9nimxTRsSev1RQQCw0cl20QbaaORGemAdVPPbub1eSBVcoRC/MLv5sPbMomWNISRuAnxCL6uV0m0MZ1fp0QEErK7dKrnmRypL21sOUZq3Orp0w/ARrvrKAdwYOFJf+LFye3GR5sHIlmYbveWVh8YyXP62wJEgAGcpG/ieCQnRlJTAd6+ZlbQ6AHDmpoTNGls1jgGf3NyeAxVwbK6H7P8E343lEb6iVunqu5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuIiNdD2iCCEToN9PYuyVmL96dq5XGVQbaKjVstBoYE=;
 b=r2z2QM2WeNDik9yNiSKET7TSdzAruGSVsYA7QSHnSBzDTBPTh9y0mKVWm8ecEu75SKvC3s/v97iipuj1Hq1faEjZ7LwG6Ui+oS3qD7f91hCoJIhmqEg2OjJrRjrWwnDITQEMSAlHf/AHTwbujmviv4AzBDuiwh21FH1tPLHzF5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5373.namprd13.prod.outlook.com (2603:10b6:806:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Sat, 25 Feb
 2023 20:28:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:28:40 +0000
Date:   Sat, 25 Feb 2023 21:28:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <Y/pvb7KfNSOXoFnz@corigine.com>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
 <Y/o8DkLO9CY+ROkH@corigine.com>
 <Y/pdcIKpM1QjdUdI@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/pdcIKpM1QjdUdI@shell.armlinux.org.uk>
X-ClientProxiedBy: AS4P251CA0011.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: b05c6616-0fbb-4ae4-8de9-08db176ee193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06DIi4nM74QhA+HL4G4TV/vQfxgkxpxnVBN7BJjgtNcVIiD16ZccbfSP2HGvMhxqFWd7f3Wf3mQfFX57YuhvcXzGbdKA3xm0/5o7ro2zZZKRthCkFu4BSdw9FXjlSwlivYiBzTxP4e9xZla3BD616d2k2zl1QTWNLQk73cKDXzj5psOOS4/+IGpAkPIr9GS7LYFkLEfUeYU7ju4xhai0SuTjKJfQfnTid6ymQXvc8MGZ561x1UdZVz3NlZsTLMnlUPB5aUH+2Tq4CiJ7DllD6vh+bi7x6MjWgqSRCyGHa0ZH7YJV0J/MElFg/UW/hsJRvQaoxwiDBCpXxsnUHXLD6nlWVi7zqn/mhIVyzo/GLyLq+8be6EIoD3ZlJkJ2x1Ch96STDUZKplSFp2bJeLO+o6v+yYx4XbAcPdD/QXC4ITiVVYJIV167tRd5vjd0p0ZB87FE5gtuuUOs+gS4jHsURVoYppc6NIw5KU9ylb8402SEYjh//XVd+16fhHOVz9evIXldKMWEJBIjDBtPEnUNtKjvP5FV3zn/f04n2PU/wrNc6kYDKOhIMjHxeUlfFemcNTejTAm9AP/kDjeGNqXrnAgZ4aZYj7/mF+jgo31Q+1kWAFst1RpOuvJOePqiTLBwmDZhu5PC0l81KXgQVc+MgZgFokcHFxp+SV0J0UXzJZhzjuql1sKaD2KgN9RvZ+wU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39840400004)(396003)(366004)(451199018)(316002)(5660300002)(186003)(41300700001)(4326008)(66946007)(8676002)(6916009)(66476007)(54906003)(6486002)(86362001)(6506007)(66556008)(6512007)(478600001)(36756003)(2906002)(6666004)(38100700002)(83380400001)(8936002)(44832011)(2616005)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n8KyBpiVbYjaEsC+t/xYOImo5obE4KGoHEY2AZnPxGKregA655iHtU+m+Hr3?=
 =?us-ascii?Q?DKu3u+N7E6Y6nEmgIdDf2PuNUzpvaKjctugKSEsVOAhabdKbYsr+Wjrm1Jit?=
 =?us-ascii?Q?Mh7Wtv4UH+yiAam8ZV9H+2OWBXUk8HtMat1peyrCTn3ulZwo67/DxEc6Tga4?=
 =?us-ascii?Q?x3slqPI70lYOJfDJDv9wQCQLoj4AlD+BJeFF5CEJPLNA0aBqf7X3XquhmfkD?=
 =?us-ascii?Q?zklraNv+RW17qfGdac9BR0M6VFgAaQo5VpyVoAIhxwimm+EGGmbzibHGYKpX?=
 =?us-ascii?Q?7r/AmhU/H7ZrH1nBq95szow5m+S+gXQp3wU+0tCx+Z2V3ijGWy4S7opGx2y+?=
 =?us-ascii?Q?+seIXKGpQceKCjAP7KJ8mrgw06+rMKDeqek5R6GRJKlGApzVRsRr7/G4ia8R?=
 =?us-ascii?Q?JRYTOKMInqkplUh3HRfUuJHPq+5YCO1LfFH7ip+av26uiwPmnapvyMBTiOfR?=
 =?us-ascii?Q?2USElwuoJdrW/BEnx+Kb/Wa6T+GjG51wtQY13Memu2oeKfglk9EwGrhaidaC?=
 =?us-ascii?Q?oTbva4+3+QrNya9E39nHf4CaNW+AUHch7YvzfFJGMJ7CyexjSUpSGTMQMgOo?=
 =?us-ascii?Q?KJPcDrusq0X3hYk9+OMR3RUzm5EAYCXbYTRRWzGKQRzXz4kE4WPV6nUAM12h?=
 =?us-ascii?Q?XFFLU89PpJm8+aH9/ylrD5q1Z+I1U2ilY48uP3isKxVJiTqEXvBM3EBLsVzl?=
 =?us-ascii?Q?MYNH+IukBJBGL2+C0KKoqAePUaw0Z5mjHy5BKFh2ew2a67e7iAQSY6k53+5l?=
 =?us-ascii?Q?dAoU026ggs+i9/J2vUbpRkNZ47nUG5uj1SDoxy9ADORBUg0d2HAi5IHUywhW?=
 =?us-ascii?Q?iw0Lpa4eQapuzO/7IjF9UUI7ml08D2+cYO81fERdVvWAp4O9DQuaf+O/dh/K?=
 =?us-ascii?Q?ez+p6ozOyet847Z9uU/SfKRn3Yt6KnEpjCOyDr42YWCijWN6P+JnZqCkqaMa?=
 =?us-ascii?Q?AGQ/D6xrIFzzBouyMZC3xym8wdcUnBZgtAaDor8ES7t3DreRi1UAjBgAY422?=
 =?us-ascii?Q?r7QnnBCjoymgQcIPa/H+Eo5fUM4WWkJWaM/OPtk3IXfspsnJUeQ4rea5CCIa?=
 =?us-ascii?Q?HZ00/gVZW/xlRbaeBDC0o5YP7h+1VTKoz4p/orInp8ZDQKe1haVAK/bBkpbf?=
 =?us-ascii?Q?1wgGS0VO6qy8Ncn1WiT6MFahIfB90O92SgE1uSg2b7AzhH8E19WnozAAxG78?=
 =?us-ascii?Q?ozL0CmruoUxj7pmpP+M8Vcc+BgazteRtCFsVB/gMu7yVTehzRDVM6ehIIqQJ?=
 =?us-ascii?Q?+5axcl/l1TKYM71oygXUqRkNWVg4v2yi1W70snmV6Thd4OupiF23w3uGKsh7?=
 =?us-ascii?Q?6USaNjN11ItRXc4OU4I41grmxV8s3zMvCrvqrh1+F/3heeebL78QDbOdrkhR?=
 =?us-ascii?Q?y8HTPKJdHyDYBZnnyJaV6K2vODC/difIDFAxrx0HkAahi9f/0PHrhsrn6tco?=
 =?us-ascii?Q?Y9nx7Yy1xFdC4b6Rxwk5T0p9h5t9jIEjOTYohSZT6gjLuV586hfcpppKn9xF?=
 =?us-ascii?Q?tGf1Mcbx9cTQwt2X2VOZ0Vdn5K0eU7qTU+k1w7uVCjzQ2u2O2kMyVO8EZgLS?=
 =?us-ascii?Q?MpEnPmXFkMauThSW0V2YpinZpmzI87FeoTpgwGb52JiDAxkiNLMr/dcow42V?=
 =?us-ascii?Q?hlZHpmhAHMOsvRam9soEAEiSX0bFYrlemreUYnX8K9On3xqbBhpqsAWWmcRf?=
 =?us-ascii?Q?wB6MiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05c6616-0fbb-4ae4-8de9-08db176ee193
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:28:40.2848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2q3S6O2eZ44sC2lXk/BPjXahoXW0ylwiuxut0XihEaa5lVTXFB0WVimiPoMWeMZdt0iS2dVG//pRX6+9v7gbMwmHpRJlA5ka4mMjS0tAjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5373
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 07:11:44PM +0000, Russell King (Oracle) wrote:
> On Sat, Feb 25, 2023 at 05:49:18PM +0100, Simon Horman wrote:
> > On Fri, Feb 24, 2023 at 12:36:26PM +0000, Russell King (Oracle) wrote:
> > 
> > Hi Russell,
> > 
> > I think it would be good to add a patch description here.
> > 
> > Code change looks good to me.
> 
> As noted in the cover message, this is to highlight the issue to
> hopefully get folk to think what we should do about RMII and REVMII
> in this driver - basically, should we continue to support them, or
> remove it completely.
> 
> Either way, this patch won't hit net-next in its current form.
> 
> Essentially, the choice is either we remove these two switch cases,
> or we add these interface modes to the supported_interfaces array.
> 
> I'd rather those with mtk_eth_soc made the decision, even though it
> is highly unlikely that these modes are used on the hardware they
> have - as I don't have any mediatek hardware.
> 
> Thanks.

Thanks, understood.
Sorry for missing this earlier.
