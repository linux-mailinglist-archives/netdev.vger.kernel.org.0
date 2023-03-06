Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954A16ABFC8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCFMpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCFMpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:45:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2135.outbound.protection.outlook.com [40.107.237.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9672942A;
        Mon,  6 Mar 2023 04:45:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDP71m76R9L7VHtx9ZXoB2ixWxwheK2PSsRhXB3Dv78+8w2CYiFQ+SV4esdSOVOdFPO+Kr7GkgNKs93YhOoFy9G8Uqu0oRWtgRlfmxmXy/SUoXpZCBzhWTRL63aCEFTrjBcNDUz/IlTQUdNluo5PTzxhf1OURqj/Is1kGgVk4PgZHAumWAvuhhE1kbJq+aJxU+UVAYn2XbDpVx3HOSslj2QumQZsEl3QWFzRRv5UWJ8VfeEw/zXIGWt75cgdLbl0i9UrNv6wKVfnW8lBFFK8Fr2rZTrM2yMC9C9ipdaWIRWRgaEkmNnFL0w+w5ewyGAElw9jIupKwV6oYULTLAZbsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMP05iXIbHJF+CpBFH+96YeH1aJgZ24MyllpoYYusRw=;
 b=BSy70MOB9N1MWwFZdglx1jUaIDXaVXHH4X66AXod6mQuZFpAfp+HtW/5BWq+3rCVHsyMYsX7WUGH3EfzmcIYZUlMmcMzweUM6ssB96deVtxhCUqV3XhEAYrayVYgNWtJyHKZrBpQ1DHZ6cw/3Qy1C374yOOd/J2SndimUGGAr+NRsThh5n4JQSZ8TuesRD/ZRiIqFhjHkJmuxxZaS6QZ1drzU/frJMMhoEeHlpf2sFrCGvXHx5JJsqXZ4b0RMUbWAMIL5daULuZF09UDj+YxWhH3wcwaT1GXAYDU8MNxFDNZVg5ZyVye4sBo4WURPifzXuNB5xo61Ij2mVS4oiUIpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMP05iXIbHJF+CpBFH+96YeH1aJgZ24MyllpoYYusRw=;
 b=OuhtZDipP+CVNS2qfSmQkJnv7wubQCyKJt0UjOUSQ77GSMnt5InvWIqNfcE3F5ETQTf1IylUqDbaBABF7djI923E1y37uO9yq2IfncvBbDr4Qv/Jv4eYCSTcFZb2RpxPiQaYUGt+qwsb0OsnhJpMyrinySMXUuUnAzAsCwOITnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3754.namprd13.prod.outlook.com (2603:10b6:5:24a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 12:44:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 12:44:24 +0000
Date:   Mon, 6 Mar 2023 13:44:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hci_sync: Don't wait peer's reply when
 powering off
Message-ID: <ZAXgIJcaUUqKwrO8@corigine.com>
References: <20230306170628.1.I8d0612b2968dd4740a4ceaf42f329fb59d5b9324@changeid>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306170628.1.I8d0612b2968dd4740a4ceaf42f329fb59d5b9324@changeid>
X-ClientProxiedBy: AM4PR0202CA0001.eurprd02.prod.outlook.com
 (2603:10a6:200:89::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3754:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d80e4b5-39c6-45a4-3a3a-08db1e4083ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEinuOL6DR2Gi26Qn6tGqXG63GFYjL27/EwFNxjVUP44hRpUuDHIbz0LzSx88U4j6RtZLaE9s2SXG98njzOQffIHfAjXbf9wKntOr5W/OUxBExU9w8802Avn/EJWFkhATvz3xe6lXDwrDEIrvhxHNjDW1EqrCdqP74t4TiRA170VgIDdxZRqAR1gYTD1GuxWHPye7XzAb45J7dDxNjD4MocKnw9fVkQs7mbgt0cV9QBhOmY4eDpPhKPO0hi27a/PbSk6AH0oytnglO4cxtT+H5SRT5PN/Qf0OOjAqlCnteFeIXYUafxTxbUMHyf+Gy7VRoAtQwRWi85h+imgWBQcemsaz5/+Bz7VWg9Z6kcP3rQRTsyvXcKqRjMWJ2ukUA3MGGyNokXS2MWiXKQqY2kDYtJ4ZBFYeKCXia/s6ABPqWk5vDL9GDD43b3Ky5WuNXG9dCvzR3DMeIi0zWsP5jdYIUYNiWEViQYfmEnnpM2L04OaxItZLmMaCur2Mq101Vsne5kWVkTjl33KcspYDaQAJf90QUb76pagU2RpEUrFUTfGfKORYQPdHdoOcHafk92VIPacKXIW8Q0P3wcalGtRM11+Kb5v6jakZP3SBJAcQkCodcS91RaCrLpk5gaGbAC2xufvu7lVzH5BPwSN+KE5f4pb5SGvepfpQQWv7HUpFj/ncGhujmUL9pYjKS3v2MtW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(396003)(346002)(376002)(366004)(136003)(451199018)(83380400001)(54906003)(36756003)(316002)(86362001)(6486002)(2906002)(186003)(5660300002)(44832011)(4744005)(7416002)(4326008)(66946007)(41300700001)(8936002)(6916009)(66476007)(8676002)(66556008)(6666004)(6512007)(6506007)(2616005)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kY1+JyfffPAKOKJi5HkYCViMc6/gfoJjyq49mRh7ULGWXM1L+Xwa6nN9Zxs6?=
 =?us-ascii?Q?B98oSuruaE0misMOxDzKsiPOFhpiBhwLC09qhKgrtVxk171C1d9vsNIKxI7V?=
 =?us-ascii?Q?pQNttNwIlZ0gSVOT24/blAgGzXQC0AgHy89cAfhrilWAPtUd8Xe6JApheFow?=
 =?us-ascii?Q?hrv8NRAK/ltii2yOBEKAVVSzyWq/LAkhkPl/BAvtB1pCvZCJJCc4ru5UaUPF?=
 =?us-ascii?Q?Z9WiHFh7tZLQJvQHHuEZvg4I7vZEEAWyoxAAckPIJkZjAcXnoN+TYmHrmOUj?=
 =?us-ascii?Q?1qJQrebBgPLIix6347raEK2pgDZd25ChoZTP+yZOC2H8aQhY9SwuQTu90A4z?=
 =?us-ascii?Q?lQnoxtKSzLf49C75PTsmrYhxcRdKd9AV7xfjYlXbM6CeBKcFZ1jb4mBnYjfv?=
 =?us-ascii?Q?q8fAL8mIXgKlzF+9wI/JgnjBtigoYIXuMhDsC81xktf/FyRkhZH7LiKsqN1z?=
 =?us-ascii?Q?XVqJwjR+0nxNEYP0wkFzN4iUQTEKW0YbT0Zcic+ONsNkxAlMPATfDBmxqCph?=
 =?us-ascii?Q?z9TeTWvOqYqdHFc0Fce6q8QKzWM2l1sgaKUUP3HJlLHChwfACLXpKPFdE0hB?=
 =?us-ascii?Q?msmdm67bcLEMJMHSQin3AtslhaQnLIqVlfjBeV9XYv0jVij/ETuoz0AujWh+?=
 =?us-ascii?Q?817amjiAKTIJOaIvTxszaQqbR/1xUg4GW0SVZ9InSi+WvcrWYco/1qZ6VbSD?=
 =?us-ascii?Q?t1rIkplxdr3Sxkj+JofO1FgjS2KPFenqmUSsFcWzjuBxF49VdEZfWluVe2wr?=
 =?us-ascii?Q?HpHizlkJYZ8a1H74Gvr32Tyco9Hus9f52gaFB4PxuDK0Oc3uQTBiQ1nGYn8B?=
 =?us-ascii?Q?6P0sFdS0VQnCXlGssyjkp9MMZGU76YgBAQRjSMRdX0m/0nPpyq3LUoP3r7vj?=
 =?us-ascii?Q?+pLKFIJMMIghVEq6sTe5oypumpsHeyKxVSsECr7i6huyJg0IkMnx2mG9OLGv?=
 =?us-ascii?Q?3yXscqHeIfya5uDu+tAj8BqQ1jxPGY4Djwyk06vRRDe5a9FJ+qpdANUIDr0b?=
 =?us-ascii?Q?jDBYixeYC5DH5NbUDAFvXf8c0+xR0TPf0udmNxrMV59h/J9oPe5SmWOTHpqX?=
 =?us-ascii?Q?DQ3oxNbhldHdsg+Adxrsr4kriIf3cXVLywevDxuY3OIjZPJPI+LrhoI+V4O1?=
 =?us-ascii?Q?Ib18BSf43AXIKIwHrioB/+sfEmvH6cQIf1eIi9uIcqmB7Fqm4HcHdwqhMPFF?=
 =?us-ascii?Q?tWxFFGxvYX7+u+krg7nMoQnJ3MmiLTQDRcJHwUAMiSu4rlZPRAz6IO/DHGFD?=
 =?us-ascii?Q?3Or0A4BFaTT78rbRZTP2Li3LGauZIQCcZ3lcO2v4Ol17y9lfHE9VDCXhWYnV?=
 =?us-ascii?Q?JNChnQhnSIPiyUBaUbP0SHoqvL109kllJjvRf9HfTWwSu2FMTuUEc4siJEJh?=
 =?us-ascii?Q?Ec2fjd6Q/78ps+aiRzq11TWba0d4ydi4gkkF+Eg02Wr0/UEULh3+d62lslf6?=
 =?us-ascii?Q?IN1han+WnNOhiZxZ9volEnTFSM3nf2M7KuSzYTLxOi25UW06YjqQY+4i81z3?=
 =?us-ascii?Q?huOcUM3QsG1Kd0TX/uwLUPFqdKG96ZY3g6TMEe4THDhY+ECDy40KgADQXsMK?=
 =?us-ascii?Q?+Re/tAmovUYnSzhAwM+t/Z9htGunsr9rcp9xRTlBciOp11MOhLbJhX13mg6R?=
 =?us-ascii?Q?oHYtm/SObvBDClfFXfSdttFbwFmp3kG17nKV5JD08w9kGVKeZ44L2iGcnAy4?=
 =?us-ascii?Q?SglUXA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d80e4b5-39c6-45a4-3a3a-08db1e4083ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 12:44:24.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ydxoj9ueNrmxbGBqqRjiVwUg6gjZNmXsTQFD786jKHoafXKiOCbcdOgG5uslSF2YbtfE3Bw/iuSTs05qVCM2Ybb6+vIQeFGPt75/bQg40zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3754
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:07:07PM +0800, Archie Pusaka wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> Currently, when we initiate disconnection, we will wait for the peer's
> reply unless when we are suspending, where we fire and forget the
> disconnect request.
> 
> A similar case is when adapter is powering off. However, we still wait
> for the peer's reply in this case. Therefore, if the peer is
> unresponsive, the command will time out and the power off sequence
> will fail, causing "bluetooth powered on by itself" to users.
> 
> This patch makes the host doesn't wait for the peer's reply when the
> disconnection reason is powering off.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

