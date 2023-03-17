Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5E6BEE6E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCQQgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCQQge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:36:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2130.outbound.protection.outlook.com [40.107.237.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126C326BA
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcIY3EQMvqxz9hghLPcsAdFVtYMEMay8a4sCHg2UD1ZU85TWwH3D0TWkHSSBCBLembSlZ12wZC/fp7Q6V+sOpCro8gopHsyKhk7DAgV09dwIvbdy+mbEj7ZaWVH0QcfcESLE9xPgCns7CsFToNh5oRpmpi8Nbtl9zlE6BExsdSkIH5hn2LrBUmhFVs1Kh/AQGQJLkMf0C3xnHgbrKgFLLOOwhD/msK/9SJ2ylgyCeyC4v3sCc2D8NtKtWr1ZN+2Q0GH/CR9DqA9JIPrNzwRGZFpR4EUAaKZdHLYMBPKRbKoPU55p5ERQwyr5OMB6o7IDFEFIKmjDnWNDv/q2zpQ1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Z4wg4/omNn2mTfh/10LNvaHrhaLtX8XK7iaeuPtrfY=;
 b=nnPEB5gNjn58r+PvnGjAB6EIFLdecfu+upk92BbRnVPiibqmAhxO84dlTwW7M+qX+cAzM1HKzqWD/HibHol+vJ39LONBCEGn7l7eE1z3S1QJ4etUnQ1HecVrHCQA1BdCovRVdVdkEkB5akjFt1Eu4y9VLQe3BemkAXj6otkwkFnawVWZfyCj6DwiJncKywL3CQnKgyEBRLzQojGOEF0MIRF0GQM51ZFXz6/j7CJSA8q4Rs3vH9Pg9Hr/OWZetGVrJ747JAL4AcjS2tEqdAOaSZoHnXF+8HGcZetLfBh0UjzYWupeh6BvDN6JWlYKvDU4+5/17JGdSF9bS9425XI2VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Z4wg4/omNn2mTfh/10LNvaHrhaLtX8XK7iaeuPtrfY=;
 b=DtquZbMFqjRdutMihH3+oztE/6+9R6UsOzE5WW3jSEofUbq8C8YRpZmBIQia1HnVhMK1CK0yfAMLFKICJUai+3PANfqvNszvGlQKxe0Fy6QsvEarCBlnZSYlo+G5EpGfUyvbD+K9IGWInJWpxV9L6ZymLWMUJ8kFmZJPWw7srD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4919.namprd13.prod.outlook.com (2603:10b6:303:da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:36:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:36:31 +0000
Date:   Fri, 17 Mar 2023 17:36:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 05/10] dccp: preserve const qualifier in
 dccp_sk()
Message-ID: <ZBSXCJvIQYPEVhlu@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-6-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-6-edumazet@google.com>
X-ClientProxiedBy: AM0PR01CA0158.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d5d8aa-f439-4427-6628-08db2705c37c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymW0+FDbeIWA8XE405Q8iNb1aYHmDpl8KqgMI+ZNpKiwjuhI4Uy+KAvqo4N8HaBD2o+MNUvM3z6qbBMR4BMsPDcFv6cJPvVwCpm66ZF5KRuH9YHu1JqfyEdXY7s45Qag7ggUs04Gn6K/9e/18Vr1EUTgAF/OBu4RKD47o9oZSWJyFVmhobFI6ztxEVUBBpqt1wtRiY83pGNM0mL5cRo8BZeaNKxdzQKKmNSbFYZebAv57FL7J0HfqdBdulF7jYEDcO0JLGmagkQGjtu54gavPc5s3ZAlRBs5PZXHJPOstvYVjNGHQQlYwBocffX8qsgX7WvJvnoD+e7iyjJ3Fu8v51pTyfbSgLM8RVtdbgCq2lTvONT9FIAtImxkTIkmxBgHckyIktpjOtz5BCjUDEvoLYWn6HdhXMHZh7MXBVjZ84HAov967SFmpq0oOh/goLWo8rZPy7nTKUxj0FmP29G7qLYgeoe2pNjyDzkJwGTHZyzfZsgg4YpOiwIiCq2A9bqIWc8q+YfjGsgUS/1g5hU7kNsABd9Crp4kEiQa+VlW7tmIn044miCnJ1A93yn4eE06YvRkK2KKh7loN8nSPgfz9CdKhui7P3ppmVufqiHP8M1pjaLAH+9+Dmr0gzxy31loqBl+C1XmPykbIh6KcBJpHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39840400004)(366004)(451199018)(38100700002)(86362001)(558084003)(5660300002)(36756003)(2906002)(44832011)(41300700001)(8936002)(6506007)(2616005)(6512007)(316002)(186003)(54906003)(6916009)(66556008)(66476007)(66946007)(6486002)(6666004)(478600001)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yfd3+0qr3F/YHMZMsj7kbXNr/BRgU87FKKlQULu3GVgJ+2aNl7pvqIEBbEvM?=
 =?us-ascii?Q?o3WKeVmlyYUiYxMhHSxUwgJW6KaJkBRhv4zNXrYRtaElJA0hCSr9oLOD+YFH?=
 =?us-ascii?Q?+hUPIWqIjqpwPTlpToVt7QcOOjyTBa2e4vD82LlVkVpXiLwAY/7ykM3a5MDn?=
 =?us-ascii?Q?sBPFGIsdnTiZ2DWbyGRyvOHNCAR6TSbKt2h8pnLjUtAPzhcwsoeeCFxaxtUu?=
 =?us-ascii?Q?GZ0QmSBfju+ZHjMqvXpGh7/mcWUIohaQoWDWiasjs2wSQALdBLRzQCE9R57M?=
 =?us-ascii?Q?4FGpBZ7DO3Ls+ydz0dtWdpGjD5TCETGkl25h4dkqz7AdhJwKyCe9MqQlM2Oy?=
 =?us-ascii?Q?xOSnUYhvLTj2UnXJVMBh5aBhvFPBJ7mOUV1m3Eec7kXJsPp5Iy+UivlCmWhr?=
 =?us-ascii?Q?hdKaUd+4yVw8OsNcvZxnxNGcToxOCttRsWvI0TCNxpfEPSCtnzrUlRHbOrdj?=
 =?us-ascii?Q?6ATUCpFLaAxfh36cdAsNebcqLDWpA4WgY8xYjkvUZ+zVuUxsIUvSU0VjJxRS?=
 =?us-ascii?Q?0je5FYy1kOzuC+iflldo08Cob1PVL5E8xNw+w+/ZdOBg7605kYl6kGYgb0DT?=
 =?us-ascii?Q?UJ791wx6Kfd4+WH67T4tWZs50S0sTNudpIfuSeo9Pv5pX+0aB2Gwb6EHSZio?=
 =?us-ascii?Q?op6iveGY/bB/A1TytGgijoifgAT4hUfEPHcH8yZ/f/ktE9B437GgiYczXgZs?=
 =?us-ascii?Q?dLA+goN/V1oQQsyCHWfTozYriO0gkN1W3wzn4BlSPq6K2K7N7aHIK9gBwE5d?=
 =?us-ascii?Q?dkvkInfrYXr9YajW0NvlNLf1ui+GsoF/78q62iG/9lePbuM8y2RrZwNR6X1Q?=
 =?us-ascii?Q?Hy3gauLlYKAbcbVBVxRJieuuusoE5fxkSq+VD1tenVYgR6fnCmpBTmyJnCJM?=
 =?us-ascii?Q?5HDAhIZpXDV9WB9V9QBslp2O0Qc98AeJM619fpPXlWJbkH/jwmqhnkRIhtfh?=
 =?us-ascii?Q?8LfpTigE9yQoKTPeqp5cdx3wtNnTzffepJ17/QD1kYueApFCkeC14TtjR94l?=
 =?us-ascii?Q?lLIiU2eAZVcloZHIgEd/oGem0Qb4+Z2CfX9PeBWzeS1xr3HtAnmvmrNeLVSp?=
 =?us-ascii?Q?pz1bAbiW4DjdTClxWXhXCLgaWaarQu0tago7cvrDsWouDdEFxXv7PDXkngWz?=
 =?us-ascii?Q?x+6P+W5LYKBs806z7mz7VYzkl8WMAFeuSxvsmUswP6jpM9teFJs+KpEa8kad?=
 =?us-ascii?Q?24wzgxD5cU95AqZU5AqKzMYJG4eXNbiWInooLVY32uLtOd58MKfj4kdXakSi?=
 =?us-ascii?Q?YcPA1ET8oSzc8vavpwxHKCst5IKtuVrh5HB+B54hzZWhnHAKvkrz8WhxXyFj?=
 =?us-ascii?Q?cM9ZzkLvtFDW6YlrIOOWmSrfmJ+MwoTl/1xEjbe/xrJJaFXzY6mMdjsZBlZM?=
 =?us-ascii?Q?ql9Q8fzq5D/voNSbPMTHZsXTL7V/uVw58kSWuyPl6XKHTnRerGW/5AFGA961?=
 =?us-ascii?Q?KbrnuOTGn1Ol3iiPpYJMTRWW499wB4ToT1mnBTucbE34pHubmMJhxMtENUru?=
 =?us-ascii?Q?N8yKeV8iOvSQEGjuL7OCrLB3fsrUcmdj9yednJ1BjwvcokeTIjxKMV8rIclN?=
 =?us-ascii?Q?6fNuA9nnDnNdfrcm6bpxcNeVDD3lv6XLqvx1njNF7/afFOh3gD5ZLu27rERV?=
 =?us-ascii?Q?qzq/JsBf+s18bPl96IT2lc9Y6f6/GxNhHNsC7zz5KSv1H+o9EzwWn27df/os?=
 =?us-ascii?Q?pbfP4A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d5d8aa-f439-4427-6628-08db2705c37c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:36:31.2647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxCQDi/YWv1WN/61EB9jLuQAJwKS9xxvUhqOby+vIPx2qCS9VC+yby4RwvGlP2FrRP85t2C1bAgrIrMtnuTfDI5ig6KRVHtB7h3XCie41uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:34PM +0000, Eric Dumazet wrote:
> We can change dccp_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

