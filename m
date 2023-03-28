Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50056CC484
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjC1PFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjC1PFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:05:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B989774;
        Tue, 28 Mar 2023 08:04:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAtGlQOxJPoSmuR0JKEwe+hSaQqO4bZKMN4gIqcrEdqZf74YGj+ginwDA2+tYsohen6vUh++bbYEzKjRRVuSP7q1S4aK6jV1r99BFCp19nsGJwn4PkaO3nPY9TxlmUqR2Fdz7gtSSlpK4GP6+N9z6ZBoluCb5H4XYT6gD+1gLDM+Qr1gQjds69kKvy5qf1xlqiyGbPy4Z2Qgrwq8UlTMS0oxAN+H0kJ9HHBibSHihawhAvvroUxCYQ7CSsvTo98OYcHyWPVt6olDI/tAz9cN1xpfJ0pPw8NIUPwqXL4NWf8fwLzvc5MKSpIizRgSte7qJawQp+Cu5hYtWjDdINRP0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOjwBZBogmRHpFK9fzguZl/mQ+weud83Q5M6VhFIgHg=;
 b=MnehywD5yaIcq0k8oQZXZaBMskNl99euJ8mRreZ+ov6y3eCCmgIE6daa6DT8T/XxhuoV+OdCsFwEpHa0vF/9IdG8ED9arnMH8habD7ePJcS6FOGJglCxoScLycbt7vA0nOXHZf+DljQbnIMTzGWJinULhnX8K8jqDnUEbi+ImoOQ2qW4PkdLkNesRj0Fbu5rcnIUFKCBm1y7h3G/BXmS4U9981Y6mhhUfJUk/JxTZihBay9pvqqfwjf0848XQRJcvV2gbmvuCB+RT4BEPnd3Vkied5IPI3exlTTuKQ8EGyU9MixJEaiW4V9s3LpVDYPNSJELZvDjijro2tn28ISGzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOjwBZBogmRHpFK9fzguZl/mQ+weud83Q5M6VhFIgHg=;
 b=ZGJqy3FHAUoR6WN+TbUCaxkwA+FibEAIGrCW6UhvZ5mgQU37oMXzgRGYlAdiIq9cEedj/rOyesqqVuyIaPPrBRThHf4qpdfFmLVQkx7UYqfNpDDMl1DFAMTBHMjgfyWxV01XVZlRIgxRIjxHsZPcYuGEqpBRViMfbA/KJKqbZno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6147.namprd13.prod.outlook.com (2603:10b6:806:333::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Tue, 28 Mar
 2023 15:03:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 15:03:33 +0000
Date:   Tue, 28 Mar 2023 17:03:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] Revert "sh_eth: remove open coded
 netif_running()"
Message-ID: <ZCMBvv7Qm3ApnD/i@corigine.com>
References: <20230327152112.15635-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327152112.15635-1-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AS4PR10CA0018.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e7761e-312e-4fa2-aec4-08db2f9d9930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhEEd2WI8IRmJpJm+n4dJoW0+L888fBLjQUcyLMnQLLEx3VUQelG9F7rGeZa3F3YU1zpkGPEpKfvoGbzlR47tJVmhAfE4YBHwOeevjARYg6iEYol5eG2Nunew4hkAOaB//tdYsvmP8calWU0dNZpHv2Ap/7e9A371c84KpKrA4O/tYYTdfKe5M1E6+jhw1/MI/8i2VXu5EAYuxHY2MCm5bLO57B81GHJefwwUNIMm023jBkEBjTDqhyuttlNQPHspP8R2BRgIKvcQonyDoggBSmzbiNzlGDbZ8i2ByrnUbaJmiPKDx22j9RTDkpgwHdmcjc2UpRFajsTvdC0LyewDx+6WcQzlZln1o1h5fvnuHbnMNo9SfWXSyCQDbfvTMsFF4RG69iL3wUhQX8oTazdDuHZfcm+W52vXLsxRvdgE3m8s8YWW9aYKET1hratTKy13ZdWWAP0HqVFxIKBo8HaBjOuBep2jOqcQE79++HXFCQjHpJlVFn12H0XychaXEXwb78kjfbfVwlEWZUGQwn7Y/0x/jU2FbUCeJWa+dkYWJ+ZEPrU9njjiaPwwyx4Mbsb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39830400003)(451199021)(6666004)(66556008)(316002)(66476007)(4326008)(66946007)(8676002)(5660300002)(4744005)(41300700001)(8936002)(38100700002)(186003)(54906003)(6512007)(2616005)(478600001)(6506007)(6486002)(86362001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mQnsxiN/AMOq/01IXXWx/kigqL1fmgUS68vZg7kz6EVez8LF4AIvdD07YTGm?=
 =?us-ascii?Q?Y8dfT0JNsy9ZEqVQOLdGz5hEe9T9q6Vb4Ax/gSjFnNrUwWLu5Uqe5NY8J/hg?=
 =?us-ascii?Q?0Pdq3NR7n4/F7lpjDR3H0tiOUpjkJ20eEu7sxd1K1M01cLEShohC8p3pvB69?=
 =?us-ascii?Q?zUTnJoGMCrnMozkzSuGoLL/zd6XNFtBB7BVKKp/MzhAQNFnhSmClU9wiLZJw?=
 =?us-ascii?Q?TOimWg3AMO9rk2uNeFyPL6fXSNcgR/qPE6FsziuZJjrY/mwprH9j8XljgIHZ?=
 =?us-ascii?Q?OsEWmrxyDNmIze5wakbUXuRvWEQf8kVtmJZ+HiagYoWSt/qJPrSLcnLsOroF?=
 =?us-ascii?Q?xJ53SFJpj2na1YIBK4PvdA7E3auV8ncGD8l4EgKeJse6easrGLdHugguulM2?=
 =?us-ascii?Q?RjQunPk+OnH9pO/MrDhjW0Wyww2MHATIJ/7v6NNW2aKonGMUczmW0Kw92cSn?=
 =?us-ascii?Q?dnG0MqzV79hMmAWn2MKkddi4bXvQLFQ5qGOUKR9amcUkqjvTJ2GdqQA6e4I8?=
 =?us-ascii?Q?AOt6KB3YGsXbWRxD+q58ee0J3WmLBsK8y0HpHWQ/UPznOn8XsTtQCU/n/3O8?=
 =?us-ascii?Q?uqF9/nlHczLZdfYC0ta8w5QMt8+awufPLPqogDQFInv2i+ggU0izRLPiW0Z7?=
 =?us-ascii?Q?OSpj+EThHvlF6SjkJLJieURqUyHYJ/0ZAvnj0x3xbPCYq09biULTnRrgJVYI?=
 =?us-ascii?Q?faqfpn9V5ASZ+10FDwluzKitv/ToHW7X1ws4hKQO7E1pIxpakxUMpeebeW73?=
 =?us-ascii?Q?ORthO4/CigaYMf8Rb3OrdZdb2b0+7n7EcyeNjteOiG2txcqSxp+mGuyCGJ2C?=
 =?us-ascii?Q?J+NJkRc4cGwTpZYk/hzbdCGurMDPAQTf1i+feKjW2DE70o9JQRu6cEQdUp1/?=
 =?us-ascii?Q?GD5tI1qGiPLqNn0xLpF7sSEqXhDtEFAzaZnmgHe1X/HEWic3Eb2QcZs53cSe?=
 =?us-ascii?Q?YqypokAGL+fKW+E+gWc4rai3fR5ueJFWU8+8mS8zFvamaJr7WjV+vOby8baG?=
 =?us-ascii?Q?2xC6pVaqMU0HJlHnkCQ2b7krP7xnbo5uiSDoP3vlnzCR2A8vROSb383aedEt?=
 =?us-ascii?Q?UHr7mpdmgDeIiFXuW4lp7XxnuSttSOGWRi8anNUBYJS6vBA+r89Ce+sk4cEZ?=
 =?us-ascii?Q?D3XGr6iWBc00PHqSF2F4dIgaRFtAxUNkmIgaIMhrkHRLCRqZFOjJyLuJInxw?=
 =?us-ascii?Q?YgeKmQeIS9hWgBbjA80OzIAVHbloUDAqlUwRVudTMInR+MH11NndDtoWVLFP?=
 =?us-ascii?Q?++jLK2MeQmtgwJBOlqqMid5L4E2lSymIGd1dwKDtv/2EWIP7E4uZV2BZyQv2?=
 =?us-ascii?Q?klqUbZFui59VhZ9gf6wjT57Lpc304Z5gbRhJm+tr06Io9sCC2zO8ePYgj4ut?=
 =?us-ascii?Q?0xjCDrI95zjZPVbD+Ey0VsdNME91Ex3lfqTrrb29XLpHOlrv5dk28rJCLpJL?=
 =?us-ascii?Q?3xp1ncaNFrmtkEdkBnvKqOKIIL4Xlaz/mkINraH4bAqHGKzG7CdgxI8TbwNH?=
 =?us-ascii?Q?+rWs+u151TJR8SzleP03UxlONyhIzHlhuqHcncA2RTF+LVuzRYFI67V9nKX0?=
 =?us-ascii?Q?NgHp9EZpiK03jro8EscuxH8Na0zKk+U9//iBPyTQF3PQ9ZjqIlgD1Wg865YO?=
 =?us-ascii?Q?S4mCrVhQ1xY1aA4dNntBkm2/tkaLlzaAzDet4zNCK9BCqAAkb9QCDju2kpKV?=
 =?us-ascii?Q?AqBxKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e7761e-312e-4fa2-aec4-08db2f9d9930
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 15:03:33.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gV5/38JicYzUml1z6dyh546UDyQmYIfRHa4BJH+nIipWRToGcTF4VubxNCiO8miHNNXTcVPEwxrS9IEuegXBizUMien3r4GsXADWPvQ1USE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6147
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 05:21:12PM +0200, Wolfram Sang wrote:
> This reverts commit ce1fdb065695f49ef6f126d35c1abbfe645d62d5. It turned
> out this actually introduces a race condition. netif_running() is not a
> suitable check for get_stats.
> 
> Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

