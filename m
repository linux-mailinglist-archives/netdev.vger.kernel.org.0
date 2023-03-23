Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6806C6D00
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCWQK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjCWQK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:10:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2126.outbound.protection.outlook.com [40.107.92.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242D34F45;
        Thu, 23 Mar 2023 09:10:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj7/4Ic9xsr1EkTeRk4xrB9LzrMLc8AEAgR/1FO9Gu7+NE8heW+Lq9TlQJsFiOlR6KdopLAbJXOHX4r9M2EAu070AYZlZcOu7Tz0b2fxBz+io9q16mz4Sh3VXYYZkj+z5Mj3JsxcN3ExnFtTBwVlyfTodaRzFLunCT+2qISERU3JgkSZrQWT/6m+Awd8wTpOXhL8CXdV7cE28Rl9B3PzM34kqbSph1vKNHSTe6Dd92c82MuTtOMc4NdG1/U4mkwnPf1CroRDFOW6Rg0QO7MQAyxpQ+U0UsI3jejAxN51t/eMJZSScg2LJhWLsfOxO75JRlhv4I7fMqMI8jTmZZKoSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqFxS9LFX6KO2srylBUIDe54LNGOu2/b7R1rMg3J7r8=;
 b=g94s0C8ob6IiP2UQuDCQmDljF+mSbVsyPR9d8N0H0NU+Y7YuFo2nEh9WqY8wBb5qh06SNAHFTftYheG2h8M3AVATXAkma5e64gln/0hUzJ0G/Gd3P9+uViQ8ZJRLR14CHJu45AANx9VofFZTJG1sik7lCbGmLTPs5DToAZwtU83Att1LcVVX4guxt/JLWh87MLhGS0P84zsW0IOffuiTEPqwoD1OvrrtD+RVo9Z+crkoCPMkAEehWFZzKVR6l+87WYWwqdT6v2gN9ZyP5ypv2ZAvK2yq6mMM8GzAnieLj3aNYrOJUUSn03vQH6zP6RBFrbJs8IafJTUomUpA7wCrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqFxS9LFX6KO2srylBUIDe54LNGOu2/b7R1rMg3J7r8=;
 b=fGXu6AAwOXoPu/n+bHaK5O2aSiz8eEzOGx8CuBDAqgSqTeSB7PGLLKRxdiN6nslreaSmSG0wcGipkZHt8CFg0c4Pe1FfkF1uGp+7gTLnGObO/OiziMZG/T9UvrZhJz/uaokG1j/BJ8/lBe91+d32A+s0wQ1A9em7DN4Is4qgQmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4435.namprd13.prod.outlook.com (2603:10b6:208:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:10:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:10:01 +0000
Date:   Thu, 23 Mar 2023 17:09:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/9] net: dsa: tag_ocelot: do not rely on
 skb_mac_header() for VLAN xmit
Message-ID: <ZBx50lRkpmZudYI3@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-5-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e531540-ea72-49d0-d085-08db2bb90e54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGsNLcivAffKHzgZ3Noj+T405Xx7OjA4gVom+fb9CyPPgb2fFZQfa7ddJMLyrLCw0FujHThr9DEoYd7nQM7wfa5Wp/xJ+YRDGkigsoSs4a6lTJEbRh4OUf9wIKa20whFbv6RfPG5RyqHdUpR1yPIHI4R9BYr+V+48ESBRjO2flDp/iz4aCqVhzHZpq8lWVYzECgmS3AeIh1Dy6e/kYtUPpdYFbNq5If08ABIq4RxBQIt7MWufl+nUv9NF3L3Tlg/Kj57WfFvNDScHfGOBpLPXQQPe6Wq/n2NfE50Ma/iXyZuV9Mqr00EE5YAk+XYODo3doyRvsp6ifKCWj61oo/A1eb2xrMF4YPUUUglMFn5HiGC1GNDP0yi4S/Zrc/al+STJtgEJDDsHUhgMJ8DwXfOti0e1+Xf1bv9pdOoojQuQRyPrsO2FRoC8Bj47zAfEjVLUABH6uSlwBDCf8ASkXnWTTkLa8HoKw/0DRKHI6uIJKqllXfw8cPAXvPtWIJeNxzDtGObt1lCvSxyMv3IOu5Ieffyc3TPcW9LJ0CZ2F3sqgulFeoCoCNibLhKrQXzC2B1Iq6F8xOBVirUAEBrN7K48SVDR7DzzbcHDRnAPs3h/cLB7rvU5Qaj9sjWFzTqWCjXqeAKOFy0NXR/0K1yIet6+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(396003)(39830400003)(451199018)(38100700002)(2906002)(6486002)(478600001)(2616005)(186003)(86362001)(36756003)(316002)(54906003)(4744005)(66946007)(66476007)(8676002)(4326008)(66556008)(6916009)(5660300002)(8936002)(6666004)(6512007)(6506007)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7bBAm1Sed7zsG0fxkFIrfqhyHNFXGA57PKl+xwY0drFRNiEane7dhem7d3oR?=
 =?us-ascii?Q?JBgEAN/L+1ga6l4/r0iEeaJcq8512Kmt2/AqGZwGVwc657/KHF2smv073G3B?=
 =?us-ascii?Q?m9epr1GXc64R+9eid+1KxWPZfsjhQwG0m6qbG1kSipXpiHDN8OtVHkE76QpI?=
 =?us-ascii?Q?cBpCIj0nbeQVXYb4z6tfq6s323QW52kpCa7vMLt1Xk57jvptcPWXK7kEewO7?=
 =?us-ascii?Q?7m4r7KzLdXRKSthtfEqokg7LuGUwjkhtvocHR8jLU5LLSzFImzr+RJtEajm+?=
 =?us-ascii?Q?n0s/UDhkZ0gR4yOYRhqTmb2kIPRLqJf+evMzBvI8bNNlaO+k46lcYsw0vAr3?=
 =?us-ascii?Q?UFpxCa95BtFuQK48rVAt7EbxGbyUwuDulYS5MhtBzeiHms5uXE6Ovg6O/tB/?=
 =?us-ascii?Q?2Sf1LAIs0lZIOH90Jpzm7WGmlZYp6+z8/SJNPA0HmrSBEfl7FCWuHUUcS0d7?=
 =?us-ascii?Q?YauI3pCkQDG9NXQs3KVudCL4qrgrvxIYYlwShGvZV24Qa4dNpPISocdjVPW+?=
 =?us-ascii?Q?mkh41k+S972sPRVTnt2rO9yM9pKd0rHFOj0AwB7ucrZX5OQeMiP9d6BFBuSk?=
 =?us-ascii?Q?wJkNAUWP8c5V8PJPzE27z2bde1fYDoVmnfJyaioy4qSsUoJyDfx+qXkyUmF3?=
 =?us-ascii?Q?DrcQaKOTGbEXwTvlu57ZEjX8dwcdEhSnt5sh99HaJAngAR7ErbGwoWRH0roX?=
 =?us-ascii?Q?ZTAnbwFMzH7vy8hg5P0ECbfrcbhcPn7SAn+KvwHhji17QXIsqGT/LKN8I+HQ?=
 =?us-ascii?Q?xJ+WTLYPzwL4gU5H51zrS1utD8lRB4P1tkoEgAZNsl+nb2ZUaw3NX22T3snx?=
 =?us-ascii?Q?J65oS34mEXz9JB7G0AaWOCy411QNT0ZRV3kmrQHn9JASmJjN88e1tHGw1MCE?=
 =?us-ascii?Q?jw2yCdJHSqrUYmEsG43XgCJPmvwRkRyHt642KU6VvangNTfgjJnsrZCVajfV?=
 =?us-ascii?Q?5cNCLs203wiQcSWRE3uv3TrPSXUSUvcj6t3vJ+vkXXQ6m5/H9HyeGJuBZhfz?=
 =?us-ascii?Q?BKqoMIOKkHkFcQQ9fjhEDZ3hevXwCKtxLDKe1MxxJYMx+jv3ZTGQl78LQfkg?=
 =?us-ascii?Q?slY6idcWyJVKfy5K44gOxovpSPNGH/4vIV97wJx339o1xJTp4+u0N/G+LE4N?=
 =?us-ascii?Q?n7UJgizRKRVHhcOisLbDNhGwgIus3P1SDRIKFZlKOdNfaxaPKXNOZfmZT3ew?=
 =?us-ascii?Q?vRMuvPE7XWAtY/f9+LWoJ8tbuxuGgPjADlsOXyF/r6sWzlKnMyLUMFWI/Ai+?=
 =?us-ascii?Q?yCg5qYTnCBRyWjufz9S/0m0CqVVTI6h2U+O/4OhKmZO3JX8qYRE9+NiTlPJO?=
 =?us-ascii?Q?MRe9CqpteRSbVBruHqU+LJaU6LWmhanQLwLqDHNGarYoRQG0fTTGVjfUfkv8?=
 =?us-ascii?Q?w+pb0CdL9EVfKCuBJCruDie8rQvlFonVOcEZtXiFhcor2zB6SOrP5HSfczPw?=
 =?us-ascii?Q?/k9zdLdnJOSnC6ExA1SuAEBHTUKuhTiANA0I0KeCslExx6t0yYTk1b0GJott?=
 =?us-ascii?Q?eFrZsMlJIgPNMuYlm47YPetxIQKGVtBZVqe7VPa3/Cavpn0cn7lFQLUQv11P?=
 =?us-ascii?Q?+2h1uvjUcNCttWRebDUjD+J4I83R7hzC9lewUvVT1L0TSsyNKQgL2+iIcRlz?=
 =?us-ascii?Q?EbU5hYY2K3AYVxicox1BHi+GHUbzYP8FM17TP5jPnr/PLHz/MrfxEbR37FxH?=
 =?us-ascii?Q?3TH6xQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e531540-ea72-49d0-d085-08db2bb90e54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:10:01.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2v9GUSI0IcbEYdTox2GxN6ha18IM2GpaRONz5sj4gTFwRUE1R361OL8R43xOng8DbIoU26SR0xMPmRwf9maDzSkTfiMQo0bZruRDhBH2k9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4435
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:18AM +0200, Vladimir Oltean wrote:
> skb_mac_header() will no longer be available in the TX path when
> reverting commit 6d1ccff62780 ("net: reset mac header in
> dev_start_xmit()"). As preparation for that, let's use
> skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
> located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

