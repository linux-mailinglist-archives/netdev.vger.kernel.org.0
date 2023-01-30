Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE186809C5
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbjA3Jkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbjA3Jke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:40:34 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6E82C675;
        Mon, 30 Jan 2023 01:40:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLBUzw4fneL340OQqLayPhEcpr3/aa2JvhAaJi1erSbQJIfLVM75Sp4+Uw+pts5uAa6QvT9syb9ts7RvPpxAbstFHNXMYy/mlKW4QsHci7D8mzRsPAeskMHTvEg+3Yjc1qNEskmexgRh6ylnEEqJhO+zBb3Rmc9LF7Q272W71XCImzkdMpzxooVTUg5ecdCnle+men7suQ7cykSXhAjqdM5Tk3CvIhs6qIlqjOmmSOUu2d547D8RBTSlNWpt8D9ud6nHAKjlSk/TvrKhXDHV4bfYpUVJCcdLmPxmhiA4BF0xTvuSD5l2CirzLe4BEVsUfZiswGTG3LKSMiYDkOzNrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MOBZbBhapihdROTO8nqwiDj0ouSPfkaDoODH4r1Jj0=;
 b=XT/HcsUgCNDQuCAu6q0VrwF53v8W32poehWMnACPCbf8ebD6CWmPlkAfvmgvp6JLf2b3/TCpl2JUtkcXP7aLjUXyT/KqFitW2bmbgbQFqzeQEfc9o/Xy4JswlLiRPCuFv/ohZ5G8LNRDZRVphh+lyWLVDvmUSi+/M0sJF74GwGEJdHCYrtEqgRNymP/SYES0nxY64G9h6I3DWCmXS6jSZaGhT6EtmXrziXbPRxSmb83kHCBx8R7TAte/0A4WbpclSklUQh0Sz8o8aSgpbT+Oiv7Z0oTR4LfxjMjjKsZu5gdKCefwRYnyXt/VUZbQZiEq+LT0ZETVPqJEx0wBT+xl9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MOBZbBhapihdROTO8nqwiDj0ouSPfkaDoODH4r1Jj0=;
 b=J1ZEcZJl+T5yAUbFIaLVbpkwI1umzxzlfBMFcYaGkaTMJJZhoq2TmC0tBGUBMuE6dDeDV9XL10t9L5+ebwVPO1PtYKntnG0LfHfC6bXeL8rdDfEUjQnfAzoOmnSfSZs+Aro7pQHOQtOEZvjd2EDxEVgQTd7Q6NRhB2WuTY5h7A4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DM6PR11MB4441.namprd11.prod.outlook.com (2603:10b6:5:200::11)
 by CH3PR11MB7322.namprd11.prod.outlook.com (2603:10b6:610:14a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 09:40:09 +0000
Received: from DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60]) by DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 09:40:09 +0000
From:   Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Marek Vasut <marex@denx.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        netdev@vger.kernel.org,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Angus Ainslie <angus@akkea.ca>, ganapathi.kondraju@silabs.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        narasimha.anumolu@silabs.com, amol.hanwate@silabs.com,
        shivanadam.gude@silabs.com, srinivas.chappidi@silabs.com
Subject: [PATCH] wifi: rsi: Adding new driver Maintainers
Date:   Mon, 30 Jan 2023 15:09:51 +0530
Message-Id: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
X-Mailer: git-send-email 2.5.5
Content-Type: text/plain; charset=1
Content-Transfer-Encoding: base64
X-ClientProxiedBy: MA1P287CA0019.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::35) To DM6PR11MB4441.namprd11.prod.outlook.com
 (2603:10b6:5:200::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB4441:EE_|CH3PR11MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e68b62-593e-457d-58e5-08db02a5f998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bjn5lGcrHL0nqJPzgUI9H2GGf0oMOe1U5W3Qo2PXywy1ER77ejvLKPxne2ykfyd+RLtVvmmFUbdzNCtpR42yEvjLcutHeQmT8mQCA9NSWxPXTQ6E8kuTWWlAV2QdqEhJPrJWnT80I+/z193EiDpD02cJFcx8hjS6KfAz8N9qfXdha9SP1g/sJJBocw3TVNIUwY6Ty/GalIbL/OcDqkVivhiO+gmX8+5L5+HDWtaoFnsanQTBxsP7n/V5nJX5HXddi7GhIPdPj1Z4sAHttFgOBydj4hiLL0yZBak1FV2I6eamtKx70fEK/n/KrZbGuSA3c3uSYwiRjL/8mznmJsP4VX1fSx7BafFEKDL1LwzsJaF7y8hSDqznwUyFhf8ElNCzeR1DDXhLQwCzw9gUI2Wh9KFqpUbLElLfMndGdiXHium3AEHL93vuG5TO/4uTkSI7TPFSolelIJ4XAdJViPZrWbglqEBIs3hX4gAnppFGRfs1qRM7RRz7DeelbmsiOZQodS9pGwHE7IibV5uqfKff9xchWn87evzJHMFMm1OVigERauJ6VZUWiK2JHpv9rt555emqU2Dbs/N516NGPaiBgu7FI7rcbU2U/fB8LpAzRUXCd2A36syk+aQQaqznkxz/hM7vi6+UDNSBu6qiSDPRR/eEX8HKeo3ao8Z4+J76iZQ5LgN1kM13BZ2Aywqxs3GN2Q6h5Ou/ZjkWOd+rTIRSZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4441.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(39850400004)(346002)(396003)(451199018)(4326008)(6916009)(41300700001)(66556008)(66476007)(8676002)(107886003)(6666004)(66946007)(8936002)(316002)(54906003)(5660300002)(7416002)(44832011)(4744005)(6486002)(83380400001)(36756003)(2906002)(52116002)(26005)(186003)(6512007)(478600001)(6506007)(86362001)(2616005)(66574015)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YutceS84O/4w3Pb2AYL+c7Clpay6Li7s/Aevbm9n/NOEyOYWulNAqwz/ow0O?=
 =?us-ascii?Q?w24+xUsZQLe8l2eq0RuWBVpz4LZtGxyUIPC9PrrbG8a6flDyKuePxCxjUF9B?=
 =?us-ascii?Q?pGwiKG8JAtOTaSifCtzsK8R4lLKhqW0bU5xQMZdvReKjjTH0EK4h59Lyjlnz?=
 =?us-ascii?Q?xOQCsXFD2uBKk+K/tsqOruyH/7JAPdkOOlwn0yKNQHA1ATA3P9jGSj3buIyZ?=
 =?us-ascii?Q?BlvV3+rvFQg7o+Mt43R5krgnpmGfy1HmR3RAW7d17ZE3vPgiJsfHhawC7GNe?=
 =?us-ascii?Q?INAI3RgGI8PGc8WxvAoZv3/D3zxtvb9nDIVzvfu1jtalUTiH80y7uM+e/QUG?=
 =?us-ascii?Q?MwpNKzZ2ZbUn77Ld1VMxxWSTbDCkBDGpwESbZeb43o3EbTqLAaQc6JKTWFdg?=
 =?us-ascii?Q?85NinmdlFN1skLaar3ByYEld9GmB5vUEAbhVQzc4kDzZIpn3wTQaCvL6wimK?=
 =?us-ascii?Q?oc3ZFJsDUjwHh/3tYE1c1hk/LjERzgMIdL/NJ2uLhsrIBsWI8CLYzveUvvvL?=
 =?us-ascii?Q?+nJaZB3Z+vAIW8Ximy9AhJMReHq/oF2yYukR+QAY/UxIne4TshsT7jP6S4Cl?=
 =?us-ascii?Q?qsFsSDkQPXo/Uq9hwYT+q50HJwy1zAr0TAcZXhvbNTp1IfirNoXdHwreUNs+?=
 =?us-ascii?Q?tKszx6al15cCJb4phedi7SLcat4s03Hd2/DM/9rPOc5+aCG2U702+hjy2xr5?=
 =?us-ascii?Q?u/tfQh7sNVYdzevjONAtKw6UY2GSOYg8LPEVxy9XKvgy3wAT+k0WxbCuy11t?=
 =?us-ascii?Q?NMHH0nAvzO26Qdd/vkGmhi96HW1a/C8syS7afUuvd2G0heDwn0D0FwGG+irw?=
 =?us-ascii?Q?9w8kxoiKrd/5JFj3aEI1r+65/IafPofQu/zUPHU6+9SjxLFPmgkKkWGdZ348?=
 =?us-ascii?Q?o4lUaZo1gEjos6+wFRYDx3rUj2W0p+7UGn8cU/WFcY5onZvxjmaoY03cQSdw?=
 =?us-ascii?Q?E2vS93DsuXVG8xhr3/SLry9F2YR3xYpNf6Zecu8ELGhNz3r8LVoANr6eTOIj?=
 =?us-ascii?Q?8kYmeCf5ZmCuVx8spmWsZfjgARACKfXiO8KFWEMRQlWHN2F5iyyYQpShCseb?=
 =?us-ascii?Q?IBZGgc7HsYl/q07l0uealtsfLJW2Mbv6LCdnjGRk3CmO/NUBBaZh7cxq4h2t?=
 =?us-ascii?Q?l60Qk3KZSUlcc8xihkPypyRohr1QAcJkH21TUDiYTWp3thCQ0BbPV70B4PP+?=
 =?us-ascii?Q?YqN2b/7T9dnPVck6v3woC2jNaeBblJADxF7oK7t47HrfSwRdaYhTH6kkRpCB?=
 =?us-ascii?Q?EcU0H/Wtj104tU2XMLeHhrds6n7QVSySdog6Cr1FNkpLLybA0HamaiLOdH35?=
 =?us-ascii?Q?FvQBFoVOys8boHbu2zA9iMQDQBmrZ5LbgChc+NRtxP6Hwh0wtzT5qjxcEMgg?=
 =?us-ascii?Q?95RSF53SJNRCjQo5WIAXCEIt9G3RIrOVOrnZzlMhB4YFxqM62vvwPxw5Jn3J?=
 =?us-ascii?Q?3H6QMsL6WKEsSdoBt6oElhVfzgLqdWUu7UCxVc0NaNC7A9pxA0CusweHdqUA?=
 =?us-ascii?Q?JjBsymTHVFBdqQqQ0FrNZYbfYDSUU0yCHRLd0VDfd1iZ2hpR+kDhNP8s5HPv?=
 =?us-ascii?Q?TNsmhjZiBu87NIaJ20AZTG/6rUp9ko3M86dGvcjC?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e68b62-593e-457d-58e5-08db02a5f998
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4441.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 09:40:08.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nb5BiBWvhmSGXlRNMhdCP+lMBYcLHN7+I+QK8PxMn0Sy9rlRqQImNBjygXGJYEWIOdi+Wb5hXxFc55quyMk3Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7322
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2lsaWNvbiBMYWJzIGFjcXVpcmVkIFJlZHBpbmUgU2lnbmFscyByZWNlbnRseS4gSXQgbmVlZHMg
dG8gY29udGludWUKZ2l2aW5nIHN1cHBvcnQgdG8gdGhlIGV4aXN0aW5nIFJFRFBJTkUgV0lSRUxF
U1MgRFJJVkVSLiBBZGRlZCBuZXcKTWFpbnRhaW5lcnMgZm9yIGl0LgoKU2lnbmVkLW9mZi1ieTog
R2FuYXBhdGhpIEtvbmRyYWp1IDxnYW5hcGF0aGkua29uZHJhanVAc2lsYWJzLmNvbT4KLS0tCiBN
QUlOVEFJTkVSUyB8IDcgKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKaW5k
ZXggZWE5NDFkYy4uYWYwN2I4OCAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRB
SU5FUlMKQEAgLTE3NzA5LDggKzE3NzA5LDEzIEBAIFM6CU1haW50YWluZWQKIEY6CWRyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvCiAKIFJFRFBJTkUgV0lSRUxFU1MgRFJJVkVSCitN
OglOYXJhc2ltaGEgQW51bW9sdSA8bmFyYXNpbWhhLmFudW1vbHVAc2lsYWJzLmNvbT4KK006CUdh
bmFwYXRoaSBLb25kcmFqdSA8Z2FuYXBhdGhpLmtvbmRyYWp1QHNpbGFicy5jb20+CitNOglBbW9s
IEhhbndhdGUgPGFtb2wuaGFud2F0ZUBzaWxhYnMuY29tPgorTToJU2hpdmFuYWRhbSBHdWRlIDxz
aGl2YW5hZGFtLmd1ZGVAc2lsYWJzLmNvbT4KK006CUrDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KIEw6CWxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZwot
UzoJT3JwaGFuCitTOglNYWludGFpbmVkCiBGOglkcml2ZXJzL25ldC93aXJlbGVzcy9yc2kvCiAK
IFJFR0lTVEVSIE1BUCBBQlNUUkFDVElPTgotLSAKMi41LjUKCg==
