Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204386D37A1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjDBL2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBL2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:28:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2137.outbound.protection.outlook.com [40.107.220.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E779751
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 04:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ln7IQkf4qHgU1kXEvRRrzorEKY8YPOwV1NZQtUeSOR+dG+5qyxag6t8HMOB7YqOoLYOGICvt2hiK1HFNj0aAdjhWjqQAAZQUMbvkeenu2xuhafolp5614SpLBaNFwm5iU/Qi9wX5D3qUbU3+hetPyxjsbsz1rWaFKbVXkkESqfT7ZnhaubU7p+vaDfMYTr3pL6ehN7n5+U3YXelZYI17koEOasw+/NCZXW26MysUqWVGq/nS3iEFLVhFW0ZPxdMDTrifg1c49wpakk927PFQGPSH5B2Ucj0q82KkPsysUfXTXf5D4Va0k8SAytqkHnr8kv7adu6KgfG8gE7w2awNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vkh9DWHZ6CY+WJDjWtrC8XE0/vyXYkY+quWyrq3N/J0=;
 b=PRdnc6YnL94i+VNhuYUMVJ4LQQiN6eXXMjrwB/oiTowSRsW9bNTQwHF18x94xdLJFQ34i5REcW9/hlxM73qBgVZI0+Ytbk6pLLZhmHyNdgH23fS1UFtUSp5YY+Jet9BnUlHV1qQj5ga+mFAkQmHLFpacLsilkJjqCor9hS3tY9YaoEsve1oKCa0qTDGJyGD5RPydbuowoyho6tAvtjoVb6oeZoQyU3ZQRGEb/vxDuVNw3Tn0/m003E8u3r4SSzaDKGK+PlNcLDBhOI7SLpg7Ud4FZbZavyiYLmfzmYk+/UVbNahlOHp2+AAmkhc/JFSMUwA1UTeXh3xrimB6fJE0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vkh9DWHZ6CY+WJDjWtrC8XE0/vyXYkY+quWyrq3N/J0=;
 b=QdT81TycAGK+aKXx1j8VobkRWZdUicZJLZdgv1f6hGKXAtjsgtjN5oVofSG9VX64QYdk+DpBFHECtuu0jTrCrLnKztgk0QJLdSi6Hg7AYEOpv/4M6ug7RK0KbrmQwzp9e9tnv1kqtRAABa1xvpLy/egc8Vtnj9MsKXBcjRAA5pk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4858.namprd13.prod.outlook.com (2603:10b6:510:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 11:28:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sun, 2 Apr 2023
 11:28:36 +0000
Date:   Sun, 2 Apr 2023 13:28:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/3] mlxsw: core_thermal: Use static trip points
 for transceiver modules
Message-ID: <ZClm2zFHD6ZGVVVD@corigine.com>
References: <cover.1680272119.git.petrm@nvidia.com>
 <051bffde8a638410eea98ac51cb3a429e0130889.1680272119.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051bffde8a638410eea98ac51cb3a429e0130889.1680272119.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:208:136::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: b8574655-9eb4-4a85-b7f5-08db336d65f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LwiJAtlWgCLZWpOcO6UAKHV8AWoqhn4GFmK4ShnkfKUdh0VFPxXXcKJjOgTH7lhvoEaDBqIg5Pe+QVnhDj+GG3L6s/7fhzML2ml5QGR6MyLX4HHRN8hMgEzWPyLPFio13LWmD4VjkJMZJuSa8/7tE3wIMbnc3ikFyYf36tsRqrHy2KcMiCHp55v7bMVOGdJYhCDSFXhka91LTgnJJiBPDs4Pl3vZu/bibaneZO9PNQ2CqXWlqO67DDx3LG8Ssfr/ZpdB8y2pMmuTum9e5a1AyFklBFhIUX/VZJjTd8LuKL/5dbaMR+gQUo31PUlW0of6YYoDNuJfoes+u1jAKnxBvvVvdeu0ZDe9AMRREcUE7QBy/5jnmC20vikyVfqqQI/ARTvWn9wRoWBCulNXKClu5geUf478zriUf0CkZzQh7fByW9CTIvHubu+5azDqZBuX0kaEkNUN0lrU4wfwGl6eelYbLVXECKKTnrksmpBzI+VLmzo06+n4DyGSC9QIpvz56/S+J+LLjqL58NxaCusBLjd3OpyLwnHbwQlSfva7a46007wCyMmpBkjp5ruO6G0KvC5i3CK277Dr1khRx8nxiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(396003)(346002)(366004)(376002)(451199021)(2906002)(6486002)(316002)(38100700002)(36756003)(6512007)(6506007)(6666004)(86362001)(83380400001)(2616005)(478600001)(186003)(54906003)(4326008)(7416002)(8936002)(8676002)(44832011)(966005)(66476007)(5660300002)(66556008)(66946007)(6916009)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VnexcU44ZjgAhm+MnbdM8QwKOFZDuwiPtWnft0JdaJTKNJEeKWrjUEsy7XTh?=
 =?us-ascii?Q?t4Ff3BbeAa0Ep6gKkUNj9svDRieGqRsgGNCCikR1St1IspwlI09pWkGfBY0k?=
 =?us-ascii?Q?LLBSWO1Kz5EqnABbmIOeE4pg0xM6LX45YWhWv9iiZ6BkaJE5U4901xO4EbjN?=
 =?us-ascii?Q?j/UxnP2/u5FCRbwomfmwZtM+Wnqd2HLG9/owfHKlpwZgn6sVkY0XVBi8YY/+?=
 =?us-ascii?Q?JA6echAz2oaLGSXp31s31damgYcdUXIrnWZW6XZZHpWvqt1w69Qp346GJDom?=
 =?us-ascii?Q?NGuYnQ/ljt+bQ7VDznaBfEITSo5mnVIegPvtaxX8ZVyv26Rc4+nG+Vy1NMJo?=
 =?us-ascii?Q?+M41QldOhpv7ucSQ1HfUyvVRgHvT30aNm5qFuWZYjL4R3Q9lhWegSV2kiuhc?=
 =?us-ascii?Q?i+DNO+aoAGcU3fZbwxbWEVSt2u+Kch0PX2OXWBxmbIGqn19BES2+IOlUBfHe?=
 =?us-ascii?Q?E+tWVVW+Y3HVAuUMO8fhksYN+23hhEt3rPlPZIEKbUYtLdxGBSXrQn+BrsEm?=
 =?us-ascii?Q?VQBzVKvrr/GOqNHV03ZEMs7MrFlSHZCPi0gaCXQfVWK+Os4wlEKF/GN9LV3W?=
 =?us-ascii?Q?kYMIcelhFMpcVENLUYRrjLeQ0h9RTY6D7ldMhGrmETrxaKQYiPkMaE7Ixct0?=
 =?us-ascii?Q?TIealhzSxYOjXOGqfu/ckT5RAYqNgtJ1Yk93PzUyqwmihsnsCi19giPw6SLC?=
 =?us-ascii?Q?rycl/ro4oHB2+PMrRuIesfxnzfvrs1PZ4XKTj87DTtGYHswo0tJvMCdy5F/h?=
 =?us-ascii?Q?Kup7uUPDjZXTRxxVigggf9gZG4CdQYIC6pyjgsx9U63YmHDxtwQfXFzsD9gy?=
 =?us-ascii?Q?gxzKa89zJ3ioTTazSltJ814uyMLSIxk1SJCOrhV4+jFEuQoQRyeQXOWbxPjQ?=
 =?us-ascii?Q?FuVZYiihtpyrION8nR1ADpbz+KI1wscIaflRCwf3YoEMSMSRYKoolUhGh9jV?=
 =?us-ascii?Q?nM8pJk3dtF6c7PrZ54uRpPd8kKs743Ckm47J+1jBMcJwgx4X38KXgdQhRUol?=
 =?us-ascii?Q?2WBTjEaQXhHVmuR8G5//o4ec5nfwm/9Qw8Yd+1/NOnmBsNucFeZlFAcnC0HR?=
 =?us-ascii?Q?i/oRuj2d1KZJ7AP2cyv4MLbFvlXP2thwqcfuPRu57acU141fGf6aSyWv4plf?=
 =?us-ascii?Q?uniININo0LtV0TUbADQdakAm1HFs60U/eGftRwOPcIYvelSir/I42Q5VG1Wx?=
 =?us-ascii?Q?ziBJxVz2IebuppxC/v/hm9WBXK6OGXqijdmfJ2H7UB18PokDXaI0ll0Uy6Yy?=
 =?us-ascii?Q?Wm6o7KZR+nQii0VtqFkAiox8gGGeIL+z2bRyN00umPgoiYMjuG5oAhCKDlI2?=
 =?us-ascii?Q?vxuPzvt/v4Oh3p8PtwNdR9/j8w4dA9K+BpOYWkGVYe5ZjAE5tNTXd3K6r2Yj?=
 =?us-ascii?Q?HLKWPg8hWnEwOjQ4wXjNQlxQ8wL6+dOzea3d/dYMhajGUoEmNNRPOtOj5v6r?=
 =?us-ascii?Q?sBCi8BfI4oTcjkGrr+k2WpO7UXLR5GRR26xoakyWitlepjQleWCn2jwpxmCy?=
 =?us-ascii?Q?1+AkL//yHqFepHorSC/NtRtIblhC9Uu7kiKhgmIIUAeozc/QMOSgZAa56PsN?=
 =?us-ascii?Q?uCeeTEWe/PygzMqQ2B1EcZGTXBCTkmai78jdf5QVnAcP4zu/5vgjDxtKwpb3?=
 =?us-ascii?Q?KHhSpLjX+lWhAapZlmX1/3h/Yk4eWYMWc94N1hjkh8qdMfJSgtPgA9pQdqtN?=
 =?us-ascii?Q?l8wrBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8574655-9eb4-4a85-b7f5-08db336d65f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 11:28:36.0005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVzp1YyD1QaUI8v7X2qtemm8jwzkgeaTix2JBlHl5bNTiTtDL33KYVGfpZAhW6xRjosSXniWC+AA6AfrgfkNYj9GNC/PQJ91iG6Z1ZReejw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4858
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:17:30PM +0200, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The driver registers a thermal zone for each transceiver module and
> tries to set the trip point temperatures according to the thresholds
> read from the transceiver. If a threshold cannot be read or if a
> transceiver is unplugged, the trip point temperature is set to zero,
> which means that it is disabled as far as the thermal subsystem is
> concerned.
> 
> A recent change in the thermal core made it so that such trip points are
> no longer marked as disabled, which lead the thermal subsystem to
> incorrectly set the associated cooling devices to the their maximum
> state [1]. A fix to restore this behavior was merged in commit
> f1b80a3878b2 ("thermal: core: Restore behavior regarding invalid trip
> points"). However, the thermal maintainer suggested to not rely on this
> behavior and instead always register a valid array of trip points [2].
> 
> Therefore, create a static array of trip points with sane defaults
> (suggested by Vadim) and register it with the thermal zone of each
> transceiver module. User space can choose to override these defaults
> using the thermal zone sysfs interface since these files are writeable.
> 
> Before:
> 
>  $ cat /sys/class/thermal/thermal_zone11/type
>  mlxsw-module11
>  $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
>  65000
>  75000
>  80000
> 
> After:
> 
>  $ cat /sys/class/thermal/thermal_zone11/type
>  mlxsw-module11
>  $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
>  55000
>  65000
>  80000
> 
> Also tested by reverting commit f1b80a3878b2 ("thermal: core: Restore
> behavior regarding invalid trip points") and making sure that the
> associated cooling devices are not set to their maximum state.
> 
> [1] https://lore.kernel.org/linux-pm/ZA3CFNhU4AbtsP4G@shredder/
> [2] https://lore.kernel.org/linux-pm/f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org/
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

