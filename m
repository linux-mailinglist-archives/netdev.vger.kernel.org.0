Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB556B2916
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjCIPry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCIPro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:47:44 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2097.outbound.protection.outlook.com [40.107.237.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B7F248F;
        Thu,  9 Mar 2023 07:47:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHcjNXZAbxWy/6wpzKdc+5+QSQu06v9zb1wq4y5pVmFNAn4+Q1cpTnyZgUqE7isr+QNAToRrBPVCEqH8MynLF8SXiWJma4jTCG4WjuVgRhy+xFa7zQvuQapFh/n9Lr9qHbUpcEfFlqJN+38ItBSQUBu/oYdO0FHuiG1PNpPSj+jg7OGQuuCNOteSsWjhSkIxVUWOtuscOrpVRJxs5YDZSEl7otHfZkYILOxFw3/t4rz+VD1oQy9X63C51PADDz5cx/mbbNVPsfN3jexB9JVfpaeCSspk3zyebRblVzs+iQi8yIH6+oeOmprMEUeKlQTkgtC75ZVDsedXmjNizJ0xjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDcgKybX1/ZkC4fY3hVnX9ecKc+WvxSPO98rltkbmSE=;
 b=CQmCKp0nMpt4jF+G4mXcVO7BnfUZCVseQQlcnPe37r+pHEGPxUAolb/eKTCuHRqz0Xw7arTOZdB+YEwj5cv1Ik0QmRGpQRbIK0GMAtIkfWk2/ue9hdzd7MgMCk4/Fnj5ne/s5vG1ulPaPTj6HxmrlIlhiIYp9UGppD7te/X0152FobA77Dqd3uXeDl3LLt4jEljOM68zMnPlAwyWg9pvbrJZHvdK5JwnJYnOlH6GgXOvBElF+JC3IvVK7by7kKjUMe/FAyXnQKF+R3QJ2kQeckZexRjyVwneRtOSc/TkA4rKt01sezn3Wpwy2OKkYnYBlPXOlI02/PJWiZrh39REqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDcgKybX1/ZkC4fY3hVnX9ecKc+WvxSPO98rltkbmSE=;
 b=s/+7xQHhQfqvLBr93wYY/TitDOb7cLipkm0u9LLa62Jh+Ck5ZEFF4ws5v+agBV8VAKmuUZypKxYq7ddhqQ6ttixH7yBaLPw3lbt7A1rZq5nagrwAheurndL+Qm1tRBGC7SjW6V5n4idEICoi4Az+7ffxESdjQSv1NNbxEgKhIng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5310.namprd13.prod.outlook.com (2603:10b6:806:209::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 15:47:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 15:47:33 +0000
Date:   Thu, 9 Mar 2023 16:47:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV
 bit
Message-ID: <ZAn/jWfoR5jmiQnY@corigine.com>
References: <20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com>
X-ClientProxiedBy: AM3PR05CA0097.eurprd05.prod.outlook.com
 (2603:10a6:207:1::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5310:EE_
X-MS-Office365-Filtering-Correlation-Id: 659ab332-5977-477a-17d9-08db20b598c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2BNAORsHhYYrIFiJkPpMQIjFjJposPPnHTV1NTRKwvIqZAeHDBL95T/a4n5OBD0YDsD9tWiHf/F3pSG3vI7qABHn2kcrH+wO1ZPKiDfZHprk70J1hgURPwcbIpf/7l9CXoljO3pBv1+wOy4ElWDTiqDu+H5cLeJeBpA1QdO9PBv5HiVO0/9FCILw4n+l8ItUNWh90f/fN8ywCPUbUaC+Ob/AROTcIhmIx9tylsBTYwqt8ZIbZF29BkgXjMMUKQVF4gT9elGhJYnqRyc0NismbQh2SNSP8VfVrq17XMbUPVMfClmQBmNqU+TbnLTqEFuLIBvtG3Qxo/JNjleQgl3vDT7GG8RqQUd5GoNiUrGzq+71p/NIpPk2syWRiWv7zGQbRtHGsTHnj3RNPNO1z7WJbeHhz6xEkzTEp/wT4PNfx/OKB97sYPnLNk8qdOB5oAC/XVk0kL9G20hDvA7yXBAVL8yIlH2iRMqG71Um+6/cI1HivZq5Qjt5G7NbprorvYHKpGumEbCf/lcFOwXYI7NGl5YTax8LOH4WFCk+fnGj/KRSBxyjJS8h/OLXnFjeo17LW8qxTAu19uj0hQlROGCAtrgQOpwnOaFZoejvFJNZsPyDPoE+Cgim5X3gP5B7KPwMs5wLDZia3p0n0AV6MBNng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39840400004)(366004)(451199018)(2906002)(6486002)(44832011)(8936002)(36756003)(4744005)(478600001)(5660300002)(7416002)(2616005)(66476007)(6512007)(186003)(8676002)(66946007)(4326008)(6916009)(66556008)(316002)(38100700002)(83380400001)(41300700001)(6666004)(6506007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0s4c+nyMuRCKXAe8hhDM6HKigRV3OopkLWwZUQZtr2/jE3k3wmuMFunHSbpv?=
 =?us-ascii?Q?MM5Whg8M0WC2UqN+LkDH4VmDu04aKl0XlhfLjlBi1cDXe0MZTPSQp+hupVLS?=
 =?us-ascii?Q?D4lvjnh7juqGCEORyhriBzBRz+YoyKJVan9Ib0T+iBwPntjeX7VrztgAyWUW?=
 =?us-ascii?Q?Dl3W/q9SQ33qTRSM9vKPEIcdwL4a03fkY+/EhYJ4/KPrukjurOGh5V5/gEor?=
 =?us-ascii?Q?Tl7vJCSVdfmwvp+r0/gHy1mw6wnWVuzX3LoPuvwkVJJwkRYAcaqnUi9cDSmk?=
 =?us-ascii?Q?Lc1wm0B4+uYknELBKJG5bhzOA99mqbdAPb7f2VIUKVrZum5aWH57mmHwwQHj?=
 =?us-ascii?Q?/dz2iodigZfhVPv9v9O1htElgHc9hG+EMlLb3CMAAgNZUPxCdGNwwsj2RZ3S?=
 =?us-ascii?Q?XqoUYwZrkdmrsVjrGp+uTu3yw4MdVhfxErz3rQ97+eonYiZrCSXj59hcOmKm?=
 =?us-ascii?Q?Sc8CLjQve8GK5l6RtSsNoNb+O9P3SbwctLExh6KbYrpvxzH1qCiqm5UwwmBL?=
 =?us-ascii?Q?AqH7kxDseuOsCbwfQqYoCK8MFVip57AqCwI0/MeJlyqCgbbAfqlFjuL/lle9?=
 =?us-ascii?Q?UntZrG5lErd9tzb6eRKzvrrYwy4dJJyJJxCD/d1rQNMiCUMTG+hkPWhgCF0K?=
 =?us-ascii?Q?7Y0Hb7hUGkHE9T2wzbluvfbuF0re837SaRHiikKUdoioFGYgZo+IDIsGxuFm?=
 =?us-ascii?Q?CRqqJSgOeAw1ZzzvBiQT+eDk3w03yqulEoqyESZEPgZasG6SyfM2srzif1nl?=
 =?us-ascii?Q?tZm+/nD2OBqhxJC5tpNEH2oHx7xqVeqYGd+Xb9sCSMFxVYXx9txUOpyr8Jey?=
 =?us-ascii?Q?xlDNdcXNPMqafWU+Nlqs3rwr7J/i5kEO+giIoanBfcip6Kt6vj3gvrnYQF4y?=
 =?us-ascii?Q?yTk0ieWeJ9cSiOKmYwHuG7j6UeHdAD/fuFgXTGRTYVpCy329o0qrwuj43qSJ?=
 =?us-ascii?Q?46tyhT8oZZ6NruoZfKoD+4l8eg1tzxL9LGS/dm0eEHgYCvTIf9juetz6OT1B?=
 =?us-ascii?Q?VLacXdjDUjHjzaLHdr3NsdbANRuCPdAj7nqVy1kdvmFo8+Rzhmn7RgA9XAXP?=
 =?us-ascii?Q?Yte2e7LeNzYHp/sp6HHwL6BwqY47XwN/V0d5IWvmGLvTWABTk5vHqElVIT5D?=
 =?us-ascii?Q?hwaeWFXsBf0tWZmnm/fq+Urx8MBciX69tya072ikOnn82ZCcBR7HkoH0af/6?=
 =?us-ascii?Q?pDOS4+oiW8yO9juF1wiqhQCc2mMEG162fRRRvLvNigNHRUy3DsWNj3RZQiuW?=
 =?us-ascii?Q?Eb4kn3JGg9KFfeKU28MW38JvikeP1tDymRnlCTnojTKKw4g0xA5EV6SIPurk?=
 =?us-ascii?Q?PIjgPT4YEk/tAW3Tg0bnHozF7yJkw5Ngu+GvYR/PBNx+HKpI3jYLPC6MGdBy?=
 =?us-ascii?Q?wcb1t9QsOqd6p5RXup5kwcq9cgtGzXib4vYUX/uMNTNChzHb86xtkD/lVdWz?=
 =?us-ascii?Q?SVv1nnXGdcf3fo0/GXNc+ro2/LulvWZaQqkxtVjzLXOfmktLQ3VaKfCzF3Zb?=
 =?us-ascii?Q?PtQTMue7mGZEqHx5QlJ88dIYmyd/P2nyB2dZh1iilwunwrTTVXAWo5+iQLv/?=
 =?us-ascii?Q?32XgZIS42pySAmi+pjJJa15zNmpEQ67EvQ2dBCLD3Sb8TA/VX+DYpKAYnFzM?=
 =?us-ascii?Q?FCKFyVYyCeFac9ik8DyTDFdqExrmkCZM3SzshkeDl7Goqi1p7F1E4HSwt7WO?=
 =?us-ascii?Q?/VoptA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 659ab332-5977-477a-17d9-08db20b598c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:47:32.9961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NWLVzMQ65NvE8E3O2JOrxqyqJHGvlHrn1afBw4oY9fJvOmEygOKh4dipkHmJi9VnPCVrOUvWsVunZdB2EppjmitZR7aT6F7LXJfFS3B7r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5310
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 12:01:11PM +0200, Radu Pirea (OSS) wrote:
> According to the TJA1103 user manual, the bit for the reversed role in MII
> or RMII modes is bit 4.
> 
> Cc: <stable@vger.kernel.org> # 5.15+

I think this should include:

Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")

> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 047c581457e3..5813b07242ce 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -79,7 +79,7 @@
>  #define SGMII_ABILITY			BIT(0)
>  
>  #define VEND1_MII_BASIC_CONFIG		0xAFC6
> -#define MII_BASIC_CONFIG_REV		BIT(8)
> +#define MII_BASIC_CONFIG_REV		BIT(4)
>  #define MII_BASIC_CONFIG_SGMII		0x9
>  #define MII_BASIC_CONFIG_RGMII		0x7
>  #define MII_BASIC_CONFIG_RMII		0x5
> -- 
> 2.34.1
> 
