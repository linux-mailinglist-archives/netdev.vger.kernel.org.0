Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB0D6C9358
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjCZJSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjCZJST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:18:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2128.outbound.protection.outlook.com [40.107.237.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9067440EC
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 02:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZPn8m3alxVSBGR4awYsDv4Zw9oGS/up6voMuYscvsewTjKshtxhxcWyLfxgG/62bF/0PeLCYKGUU5Swe4/o0aJIcd6YEYxDez9NINWUCbPEQdrSOKNiJJA1it1mZpEolYzz+zOzt7R3Ur9/suZMy7RrGeq1nFK/0ynRnXFg6ZqmjiRWV21vczBqGOfj2W/mM48Y4VkyrahHDueM6B/nFwqGvLlZqrmZpBuircKYvy23339cDYjYSmu8fwn1NZmmLhn0rV52OAwAoDt4Q89wdPKVcQf2di15lb4G1Qg3P/YHVm2ExLsD6qQt3oHU+mmMSj0n3D+vx7PPTaS13cRUSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MVNrwefv0SXcL6tDE9jnIt3jwfLCvfVKxNmoCjCJ0c=;
 b=VhS5sQ9UL2o29+ZmpfTP+mMvTA+ONkrRRIU+m5a1tgVLEyhBiEr636l5lUcyAesVAQaquQMabLm9jUMB/zMqzONn6k6pbJfQT/tDmCVZW2/6g+gyoGaPl/mptYkiGLK8iM5bDxOEyktQgTPfB3/ugGjpBr3DtmcGYPjJ4CLPZEHcvelV8XdMTow40r19Nwga9dWgyHXUcqZq+IT6+3KFTBcegBdIBHNlAjuQ9Q/Zepqx6PJmpSLN1PIkJlkJ5kUl+YW2TUO22Fm0yDJV0+d6I7y/RbIElCHXweoLvSiy+s/UOpHBxMfaXog0pBT/FmZlyiUFtBcce/CcTR45J3NsaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MVNrwefv0SXcL6tDE9jnIt3jwfLCvfVKxNmoCjCJ0c=;
 b=XM/uRUz4BfMXo57babXRij2gpuaZcSfRyBoG8LIVhsIJs65dczMSYRd231FZbPcQ8+DMWxjrKgOhpb1FUpIV0mXENlhgKtyggWWkf9iR88F7yn6a/XXPxsb8l8hYIwDRLIYlwOKouX0joIQFY4qli4MP0y+rQWRm2S/zgywEPtw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6284.namprd13.prod.outlook.com (2603:10b6:806:303::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:18:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:18:15 +0000
Date:   Sun, 26 Mar 2023 11:18:08 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 5/6] sfc: add code to register and unregister
 encap matches
Message-ID: <ZCAN0Cgnpjak7zjF@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM9P193CA0027.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb9fd28-20a5-47aa-548f-08db2ddb076b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMHHrBpSuiRbH0KAnX1QBy1GHlCUhJUcFqCWOzULE8R+7PM+J55j/FnED8+4hd66IR0tKZTmzefm0Kt/jOFLdntxD+oVd4MNT1oJZW3d/WGCD9bJpajt1Sy4XH+rM3oLm21KfeRNg3+zvc6nzI8EmtujBKFYwbIdRo6h70IkSO3n26kOOkj3+YoAFfyjIKjnSOJU+Y+kabBZ03s8glF7SjVuf7ooQu/UtFIp+AESkXs2PRYhQcmP94bF7IuT84EPZ8PuQ/ZquV9M87kmkA/y27LLk/zgT0qj5oGyfk8MUE9Ko72CX91ADDIiIbqhCU7dXxxs9CxcTGAyY4jhEhgakZaig1iTnfsHnRdIUoQyKcpWhklL14Bvih4OThZa4rig5uo7TKga358ItODiJxlzp9Z+rdTcf//Aej769gmu51D0BqYRkPyM16dp4x91QqURSv8VIOntE+Nl8npRFJnTS/nyZ+/UtX2jswS8XRomZdKRpBZSa+qsAKrIf23PhGaQ5XhumiCm1ZD9xJMwU08wx5tmDxe/tFJYru/EUIxHY4hNHcvkGtT6pOU+ACwCm+2Oe+I8KvRJ0MtWNdZepcwd2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39830400003)(346002)(376002)(451199021)(36756003)(478600001)(316002)(41300700001)(186003)(6916009)(4326008)(8676002)(66946007)(66476007)(66556008)(7416002)(8936002)(5660300002)(4744005)(38100700002)(6512007)(44832011)(6506007)(83380400001)(2906002)(86362001)(2616005)(6666004)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ppmehBDPfq4iwwwMSpbgHg/KCDax3oS2rncScPNv2WbjGpnzmPDaLZaP/mj?=
 =?us-ascii?Q?/JblEyv8+YogiGJiw+vB+rOynjtYoG7T5NlkWxnYCa0PTfApfFVJaVFe1MVr?=
 =?us-ascii?Q?qKjNi571Nvwc3obN3kXZ8I1lKmv77tL6+z20C5QzL1O+cYgKLj7a5I+bNbhq?=
 =?us-ascii?Q?HdF4UjVBhzAFgh+gtIid9ktN/kx/TzPCk/JDk2vrrTm4yNXflG8KXYPBDH6F?=
 =?us-ascii?Q?Mwf5v/GQN3KIEfPnvn5BcDJhdHq3M0s97+psbeKc646C8wbsUykPTrEFb7r2?=
 =?us-ascii?Q?M4bp4+Z9F/LdCU/ChTZnibKayWaNO9HvnUqk8mUYQj5lid4nR9i/976vIgGy?=
 =?us-ascii?Q?/U0gtAxqti/9+3WYr0ipoFac4vXJtGSD29FZaNRHfuT60EtBduNHZ+nX8Mo8?=
 =?us-ascii?Q?qVP7MdQ/rw9q1Z2Wf92WpihWtVwleeg85EPqg+RNjjZTXLWpE2xYD5v4qT77?=
 =?us-ascii?Q?efYRcjTWBF1/nCUDDFdhXu7EToqvqqGHuFE4lbUPtPdyg6DS9b2kdxnRGfRz?=
 =?us-ascii?Q?HMwdMFYsx3JXTcT7UMl3N0nF70C+pZVLn/QG6b3a+193sAdBh4Srxpfw8nV/?=
 =?us-ascii?Q?1jySPyzv7SqvSPpXZnYZ4LaFogZ+3jlA6q1qEVYBuC9pmzTCOfgPRPfy/S6L?=
 =?us-ascii?Q?OwI+ch0/DgLRU9DbwB6TSzbHoMkwYbmM1bdvsWxixnXn5X/O1Wq/X9MuyvpU?=
 =?us-ascii?Q?5WjKwAzXIU7bxb2Q30/h6kYZh7g2j6hq8ZudNWaHyGO5JOnENuDv1xOderGs?=
 =?us-ascii?Q?jrdJOPvwbzOASVd1GsLsOU17XqFql+ZoPdNUHuoAxzETCh4wJT9Wn17/UaEr?=
 =?us-ascii?Q?/X3pT9c5LgC8TD5fWqTWXxH5Watz4asJTuLGe8KsksHEzt217I2bHcRvwkm7?=
 =?us-ascii?Q?As0PxCH5VMwXMAsKTssQFTCwkDeICqoHkZv1K0csdD5bKaA5Io2/KveAnBc4?=
 =?us-ascii?Q?IYetHbJ5tS5ypSgoXMizh98gh6R0zFSugFotTP9Mi3woa3F5NfrMsSvFsIh7?=
 =?us-ascii?Q?yYnuu49XAf2a0tLtsMXdi9pFlS3OBVJTs6/SBnLatYU5EbtncP839bZy8Bl2?=
 =?us-ascii?Q?xGc93zM+IQHwVlxd69iKFHfOhYt7+DkHb6RMDos7Qkg8v1QPFTFCki0VgqMy?=
 =?us-ascii?Q?+t/kFHzN/fMBrSb//P2D1yjBgbgXNSE1pQ9GXwoniGtN2eP8jO5HDvfuNE57?=
 =?us-ascii?Q?rUHEHgkDYE2ZtsY6suKwtVs3WX4GHQLWC5y9qd4Ms7WxEJFaSLN5yPkNfU5I?=
 =?us-ascii?Q?C1hyhOrlWW/9D4mGx0Mlg/3CfvvFnCsJre0flfBavtg6/cxz440P6LGSu+kV?=
 =?us-ascii?Q?B9U2Zq2eIts2pPaI3hFNtd7gfWnuqfV7i7UtZqNC2WKG9TYV4+BjLw4EoTxD?=
 =?us-ascii?Q?H6CEtM2XsyNVOegYmbbnqBTeLebguG371XYRi7lr5wnjm4s0SBFI2G+Le/I1?=
 =?us-ascii?Q?23r121c1jentwezG42rHhweXLjZpjpe7GWjKyxZMytR88zIiOkT6Tir2WEEe?=
 =?us-ascii?Q?KD1ROTPF5f1Azd6bkT5/eD0auWR8r6rJVHQcBxvAcxitKuDZr/ZzJqNX6YeK?=
 =?us-ascii?Q?IhABYeDXa86FQEOY4EM0ZTRobfHuu1RZSQANFLhhc4ntSmVKs7gl2YzNc7jm?=
 =?us-ascii?Q?cLZe1AxcQxFO8WYF4+2/Fa9uuW0IPOATrZMb0DJFCaqtRI5ERoSyrwrrYo5f?=
 =?us-ascii?Q?rCrtHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb9fd28-20a5-47aa-548f-08db2ddb076b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:18:15.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fURzFK09ro/6hCBaE1Uw2ije2WIFD8a9ra95GKlBXUozn0OF80B1u+7yM3Lz8w+/ififq/npPz8ZOSkPvhHiFzRodXuL08L98NDjOjHoANA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6284
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:45:13PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Add a hashtable to detect duplicate and conflicting matches.  If match
>  is not a duplicate, call MAE functions to add/remove it from OR table.
> Calling code not added yet, so mark the new functions as unused.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v2: replace `unsigned char ipv` with `bool ipv6`, simplifying
>  code (suggested by Michal)

Many bits have been spilt on a minor problem around initialising 'ipv6 [1][2].
But that aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

[1] https://lore.kernel.org/all/20230323220530.0d979b62@kernel.org/
[2] https://lore.kernel.org/all/202303250154.HsaEs3hh-lkp@intel.com/
