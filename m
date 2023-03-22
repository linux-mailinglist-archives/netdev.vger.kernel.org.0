Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313666C58AA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCVVTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVVTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:19:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBB34ED2;
        Wed, 22 Mar 2023 14:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFlZo8pTQeLYauC6g6EzWN8wrw4+eBUSEKnIx/NizjxIx4YxKe6yGykdFTyW8XubDHN7qUFtDFHLQR58POjucVYzJJLFIpvFtk9ZIT/4OGZS/zlepsxaAkHD5yRMZ6bKA7Oq1+uYunHWRNslUn+TFkHRNKKKD+ixL19bLWXofNkDr0jNuNePj7sUIi3K7lWWx8Vql/3ADey3EPtHDTG3aMDJTIT4Sdp2QyeKtof9sTYJiSpt4UmaBlXAWLoI5wrs6IJitZQN5sLfHP9RxAkX2hDQyb3I9g/MZRmjD2W/3w05JSRnuHY0fO3e3X0CVMew8zr0bPHJR+1KTZKcdUul1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSdFiv8oL04Gz6cXjGhxxv/4iVFCTgT1SCQ+EHaC2Mc=;
 b=b1KQC+t3j+eEPJHrijYUYjKow43DWlN4SKUylkk0s+TkA29v7QAAjSKkBlZXbEodo5i3iVYhlV7Pe7/BCVuGmI/YAD8LL/co4S0vbBpWfXMyllFerNaEV5+1ifT6Cey8Wyd6Q3+b+XTS6X1pZZmpiy2dB7U4L2qhxB7fnV9SrHmBDvRFAjBCEYJj/w/GI3rd9VInwnH5sMjT9TjTizcmpmRHuje91TnUomVh87Mv4qdGeEfqjkxUMume1pNNheoN2WqiJlfD68B2RbA6OtYd+fY5w2qHWz/qniA8fR1xJbJZFDbqxAYEQsVZdyIZKOu3CTvZbOJlC4ITc2cj854MLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSdFiv8oL04Gz6cXjGhxxv/4iVFCTgT1SCQ+EHaC2Mc=;
 b=SiKkPKAVLt2eW1MbSpdBt+RhEASXFkgav//Qbbe3eY7/ENKgime37CPT9KgZe+UcDXKi+oKXFtCUAs+qvCV4vFoieF51E80GuNc1+8w2ODmKlEXDwalBr3icHbN/ZVcuCCdmhdGOZ3SFDjIdK7qpnmtcUIQcUQ1XIks0EC8HKcw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4822.namprd13.prod.outlook.com (2603:10b6:303:f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 21:18:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 21:18:15 +0000
Date:   Wed, 22 Mar 2023 22:18:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: add IPA v5.0 to ipa_version_string()
Message-ID: <ZBtwj8L6uj018iqy@corigine.com>
References: <20230322144742.2203947-1-elder@linaro.org>
 <ZBtrfLOh3EKBKW+F@corigine.com>
 <a0e5f9e3-403d-3334-9f7c-9d649d794a96@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0e5f9e3-403d-3334-9f7c-9d649d794a96@linaro.org>
X-ClientProxiedBy: AS4P192CA0004.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4822:EE_
X-MS-Office365-Filtering-Correlation-Id: 72468c8f-90ce-4dd6-762b-08db2b1af32d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DRdBgsC1ixjhzcLzkrKnNcGJANNgsdbrwSMs+rHohzxSfS9iil7D+JqLHKCXByPsuYmXpD/GnYXpiznvo+5ywadcVYyrX6swalzRZtrKPTJjm/EUfFCgDWS2hCwXuJLInmnIp3JNpSVS2A/OcQkdy46Rt/Gozwxy6egUpetDHsE/lmbHviXy+/WwXngJJ3Pgaw2sJYOBlu4yRwLE8YOJcOHxTI/cTkRuKo6XTSC52hf/plikFS3cEtTkOU2AcubhbVchDoA21YYrXOWjsPaqd27bmS1W23bpKWXzwX5q6kdq58ztmRG0bIM/7kJayaqnp9ANLsMKi0iH5CBDTG2h+1cB0DM3i9NliOi3+Hx5ge/eJOUkhI6QZ6tMTlqlsuM8Ih7gSPCDG2pDxdGmQ3AljmDP16ocoUe16BpzHGHiIhlGSbF5EDIYAIfWHCLEgx+ER8GDAdSYAj1pTFlNePaOXApgNwtgCOexJeAr8ffrSzFxYKFfDPnl47tPh9Z+ghUSUITDnkWBWjMvVbM5CyQdo38wpl8uhKmfiQgTszz644vtsCgYo6EEHFyrFEVDtDYaLMP0TGw5j7VJWM+Y3HWlawwV6DnmkAdN5JloYwQzrpPTTIbH7fIrebbRx6edBhelE6dNfJLFbHu1i4rl0W0qQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(376002)(366004)(396003)(346002)(451199018)(7416002)(5660300002)(8936002)(44832011)(4744005)(41300700001)(36756003)(86362001)(38100700002)(2906002)(4326008)(6486002)(6666004)(478600001)(2616005)(186003)(6506007)(6512007)(53546011)(66476007)(316002)(8676002)(66946007)(6916009)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QR/hufg31rVUs1wjYeT8h/feoy+pcUczRTYmmHlYHwdJmAREEFfOA/NYVEZV?=
 =?us-ascii?Q?pyjiGnw50eMX28HwDZJgjM+SBYYuQHvFP2/kgpXi+LrTAsNhJFigx6Z7Rv95?=
 =?us-ascii?Q?vBuXK9M8R6JR8E01Q1N6auX62paDBzFOm4AKs9yYGyXdOG/ABWdhSDIgQOrX?=
 =?us-ascii?Q?nzWqYDEVH/5mjpGn+4Bk/ZCDjOcdBHxsieQzF6630ecnLnUv9Ktm4NBKifEd?=
 =?us-ascii?Q?p+PiCbL/qtcao2Ik0Yzb7SsnI0Coz5F78D54EJ6KgCmgbtDC1GoNlvST4SZY?=
 =?us-ascii?Q?spsSYxSY+e305tF5vunf6oP/QOOWSHs4DLAf6jVayUSEYXVknxd3Ipdjp9ac?=
 =?us-ascii?Q?cQ3WpuyhNSIssesQL+HrDXinoZedFXC1wmnEHH1/3pjKLEUGTRMHvylUMu7U?=
 =?us-ascii?Q?Bl5wwmrjJtpMoL6mWRt+L9Z7wvAYkBmfcuNbqBy0hZ3xfsRyei8otgtFJ92T?=
 =?us-ascii?Q?sX1CmGKATgg++FFCVzBGmx91Z/o3xUW0+Bn2QZabg7S4+/i/VeTikatkMzMP?=
 =?us-ascii?Q?LO6/DnLctVHCMXJswt/GQdLJ5zDJU+OxdCm9FH5Yo0jtQAXFFuHgnA7boVw2?=
 =?us-ascii?Q?HxIWQ+PeHY/Xw+LiKgOmAQa9UVZUc1wY4bElEm0OaS6oNOCfb/wk+vsIlOls?=
 =?us-ascii?Q?wdNnCfphgxwlY3/D9fjO4PT8wh0nj0mjoQoBbScWj738cG5sVpmcdgmBjL4J?=
 =?us-ascii?Q?XpC1GgCil3HdjI9nJB/7Q4+eDakIs8+9OVgMcDvD1uDub9J3J1Xq+IKHTiVN?=
 =?us-ascii?Q?Hw92+8egtAxjfSunBI4WFb/ESUql27RJ8ZRoHRuvNJe8AFwSjjSfbFWERcFj?=
 =?us-ascii?Q?WjAlPrBbGTaRhcsjfHULVfF0Azq/96+qaXazqVh4+VejQ8W7jjdolm58a3BE?=
 =?us-ascii?Q?gZRfUphZvNTji0LJ7BJ5lrSWxMPauJ3Gcp4QNGc0tx6fazwFtAVfEtZf/iJW?=
 =?us-ascii?Q?XFZGJJkPXJlnCrXbibF7nWJbs9N/xAIGxvsYNkl8FX5vhKA/SkuVVxnIAF/9?=
 =?us-ascii?Q?1q6CzuMSCT+rC1g2tKZo09evon4Ky8SCHwkKdLz41Qv30y/+70gs16YBE3gD?=
 =?us-ascii?Q?Xl0g6mXOLTyoGLYn33QXMzJTT8CnuqxPjHqnjhCcUvOzyguAwAk+YmCVpGzu?=
 =?us-ascii?Q?/F6PEYrwTKwUa1mL3EU/c4jmp9oy+9/BEAxhVAeYDQ6UUhZcSEZcktobeiwp?=
 =?us-ascii?Q?Z8gKQ+B1P/8yZ3lZFEcux6Z6lMahZNFr93MJ0ehY52n3LE2iXoiJKN9zhSqZ?=
 =?us-ascii?Q?+EfSADDGPdY/5/IObaW0Vo4hRlZiAWdwjc2fLaTC2yJfUi3jztuQdnbn+8Xv?=
 =?us-ascii?Q?8AMYJsmss1fdjBtntX+4TesDzOFgFrQ/jwIqcQI0FEjSksmV+mkmJa/qSOPM?=
 =?us-ascii?Q?zQH3lECX4fGdyzy2dOG7RNEtJz84DTZocMchxMdgkIXOFQMeI0cVLEvO/zZX?=
 =?us-ascii?Q?fzykKC2E1sWo+5XLHoJFLBiXc8+Y5DpcbInaS1uDR+R2Pf3HcB5PIZv/QQ2o?=
 =?us-ascii?Q?wM6Y5QrsE0XtKy7GFTa4AaHrkgTFMBP9wvLF8pE6NwK1/wlWV0bs8Jh+l9nu?=
 =?us-ascii?Q?A4Zo/BXdRhsaOnIPwhAnGx4X5JTu6Rz1K4KiwE2xI419TWvuhogrJClOC74d?=
 =?us-ascii?Q?KlwiEynVG2AzALWSmbdKhvoUKhOo+0/IH5mJ21/cnpd7U4hGiS/5IG1lc638?=
 =?us-ascii?Q?seT8AQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72468c8f-90ce-4dd6-762b-08db2b1af32d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 21:18:15.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KiwYrv649n7V/5XGAmWmYMyzRxQT0KuEjnYSXnEswoaLP4z4txCgiQzN7+lPxBTpISZVF7tWc49nBQPr1BqYd6OUjNPE59Uoov19E3L9eI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4822
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:08:01PM -0500, Alex Elder wrote:
> On 3/22/23 3:56 PM, Simon Horman wrote:
> > Should IPA_VERSION_5_1 and IPA_VERSION_5_5 also be added?
> 
> They could, since their symbols are defined.
> 
> We expect to support both of those versions pretty
> soon, and we'll certainly add them to this function
> then.  For now, unless someone thinks it's important
> to add this now, I'd rather keep it this way.

Thanks for the clarification.

FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

