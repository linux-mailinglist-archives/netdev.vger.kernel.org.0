Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D75091C4
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 23:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382343AbiDTVMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 17:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382341AbiDTVMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 17:12:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F29B1A80E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 14:10:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B96Pi+UgYYmKomBWJP20QChlcdhc57jk9IOyJzJo526MCg+HYCiM23+QUYS3iONKZIP5z9w7lRiEP4b6K+nfP6Zm58huvO35iSzm0cr6sF+jV3ScKCbqm7bwu5kQKrOxNsklzw5VUiyJsD3+k4KWkxQ8BhxU35XflJwcx1G8LSl0IbQQgHCIzjHcq57LAoksFHunmHleciviEdnemSSINtB7I1e44CTu0TKK2OMGG5JG0dP660Ny+jyj2KSz9pcSJFKZaAxoZAAzIQKuu2gRh7gqELPid9ofo1geHHTv91SxMK+LHSqLkS+498w4/skFZSyH2V1nmm6LIqNDqvZl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuJ6M7gTT+RvLz2Ty7uI+eN4SVdUS0zYtenzz/AbTzc=;
 b=atXI0aTF6MgXeo/JHMXR5yXpZkbWyox864BIsW1BAknkRP5vE9G2srQ/WV0Ec0wbowsN5ywrQBDQ34c7K1hEkes8MxYV33cFV3gdTdUlTFV7gffvW4u+fy/wcoMxeek53XajMo94V8YL5s5BWwJEBc8/Ts2dF8VxahflDtIe/vgvVVHtHj5O8Y3hwWa9ApKFjP1JtZWC0RWstOEXoAk9bas3u/4aY8lg4EPxWsBTTgW2VYz6z6QGL+O8r2umtw7nNR6RSda3emOSjVgrjlaHRWVV8xsttATVCRmCTfHF7/JvEA25ZtbLsZwj6UwmvHm5DHaCrPyxb0ZEzpzoebvodQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuJ6M7gTT+RvLz2Ty7uI+eN4SVdUS0zYtenzz/AbTzc=;
 b=b50VxmTUWuOph2Sbc5qW3l/zL/V4KlWYrMOOOm1xpSdTa3QfcSdW4mEnb9PJ61Cig32ZQp6LqOIwN3A0S9ShTt7gT4qEY6szimqydYxtdrjRWZ5+O4hPqU8HxONCLXnOpV6G5fJsbRb/duKr7Wy5dO385XZUKdFk7Fv60kvnXT4=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by DM5PR10MB1548.namprd10.prod.outlook.com (2603:10b6:3:13::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Wed, 20 Apr 2022 21:09:58 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588%7]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 21:09:58 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Gratorp <Eric.Gratorp@infinera.com>
Subject: Ethernet TX buffer crossing 4K boundary?
Thread-Topic: Ethernet TX buffer crossing 4K boundary?
Thread-Index: AQHYVPr9tbvd8AYb60eB9nKHxEvVRQ==
Date:   Wed, 20 Apr 2022 21:09:58 +0000
Message-ID: <7e3fa36a3e16aca6fd7d00cadeeba8a8d71ceb0d.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e795fb91-3d3e-4132-5762-08da23122035
x-ms-traffictypediagnostic: DM5PR10MB1548:EE_
x-microsoft-antispam-prvs: <DM5PR10MB15480BBD44EA93E3C247B4C3F4F59@DM5PR10MB1548.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLCQ7RuTdKr4L9G3As4/XA7GPzCRY3qI9va/dbAyTe0oJ0yUYLcuPKL4dTqxW2dQFeWdq6+vYFHMHozLq2E9OKSwWLj0hiybBwVKdZS32CRSZuEaJEo2ZxaZH+OW5Rt6G8+PV3kuu3gI4NbvqVRfVOiBmjHylvcbiH73lBxcSBgVVcb/13hhZTgrVYbeAA5gRSjM3bOj+/P+i9IG8BSnj4taU6dpq1oiAdPDHsWC0DeCrdPlg0K7I0pvzlhNoocgBvqd/hZ3nw7ws1Fk4Qw8lEE/0V0q4nVmw4IT8K6YXClJtw6cCPMWHuY+FdZCMlHdG+pGzB3QnHZZ5xLcAolqAo8fhgmTpKO3C0mn33vVByWL6brtW/GTNMDzbdjxl/Gd5pdMGPskR1MoCp90k4NNDv8pERSBI+4etPsrt7XJiU2fcqxBd0Ue3xx+WP+d/n8KgQm4F1bcykLWyOGOG8XBOOI1QbIfnkIEXh0+7vbDrsOrQo35E7p1Ln6/R9fri9u9nGr/hd60INbdQO+Fi8x5DsnfkmALGujxAYZ+7lWTXsP52S4MUmDIMEz7ReVpVo9GjUWU2o0bj4vwheVmZR+WH9j3kCjvWX77JXosb2/Ih9zVyEeA74s7bOX6Ci95LnEp0Hp6yTFDLom5FUOLhmZL7BwcT8ZJdnhHpvKYnYNQsmV89i4hy5abXb8zR70yX4c7O9UnxWBHmh6WSICMzyEHQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(107886003)(83380400001)(316002)(66946007)(76116006)(66476007)(66556008)(64756008)(36756003)(4326008)(91956017)(71200400001)(66446008)(8676002)(6916009)(5660300002)(38070700005)(38100700002)(6486002)(26005)(558084003)(6512007)(186003)(86362001)(508600001)(2906002)(8936002)(6506007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzZ2YTZvVUV4MkVPL0pzUE0xcHZqTUxndUR6U1JOMXh6TFR6SkFRbzIzRTIv?=
 =?utf-8?B?NmZ2RytmK0Vyd1BRekYxbHcza1NXRlEyRmFXdXJaR0lvVzN1QnI5anNDS2hq?=
 =?utf-8?B?Q29EamtTc0xiTEN6ZGh6Mi9ta0pqRjBSejdvM2U5cWFSTm9xdXdCTEczM1NK?=
 =?utf-8?B?c1NqSlc4QlZicFlmZUk3SlNxeVR5Z2t0aUVUYnUvekFPTjFZelFnN3A3aHpW?=
 =?utf-8?B?ZnB4aTlqWW5GNytzTEc4TWp6QlVNdjRWVGxCWm5CSUx2bFA5L3pjTmR6Nnlh?=
 =?utf-8?B?dXFWVzc2ME9vZHFEY2dXd0FudFJKR2ZMeTR0bHJCUXdNMndzUm03ZWNZdE5I?=
 =?utf-8?B?OHFQNHlWSXVRbGp6aldjaWQ5TjFMdjkrcVo3MGpkcjhjQW9ZR2grSUYzTjVO?=
 =?utf-8?B?UnFKMExEY1BUdDY1cVZpT0wyZ0dhTCsxYW0xMEJ6blR3dTJ4MVlXcFh6b1Jj?=
 =?utf-8?B?cjBNQy9Ob1N6cjdSUUNxMmZrVzdKc0RyT0NJWFJacWUrL0h1am9LNk9FMTBl?=
 =?utf-8?B?Sm1zQld5L2xoRlJTaUszUThpSFFRTlI2U21YRHgzZEx2ck9ZUktUZW9pWVBq?=
 =?utf-8?B?blJoQjZLOG12VVdoL2ZPS3pqWUR6dnpJMnYxblJ0a081Z2RSTmk4bnp2NURr?=
 =?utf-8?B?V0JXNURQWDB5TVhZMUZHTlhYcWV6WnhOL2xPQUUvMis5MXZueUZtQ0tObkNM?=
 =?utf-8?B?cWkxN2VvMU92aTB1N09mWVMvTUhsWTdjTk85NEJYOUlxaFJwZGRPSzRkZGNR?=
 =?utf-8?B?bmtDVVRBa2xGNTBSWjE1aXBPTStoOXZMeVZGWnRCb3UvOEZEcC9iT1cxQlRh?=
 =?utf-8?B?c0dmT0p0M05hMTNReDhCTkh6VGRSc0Z5alBVTUE5NDY4NGo1RDhROG5oR3Rp?=
 =?utf-8?B?SmY3UUJBRDlEVk9vNzlQL0hYRXVNZmxSY0E1Kzc1alBUTnNlWUxaWTY2MUpk?=
 =?utf-8?B?SXkrc09xRE9FdWQzTHZPOXIwZHB5Vm5VTWRXS2haZ0FremZyRUFjckZ2c0RW?=
 =?utf-8?B?UStUQzQ5djUwWStmcGVzMFpHeFVjNFhka3RMQm4rUWE0c3hjSG9XVWs0eERq?=
 =?utf-8?B?enQ0QnhndUwyb2lZSmFIbEtmQ3NqT0hyYm1qMTJWT2lVeVdiQkxwUlduRFB3?=
 =?utf-8?B?UXdaQm02cVJUVmh0azVWcG0xc1c2eHZiWGxOaitEK29VUktaMTVKQ0xMdjlP?=
 =?utf-8?B?YUhxQzlkZ0Q5K1I3ZW02eGJna3BaaC9UeTRSOWlyMHh1eFUwRXFFam5UWWNW?=
 =?utf-8?B?RElxTGF5OWZkVFlkUEpGeFRUYyt3WSthR0c4aVJRQUtrT09JNVRoTEpLeWNF?=
 =?utf-8?B?eGM5Q1VWd0FoUnhnQU4rMDlFcFlsZE1JZml6ZEpCTnhDOXV6T1paNjZ6Lzh4?=
 =?utf-8?B?OVNhUVJYSUV6K2xZdWNnbWRhTURRSWVDR0R2ZzFJL0lWcFh4TEVZRm92dTdH?=
 =?utf-8?B?NlRsb1hCWjhyYktRaHFwd2YrZHExbkg2RmVHekJGQlNxd0VpdzdkVGVFTXlo?=
 =?utf-8?B?ZXhuVXV4OGljaDRoc2U0STBnNHlWdFlWY0tFb2swdXh2T1U3UjIzTkhJd0Zx?=
 =?utf-8?B?OWl5YndKNkpLVHJPUlUyRTVZUEtsUTc2bHVqRXp3ZGRvWEZxeTBTUWpJYkFK?=
 =?utf-8?B?MjErSzhaU0xycEl6dzdwYi9nWUtKU2ROQlBwdnZuVnJzNnozb3R1RnREcFAz?=
 =?utf-8?B?Q0x1eWNqcU11K0ZuSmh3Um4yUzVLdmoyUmhXUlR2SWFlQlo2bFNLb0g5VExH?=
 =?utf-8?B?eE93aVIxQ1hrZExHM1BDU25MNVVpTUlRRjdBK3VBdWtjanZSak5EU3l0bEk1?=
 =?utf-8?B?c0lTalVFMi9GSUZaUVN6T2dYb0l1Wlp6V1BTSUFIQXExbkorVjhuVWZkdHhN?=
 =?utf-8?B?QUNQNVBrNUxhQ0lKNmRWaENyVEZ1MDhPdjBCSFBPZHlkc2NjK1o0RGdzZWpD?=
 =?utf-8?B?dEx2SlpnUCtidzNmZ1RzUFZ4RC9pVGNvM243Wm1MTlRXRG81YWZjdno4ZXJ0?=
 =?utf-8?B?Qjk4TjVoam0zZDRHQ1dPRVJDbnNmOGhBenFrSEkzSFpKc3F4NWN0dm9tcVRx?=
 =?utf-8?B?azJva3VRb0pucWFpblNDWVJ4VWVZSmpKZDdhWjkzNmptOGJ1WHJJZi94YVBl?=
 =?utf-8?B?NWMyWEJKT1RUL3JMNEMya3FhQWJpMFFKSU1xV0xSYTRXM3l1SjIzM3hheGhq?=
 =?utf-8?B?Y08reHFoWUxTWEtvZ3BtUWUrVVE3T3pqNy9OKzgyRGwyNnZHblZXYnU0RE1I?=
 =?utf-8?B?ZkIzbWJIZHR2QWtmSWVQTkUvcmxGSjY5TzAxNUc4S0w5NDg5ZjQ0SlFsMnZw?=
 =?utf-8?B?Y1g0QzNiOUU3d1RQY1hDdXJiN0JGQkxWSXY0NDhucVpTdWV3RkF3TFoxSWNW?=
 =?utf-8?Q?z/eYZy1+C+S/xdGM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B01BE75CBE1DB347B359530D60BC2FA0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e795fb91-3d3e-4132-5762-08da23122035
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 21:09:58.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +eS1apnfb06ULjIxyp82NRHZXRxnYvn3ZAZXyzbAKbQiOiS5GW3NtvxkIYlbtlNSFFsycx+kAzis3yAdS+gkJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1548
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2UgaGF2ZSB0aGlzIGN1c3RvbSBFdGhlcm5ldCBjb250cm9sbGVyIHRoYXQgY2Fubm90IERNQSBh
IGJ1ZmZlciBpZiB0aGUgYnVmZmVyIGNyb3NzZXMgNEsgYm91bmRhcnkuDQpBbnkgaWRlYXMgaG93
IHRvIGRlYWwgd2l0aCB0aGF0IGxpbWl0YXRpb24gaW4gdGhlIGRyaXZlcj8NCg0KIEpvYWtpbQ0K
DQo=
