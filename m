Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B326BF2E6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCQUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCQUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:42:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2101.outbound.protection.outlook.com [40.107.93.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3179554C9C;
        Fri, 17 Mar 2023 13:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYmI+lQSXjRBFphxxkxjvoAGwBY388P+mOgb6lvS5fsRxSvudWIpeRQyEHyLZMKxm5j4ztukBcChgf0DVn7s0m6ps7ii11Dyzf3h74Z8E1EHvZtpK35U28XvuX+aLZVQtJUSiOgY2tJUTywuKmbVXcWLuSYsveABMUegNo+ub8CbB9htztWjNm3Sh9o24lET2+KCR3MAIdgwFYUdBAfAPWA5brANU4cLBXYD/uPNK9vR5/xpJq6obCEkK48wSJTXzut30X/QI6nDcJDXEQnNtwZeMiz3C9vT7YOYPU/5ipFAM5OdorQdyNXDVTJFERNTdWbRsO67jreIVmD+qHLihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sL4COKv/i5dIlhHszreQgT1ja+/HC8RJ9VnMOe5aWU=;
 b=T1JggwTddJFV7ddpV99Ai6mZDYFte97vdTUepn2in/kQxn4injsAL8ApnwH63rG7hpEAQsLsQOrPwI6ab59YkP3DU6+0mqq74qvXKM0FI78cxhC20Q2gbSGMbXD8WjqLXRTUu3obBF9MVrMsjQJXUeU51TglMqayg4UJS4szohARoZK2FazGpTOA+rIoT9KTcOl1ejihvER4LT+KZtjq2nItXV7MCA9b1iDCM4TKxoQEDlTQc/XX42cuA9IN95nt6Lip3wMPxJFXL/tQpd2cr0ZzX3sPQOO7uGZJpaLfXxzwVYADBpDWDd25raSPYNo3wEDsXZhGAosfzoRTRUhBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sL4COKv/i5dIlhHszreQgT1ja+/HC8RJ9VnMOe5aWU=;
 b=GTIlQ4L021xN7qf0ZU982AG+yA0978bDHsBwEnJEpuAFUDFR1VpJ0OJc5rclVHiWUIu1TCJl7p2mefQv7AOZhYiHuMc85xlQ33OXGkZ3wyqemiodlAAdLWoaIwuEwtFLJHnL+zYje3ILlYmErVt3fdjYbBiLFPSaWPodd14zKyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6249.namprd13.prod.outlook.com (2603:10b6:8:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 20:42:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 20:42:44 +0000
Date:   Fri, 17 Mar 2023 21:42:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v13 0/4] Add support for NXP bluetooth chipsets
Message-ID: <ZBTQu4RXHHbVRJTA@corigine.com>
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
 <CABBYNZ+DM+DKYVb-EqRX+WwW2hCrcVeMh29PVjqTM0WW2+HBuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZ+DM+DKYVb-EqRX+WwW2hCrcVeMh29PVjqTM0WW2+HBuw@mail.gmail.com>
X-ClientProxiedBy: AS4P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9e5157-edeb-409f-fa9e-08db272828cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3xSpv6766WT0Ng4/YiBoT+ipIFm2oExF6c2FfsY0cI0yXY8kIEBdroPD8omadpZZk8Y95Y7TRk34FD368SW7AFHn1qZAOqZVEhXQhd1thgrBpjsKdaaq69TcvNWwlecdGoXLeW75RE3yPv/S6oVj+N/nk72pi09BeOtDgqcoZqeH2AFcsLGr2ARh17/7w6/yAYGlTs8O+pNuTkfsVqBozqv5HPajli4HXrDYqEuElePW9B/NBSRrk97x/ZBM27CpHOV4yDlBcnWFzSvXc09soU+Yp+4whX5R+BD6aP17KFj5ZpN78r7pGHf+QEZ+nEG1sD1ogp3EVf+9JA5NbO6N+yEafMlxDLr9RpFeOWHLsPPnTJrG8EBD+WxKGoUPUk5uJiv9ngRG3Oq5v3JzzyqmNFBZWs9Ey8E8TJIvJprZUbEhXhHBodn6Ys81j6NsUqJMCrCAH8ZliN11LhKYNigz/+SA3XWelhmVaoSvtS2Ml5ulc0JBnW9/yg7S+YWOlBkU8UHjlIZAHbfLGEdEWU077Lg2wl8YLvg3Cs8niRB/LelXtYZ0Qj8Qh6iJdLLnbpf5WFL2NNwyGOGRuMOK+hJ+Nv9GLc+0DvyrbKyQdF27/TNew0w27gOAmopE5SdNOrow6Nyyt9wCI7mJMfhYB1zGwBGvfRrJwKnne6ripoR+6ZZfskmZFa9LcxU7umaNYPc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(366004)(376002)(39840400004)(451199018)(6506007)(41300700001)(316002)(6916009)(8676002)(66476007)(4326008)(66556008)(186003)(2616005)(83380400001)(7416002)(53546011)(44832011)(5660300002)(478600001)(66946007)(6486002)(36756003)(8936002)(6666004)(38100700002)(6512007)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVlxcEZQMWtBYlczcm1hQ04xV1IxR0U5cTJnUE1tVkVvd3B4VGxlYlZmT0lh?=
 =?utf-8?B?eEdXbTNDc0RIZWg0U1Jkenp3aldRRVF1OVV0dGhhcG9xbnI3ZFdZdjdJNjIz?=
 =?utf-8?B?ck42VXBQdUhrZjNCU3llVmQ3UE1ML1lwbkdwWXhVNGJMSEtzUE5mYmozMkdP?=
 =?utf-8?B?cTJHUnlmSUMxVWxpcDFNSXZBdWh4U0tXbUtUd0NYYk5vamNPc3krUWhxRFZC?=
 =?utf-8?B?STJhSXJCZVRTQ2FXRHR3RnA3L0xNQ1dTMDJ5NzRhQ2gzQjVRU0NpUGNIZUZT?=
 =?utf-8?B?WG5oTUdaOTRQRGw0a0p5cFBmOE1zMkd0S1Rvc05UUGM0OEpjTmJFUStkbk1D?=
 =?utf-8?B?Qk1zRXVKRkppUGt2S05jMUZpaXFSL3lWR1FpbXp5d244bENleW8yTlU5bkdJ?=
 =?utf-8?B?ZXo4U2VkbkVWUnZUbDJwQ0ZxQ012UjJmamFQNDB4NG5LV1ppUDBkS3lWQTVt?=
 =?utf-8?B?TG9KUzBreGlOY2E5ZXZYTno1TU5tUUdWY1RyQmJvZU42Mm1jSHdNeDNvRHRp?=
 =?utf-8?B?SWNRS1JCam5Ba2V6VWtUc3lMNWlHT1kxQXhRUkVkOS9rSXJnRndjT2tSYmkr?=
 =?utf-8?B?OGQrdmVoSkM5Q1FNL1g5dEZlRkFaV0txZjU0ZjJLSzBpbjhOUEFUSXN2d3FO?=
 =?utf-8?B?VHdYUEhhSk1ySVRBbFNxaENZT3VYWExuZWdOT2pNMGJSeHFtMjNURjdOWU1k?=
 =?utf-8?B?anUzeDZmbGQxcEZua3ViSDRsenAwaEdVajNHSVczWmdEQWp0a1dESThSSVNK?=
 =?utf-8?B?T0VjQ1huK1Y4VDFKcFF0SXNOL3dQYVJsTDA3Z3hYK2xJcCtJK1prdUJWenly?=
 =?utf-8?B?Q2EzZFVWRTVmRFFQeEN2ZVB6WWVOWVlnOVliK0dHRFBzNXRQd1Z6M3JUVW9a?=
 =?utf-8?B?c1JTNEl5Z2xTb0lYZUJVWTFFWkVKbE1lUmtwTk41dWx0am5OR3lzQ082Z2I4?=
 =?utf-8?B?dlg4Ris4L1hLVFNoYnJWajZCRmpVK0gwVlpyRVlDcWZnU2FHNmdtYmhZRVE5?=
 =?utf-8?B?aHN6VUg0VUNMY0x0bWc1d1V3SWJhMHZDQVZmbzR6VDkzOVBWNFozSXAvbE5p?=
 =?utf-8?B?ZGttck1CcHhHdEZ5WlE3QVJkUE9zcjZjdVFmaitKd1BpdGdJUUp6UnA0eUJS?=
 =?utf-8?B?SGFrejNhN3NzNmpIbjdvbTZIVnIzeEVQc1V3dUtoRG1Ick1CY2VXcFJuclFn?=
 =?utf-8?B?SStTZmE5TDJvK1ZPSEtoVXVWYXRFM3c2L0NzWVVFa2QxZ2NDK25LT01JYW94?=
 =?utf-8?B?SlpVNjE5T2RVUm1VUE5uVmg1T0NLNmtKN245TDdwMTJCdzVndjVUOUNZTXJz?=
 =?utf-8?B?TytOQnZwTjVRWGpPQVZmM1dSRDV4ZGtQbDc2Rk5SZGU3YUs1VGhmRk5vUnIr?=
 =?utf-8?B?VGxOcUxYMEtVR3JSa2JPc3A1R25yWW5PR3o5dlRmUG53ZXNOclpLcTVPZG9m?=
 =?utf-8?B?MmlCUVlOSklrOFZPVnkrZjU1TGF6WUpwemxTdjc1ZW1xY3cyY0YwSjdrY3VW?=
 =?utf-8?B?YmRjbVVkRkIzaEJQRFE4cUhSZmt0bXVYK3F2UWdUNFNtMEdKYWU2cVlMY1d6?=
 =?utf-8?B?L2l0aUttRUtva2ZUOER3Rml3Ti90MkRFdUliSnMvYkZFczFwWVFUTVVicFpR?=
 =?utf-8?B?ZFdEVU9pTWNGY0tVaS9ROWYxOTVvQU12WERod1g1UnFsSkJ4VWxBVXl3SzR3?=
 =?utf-8?B?NjZNTVEzQitjVWZvSGE0KzV1OTZQRHdnTnJzMDFqOGZTdzVHNElSdEZuYzQx?=
 =?utf-8?B?K1ZkR2tNL09JVHAzbE5oR2o0Z2E3NG9RQVVMbWswV25ucEgzdGZZZ2VYbGJ3?=
 =?utf-8?B?alhJek11Nk5pak55a2dPWk9sOTQ2ZnlmcXBsS1BLN25oRmNIdFNnUlk0cFJP?=
 =?utf-8?B?eXd5QUdPaW9SYTZJN0gwNkRnblNqVGdOOFZqT2t5TmlBaVF4RG45TzlFOWlh?=
 =?utf-8?B?SFhnb2xqRDFqd2cyL0N4dWxNN1Q2SHk4S0hvbmtkMVlvTkJJaGJHQkRONWtL?=
 =?utf-8?B?RUY3UUZRczR3cEkwZmh0TWZBVDEwb0xPUUdvMExvcjJEcjd5WDRnN1MwZ0Jz?=
 =?utf-8?B?T3BhUHBVZFNFMEJqdC9sRVorREVabkZ3bE9DeURTeTNHK29ZNDZTeEVERjh0?=
 =?utf-8?B?ellBNTRMVjdsK0Y2bGNmdVZ3Q0piWWJrZ1JydTd0Nk9FQk1Id25TejY3MDYv?=
 =?utf-8?B?NFowSG9Tb0w1NTlEc3dDaU5VYkRBYmlLbVA1RDFxeStaQW1aZXhQT2NJUXRP?=
 =?utf-8?B?b3pTU0NqZEJydHJ0ZGU1UEp2dldBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9e5157-edeb-409f-fa9e-08db272828cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 20:42:44.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcDbRPWOfxdS3zrKCEvsfcenuv0lI8Td1q23hfxLibT2UbDUJZqsIGsvvtNxNurYwpZ60LKoKPEshSINs9PuuvqSjcFmrEnR6f7yKQX82Bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6249
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:00:11PM -0700, Luiz Augusto von Dentz wrote:
> Hi Neeraj,
> 
> On Thu, Mar 16, 2023 at 10:22 AM Neeraj Sanjay Kale
> <neeraj.sanjaykale@nxp.com> wrote:
> >
> > This patch adds a driver for NXP bluetooth chipsets.
> >
> > The driver is based on H4 protocol, and uses serdev APIs. It supports host
> > to chip power save feature, which is signalled by the host by asserting
> > break over UART TX lines, to put the chip into sleep state.
> >
> > To support this feature, break_ctl has also been added to serdev-tty along
> > with a new serdev API serdev_device_break_ctl().
> >
> > This driver is capable of downloading firmware into the chip over UART.
> >
> > The document specifying device tree bindings for this driver is also
> > included in this patch series.
> >
> > Neeraj Sanjay Kale (4):
> >   serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
> >   serdev: Add method to assert break signal over tty UART port
> >   dt-bindings: net: bluetooth: Add NXP bluetooth support
> >   Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
> >
> >  .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
> >  MAINTAINERS                                   |    7 +
> >  drivers/bluetooth/Kconfig                     |   12 +
> >  drivers/bluetooth/Makefile                    |    1 +
> >  drivers/bluetooth/btnxpuart.c                 | 1297 +++++++++++++++++
> >  drivers/tty/serdev/core.c                     |   17 +-
> >  drivers/tty/serdev/serdev-ttyport.c           |   16 +-
> >  include/linux/serdev.h                        |   10 +-
> >  8 files changed, 1398 insertions(+), 7 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> >  create mode 100644 drivers/bluetooth/btnxpuart.c
> >
> > --
> > 2.34.1
> 
> If there are no new comments to be addressed by the end of the day I'm
> planning to merge this into bluetooth-next.

FWIIW, as someone involved in the review of this series, I am fine with that.
Even though I have only supplied tags for some of the patches;
those for which I feel that it is appropriate.
