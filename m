Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BBD677091
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjAVQ3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjAVQ3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:29:44 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2129.outbound.protection.outlook.com [40.107.96.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1978915CBF
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 08:29:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpEfbJ4DSqj7SbSeN/6e61+7BNjcfnti1kHupfKR3MWHlES4emNVrFBlCJvMaQxAUEM2ednwAcRO8AhKnQweK0n+XvzdP/AJ1y/6y4b7lefU+YmHSQDPF7tFrd9fDjelBUSYGp27FfwCBLUl42mtOSfl9LBhM6h5H98FCPt9qw3Gsjl4TnY7dyeeId3pCmvFy7DGLvXfwzRnmmNo7t56dOaXU4aOnOKOrkUre2wc2h6Z/zqUnlwrf9HkNx1f0Fjx7In4UwOThvrBLN3Mj9FMVGf/ZFpJ2YeJOl9naPDdb2XEaHPL3ydgqx/I1Whlxaqi1FocoAl3UIMIGAWoRg3Vug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgL7zbNTTyfS9SJhDQgzsoLTfi/65oerFPalkeKyXpY=;
 b=eD/TXR4M9L6ZeZFfAToLHr0hOH8myhrIMBIy8+QQYEfLNIgit8e2/qhij111PpKz5bNC1s/6UGmkODh1JWhKr68cSIOjsqLunpPXll1kogOSUybnkqZlzwggTAkOl65XKtgKURiRSevv/PvFJHggwNYfdE0ohXmnygHOz9RC/P333UOAGFgOMeppbv6edD3kNPNIArOVRNCAlETn1DNhANe8Qc68wBjtEODfNAcHwYuXgOclkDi8Cmzwbo2Mr0HEr+gxCB94LS/maZQo2DY2ngpGrlOUDFbd++5WmadAauxeqBEkpN7Nvj84m9vNrEvegS+lbe3bZKAdVAaLBLb2bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgL7zbNTTyfS9SJhDQgzsoLTfi/65oerFPalkeKyXpY=;
 b=p7grZ49Ga4mkWIdCz8mT3cmAXu0LZFuIL8rJ1hV3nDUyLSq9nGZKtRnzIWG2rTrFm3jUHgQhJ++OtLi9InBIsylCv/RYFklueKfble3k/kzlAFNLpuaj/NgjKM779ExZabD/4c2OqcN8Uuhltkb7uYyUhcHRs8TMXZHE6XG3JSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4095.namprd13.prod.outlook.com (2603:10b6:806:98::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 16:29:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Sun, 22 Jan 2023
 16:29:40 +0000
Date:   Sun, 22 Jan 2023 17:29:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net-next 3/6] net: enetc: add definition for offset
 between eMAC and pMAC regs
Message-ID: <Y81kbbO+X21uVFMb@corigine.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
 <20230119160431.295833-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119160431.295833-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4095:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c93b770-5569-42be-018a-08dafc95dc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5d8QrEWGTMj0TG0Kwl1ze7EXEco/IvAZa7VRBNvkSU7OHjWfnHJNMxvWtuIRa1ejBlJCKdw37IOZasnhki3s5ad5rNIQTsaiL8uaBVsgyNasLa7Ohh14MPZp/FDzLn+ZEORjbayS1xws0sV6LowOdpo8MCQSpkgI/147PNHwbJe+y0TX+33wtyjBGRf6PS49GS7jVW1YX41cWa/gEJ6NavzG6EJnc9m0edo4wAz8da3FjPPxwBqYp54PqcgnYFBZODrF2khUgowIZ8aTE9hUcQbEOpmS/OKk7cypsTnCMiKxlnZP21TR1KCaJnek9BbeqnhqpvXuJtR+3dlRVDKhfKNC4Ps5SWo02uzOohGo3/46zSbEkQALld8+I74mBLchSl3Ztm//HByfzPNVgn5EKNHAdH4pTZjo7zIIHfiOWDSF3zO1yJ1FMZGeHkZwtn+mGZ3a3G16IYBwke6fi7qQW9L4hxjswTrdmPCWq+F5Nra/x4I/wH3n1VBkZcmy4+Vsr/bUHzpYmu2erogWIfi2LV7f4qki+hfEsilqbDakoV3hcv1hx8IEbRxpln0QYxc1cQ6iObQxIGIcSrG2zWTBHR9bHIzqkzjOVfU90zoEWS8hP3Fhm6xBOim3FoBBURIzOlLczq7U3rSmM2khWbB6u7JR1Ea/9mykmasXDSbVNWORmHx+01jjbag/m2ePs/DoqhOTN4HWB7iBvuhjZTYcxci5aUD5JZB76Epcwk00+w0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(39830400003)(136003)(396003)(451199015)(36756003)(86362001)(66476007)(6916009)(4326008)(44832011)(66946007)(66556008)(8676002)(5660300002)(2906002)(8936002)(38100700002)(316002)(478600001)(6666004)(54906003)(6486002)(41300700001)(83380400001)(186003)(6512007)(6506007)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2oSV6vEfby5P7jRGbsm5Kh7t/2Db4Ansj29CE64KVHitmvIO0V+aOKp9ZjY8?=
 =?us-ascii?Q?95QJLB3BHHO2UM9JuSEjEoRUn5kpV+tfkZm9QgfU+IlkArjjLEh/mnp/quTL?=
 =?us-ascii?Q?CBRJqDipbMnXBsQ3zN3+ziQzKF/zaxHrrD6Y+0feA4jMI4O7LvAWSfeQvCpU?=
 =?us-ascii?Q?TNDhqtixWqX2/3hCQcbP/NIIdUV3to84UZWW0660Yz2m8h7jkxkqB2FpJ1Ow?=
 =?us-ascii?Q?NkH1ZeBu+dzRBBz+sxAO93XiDsnyMEmdEWF1St5mRL0YrAGcjQn+S+GO7o00?=
 =?us-ascii?Q?hh48Q1tMCKjTBw4gUAGTB5vVWJmdAZA8WpP4AvvkDJa+IG/7JYNmIMTzL2zc?=
 =?us-ascii?Q?IIQLYgRHHPBT73lgWTrbk8CJszOnLoJ2qh9KADuns6D+lhAkx77IQSClwr//?=
 =?us-ascii?Q?WFz28smuYzxZ13pTrAy4lPVPbfLGx8d1TrozyyMEhDYUOYGICy6WFWYmU5C+?=
 =?us-ascii?Q?pFGzus29ZDLpPgcZpYu1AGUNNANvze+lGpiAHYXrfWITCCbLrA2tP/tCi5ng?=
 =?us-ascii?Q?CUPa2loDdqhBRgmavydIErgTzmHOaDQetVcXPx6eQl3NEyRopPJzZHYQNYzU?=
 =?us-ascii?Q?zQmistXi0fFU7+gQ6Zv8Nu0oyimaTv44uIb/Yu3++CCq6fgtXCyqL0Q5WzKc?=
 =?us-ascii?Q?EVv1iwgoJVCR+CEmfNgei7ke3t75dxhgbZJqf1wvU0ikE9L0Kv1jok5nrLJD?=
 =?us-ascii?Q?yMTMn+ze+hcwvRsGUu3Z2ZLNV/4phurJpyOZgvGdFPfJyS+rNoBibaBZkf3/?=
 =?us-ascii?Q?GdeEK4U8xK8b1rGXXVbWhpfOkH7GDZIGyTK7VDF46N+11B6ICzt249wFS3+w?=
 =?us-ascii?Q?Ze+EZq8VmigxCLNho+u18ehOsS7cRUv0Qb0tiZ++USdIv4PLLy+MFkbacD+y?=
 =?us-ascii?Q?+xw/D5JommjNgo6q05W2L04NVm6s8WYFPnUuN5nzW8naZtJsMo7T2sLkwVWX?=
 =?us-ascii?Q?146pHnJrhJUIXgiHTlzZ1bO0PGYrunrPQDIP9mZ7rSlkKzzRmxjEH6y4vEQy?=
 =?us-ascii?Q?uo7R7nkhN44ijEr4Dvp72kMbO1uoxRX5mCQLqWa8TDgaHwAeC+uzgJCv2Dnt?=
 =?us-ascii?Q?Z44uNuBtT+qUVW0aO7JVRUNDimZijzGLu1lXGnLY5EYgocYR3JLAdeR/d005?=
 =?us-ascii?Q?h3eFKxCi03LVpS+SzZlX4K9mFEscw0v/2Y1FXbmwdB97JVsgb7Uots9x/AzH?=
 =?us-ascii?Q?UCBCOMWuknx3oI0O+jhHmkHZcqTop5xH7aLUKHZvGASSEP4+L65K3GqZX3sg?=
 =?us-ascii?Q?xSCQR0HUhvTFR3ZIxaAP+m5hLR+/ZYESTKgFPf/EmEdzXpfi1IUZff0p8aHf?=
 =?us-ascii?Q?sZY9tdW3nxgSUzSir0UU4uddIrCZXXCYUioc3+Cdkr1ZAPyXHsJjBWF6+cUo?=
 =?us-ascii?Q?y51rFG2z3iWOwlHxCoXCjzfcbRNiX/jtxMqwc9lTrhyZbX584OMCMNiAk15c?=
 =?us-ascii?Q?FtBzhLRq1UWJJgZr59vx9ObrRj2X4Ax/lqeOaYOlAN0+76ZNHvj3zVM6M6n+?=
 =?us-ascii?Q?ioy67HSAFicYuiCJkY8/FL/5cLUezrhfT2eqE/I1p4u8tYlGEcTnpqGGfdDv?=
 =?us-ascii?Q?wyuNYYPccnja4l1nwpuTZkml3jHSSulVLEy+IA1CpDf+rxPSPrSADaC6JQLL?=
 =?us-ascii?Q?cNq11y3SjZjFb92hIjI2OLSyfnun07dm0YFmMXVkBpXgAuVso1AbQe1+XAN8?=
 =?us-ascii?Q?VXbD8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c93b770-5569-42be-018a-08dafc95dc02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 16:29:40.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tka2dZijnobwdDQ9A0ek8vQMyfE7o9v3UsBMCHz7cPRvsMl6z5N9F0v/qBQnwayyPp8hVYtZoilXE8PbdXSpXS+B/oK1gM1+lxaBYmgEY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4095
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 06:04:28PM +0200, Vladimir Oltean wrote:
> This is a preliminary patch which replaces the hardcoded 0x1000 present
> in other PM1 (port MAC 1, aka pMAC) register definitions, which is an
> offset to the PM0 (port MAC 0, aka eMAC) equivalent register.
> This definition will be used in more places by future code.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../net/ethernet/freescale/enetc/enetc_hw.h   | 104 +++++++++---------
>  1 file changed, 53 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> index cc8f1afdc3bc..5c88b3f2a095 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -226,6 +226,8 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_MMCSR_ME		BIT(16)
>  #define ENETC_PTCMSDUR(n)	(0x2020 + (n) * 4) /* n = TC index [0..7] */
>  
> +#define ENETC_PMAC_OFFSET	0x1000
> +
>  #define ENETC_PM0_CMD_CFG	0x8008
>  #define ENETC_PM1_CMD_CFG	0x9008
>  #define ENETC_PM0_TX_EN		BIT(0)
> @@ -280,57 +282,57 @@ enum enetc_bdr_type {TX, RX};
>  /* Port MAC counters: Port MAC 0 corresponds to the eMAC and
>   * Port MAC 1 to the pMAC.
>   */
> -#define ENETC_PM_REOCT(mac)	(0x8100 + 0x1000 * (mac))
> -#define ENETC_PM_RALN(mac)	(0x8110 + 0x1000 * (mac))

...

> +#define ENETC_PM_REOCT(mac)	(0x8100 + ENETC_PMAC_OFFSET * (mac))
> +#define ENETC_PM_RALN(mac)	(0x8110 + ENETC_PMAC_OFFSET * (mac))

I'm not sure if it is an improvement, but did you consider something
like this? *completely untested*

#define ENETC_PM(mac, reg)	((reg) + ENETC_PMAC_OFFSET * (mac))
#define ENETC_PM_REOCT(mac)	ENETC_PM(mac, 0x8100)
#define ENETC_PM_RALN(mac)	ENETC_PM(mac, 0x8110)

...

Overall, the patchset looks good to me, FWIIW.
