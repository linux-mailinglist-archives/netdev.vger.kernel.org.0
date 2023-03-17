Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D736BEF2A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCQRGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCQRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:06:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2103.outbound.protection.outlook.com [40.107.220.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192C03BC4C
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtdy0Xi6AYEpmIqxF3MokKaIb6T/LKp+osd+YpvZakFSPEdfEKItJ8ej6sjSdZ6SU/NXmET7fzFA3Bfhqxcrjid/28tD1LZnVj2Be/FSvlG9R5+J6klZk+uKs+SpdaPXPh+RQ4NPXW83DxnAp6mmOXyNqpH1xBjIq1hQwgAEyKzwsLAIGMhCTau6py7y7XqY3PaY2ZSp5hYFeInwPmgBlEQlsFNgGEl60DhQ5ajveVfxl+4NDjlHeYQgNANmyHbMZa7yZBy3TdUBvWsnK6sHiAN1OoHMY1/bOvLm/Lr3rTW9y+e67Ykjw7IPFQRqWNXV0Lcuo+aJlipxZ++Gx+oN5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE37txU7+MBZD7YY38rGWnPyFpWF0fO4JkGFMFzhAVY=;
 b=IMfNq8VSjNePKFzOguQw46RNNvE/8c5oEq9uRdbwsVvqpYqCaOritliFFf4YuoKJOanIGbdBzOYZbCe1cfrnXCPZKdbG3inyFBbgIdFtYIXrm0skJHlKscqSWH+iUD9OBmW0MLzv/aYXBe2oJHuSUcT/HFNeACrrjdm40k9lWeyAKBpCSf6QMvThTVLiQzK3/qVIrYVxzqk2r4y8V2OKzy/Knj37EsQ+iosT+/OISyQbqMLYUAyOQ4NwsIujXDEs+3GiFf4zjucK8TSjH/ss74B+79hhiYtDOxK73I0lHqRBHF1/yvZLpxp6DsFcpLDwueFznkPSFBlCxGwYz/aibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE37txU7+MBZD7YY38rGWnPyFpWF0fO4JkGFMFzhAVY=;
 b=uZjBQKeD/Q7cHcnOcPomt91/niLujIiIO/NSwaw7pqDSYhpax4RqDMMzXJMkDpn2KS1HbqPHwySnUdB09l+xvffEAojoyREHgzvrT+SjYzHY9m6z7FsMcYZnrgYM6/U2c+2H9zj1lt/popASB+MLCu/znt2GUTo7cYuGVSB/Zuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5639.namprd13.prod.outlook.com (2603:10b6:510:12a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 17:05:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 17:05:56 +0000
Date:   Fri, 17 Mar 2023 18:05:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 09/10] mptcp: preserve const qualifier in
 mptcp_sk()
Message-ID: <ZBSd7bnCz+caQDiH@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-10-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-10-edumazet@google.com>
X-ClientProxiedBy: AS4PR09CA0019.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b6657e1-428f-47d1-d6ae-08db2709dfb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+9jhIDV8e5hYrmJU+z/qcZeUxKg6Fo3BWzzBFujWEhUwCoGgP661BRIUSf7GZIMMxc6bYTNy+xjnOuy+cIjCeO492ukSB1hBHLco9WSUw0TKwnwg/xOrbjjZ5NwiuCtCkbKOvLMJ++cAhA4Yefsgixqhjw14TSDC/sRSAaKBKQBOGFg70XBvy8OOrf51FI5zZkTL54Q4AKblsaDww60MBPhFjpFm6jvQa/MqBW7fgOOXNrhK5s++dcCZOS1IJyX+zFFTWVuPpMjmQkFSl2zjdnOrs3eVegy0/rWA4LDY6PrGQ3qbVM/ONZA1R4Z6ltvyKRUBPfwuaeXbHNJWQTUCqvfpKhIoqfaUWMXld3UxlS8LyuIi/v8aM+iKMdfMN79r81tILOCZwdHuPPGoZKakDlmxTDxrBG3qDHjRUjlHeRXNGusNGfAq/TIi7eW3RtzeQGFoZ4smGfTiC2bFqBqx4cESD/SNXHoDKjlINpcADcODlVP5F+Bsd1qoga2hRxsiQtPyt6xmMxRVojvczy9940XxT0v3BjzyGyItFREWiQK13gCdV+bHPcpaVKustsL7h8GL2JkLY0/wUWeo2JMrLsuePAILF9mSSRKKVgalZkSaCx27/6rSnHeQ7naoTHMLtP6z/79qRDCMq6nhG2kXLTBNKoYYOJDiljJf/6AfgMwLUX4PBfb56er164TgcrYNcdLd5b2McyG67wFfc4PluFG3wg3/+MJQUuMFZ3qCnBiYU1ry1MCgQRSEdTEqkts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(396003)(366004)(346002)(451199018)(2616005)(6506007)(6512007)(6486002)(6666004)(186003)(316002)(4326008)(54906003)(66556008)(66476007)(8676002)(478600001)(66946007)(6916009)(44832011)(4744005)(5660300002)(2906002)(41300700001)(8936002)(38100700002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6uUH6vrfC+jxa44ZC8Hk2JKhB/qEOXVSAAqjeapWErmPe4ReNQjLWXTX5hJ?=
 =?us-ascii?Q?2oODFmNdUNVVfN3SlE12+DL9S0rzIV8ImUK7s1L6p26hBFh72wVwlVi7gBxT?=
 =?us-ascii?Q?l+NLGjPBCCIxjU2wuiyRXpG4rm9HH6ImZC+7ReLLcakF7GHvlN50tCLRKvnf?=
 =?us-ascii?Q?NQW2Cad7oOl9yvQbckNnS1KjSk5Xh8rnkfKHwGu2Jt1OEbQ9uiyV2C4gqvMA?=
 =?us-ascii?Q?zXSNtVAakZGODMUHLCq+7QrhNVnIgOCE8O6JtcwtDk7usaxJs0hV5rN03/W2?=
 =?us-ascii?Q?cBeQllaCwoskIv76QNluQoY97a9Ogs328Qg0QSQEbUHNbag++7v0uvqaCP6Z?=
 =?us-ascii?Q?g4RVGpfnB1EpYAl9Gj/XB2EBlr4gfn7KNmTPZ8dhp0WAMsh8kS3wdInoA1uM?=
 =?us-ascii?Q?0ILbfJhVywerrh01MHDM9Zt3FzN/ZCyp2lRs2ilscSxsns1pneE+X+1kW2M8?=
 =?us-ascii?Q?AcNUXADx+j2KZJ9ULEXDR7jgZ+H+svgF55QmOfcSp1L9FN+erUu9/nIAGlEC?=
 =?us-ascii?Q?oFF3xfQKpaACXMZ+dD/JmZ1+XMYS6vFhrDG6qHr7i/ovaezRfGKaotk+WPOE?=
 =?us-ascii?Q?YcTI7P7Ax8RcceJXewCLP3bQn9IqQW/75Kde4QIMySKjBCOwrYOzWjvV/CP5?=
 =?us-ascii?Q?rSDOWqYTRhv45dDB8/HsuAp/kqVW7e1wane2EtYZ5hxAj4ijRjMtzBUfH4SF?=
 =?us-ascii?Q?AI535p7yCrsD8c0D1gdZ4zdlTZWUM6F9LEaZHFSYzHdypCG7rEfNlpEpJ/l6?=
 =?us-ascii?Q?4VjRb3zzMVd2CwD9BZ/D/nlI3iSV5jvYcpR+rvzHXUI9ZmLIObNLmtp7aH4C?=
 =?us-ascii?Q?B7dH3hAdekTKVmuA6yagRie9q1VRXzY2jwSvULKOdHNX+7OqJmTDhmHWwI9R?=
 =?us-ascii?Q?clh4YEbGZWWC3qpFsccqnHhSnuS8EY6DE8GWruWfjI4FWG2mEEjRo3GAMZSN?=
 =?us-ascii?Q?g3k3M5meyp7qw1mfQia2IDEJJgCHscDhWWy1GwGESGuFHfRezc+NvoxI3Sa7?=
 =?us-ascii?Q?bMIVptUQrfIEfBKndCCJ1cIPYwfv7FbfGGnpsHXml3HwplCgHTMZ2EMfnIdB?=
 =?us-ascii?Q?nTypEB9di0yaxW5xAMBIBoNqqNDpJjjHxXw95vZ/dgzfFAZu4Infkaymi3kV?=
 =?us-ascii?Q?xZOTxzpyPoq6ec02mUk4F1pIpMpdjB+VnhrZqjey3UMc761SocLY0HOKrkry?=
 =?us-ascii?Q?LENAec1qdujjNIQbaQ+53AbaOVR4F3sM2t8VOwcXFGPqk1r4vbI+pieYxuYp?=
 =?us-ascii?Q?12Y8nyiKwuF30BZveLwKX/t3hOg7MaDK33kAdaEiXU2WXpWrZUShHK7HY5uR?=
 =?us-ascii?Q?MGDN500xJP/I0eVAvSxgdWaWRYVimx1Ht/Z+w0d2roDNSLe4ci1R9dI0xSJu?=
 =?us-ascii?Q?nyMIbxtxtB2sKPB9xupN1jHG6rDSjt3M29t5qmbE3ecf4zVzs0GN703//MZy?=
 =?us-ascii?Q?YMYwc7pEWzY2OQl+CbgPT0Y4PH1l6QwrhDP+PQaRT0cUTXguOq2NzRNXblBs?=
 =?us-ascii?Q?4cseUFApQPN8wwft97jnDCnOtjD5y3D9VMo2hBrsQjqL2fytuvO28j+wC8ij?=
 =?us-ascii?Q?o+GqgoGLPusXMiUrUSPJKddDKBsht357pmQcVrEct2u2sh+1DBY9TV5F4qX3?=
 =?us-ascii?Q?VmR65fjWKRAAALlYYRvljmc83mUGwvAVqJ8brHz1xanLf/uk+ARuMeu/0wvh?=
 =?us-ascii?Q?LILrRg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6657e1-428f-47d1-d6ae-08db2709dfb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 17:05:56.6061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXYD+UI+f2RdmzUaD/OAm9lmvu86CViThBDupsavS+wULVKJDsspePXh0NXFbpO+/6ZtG14uemGkLAnLMT2SwBsnZcuHfE2Qg14dTRC9YWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5639
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:38PM +0000, Eric Dumazet wrote:
> We can change mptcp_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> We need to change few things to avoid build errors:
> 
> mptcp_set_datafin_timeout() and mptcp_rtx_head() have to accept
> non-const sk pointers.
> 
> @msk local variable in mptcp_pending_tail() must be const.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

