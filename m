Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41405B8BC6
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiINP1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiINP1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:27:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2113.outbound.protection.outlook.com [40.107.243.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7629F7C32E
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:27:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiXa5nGHjX2F1rCxVOfmCiGYjb1G6L2pdCiBXBoFnFCUl2ukRLud5xkdkvXcEdb7gpzi0Ky0rr8qrd3T3BN2ecnwlXLd3UzkgABNz4i/zbZZ6CRZYZuKX/lRISkG9HvYzR5wKltfq0vR9+zdipn7zXSlxPlyHznTuKBk3lVSLpZGkIbLgLaRPD/HQJLeVANdNnQD/j4i/CWSH5xSiuF+fDLnotXQwKq/3TPmMSaaL3oy+AY8tZ1877xmz1NPzK7RywvDujzNr7Pbmkekt746Z8n5yuOvFhdtQsm4Tui354nRt4J6NcEGEXmu1QFjoEbTXw7K78wZ95TKuQihb9pchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paxd4pJoN128mUKqyiWodXLS2ohU4Nfdzgk0R+Hyx3Q=;
 b=DHLG0aeLlzQY+zeY0X6C5m+n/8WtV298/+3AtT9m4U4fORyuJZ+V1i1Jg8qX/u2h+r45H2qyTcQVrwUEamKKBIW3QTUUW4h9lD8DMK56sWsjGOtl9VNSq4Zpoq5JUZFyMpYUQSX2nHckYvW2ge/RSoFd76IXd746l2cod2LZy0N7+ZBWdu6SAbsoiDPG09zzee/YBBHuYELDuIlMuKacVC5J9uUOMlC+5T2HLCqw3b2CxIlMuN7KNtzMdiC28gco4eIJuCdXjKMhvxv2oGPvCWzQoEkPnk0f19ftdJJREXlcsYHGx7xWNUcOrvotnbGsxi2ceF08+bT2Xam7Hoar9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paxd4pJoN128mUKqyiWodXLS2ohU4Nfdzgk0R+Hyx3Q=;
 b=QY2EyewhaHBqet2eIHnsWMi/3rsKlTQ0Mwn5VO9PLw7MP7ovR/lgSzlQ+Bq4Mm1cqTbsKXzPB5qakmDOFme8NF4QYpK3Y8/e5ySXlSzhDNa3EUsREC2Hvs/2psDdQdEsqEAOall6Fzeo1Qt+UNyxZqs+PO1YhdLv/NCiZxeOZdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6377.namprd10.prod.outlook.com
 (2603:10b6:510:1a7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 14 Sep
 2022 15:27:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:27:38 +0000
Date:   Wed, 14 Sep 2022 08:27:35 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [lee@kernel.org: [GIT PULL] Immutable branch between MFD, Net and
 Pinctrl due for the v6.0 merge window]
Message-ID: <YyHy53kHEMIhaoFb@euler>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: da489102-17c2-4198-3be7-08da9665a84b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KU3s5rKiRUkvZoAMYVdzrHkxQtTpVjmeUavp1X2Mr073snglFWoM53RcQT7mzVS3IyxuqlddlYgLhve3XssiHeIRFpkEYK46R2IFwAWYY9thzh+C7bwDq7afXeu8eUlz4bq4+kl22JYMP39/D6ff/kmJmAYBLERamYHPUT0o1dQkrjn3RpUzu9L4//qm+x0Pt/rWgKlSsTy4h6w946wwG1DYWL5yX0eGV/kXFjE0w2KqHoD5y+TT/jGOubCf0hkVT+UIoLR8ahJih+ssMCEfQ3sqpF4DzveD1wW2englWLpdEbiPxYvwb82aKVj6SS1+lYgePoZtvgaSEjnTfRHDjNokSAzHbU6ZDRlouC2CoXyGw76cr5PfsQQ2xbIs2C9RrxOU8cgwx/Ch07kOTciwJ+JD/UYTzLA+Jyu4l8RXzh7oSs/T30xKrUD9MJJIK3T6be16SdY8W5/9WtJWfah/fmUi3vPYy+usLJyJqslnTaXiKPYh1fRFqogHf1CW0aZ/8LF8vncG4+BeYcewVfGrZKNz4btM9DhKYQmbgZiEx2ieEDskom+52ICtMId/hPxGifb5KIxIbC2IRAmB7T4S4a4eWs1HoubQxyp8qfTbsAfRsHf4dnrmhhM3RvJCV8nn+v6AP5YZNcmtiwrzAKVpubigPC+s/fFSACFI2xljNdCz6l+1K9jzZj+yHCkyIZ7rhD1VYnYhAw5koFr9DAUPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(366004)(396003)(136003)(376002)(346002)(451199015)(66946007)(33716001)(54906003)(6916009)(8936002)(6666004)(26005)(6486002)(478600001)(66476007)(8676002)(41300700001)(86362001)(4326008)(9686003)(5660300002)(38100700002)(316002)(83380400001)(6512007)(44832011)(66556008)(2906002)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWdVV3ZOUzZNUWM3ZHNKOVNYeEwvTGdFaTJBMDltZ1VJN3R0cHBVcmdSSThD?=
 =?utf-8?B?Sk14bXdHYTd4S2J2K1lpMkVRaVRISWcvaTRvRWJrVGpRbFY1dWNoYWxlR0lu?=
 =?utf-8?B?NVhpaFJQVjJGNFE5cTJ3TC9xRkZSNFhXNGNqRU9LMFh2WjJFdllYQmQwZmJI?=
 =?utf-8?B?NGNjUmNxNXF2NEduZDdNcEw1OE9hVHErdktRTlBLS0Q1U3JwQ085OU02ZHBm?=
 =?utf-8?B?ZFVRbG1CRFpWTGhmdEpkUFNsTzVrUmhSWW05eFlFQmVoZGdLdjFXamh4TXhZ?=
 =?utf-8?B?REpQOFJFSFN1RVp6Ri9aT0Y4YVdtTHZ5aDVVWExSQUxoTzNIaWMrbjNIbHll?=
 =?utf-8?B?UzBiRVNEanZkaVIzeEhpUlV0SUwyZ1BWZnFCQnFHZGhYTEZ3ajRLakU2L0dG?=
 =?utf-8?B?Rjk0d0tKU3hUWW1DenB0c3FYbTBkUzhJa3ladXYwUTRQdlhwRFUrb2FIb0Mw?=
 =?utf-8?B?bzRDc08ySnRZc2hLSDZNME5UTHZLZDVBb2lvUW1yY2tMRzVjRkRseHpUNVVy?=
 =?utf-8?B?bDBoejBTSHBZVVJTZW1DVkVOZnk0aGJidmY5Wm81ZG11SlAydml5ajZnQ3Nu?=
 =?utf-8?B?eVV4cnJXRUR0ZHN5UGVnQmNoMGFzNW1BLzF5ZDcxc1I4djB2emkrYjdnMk1L?=
 =?utf-8?B?c2ErcHJxRDlsekxQdWczYmhsU3o5b3dKYXJ0bmlTUm9GNno3WVNwVmZycWs0?=
 =?utf-8?B?RnZZYUtTRzgzYzlCNStQL3BPRy84elQ4U09QQjRXOUhrS1dTeUt4ay9LT2xv?=
 =?utf-8?B?VEl0OUw5NmJSSWdRM24rdklzSXIrZnVXTmJRYmljSXQ1bVRES3hqd0NRa0Vl?=
 =?utf-8?B?Yk85eGNiTE9CWkJXK2h2cGRCT3VJWHZXTllTNXZHUXpYSm5LK0d3aGxHTXcx?=
 =?utf-8?B?ZG5QYzBVYkpYTCt4cVJMd1B2clR1K05EcDNyUHJHOHowdDlxMmticUdMWm56?=
 =?utf-8?B?YzhQalRvbWsvbGJvT0wrVDlmOXBqNW1QQmhjUEFuaW84M1pzekNkZkNvUU1E?=
 =?utf-8?B?TFBwckNWVnRPVjd1bnB5U0FsVHRuTXJ2cVUwMlk0THorNkdQOUovVUloU3B6?=
 =?utf-8?B?bm9zd2s3Q1o3WVVOYlRYZ2dnclU4TmJLS2RyV2lwekpqbFFHak1CSVhUYSt2?=
 =?utf-8?B?T0F4Mkc5SHh6RzNSVlA3MDNmVVRRbDRmb2JUV3krL2tyeUEvSk11K1RUQUJP?=
 =?utf-8?B?NGxRN3U4ZWRRamVwOExSRi82SWdvN1ZXckwzWE9kMnlEdjQ3U204NVNYYitO?=
 =?utf-8?B?WHFFQVBxNXVzQ3ZWcDZxZ1lkVVJrdjhXajlVNEgyRFJMamxvYk9aQWp3RGF4?=
 =?utf-8?B?aVFPVUMrdWdsYXVoamhCQmJUeUN0Szdhb0RQOE1BWm5DSlk1bXlCcmFjSnRZ?=
 =?utf-8?B?NmRFbDVQODF2d3h5VGgvakZlOG9ZZENCK2RPZlgvN3VEUG9OTTBFM2JjSnJO?=
 =?utf-8?B?V2xqZHZpc2doQkhyR3RCL2FNemJuYm9VMDdkRk1aa3JUcFludGpHQ2FsWWRr?=
 =?utf-8?B?UUw1Tlg0cXlTSkhBVVFjdmdsZGxnOXZQb0lxNnYyalMxdnhvNDZ5eGVqQ3N0?=
 =?utf-8?B?TmNzRXREeHY4U0prVXY0MnM1WGRlVUZpTkd6TlJmanM4YStWUHVxakprTkZv?=
 =?utf-8?B?Nks3VlluZ1hnSDBZb1Z3eTlPWms5RGJIdnZJeVpmYTJWT2dkbm9FWFQwVW1r?=
 =?utf-8?B?S2d4Zko4aWFyanVGcGV3Zlp6ZGRYeVVKMWhYR1NLTXlXK3RhZnBTREo4d1cv?=
 =?utf-8?B?QmpuQTdXQlNSVVJRTlArdlpScGduYzFrMmMyNEVaQ05FKzlBaDI1WXpKZmps?=
 =?utf-8?B?T2lsM1pNY09HcWNLdTNocGlRbU1qdEtJcWJkemxqZkVEZTFaNlFzRnh0SXlV?=
 =?utf-8?B?ZjdVSEM3ZWhnVXFxSzBZdFRUU0Z1ME16czlYcW9ES1FUUVpsVGkzeXphbUJj?=
 =?utf-8?B?TjFWeG9jVkl2SEhQOEVpUzVYc2labkFXRWxZVnFGaGFOR01BeVBkRDJuR0pz?=
 =?utf-8?B?c1hZVjc3bjRDb2plbDEzbU5tZXN3dEtCSUZEK0tXMDFLR0pFNnVxK0IyQ3ls?=
 =?utf-8?B?eWpSSXlibmkxa1lzS044S0Q2ck9yL0FLWUJRdEdsMWJVczNhUFV0K0hhZ05V?=
 =?utf-8?B?REZUNm51eHZjQWFQb0J0aWh6Wm02cXltVU1xLzUrejk2RnNwcDdEUVZRZnpi?=
 =?utf-8?B?TlE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da489102-17c2-4198-3be7-08da9665a84b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:27:38.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3d+myYgYZHqAJ9AeBMeJ+f6ZxtO+3+4OkIi8QG6Xvv9uPwe6l3EiZc8Oid/Kkh6ffIT8I5owQNcie5EU15QaVaigM0hN1bkWSOZsHg33ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6377
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, David, netdev maintainers,

Could you kindly pull in this branch to net-next? If this set and a
quick Documentation patch Vladimir sent both get brought in, I can
actually submit the networking portion for v6.1.

Thanks!

----- Forwarded message from Lee Jones <lee@kernel.org> -----

Date: Fri, 9 Sep 2022 07:57:12 +0100
From: Lee Jones <lee@kernel.org>
To: Colin Foster <colin.foster@in-advantage.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Terry Bowman
	<terry.bowman@amd.com>, Vladimir Oltean <vladimir.oltean@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Dan
	Williams <dan.j.williams@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, UNGLinuxDriver@microchip.com, Steen Hegelund <Steen.Hegelund@microchip.com>, Lars
	Povlsen <lars.povlsen@microchip.com>, Linus Walleij <linus.walleij@linaro.org>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, Heiner Kallweit <hkallweit1@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Rob Herring <robh+dt@kernel.org>, katie.morris@in-advantage.com
Subject: [GIT PULL] Immutable branch between MFD, Net and Pinctrl due for the v6.0 merge window

Enjoy!

[ Well done Colin !! ]

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-net-pinctrl-v6.0

for you to fetch changes up to f3e893626abeac3cdd9ba41d3395dc6c1b7d5ad6:

  mfd: ocelot: Add support for the vsc7512 chip via spi (2022-09-09 07:54:47 +0100)

----------------------------------------------------------------
Immutable branch between MFD Net and Pinctrl due for the v6.0 merge window

----------------------------------------------------------------
Colin Foster (8):
      mfd: ocelot: Add helper to get regmap from a resource
      net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
      pinctrl: ocelot: add ability to be used in a non-mmio configuration
      pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
      pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
      resource: add define macro for register address resources
      dt-bindings: mfd: ocelot: Add bindings for VSC7512
      mfd: ocelot: Add support for the vsc7512 chip via spi

 .../devicetree/bindings/mfd/mscc,ocelot.yaml       | 160 +++++++++++
 MAINTAINERS                                        |   7 +
 drivers/mfd/Kconfig                                |  21 ++
 drivers/mfd/Makefile                               |   3 +
 drivers/mfd/ocelot-core.c                          | 161 +++++++++++
 drivers/mfd/ocelot-spi.c                           | 299 +++++++++++++++++++++
 drivers/mfd/ocelot.h                               |  49 ++++
 drivers/net/mdio/mdio-mscc-miim.c                  |  42 +--
 drivers/pinctrl/Kconfig                            |   5 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c          |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |  16 +-
 include/linux/ioport.h                             |   5 +
 include/linux/mfd/ocelot.h                         |  62 +++++
 13 files changed, 795 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
Lee Jones [李琼斯]

----- End forwarded message -----
