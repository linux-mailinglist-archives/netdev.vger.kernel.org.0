Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D010C6BEE69
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCQQeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCQQeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:34:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2134.outbound.protection.outlook.com [40.107.220.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1571B54F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S59m9TI5ZSZyf9BipOnv8cZqEL1GMvwC0IKYoE/0H5lJrnfsdMpM/dU5AtY6plJZUt4w+u3SPYQId+7zNSeyBTcCCVF9XV5LaLgu4PuPfQYSj/q7VELub9j8MOmmPSnbm7OQE8fNOTUrdmFTgl8+Ub+IafhU2XAdwKr9C8PXmZS1aSCtiI6jG0b2K+Ny4gRoqRw0uSK1fwTvIZv9xR5ST1nSK+y6SlbLJq+Ske018oPetif4A3QtiFgdvYy48ia+XAhvyIIaLItmIrU1/rAnv7gs4NB53A0BTysKUb9RIJuiIucMorY/D0Sz6zC0fysKArneSn947l1bC3euxZU6UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JN2gW8ZpHoDmbRoIuCdoME544tt/VmkhQAMEHhrtqmg=;
 b=Q37W9Jdk9H5JAFFEV0/FFFn4B6zp6Lgp0WFW2OgiJlzQejDWVC3hc4MVf2o24xaMrfSHucSjApRtIOauhYc432v/IWnMy/4sPK6ArDVdQIIeZI2+Gc+tPB8kxTZgWaVrPKDZQ6vbttvExKZuim03X2MFbKCxeeS0ZSuOfKmh79JxRPr4eI6sNrFejnvogK3CqP0oh3LDnFJMkb/rdl8mgGr7Mkwas+fqM8TCTSTb5NA5blt20mPwYRhQK3zTCtOSCNOcHWdQHCYwRECyeYM7N7upIseRZ+iU+lxImswSLXhCxbjOxT7aDB+YhWa+0UJUC7elnTrZ4cPyeDNYjCZvhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JN2gW8ZpHoDmbRoIuCdoME544tt/VmkhQAMEHhrtqmg=;
 b=hzvtXIy48yUWlr94f5m9JrftxMMeqJcyZFUkX0WLX/zVHWNWKqAlxtsg+TVxtJUgqI22GU6vF+bhh5vd+TmBJ0Phq4ad6+gAH7M77rQ2YJehzr1+Yu0tXMUrJlkzt0Eer8gQGmlGvGYgvPhau4WzPUKoPrLgh4Isfd43xVPDDxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4954.namprd13.prod.outlook.com (2603:10b6:510:74::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:34:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:34:00 +0000
Date:   Fri, 17 Mar 2023 17:33:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 03/10] raw: preserve const qualifier in raw_sk()
Message-ID: <ZBSWcq9H3Xwd/4ut@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-4-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-4-edumazet@google.com>
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: 154e2cab-6d31-4ca5-a2d8-08db270569d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ik+nlFn6CwdgHbRnahzul7ksPBy4r8waYk6qe7bsr10Nw4sl9+bzEgjobyta0YR77y+m/vWNRNTMGnwU+FrMsp4sxqbM4lU2NlePv+C9y9lbXKVwLsk/DM8dP+3qLy558N91WhMKEFO3W8zCyiauTqHgnF6jXCn97/OhpKrS822VVyZ/5IKlMptOZmsNzzubo71kjdQ6RQzNjz6Vc1b2CBiWdAWeTonq6uCwwJODBxaOFQjV3TwhDUxCFcuPXU6TkaqZLP1kVgxX6q8n7oCaJ4qWue+fmK/UnzwHLHdiv6yoVZDlgz8TRyJB2yKmAar+uouXd3lp1K7BqOd6JLar4o5zsmsctiHVg18WVgEMffJlSj1bZC9qwj6xqlPh27hTfnO6vLG1CvBUrUHNRRt9Z9w96lnUwllrh5gctD/um4uXB+wyOUtwVclz8WUSvHDuye5DNKjn8phxfZHyDrpszwdTex/evhCC+quF62jf2lUfOI57yQ48LuisVXXE2xDUWPzR5/8Fntt0RYo/4w7F4o3IfW+sC3LAxqEANHQqsMVs9srFUEj9DcCiwMkjq3ncbc/IFCxRmR+J2e39ThHoPvKj493c1FX9YuTcN5FniikQD/4Mm8+268PA03WVH5faWZBMwR1x8kvxjnalUbQVVPGfOrgkliRhhY9MtQEEXb1TNhhdx36InrG5gzHR/iTl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(558084003)(36756003)(38100700002)(86362001)(44832011)(8936002)(2906002)(5660300002)(6486002)(41300700001)(316002)(4326008)(478600001)(6916009)(8676002)(66476007)(66946007)(66556008)(6506007)(186003)(6666004)(6512007)(2616005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AQhxyKqvbTcgYLGUS3YBuc/rBWIA/cXLMzkFAD7TlnpG4Dr973bJsH/rmgs7?=
 =?us-ascii?Q?y9EI9ZMishQvE/+XNBkLlvIOyr0Apcs5n1Uzg+sjFus5FZriZZp/KLKYgzZJ?=
 =?us-ascii?Q?ykqc3stX/2VMguYrxj86FUAxRO+8VmzC6OAlM+DsldcxZMQPjUdxedOPZcSA?=
 =?us-ascii?Q?H1nl5E2WF2r7ZSPPtrQmWH8en/ddRjudcob6EPUMtHxAk6uO8Ta/P0/0++sJ?=
 =?us-ascii?Q?LsdysbISaUVHv5WFi2Lo24lBUg4p3J8vpbxphuYOZbVi+0Jm/HlKEps3at/U?=
 =?us-ascii?Q?JqhRQOMNvayiB67C2/Gi+aacRyjKJkEzBsF3sWWG36+POywdo/LPQcNXBvxZ?=
 =?us-ascii?Q?EKKDnnu+xp+ej599vOn3Ty7WgVimhSpvGwMPeFdn7CzFYQHk4D4lENp3WcY+?=
 =?us-ascii?Q?8O0+0r8zONXb9FtEi56Tjh62OMBTgAlgv1YU61k+zyS4LKS2JMYSqhR63B7n?=
 =?us-ascii?Q?fUk8wsOGNhuO/+QOZ9E/I7aoIjMduLULN+11fJsahmLA4QOUruPhTfTUPMM+?=
 =?us-ascii?Q?VJFVa1IXAGhsNdBTnF4U3WmNtKtrDBhfehjXm0GbeXJMPaTjfV7CUPYWLJex?=
 =?us-ascii?Q?V+VNI1VlyvOmrDKv5285PyNblEljqgEjjnE/skGBV2Hy9LG7+7hd2gyJqbw+?=
 =?us-ascii?Q?d6Ep4vB4NMgSdl3Utly8BQ9lCcazCi96clH5fJcN2pzKeoyg/H2qQv+T8xkD?=
 =?us-ascii?Q?YiBF3gXhIfZI967SJ6oA2bRDQNDNzsRNRGnoHDHFOE0FKs70SKXyywCDIi6G?=
 =?us-ascii?Q?wZEtrrNHIIRlnPCNMhKSXzf2DVfXpr0FRK1c0gdA8M7F280VH4L7g9q1txp5?=
 =?us-ascii?Q?k2f0imn8WCgL1kS/pleymvJVw0i20MSMeEfh5Y3VJwNmGjIDBtVipemkM0la?=
 =?us-ascii?Q?Q+buAanYmG/4oyUzljiv8gvs0inU01vgx0eg8fFvBCxXqarSdlnnpEV9/AbN?=
 =?us-ascii?Q?LOUXmls6q++6afeVru8pWs4sNv04R2GncTOBo2sSGo5hr6VaH/JY4g0VhmQG?=
 =?us-ascii?Q?Uaz2QAYnlGg3BtqO27VfuwSG56f1jC6zb58Hxhxj9z65cpnEyYzR6ZeRxOX7?=
 =?us-ascii?Q?6meR432DRuTOiB8WnGojOXIfmh3dj4MFYXJ6MirGMBm8wN6gFILQM48xExkd?=
 =?us-ascii?Q?8h7OhVXfeNvpHjifyeWGVF8/rE4MmrpvNVIHaEvMvoRU/onmpHK/LLAMK2A9?=
 =?us-ascii?Q?t/9nSPNsJxQvhFnQyMn9b6xbaUx19KUeo4v0bKpJmI9LzTuACvwWEZniVU1A?=
 =?us-ascii?Q?xmas7xQpgHr5/K4dZzK+2nZ2z4pDQ0Kg3VuZzp3SJWHl/2H2td16lBEmZmG7?=
 =?us-ascii?Q?OGNLXjfip4tr5AWQ//nZjgQaBF3RxkooOvRfCd79dmDaDQzGesrsXfP6sSvW?=
 =?us-ascii?Q?43tv7t5TowgRQQkd+3miecb8wzSuiNJPq/QiHCC3/Fe4yQ3HRuV/1QkLqa+h?=
 =?us-ascii?Q?pADw7lIOmyaEyERbcf+T+ujb6VmfmoxqgaP4sw9vjSo1KX6Wl8OvJSlzbEnc?=
 =?us-ascii?Q?V94LWRwYlmk9K5Njy0gMkwFU/6H1gSZ7Slu/Gee4CAMLE/Se4c6LnW6+D9F9?=
 =?us-ascii?Q?z7Z3oIUi3F3PJRepitufuOAUn2EWVgwp8WZnvqcHPVtFzdvf8t/Xz9z3dd8O?=
 =?us-ascii?Q?+C1zgxHq5qMMoWay78RuTyhp2+pzEU3n2pAxfrn5Kcfzu11K6pWNZE+RNGe0?=
 =?us-ascii?Q?xpuq7Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154e2cab-6d31-4ca5-a2d8-08db270569d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:34:00.8572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/Vo395nH8SaE++UnrnBRrrN5lX8FukIwP3wdKxEkftWX/v0gC9lZCuVHqvSXywpM4BDExUPft7BOCZ/qUXQqfflVO7kEsnd6jVaqSHs8lI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4954
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:32PM +0000, Eric Dumazet wrote:
> We can change raw_sk() to propagate const qualifier of its argument,
> thanks to container_of_const()
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

