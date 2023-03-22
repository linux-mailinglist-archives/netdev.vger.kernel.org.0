Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E26C491B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCVLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCVLZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:25:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533586150C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJFycSypn0J2ezH/dApNQ/+RBDAowzSV+1Cnzf0c5UEOjMgpPATna7aDQ9edTvHTkW4YRV3pqp+5F5wAHj3q+xEboEYiXARLDFA1WwJ8UOKhiuT8g7csEZpuPgsNpCq07MQWQwchGOSLJkDNqo51d80isTuyDCFPuuS5wiG7FksQ08V4oke/TzC0HQ+FMj+U14rqkfZjlu+Xp+WUBYa5ulpF4DflfZh+Wa0gDxJ/ZKmsvvU7OQLMeSvDt2jJ5iU9uHOugwaZmA2602GKrITJluVKQTLjMCIGEyQUuQYjRq87MPmbg1sak52Ty+73ls+m3LeoF3tJ4DneyNsq9xofZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68vtFyCb1Hx+3g+zQO5wm5tLYb42RAPo0LbPsmGVogQ=;
 b=Q9eEwR6iD4ebQNhRvgOh0ilwUVdkFP5wmwq8f5i9aJJVMtfDt6h21W4p5hSY16/spMUMhzRv5kzcJPQK26DjKnkiMP3XoFZ2iC5UoXyTTOkeYXhelcOeKM0l7GAi/c3wC2SuflNowuXWxpW8kUaVLFvK4R9vh/4ImYEmoD+GRYvFJ2ckCNDEtOq/POK7lrsFpSDgP09r3FQa8IP/mHqnhb1ledoXQ3MiqDQ9EgR/24wegrDvz+jFDtq1TofuFtI1qx2llks2XJBGvkjTfHddOJB7XmjhhXBlYgo2Q+fmj/dJWQCAEtQHu3pq/QS8bym5qdt9CxTQ48ZdOmkboJFBjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68vtFyCb1Hx+3g+zQO5wm5tLYb42RAPo0LbPsmGVogQ=;
 b=EO5514YV7WanYHvVoelBLvGK+pqt+R15IQgQdY+CLctyN1kJG51/UXJ+uvaaGlkt7VNeiYPowBgVbivdMvnY+UUMGQ5IpbEZ6cmbL/XkN8ocQ+Yh2Tchs602IxVSZtkByP9dMHbTC0Ld1o3t3q/D7FqOQ640ggMDOTkTpRqnHZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3948.namprd13.prod.outlook.com (2603:10b6:303:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:25:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:25:50 +0000
Date:   Wed, 22 Mar 2023 12:25:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 1/3] net: do not use skb_mac_header() in
 qdisc_pkt_len_init()
Message-ID: <ZBrlsqpyfj7SrMze@corigine.com>
References: <20230321164519.1286357-1-edumazet@google.com>
 <20230321164519.1286357-2-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321164519.1286357-2-edumazet@google.com>
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3948:EE_
X-MS-Office365-Filtering-Correlation-Id: 375348df-158b-499f-020b-08db2ac83095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkmz1efhcDs5fTHImqLY++5dan/CdlGSw3/UAvYrhy54IZPyAKgPGHlAaBBnr1rnjn8pRYVlMGCaLMGmy5HSutxlJSBBFLAhGuJ+yn9Jixj+D1syvGYv0TaUR1W3iRjXO35fajVX19ZTk9VcBxuXRuBTRjGw2i1tQ6BZc63P47YorRW9JJLw0x39JbYHriIeJiqTRgz+xoqVm5fOkf9kL0qD2YOBSy8jv4RvQ2NPrWl5oPisdtGNKICYk5wzYigjwLfaJSGNftqjtwH9pgGuY3U0JO0CXFxiUlaDO6HuWGb/CI4YlX1qa3ekdqHXE7oQY6x4ML9WmX+ldmuRm5mQKQ8ZGV96mKfYoBg14Kc5sSVSNfrG7W4n+VngM0aPhB8OJUdnPyMZarwdiWRNJKnnzEcclQ/4AcSerOOr6pedweNVZoiQi1hSUC0LyRxqYUV+GMyBvhwu9e5rTvilpZmImhMaUMWxgaLpFx/3rXz//A8KM6dgyUiNQ51+QHq96k3+s1xUTLa3Gs8/K3j7gdkKkPd2bCOTiXyy8WEexaW9SZBUxKOl9WfAhOZ5QSci1Qt3cCvgZsBXB85jiEfgThl5Xc7xTRTxgtccdKmwAwLt8g62Oxus5Lk1ssyUyx5UpIPTY8g+pSoAw/pmrEVWEWbpPaP/oi/he9JvOGx+9hotYRdTXg2r/kE1PiLPFaUOeZaN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(136003)(346002)(396003)(451199018)(478600001)(186003)(86362001)(5660300002)(6666004)(6512007)(6506007)(2906002)(66946007)(66476007)(6916009)(66556008)(54906003)(4326008)(41300700001)(316002)(8676002)(6486002)(36756003)(2616005)(4744005)(38100700002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1cRaGJ02uRs/vpbczI7ou3bYPTufXI7hQKO8+Ysk0tJq4I+K1sSq2CHy/oO?=
 =?us-ascii?Q?9foRoZTXsgmLN+pMbqIn5VR9kI/jRp2t1R0fP03kr6AcQMuDV6Om3rBEgXyq?=
 =?us-ascii?Q?Imycv22xoGqdmRaBXajC3zoI+LrYtM9xQRDjmhvEIy2/wZqhDpEh3xLf2p0p?=
 =?us-ascii?Q?+jWwDwmSuxPu4MLevqV67L/lZoqW8+2QQO/HO1zc9ZOslOqxSPdPm+5GQPWO?=
 =?us-ascii?Q?3nA68eXpr6d2pu7HwhSkUoRmJkNREdZPvgDh3DNxdLVSFOST3SxWYol2pbsG?=
 =?us-ascii?Q?pdZkQhykc+smCnT8ThX66LV2LfgSLQaRiDn+UTfkYQU6xzlnpk96EVTwRD3A?=
 =?us-ascii?Q?1HUxQhfKdifs/ZuKwaqXno5BilPJ4Frk2JhQOv2MeUkIjdbN8wR0V8k6z2vs?=
 =?us-ascii?Q?EXJQdXYTuDxXaHHt/4V8ZJAigZispAR7t/QexSuJDFq2+7CJMOQJYgTvY9Hb?=
 =?us-ascii?Q?edjMI8CS6lh4UMAhQr51Mizpn96yNr5JpY83kHGC0bx/YoS02a6Fj/0hCzUp?=
 =?us-ascii?Q?wujH4A3qWvsgjEoOS973teCYVlUo8cKAdaEua8zcYg+X/Fj4rfNra2oL5kXj?=
 =?us-ascii?Q?3NnjwAd88cY64C9LJ7X9XxFtLh+N4sHfzdnG3Fj0ifAt+mKuFF3s8/WdVSBL?=
 =?us-ascii?Q?7engTug3xxgkkU/TgN0/X4+Zya8eh7SX9zwqTJqfOgSrhGIKi71hQDYVa+RE?=
 =?us-ascii?Q?FjTF1e2br0vDfQyxzYSQ6RWbrVttBnfzadDZDxT5uNSVl3QEfW7il6xVIfcY?=
 =?us-ascii?Q?F2LR8plDntGj8BfYrkIRY5iwvwFKQVQbHz3vRNWAXyjzfJLzoURIQ55CzTpc?=
 =?us-ascii?Q?jRF3czkIb+0UeF0pJ0rNF7aBuDOScf9WdfSnHg+PyGuaZnjrkLMeXhLwQ9cF?=
 =?us-ascii?Q?nGtdcnBEh1+hzvsgJ0pFq90osvxso5zc3HH7Dv1qWPHLw2o7K4Fxl0V2UprV?=
 =?us-ascii?Q?0cRhbgC5mLJYOEo//nPnBY2+ylcwrAJpUJS7VW340+qiRDStga9FKlx6t1k6?=
 =?us-ascii?Q?CUVRYUTlYccJvV1auxc5ra+zi9t7AX3ydyftG4xZ9wNgpawJX1IT6xlxGzgt?=
 =?us-ascii?Q?itcjqqgWE8j8sARsd2XAD85BqdwsfmESgkOzLWtQ22sJRK0tMq+wZ15aZYXw?=
 =?us-ascii?Q?Pknwyb3OzWtjJUfz5pQN+cvVdXAUinerT5XPX/6q8uHTN5kO0j0qU4BQypv2?=
 =?us-ascii?Q?5PogEZdzy0JbepSjR3Al/ENsE4n7vNfOp++XO8fh5kPveDlKLSaQ8NZYJnCP?=
 =?us-ascii?Q?OHxapyEHRWTstsIC1Qtn2gDxLq6r+gfHZj9vZYXJjNi+k55tHXLcopFMkIiQ?=
 =?us-ascii?Q?yfAKhIj9UL0OrsBrCCbBmgcrMZwzfbELHBV4SMvyTnTSWuncAXCLqGSzzuDp?=
 =?us-ascii?Q?XtaRGBw0TTwM7H2dzApcPKmkCG34CAx4KsdNPD1RhoQxo6RQLFI/cGDGy5Zg?=
 =?us-ascii?Q?xwNo7FhIDIk6Snr8Hwp3nBEtBfAGkc9DiaUJLsXhnjfhGwP8fs5Fi3sjFv2g?=
 =?us-ascii?Q?h0mpX2XixHkwfpbRzGJxRU44h+7PrmKLAAgeRnZuWIjpeeW9c4cg2HBuFeHo?=
 =?us-ascii?Q?GOQVOVfpxJLUa1tdNwxyw44ZoaIgLzVVOdKSH+6P/wEK40PmYTd+5Xj5V7Gp?=
 =?us-ascii?Q?kQqMjhrfFAGb8JGm3m7PdsixDq5jrsjxAB3RYW565Kmz6pv9Srb7iwCvk1Gx?=
 =?us-ascii?Q?wb2kaA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375348df-158b-499f-020b-08db2ac83095
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:25:50.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RV6OzK6RdyFI53zRNBFHGEygsi+EGDyV2yefUyevs+VzPdoxMlVMNtskU46PuSMvvNwbchmzIR702Q67YaDKHcFCHOLFAi4Os7q8GXaRyaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3948
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:45:17PM +0000, Eric Dumazet wrote:
> We want to remove our use of skb_mac_header() in tx paths,
> eg remove skb_reset_mac_header() from __dev_queue_xmit().
> 
> Idea is that ndo_start_xmit() can get the mac header
> simply looking at skb->data.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

