Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234EC6AC077
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCFNMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCFNMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:12:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ED42C67F
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 05:12:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbm9XEBfK57cjfGypunfpDNRie/WXxKvf2xn33RM8kHqvpJaBcO4JySTlQPhmdTzPi5E1vW8tx6PtY8a71JQ/hW5N2TN2EhqFRInUHO3XzSxg3P8tRB1Au18NxgKUojSV84bCZ6NSaTQNn8JZgY+gLIyx7ricHW/cJbHdvyGYGoWxnc+1EuAOLRDkTkz7dngUg6+zUf/64rsAenSlxcTtwowfpH8aGUHMB5gDzYDKatSHiKBITxCd74x8Rd79tSRaMTr20GvIviL9Zay1J//C6uUMFZFYTmeoER/z0oag+fIpElxSowGN0q0dwlEModq+k1MNWPiG8SZ9qxYIJ7vJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OA0es0kV9b10s/BzXW+ShyjWI9BzJGjRzMEW5PWnXWE=;
 b=V0QOcGez453aCJWrD66dBZmIoOrQh6eeEIfxuWuPYKq2SYfkFLomfNuVla365S42gfOEk0ZWLrW+H1SBN3RWxguKX4QD5lAKf9gmK/s2T1rvsCNDNMeKCDxYA2mDntlUQS6S3LrCmAztdqT4lcBrDS+TgNT5pqgts/DLkq+46qNbzzqiWGSTG3pGhWnZgZVC83XOQeCUkQ3d1UPsIil2LwMwrxgPwS1U2IIWdzbO8xSZ1Dbd6QbUc2Tjv6UhqVBpJ4oZxO1OTZJ8ct9DTymLEktopW1oCpRHkQSmwjFQ4j81r64SoDbP2Xk0g8UpLP8P2x0AgBBMMSl9uVbS894Ydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OA0es0kV9b10s/BzXW+ShyjWI9BzJGjRzMEW5PWnXWE=;
 b=GepHPXn2DI5Cx5yAioB0NNPnouHiqpyxfacC+QzhMLUk2CTtfTYIHenolq/WWiqy3RKRpbu/AQ59ge8Y3lUwO0tOKFL7nis0mcj8aXr9ooaoJn255n4ET6p+WTOYtGhcAlf+d2jv6n235GVbchVn22DG7K40gdqPy6vWVo8zZP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6224.namprd13.prod.outlook.com (2603:10b6:510:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Mon, 6 Mar
 2023 13:12:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 13:12:02 +0000
Date:   Mon, 6 Mar 2023 14:11:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@intel.com, lukasz.czapnik@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net] ice: fix rx buffers handling for flow director
 packets
Message-ID: <ZAXmm4R6HgiKXSLh@corigine.com>
References: <20230306102024.1375464-1-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306102024.1375464-1-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM9P193CA0014.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cc1695-9078-47f3-8088-08db1e446032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SfMoY9YeSxY97JMLaszlwu434cjHrFBBKq3It2AN0Nd/Uz58X1Sq4dAGSQN/h3Q7bZ7xaqgC2xfih7VQPAXDRwW183dpjmpS9ll86wVA56Z6FMmG72iZGlJS54NWO1TCVso3aJsbwb+jP/TRol8pceNkKsvAKiiPr8JvOBDKn01qjQW/nCN6uyMwjNMoZjV7Su6ysnY7kUF4Dgv7PiCqp99bSSWIqOw03aZPVfa4GDgyBgEcFanyWQxrAoTCfqFrYGk8eJMQ2hvitmK+ul+iaRpSKxdrffpQUL6ycgoRQigemqNpiulLpnKjnCPdQyizqHjlTJAgLTUKHKvB3YfRmTUvEnPWrCAa6AsJlK/SSyHbP2C+giKiIXZNXPyAILkNA2q9A7ORS/YDdMhQsolvJsHv/EqtBlnqSo9FUFrO1RuP6jiMm76AbtSBmLOEiu5WPIwwdY/ZLLmB5IipF6wl9O1gh1DBSexyuqeOVYmFeEVupzodkRh+i8PaPrWJ/eD/6W7QF7/Hz/jCClWxlWX4BQuHexd/osjXjX5F/81klqpJCAQxYP9bWQcETDVUc+IP3SPFu5avXuqZk8rq9qJwn/Mwzu5CFXopdqBBqz74qJ1Qjw1QfJuZKnw5IG6502XmAKlJIfVTkr9sBKgxhDLzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(376002)(39840400004)(451199018)(83380400001)(86362001)(2906002)(8936002)(36756003)(8676002)(44832011)(6916009)(4326008)(66476007)(66946007)(66556008)(5660300002)(41300700001)(2616005)(316002)(6666004)(6512007)(6486002)(478600001)(38100700002)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HG3cBkLmP1KR0WAIIbbqTXfO6e3JKbMNTZjWdOpvH5T6BbJ4rQ5bU114QpRg?=
 =?us-ascii?Q?FfyV7387ogLk9QxerY4Lpw/OY1V0BDXexBQgi05bjWAl6POXEEbshQMfjLo0?=
 =?us-ascii?Q?fRLYoEXH1ov9VennjMuhEA0RdX0yhQ5TuoDzZyLZpZBypkiAnggxoLvQvd2S?=
 =?us-ascii?Q?RaLHpxuh2sYDpkomMCuryULB02AQn+/Y6UvG2IUa8CpXborhxvkKxBVXTNPO?=
 =?us-ascii?Q?Mb2NKLLef0mdgRBOtJKXvoVDNkc/rytn7Wf8bK7haVb/n54VZzf7Wz1iD634?=
 =?us-ascii?Q?oerUo/WGG8yBuQ5y1Sr4G1cK0URnLivEDPzWTxM+BuLgh3nbYZqQ8VNtf1Z+?=
 =?us-ascii?Q?ZGCCBNhjqFUKNEaSEZGwYvmZ/AWglmFe3CgoEPyiK7gSaQM2sJApV4zxNMOu?=
 =?us-ascii?Q?IcwAybcYh4fiw1ZPEfoUeILnu/PyoG0VlWrEvcUINHR8qXfG2wMHDIHMW0Lt?=
 =?us-ascii?Q?PWpAaL5PXNewOKW1aNiarcDSc0LD0Mg+80b0HalwxIiLGEbCoLjsyXAPVjfi?=
 =?us-ascii?Q?3P4PaqW1bfvEIMjVwzmbivrp0UKVaiNHRzNBRBTgb81aTLxUdUnAw+04dLfC?=
 =?us-ascii?Q?k5DxcvJXb9Gcsqw0y7w9Z2HtlMxFBx7x8NGg4eoGdwoaE2XRWReefyd6RPMA?=
 =?us-ascii?Q?M3RvkqMibcra1F4GreT1S8j0tKQURxAK9ee6ER+opIy+an0/x+2675m9bEB2?=
 =?us-ascii?Q?wRQvSkgE986w9f2ZqSyH4QPIr+x+qKjUMoNrd8R0ueStRT1cecA076md2jdH?=
 =?us-ascii?Q?SZ6RJIjxZqqhkA7ct4aI9PATJIIEHYKayqEK+AxX4pWg+/hKOaOoKkzeRBgi?=
 =?us-ascii?Q?iuMwGgl3FKNU0176gM/YnLy1hE1wxTHt2VNQHaaULQvf3ioikAFECHY5ZjDw?=
 =?us-ascii?Q?f/pfGsyLCLuCrbVijQxHYrENGqI1HmkvmGoT3ta9+WF+kKWoAHLhAUnlv35E?=
 =?us-ascii?Q?mequ710fW/Spf72QzKRY8kth9KfCnhlWB5lkmHWtqtRvYzhFYAeaL/VfPmC9?=
 =?us-ascii?Q?6nFy0+374wCpSinb/PEsPvxRnV9PJ7MMAXUy9JsxI15lsLkyHnWyzz8sV85p?=
 =?us-ascii?Q?EtG+sHyo36/pmh9FtPqJMknCaCmepe8uxFtKcsPlLp7eVBHQv2XyAbfBjIbB?=
 =?us-ascii?Q?qPZSlQ4WY7F/pJZp53hpoOAvd/PNl3hkoYOl90UFiBCv1UFT3cdXxnMrMjiG?=
 =?us-ascii?Q?UTkP+pOhoL4kLzLFUtf5pFIxtXUXQswDWyq8ba65+EIMaJZMiHtNlFFlW2RJ?=
 =?us-ascii?Q?8ww1sz/a9R2aCp93sQ6Pld/cHscrGCtdRHrCaCXQI/ZHWOKgDs7QmL/GiMQL?=
 =?us-ascii?Q?cAdJXgIHLuGqQDx/7hXqkeMQv7XTw1O6C5A379oS6noLA8iA7svjK+/Q4Clv?=
 =?us-ascii?Q?7G70Qe43myRcPSV6nksFCOyXGejAlqqUkFyR8skgCjVnV3PxErvniMcQGZuM?=
 =?us-ascii?Q?tt/ORKem0tUhAoJeIJculIs31eF2HfY9Vh27CUgpZuU8Sv2rahkFtauPB5tJ?=
 =?us-ascii?Q?0dd3JHF9EeuRL9PC8iUKPKy/83d4oBBV6f/BwRyIhlCPeP70kEVQu1YgYY66?=
 =?us-ascii?Q?wau1yWhbGnrst1XrpWO/ti0+r7KaYKaYtcSadmB7Ge0UsBeC2DWXtHqP94bH?=
 =?us-ascii?Q?IbYpizC8MlV7q09zj0DjMBlGcuO98IlPNZSyrYGcbt5+1gGfWbjl0GA7fYH9?=
 =?us-ascii?Q?l2OPyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cc1695-9078-47f3-8088-08db1e446032
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 13:12:02.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZURcP5X5s92mTkubQwf2+P6bmgjtZ+FCv977sc4OEbxxDJAhTjlYsA4nYMZu/MOfVv8plrmgLpc91hPUSVG3lh1Q/kei/3Pmf9XWuN9Hz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6224
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:20:24AM +0100, Piotr Raczynski wrote:
> Adding flow director filters stopped working correctly after
> commit 2fba7dc5157b ("ice: Add support for XDP multi-buffer
> on Rx side"). As a result, only first flow director filter
> can be added, adding next filter leads to NULL pointer
> dereference attached below.
> 
> Rx buffer handling and reallocation logic has been optimized,
> however flow director specific traffic was not accounted for.
> As a result driver handled those packets incorrectly since new
> logic was based on ice_rx_ring::first_desc which was not set
> in this case.
> 
> Fix this by setting struct ice_rx_ring::first_desc to next_to_clean
> for flow director received packets.
> 
> [  438.544867] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  438.551840] #PF: supervisor read access in kernel mode
> [  438.556978] #PF: error_code(0x0000) - not-present page
> [  438.562115] PGD 7c953b2067 P4D 0
> [  438.565436] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  438.569794] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.2.0-net-bug #1
> [  438.577531] Hardware name: Intel Corporation M50CYP2SBSTD/M50CYP2SBSTD, BIOS SE5C620.86B.01.01.0005.2202160810 02/16/2022
> [  438.588470] RIP: 0010:ice_clean_rx_irq+0x2b9/0xf20 [ice]
> [  438.593860] Code: 45 89 f7 e9 ac 00 00 00 8b 4d 78 41 31 4e 10 41 09 d5 4d 85 f6 0f 84 82 00 00 00 49 8b 4e 08 41 8b 76
> 1c 65 8b 3d 47 36 4a 3f <48> 8b 11 48 c1 ea 36 39 d7 0f 85 a6 00 00 00 f6 41 08 02 0f 85 9c
> [  438.612605] RSP: 0018:ff8c732640003ec8 EFLAGS: 00010082
> [  438.617831] RAX: 0000000000000800 RBX: 00000000000007ff RCX: 0000000000000000
> [  438.624957] RDX: 0000000000000800 RSI: 0000000000000000 RDI: 0000000000000000
> [  438.632089] RBP: ff4ed275a2158200 R08: 00000000ffffffff R09: 0000000000000020
> [  438.639222] R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000001000
> [  438.646356] R13: 0000000000000000 R14: ff4ed275d0daffe0 R15: 0000000000000000
> [  438.653485] FS:  0000000000000000(0000) GS:ff4ed2738fa00000(0000) knlGS:0000000000000000
> [  438.661563] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  438.667310] CR2: 0000000000000000 CR3: 0000007c9f0d6006 CR4: 0000000000771ef0
> [  438.674444] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  438.681573] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  438.688697] PKRU: 55555554
> [  438.691404] Call Trace:
> [  438.693857]  <IRQ>
> [  438.695877]  ? profile_tick+0x17/0x80
> [  438.699542]  ice_msix_clean_ctrl_vsi+0x24/0x50 [ice]
> [  438.702571] ice 0000:b1:00.0: VF 1: ctrl_vsi irq timeout
> [  438.704542]  __handle_irq_event_percpu+0x43/0x1a0
> [  438.704549]  handle_irq_event+0x34/0x70
> [  438.704554]  handle_edge_irq+0x9f/0x240
> [  438.709901] iavf 0000:b1:01.1: Failed to add Flow Director filter with status: 6
> [  438.714571]  __common_interrupt+0x63/0x100
> [  438.714580]  common_interrupt+0xb4/0xd0
> [  438.718424] iavf 0000:b1:01.1: Rule ID: 127 dst_ip: 0.0.0.0 src_ip 0.0.0.0 UDP: dst_port 4 src_port 0
> [  438.722255]  </IRQ>
> [  438.722257]  <TASK>
> [  438.722257]  asm_common_interrupt+0x22/0x40
> [  438.722262] RIP: 0010:cpuidle_enter_state+0xc8/0x430
> [  438.722267] Code: 6e e9 25 ff e8 f9 ef ff ff 8b 53 04 49 89 c5 0f 1f 44 00 00 31 ff e8 d7 f1 24 ff 45
> 84 ff 0f 85 57 02 00 00 fb 0f 1f 44 00 00 <45> 85 f6 0f 88 85 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 82 49 8d
> [  438.722269] RSP: 0018:ffffffff86003e50 EFLAGS: 00000246
> [  438.784108] RAX: ff4ed2738fa00000 RBX: ffbe72a64fc01020 RCX: 0000000000000000
> [  438.791234] RDX: 0000000000000000 RSI: ffffffff858d84de RDI: ffffffff85893641
> [  438.798365] RBP: 0000000000000002 R08: 0000000000000002 R09: 000000003158af9d
> [  438.805490] R10: 0000000000000008 R11: 0000000000000354 R12: ffffffff862365a0
> [  438.812622] R13: 000000661b472a87 R14: 0000000000000002 R15: 0000000000000000
> [  438.819757]  cpuidle_enter+0x29/0x40
> [  438.823333]  do_idle+0x1b6/0x230
> [  438.826566]  cpu_startup_entry+0x19/0x20
> [  438.830492]  rest_init+0xcb/0xd0
> [  438.833717]  arch_call_rest_init+0xa/0x30
> [  438.837731]  start_kernel+0x776/0xb70
> [  438.841396]  secondary_startup_64_no_verify+0xe5/0xeb
> [  438.846449]  </TASK>
> 
> Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

