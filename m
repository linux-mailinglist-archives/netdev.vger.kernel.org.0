Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597216C94E8
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjCZOAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjCZOAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:00:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2113.outbound.protection.outlook.com [40.107.220.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08E27A9A
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:00:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cwk/RqtP8900frwqDvGToWaZo7sIrKX6+3rRRzjdri4omj5fxP5hCQQjqoaV1+SGFtOVEi9e4NkS+q8scUb8h7whc6o+QLIL0Zr5sugk8wB/aSPttYLvQw65m+RhXIMEXiMw5cB3ScOvkIJ7Zv9DZvjuU3PCGLE0XXT8ghG6h5U9MfT15rvqSEXlbr7dUT6VOOV6/yfrDho85+Z345UgP4zcI0keBpLy/D5H3XlClBNcmWtcDEm8nQFLmpCaJS0GV2Z5oEeq5HZjJGcIJGlXY2gNZjRKenN4YB0Sxcm8wkBRS/7QiMyN36q1848QuPumUngXXrmgTySPpRUG/2BblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmfxF38sPycEecaLfbQ458gl7tCWCkH79KY8zOAzrIY=;
 b=Z9/aqH6g1VdFoJdDOS9TUqZuON5JlMQbRo80zNuDtY0hz0mheEBZII0M27QJhHDHLITMNy1NKQusAovs+pgGY/FYZywz0Fs5oIohYpPSDg7Z7TfMJguOupp3o7SVSH1paOU83roxtAcDzbmqPRSVEQKaxzpRpU+Ps1F0J/SOZoGiAGPB1hx88UvJwqsWMrf7E8K87taArbmlWY1g2qcRrn3GPpo/qG61RbyfSI7o6WRd2fkfYf8S8/yCslSQToPLOH/kdLCS4HugOfcv9OJHpCVYqXezWqb1DU4IG00iv2eF00x6debNOvtYI8qgzZolYEhMGFLtTC6OkQyXHvqZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmfxF38sPycEecaLfbQ458gl7tCWCkH79KY8zOAzrIY=;
 b=Bzt4EQshugGdDStlzRGb22Rn+5Sf1skqn/pBWFLCP4MqKDAu64JT7G3ODx5NDnH7Rfi8yOgBhPR8TzdbRgQhIXfEI4isAfulbMYSQGKBVfskBXN5g32+YgS1bLk3shp6q92xOpq0LMFxLNrCAgIwpeFj8Fm1JhYftpBJi/MR15Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5939.namprd13.prod.outlook.com (2603:10b6:303:1b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 14:00:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 14:00:12 +0000
Date:   Sun, 26 Mar 2023 16:00:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 2/6] mlxsw: reg: Add Management Capabilities
 Mask Register
Message-ID: <ZCBP5dymVMTYA9Pf@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR07CA0028.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f0cca43-090f-4885-146a-08db2e026ac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CB/Ozi+rGrcjJI0vCZrBZMj+bql4mZaPY2qm2xgpQUBW4bGpgL4ox3ke2k+3p3MWzCfwJYwcSyj+pI60aIwaE9XfFBxk+SX6Cg5IUG1ZAFSalItNycK0lzwQWLyLObppadFjNTnT3rSsjLJ3b4HSX+SEmbptM5LoExe5Yrq4jcdHh/a3zhuxhrxZaRAKw0T3KtD2LA2XGJMHEel/qgPxTqv8FnSafU8XFV07664wYgIZfWMBFry9YaVUkjT4qfESmm+J0l5fj9rSABdqOFoTGI7vlsyO81/IdOA1dJTayIQRWGSc+EDL2II/Uv9s/XcJfDIRnqKkOxVrn0RGKlKqWJ0gUXwOUOldj+6arBQPZiSKG9YHJfSobcuCjmi4yf9/ftiivo/jyVS3uN3cxlHgmiZhxAK7yeWvl1vOK1OpM8BGg/onA6bKh3ULF+aTHtBrzO+nX8jhDJwelCUi+H0gV/4cVFH/2LXRHuX+eLRuRr2NTIOANl77272wwPdKSATDI0TAmBdITCIS6Rc2xc6SHdWoH/j58VOgnOTsIG/Gs1Wgrmv+46uWZ6YKrHASYNlJ7M7UDf7PRm/ADoYlTQoeEXGciE5g4squwpcDurOTjJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(451199021)(66946007)(66556008)(66476007)(8676002)(4326008)(6916009)(54906003)(316002)(5660300002)(8936002)(38100700002)(41300700001)(186003)(6512007)(6506007)(2616005)(6486002)(478600001)(6666004)(83380400001)(86362001)(44832011)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7x3P81Q18L8qKMmSj/EdZBNeV2DfJZiTLilkv4S/nfMzISQ8/ZEClVDBuxmS?=
 =?us-ascii?Q?7OMv6Z3scaqlJYlt4AbyCHIbAvmuHwpErATq9PoX7Nv0QUevXRXje5lPKQoC?=
 =?us-ascii?Q?Ga+sdciKKvpDiuHw6e0RuWEoP53iS6yxqnob0oMgisvd0xaVV8uvV8Kir8H/?=
 =?us-ascii?Q?T3IOfYvBZLBnltm8AOHGZEMme0Wgb/w4KHqWI7y0/+whrwFr93739Edft0+4?=
 =?us-ascii?Q?SJyUoCz2dS34wU2ZXsF10r2uiGXmqsafSww5bEWXFgH1Oncf3CyOYh6ByKSr?=
 =?us-ascii?Q?oqKYA2KMmfvmWA5nYgTOemh8cpsSCMxugm0KLsR2i9KdZsAj9pbe+j7l/fLz?=
 =?us-ascii?Q?AunmFORHVvJ6T8eXMcoI2g2BUZBroL3OWoyXTxIUXQLT5P6k8NgpFYUuf5yB?=
 =?us-ascii?Q?jWqQOwJYoipzE+6gJnzmnW0oKXiba7FBb6BaAuAI9mnVbHJDH1WXM++59BCE?=
 =?us-ascii?Q?zrw3SZBCKZ00nh6Ja+V8k4zr6c6qbIaKnH/ot+Rwq/7Mxfj8uJjf340scuLh?=
 =?us-ascii?Q?RWsYIhXCmIeN81ru+SuyDm8iuHLZNWbgu/KsoLdXsu1BoeG9ZaqQvslXtbv+?=
 =?us-ascii?Q?6B10KWVXpSxJnIi6SSPOIRRqcqatT9Zju350/S+MjGYDdaZ9PF5N9J9f8pfv?=
 =?us-ascii?Q?dGZ0el2EYUDbPxJR5R/xNHisHrdfd4Cm/R5S9ZL5juBxvSQckNIeLfOQ+SxL?=
 =?us-ascii?Q?ujM7axMZg71oNzOyk/npOtJv5z1eWjDFobij7owfaIgHhhIMQDRzHJk5xSJc?=
 =?us-ascii?Q?kKZVDcanI7a7FQ7C3uxvTe9eDqCN5RtbGAFLD5oSeyDO/yQ0rp7i61SLRpa4?=
 =?us-ascii?Q?ezV3J1tj4PnRx31FyZP6X4doxTohY52FOridDkS0crGrvwfGVx+eEnDtet/8?=
 =?us-ascii?Q?f2EVP/+KeChR94o/894o2hpLUU3frXcSB27EtZE7TV8TQa8OpK6IU3wKae2h?=
 =?us-ascii?Q?qHGsi1twoEcQAPPuXFdXkcsR00QoSAV1pingjEIF1/kQ07pBDGS4zT+d6WJS?=
 =?us-ascii?Q?O9epFbiueTfbTs1mlYBnNBywnbZCuV/MNXNp9jdKFA3QppBCxosAEI/VexVG?=
 =?us-ascii?Q?PrMFSrwtV701dmEMT18nD1w46D4NPcYsyDTGfXwWICGkarImF8Bw7Tp9EOiu?=
 =?us-ascii?Q?nJ+fsDOX4fQXQ4EPnYBnzdC04Fw3aXNxGo1bPOJhFV4KWYoEC+nM5YJEGJaw?=
 =?us-ascii?Q?5SSBIzZtbsqqsvBtS2vxew1rjI8Db26skLTLspGS/QcU2qt5Vnr3R4in0IDx?=
 =?us-ascii?Q?mHz7Zxs40XvqW7OaKWi/TSv103f2y3/BIjKr29B+1palIL8AxU+eA+HWKcii?=
 =?us-ascii?Q?X3I+/47l5NOizpYBfc6PYh9g3gNKTn41hBUkC21mzANdn+4li4LVgZTocJDZ?=
 =?us-ascii?Q?BylktYlt5ip951p4GEpe7pvqpTO47pngXNMb7wbnJWKJV+Pdbkes7kdY/mK1?=
 =?us-ascii?Q?usa0IbP2Nt+EUZuXbtmkNLbWEPnfhOYiU25W8YEO976ccPgA7HBvr/fg2OPa?=
 =?us-ascii?Q?T/FiXkMqjGOrCn/BraaPas8jNWJa+fMt6BiLaK8Nlu25vuSdgavUOJ+4cYTr?=
 =?us-ascii?Q?qp7Bd9s+tH6DzlK0EJlDxB42LPUdfR90KUcIahr9FEegGnj+KaO655IAGAQT?=
 =?us-ascii?Q?L8IC3saxoOyJNB9EwpwMzvGG2/3tWdiCCStOTW+Q84yUKHIUNfjTFVzApcug?=
 =?us-ascii?Q?8nzjrw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0cca43-090f-4885-146a-08db2e026ac9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 14:00:12.0927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/cYiE0KKOdq25X8h/ZJ//0L89y7Ze7nDAtnS/Wcgy+T3OmHuGb2XAzIrbGwvFRTIorIzrbaOXHLtWvac/rtxoPlXJ3E/OmnPFvnQyrA0kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5939
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:31PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> MCAM register reports the device supported management features. Querying
> this register exposes if features are supported with the current firmware
> version in the current ASIC. Then, the drive can separate between different
> implementations dynamically.
> 
> MCAM register supports querying whether a new reset flow (which includes
> PCI reset) is supported or not. Add support for the register as preparation
> for support of the new reset flow.
> 
> Note that the access to the bits in the field 'mng_feature_cap_mask' is
> not same to other mask fields in other registers. In most of the cases
> bit #0 is the first one in the last dword, in MCAM register, bits #0-#31
> are in the first dword and so on. Declare the mask field using bits arrays
> per dword to simplify the access.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

