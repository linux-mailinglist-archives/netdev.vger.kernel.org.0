Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5F76BB905
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjCOQFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjCOQFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:05:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2133.outbound.protection.outlook.com [40.107.244.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1DE96C3B;
        Wed, 15 Mar 2023 09:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQ6glIX23Lmxh+fMDwB1PWBtjmk0esxK8Ds0E6ttcGzKSsn1MA4kqNKEaK3mV6/EKhNES3rgTg9PzY3Qnr0JJaXd1Kh+xq0Wx5ehuJCmZ8NGSK5FImLUk5JuuNttqd2LRYKWxOSm9gcQ8u7zLEy1EyXFwAB0+IJqV72islZR4wph+jEQ1BzaZBMp1ZYPyAgyc/P+Cdzt35JLL8bGffqeeWCupFBFtq7VT2TK+oZGY66RAu6RoKv+IbdF2aqR77sVKy8QuPP3xXZ0U/OZzN0F3m/Iv9uIM4fFxyvTpqBv6WI3R/DHVohE7k1QK+of4MF2nzftSFlmIztwBfZTL2sUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlRYDZoTrTaY5TwBzR2l3REwdJbYsdKSDndtO6O8Lp0=;
 b=FOlxinIjD6F66ZMkfjGp6ej9ILIMfSg9rVUKvawNAU0+Q0yY0Fm3j+RTS+4Wxbp/5FX8F4DCiTLzW8bmsYcqxyAfjtQwSE9i6dgpiAtXzMAyuDPEJ0y5CPVYYB4DI9j7gk1eF0qAvDcV2I3Et2T0DoGMMKihOlK3MLuy5GL3ZWnsCXQM85ghH5Cq0hgRzjAyaQzJAYEhcju7jU+jx6QnoMHs0mKEe/j53RLz2pCf31MKMULkU2A9Q8PESD11xrnuZtNo+K0ocRtUNE0u0BOlxX71k8/AoP6PPP1/8zhYBTPopjw4lA9uibpFjSjmnivZ48YPUn3FaRvm3CBaFt/bBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlRYDZoTrTaY5TwBzR2l3REwdJbYsdKSDndtO6O8Lp0=;
 b=XqMY0j4pk+C3Bikz0EeMCNjGoP56KFJvSOzLnjoPQlqzcxcshpq4MdN29lwmljXReNQCiM2bSKTR15T+41pTULcpQ3kVsiyeZ1bW3/U9O+PwUVcOjQFbkeHhtSLYH8gAsa22AixuNSU3sQSFD+HGzEP0CXs+vmj7C30Cg3WaLZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4573.namprd13.prod.outlook.com (2603:10b6:5:3a5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 16:03:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 16:03:12 +0000
Date:   Wed, 15 Mar 2023 17:03:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and
 tcan4553 variants
Message-ID: <ZBHsOnKWS+656eWr@corigine.com>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
 <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
 <20230315112508.6q52rekhmk66uiwj@pengutronix.de>
 <54aae3b8-ee85-c7eb-ecda-f574cb140675@linaro.org>
 <20230315155833.qsb5t367on5hl5li@blmsp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315155833.qsb5t367on5hl5li@blmsp>
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 9825650c-874c-4adf-d769-08db256ec74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMrWqfofAOk3PYMYnbY55g5JVuNHWJ++KlLKGHMF2DSoxUDLtjmD4TRmVTh/mdGpNmMH4GK8OKfJrUmLUq68uzeEyN+j5LioHMgc4/22faHKkCd2pdPXG6EpL0zJH69bGDjxM0IgJfWNHOA2VHAGbFxohtJTgyPwQEU+S+D48vDMjtwb7Aw3/mRBGtdqbxCXtUmEoDa5Jm7ttBdw+ZchA9e99rrNjNQeuKcStUwHzsQMDmXzoaeqMyWWRcPhQ/DKoW4i4kZLmyyH1HNqkdQzPg15Ba0w2hGkxISvZ9S2FUBtPvxB+oWtLl2gHrJ1+axGlWpRXDRKWclVWoMqTy1stMCjFJC5vMpjH8nBCvGp/BO6wZdKes3H/BMWnOK2shVagoRdrd2ad4nqGc78lw7CvtehZkKJZykoYdWQ5aDPv8vz9v0VIcy26hrkG+y67HzdHj+XlbcSzKa104N9GRwsEv4T3FrRWd+zyUGAwc2+v0qmJVBbZc3vggJhbn0UR9hlTdjunwyN4n+VLnXjYwY8Sl0wodAbus3OZq6DsGLepc9o4lZDlNQV+rVdPzkSe8zwcnhMtZt1V8h38oH676N/ptLfBqb8mnDhusXnVoMoLc3qex9IEGlMJs3TzTdiUr73ReU7C5L1Fo0nBeQsMgJpUd5P9zqVnnPoUKOYjKAmZ0oNK4N5C2zLVOiczjFDjF3YvL7mXPrfbHJIZrDRFt1YasIUHA9YVe4b2QiZQfBgyhitbgnT0FFJ19qT4krZsf2o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199018)(36756003)(6512007)(316002)(54906003)(478600001)(6486002)(7416002)(5660300002)(66946007)(44832011)(8936002)(66476007)(8676002)(4326008)(66556008)(6916009)(41300700001)(2906002)(83380400001)(38100700002)(86362001)(6506007)(186003)(2616005)(53546011)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fNkuM3KS1df7HTXckeZYrFXxB7JgYT5a8POcvz4MljspMZJrDL6UZO35a/Ln?=
 =?us-ascii?Q?c5PJllPznFPqRcXIfGcpvf2r18pg8qb8eNUzoTO459eDQq/0RJ4BqVLvee1m?=
 =?us-ascii?Q?+rU69M5ZddNI90oZqGAyAzzBDzdEkWOqEVZZ0V5tHzn3+eSDTr8IdAGxZPdW?=
 =?us-ascii?Q?Fvc0+xbdFm6YfSyIGrQ3FChFgOar4I+pDnPghzaOpbPIQHii+uHuPblG1Wpw?=
 =?us-ascii?Q?0CXqXjDpiZnxxP3Es7gDw9UFizlG+KSr5j7nKgm0R7gw61nIsoeB4YofW7ts?=
 =?us-ascii?Q?Mlti1P2ACTqxF/9h7kA6vyuldXy/FFvsspnmbwm6nEbbxSzVSILlYEyH408U?=
 =?us-ascii?Q?dV5ctFXQMkQSRXEXdQxWmJDdv2TOute63EfiIeEciYNA2meLxqMHpLwItHUl?=
 =?us-ascii?Q?tolG1AKwVdTsjCkqcnWUWR2xAaffnlqUm/nR94MBRuoy73ghAaezuo2yn9Wt?=
 =?us-ascii?Q?/nn/2T4UC0eagrMeihlcvHtdZ1nyAjw9Uez/JGqg4PkrOCtFs0BA/KK8dF0i?=
 =?us-ascii?Q?YlELJMzecUE9kA5JvtaAlEk5Ock3A1gKLp2c4xq/l3T0NYqo6qIB3Or5K/HE?=
 =?us-ascii?Q?H45JLKARQHGnWvLdDd1pxEmcy/ed+lXjDjnPPpApAu9YDAvnCqOGt2J18Xwc?=
 =?us-ascii?Q?wPLqm+owt1pjG/Fo2Ock0kpRRvntLn49ISTeQYY9tt4Fl0LC2H2Bvf0WjQfc?=
 =?us-ascii?Q?hutJKFe/pyukkvJrqsHmtqfxcrdOan4M7QBY6+XxUSyvynFAvu8Hpqg7wyZv?=
 =?us-ascii?Q?DK5FXNQGEuYXFIuRFA+cqnyu14ZHC4W+tvv89k3g3ugzVP1PoGBxxXWUZZMF?=
 =?us-ascii?Q?ZkSQ3YdASnlb+N2BPVDTwbZbyeQfft4LsQZvme1GTUT9bMX8bDxtWD5h0n1T?=
 =?us-ascii?Q?JeK28Tsb3aKLn9XMFBQfZrucK7cnaFHLg1yG8QBWkoNyAIEGRqSsvz68qSAg?=
 =?us-ascii?Q?T2BAYh5cC9gTxB+a/i3ZZ0tuQMo9lmrm3gsT21aPZXUakTClpIgAI4bBh7BP?=
 =?us-ascii?Q?d7f09lTIQ0bjhArVho1I9q2dPW1u00t0vg/RRHWk9nPTv1mp9D1TfuSQrLtR?=
 =?us-ascii?Q?awAC2eUOEPspWXTfJ011wqEIgvwmkMX9fzCuY84GAPwry9kOvBzHhVwdHaJS?=
 =?us-ascii?Q?LPnN8oR1oFDCyUmN9ZIGcr4owHaWdt6bOA29XVya63L0A34p/2advzWi3Vsp?=
 =?us-ascii?Q?isucGhlQOPChRjiaoVChnHL8d3WA9nuncRrgVWHBBPscNe9wTjmpipF7BIrj?=
 =?us-ascii?Q?uRmi4noX6pRrSA+mYmCFzOiGW77J4v3frs0mj3ODZnrRppqDSr/XlWoOMUD5?=
 =?us-ascii?Q?4/ycS3t/c5Cfq4AHSsHTADaNAhjgyAGraIZFsshqolt23thpYpJxvWJIOiGA?=
 =?us-ascii?Q?SlJVR4H2f66ESJVvNO8G7LQqBtE6iwlq2sgik7clczgWPSn0W405xAMxMEhr?=
 =?us-ascii?Q?7lJ42EpeV5JLJLy/rsIxz69HzuoT+/EbTJ5pgEwUoj4KXMCe1gLQpxle37Vf?=
 =?us-ascii?Q?6wzIQdkVBSsfigifBo2Cse9kW0SKsdWCT6P+caasNPRDhpozUqQvwroRGXMZ?=
 =?us-ascii?Q?DyjTtURxsvDS3kjytSw0KMq4gkvQJ6KTbOfg7ebbApD/0t/8+jN2iLL0BaOM?=
 =?us-ascii?Q?PMcgwwU5Q3QJU+4cDobyr4Z6d32whUGiLtTn02FivJv1t8LIk/QpDcZWwTE0?=
 =?us-ascii?Q?ZY3d4w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9825650c-874c-4adf-d769-08db256ec74f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:03:12.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/zYHPKNqLvDCbK6IwGnGpH1vEnP2411MHwYn9KHUkKs6Tx+S1excOu3tuCfDboYYQgAXXIPnHVtAXdtHiOH4EIgZNWlXKZWUvzPcMu66qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4573
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 04:58:33PM +0100, Markus Schneider-Pargmann wrote:
> On Wed, Mar 15, 2023 at 02:14:27PM +0100, Krzysztof Kozlowski wrote:
> > On 15/03/2023 12:25, Marc Kleine-Budde wrote:
> > > On 14.03.2023 21:01:10, Krzysztof Kozlowski wrote:
> > >> On 14/03/2023 16:11, Markus Schneider-Pargmann wrote:
> > >>> These two new chips do not have state or wake pins.
> > >>>
> > >>> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > >>> ---
> > >>>  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
> > >>>  1 file changed, 8 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > >>> index e3501bfa22e9..38a2b5369b44 100644
> > >>> --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > >>> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > >>> @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
> > >>>  This file provides device node information for the TCAN4x5x interface contains.
> > >>>  
> > >>>  Required properties:
> > >>> -	- compatible: "ti,tcan4x5x"
> > >>> +	- compatible:
> > >>> +		"ti,tcan4x5x" or
> > >>> +		"ti,tcan4552" or
> > >>> +		"ti,tcan4553"
> > >>
> > >> Awesome, they nicely fit into wildcard... Would be useful to deprecate
> > >> the wildcard at some point and switch to proper compatibles in such
> > >> case, because now they became confusing.
> > > 
> > > I plead for DT stability!
> > > 
> > > As I understand correctly, the exact version of the chip (4550, 4552, or
> > > 4553) can be detected via the ID2 register.
> > 
> > So maybe there is no need for this patch at all? Or the new compatibles
> > should be made compatible with generic fallback?
> 
> I can use the value being read from the ID2 register to get the version.
> This at least holds the correct value for tcan4550, 4552 and 4553. But
> the state and wake gpios can't be used in case of a 4552 or 4553.
> 
> So yes, it is possible to do it without the new compatibles but the
> changes for state and wake gpios need to stay.
> 
> What do you two prefer?

FWIIW, I think it is good to have the extra compat strings,
even if the driver only uses the fallback string for now.
This would allow the driver to take into account HW differences that come
to light later, without needing to update the bindings.
