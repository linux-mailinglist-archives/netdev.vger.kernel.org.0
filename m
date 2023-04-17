Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080F06E4719
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDQMFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDQMFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:05:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20709.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::709])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DF48682
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUM4mNQRcaWI9ZQkZqe7vXKc4QJ/djaxlacTrj9B9MiFqwPglSSqxOciTwaaNrWxFHGG1dO2dcQMIRTZrTz2E6nxEpHQvabnY4GbVDdDux9fKErfIVc1P5Iqn6l+6udelYa3zkDJV3WuLHcDFDbkfFRZJMwzWZJF362LYXGGytnrZcNO8kBOxYe2WF/IQ2F69CvM/U6GMAP52Y9KlF6XBvX4A4vzhHLcj6GJ4WNneEaLPpIV09n3pDSyzkf/rfUeoKlYk9eAMXWxL0cMOq0QqgDvoMdjlGCv4dmQXYUjvSrpE8g529iUog9TYr91Vx4rm3jBNug0KqdNpu5fw57aSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyAOupHLZeHpzg87kjf/BKJkwPk4AW/28CRePlo+D90=;
 b=H37BrMUll3lROHSmmV1H/7TpQ9QCJAThf4ccui8s2txtIXVyI6fmDa4En8VYiJe2a1mX2W9Wu6h4Jry/6ohpHG9p5KDuZHQKvNnJqn0R1z9oUPlYZNyi6MpVZKPAp61t/0fiTup1IFgEwf6uhzh3DrTWoLAV2pRCqmQ/guLW5GlOF/fRk5H8n7t+VIejDXYhdBEOvAa2k0Mzun9eXuUb35G8accuapuCcL3A1Acuyx2segJMhydsX1cwn9tv3/W+pa/sRhPmLQtPCPhyxONUeWFHURmlcUSnWTEqwTdaMw30ElAqXQ4D+UTwEq/7zuDKTa1Df6YMN7A2lBik5Jqg4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyAOupHLZeHpzg87kjf/BKJkwPk4AW/28CRePlo+D90=;
 b=trIuhae2N1JsuFnzxBV2v+FWsUVhSbJ24+mg77hIyPTBA3TtNWdHnCgiGLCqQi0K4uD+Ezsa0p4M4hGRBs6HTSz7qYjijkX/OJnXREIF6W+jnrtvpjyToUq12cbnR9HjPeqDGJ0WjbQyGB4lSH3lpDD1bj5ky6vlwRg5RUzdHCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4776.namprd13.prod.outlook.com (2603:10b6:303:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:03:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:03:14 +0000
Date:   Mon, 17 Apr 2023 14:03:08 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 6/6] ice: sleep, don't busy-wait, in the SQ
 send retry loop
Message-ID: <ZD01fKpq+kL25Jdn@corigine.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-7-mschmidt@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412081929.173220-7-mschmidt@redhat.com>
X-ClientProxiedBy: AS4P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: 23aeac8e-31d9-440a-9d6f-08db3f3bb915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CBLcTWV/mwrfbnDyuh9EpoTOlxN1Dvc588mp9xR1OzFbXDZsr8zRxZumkPMAVTAE9eqOteS4B5bSdgvOVBBm3RPJqQshaje+FCVsB7j4V2JnqX5CivaVxg2QCW3eNxjP84d6H0vLfSSyly+7nWGTVO0iADG/3qqYXmbeq+syNeTYcwwRKPfiCcpondUmE9FZyhd7Y9wlL1xRAsuIlV7b/xVMRMdSPc7ObowhNlNKdPag3qwDwCgJl95ktXADarIv0hUe92SxR0XaZFYeW3D14fi29uXtr07cdtgUvIDH5slv3XSSfey9McCdC6BX/wFT4WADJZrllqLWz6SEIMjh9nxFgv8zH/yzRrEvdNMyhifHIe9emq3Sd5ReX8KNaqlkd8mY6hYxmhfzfvxc3CDifr5IdRWgvtz/8vqY7t8RRkgEMDl6BRmVinkyXEk03pWdvde16ngmtl7Tiq87Gh6QvSBUKEWMOG6b+9IgKcckyTUIKP+8LbtDJKdK6Sk8HvXzNPJn5xGgpJsNxqAgvLiTDWJDNhQMMQmEQtqVJhpvT9Ok6nmHt4IhpaSfy+EUyPaSA8Zsin90cRiK2ohY74sC33xJBCpwuwRFrUsIX/EWAI4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(396003)(366004)(376002)(451199021)(38100700002)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(4744005)(36756003)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(6506007)(6512007)(66946007)(66476007)(316002)(41300700001)(4326008)(6916009)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LOgULRBQl67iwwDXDGyQAfxIjM7EZDVCAJhMkBpnl5TZZHQwjgxCY8Q9lTkq?=
 =?us-ascii?Q?J897ZcwQAoJbtJZaJlZKhQ1PJV3XgJiTDDlLXgrohcm+ZV1HYwrp0GnwUfXh?=
 =?us-ascii?Q?aC6TdmWCo06o3CDM+aJVJAGmxq7yhajcypjPC9sGec5mbefwVqEUOThQ+VkE?=
 =?us-ascii?Q?zgjbytgC7eKpFuEFNCsFUNlRTlvJeZtCSP4aSLzFnV/unYQhE7tdWlbnkiLp?=
 =?us-ascii?Q?Z9WBEaISte+5F8zg2COyk9s2qjHiEnS/xqr7/ETMle3iGmjSdf6vYOoLqfVo?=
 =?us-ascii?Q?qeoYMn6qH9OUvfQRnMfWxc+nO8dzaQSe0ONaj0ZW+NgWHE2QZ8pYmRhQDLbo?=
 =?us-ascii?Q?VGxhg0xCNppyg+2oRSk2gdXHWie6vEeqMibSVD9ZTngfZ/1M29GvUyyRUaiy?=
 =?us-ascii?Q?MRuQKoNEIKD6KV/6zon09hx43X8jeIvbPNGB7+x3xNGbS/ooXRj0szgOOI4H?=
 =?us-ascii?Q?f4z1rFhE5au8a0+dPniYkgLbyz4N4SozLi0w8MC2S2A6QcAa+fBwllgZqkfQ?=
 =?us-ascii?Q?UJcbtizlksVZQdsjWg2XQk+yoIljp0nqv2rsB6sEFzVVppdcU851N2VUHQve?=
 =?us-ascii?Q?p8oABAvhwfhBq/Kw/95NFNDrmh3uRkVpDT1XpAAzNJmvp17uC6IBysg1OxrQ?=
 =?us-ascii?Q?RxzT0WGsjHOlA6DP55tJ7BukEiJ/Gt4Qt1mXpkUqQ42qXrCnI0OM82phZgfi?=
 =?us-ascii?Q?UMYy+MLFm+/+RKhxWI7xF3W+KFQ+xPSOGo38A5MF//5wS+HdF7Re+1+qQBWs?=
 =?us-ascii?Q?ULQb62Pste0qIaasXoOUAqRiO4R9T1+Yi1b+ILTak04u4qA2THcpaH57fE3b?=
 =?us-ascii?Q?kfInlyOBSpaom78TZBoLFHLrbHSSP8TLDm8GGRyhBqnE6zhKhaavbKvI8Ofo?=
 =?us-ascii?Q?ZXlwenx6Y8o4esghn9y1UxT3taQqdtJPbsHyECIQtKkjeC0tdPDlm6+QMp5S?=
 =?us-ascii?Q?UvieftuDrJwAUCbbvWqJGbFLEQ4JA16W0aSE3neM3s+yyda4PcLE/aT7qtut?=
 =?us-ascii?Q?aK+AVKz1jyMy7NzKrXF9MrndQv09w+VUtP1RrqYzPNfg6HJCt0jBbSN7+fMD?=
 =?us-ascii?Q?VzxgAH7KpHH/mTQACwNTwYjNMoTM0Cw2raMB3kh9u5qFaSfykNCgDRVKiqgm?=
 =?us-ascii?Q?AH3K6AiMGiZz5kmWRVfDfbA7mJtxD/IeKwYgjc2E9oDshQCNSzNbC2nE6HU3?=
 =?us-ascii?Q?O7zc5kWUNdSSBd/8p0zqS2Y066DXad0Ue4+b3ZQgXMsP6a9c16YBy+er8s6F?=
 =?us-ascii?Q?lcNCCEtWTREY0ODC22DftpmrqPYnHSjVNTKyNoEd4wv517/a4TNmqmcM2hvs?=
 =?us-ascii?Q?5LO2Pe9MVmPCwOTLNgIM2BOe7n0KQhdcu9mUeO9QOHMSn9ccsBhh0RgjQ8pQ?=
 =?us-ascii?Q?XYu+FAquOwrab2LgEslAZcDYuz95UIM/IiWdLLfULRlE1ha9qGHViiri939u?=
 =?us-ascii?Q?0hE8g2T6OsnCrsUv0Fh8WObwKJYGh7q01YjSfEMAP9Ecgb/7kqRpwhPCTBbK?=
 =?us-ascii?Q?CoZwe3GniCjti3ME6oMXXYLtv/MsVZ+bk9B4XS1nlEvGD8Gke5rKyNEXmPKS?=
 =?us-ascii?Q?+s18loS9wBrm8jfGPykO3iumpUcZzlEdTJO8zxT+de/3dfKXQl5LoFyuxBqz?=
 =?us-ascii?Q?K4m9zJljeI3nCfTMl0R1JdSTfCJ+YHHHpIX1gd22qWu3Vl0B4zw9MtJrIEPN?=
 =?us-ascii?Q?o57bYg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23aeac8e-31d9-440a-9d6f-08db3f3bb915
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:03:14.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4pdqpDBHnzwxIOewlRn+jWQSgDaDi8zFTNBFDQUPniaIWv2mgta02MCNTuV8fduPoHpztzczaRNb+o88TF+lvRw0R67k+NXHZz89q8WhpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4776
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:19:29AM +0200, Michal Schmidt wrote:
> 10 ms is a lot of time to spend busy-waiting. Sleeping is clearly
> allowed here, because we have just returned from ice_sq_send_cmd(),
> which takes a mutex.
> 
> On kernels with HZ=100, this msleep may be twice as long, but I don't
> think it matters.
> I did not actually observe any retries happening here.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

