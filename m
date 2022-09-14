Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F56B5B8C7B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiINQHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiINQHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:07:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2105.outbound.protection.outlook.com [40.107.223.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F3E52FF2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXPSHhC25vTmgSImqrwG8rko4Z2C1CdQ4SvlB8DPZduYpes8d+GziEpSWrLyXnqfmRV74cto9h3p6BZ8wP0xHqXm3zVTkfeXp6EfaNTqVrzH22zXg83y9zD/vwXLpcCUsHKEmV3DASurcOo13DAjMGknKp0bhlrYANGx2NSrHjbTYcf0xpPnzhTL/kbmmUkHIhN9WxA7HgVmcwhLqtIzjJcF+XmmG/XvUfZS6+dqNbbyqi79ccsySJQpXQR8PToxUtk2wbyWt99WLnrm6JV8nI4o+D4VPBY7m5Ba75Ah84fajKI3SfMaGvZO8wiknsMkniPcAuk3DOQobIorK+p6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkY1+SWxCPVSX7d2/QpwrYCvRG2qGad/TLbfl+lz2Pg=;
 b=llSprZajrPged7R1He9Yz3ohca9CyJZx0gjMxerE/pXs07l0VsQfzN/hbCU1KDSR3NxrMgUwWLE8AXDGCuDXtuugZxyOzlQf1yl3vQ0pkW83ezCusmTtg9Bi1aJU4FT+9HOdZw+K4UUl9eu30RFCO6w8ShSCYLZX9ZE9Qc5M4W7CTL2chucq/zrM5PZ8nmRVhbS8TV6Pdu+c4upQO5PYeyfXfdC84tHMQ5c6RGbwbIgDX0ub4FxacHwKMLYpiIludb6tLfjUYQiHdLyuDwPK5NNeUcFVcWQhkYEiFckXQyYdWHSEqo6Xe9jIxNWnRnTfS5m27ZEjeGxYOOtTggPWOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkY1+SWxCPVSX7d2/QpwrYCvRG2qGad/TLbfl+lz2Pg=;
 b=Hzv9wF9A8pLZSZzudn98QMFMZd3eQruEv4Fzs9Qb6KmO9kJOZhNgqLJQMOV9swuey3xw/crKJxAOKHO6TJb/Sai0vEPWXcmeLw1RzH23wPkzSBfQm20Xxm2oKXA4HveAvLMt/pw8oIKbbedv8aHGAjnCVRktGf03NQ66Onpx7Uc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5018.namprd13.prod.outlook.com (2603:10b6:510:91::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.5; Wed, 14 Sep
 2022 16:07:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5632.012; Wed, 14 Sep 2022
 16:07:03 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Hui Zhou <hui.zhou@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: [PATCH net-next 0/3] nfp: flower: police validation and ct enhancements
Date:   Wed, 14 Sep 2022 17:06:01 +0100
Message-Id: <20220914160604.1740282-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 774648a7-60d4-4aba-965b-08da966b299b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2TREtfMvM7Tfb/3huitFW4uf60EZNFZGThnpKuT7c2Qomcj7KHGxano0U1y2OdUwIn/Ifi+cWY8Mxy9FlMH/hyXBr4WwVFUqT97tqorDp8KNHxQDLlV041tS/mC7DXNkhQfUnqnLJqMfl+mV0G3XYf2dZqaOTPWSPec/9Gmhax78OBJTs7OP9ePRMGGiTkGtCBU8v3VMc0QcNVgPYW6mnlC1wn1GHAXai1ui6FWdtxm/uu6U8zWj963sDtVRsPMx5VmiUJoA+iALasCO6+45n59ur3SjOaiSmktv1CCi/EKP37/KDFXu7kAPb3ZMu9E6HbGTF0NP+6nBFtszqoFYPUQGqBwlQsTVLvH0Nl83nQi9+Zkjnm1TXQOyU5nnlvHrw/Ye1wCgwm79GQ7JtDX49I/Lih6v4NecBSRCXsij+gtX95i2aalDIopdBVThYos7R/JNJ7gLYJ7TUIrt9bNpnD2U8mS2m+mkXNDbngM2w4nouulVnujLxLRePOkF8GVEikPcM5CnGUYsJ01W2I8c7UveNRDszxZ8/7Nu9ceTIZW76n03GCD4HsJopOTGLAapIOVmZrLvKEW7ztb+PlUJa4Ut1X8JGfTX7Ny4scnNRVgKqGF3PdfuRJT4T5yKtvjGaK/evraR90aBq5pPB55oUSXzVf+pGVwdWrejHVrMl/COtSLHOC92NL01zKQoJZ/sKKNgtFpAQlBhR4+0qyX0zO1/EcxfxW/WuOt3ISWIAzYegeGDwxGhtLStxC81U5vREkyqbRrTLMVZ+ls12t/Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39830400003)(136003)(376002)(396003)(451199015)(38100700002)(38350700002)(66476007)(36756003)(52116002)(6486002)(41300700001)(26005)(4744005)(6512007)(44832011)(6506007)(4326008)(110136005)(83380400001)(8676002)(478600001)(107886003)(66556008)(54906003)(66946007)(8936002)(1076003)(186003)(2906002)(2616005)(5660300002)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xejJ/K42reftG1kI3NqJjfKvo6JH8ikPVSuayZ4QJESsuosFlj175SBr89OE?=
 =?us-ascii?Q?cfRRSe5PKbEhEHg5+pH5Febl1Pf3fSNg11MmsIgNiLaZj/xX3DCyfCqKA6FR?=
 =?us-ascii?Q?/V+g4ZaBLAZolhYi6cCaAq9UtxKh9SKTBRUsInVvCf5BhVSEBcwtJMM/4Q6T?=
 =?us-ascii?Q?l2JdQWGfEjapi3L7TuAK8eWON9lwtXmr0dsJOuUX35aSD7Scf4S0QlKrUGUD?=
 =?us-ascii?Q?VfCb1NBzsfvQmS4AOYV4Pibdbia99BLu8KGU/tm1/Z6xIk4dOn088+Iph3Jc?=
 =?us-ascii?Q?7dWuFL7yR39gVucFyy/8Z9rpfqOXkdUuQsMsI6vkgfoGVhWIdDqaRWeY38Ms?=
 =?us-ascii?Q?Xu6DOMcrdN7OvtrT6pUghDByYVYUlOj7Ox1O3MV91EYRNkp3rgUk/1x/4ofI?=
 =?us-ascii?Q?1YHHHfCwZ/q1jCZZcNsQqm0Yq2G1KvW8St8Uhy3V+roPaxLdjVQq1GWLqUkM?=
 =?us-ascii?Q?5QjnBUWFYTPaoTbkmVLiPZFAJBM8/0mTms5UCxbvaSiJFg4xr+NOwGhz32hB?=
 =?us-ascii?Q?T7V1FvXfFGMALJ7MUPERVkab6KNlzlO963oO8Oww8TMoSPh/uwB/2rBWereH?=
 =?us-ascii?Q?VFnNCjdeqkRXym8TsniHqyFqMlW0qlMTCZ2ha93XLZwkPsA3P+LzrrTF7DNi?=
 =?us-ascii?Q?3uBl88OgwgFF5mZ4F1ekkAeYry2BwPfDdFSNuSLEoxJ54rYrUs2fUDVXnGmy?=
 =?us-ascii?Q?Casl7CAGiGtxViJMsRrGy7ZJqAGc2SfawVQgC9ZAkXnthxAH8WjPcSKwJdPu?=
 =?us-ascii?Q?Zi6bXu2DFWZtvsFGOu2YYUeoWZgRoxA5aGT2DPSP2aMt9LJzcvEwHDNkkHA6?=
 =?us-ascii?Q?y9y571gFb/BKS6r64YPPxCr5TqdTRcvsbOVhCvkUEDJhK+mn8Woq9tn4bSho?=
 =?us-ascii?Q?4Y9qf1QjDb2NYI43Ta0SyJwJnMpKJzT1WDoH3gN5e45rIR+TBrl0uzThH83P?=
 =?us-ascii?Q?Opr/xVD8tL0ZLQ5XpvVthbpv1z3+5+xpmfQvN75anCLczBlULWVN3NML/+JT?=
 =?us-ascii?Q?3KCY+EWl0WIAMtyGcNo/pgKYP7AZX81DsCCHYAXGxSJnMReCzELBjPrDc7IH?=
 =?us-ascii?Q?nfmZhpgPgzgaZw5YcZ6updjAlHuwoIPhSxQjaMHZWqY7hW5c2T/U26jpyfjx?=
 =?us-ascii?Q?XXqFd/+YjMVoApw0eZZ2Walp7CNokfc5LfLq9nBhMc+fVXJDGrDycw4POB2n?=
 =?us-ascii?Q?XTBfbLxT7S6Dc9ecWGQRxY6UiLnOdNM/YXKcJSetRB+tX5/le/yzc6ZU9DFB?=
 =?us-ascii?Q?7GqSxiU4lGk8+IcEGLCmUNETTVeDFfC1BlQo924kLS4PjBEccINHpi/2Hh0G?=
 =?us-ascii?Q?3SIOmwjnqMg/7+k20htWqTjuZd0B35NDPM6EejW5B/UzsHMQsPv8OHSFZ3Wt?=
 =?us-ascii?Q?S21ZEIC1jek04RIT9q2ngY2yi6l+JXmttg2bLtux8nLgQv/3NcfwkTzf0oGj?=
 =?us-ascii?Q?Y9hxVKA0k9dUupTRpTwFTjrORiKdT3cYR8oZjBOy2G9XngB2pc4ngrKbWLlu?=
 =?us-ascii?Q?muB2cRO3ASW5tG0x3CN6bVau1Oay290pd5DJSLozOlYvCesIFxFigat0IkqT?=
 =?us-ascii?Q?WGiZFPdro0HklYDGjByVr0trhNiHBnEdm6tLbQVc46Yu9tfe5MBOL7oGUu0K?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5018
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series enhances the flower hardware offload
facility provided by the nfp driver.

1. Add validation of police actions created independently of flows

2. Add support offload of ct NAT action

3. Support offload of rule which has both vlan push/pop/mangle
   and ct action

Hui Zhou (2):
  nfp: flower: support hw offload for ct nat action
  nfp: flower: support vlan action in pre_ct

Ziyang Chen (1):
  nfp: flower: add validation of for police actions which are
    independent of flows

 .../ethernet/netronome/nfp/flower/conntrack.c | 242 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |   6 +
 .../ethernet/netronome/nfp/flower/qos_conf.c  |  31 ++-
 3 files changed, 263 insertions(+), 16 deletions(-)

-- 
2.30.2

