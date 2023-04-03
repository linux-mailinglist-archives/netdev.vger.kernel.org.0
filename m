Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC4C6D4CC3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjDCPz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjDCPzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:55:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2132.outbound.protection.outlook.com [40.107.94.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875ED2D79;
        Mon,  3 Apr 2023 08:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9VL5GgIu1SYjpsQ3CIn1NoBH1HVHpgAfmg9zP/P2L6dOSEcGWA4UxPzltyxgayibzL6RnMzifKSn7HiJ+SttyJPPf1X7X0ySIWq4BdPAaMGG1qpx7KhMoviTXn1Z/lVYbomzSYqy5v5Q/F1oDM8pVdQw6G7vqpgOSOYuXCDT6Z4KHstumNXIws5LGtru8IlR6nUg7W2Rh+yp1y5GxunMHuVPzV+/GOn6TTYqJaNczzSAa0ysN8964yMFQLbR9oUNuoLo8fETlxT13ChK2tGDn3lkgRIY21eHpdoIwPYouDiJq46zkyIziWSmn6DfLWw2G6xe9y1cwKnOxNqSG2TCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72Xm7KIKKqXTyXOiW0BSsCqFMPBt77Ip6hJ6hR0Gyy4=;
 b=I/XYBqlRT6jDwg6PgIhRXfT8vjAQ3IO1ickUz6TB46TZxhoNYugXv0vWn43MP7y365P17K/CfA8Um/EM+bRdP+qhCnMx+5p8OGi/vE1ZZ9CxrUIf8G14AjkBFACETGK2Rr9bYAnqeIcp/5tdvz+0Y407ixgGg9tcOrWuVR+BnMeEdKVLqzdfhy7FSvcXbWm1d24CopL5mzMTTN5DhsE9I3H2frLEObByyG1m31azq+EzCX+DitkXLEO1xewA6KXDQpYzsynhZBV9Wdxikvuitgu0YZLheO9s3XUldBeoWEh3OeBXl7LJPDR6nXt6OiWGnUcVJiQz++8RYqSDcDOrIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72Xm7KIKKqXTyXOiW0BSsCqFMPBt77Ip6hJ6hR0Gyy4=;
 b=sVFwtQ7vXNNmyqHp3t5M2g/+Pk1EeHfrpu3EhOf81ZotlR4chlrNSUPgP8Xuj6S/oZdJXx33yPIpxHOuBbtofzK8YUuLLRjwnsG/+SgSSMc1sgDdh1vawNNeCM2eSw1HsNDLMRMvRIDsSsNMpqACgOykawEmh4nxnczywlhBQeY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4069.namprd13.prod.outlook.com (2603:10b6:208:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:54:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:54:56 +0000
Date:   Mon, 3 Apr 2023 17:54:49 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 11/11] net: stmmac: dwmac-tegra: Convert to
 platform remove callback returning void
Message-ID: <ZCr2yVHc1ZCYxVSV@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-12-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-12-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4069:EE_
X-MS-Office365-Filtering-Correlation-Id: c6efff30-86e4-4ea1-4dd3-08db345bc570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jOOQ5piMQJGcKL7zEyR8GutnTDb4DpzV2ANEEvfJBLOwapK6UiTDZCCYV4jwiiHjYZkwzux8USxcuC+oWfyxDso4yQwmaX062F5PXyVvEr5CTH+uWzNCNMk3vVBYr97QP85G4r8AQyxD2j8gmSfDhe9WCnUYT5ooG3ElYqRkqabf38bN610e04StHa6SfWyrd/GeYAPcI95AyoI8q2OUt4pswiMj33k9sR6kNzq/dDD05Z2GFZxrnR7sHZg3qxsXX8p/LwBkkvBQJUJWSPknFhQDHGgpzx+Kyh/lDCqGu2dW2bFbOdsLzVwFvLFrNGu1tNuSRiZrO/PTxSeWwN/y4SqCrbsBefdEGEFTiANKVlLxHOpxy3EZCfXf5XuHiZlTk0p02f2g6z1gGcf/XzkJq/nHkkYNygT9lSdZWJADsSh9/6JZspgkJ8p6fx95j+GO5lNxhRd4cvhsflb7iUHyH+8HeKvH+tYVxMw3lmHORazjxtVn+rfEQ+pWfDVNusivPJ1AppYwjfufJ2QzRJMPz+I4kDwrbs6TL0RCLGqegS8z/wEgEgSfFRHgj86f8V+h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39840400004)(376002)(136003)(366004)(451199021)(38100700002)(5660300002)(7416002)(4744005)(44832011)(2616005)(54906003)(316002)(6486002)(478600001)(186003)(86362001)(6666004)(6512007)(6506007)(41300700001)(36756003)(4326008)(6916009)(8676002)(66946007)(66556008)(66476007)(8936002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3pldGNkbEprZmtSeHE1YjM1dWx2UjZ1R1FUbGFFRHBCcG5XUklUeFZTaktu?=
 =?utf-8?B?TURZV0gxS3F1MWFTbm9LbWJBb29WUWJEUkF4SkZoZyt6VkVmRVlHSUxLUzRU?=
 =?utf-8?B?VzRqcFFQZE1YRm9HVGxEVWhMMytwTmtLN0EwTDN2bGMwZlQwZ2d5QytwZEgz?=
 =?utf-8?B?cVphSmxwaWk0UlhaSEZVeE0yaVk3L0hXVURWdnZLZ3MzYmxONkp2T0dmS3VU?=
 =?utf-8?B?VG5qMklpekFuMG9pb3loUHNwY1ljcXo5QUVkVXd4OUNHOVd2OUNaU29sYjAz?=
 =?utf-8?B?WlU2eWQrM25lSWRpMGlxaS8vU2lQWGRpOWc2anh4U0FDbWJtQkpyT3pWdEIr?=
 =?utf-8?B?elJIWStvdEZTdXRBS1JoM1pCVGMwMlJ1Tjc2TExyb1RvOVZ0S3VyTC80Mkth?=
 =?utf-8?B?bkx5OWV1VCsxZkhJT1J6R2F3V0RWcVRUME1WQlE0L05XT3I0YnA2U083c0c5?=
 =?utf-8?B?VEZPSk1NZ1JWOTZJWnJUUzNwOXlZb1hZZVh5Nk1Ia05tODlOWngyYVdjWmI3?=
 =?utf-8?B?Qk95TkdGOXg1MlNkSzVGVUFWWW53K0Z0UjBwNWJPYVdJWGszRjZMZmY2YWF1?=
 =?utf-8?B?QmtmOWZuQVRnK01jTmRYb2w4aGFDSyt0a3FGZ1BtdWVCS2FhcmlsZGNjNStB?=
 =?utf-8?B?Q3cwUWdzUERvZHp3MXRLSzgvOEZEOE91WHkwWUd6QnFqRW1WUXNJNGJCQ0JM?=
 =?utf-8?B?c2ZSdWlXWXFGMml1dTFCUlhhOEFtY1BJaCtxS2pNREhuV2lGKzNxNDZHcVRC?=
 =?utf-8?B?Si9BQ3kxYTdqVUozV0VyV0QwOUtBSDhSTXlESXN6K2RIeG9QUW93ekZSTm96?=
 =?utf-8?B?UG1pN1ZmNWJDdU5WK1ZDTzdjL3RRdkROZjdJY3g2dVdESmo2UTk4T0hUa24z?=
 =?utf-8?B?NlpEdjFGbTlMRlIzRXE1dFFjQmZtSU5yeUdXenNYb1ErTTNCbEl4VVpsT01G?=
 =?utf-8?B?RHRuT3FoWlVtVXFPTjdYUTE4RGtTbTZia3laNllpbTFlUC9vMkNjOGRtV3Y2?=
 =?utf-8?B?VWRaWDNTQklrTnhhMmJaWHYrSlNUNno1STMvQnMxOEd1VEJLU043end4L0FT?=
 =?utf-8?B?Q3BWSDF4Q3FIaDF1THBpV2dKczU2bFQyYnZ5blJCMFNlcDVEckl2S254aVJ0?=
 =?utf-8?B?akVudktycFF5aVdXMTVNVW9xRjJrd2hvODhXem9IVnVVUzlMa08vbkJFU0sx?=
 =?utf-8?B?bUJwLzduc1ozYjhzMzZLWHhQRWQ5UFN0NUVsZFVseDlqN2RsUHoxYTFnbUFE?=
 =?utf-8?B?ZzFpKzcyZ3A4M1VjK0YwdXNjRm02NjM2YTJaSzFkMDFVVnFCR3M1ekkzVkxD?=
 =?utf-8?B?Zm5BOWxJS1ZRN29oNmZ6aXdQTk5KUHUzTEkwVGl5UDhQTkNCaGxRSlZBQ0ls?=
 =?utf-8?B?UmQrUm1lTDZvMFBURmM1TzNsbm94RlVCdDVGWjR4N2N0WlAvaEppdThYcis5?=
 =?utf-8?B?N2JlWTVsNXRYY3M2dG83Ym5jdzRJa28vSVk1VVVsR1FMcmlmRGZRODh6VzI4?=
 =?utf-8?B?dklIY1IwMjBnNHQxRWZvUUFWamhSR1dEUFhDY0dYSURjV083SGt6VXRFa0ZK?=
 =?utf-8?B?Mm1nNkJXWG1jQm4rQUNXZFYzcTA4S1d1WWIyTmVtVDNqM01vQnBxWkszY212?=
 =?utf-8?B?TWdIUjlHVXh4dXpPb1RaU3VpYWo0SzBwR05ZVUhoL2VXUW9HL1ZBNXFUOExt?=
 =?utf-8?B?eGdLN3c0b0hrdWoxbVJTZnFDRU04VmJKY2lIdXpmVW9KZHN1dWx2blA0Rkpo?=
 =?utf-8?B?MVFrbEdWNlc1eTllUDBrc1FScEFRSVFENHVURlJTTUhYUUJZbWllRUUzYyt3?=
 =?utf-8?B?OFNCeHgvbkdBMDd5RHhGMFpVWU1KMC9HSEhuSGpuWkdoOHJLRWRGeWRCcGJt?=
 =?utf-8?B?Zi9mUnA3WEg3U3JSY3h0L0U1ZC9IdTFrVG84Y3BBMFhyTmxTRTBRcDBtQ3Vs?=
 =?utf-8?B?anJOQzNFSVpPRXBueS9FNFVXQmFCcVNjOC90UEhEb3dURkl3SzdQc2ZBOUVH?=
 =?utf-8?B?NWNMM21UcUFWSzh0MGhkU1NtbVQxbjRuaGNJRkFNdk5RdklBQVQ0allyVFFT?=
 =?utf-8?B?NGxjN2Z6b01CdDl5TUN3TmY2WGREMG5Md3JWaERselZPejIza3pnWW9INUZP?=
 =?utf-8?B?ZnZCc0lCUHRodVJHMmlsdU1oL1Y2cnVaOGQvU0J4S2hRVW5IcmxzS3RLdmsr?=
 =?utf-8?B?ZkVkczRmREsveUo1QjdrOHlpNnMxL3RCOXdaclJub29jcUVWNDJRZ0pwdVMx?=
 =?utf-8?B?THh4bzdJYjUwWHB5ZEtHZlEzZGp3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6efff30-86e4-4ea1-4dd3-08db345bc570
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:54:56.4511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpgO9dm0TORTgBnwRvSuRstcymKA6z5BeCqsEAmpqxwIITWpBYn/22qlhX4If1Ldi634zfNNquBzth1PABQEh02uwaUPG89K1ukLZLz5I/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4069
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:25PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

