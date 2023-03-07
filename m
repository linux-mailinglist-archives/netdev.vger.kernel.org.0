Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2A6AD7E2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjCGG6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjCGG6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:58:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20726.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::726])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1319D8615D;
        Mon,  6 Mar 2023 22:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBZjfuU8PW6rrd8m/9SM0LcCrbIlZKAjUynHwIeZuanHfeCrK5yjRd31tcHVrnm4//n5jU2vMO94kJGuJNcH5pT/f0lZtpWGLKEdzuaVKzaUFyzinjyWui9/KecsJS+bl0CdgLv+oyEvM5l6Qw2KKPlCyAx3tVskCx8Bj8XNn91dJiASjB2Ix6/W1LJCWol1ycxmrqlf2lFPI/lHCdhwuiHH81GwRYqtaHjxmsLkNTRayoXP93HuPSfd2/R4vLIWo8MA+/BBQIPNSf7K/hEmcYdd+b+Ns2rQLRBEANOvPzS8IQocooke/Uibn87t2+/q9ivacm50iFwLq/6wZZOGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=609lC1rn4x1JNwtUqhqFClHEMTPqC7PvSArdGZyVXu0=;
 b=T10kygKoN+WLVsM08p+mUsZwzkj/TnMHtBQ9Npvfkndisk+8gutaATOcyHWwS4ZgZ6OgpFr6PKeOT82rdJZ0v1P0g1wG0kEo5W2E6SNkyvpG4bySP5y0eV31GKRlSIQdjpACqK45oCbJNyef5U9r6zctu9kzFlPfQ39+vEgAZqZ/rl/PN6jkFO4ClIck8H58JSIzaRA3PjL0X0K++/8WxcEpUacs/HvPyabgFijOX7nGG+DIR+PISV4LYYWeKaghmHnAzGM2LxSyDbQ5vDjyRnJm1FcHqaGAXe7HF70x8bt9VAatL8dsG5/GSx/qyWHVsgzwz2/PgwXaqJYwRpBtSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=609lC1rn4x1JNwtUqhqFClHEMTPqC7PvSArdGZyVXu0=;
 b=UcZ4gMxX2RajnTFFyhmlSx0Lkk1Bmvh0MqZ/hqXpCyGn+VQi8RxHjS+5kkYKNj5Q2R2OXOfUEoZE3rbHm5BaY805FsNf6i5gKYn+jDbnsfsV0HdztqBQyJhaxTNR/NbEP6dtajkTbSbJox1XkwM4NqVKGUcQEKwdLfXT6xdnoWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5428.namprd13.prod.outlook.com (2603:10b6:a03:421::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 06:56:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 06:56:42 +0000
Date:   Tue, 7 Mar 2023 07:56:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 4/5] mac80211_hwsim: add PMSR abort support via virtio
Message-ID: <ZAbgJD52AMpxlH+u@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-5-jaewan@google.com>
 <ZAYkypRT+mIdQr/v@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAYkypRT+mIdQr/v@corigine.com>
X-ClientProxiedBy: AM8P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5428:EE_
X-MS-Office365-Filtering-Correlation-Id: 51791778-a73a-4ccc-5518-08db1ed91b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkaTydiWgfojgSvtg2lNXuuB9L1+uj3YOmCv+o3UyRsDNYMrcnBk9Af2Vi8vqYaZBmgwKp8ey132USay9u6jm7t/N5njQcriMunySMUae89ZI9c6XgQZaEfI5d2gpG8HACATO6seEhXpgLhzyFtMgq9Ytm0G1h9ThXiqw/ilULBLs4eOWlrjGo7oJjvSLIxh3lfcoyBNDS0US75eC5E2HwcvZnqra4wCr9Dn7/mpxSEBmx8MCvQ88tWZaTWoAY68HjDh38F13FPjeNPxvfTWPs7QW+WHokefZ1rRWhbpWYvLB6bQUBuKtymgHuv6VKb6m/5R/F2A/JvmaAwFs2YLw9kaxKpkUK2QCkUqVOJxjnxE0EPczlyqIBEbNkeJkiGh+9PKK2mjNXp+k3J/BAr9kM3uNaU+ZiwRn5z6xTSmg5uWP1l9knwhUTuXMrfDTDXuGRjyAcjAh89WepQMwA/CkXzGFX/krf80x96V2P1pVl+wkQesl+5cZ/Hw6EvEpveciHu+aBtV2J8K2JRsC4txyuzhI4oUElH9JymK/IkhydXMbldu5lyeqgnBhpe9dV0CV54eI4KACDMJ5/uGJNhlb31nJbJNIAqYS5xbcjLBO/4fMAJ/gfbaQk0BELztpCpIu8yjZw7BUAr8Egn33JmT4A8SrJH90onUvWAtlrBcH0pWazlErrcf7CYt2iSgpAsMpgr0ayoQMlRgPzeu5EwbXyQYPTT5relD0HohETM2BIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(376002)(39840400004)(451199018)(83380400001)(36756003)(6512007)(38100700002)(5660300002)(2906002)(478600001)(8936002)(86362001)(186003)(2616005)(6666004)(6486002)(44832011)(6506007)(4326008)(66476007)(6916009)(66946007)(8676002)(66556008)(316002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?anbifP/9ADG0OhMyU+ww4mwtmBmI+8QTGvaj7X++302l3ZwUlQfBeP1Qphjl?=
 =?us-ascii?Q?cdimFyE305qn3/ZSl9neymHEye0CDrNlI3IREnb24UQzyxbB1K6ACCcncro+?=
 =?us-ascii?Q?sZLLRUsFa1zOnt653uQJrTyoG+tgnDY1MH/ebn8NgWQXVD2yh41Jj+KPBEt6?=
 =?us-ascii?Q?RWl5edLZylxBG+4wnZ6B+CmlrzYJBxZLSVPN7fPxLLOCcp6zMxjKaFfnmTZD?=
 =?us-ascii?Q?EEXkqicEpnyVTDYkVkCLxH9iqM5D6vWXETwbhTKE7d0Y9g1NAJsqRX3Rc+4U?=
 =?us-ascii?Q?oDYIVbOLNNjgfB9/3t8qK3l94xfMD5SM9ZaylWqzMUkpqPkS8UoqGD9BN4nk?=
 =?us-ascii?Q?tOL4CMLThpaqyx1dG0eZSPVUacRKYHB9ugkVRjY/4s2EhjnTlNFb2mqdog0n?=
 =?us-ascii?Q?y9R6R/plqvJTrEXLobfdTPZTGLLON2dTIUl5nm/ntKwZ9H5j4clD/K5EwZIa?=
 =?us-ascii?Q?4S9SyvgkBQdFY+hp6o/lf6/g+mZ3s9KNFBF3YvjNiXgxaKMeL1hz+icUQXGN?=
 =?us-ascii?Q?vOgAQEICM4MaqMeMoXACWaZ/ANggaIFT+GEAT/R08S3GabAj2Ji6EQyxKIYZ?=
 =?us-ascii?Q?/JIOpMu+ddjJScN90+JwZs4Z21l6dm3+22ZnCr73PiBanDgja0M9xZlFIoG+?=
 =?us-ascii?Q?oDdtdN0au+Y7Qr7luHQJ9JkyA3a02c9aOd9rxYeYPMgYITfLtHyB08gRiY/h?=
 =?us-ascii?Q?F0ar0A2WsNd7+F26nnl/e5+9OtB4NYRBUGf4OQ7NMO6vcdCnmTvieiyHSSxA?=
 =?us-ascii?Q?PmY5DBmU9zNmb6/e6TRRW+FdCJYj3ELua/B+XxTm19DxhS5Rd7SICKIX71Ok?=
 =?us-ascii?Q?j5tvOwQmBXX8PyhxBdDjSs+e25wj+s7Ycyb9sPLBbuCv47EU4F4duV3byIrg?=
 =?us-ascii?Q?+aOiKV6rZsxL1o9EV2eh/YF3J/e8KN7ehENcYPY58/enCNSfDAIAkRRMk+al?=
 =?us-ascii?Q?0xP01QGYeUpBi42eL/6mls1bsuJN3bO7l2cRE1Jp9NZD7I5dEWaE9SWTkO/U?=
 =?us-ascii?Q?ZvyQ/EhN3lHF++VxyJePTOYAuxvUO4j3Yfb9XuRGoECWnKO2r4A8yagZQm1N?=
 =?us-ascii?Q?ObG7hxcKuD0h2nTP5Fdgri2um1OZexOigsA9sCnWLXoWGUsscJEh37axePL2?=
 =?us-ascii?Q?lvO/9INp8nLtkD4LMpJ0GT+zoI0+JvRxZrLMw1Yka8SK81EbhFS3+2nbUvaA?=
 =?us-ascii?Q?jsASFvODA2aYvXE36qsQmgASB17/An7V/mIx5LKiP9swcbAbyohVNSN4PnBj?=
 =?us-ascii?Q?E7zXYG7S+XkxwCwR7zqMvXhnMefe2epl7qhn/k20LYU/LutKeqvhVTJmBXrz?=
 =?us-ascii?Q?ZhU7ToSVsRcOXVr1VcnBTW1n0tw0MSmkLUxtBiI8SBTpX4qM/Q0iq4kvQLHH?=
 =?us-ascii?Q?cRL4+dHwjU9sdNNTCgXJrgbIE6QzWEUvwoyvf3HhhrIe5x2ToitPDycbFKgU?=
 =?us-ascii?Q?PspmdrTvl8gdbQn/pXy12P+gEoF6aC6MSKNR4d+5TEcHJy9/PEbvL8BCvrcY?=
 =?us-ascii?Q?Oh/8WFhp6Ds5EPPzAeTucRwX2ubPj3Ail5hwZm9KuvSEaMjXJBLs38gMRGPw?=
 =?us-ascii?Q?7fMIbwQmzIypE4cfAgJND1qGf1xNBzshOKN3D/NIXiBH74XwXxbx/BU7JCBl?=
 =?us-ascii?Q?UuQQnNLznLWBFFDJfOBBebplQFm9xrjjGGpj3lKTY/z6JeZ7gmmEbHuVoLhF?=
 =?us-ascii?Q?WUJHgg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51791778-a73a-4ccc-5518-08db1ed91b4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 06:56:41.9943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8Y4AjH46lHoroIWoiv1TVBy570lcoz5dwuPLJXSeQoW0XACN2ncYj2PsBh38h6wMco6YkxAEt3I+xhZfd1mYQ5fmypwUXJpl1B2UX5ewI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5428
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 06:37:14PM +0100, Simon Horman wrote:
> On Thu, Mar 02, 2023 at 04:03:09PM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > devices with Wi-Fi support. And currently FTM (a.k.a. fine time
> > measurement or flight time measurement) is the one and only measurement.
> > 
> > Add necessary functionalities for mac80211_hwsim to abort previous PMSR
> > request. The abortion request is sent to the wmedium where the PMSR request
> > is actually handled.
> > 
> > In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> > mac80211_hwsim receives the PMSR abortion request via
> > ieee80211_ops.abort_pmsr, the received cfg80211_pmsr_request is resent to
> > the wmediumd with command HWSIM_CMD_ABORT_PMSR and attribute
> > HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> > nl80211_pmsr_start() expects.

...

> > +		goto out_err;
> > +
> > +	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
> > +	if (!pmsr) {
> > +		err = -ENOMEM;
> > +		goto out_err;
> > +	}
> > +
> > +	err = mac80211_hwsim_send_pmsr_request(skb, request);
> > +	if (err)
> 
> I think this error path needs to call nla_nest_cancel().

As per Johannes's comment elsewhere,
I now realise this is not necessary as the skb is destroyed.

...
