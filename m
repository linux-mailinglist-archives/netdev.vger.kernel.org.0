Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B17D68F017
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjBHNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjBHNpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:45:09 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2120.outbound.protection.outlook.com [40.107.237.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA0930282;
        Wed,  8 Feb 2023 05:45:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDzWst9Y0lKfcCoT/jzd+13EosY1HT2m0ev4dXhleYPKuiHZvMJoPVtF4ea7vK0lrdMgIfOmf6e8TuofZ9Cy+xXNminij6wpHCf5SUqPlRsV8vr0tDQndeVjybgvH3BXVvaolRYnUVL66wt1Tvir7yuXvb3gX0u8tfxbmJVuJWYRIiKsiIhzNtqZr2x4h1WWwbg5By/DcXti2vKeeV5EYmsON/uuiQte3W2VpRZYRFPwKA+14JsZEa8zifI5bMf/C8CsHk/At710A8fXo8ZSLMWbj86LZNXqCHEP7sVO0f/sYVlflsGOhbZATXs98K0+lOAk86UBlKwVcuhCZNNIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJ8VsW5k0fXq/kPqrk4b2Cw97DUVFjfQPGMT2odxsPs=;
 b=EA5aXfGzT4jzYlWVRo9J3PyEtJxg36e2PjL+HskNXn2JokVcQ/y22ZC08Vjv3i13SG+5kwcwcfr8Df4HMRI2VVPwXtejkIk23OGbzlx0T+hcQniN+XkUaLv1g7Egn9Ghjt94UARnqZOYXRyV4p2XoeEBPeogD+cLh5q/y2CgDGcjr3npKctjIK1kcHqe169Va4fXNYpFZ/aKz8oDg2Z/193IB5ueEjhqqjnZBWyuSMubqJ1itW9md3CQR22akMpd6xlNQYnou1mxqT1kvg7K/GlrzFLYeIyJecU1FzWfH5/NAXjM1ndr+LGm7KeDoxNUqoAK9w5e09xsIcionARXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJ8VsW5k0fXq/kPqrk4b2Cw97DUVFjfQPGMT2odxsPs=;
 b=W0JOqurhJ6EJdG7cb4INXauErb49/lkhyfmFrUDVpbkB0y8/pJ0ikUnt42ykgIVP6igKsZTMHvudJsPz1akJ3WsRAScuiuBMWz7DL5FvXu1EvG1bZoJvqBZW5qtdug52u/ImxILpVXKUGuH0mtZqiBedrUjkqvmuPhZFA/jBokc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5315.namprd13.prod.outlook.com (2603:10b6:510:f9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 13:45:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 13:45:01 +0000
Date:   Wed, 8 Feb 2023 14:44:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, roopa@nvidia.com,
        pabeni@redhat.com, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] net: bridge: clean up one inconsistent indenting
Message-ID: <Y+OnVfu/3ot3Rk7f@corigine.com>
References: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
 <Y+OdyiQpz7lIBfh3@corigine.com>
 <1a71f6f8-09f6-9208-7368-6b2e3bb4af87@blackwall.org>
 <4e9705d5-c6f7-0b08-6e45-b19bae1d248d@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e9705d5-c6f7-0b08-6e45-b19bae1d248d@blackwall.org>
X-ClientProxiedBy: AM0PR02CA0101.eurprd02.prod.outlook.com
 (2603:10a6:208:154::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: de81a952-84ed-491d-706f-08db09daacb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mV3tPfQCj3dxP9Nx463jbRg+KpA1BsI1dVq5qNI0WDttqnRcP9Qo7mY3FM5rPekNnIzAKewOqizcLN3DKsMkYnwfvQLs3mV68PIQbxXzugm61q7ptNIijooQyCdLMmI6ZaOt37QHOb8YLoLB1/zC4hPmAFNKdKCNlxjxIcY/XoXk45zZLdOSJGxbsC0jfVoiFYc+sdSb0RErCkxIBLhLz4zQVeLTIEhDSfPQFsZq3wF1ldJx8DQfIRhiY430zEJm84eJJF7MbkEFwcrurOcojfb3QzGXNg+iGx+CDk1+KILcMKd1pmcgN1Yb9r/vRVu+twUbJlhWlWxRGY0T2z3TDRmuyiJAV4C0ZEr0rL7RIExNlSCb5XEodp+mcutwzzqXwVk/GWokCCffjd9S5aKBgHtRyRIdelQt1V1xwTyrxPmprAOnJ+P/QQZtQPdsWB5f+Qt3r0xhgvkPZyTh8zOg9AIw2NNg1ERhUUzgEFA9TB0YuId1KwSkRqMhTOrirdbTHedy6Q49NUJ9zY4nLMq3nfApif9egqyEMuLjIHq6sfquHOzBp5tGEz5zZeYhsYhx48HJIBdXywTy+CXzzkXX3+h+BJuYb0jHqwGuDxzM6sMj/JxlhBeeZcMIrOC4KD6DtiQ5P5DaBQgUqvEkTuPLP3+X6T1z4i6MFkg3O8b6Dns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(39840400004)(346002)(451199018)(44832011)(6512007)(186003)(6506007)(53546011)(2906002)(6666004)(36756003)(966005)(7416002)(5660300002)(478600001)(6486002)(41300700001)(8936002)(2616005)(8676002)(66946007)(4326008)(66476007)(6916009)(83380400001)(66556008)(86362001)(54906003)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXBTeHYyRlBQZXlsU0hYT2Z4SG9MS0w0T2h1enJOQmYyRllRWkJYUlVXSEdj?=
 =?utf-8?B?WWJzbGxMVzJqOTA3NEdTdm1la3RtQzJGY0RHVWxSaGs1VFFzQm1hR3hUYUto?=
 =?utf-8?B?NlhyREtGcmFlaEtpMWcxMHhHR3pxODNUV3ljZUNqNERsc1FaV0ZyTDNKUy9U?=
 =?utf-8?B?VDQ2M005Y05CN21aM21HWGI3bElTMzRuT2lkandVaHZHc2Z3WTI5RVc3L1J0?=
 =?utf-8?B?RksvNXVkRGFEUS84VWhUSitwS3lVYUFpR3dwcWtzSGt4alB2aktBOERkN0c0?=
 =?utf-8?B?UzZVLzZ4K2JaTFJ0ZzFKVHNBSmw3ZXdFZzQ4ZGkyRk9nM1F1Q2Z5RFF4RXdJ?=
 =?utf-8?B?OGJBbWhXTkZKbmsrSmxOdytEOXFZT09JOEhiaTFQU1FKQUFJTStRbjFQUkd5?=
 =?utf-8?B?SFZTd0YrM1prTjRRQzlUWFo3L1ZpdUtheEdsYzluSzhPVW4yMWNCelVRTEth?=
 =?utf-8?B?eG0reW4wd3BBN3ZJTzJIbUxJMGU4UzRaVkE2cDRjcEp5N2lNZStLZWJGWnNZ?=
 =?utf-8?B?dVgxeUhUamVEbU90MHlmVUpNaE1TS2VCcFRiZ0owUkF6eEgra3JKemhSc1pr?=
 =?utf-8?B?QTJtdlpKTEsyMFdxRHNSSUNkL0loMVlKakpNUm1aVkZFNWhTT3V3ckIzRlNY?=
 =?utf-8?B?NjdhRmVuVndIa0cveTdYcnN5WnRXdkZrUFhQUG9HaDh1YVFSMHpBdkZSdlRk?=
 =?utf-8?B?ZytsdkRuSEkxNTdnYlJCZGFxd0h1YzRqQUZqMVFVQWJBbHRvakNRZVdzc0Vm?=
 =?utf-8?B?ZGwrNmtOUzI1aW50ZjVpSW9tdjdkSGhyV3gvMnFSV3pDZ1VWTU82OGFsV2h6?=
 =?utf-8?B?NGxicWo2VXgweVlqbW03azA0YUc3dzlzNGh2NWpGQTBEZUZ0WVV0d0VSZjdt?=
 =?utf-8?B?VFpZSE5vM1dKU2NSMG5pV2xXU2dYZjdQTk1aM0t1YjhxdGtEMjdobTBocTNz?=
 =?utf-8?B?TGtYNHJxVm9yK2x1THJYUjV5dFhrS3JLcWxOSXlzN0FzSFAvVHJnckNxaFlo?=
 =?utf-8?B?SldFb1FhTjJJN3hjVVBPV253WEdpV3c4Z1lMNkdCSDQzOWJZbHJJM3ZqbmQr?=
 =?utf-8?B?M0RzakxXdCtjK1BCZkVUZHlvamNlTzhzOERXNXh4cHB4MjNXRWhmOUFTUlph?=
 =?utf-8?B?U2ZpWlo0NHJaQXRXZzkzRjc2bEk2MlArcUwxZWlhQitjT3RUU2VlMEI0UGRG?=
 =?utf-8?B?MmNYdS8xUlBoU1BERk0vK3hYNkZNMFNudEZ2M0dqclhuRnhVQ2wwRVprTUtD?=
 =?utf-8?B?SHFWS0pZTVM4U1ZaU0FWMFJ3WTFKSEZMNmY0eEp3QjhQR25oVGVjTjNjdEhJ?=
 =?utf-8?B?K2hpclY1c0ZiTjdTLzdreWRNU2J4NStFZVowQ01wcWQyVUVGbkNDQlR5Z2ll?=
 =?utf-8?B?QjgxTmZGc0NZS2hmY0N6dEowdmdwaHRDT2d3SzNxZ1BjY3FkNjJPdGdLRXlS?=
 =?utf-8?B?Qit6ZFR3VEg0bDFiMXJUd29qZUJXNloxKzZLbDl2ZFc1N3hodXEwMFlRemN1?=
 =?utf-8?B?WFk0ZUsydWwyRk0wRlpWbDE5c2o4K0ljSCtkdXIvZ0cveCttaW5KdlQ0bEtR?=
 =?utf-8?B?L2h1WTIybjBycUJxdi9SNjRGOVl2aGhyYk1TOUtZMW9QR0p1bHBQMWhuZm1J?=
 =?utf-8?B?OExoU0xRQk9ldkdtVGJ6NXlmMXpCbFB1cW5EOTJtMml1a1NJcFpmOEplTlAw?=
 =?utf-8?B?UjlOZFcwYTQ0Rk80N01NSUFZWTFOMkEweHcvNXZDTFk4U0JDRVU3eEF3ejY3?=
 =?utf-8?B?TVY0aytOM01pWGtyTEE3R0JEaGRONTZhaFJtTUxYdUwrTEFjbTk1bGt2dEtW?=
 =?utf-8?B?NTlmWG1rNE9XdWFrQ1d6TkQzNC9COWtMdTc0M1dWc3B6clNuYTlWRnVDM3dp?=
 =?utf-8?B?eDlNR1dqTXQwbFU0cEdURFQ5NG1RWDQ0NVpLZTQzWkhweU9HVFFxaWJpSmVp?=
 =?utf-8?B?bzRqeEFSY0wvMmxiWTFKcFVCb0t3QlE5MXFGMlVpYUFGSkN1dFBWVjZaZVRC?=
 =?utf-8?B?eXZwZmdzeExNUlZuQ21YSllwallIRXhTcDB2N1RqTVRFWGt5Uk03V3BocXpo?=
 =?utf-8?B?Q3FaNjFPQVBmZm94ZDlDVjBhRWtnd2RvZHRkb21VMDdxY0Q0R2VoTlJFZlBl?=
 =?utf-8?B?R29yYkZiOFYzSXZGSzlKVlI4Q01Cb05GZHRuK1hIdHhQMnlMTTBYaGlxTnpi?=
 =?utf-8?B?Vm43QXpFazlkQW9DbmhTcmp6eFgzL1B1VG9EUmQvdDJERDRuakdjT2ZLbnJ2?=
 =?utf-8?B?amdRSVNXU1JFMzNzb21rcEVySUdBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de81a952-84ed-491d-706f-08db09daacb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 13:45:00.9973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9JptbAYsd4nLTUjH0T2Ntr8ftvRELG6MXYdthb+LZ7jULwlSSOI5pCYTiD/dL0c2vzHughYLKA3WPBOGEXG8cwxMNZBQ7hgmeKeq8VRcWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5315
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:31:39PM +0100, Nikolay Aleksandrov wrote:
> On 2/8/23 15:30, Nikolay Aleksandrov wrote:
> > On 2/8/23 15:04, Simon Horman wrote:
> > > On Wed, Feb 08, 2023 at 08:56:26AM +0800, Yang Li wrote:
> > > > ./net/bridge/br_netlink_tunnel.c:317:4-27: code aligned with
> > > > following code on line 318
> > > > 
> > > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > > Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3977
> > > > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > > 
> > > As you may need to respin this:
> > > 
> > > Assuming this is targeting net-next, which seems likely to me,
> > > the subject should denote that. Something like this:
> > > 
> > > [PATCH net-next] net: bridge: clean up one inconsistent indenting
> > > 
> > > > ---
> > > >   net/bridge/br_netlink_tunnel.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/bridge/br_netlink_tunnel.c
> > > > b/net/bridge/br_netlink_tunnel.c
> > > > index 17abf092f7ca..eff949bfdd83 100644
> > > > --- a/net/bridge/br_netlink_tunnel.c
> > > > +++ b/net/bridge/br_netlink_tunnel.c
> > > > @@ -315,7 +315,7 @@ int br_process_vlan_tunnel_info(const struct
> > > > net_bridge *br,
> > > >               if (curr_change)
> > > >                   *changed = curr_change;
> > > > -             __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
> > > > +            __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
> > > >                               curr_change);
> > > 
> > > I think you also need to adjust the line immediately above.
> > 
> > You meant below, right? :) i.e. "curr_change)", that seems to get
> > misaligned after the change and needs to be adjusted as well.
> > 
> 
> Oh I need coffee, I somehow was thinking about the line being changed
> instead of literally the line above your statement. :))

No problem. We are talking about the same line :)

> Anyway, ack.
