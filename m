Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CAA6EA692
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjDUJJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjDUJJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:09:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2092.outbound.protection.outlook.com [40.107.243.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194A48691;
        Fri, 21 Apr 2023 02:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gt2e7J1iSino6085EHAUJXHr8QjUhQdSFqG1GTNI6J0kXsnMnWgKXIzDdm8UqGPiZANztYkQEp9QkhdXT5cEsN+DZr77HrWe4xlWpjn0sz9wTIxPY+A+60WR03FeGeFFcuOV3zih4tLQW8MzJutXFRVOutbHoxCYM0HW7NwMk3RGTmLChuu2hu1ZbO6hu0pSG9AHBWL3fXAt/h3U+8C5l8FD7BjlGs21mgMTw+8KUmoaBdSV46a5s3zvZgXoJ/38RbcFJxyXT8D6A3s6Ri+c33nIgTDDA0f1BPA3Eang2AwpP2yWN7ieJUjvZQ9BVmWNm77Zia8zrOf+Ovs0XhPuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phE6MuOLIqTP+9zY8UF8KTwhXqB09hlbvu6Dsm3vSv0=;
 b=DGAIxs1uA85nGkTUqnQZFvZmbWtERE3L54f702XMc9qYfaDS/cKZkOjpDo+flt6ffnSwxRz8KmmDjJoTpRTZolCjE5uDs+uZFR+5TkqfLlNoAEu/wK4h/26rz3uMXo0U6I8LFGHU99XKAdhvQv4vo/MHobf2DYEvmHmag2P2fH/KBTcO3cmCZIFwjdZLjqpSAVOferK3Q3Y39sKZmjmHUc7v+HdKELiNDdo1yfhV/3+cDGP0w7GFPlc3DZPn8aaoelJWnsMX37wtShAAG7zvRRYKMQhiymSmsLR5oHLLdp3kmd2FD9qQHhkXBnI6ShaBrbkKKCtsTjhuIUhrt534HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phE6MuOLIqTP+9zY8UF8KTwhXqB09hlbvu6Dsm3vSv0=;
 b=giLAxySA3fipqTFs718n94oJCq8r/noujRpnMSB8uOVQd1LU+R9EMdmMHAQ44yAx9gvaVM1aKsSROxlurMZChTz+mvVZg0+OiqUxBZSv2+OWnZgkmH9avo1DYDDJjns9jmlaEQ+wtE5ObKOBS6f6neB9IaXW2g9acqWZJy7c2DM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5160.namprd13.prod.outlook.com (2603:10b6:5:315::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 09:09:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:09:44 +0000
Date:   Fri, 21 Apr 2023 11:09:37 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net/sched: cls_api: Initialize miss_cookie_node
 when action miss is not used
Message-ID: <ZEJS0YHW1Hv4+ni3@corigine.com>
References: <20230420183634.1139391-1-ivecera@redhat.com>
 <803f6502-76dc-d6e6-1bb2-5632de12e5ee@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803f6502-76dc-d6e6-1bb2-5632de12e5ee@mojatatu.com>
X-ClientProxiedBy: AS4P190CA0030.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a0014d-1407-41a3-bd07-08db4248259f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2qZ31o07NWJ+htIEXc/Xi1KvPadeUgZRkP4ZpQAu+PDPZgB8fCRVRh+v7EfK/OVxMclfNW34llTKskpwpXliBB7SlXlI0uu0/jh2Z0YR2mN4Z+IKKlMtqiBc+p0Cf2hiK79UbGkJk5YZ8ztd3edsoK7KAUJxd7dmmrlbtyPavICUKU8Zxh0ByancLW/0WPN7aivTIuWvvYYxPpaN5WAudTRtMHaAlOc+/TQQxosxJBEtlKwMcjPFwWsHnPqN/OAn44mD7gcYuEboSsrTyEtT5/oKBmbUwS1zLEKdB0NJ7obcMma4EP0PjxqYwPjjKqRehWCgvL9b5n5SLLkGS6l6FAdFNO8ZYRU5SUJiwTWQmJEjpyNLIU1B0H5CagPWM5TZbraNFH8/pMt6REz/OoKlyKLIrlCGFzgeTqGV/K8hGQ7ko7qg2TjsQRHjR1EeREV/k5Ax1bIfK88T3t5E5NfCEcPQAoA1qmzhZxdCqaJKSlaCGfnZF5qiIgJEhpLoAN8gWjSi0Up6fn2JDYhCzieqPykTZHS5GSv6J1dqU6Hhp5vdY4nIzi36TZ1wEa7J2M9cqe5/5U8+G7E9nTAxuZt+0FtArrWRCcIEt//u1pdtfI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(346002)(396003)(376002)(136003)(451199021)(41300700001)(66476007)(66946007)(66556008)(54906003)(316002)(6916009)(4326008)(478600001)(8936002)(8676002)(7416002)(2616005)(5660300002)(6512007)(53546011)(6506007)(186003)(6666004)(36756003)(6486002)(2906002)(44832011)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tqkvS9s7hj+VzNjCNEAWpvvMxbfiNJ6ifJNSBWNpbdJQiZA5SVdpv17lNk3Y?=
 =?us-ascii?Q?14EfW66zMrAH84zl/Vy1MfXh8I0CJq5fxUG2N3XoP8pd0pEfoDHQYW11+sKF?=
 =?us-ascii?Q?Pg2OITBJ2JO6qi3hQdkXxgCj4O0Yhyb3PABvziteWp0JnDWF8RSUr72fqH8+?=
 =?us-ascii?Q?fEo/gBpRoU+FuZwFYhp5OGr1y9GJjLi/m7x+/+9tcNPA1beOuQzp/k8j9AEh?=
 =?us-ascii?Q?q/UTKow0+oHaJBgvm6DXnAQsgX52/wup6+icywkJycv7sGbCNttrL5VlDvWj?=
 =?us-ascii?Q?ZMJRHKBeSIKQUtFUkypkhNkrjXKqiA5yNiyXNHeGbjVgwq1aOv0CufexmXeC?=
 =?us-ascii?Q?tBXZiYKM5IgkmAJDOMuWk+cRlHSbj0UpsWnLEA1M53wDD3ZoTK3yzNKOug26?=
 =?us-ascii?Q?ZWXW1cx4R+qyvUcf+jCrA3yTVRmudsYoBVQiAQty/RAcgCnVZcU9IZezIxh4?=
 =?us-ascii?Q?Aw/ciHZk81YdmOAPsxgsAvDc/Qlu8a2rti8I/degZ6bPXiLJAKPkOnlHJ5ub?=
 =?us-ascii?Q?rqxNxhGnKWwLsGt9yPP4CMS63Z36MWKN6pThkA8QCbmYY2X4g8OYbWGVrceS?=
 =?us-ascii?Q?2YZ7Wk/n7DZPp/WfSNEYBrSist4xfHFi5CPoC6mk8nZAVDhpKabnn06U1BPv?=
 =?us-ascii?Q?KhvACtRmP23Ehb0NAbLR8gvq2Rta7GHv4w/ou5iBFNscUE3hmpCm6MHNBzOV?=
 =?us-ascii?Q?5YjujxQ+MF2dEiobXMUpv4csF4ywk6a+9S8tDfnoAhSLrC0bYGfjxX+JjSki?=
 =?us-ascii?Q?l1vxuexyAKjYx57S9VjdVD54+0bWY5bgug01gc2hZL7N0cGdkK6YufsQbwyS?=
 =?us-ascii?Q?mZjuO1jxMJwmib69X4JjZP+konuTDBdLze8fGJAI6ZGYdJjLqKZdZYyoYHim?=
 =?us-ascii?Q?YOQOA8LO5R98Mar4opeG6BIuWD7kHPRmA3TA4dp+sefeW1nJSGLACAC0XDzy?=
 =?us-ascii?Q?G9AyBHBAvoeM26XXy2dF79gyFKGDLNYMbnBStV/Eu2Syx1pcgb2ftlBSk8yb?=
 =?us-ascii?Q?GRvkIXGvxkgx+6WL1N5jyvhOZJtxCYMszDlxrc0IZu0Tl7tcrxMdn9oO/iSa?=
 =?us-ascii?Q?Pl5J5j6vSqKbBZHys/Aqk2ZNeu/gmBqWe0jTwt81mej/u7lgdCyXN36OiAat?=
 =?us-ascii?Q?JovXlvsG3YzdHJoV832M5xpUyErXMn+xw3um8r7dS5MSEsnV4Pbeq+KZywOg?=
 =?us-ascii?Q?YdGbfAnSewDMFFEr5rdWzAvFrLrYlTxNCeyp/Pm8I6tCVmqWuKb/jnhIWTkz?=
 =?us-ascii?Q?97H4vkyEdLJcyLpJEC0WIBgTQPRuEHJn8E9TNXH3AFFARmziZG1uh2wGgJkP?=
 =?us-ascii?Q?2TbrXN5l1qidq2poRbIMZvNz10qngyMzPo9dAPem51H3XJOG/zmpVeHCi6Sd?=
 =?us-ascii?Q?AoRn7tKa5MZ7K8aoLdUap2c1YKpoTSohFFmllisJvG/jZ97A5RGcd48H6S9N?=
 =?us-ascii?Q?7NSzQDv3Nza/5o4dGfabr+fad8PcTsEYJt7ytUwEe+/3zDQRGMCabSU7/2iZ?=
 =?us-ascii?Q?7lPX9Hun2pX+VNlhRe3AILXYUdJcr0+RxnCrGvZpQY6OY6v/Fp+2uZXlmeI/?=
 =?us-ascii?Q?5xcAFhGrUKeqXepJ/r9ERlPyS/dKhBorSTz3EHXV4XilPZr3PwJX6pUn6OeR?=
 =?us-ascii?Q?V1ePBL9i0Q87ivF5LjpFShPngb4y0VJlMakFcrhclzBO+jUhbyQZIZP83XxA?=
 =?us-ascii?Q?R8b31A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a0014d-1407-41a3-bd07-08db4248259f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:09:44.2430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9WpdCD5QYF6fM14X/8cmdhM4ZsbplmetRUDojl0dCGQc5fZh+OtUa4GIdF33hVPh1SWERKkVZxV7Yqqv+VXIJHejBkwFiaZkhWMM08zpR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5160
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 03:41:17PM -0300, Pedro Tammela wrote:
> On 20/04/2023 15:36, Ivan Vecera wrote:
> > Function tcf_exts_init_ex() sets exts->miss_cookie_node ptr only
> > when use_action_miss is true so it assumes in other case that
> > the field is set to NULL by the caller. If not then the field
> > contains garbage and subsequent tcf_exts_destroy() call results
> > in a crash.
> > Ensure that the field .miss_cookie_node pointer is NULL when
> > use_action_miss parameter is false to avoid this potential scenario.
> > 
> > Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> >   net/sched/cls_api.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index 35785a36c80298..3c3629c9e7b65c 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -3211,6 +3211,7 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
> >   #ifdef CONFIG_NET_CLS_ACT
> >   	exts->type = 0;
> >   	exts->nr_actions = 0;
> > +	exts->miss_cookie_node = NULL;
> >   	/* Note: we do not own yet a reference on net.
> >   	 * This reference might be taken later from tcf_exts_get_net().
> >   	 */
> 
> Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

