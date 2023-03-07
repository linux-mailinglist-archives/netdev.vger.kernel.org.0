Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEEC6AE549
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjCGPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCGPrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:47:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B0E898E1;
        Tue,  7 Mar 2023 07:46:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtu0mGQZgjOr9DfttsgA5OOo2GIfSsqkU7aoHOI2XePr3erg6tq6UB6tvISBnP1dbcU6T6m1zo6L73UT3bF2U5i46jUPe5jTPlha8quipuBcdMP9gWMG1snLKVkhyu8cSzNHceCqGsnJF9ZqBtDEdcMNze86nGNNfNxMpqxiwGpcEsL2HEuIpWcCW4mjm9f9SqACac6CHDfWW2LT7z0m87EWHmeiaZgg5QcS/zkFOE4CM8EvRm3epel9MjW7pKUuFvwNQGJjggWoO6wOJfMMI8SLst5bGM9Szku0z+lz5iWDDPfCjbg0HLFk3j5qsAhrDiUtraO0tzsCzk4xxxb+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bO5LXGB9h9+OnuGVrTrBZWgtMqJB8wzHNd3l/9CO4IA=;
 b=EXGNRYXIrsQ2rMWKicU3eqFUUXfCVMxUI4jg+ksS5QaIgoHCq8wNQ6vl+SBBeC4YEwlVcBmVetjlRF/ElOCHRM3R0ha2VCu4sZOF5balyU55sF2zwoBvTByFpw3Ba2XgEUGS6XMoxH3PcHb4vdKP5ihnxCwDk2BFNeOKKpxOX/ATxDfGk2BiS9Ytf3VgsIqlZbqSvlmKfc8/FrwyP/xqPzE+r/EWBTBIueXarDrcK8pD6SsLJGOX2fkbLjJMDQ5fWq67t1tMO7K2QCBB8VgEEdWO9n8OBiMInEsGkZwQ8aA3l5hD11YVcV+66mdOnNaeFzMgexWmXO6w3JgOZxjAtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO5LXGB9h9+OnuGVrTrBZWgtMqJB8wzHNd3l/9CO4IA=;
 b=DSXvxGeC98b0zQwfyoLBzheUczreL+VOHhoxNIFIupmkn8SLXDm4GPbH/HL+eIM3NhNzCGKNQwCFOCrTPOlPhShhVniLy9zvJ1bDsQEOboXpJx0UrTpdNJ5Lm7po5pIsjEAwJwtjk46rOjhVUwy7Ywih8N/7q9NapnxYamhQxtA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4685.namprd13.prod.outlook.com (2603:10b6:5:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 7 Mar
 2023 15:46:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:46:07 +0000
Date:   Tue, 7 Mar 2023 16:46:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] rxrpc: Replace fake flex-array with flexible-array
 member
Message-ID: <ZAdcOYUloeb2Echh@corigine.com>
References: <ZAZT11n4q5bBttW0@work>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAZT11n4q5bBttW0@work>
X-ClientProxiedBy: AM0PR08CA0011.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: cba1eb05-95a7-4d8e-c88a-08db1f231149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6e52MJZvig9YFhye5oYJti9isfL7sxNMXt2u51eSUe8LTRfDyMQFmcPzEHmCycrQhzHtkgWj0ERmIWk2ZKxjaQbAnjFL2p9c0OZTS+NvY4kaF4nTq08PMHU++gNVuEFAZvAQdowub9fdH6XtRyfZ6WKxhw+6ftyF5kc1Kh6J3n+ACUaZ9Wch0n5T/fbesf6QCfN5s2I1h+Q2tKjifZaU+VGO92VufOJbTTClzwFN8wRFY6hCAZ3ve0Yg8Eri5OH6qpedqjVhNSwrAojKbzml2Yyujz1B3slR0DLc/2Gp0s13EGizGgRKYDURPv42cWuzsRRaBqNj9IJq0PiqLoDZ8augdhVJRUJ4yQMyw9SFsPcaTm7ek+QfFoojPdr4zPzM/HI0pHn+U45MvyInH3cX2UkFSQZy6nkwQ392Ao2hEiXzZTV9Qj9AwJMoJxIQ/GytOhIJQw1TPUc0TEqpN9H0Wjb8bUTs/nE3dqkvo3ZXEehxSOtELKDQJ7ZyVJXx/sOVa4bOF4wCX0hnufw7x8aNz9CEjc1jw4eu32beYfDQ0pO/k5cjH02koEyWJGRkIz/1kI6R0IfThUl9yrPJSEN1AE8IqS/LfRMGyb4NJbl7Ji4+9IeO1mAsqL1+DWCY5r3Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(376002)(136003)(366004)(396003)(451199018)(36756003)(6666004)(478600001)(83380400001)(966005)(6486002)(6512007)(86362001)(2616005)(6506007)(186003)(8676002)(8936002)(66476007)(66556008)(4326008)(41300700001)(5660300002)(6916009)(44832011)(7416002)(4744005)(2906002)(66946007)(54906003)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmFhcEpnQk1Sakh2R0xYMTZ5Y0I0U0VYbGpscmRvZ3Q0ZWdOV3AxMVNDVllB?=
 =?utf-8?B?aUJuNDdONHRsV1BPYis4SlM0MW1zbW5oeTBTeXhWTldobTYvUXZ6dW84Umkx?=
 =?utf-8?B?R3UvRjErdGNiRGVTNC9ncHJOZU9oR2xQc0RseHpVdEdpNm53NkxzMmdWZmts?=
 =?utf-8?B?Tmw0cXN3UG0vWldacUZqNUdtc3RpZVRhcjM0VTY4WXFlTlY1b1Q4RHpKbjZq?=
 =?utf-8?B?VFpoTTdQcDJwSytOK3JKUGR0TkFMRGJPVDJSUmxWT1RVa1NBNUZkcklVMUpa?=
 =?utf-8?B?M0F2ZUs2YXc0aDR4OEV4THptU1QwUjhNYk1wNDlvcHNXL2dsc1RrWVQyNFFI?=
 =?utf-8?B?MkhUeG02M1VxMHdGTGJiRVZkOWZ4cE9EdnBzM09XQzJlM2FhU0s4REhqNW0v?=
 =?utf-8?B?dXcrR3JxS1F6cURoWWdQbGtqZGJ1TzUzMEpKdjdOQjdmUkU5bllURlI3V0t5?=
 =?utf-8?B?M3llUVpKV3RTQjJGT2R3NWxBcUoxSG53d2c4OHp5djhZRzBxTHVYR1djRURy?=
 =?utf-8?B?aXNxRDNJSjFoZGR6NVE2dVBoNlFMZTJ1cm9wamNJYlFSMDQ1QUxzVExHR3Rr?=
 =?utf-8?B?aVNOejlOTWxqS0xoYTMzSGMvcW5Id2h6Q25NQkFjU2tuSlYySzRhekNSYW5K?=
 =?utf-8?B?b2R4ZUJFSkRHRFpEREY5ZjViVkdFWndSRUpSZmFJN1VPMmh1N0JvUEpQOEN6?=
 =?utf-8?B?aTBXcHRGV1RQaytkVHJVdXlUdzk3WmNPcTFxekdTUWM4SDBzbk55a0pYZTEx?=
 =?utf-8?B?OW0zc2NVQ0NXQ0w2WURIWWZtc1BLWmJjb0lYQnpvTUhFKytydFFpZW4rc1Nx?=
 =?utf-8?B?M216SS9Odk9kcjdvSkUxbm9KanA4ZWwxM2hhM05oNjBiUzZNSFhOQmlzeDBs?=
 =?utf-8?B?SURxODV3SFZ3dFEzSDVRcUovd0RsNnZ5aUpDMVlrOEhwc25rS0hGaXA1Mlpt?=
 =?utf-8?B?dkZkSXRPT1M0MWVPS3huTnd4eGpLcUVxNVlIQ2YyQjNwQnZrdm5ZR0ZEa3ZH?=
 =?utf-8?B?bWJjTWNBMlVZOVNTWWNtWGJxY2lLZkJ2VUI5dDhkRlNrN2VrL2t3OFVMOW1a?=
 =?utf-8?B?TE9udk1EWFI3QWg0VFozbDBReUthZ09lQVhDVWc3ZXdkUFRUWWprMFh0QU5x?=
 =?utf-8?B?OE9CY3hrSUNpM2lNeGR4Y0ZYb0lZbjExZVZwWWV4YndxYnVWd0pUVFBBYk5o?=
 =?utf-8?B?RUdvYUd5TmdZVFUzNlRpQVE2aEVLclhNaXRrQWpKdDk5dHd5ZXVsRDVyMi82?=
 =?utf-8?B?K1pyU1UyaGs5bzUvN1pFa2craDV6NDhiK2VKbEpOaC9ZVXZtN3p2dXVMYk44?=
 =?utf-8?B?Q2Q3YTJGRmIwaVlLYW5pekJGWTRuZElIN01hcC9BVHlUY0FNcGc0VTB1c1Jy?=
 =?utf-8?B?WlJYMWxWMUlaZktMdE54TkNWQlVqMlhKYkpSZmhoaXQ1V0R2b3JOS1ZNUy9I?=
 =?utf-8?B?U2ZxVVRkRDFjS1ZkSE9QUVpQaWhqbDRFWFFvVzVPeXRpZHp4NVhuV3FtMWhZ?=
 =?utf-8?B?NzBMcEhwRm1VRm9GaXp3cVloSmJrci9kMENDU2FLMHo4eVk3NXlmT1F0YStm?=
 =?utf-8?B?eWtkL0wyYTUrVTRoUUhlWmpKOUJiTG5BL1VRVDJ5Unc1MWdVem8xOFdRK3l5?=
 =?utf-8?B?Q2J0R21QTnZIeUxGL1podkNSYTVCTlJuS2FSdDQ3MnZjR0dkWEtBeDFyTUJH?=
 =?utf-8?B?R0pZSHM3dXlLVFIzdXc1a2U2Rm9USXBEeTBzS2ZuYnhndkFqYVIyTlQ4MEQr?=
 =?utf-8?B?U0oxRkFtTGF4aC8wU2p1YXhxRUZtUkg1NEVSNHBWSXV3RVYyQWlsTExSaDZ2?=
 =?utf-8?B?UEU3LzkyNkViNDVkQ25QMFF5REFQNVlzR1NtcTJ4SXRucVB6cHpLeVd3ZTFY?=
 =?utf-8?B?R3ZaSzZ4dEFSYjBaQlRFWUxOSjU4aVVCN2MxcE44UU5ScXZ3eW9UQnp0aURj?=
 =?utf-8?B?RTEwaXJpd3F4a0hGNmR5S3Y3MC84a1ZXck9nQ1plcStRczhpMk5mL2prWlV0?=
 =?utf-8?B?NFJjV0xyeFlLb2QyQlNyQ3dZUVNTWHlzbDFualBERThJVEo3UjIxbVkyT0p4?=
 =?utf-8?B?bGJYY2dXMzgwNVZKakNZM3FibE1LN0szQVFjYlZBL2xEQXVhM1F2ZHMrNWR3?=
 =?utf-8?B?KzFsS1Ntb3VSOHEyQm5XM21GbHR3WlhDNDRUZXJKcDQ1bDB4bDZadG5SLy84?=
 =?utf-8?B?RzFva3VDK1FEVWFuZWx2ekZ1SnlURVJhMWZSdzFGM3RJcjJFR3p3Q3JEM1Rn?=
 =?utf-8?B?TU8zQlo2dXFSdFdCNEpTVTNXeWlRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba1eb05-95a7-4d8e-c88a-08db1f231149
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:46:07.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKjoqiS3Dzj2Mu0CoUy3hTIx6jxqsUFXSrf2UGixqak4XjKKkWk/BzkGrCv176NSl+AlJNjyZ5ULZRpybhgJNmaIu3A2J5Oy7w+RKaDvcGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4685
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 02:57:59PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> rxrpc_ackpacket.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> net/rxrpc/call_event.c:149:38: warning: array subscript i is outside array bounds of ‘uint8_t[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/263
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

