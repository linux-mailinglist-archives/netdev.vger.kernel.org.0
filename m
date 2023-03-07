Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA26AE6CD
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCGQhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCGQgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:36:04 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4E797B6C;
        Tue,  7 Mar 2023 08:34:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjTBiDzXg5yimK+ihCLjQhVMavoOhJKJz3Wf7Qm+ckRwBIcKHE5yqocyE4smkLNUie+Imjie5xOd6I+bBxlypkW1cKNc8axcA2DT9pbqWWAdOjogAssZzZhUFDlGTVJQuOXkK7ho8/+AuNXmpgj1we+1dX1r81abdUPuPaTlqMNX7siRACUnmyZy2G6wbiT6ttF/DZsLxNz3K76A6ED6L9LJldRfUa9WpsjX7xikxSqfUjfFP5CJuusBptY0+WDLnlpxMb/jESUB3LzaFMi/T2XtdtkrFX8aWU1p/QF7b2JwjDpZTU36tOQ+W5+iQxHWom8BrDu810P6M8ERf6soJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJja5LKz90f/VXh1DVRUZe6YiTAZpccmEJa0lx047hE=;
 b=jc7c66lmkOZBqVOiWMnGenPUjN5/tXv4OFCerRKRo4iDO4Rd4akz2znI3SPgzcQIKCFdPd15CadTGPfB8Dsy0oaxOBGso6LVLU5CjjdJoU/Cf6zkTqWwGbKCVPjozYZfjQIGgdpnh1odAqYAWNRKN/IWcT1dLpxcX2z1MWIXTDHrJu0ApEq0DvB7639brEV27y6TKFGLtGmrbOtHqWxEqSarMcTseUs2duS9p7REE+usw7nrGgMQIdkRntzbn4aeuSt7KSLayhN9/ehz8HeVg1TcO1Q70DjrM9Sp5nTmsij38qvWdXknq+feUQlhK4j2SW6u7f2LozWga6LaH5AAhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJja5LKz90f/VXh1DVRUZe6YiTAZpccmEJa0lx047hE=;
 b=sL/JirRFLZMEXmUPUQirSkmiEop8YIfji7IEByxkMgiCoJAKhuZh+Qgp7actypvw4UE6cMS8adZjaaQs4eaFLR94AMM9cQC/M6k6Yri9at+28SeQ4ADc12Q7wsPrbexmgHzj6F5IPkybxTJUW/iAaHDl5z0fG3EZld5JuCgcxVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4151.namprd13.prod.outlook.com (2603:10b6:208:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:34:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 16:34:02 +0000
Date:   Tue, 7 Mar 2023 17:33:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, error27@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: microchip: sparx5: fix deletion of existing
 DSCP mappings
Message-ID: <ZAdndDaDiuSy5Lwf@corigine.com>
References: <20230307112103.2733285-1-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307112103.2733285-1-daniel.machon@microchip.com>
X-ClientProxiedBy: AM9P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: 663782a0-aa35-47a6-eac6-08db1f29c2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fa+bXs28/Jk1JFerFL6ef31O+pdJfDGjJomhr2tVVm9jBEIzgP5uloYYffHjDXTGpo/7ypuERybMY2ME5oBEuPQXQntBiE7v0m/sSz0skuapQ6nxsB7U2sxwnGDElx102+XwCHBLHIjqKii2bvv0WNoczaakmI8sydg4qKiAvNcQicwZ5Lr8bH9nzNPZJlE6Idt3g5z97whKuQJ8g+06FerFwulcclTM9duHru7n8zYlf1LoW6jMKEMFmdVHXwbz+fuNdWqBl62aroBEk85fzT1qadZYvbGTjo0pyyq+RKyV1Ao3P3wbLrn2ImZ+nZJH+ozkGcm4CPJVEg4EBWHRHIM0JIyc7FhaZP2UsCifIrw7enqd21daVRntTdEy5rxHI5dTRAVZGlkV5ynOfiLTn7bcp/R6hWWabhsmq7sPHGvpySRLJceXTIUY6Img0oJTALSD+urtQmoxkZw/SIkeIfcnmnZbJsidlIUVzF+ortNH92IKLoxzh1NXinkqUfaj0fOuKTdUT8CZZ1PaFCMFpGz19rsHu4uDEeWwPA7j2NRRRwhdjWwemn6AojI5+dCnXhJE7IkIkGv1c+QUwLI93l0mzxJQkLN+QM8DGDZdMKXbmYobgmrmdR4Cj2La0tty477ut/f8rp0Ioi+EmvWj4K2rAHFKjxfA85WIEUMRtkWcLCQCI7DFz9jqtk359kAz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199018)(2906002)(38100700002)(186003)(6506007)(6512007)(2616005)(44832011)(6666004)(4744005)(66946007)(66476007)(8936002)(66556008)(478600001)(5660300002)(6486002)(7416002)(41300700001)(36756003)(4326008)(8676002)(6916009)(316002)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X5MRicyp0gyxhQXe6r/OSQKwcASZc37z9Y+OdYjaBd0nwZBcLvKpK2+cBgOc?=
 =?us-ascii?Q?Bl+lyKgUY/xzG4Kbk1z5RFGkkroBta3ruOsi85rp4AkOrl9DIJqqbSghuq/A?=
 =?us-ascii?Q?rQ94iULy8stWphZvVVYPTu4zB0LJjONRXlFJaRplOjYljhO3EJqofAsi6pkG?=
 =?us-ascii?Q?3p6M69tp5iZ2JuFdiocliCrMpnCEsPdJTTCvNozuaAftCpGuzORjXz80d9HR?=
 =?us-ascii?Q?TuecocdiUUgjuluxBJVZPjnsaFEB13/baKH29jEFoDUOUZFtsJ+OH7mawyjk?=
 =?us-ascii?Q?7ikoQRHsc09qpumNFjjm9O9weLrBzvZdpQqVIug8usoDTbO+7lFjkYZ+FPcp?=
 =?us-ascii?Q?ET3ZLlzHQWwEYfDBPHe9CZI/qazIrp5LA3Mf+/yK4CGm7AuV8yXhWJD4fLxN?=
 =?us-ascii?Q?YtdAdrBYUBE+3BbgR7Crnpf7Y9cEK3j0mwZGM89GXQDBGJD1E86/JH54i5XE?=
 =?us-ascii?Q?cZ4xEFb6utOymFkHddzflvipFg9TPjjHfs8uXqA89vlFSqdk/lA5ZP2OLpnn?=
 =?us-ascii?Q?lxZXTIXx3eCbxZJ0JrJtqUkv26Zc1tiQApE+HSSw9IKNj6KEoh/sKu5c/Nro?=
 =?us-ascii?Q?FYleASEJUYuKYGLTtL3xwV5LKMMgf6RA44NkA1zmENR+lwi/xu2R5o/WpT1R?=
 =?us-ascii?Q?caT7XlgqC2sSPFSPZcxJ1CxUHhAqJvjfwoQyzAkbCidrHwvkncYid04e1tuO?=
 =?us-ascii?Q?+PMYAQuukiFc9e1WSfXUoERsDXNRvQiUAzqIbRctXy5ou+o0QuTx6AEDpLdH?=
 =?us-ascii?Q?DrZzheNVw6zrs4eoCL90C9IoiBM3pZ2cs+nGFJOtnay44EzvqcorpySC8bAi?=
 =?us-ascii?Q?jj8qXb5IhgLIgI5qjpvTq2l9hCPKdBU5M9LrkFuiNs0J86NabhoxeMVd/ECM?=
 =?us-ascii?Q?vk1U70lStWUoNQ/u1/fB4amlCzHK0APoj6RQh9LAI0hipeBmlJzoBgGIn59A?=
 =?us-ascii?Q?bQAk75BxHXUTzZ3cmaMmA2Ko81pzCp1+cwmxfCaarB70NeEu4O2eZC7ohZfS?=
 =?us-ascii?Q?kLbU2cONuiP5yR6o+tJbZtoIuRK5HiOPoJFEC8ZifDmnUefY5/zNvLtVB6hn?=
 =?us-ascii?Q?UVbqQWC2GajLVomBD5/RFiEwpLDb/BefYUsF/89XZSyR/Vrt0YKRlx4IxzjW?=
 =?us-ascii?Q?jwAI+rTBAB0LXMTS8RCtU/XyraiXIXqwrgoct98mOEe4R77T2M23BqlXPeM1?=
 =?us-ascii?Q?WcPh8ECHAD9871nKFccHYLsYRRy3XqsKRnSRLzyS89Abzawyh/acyZDy2HCd?=
 =?us-ascii?Q?HM6N/tGYN/c7q23Y5r5c9sLKJthTQYZqTFpmW+8h5vy4HWmvbU4VXzeu0ch8?=
 =?us-ascii?Q?NZ5gQnY7M9riPJ44QNSAxt8+ttXCiLGFO+q2+DKZNgfeZp8HSkPDlcJRICbq?=
 =?us-ascii?Q?XQ5e0ZF2T9a7Zf+I0W8p5L7ryMr/svTAKzGuO4LYqWyD3Vh4rYtgYIpLQlGy?=
 =?us-ascii?Q?z2TBj43GvwVtXc8hGm+XlVcCDsDB690+ylTBt53ZhEHQe/B0gCzgAj5d8jeQ?=
 =?us-ascii?Q?CNfc90FXkn9t+GjMjc6q0UxRq4BV8FZ3VpPeKzi22Qe5WkTfxE/ySBSFnUn7?=
 =?us-ascii?Q?LJu/xqaA5KUl3a/Ah5ZlEo+16xStylTPDsRU1YckYoyN9ucnqc1lMDJeLmOs?=
 =?us-ascii?Q?udCFnD71eQIKdgBCcwSRkDyPoFaJlYmtuDGF4XTu4iPjcRXf3reWDB4UvB6l?=
 =?us-ascii?Q?x15Pmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663782a0-aa35-47a6-eac6-08db1f29c2e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:34:02.8613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/v4+VBonFR22xDMQrfU3RAYoPrI+o7LE9x3Hp6g43hV3dxmM1wR/BYW11ssqhWr4D/o6KBGIyG5X4l1ZL5F/q19RwR3bPXjSe2yCHpL2TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4151
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:21:03PM +0100, Daniel Machon wrote:
> Fix deletion of existing DSCP mappings in the APP table.
> 
> Adding and deleting DSCP entries are replicated per-port, since the
> mapping table is global for all ports in the chip. Whenever a mapping
> for a DSCP value already exists, the old mapping is deleted first.
> However, it is only deleted for the specified port. Fix this by calling
> sparx5_dcb_ieee_delapp() instead of dcb_ieee_delapp() as it ought to be.
> 
> Reproduce:
> 
> // Map and remap DSCP value 63
> $ dcb app add dev eth0 dscp-prio 63:1
> $ dcb app add dev eth0 dscp-prio 63:2
> 
> $ dcb app show dev eth0 dscp-prio
> dscp-prio 63:2
> 
> $ dcb app show dev eth1 dscp-prio
> dscp-prio 63:1 63:2 <-- 63:1 should not be there
> 
> Fixes: 8dcf69a64118 ("net: microchip: sparx5: add support for offloading dscp table")
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

