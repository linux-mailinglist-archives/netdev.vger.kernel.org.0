Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33362E011
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiKQPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiKQPiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:38:06 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2094.outbound.protection.outlook.com [40.107.102.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDA359140
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:38:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foZ/zT/NgH4HzlkEtsDa8uy+nH/MzUM+BlUBF44GB2/eECQRheP5rofdrlC5CugXz3EMi+kkeupkpVqS1FH7A/s8bOv9+NUc4M8FYLZmXDhmOyIy0zASGf1RKKSo4sQrf/UhhJMN6bYkIeDDvRvmTRasMgA3/0ja0FiHA+Ncd65TjHN/rhHe8tqvy6UUeXfo5W7idwh5AGyKCYFHfA8TXS+TBZQBg6vuGrCupysCS3JPAE1hir1jKlpMLP3+HlYlBJB5fetg5XDso69dcyqVK0LQpiqfw5ooyBHN3R7HQwjYJ3a1az+CnQMoEADKBuIuWaph8lfkMVbpTXDG3VhETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLUxlxNcxTskkUHq0AZ/Kuw269e7V9VUhIFGl625GAQ=;
 b=HEpODn3W4VTCCIBo2HlteFh+VwwovXnOeYxmaudtihD5lr6ogSCfiYo9QWoKLkjOK46m6zj07Zuo+0fjWy2pPSpeSto4sgP/9f11cMhIVhjk+opzmy4a13KCi0/rSm34c6QF8KutILcq4FOQAK/vUJoO3b8tLVtmdFeklJZvFzfRayKnBMlAXiMPBjqy+gWXxqw/duUWBYXgHdbmsTuLxf4kZ+4+uK2C1Vbk9rJVLD6jrczNMbVAz1j1bt7EOB2gq55c6BxOKCV3VfOEzOTPSVcil47nQ2dU3ZezwF0T+TW/lk7Snh1E6yV1i5lvibGuqqWRs3YiZ+cjNLsSED79hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLUxlxNcxTskkUHq0AZ/Kuw269e7V9VUhIFGl625GAQ=;
 b=OlkCzN1eU9ckDCs4Nd/7zMz5wwiAgeiinqd9pzdoP9Nb7TCmlTJL1J4Mx5goUkQV1WsBj4Fd3hqw1HhIYq/IjDVLb9hvnJ/sQ8024fj68nh5EXUAhHj8q//L4+hi5PudhQUvVhkAzNzQt1vYTn7T3Jsyc3pIZiH8M9R0oQZvIgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5242.namprd13.prod.outlook.com (2603:10b6:208:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 15:38:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 15:38:00 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 0/2] nfp: fixes for v6.1
Date:   Thu, 17 Nov 2022 16:37:42 +0100
Message-Id: <20221117153744.688595-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e92d48-e405-479f-fa3f-08dac8b1b52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60gKCgXimYaZTdjC3wUZTTkf0pNwCHXTefq8ewfvDgSMC4PsjFQrFl+BXc+GHWj52ffC5kJ+hmLeUgngLdPlaEmT+X5nZBAys+YrNWAhwnh9yvdzV7GxeX3RMgy8dlIv6WMXDmt7ajR0PPko6h3JKJBJO3LAtXwS5wqcyyET7uVklciq00xdPLDkJ2d/RT+72iNa946BG03Uv975azvYsrAnvEwulGJXenY55hmWpHqJT0u3ib5zbW28FYxw8qh2rvWiYxAfQk554I54gukqJekMefjsz42F17dFN/K1HWW6OvnKU7YWj9ZW8XkGBM7a0bGBtJxMJDOoc5PVBRiUuTg8wf/KD7jQCCn4nyaX/ULTi3z62tX2ztHk/OGIKx9WY0zG6l4224aTpeKgyNBhpidSmcGpZ7Y2RIC3PKbXpZ7byGjGVsCau/ygxO12u8vcQSjO6BVve0JOQRoZEATHCfa78HAYabEy1MCNdzugw1PHP/vk3EwvT/GJygbe8DBSWfFkHyPXNF4gS5SWNx7MEPm+uMuuhcOU+JHXGR00jrN8B8Xfm75uV827ik83C2PWvx/7Yc7UjuB1oRpbpgfaRYJ7Fn+z1Ttd54HUCBMSHnM8qsBqXQhc6Gf/1vFK6ji4qY+ZIk1Kx7udvIzp9npg5HjBQ4F797mWf/jWfOQ23PxXNyUaErW/7TxiUQuEnlMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199015)(4326008)(83380400001)(66476007)(86362001)(8676002)(66946007)(66556008)(5660300002)(4744005)(44832011)(8936002)(41300700001)(38100700002)(2616005)(6506007)(6512007)(6486002)(110136005)(186003)(36756003)(52116002)(478600001)(6666004)(316002)(1076003)(107886003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkY2eEw4czVMRXo0ZmgrdjJiWmVNR2RKdmQxZ3JoaEU2dkl0bm54ZkdPdDVw?=
 =?utf-8?B?dTExU1UySUR1Q0tqTTAwRzdQMXBOWlhDSEs1aFNCZ3liVEt6cFA5ZVRlTko5?=
 =?utf-8?B?Wm9ST3EzZ2dxazd5eE5FY045dnpwMWZjV0R1a2c3eEhYZ1M0anVabk1zck1k?=
 =?utf-8?B?Yys2YnM5VGwrNVRZb0pHRnZKaVVHd2x5YjJOaVJDbTVxY2NNR3FoV1B4RktV?=
 =?utf-8?B?NmI5cldCUERmUk13MVRNZ1JYeEFiZTVKbThkV1NIbW1pVC9VTmlybW1HR3FY?=
 =?utf-8?B?cVN2RFM0OTlISE5ET1lhTlRqcnJXNW1MaVE1MWVSc0VWS1BwQ0RRZy9pWkFR?=
 =?utf-8?B?YXZtVlQ4YUEvZjZ5UkJlMVhqR2EvQTZBSERBd3NpZ3ByV0pRbzkrRFdZWks0?=
 =?utf-8?B?ditBblVQVXRXUTY2U2RvY0c4cjlLM0ZiOWF4Y1dqOFlRa3BFWnBjSTlSeW5i?=
 =?utf-8?B?QS94Vk40K2NuOVpPWUNSN3pWa2hZWEF6TlQrQW5kNzk3YXF4SVRraEJyWitS?=
 =?utf-8?B?Mzh0dWE0Q2ZFa2VMYlU3eDlsMUoxMUxBZmlvUi9VdXVBWDhJcWdSQXpwQnVz?=
 =?utf-8?B?RXhFSnl0MzZhZW4zZFU1dzRyUGVZMGNvbnduZ2U3ZGRrTTN2Zk1kMUtiTXZi?=
 =?utf-8?B?eGRMVXIzdkZJeWdoNmpPQ3lDdXAycDAyVWh1cTk3NkRFZ0FJZjNKZWkybG1t?=
 =?utf-8?B?ZVNjRGxsZEVjVUhrQzh3dUl0K0hxbnpvdE1TT3M5ZVNqZmNxSkt6cXpEb3pu?=
 =?utf-8?B?U2NPTXF6UjJmVXdLL2ovU1NqM01yMFpPNDFFRnR4TFpqVG1POCt0Z2h1YTh3?=
 =?utf-8?B?T3hzcnQwd1M0UjR2bWZoVEd2cVdNYVBKbjdOa0MreDE2eTlnaWtuQzV1ZFBL?=
 =?utf-8?B?UzMwR1h1UDBiUlB5U25nOTJodWlTNmFhb0lHb1dzMW9JMWFlSUVOTklFdDRO?=
 =?utf-8?B?bzFjdVZoaFJ2OENHd3ViclQ0MUpaVlBubkd2UDJNR2Z0U25lQUlGL1ZxS3hU?=
 =?utf-8?B?eWZoQVQ1V2VnWFh3SW1IZjhMRE5JUE5XdHo0YTVYUzk0UGdxNFZKa3dualg4?=
 =?utf-8?B?aTNrdTFqSmY4TG16VW0xcndEMi9MOGNFeDNSNTd5SEtDWWZ0MmZhZW9WcWVs?=
 =?utf-8?B?ZDZheWVZYmxsRFNUdStMdTJPRkJYdk5wbWdiWWVBWE1ZbUlScTcxaUtUajBt?=
 =?utf-8?B?aGZ1TnExMlc4YXYxbnVNemd2VUhMZ3gvTERiNUdkODZwQVgzWGJ3djBDbVBr?=
 =?utf-8?B?WWNIandUVnNnYzcveUJydjRUdC9rVGZSbDFNWnNJUmVsOUZjWHBxSm0xVUV5?=
 =?utf-8?B?UERzTFZzQkNRQzRCNmY5Lzl3ZitNTkxwZFc4d2Q1ckUwUEd2aXljMXRVS042?=
 =?utf-8?B?ZHJvMUNhUkl5RHQvTmNiWm0xZnk4UlV5U1VyN0psK1p3MzQ0UWI2RjRvUTB6?=
 =?utf-8?B?WGdhYWpjcHNoRmJTWVJodGRzeUpBalVJMG9mSUpGTEwrMzZiczVuSHVvQ3g4?=
 =?utf-8?B?djNpTXNQK3kzVmZ1N0w2aHRvQzNrU1IwYXRvbXp1MXJabkxueXMwdjFYeUdQ?=
 =?utf-8?B?bitPNTJJcktKNHBqRVhZRlJCUElqNzF1VHQvNmRSVWMrUWRHTERxeHlKMzNJ?=
 =?utf-8?B?YXRicFdZNCsxSEhpbmNyOUZjcnI4UG5veWhmQVNtdURoejlUR3lZc3JORTJG?=
 =?utf-8?B?dHEzdkxkTEVranhnMUt0UWNDMXFWSzR4STVhRzNEQjk2Y1NQWWtpSTZNMGx6?=
 =?utf-8?B?Zk4ybkJDemZEQk1BQUpMRHd4RENDdmhFY0NCenVmeEloanhHSExEMWxPRTFF?=
 =?utf-8?B?Zjg1T0t4YXZyRnRyZTlhYlZWMzE5UWhlZ21nUFkwS1p5TWN2cnpVMUhRWGRZ?=
 =?utf-8?B?UUo5OTcyRU5aYmZTVUcvRG1TT0UzL24weHlsV1hQN1A1THE1b2tlS2VqQXZZ?=
 =?utf-8?B?SmlpUEVqajdoRUkyU3cxanRZdjAyUDBnazU5UFFDVS82alFWeGFjQzZnaWM0?=
 =?utf-8?B?Nzl3WlNta3FUa1I3S0tTWDMwVyszdHFyOGg3WDVFcjU4b3d6Z0VMMHZQTitD?=
 =?utf-8?B?WWtDdzdsZ2VJSTF5VzIyc1BvN1UzenRFa1FTRXp5YzNrUWM5VTNlRlVjSzZ3?=
 =?utf-8?B?M3pYYmc0QXFUam8xLzNvZ1BHaE1qU1NMNzJXOVBKK0VTUDk4bkpYRzNLS3Rt?=
 =?utf-8?B?YThna3dTc3pYUnZkMERUMWRza2M0akNkUUltbnhRaHduVzFPM3laUGZuWjVa?=
 =?utf-8?B?RTFvV20zOHFZNUVjeGFVOUU4NXFnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e92d48-e405-479f-fa3f-08dac8b1b52a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 15:38:00.4056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwPbIkGvrppU0F0rmJnMZHoIAsXH5/lV87Nt6v9RJi9tigGcXZGWfXN6NqmfOfg9j7WcIFWjNDsUpAOWe03xyCGW6AW7MS3ZrcPg1OyVTvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5242
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series addresses two bugs in the NFP driver.

PATCH 1/2: Ensure that information displayed by "devlink port show"
           reflects the number of lanes available to be split.

PATCH 2/1: Avoid NULL dereference in ethtool test code.

Diana Wang (1):
  nfp: fill splittable of devlink_port_attrs correctly

Jaco Coetzee (1):
  nfp: add port from netdev validation for EEPROM access

 drivers/net/ethernet/netronome/nfp/nfp_devlink.c     | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.30.2

