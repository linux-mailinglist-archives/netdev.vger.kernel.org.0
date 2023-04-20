Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB196E976E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjDTOnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjDTOns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:43:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB206593;
        Thu, 20 Apr 2023 07:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBQ8qYe4TfW59F6o+GXVURs8Rsnjm5u42WxYKHd0+52Yq+dbDWltVL33tu/oF8V/184ESK3kv0bjBg+fgobSjDMHgSbPw/kevepmm0XfHruUGEnuM/DPlO9XZPZBCMyjDLlZIUCmwuWqoXCwpUi75ZvOyVwcwbJO1K9Ar/UJ2mxmC1sUStI363Oe+6aAFrxYjcL3a02+m9o6pm6ZBBLlYtb7TRZNv3aD1XE5Bsxirq/IOyZ20srzVQOVUcM6N8IdB8PvqKMjD0JCtX5tmaDJwaTWACHlhoVGmJS/jwPEiTUmgiaLTIkJcZPsS2uhf7+SzXioVtnnlLa0hj5HpXb97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qAEePaQbFLSJjb4flk/alWyerGXzlyhQ91+Hc/I6ek=;
 b=l85Wmi4GLXOkmWbA4i5Lb9wHsy1fYmaojHjc7jj603ZRTO6AkgQnwRuVpMWgLvEC/q9F6Wobg3jCbbd3EMPgvQ9O3ckdLTHs4XhC7WLKnTh7NjL/B3pTta4Hqnf3fuz/BHHgoLnkcBFFrXBA0Qm/5OQwZtPUaEMK5PUPm3oJ8jenZippzpryMyuKaCZ7tQZhw+JLj85Q4ZIIVqU1YIZUB4HnCY6VgSCAdMMGeB8rFrcPmfufwnFZ2iDNlzp7AX+S2oqAFfjAN+Q/GTZ97j2AX10aiDJv86XEQUTawlLyszO/uWHoPyBUvNAG99ZO/hSKyXq7+oX+Mc2mtxDobRUYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qAEePaQbFLSJjb4flk/alWyerGXzlyhQ91+Hc/I6ek=;
 b=D521pV89q/WXwrETf93hgQf1nQSCmoYtyBB8OiFvnAGg/KP/35ZqYXwevBKwsxN70VB3HZHFeq3lz6VwpygxczLlhgR0Dnd08G9hJQhAxVVVAD0W29wgGyd8+QAvIXPRkrQ67OPudPkyeAJoh5uWR5UwmFSHlK2SLFRwN/cIjyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4410.namprd13.prod.outlook.com (2603:10b6:610:64::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 14:43:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:43:29 +0000
Date:   Thu, 20 Apr 2023 16:43:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/9] net: ethtool: mm: sanitize some UAPI
 configurations
Message-ID: <ZEFPiMG8Rn5Mc3g5@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418111459.811553-6-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P189CA0032.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4410:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f37f702-bbf3-4dc4-35ce-08db41ad9acd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ah+lbZpUp/Eu7V6WD8v0T3LTh0CBRgFuh15xjOQLXRDVJRWU6UV8wmNfg/KgqEvtWdSbYEtR+3H/rL2d5oCuvlCeeXVhhk3cLSkw0ykYfFsQqJx/YDEDsTe7KE+xZlCy+kYS+cjarvo7LE5X1zcAGsazaIwfyTH7t+bF/I/EutNzk/85fLx8eqz6sPC9D22DCrRvRY0IkddqW0Bfl4xRkTqbpxTp3jul2wcwlS4+RnZQnxEt9teClx2st/gJ7J++ntKMFujHFhkp/rja+JLxaj/FaxuNXo2LsKQHzgU2vAv7gK8OEYPSoaGviQavibJHE/jCHFyR5Q9W4UOA20KkUawOLZKtFWPH90svS2sTFDWfKylukcPAmPoMVBTwYH2q+4RVY2ImfEIOt2/zRtEjzGJ8xhT/QVIm+cFr6lOK5bMljP9kCO2Cx8rRFRocJqqURj3JkTn0dOBeB661Zm2CJPQXCVA2l1W0BSnbFFrTOYvkni7QMLyywTe9F4paQUmlnq5ES4F3OVMNiTpQi9mz3vk/S/xQ5sB0adRw8CCxLgaHXiR6S6bGw2GqNj5nHR6T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39840400004)(451199021)(8676002)(86362001)(8936002)(44832011)(7416002)(5660300002)(83380400001)(38100700002)(186003)(66476007)(66556008)(6506007)(478600001)(6916009)(66946007)(4326008)(6512007)(54906003)(6486002)(2616005)(36756003)(6666004)(2906002)(4744005)(316002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52ZYbxd/fs9eyW3PUiT0wI9e9tSNpy8yEFo9Ngf1w6J9tWNYsYGd1HiARr7t?=
 =?us-ascii?Q?DtVOQJRp0ulfPkOPS22a0AbUt164+wDk7CwwFxpBz9zKipJP2FVKVFdkMnvT?=
 =?us-ascii?Q?r/o/C2N90HniAUohbr35wJIWcigxxkcbi8gZrOHmzS97hg/kNLQZm34HBwmg?=
 =?us-ascii?Q?AoV4fEPRxdiio2doeb5pBtDDsEPH9kiX+TkEm5Xp9vlVFSjGlmKx1ObxWe6+?=
 =?us-ascii?Q?dvXN5a7s8S/tGztmrv3mRVw2HSw2G/rRqxS/yr7AMhXOp/kG+wTxmU2Lbpp6?=
 =?us-ascii?Q?JU3tL7IopY8zCwmP3DNYanhzv9l2MOK3Ck/4hBlgzayXATHAYmyb9qaBN4Qh?=
 =?us-ascii?Q?YicF1lgU59Xn1zAsgnSolsW8devyG7KnFGaa5Br2BXv/+UPTwxK4iBslpLpg?=
 =?us-ascii?Q?n7lln0HiF31sOwrOo+1qE3q2liOy1r+vPdCzLQzDo9Hro+gcvk379EOLubw/?=
 =?us-ascii?Q?rAVyrIWx0JoRyqwtNA9Wrqt4/iHfvK7sv9pIP7YVgb82ZpDw1aMNmfe2QljU?=
 =?us-ascii?Q?byOurCmIopUCeiRNg5z9/r261KXqCl/qvKi00RKr0fTCN2xQz56ep+6lWE2S?=
 =?us-ascii?Q?R8PhNHE7XUe5WBNghEaloB3SePWrtPfwh8H58mLXYuoGWWJGM59/JcbgbRT8?=
 =?us-ascii?Q?ra8mLQ26Isg8KwDrxFpBpn4wsWXEqRA/9fqw2E85/dDh1ITlUkp2MwUEuo/6?=
 =?us-ascii?Q?MXhYqGue0YN1l87kpDJrmik714oMHetm460p79ohOQwn6DKWk3D2NLzkETwi?=
 =?us-ascii?Q?MXgDYT9MYsdw3+8lsOiHddx5apQv5JTw4NQdoVhd8EFArKwtRkYepU1vCemH?=
 =?us-ascii?Q?iJq2h30HbdrXbmTwz5P28Q47VIphcQtTrobLPgcqxGCp2bfEg52gwkoVYcYI?=
 =?us-ascii?Q?NIMgx309wG8JL2nhg8hz19WIWXEGRRI4MbzdRzrKdUVnKHNTs650JFS5a58w?=
 =?us-ascii?Q?cq4mtqLwwxTkPpdb6qROvyFdEAxCc6tk0JA21GMZa4jrQ3dy25RHks0T/BVG?=
 =?us-ascii?Q?chgjF9JABCFrU2OfGDEm6vcUI9zNhLV2lu8c3ysDNZYyJKgIh1LLvQydhktK?=
 =?us-ascii?Q?m361ATDRQzyR+imcQnatKQ9cgGZ5Z2fOHEGuohyiPuqZaJPWF+8MZOw+EgJY?=
 =?us-ascii?Q?6QDfATcztCeqSNzmUaP59jp96/rWwfuJ7z9wuv11Tbr3sr8tg4pKEaWv/qmI?=
 =?us-ascii?Q?skKicOOsLBDXdETSirYrrC0XHfktZWEE2Us+KhlbiRngzPKNigmYxs101NCK?=
 =?us-ascii?Q?AM3WdmglsPHwcS+6087Lf1H0p3ViCm37Uh9Ma4egt36nKJOp8nisUc9BlZIt?=
 =?us-ascii?Q?6Wf8E6KlbWh1SeY9B8Opijul8SMIWd4IqfVZ8hMt8u5++nSuNPp1EtfMajwx?=
 =?us-ascii?Q?kNtNrkmeFnAI+10mP3DvJr3BBCcyZO5xUWSmDp9gdHjGhi9qMRTaqlq12Fgb?=
 =?us-ascii?Q?FZ7mkA1mySD9WJ4gcDYlFNIKXWYFygtgUfgHOO4SuRw1gsx85eoJ5X4yxcw4?=
 =?us-ascii?Q?SG/RSgBTk/4fxHnMDHn+89NqAHI4UrAzuhWtwzBM4RaLXrLfcOW70m7BLcVh?=
 =?us-ascii?Q?Q1YVzmj1DCRHie2CGEN06l87BrRubwLdj1t67GcEbfaeDQPO05X0Fc2Xm5ex?=
 =?us-ascii?Q?16yLFYFpSgnatDdQU6vcMRKNDARxRWKAyO1QqgaDxFbBa2x47MEdfjf74BLM?=
 =?us-ascii?Q?b2cDjQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f37f702-bbf3-4dc4-35ce-08db41ad9acd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:43:28.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2pTIPockZflqV7smIZSfojAJh5+up28S9Ovw300a0DAIIgisQOzuMgqkPB5A42hxzb8j3FA7KqhWeqhGYciTpF1JLvt0QNsHhCdQnAa/Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4410
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:14:55PM +0300, Vladimir Oltean wrote:
> The verify-enabled boolean (ETHTOOL_A_MM_VERIFY_ENABLED) was intended to
> be a sub-setting of tx-enabled (ETHTOOL_A_MM_TX_ENABLED). IOW, MAC Merge
> TX can be enabled with or without verification, but verification with TX
> disabled makes no sense.
> 
> The pmac-enabled boolean (ETHTOOL_A_MM_PMAC_ENABLED) was intended to be
> a global toggle from an API perspective, whereas tx-enabled just handles
> the TX direction. IOW, the pMAC can be enabled with or without TX, but
> it doesn't make sense to enable TX if the pMAC is not enabled.
> 
> Add two checks which sanitize and reject these invalid cases.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

