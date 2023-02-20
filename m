Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23CA69C8C0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjBTKip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBTKin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:38:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2104.outbound.protection.outlook.com [40.107.243.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502521A494;
        Mon, 20 Feb 2023 02:38:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObYe3ImLxnROL9I6SnAKSm+pw9t2CJF5B+uC0aJGVsDiSCKtX4rGOr1YldtnzkLlCyKrTzbsvyI7bMciwMP5z14fn8EPoOUwHnsUp5rdz2HnR+nC1A0/9ye+4Woci1xQA+YKNGJldI1vqC6f8eVRcRXCLWvOZ43AG2oL1DrO8FRMdwzAhp87MQpNL4Hvb0E36+HQdmK/9nSxQGuacP9i62zuMBTmOd6xa3jFpTxVwf9aN/gIh6YPLSi9/jKp1lZ4u1ZOALlpgg28EE3jSKxw0x7hPscy6FODCgwxd6q3Cc8aOp1N1Pt1Pacjb66Xn380/qFGAnDPAZYZuuSCnZoNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NavUXXirxpIgbvmfZImVKpBkmzf8JJpoz6CUsU0046g=;
 b=ExVCPyOSkBvVUDa6T0vr+g9jPDTp8Wg0/WRUBSalkx5wIZzC7enTNFePIUSuseodlmMojuLctcsVEpGSw/zgIBTJjl0DiBB5h8DYjx7DHjB+/NZpghYG3RITPLa70E5PVsk1sTMDnQN2jtAA7P1yAEty3iJE/O2LKRtU+2WmkHqIVNp1Zl/Xy17Qj8AzLbPN+Z0H/3YONK+R/alApVgX8x+gB/X93h7urqqzHIah53OoeWXnEcsyMz2h3/RQl/++NARV/Xg53U+9tB7wgXvk3DNfRF3pH1kjx8/il96jMTSouti6noY1JcqlNlRt/UGMO/CsmIj33BF+oDJA3c13Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NavUXXirxpIgbvmfZImVKpBkmzf8JJpoz6CUsU0046g=;
 b=Mt0wtFQdzTzvPB5PEcmSCDPfuyAkZtXsoiGtnz5ox9PRUMhdgTW1K/BD0rN6r0R45JdIY0YhU0yHmCFMZCsRbYrDbp4fwpGmebNx+FgPQSjY4+AN43ccrdX6gSnDxIlaGVeMz8/xTGTZbpj+HbIs3bdH445lFyWoVIWA2PQ3UIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4087.namprd13.prod.outlook.com (2603:10b6:208:263::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 10:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:38:05 +0000
Date:   Mon, 20 Feb 2023 11:37:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
Message-ID: <Y/NNh44zpBwPUacq@corigine.com>
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
 <OS3P286MB22953C8741F17F500879FA86F5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OS3P286MB22953C8741F17F500879FA86F5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AM0PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:208:14::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4087:EE_
X-MS-Office365-Filtering-Correlation-Id: 0905338a-b409-4f22-daae-08db132e8cba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzwiTz9U5hLABqWU39rz7HJblYMi9w+RigCSIDTDNyfrlHRqFZdQz6UR6YvHwsbsaLPkZjb2EthgREWP2ovozxvhhsp/KKObEW/4hGsOZRF2jTQKLfr4vnoP5/2iN8sbVoqHibiODX+djaME9OopkDH3GZJ2zCcvVnG3nYRokZGJRus3KysSI9+MGrjONNcRU7KEp+E4uU7zauHcZJOa9MGwM8oviqZd4tH08FLoaAPy6lxIVGXp/kpsD245eopZWLvAPprL1skdEqTeqvcNW4+wyuT30g+CyRb+mXkQAApHlhAnpgfAFhWiIr0DnRN/owhKhubMog7Yw2gpm6kOVG+FU/pQBJ3HkC9fpBjjv85Y1fG0OwiP9IK4Chua9rK6LKbOR7OwkOwsfqOnI+WkLvudR+0GElFcHf/lEWpxGUY84WV1z1gi4AjY/Y2bVPpbnTPtab7zNfAZU0nrfmRoYQ2pgCz56JpvT/GJGIRdtYV+D9FeqS0lZrTxjgJ7Bs340J0h5Ech1If+qFHYMJhNOXO2CdO09pwU5vAFdBeKi5j+NdCQMy0ri539zJfOA+Z7iLMB++rosi7mCkeU5ascFlV/QsN80HHq51wJn52grA1fF1j7sU/17vU60yTHTun/j+KcdLWlpja5jFO5U61deQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(39840400004)(346002)(396003)(451199018)(38100700002)(2906002)(6512007)(186003)(41300700001)(44832011)(6666004)(6506007)(5660300002)(2616005)(8936002)(478600001)(316002)(6486002)(66946007)(66556008)(86362001)(66476007)(6916009)(4326008)(8676002)(36756003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzQ0Rjhya0FhZnhyYSsrTVg4UFJObXp6ekdJdG5SL1NXNzh3UnRHK05qZmJJ?=
 =?utf-8?B?VVRRQzFjVmM5aS9rZklFN3RkcSs2TXJYWDd1TnhJZzFJb214Nnk5aDZxenZ2?=
 =?utf-8?B?YUlMb3dkckdXZmRRdnI2bGpXUG9ieWJ2aVk5R2RtNk81alBVdjdhS1h4bzBw?=
 =?utf-8?B?RGU3eHlrMG1PS0tyU2VwbnpjSXdjbVdaYUk1SnRXTTFkZGQ5UmhDU0tsY29F?=
 =?utf-8?B?NGlCOW1ZS2dGckpjTktDR0ttaDJSRjRMSG1YZkRmdldycDRKWEZhNHJNUFJj?=
 =?utf-8?B?VTNmdG02MGRZNGFBVlVhQzBTbDByTHRCbnVZQ2RCRVhmM09mbHFsRHFQVzVq?=
 =?utf-8?B?TFRsaVBYaXY2QlZFMlcxQWxsSCtKK1hNWmlpNWtaOTgvUFBweDJLSFZDVzBK?=
 =?utf-8?B?Q01wYW5SYjdscVN3UzJaek4zT2F3RFU3SWoxTTFwb2lVL0hYUGdVSEtjckVB?=
 =?utf-8?B?UWVQTDU1Z1VUTktacDZSdFNvOWNHWVo5MVlGM3dwOFRzWlhGQTNuRHlkU2kw?=
 =?utf-8?B?d3MyOU45U05zM2M4L3pKandJNmllNGZzWGhldVp3anJqWEwxbVR6dW1td2lZ?=
 =?utf-8?B?M28zQkhSOTVZVU1jNlZyTFVkZG9LUWRITjEzWFhCRWVCWUNLOVJrRGU1MnJu?=
 =?utf-8?B?dFJsS2J2Uk1HTm9COFNJODZ4SytaM0hHT2J3eTg4QS9Gd3R6KzV0NDlIRDQx?=
 =?utf-8?B?bjNFc3hzQkdHcXRVcktsRzVFUWljTmMxTDRERkZxSWQxVHZMcVJCT3dXSnd0?=
 =?utf-8?B?R01DMWdQdG9WM0N2UmxYMHZ3VFBUWDBQMHo2Mit3c1FsemQxWThFTy80Ynhm?=
 =?utf-8?B?eVdRMUVFcnlxOWtCV3dKQWw5bFVGTWhMamZsZHNHTk5FTzhSY1haekxhTWJi?=
 =?utf-8?B?WUplMUNGWlgwSXE0b1FBZ0huQzdBTFBkMG1IRHByUWJRNHhzMjNNNjdURmZr?=
 =?utf-8?B?eFZyaGZUcDYvQXZuVXZUb0Q2RDZBc0lRR2wxMy9HOHFzeTZEd2ZvUXZYL2Vy?=
 =?utf-8?B?aEYwRTJOeXR1L29CVldjcE02aFBuUGJJNXNCT2M0bmlHMGpib011VlVBSkEz?=
 =?utf-8?B?TkJjWW94bXBSZy9rWkVuZkxOdktuT2U0ckp3MVlBN3p5WWkvTVArOEZSQmpG?=
 =?utf-8?B?aVdXRDY3T0ZLdkMraExoMTRBMXl1blQ1SG40TW0yK2tLY3o2NWpleDNWSjJ4?=
 =?utf-8?B?K1dNTFU0S3RvUjFHYTVPb04yNXNvMDVvN1hYUTkvcnBSMithWTF6bnl4S0l2?=
 =?utf-8?B?Wmg0a01qeWp5T0pwOEZ5T29VcFJ3RjFPUnpZVG9RdDFGT3VwQ3hvanZnMmRs?=
 =?utf-8?B?bWMzQkZ3WnBsc1k4d2xtdFR0K25rcDJuODRFZ1I1VkczczY4WHlBSWljMlFG?=
 =?utf-8?B?Sk9JTWc5THJKS3NCMTMxN3FJQ2FuU2hMWVZvaGo5b3BiY3dJUmhtVHZQV2oz?=
 =?utf-8?B?emJJT29QZWEwd3pvUE43c09nZEhYcnp5VXlSbTFvcW56cE9jY3VWUWVWQjc5?=
 =?utf-8?B?RVNSaSt3NGpjcXVrbnN2azdRaVRPT1AzMG9IU0NDN2JvbHZGdnQ4akxIQmpG?=
 =?utf-8?B?dENqVk1wZlhPVUMvMFZCbGtOVG16bGROWGZrbTlsL3FJV2doRjZuT3VZd2hr?=
 =?utf-8?B?U2p1M2EycEFNenlzNEs3eTlTSHZ4dFJjQ2pzV1ZXT1M0MldZdkU3VHNka0tj?=
 =?utf-8?B?a0pBZ3JKZEJBdEpFZlVhcktReTFvOVE4cnVaSkdKaHRPa1prdU5SaUI4VVpI?=
 =?utf-8?B?LzBEYXk5N21LSGxXdVV3Z3FLTlFSeS9QZ2JVU1FWUFUyOVVQTFZ5Mm12YjdK?=
 =?utf-8?B?NHR2aXA0SmtObGI0ZUcyZVVIc1U0U1NTYkZFR3NLUGg5dkRuMjhuNVpZZjAv?=
 =?utf-8?B?cTdLUGRrNDVSRTlLWW9HRnFUWnlzNmRVa1AzMms2TDJhQTdxVjdyVDVObzVx?=
 =?utf-8?B?ditubTM5RVNDOVlGeXpkRXJGc3VjbzlQKzhvRCtzeWcrOUZheVR0eWNTSDN5?=
 =?utf-8?B?Sml2cEdXUGJaamlUSFVLZUo3SWdJUnZ4dWtaZ0lGM0ZKeEViVkFwR0tZQXBQ?=
 =?utf-8?B?V3VnTmlGdHNsUEVEU2NoeWRYUndobFJhZ1dMSDRWWk5ZT25rM2VaWFhLVFBv?=
 =?utf-8?B?RytZVmpVakUxWFRxMktwbzdaVHZRK21TZ2lBUGYwczhjQlE4bXZUK1hCRFNE?=
 =?utf-8?B?dlhVWW4wM3NwUGVCTzBxZDN2Y2ZUQkVoSmVCUGJxM21xRU5OZjdLZGcxenVr?=
 =?utf-8?B?S0hhK1YybkZjNkgrQXVsTitqOGd3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0905338a-b409-4f22-daae-08db132e8cba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 10:38:05.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW21yxNfwdyEyXZm9H/ZY76H2tpAjXZ0VnQXuctCsIYxZ94pvfiggj8Hw33GEMniKQY1eVz3e/SNstUdoPBhmlL9ciWlA3fk5z0iAtIrTZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4087
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 03:11:17PM +0800, Eddy Tao wrote:
> Hi, Simon:
> 
> 
>     About your concern for the stack size, it leads to more room for
> improvement.
> 
> I will file a new version which will have smaller stack occupation and
> better performance
> 
> 
> The new revision is invoked by existing examples of using struct in stack,
> in the same file net/openvswitch/datapath.c
> 
> struct sw_flow_actions *get_flow_actions(..)
> {
>     struct sw_flow_key masked_key;==> sizeof sw_flow_key is 464 bytes
> 
> static noinline_for_stack int
> ovs_nla_init_match_and_action(..)
> {
>     struct sw_flow_mask mask;==> sizeof sw_flow_mask is 496 bytes
> 
> 
> The first example reminded me, revisiting the code in
> ovs_packet_cmd_execute, basically sw_flow serves as a container for
> sw_flow_actions and sw_flow_key only.
> 
> We do not need the bulk of tunnel info memory in sw_flow, which saves us
> 200+ bytes further -- less is more.
> 
> 
> The new revision will be presented shortly after some sanity and benchmark

Thanks, for addressing my review.
It is the stack size issue that is my greatest concern.

Please consider including performance results
in the patch description of v2.

Kind regards,
Simon
