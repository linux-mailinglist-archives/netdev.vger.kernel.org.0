Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73476EA6C8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDUJTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjDUJT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:19:28 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2109.outbound.protection.outlook.com [40.107.102.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6899A249
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:19:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C019RDSG73FdtJKk48lnGzNo+HODz9XnpfwCR/x3L8silQz91bcPpKOID0T9uGHSl5hM80SdAkRqf/YgDJtApVxs4mOGlh4G2Kb36dNC02MrLS09X1dHX0xxdOy8fqZD/1LRGpPNe3clcKNly588QFU0/RXdaGJIknsPvGzkhXLmE/ZZYFs7o/zEOC9FMjusKlAx5STG4fb7fsClVu+LozSD+kZpBb8UJQ+QMs/a9/KWem/8oXeKjq7igFHHvCLDAP+CqNWTwAwnj4w4AeFQ/bIBQFuBawax6+nXj+v3AKQegnIBgupAfk9hMxxb0NmN/bi4Qo4qMaVlaX5pQw2jJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2vjLezSQCX5m5i26rnI3lWePj6A8iFwHBAzDwtxtRU=;
 b=LHiAaq7JmEw/oxr3LQ3J0Y8kk9a8CI+cYVhIFt4IMNpgxMOfFpWeeSsm0pi04Ye8sdO1HgVdeN3WYuVKtrm3Az5JsrbQaijIxyjwVmsFTTg38/epIvLDmZwZEamsy5zxit3mS7CtbIliNEsRQN+RyFn2+AJ4b9J1pFlouFhulRy0HazP3RsXXwOYdGOyjuS6296tQugd8dl0TijDLnFL9RuugzaM/XiSblUg8yw/u3+44Hy1u6E6u+xXrWMIthahDE2NVsy23t5XiO+V5lfCEXXT3b7lxqSvTBz6L/g0cu2d9A9RJ4vC6fVLYjbsFcqLXDyIz0LCfPs4QEYRBIVCGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2vjLezSQCX5m5i26rnI3lWePj6A8iFwHBAzDwtxtRU=;
 b=floeBOaGZlGU0fEJbhBYxz3kN5YQbB6te0DE4RtC4Mfabbf8NotVTdv7DnJm/FUWw1O9OBPqFKSd2ZmaMVTgwI4D/T2FRGw2pRtUHf45ogqUANj9+jl1I9dJHz2Q8A/6TOT8d8o9yTmyICagVbJLNr8OWnQW30dmZK6C6S+rKyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5594.namprd13.prod.outlook.com (2603:10b6:510:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 09:19:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:19:12 +0000
Date:   Fri, 21 Apr 2023 11:19:07 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 v3 2/2] iplink: fix help of 'netns' arg
Message-ID: <ZEJVC+RHmPunnxH4@corigine.com>
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
 <20230421074720.31004-3-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421074720.31004-3-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: AM0PR10CA0011.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: f8b4db34-caca-4fbd-0a1b-08db4249787b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iumSHjwi86H4ewH2s4yaPAAInfcEs3Y9DkRDPdCcvkSGoZpNdQLFLhhjFq9C5TiL+utuek7F9xvZYOW8lf7Ei2Xlo32BUdfpZLYLGk8aMBRqT+RFAOqbJlM/kCd3iIvRZkpjvOTyHXfbXe5HbRnzN8y6r6hA+Gc3MK+RgjBHXL6YALD3/F90F28BDajjumhQdS/xqdE4+N+DnBAgvFnISLAloB4Xk2extjQ1n2qzSyfjH+zJtK7wd0KSYjo//qqG+hJ0EtyKKQBTsr+Su/2jvGV0u3orkO8Zm78JOrPK+ZD7CiWajofDMyKSyzlvgGFgBgbNxjGErMwp5zJz0IYNIlxtk4hGzj48FvQV/PzgLOdX2lr18qveCkD+WW6jVEgn6B6OawGBKsEPlcHfj1eRJVhLAKHWAy/EVjE3HuzXgMTF0jfuhAn9F2nXgD/Qevezr1djrpVkI7yAK7oFk7VtPbXZmRr/Gc7O16iWYg6cRoZzZNTaMEXK2zAJHwzrHgvZaUQyJgrUqfWEf0vxOOb2aT/sPckffFoGA2ZXGx5Fv7ky3mNS1hFN+cZZ7mZRXevUWyyJAvPpSQumOH6N3LbjDmAMFa2ALyK41Y2vTQ2L3jfr04Ar3ZzdYaV50CSwFJ2a5UBu4np8MF4b3Pqf+8aXMAf+A8k3e00uXOa1tcx7tDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39840400004)(346002)(136003)(451199021)(316002)(2616005)(6506007)(6512007)(186003)(6666004)(478600001)(6916009)(66946007)(66476007)(66556008)(8676002)(41300700001)(38100700002)(6486002)(83380400001)(4326008)(44832011)(4744005)(5660300002)(2906002)(8936002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PxXaPq6LS06QRnK2+q2SbLlx3c3ST94KFZFO29BsHmXkw9Bx4dzcsjyGqO6Z?=
 =?us-ascii?Q?zI/m8KUucOhYAL4G5VT+TnAxGFHFYs8+URUy21nePAGPq4pSCeddWIxzv0Bu?=
 =?us-ascii?Q?msWbYjU6Sx5CZ0bXlznCBZbCgAmlHeqmKMiUh0ZBLOr9FfLG27qMIfvUHBXg?=
 =?us-ascii?Q?EHrIOnZC6QOSjL4ATf0X7cWDd93Lo7BnJ3Bvg+TuVI6l1uUf/wylw2R8++s2?=
 =?us-ascii?Q?ZsQwp6DwP90reSFlP3IWja+Uc8UiEENG2rAWrMw4IT+1hL9mtTpr9AukULn8?=
 =?us-ascii?Q?5ji+MPnQG4+HPBBlChWFr3Mljc0+PyGNlPVOypc3Cq5dJFG7FqIpVGCEglb7?=
 =?us-ascii?Q?wdsSQtnUjqfzfPlymTOg73PBsQQFuilx0XTAbzI2+29p/iX1lAs3T8ruJXr8?=
 =?us-ascii?Q?9axOt/05A4COkx9CBHEnIvwdhO0K8FP3rNWZoedvaeR0QMalKmUlGcT1YEJc?=
 =?us-ascii?Q?brVjb8iDBVIazs47GslRuTPpiY5QQS67hwWDf0+n2BOZuTMxymD1fHeaNDGW?=
 =?us-ascii?Q?UlG240j0MTcs5vMeysMDYiuRHOh//ex9HX1lzagF7xaSogKduQs93pVNitbr?=
 =?us-ascii?Q?mymsgSEibrSRft8Ni5nv0Q5IYcQAKDRLbIksY/Ou4zkOyRKG88vldlOEcmCU?=
 =?us-ascii?Q?nmSkLobrq3CQzoXBM+1Z3HKBBLAy7ThR0jWN7bCZXixqtm9LbJdOfjnfA0Tc?=
 =?us-ascii?Q?/mCZVA3c5f32ndZvE81WnaLlf/Sat+YDoGc0symScbEFEEQ2P41dECutkj0P?=
 =?us-ascii?Q?3lMRbXGJ8+JJb4NC0ZxA60J+vqSK4sf0LjLI06HhfS9qRSZwt69nhSYBg5py?=
 =?us-ascii?Q?k8WzSNa8bth1fqmqmmXZNNGMAEnFkQcpEHpJDGr9ktlpmHazmbx7az0UkLzz?=
 =?us-ascii?Q?M4GyYAch0zvffF2mxUrTl1fZu62gERxzqrYGRLt4V5EnXR6XHRvh4rIr4DHY?=
 =?us-ascii?Q?K+nV6N5zpxWx+WcHgRkN6zKhsEBU3aFVEOoYyiYeEqdnxn3GiCxackJsVGjX?=
 =?us-ascii?Q?NAG7MEg3BLaDSmW+RD9lOXLkjL2Ym8bI6vUtGGNG1d+lc2rmgbpXtAc7FZ0H?=
 =?us-ascii?Q?hgnbGvFSvpIyAmr0FD98HJC8oPbZ9d91osq+JbxuXRVGE+RCJbMXRi7G7/l0?=
 =?us-ascii?Q?4WdAleeQ54J+W7x30eoirhzGYANtg66zxyEsSlcjtWdzQ7TNFvmik3HUtKG7?=
 =?us-ascii?Q?QSSqk6n0y9cKe0eX1CYqG1ByYKzyJoc98RCsSj+U4a7h5vvUODFLZiRT5fDE?=
 =?us-ascii?Q?me2RSUxbWY55osxyK/UDE2z5hJnhxCE6FnBwQ6vxvJxgHDdHiMURKwiicaBX?=
 =?us-ascii?Q?OinwrmEGgr4lIjz7OzRJMN/849ON/mFpybe1hI025FPnEPQmwoZ+ALyDbtsA?=
 =?us-ascii?Q?2g/SPIzcrIPzkTVeMC3ivy6/ZYlY2I2D8ndct3C2N72iRkWWhNCrM/XNuKll?=
 =?us-ascii?Q?rhzgkxeh/aobnCTJW0A8JHFbtvG8C2yzYAmXWaCAGmOroau7jyfQaTyjXLcb?=
 =?us-ascii?Q?lb56uBhXR9LsgybaTn+7vbrvaVQElhkXjOJ2is8wCjTaRt8eEjP4oRMZCI/W?=
 =?us-ascii?Q?8wDJqL8g3pW7SeUqb3KmNt18m9GvwUuXdkpaGv9dfYTamRoGpW69ymcfX2Sz?=
 =?us-ascii?Q?7OGUSBPJJEwDj1wDgbJQKQlbSf3xMWhu9Xu9gx+N44p8jksUrpvh1SI3XEoJ?=
 =?us-ascii?Q?jpuLYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b4db34-caca-4fbd-0a1b-08db4249787b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:19:12.5895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPjCQEwPAlcLuQeUovDvAruT75Wqs1GB2RYHJBMaMlUL+7QV+do6Stsju8mdvp+vNHZe36QS3UvtIrLRHbErABW+uqrXsT3wa6z+wuhqAyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5594
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:47:20AM +0200, Nicolas Dichtel wrote:
> 'ip link set foo netns /proc/1/ns/net' is a valid command.
> Let's update the doc accordingly.
> 
> Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

