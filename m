Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D7D68C1D7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBFPjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjBFPjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:39:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2116.outbound.protection.outlook.com [40.107.92.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19618A5E3
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:38:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ly6HNpjjQdqRIjoQj3NYS0c3/SFMgJ7qDFmjWlovTEJr8ZyBhAyJxvAg1FK0OZ0QdpU1Y59Ur7z143Uo8YOzMvrnFlLGHshsQdgwGWZD2QF6ygMzhwA89aa4ZQA7vE9JvhhZvFYnveT+fl3Erv4Oa1DynpnM+etGGU8jBrSVoEvS9PE7obPmq/DjNcuU3sgEZo4CEGofHMq7aYsgP/Ij1UmVZkpvhtrA0H1TUq7Fop0fFUUBcxZYKznyvBrABo/4T7v+4y90cr7xWcG1+qIQUpX7gvZKxW5A/0+pN7MEgWIcmFUyGX/7lLAqpEy3qIdoRyjFaiCkrJkAnP09etTGVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kc0+NPqnKyMVCWVyOOyMFsJjWBC+FhpOZqTNhNQU4z4=;
 b=LaB9G5tLQpnGEmvhrG5KhunLQjwH9TOCPfGSeW9s1NV6dCl1o19dNtJ8u4ADm6kYSRkAwIKbXSr8o86EwGSWZZXQMM+6nb9OUOqd3y0Q37OXpPcUzDgArVLh1qzcHLXMAVU8fXN8xGMRen/aToAgxCmCynpONmt2nmMcZZUq6l24IY5KsB5IT9kD3s2VuAhOOPiO91aygHdSh0TEkTPHeCEe4bqmhlBzLWmEk30yZi/ryxAlNbnaOk59SXcdBb+TFnLbuwMExWxnqFDVfiMbgLcTGU2yPgnvhZnH4sEDLGfUUOm94ZsBrpHnn9JioxXzfPYTNNnTHt9pb3AqvT1X0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kc0+NPqnKyMVCWVyOOyMFsJjWBC+FhpOZqTNhNQU4z4=;
 b=Ujmg/JZefsIam3KU1NmoAHtRj9u6V7LZIAELMNizha05reuvPtPec9I0/IXYvY1u/CBZirUIpGc2SM7oxktvKUfRfM/AAgqv3fRXEW7mgtFv2LnloL21dTtfJIzR96avzGgZH1N29011mB/j9uJZ5u99JhxdcmLRGvFeCE5pHxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4912.namprd13.prod.outlook.com (2603:10b6:806:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 15:37:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 15:37:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH/RFC net-next 1/2] devlink: expose port function commands to assign VFs to multiple netdevs
Date:   Mon,  6 Feb 2023 16:36:02 +0100
Message-Id: <20230206153603.2801791-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230206153603.2801791-1-simon.horman@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0013.eurprd02.prod.outlook.com
 (2603:10a6:200:89::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4912:EE_
X-MS-Office365-Filtering-Correlation-Id: 198314a2-f979-4cdb-edf3-08db0858088f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0Czpa2tBpUFhCF0t4GyHbGZb3SG6fY8L17QAihHNRdyJleyPmvQJKpKhtwi6PZgt3aD+OOezLP6cbSfgT1uhxrnEuWigi8Ra3XepLL5KxOrDe3QBy27+YdlkxdotTUte2fJxxIO9lPWJVWyGj+ekcMq5p5erYcR+R4KtWqqTNrAg80CAcO56jUWG3/Lr3sLUhNkN87TOe3y36sLh6md/tHbeEoTSlpK1S9HOev7iBtalSOqOqmqWP8oRyyi1W8rw3AkEQ1CoS3duh2849IcqB4sMnvNBtXvYMf4/LtJshN6rEQHrSpDAhIQlzHVRwEZPCSVhZehpGHrkYoV9PKfrcHfcM/w67d76P0GnBqdDOzrG37/tzBjb/gpUMpl3JnVH6eMCguULYD647OFp3Ax+B2vkHjGUV0ZSJmswfY98mOiOE4P3Mt2WTSn1WhGMXCezvXbvEAkZobuRxwQiKR7bFCm/weWNRkrKmvor4Aoz6bCNxWnN3hDf6Xk6a1j6RF1Ksq2+OH0cGuTCqa4fkjT9caEFikuntICXOeCKAN0RkZJh+JXqZAB8Kx2jz+L8DBp/yQHBNZEmcKxvfX8S9bhNuUGQMozXEceW8q0CmOJ58cuRoTerHS4/OQ3c8y/vgfCt6YKqLcrTBwklLp46Bx+8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39840400004)(346002)(376002)(451199018)(478600001)(2906002)(6486002)(66946007)(186003)(6512007)(66476007)(6666004)(107886003)(41300700001)(1076003)(6506007)(8676002)(66556008)(52116002)(4326008)(7416002)(316002)(54906003)(5660300002)(38100700002)(110136005)(8936002)(44832011)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnFuSmZtYm4vU1VzQ1l3b0M2ZXk3RytINU1TS2dXWnpmL2R2QWhtaWsvWjA1?=
 =?utf-8?B?N0J4MlZjMlordkVtUkJhQjNEdnE2dm5tdGZsR0RTZnk5cWZDZ0RqWTJpY2x4?=
 =?utf-8?B?SW1FK25MR1JYb3c4bjJLc0l4RGNCdkxxeWJuaVEzd1RDUWdtK3ZlRTFiNzhq?=
 =?utf-8?B?QnROek1kUnlSRUdaOXFNQWZQcnRndUVHLy9BaFNEc3QyeG9TMkZuaUVFdWc3?=
 =?utf-8?B?TEdEZGducnJFMVdoTDZOT0NWQXh5cHZqcXJ5NmZsRWJMMW1zUWhYeXFFR216?=
 =?utf-8?B?VkpzdUlUNDJ6N2dlTU1pTUJjZTJ5Vm5uNjRlakRLalB4NWhkbXhiN1Rpa3dI?=
 =?utf-8?B?L1V4YWtqenlZUVl3aG8rTS9vNyt6eVF3YlN4RzNrY1h0Sm0raE5JWGYrZEdB?=
 =?utf-8?B?Zlp6NS9tYmc4SkduWmlLQ3Vac25xZHVta2FTaWN2M3A3TFhXRE84Vk5FdGsv?=
 =?utf-8?B?cE9sL1dLTEVlR29ZSDkrNlNOS2VjbTgzSUlYZ1IxMTRlelUvbVFvNWxIVkR5?=
 =?utf-8?B?R1cxUUtIa1hxOWpja2FDM1NLMGRveEpNbEgwKzBibUJNdzZJNndGbFQ5Rjlw?=
 =?utf-8?B?L094V1FFWVZvNDlMeW5tVTgzZFc3YjVOcktoWXNRcVdKUHF6STUxOWlHWWU3?=
 =?utf-8?B?bzQzRVBLaXFPNTMzVitHcmV6ZVdYZzIzcjV0dXVvcVlCVndvNG5TYm9Zdlg3?=
 =?utf-8?B?ZGU3VklVVzFkU0RSdkdianNick00aSt2ekYzbk0zUkpZRzRFOXE5dkhIQWp0?=
 =?utf-8?B?U3BDWURwS1ZmVlJyaFR5Ym1heTZmUG9WUTM2VDZKR2IvVmo2dlZ4dlhUVVhw?=
 =?utf-8?B?aSs5T1pHUTZQaGFqRFlaN1NTd3hXUll0bEpwaUhFdzFoZzQ2Z0Y5eTJTcmIx?=
 =?utf-8?B?WklIYUhrMmZFNnBjSXpEVXZoYTlVUFdTcUt6SVl3bXVZM25OZUl6ZkRhUlBS?=
 =?utf-8?B?NDM1VWNlV3p1MkJheURuaDZZcFZ6VnpUbGFNczlORDVmTW1DMytHRFZoU0JK?=
 =?utf-8?B?bFlyTnI2ZlZObmhUWmpZSlBtcGpVVlNHQVp1eitZamYxWEtnSTVwcEo3NGls?=
 =?utf-8?B?RWhrM01FSklISXNNTTNEelhqTXRhQTUyblMzc3lvNThvc0JGeTNIRkxUY1VZ?=
 =?utf-8?B?NU91WktaWDlhQUlmUjQveE9HNG5seEtzRE0vVHFhUkc5SUxVNXY5TWhZakdj?=
 =?utf-8?B?V0VwWVF4YjZNd0YyVEZuN0dKTi8vYm9Wd0l6WG9uRU5oRXlSNmZhaGxCNlMy?=
 =?utf-8?B?UktJc2NNc0ZxUUV6RTQxeU5jR1piUGhnQmhiaVBDVXpLdHhsREJtTjM0aHlN?=
 =?utf-8?B?VStVMlM5aC9lTWg1SkRKSDVPaTV3bmFnd0dmbHB2OStBdUc5dkVoNVdZK0h4?=
 =?utf-8?B?OGFzQlEvTDdaVW1xWTErbng0RThLN3pUSU9TbjZKZ2FEam00d2gzV0NKR29q?=
 =?utf-8?B?RzJsdncwWHdYaUJMNjZrZS92MzN4Qlc4MjZEdC9zMUR4bnlUTFlnYTI0bHlm?=
 =?utf-8?B?UldjTEE4akVvQ1JPbk1kMGlSVGVsY0dsVUErUHE0U0hQa2RWenZkT3pmOWdt?=
 =?utf-8?B?SWdUTkNXT0dUV1FjMmh6bFd0Y1BJZWpZVjZDREM4QlJlbTdWVG9JTDlpaWtS?=
 =?utf-8?B?NXE4YS82M2hlN2pLMzR5dWROYlJtMEFjWStKUk5ZVW5oaHNRa0pTTnhDbEI0?=
 =?utf-8?B?dmxZdWhqZWdwY0J6SGR0eVdUczRoZEpESXBpTitpZXRrS3pyL0RPSmo3ZnJv?=
 =?utf-8?B?SXB4QUE0QjdqM2lKcGFxdXlwOEtodXoyKzF1bnRQcjFQanQ2TTI0NGllUlFx?=
 =?utf-8?B?UktnMEc1ejI4a0lKVGZZbEczeWVtNjUvYkNTQSs2UjJFd2VMOUc2bHBiY3JK?=
 =?utf-8?B?bFZxOGQ0ZjlQSTV2S3NQMUJubFZidDJkejhKc1JDSUsyOXNvZFdNZHlDZHJW?=
 =?utf-8?B?Y1BMU2FZOGpLNXJhd1VXSmF5cUtvT3E0Z2NtY1ptVHR5dGV5R2VaVWxiN3kw?=
 =?utf-8?B?WlB5U3R3UE9pcHZrektxNjFRMFB4MG9jdzVNVGVSSjh1MVRONzJheEFFdGVy?=
 =?utf-8?B?cnViWUNUeGVNbDZyd0E1Y0FnTlJxUW1zcW9UT0pjTW1tL0dxYS85MThPQjdv?=
 =?utf-8?B?dFBJaDhNaFVyYi8rdlZNSE1oUDFHZEw1NlRZbjlpaWNsNXlwMEpFT0puSEhy?=
 =?utf-8?B?cXYwNjR5OVptZmVaSzluZFNuUHdwdFJGa29TeGh4dEVYYkV5bjJEUU5rNjM5?=
 =?utf-8?B?QUhhZjRBR2Y2RUhXYmE0c2F0dUFnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198314a2-f979-4cdb-edf3-08db0858088f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:37:19.9038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIxz3TTDHiwBVuY86Mjh0PlQqc6uLtyUy1vgNcBEruCMFfL8edxJknwSs1ZfWQBr/W0q593JrAOVsksRU4Y86nMOk0w1F4lgVU78htCjfq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4912
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Multiple physical ports of the same NIC may share the single
PCI address. In some cases, assigning VFs to different physical
ports can be demanded, especially under high-traffic scenario.
Load balancing can be realized in virtualised use¬cases through
distributing packets between different physical ports with LAGs
of VFs which are assigned to those physical ports.

This patch adds new attribute "vf_count" to 'devlink port function'
API which only can be shown and configured under devlink ports
with flavor "DEVLINK_PORT_FLAVOUR_PHYSICAL".

e.g.
$ devlink port show pci/0000:82:00.0/0
pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
port 0 splittable true lanes 4
    function:
       vf_count 0

$ devlink port function set pci/0000:82:00.0/0 vf_count 3

$ devlink port show pci/0000:82:00.0/0
pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
port 0 splittable true lanes 4
    function:
       vf_count 3

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../networking/devlink/devlink-port.rst       | 24 +++++++
 include/net/devlink.h                         | 21 ++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/devlink/leftover.c                        | 65 +++++++++++++++++++
 4 files changed, 111 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 3da590953ce8..5c3996bce6d9 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -128,6 +128,9 @@ Users may also set the RoCE capability of the function using
 Users may also set the function as migratable using
 'devlink port function set migratable' command.
 
+Users may also assign VFs to physical ports using
+'devlink port function set vf_count' command.
+
 Function attributes
 ===================
 
@@ -240,6 +243,27 @@ Attach VF to the VM.
 Start the VM.
 Perform live migration.
 
+
+VF assignment setup
+---------------------------
+In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
+different ports.
+
+- Get count of VFs assigned to physical port::
+
+    $ devlink port show pci/0000:82:00.0/0
+    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
+        function:
+            vf_count 0
+
+- Set count of VFs assigned to physical port::
+    $ devlink port function set pci/0000:82:00.0/0 vf_count 3
+
+    $ devlink port show pci/0000:82:00.0/0
+    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
+        function:
+            vf_count 3
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2e85a5970a32..3e98fa3d251f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1491,6 +1491,27 @@ struct devlink_ops {
 	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
 				      bool enable,
 				      struct netlink_ext_ack *extack);
+
+	/**
+	 * @port_fn_vf_count_get: Port function's VF count get function
+	 *
+	 * Get assigned VF count of a function managed by the devlink port,
+	 * should only be used for DEVLINK_PORT_FLAVOUR_PHYSICAL.
+	 * Return -EOPNOTSUPP if port function vf_count setup is not supported.
+	 */
+	int (*port_fn_vf_count_get)(struct devlink_port *port, u16 *vf_count,
+				    struct netlink_ext_ack *extack);
+
+	/**
+	 * @port_fn_vf_count_set: Port function's VF count set function
+	 *
+	 * Set assigned VF count of a function managed by the devlink port,
+	 * should only be used for DEVLINK_PORT_FLAVOUR_PHYSICAL.
+	 * Return -EOPNOTSUPP if port function vf_count setup is not supported.
+	 */
+	int (*port_fn_vf_count_set)(struct devlink_port *port, u16 vf_count,
+				    struct netlink_ext_ack *extack);
+
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3782d4219ac9..774e17f6100b 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -676,6 +676,7 @@ enum devlink_port_function_attr {
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_CAPS,	/* bitfield32 */
+	DEVLINK_PORT_FN_ATTR_VF_COUNT,	/* u16 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 97d30ea98b00..6dac8b562232 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -141,6 +141,7 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
 	[DEVLINK_PORT_FN_ATTR_CAPS] =
 		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_CAPS_VALID_MASK),
+	[DEVLINK_PORT_FN_ATTR_VF_COUNT] = { .type = NLA_U16 },
 };
 
 #define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
@@ -520,6 +521,35 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int devlink_port_fn_vf_count_fill(const struct devlink_ops *ops,
+					 struct devlink_port *devlink_port,
+					 struct sk_buff *msg,
+					 struct netlink_ext_ack *extack,
+					 bool *msg_updated)
+{
+	u16 vf_count;
+	int err;
+
+	if (!ops->port_fn_vf_count_get ||
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PHYSICAL)
+		return 0;
+
+	err = ops->port_fn_vf_count_get(devlink_port, &vf_count, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	err = nla_put_u16(msg, DEVLINK_PORT_FN_ATTR_VF_COUNT, vf_count);
+	if (err)
+		return err;
+
+	*msg_updated = true;
+
+	return 0;
+}
+
 static int
 devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
 				  struct genl_info *info,
@@ -871,6 +901,16 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 	return 0;
 }
 
+static int devlink_port_fn_vf_count_set(struct devlink_port *devlink_port,
+					const struct nlattr *attr,
+					struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	u16 vf_count = nla_get_u16(attr);
+
+	return ops->port_fn_vf_count_set(devlink_port, vf_count, extack);
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -893,6 +933,11 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 					&msg_updated);
 	if (err)
 		goto out;
+
+	err = devlink_port_fn_vf_count_fill(ops, port, msg, extack, &msg_updated);
+	if (err)
+		goto out;
+
 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
@@ -1219,6 +1264,19 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
+	attr = tb[DEVLINK_PORT_FN_ATTR_VF_COUNT];
+	if (attr) {
+		if (!ops->port_fn_vf_count_set) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "Function doesn't support VF assignment");
+			return -EOPNOTSUPP;
+		}
+		if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PHYSICAL) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "VFs assignment supported for physical ports only");
+			return -EOPNOTSUPP;
+		}
+	}
 	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
 	if (attr) {
 		struct nla_bitfield32 caps;
@@ -1278,6 +1336,13 @@ static int devlink_port_function_set(struct devlink_port *port,
 			return err;
 	}
 
+	attr = tb[DEVLINK_PORT_FN_ATTR_VF_COUNT];
+	if (attr) {
+		err = devlink_port_fn_vf_count_set(port, attr, extack);
+		if (err)
+			return err;
+	}
+
 	/* Keep this as the last function attribute set, so that when
 	 * multiple port function attributes are set along with state,
 	 * Those can be applied first before activating the state.
-- 
2.30.2

