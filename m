Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A836C7DC5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjCXMMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCXMMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:12:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E29D99
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:12:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zv2KRuUIk+2osG87DU2e+iRvL4V13f3TpaaVLB22vkVAyKF56Afl/7vo6rCa67CbVaP5wYh6iMMpcloGcVXhL8gfxvazmzhhxYtyyAbywPnPsZjzZ148jMuJ+MZ25iOajzi3R5+Dk7yYXFad9XZ79eteeSQ4d8yMR1/NmolW4oxSJEzGpeJsKVTah69G3KG9q1iQzWl59scMO8bjLht1y2WuyS15DdGwf2FhcOxHNUAYQ/aUQf2N+ZKTxZ5V/Da1OrO1jkZc4mm0scAVkHVD1yL4vTDHrFTzNaTSl0/0u3SONMREQEbpgTpAWlvL9Owx1CSW10yO6zhEDu0B7ypDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XKZxZ6yWLGrE/UKx3xftAPPk3mQL669aZWal/qQJUE=;
 b=MfAI+c2/5OaDkmoKG8Sccwvd3aUydAgVwx4y4kXfTX67cZfIECHYST+c/csQEYUM7R258JJ1Q/uqQt/2v9knrXFdv4G29+q4A9DYeXtTo8Sofvp+BXzsEgEPVvxqZqI/vZw3gahFn21C2s0dBgo6HQ7ZLjZchCjBPMLrUadVdXZI1IWw8p7yZ0W1Koup2osb1mjyRu+oD+lsH5jPqGhWdYXjKmJS4mT2HgRDaDQdHA4U6B/9MFsryd5PwMN4gwLfMUnWS0lHnRP+cnpFEZXEYS0Fl6wDtGW9XKTlDFH7uDFNcFnMQo9uXRzUU+R8gpnw2g91eby9R5udxVc5nwCsSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XKZxZ6yWLGrE/UKx3xftAPPk3mQL669aZWal/qQJUE=;
 b=pmURSuxuKzwk7wOMPS2c4mA6L8MUOAqCE/TmJj8kIv/DI8F1CmoZwIdbttYwDLtlnddcz0Dalpr+wNkbpEMdm+2DOCugNKKaQltTUe4WeEPQyvb6qQG5wDTqjxkcjceywet0dhpC8N1NMOeyVkX85RiatUWdiEd0yNWk8GgzMYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3831.namprd13.prod.outlook.com (2603:10b6:610:a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 12:12:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 12:12:27 +0000
Date:   Fri, 24 Mar 2023 13:12:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: ethernet: mtk_eth_soc: add missing ppe cache
 flush when deleting a flow
Message-ID: <ZB2Tpd6TWpFm9pDR@corigine.com>
References: <20230323130815.7753-1-nbd@nbd.name>
 <20230323130815.7753-3-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323130815.7753-3-nbd@nbd.name>
X-ClientProxiedBy: AM4PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:205:1::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3831:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fea1e6-cc3b-4964-5160-08db2c610875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVlbtn3Gb3oyddAL2m0B1Flr2RBrvc9JUlu8bpnn4+P14mZuZ82MrfjLXiGwBL4nojDVnG6itgYrSlHxs8+jGW5DQZ3k1x5xonNen8jG8ZPHuvAJnGJRMK0VtEhswVuiXSagovjPGdTia4pS+yftnE6lDQTuRN7+WjbcjNUCWAPoMNK206RbfFYTG6QWDZBOaIcdFEYwfamZGlWJJP/Cp26x7o9tY/FBir4JCDQLM/lb1Xqlov5jRcuF0nSMwIC4aUlOhSR+6LoiqXISOOR/4MJzUO6c9ohLpVSc/PLKjeK7puY995jJ/f9QlJlSrLRfzkSnJVCasHbFCBusL3O9TcAchcUAYtEy6Z4kXPB0kYjK2cwy1gGSa5tV/vCw/pnl1OP31Boo5G1D2svS4/Pyd0PEPFSBULKghtMQn9DcolOUos9DxMM49jU8F1wuy48uMLz17Q3LoTRtMyMJHeYK9PTSLOSpEYLPoetWjzwu0NUHbnLPKWwTN+9JJtHtUjw2fILEuxEIm154j3Ce6OmOLlv3QgDsEYPGWBxjKFQ0XEqAAPUarkT20xAv76HY017xBA17niPsBvACfAqauERO2k+WyGjBDGpVPDGNNNc5+DrZQ4UHgbV4h4DCg08cC0Ds4ttCOXvRw+2pFsZhpvOcDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39840400004)(376002)(366004)(451199018)(38100700002)(2906002)(6486002)(478600001)(2616005)(186003)(83380400001)(36756003)(86362001)(316002)(6666004)(8676002)(4326008)(66946007)(66476007)(66556008)(6916009)(6512007)(6506007)(4744005)(8936002)(44832011)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IYvz44wd20Bbq0Mbiid97R2l01NRuYL9qfp2/8CjeW4x+TQtWxfG9oPaQEl/?=
 =?us-ascii?Q?uMfMEcQIGRhHKP3CkkyJw5wraFd0wDr5r8/JwOEVACmXqxAOXPYi+NaKXOVC?=
 =?us-ascii?Q?N74t9mgLVRl+FUpdTSZ6F6oWBFsGB4Y1IRG0iJMGcrxGnnBzkYrb487oZ9Ru?=
 =?us-ascii?Q?sPELvEVQVxpgtfwpRGYQXAjQQG/qOfJYH2/JXKzv7FlpV8UxSFEtCmQGFzQ3?=
 =?us-ascii?Q?9UZ2Nz/H/3c4w8Q7gnmEphhqzWYSz15KtyPaVGU5hptf01silniapTDyEXud?=
 =?us-ascii?Q?iIDpx1dJ+MuSVczedWiaItdf0LaJorWpeQnAknd39jxPjqj3uVjgcSyO89BE?=
 =?us-ascii?Q?NNTdYQ+oibJ9VYLcMOtt2TIArwT2Vp5PWkm7njy/bUpksU6tRERBuSLnYeql?=
 =?us-ascii?Q?WydFRGhmu5Y7vV94n6oTNf7jRcYh1xACazBpKZec/RBCcRAjFp6VGEZzOF6h?=
 =?us-ascii?Q?ceojzhzxnCV+ILe016ICB+KK+dHVdqPdRfcTUW34N4ANqEu2UPlhrzzoJ3Am?=
 =?us-ascii?Q?GTISNT9SHZ0qTm4QIuWxRliguJkp3oPe6+xu4dCer9Pi/Dhat+LKXBW2FbnT?=
 =?us-ascii?Q?JnC/Lo/f0hkTfq1AYteBrkJb40ahE/anWNknKAxkpJkKpvS++1mKyCSEXwC5?=
 =?us-ascii?Q?wDab7Jwobwjpl2G3wVSKjt/TFWNnHu2TBl61MmeDxpGhUcxrtH0ZRUd6vTFP?=
 =?us-ascii?Q?veVU2gYODqbdMF0M/2WS8Erg2P0kiqAAaisb+kZSPnYKooVcNDvGJ0zlnF68?=
 =?us-ascii?Q?6LoC9P0zc6JET2LPRcCWamEN4bFT1q5IPpX9mEnVLjqZhkH13vJh8MhuhYHA?=
 =?us-ascii?Q?rUdj4sq0NnQFmovIGVW4ntZSBKn4/rNCAwBlz2u1RL2azmX4VL3Mr1zqabtj?=
 =?us-ascii?Q?SSHb6Sue00h9zFzkzmxXzm22GJzPN0wRcOjeo886OAiwkwmYWL1ZsOC77tgQ?=
 =?us-ascii?Q?1+1dGlmgg4hYOikkfuvof9BTMl21954XlDQ75e/m9cOK4hCwA/Go3541jm1s?=
 =?us-ascii?Q?B8kZAUtk0T8MhVeZIp9K2J4prPDECHnDE+aL94LTPMQzROhkrYcXleFYGFvt?=
 =?us-ascii?Q?LZojrTuNmXn/y4e4TH8xHkdhXd1ssBEMksmx7lIame2AQk7OlqmSUDUufn+X?=
 =?us-ascii?Q?jbzredS719XsVLDJa9ABnyNCwLEIiARiRiE+upx7MqS0CB9NVAlBt6DkphZP?=
 =?us-ascii?Q?kfnC0PhwvqtLiEIlOj5uNAjBEigmZYiFmrLnB8nRfbtGzD+njDz/P1qYqlTw?=
 =?us-ascii?Q?aLnRfEXK59uCzeicgnmMlEzkDaYuQpQP64OBlkbg630MsUFN2ZYVvusgARI8?=
 =?us-ascii?Q?4YjJtNj+RlzmIz20/ocf+xiFszJkuEmkVqNLlJeUBqujAo/uLfxLzAuipX1y?=
 =?us-ascii?Q?lo/Us9H55rBgM2GivJnPb1v7M0i2bcA7LoD0lPAp5Pejqkj63+DLa2OgWOku?=
 =?us-ascii?Q?q3bunijjUDoxcetdCmLZ3Q3mwumrBLxEcLbfgrmpFwdtMJhMgrJemtsV5IEQ?=
 =?us-ascii?Q?F9B5VB639/xqKgBr9Cm84WNo1KJU/RCZTUPKYfpZC5//ZEaWQnzqQBvqN1fs?=
 =?us-ascii?Q?genPF7UJoFIz/bcIcvp01vf8UNPSNQaAL6G7hdPtykv73oqU9qAYp6IIjQzC?=
 =?us-ascii?Q?2/PIt1N29dE6Xr6VaWtUnDpDRgeaq7B7oSe3KDTB2WlKcxKVVw7VCIRBl9gh?=
 =?us-ascii?Q?HqQnEw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fea1e6-cc3b-4964-5160-08db2c610875
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:12:27.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQ2f7qL9XOfsv8KX9mM+C4TIUiuNl0QxisNgLyAFlyAt5Dzs1BUaUooYZ78qABfbph/nntP+Z/pqQgwgLfflK+Ih+qfl7d7EnsbuNJSZeVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3831
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:08:15PM +0100, Felix Fietkau wrote:
> The cache needs to be flushed to ensure that the hardware stops offloading
> the flow immediately.

I wonder if a fixes tag is appropriate, and if so perhaps it should be:

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")

> Signed-off-by: Felix Fietkau <nbd@nbd.name>

In any case,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
