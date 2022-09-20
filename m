Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26AB5BDA84
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiITC6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiITC61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:58:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2090.outbound.protection.outlook.com [40.107.101.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9023358530;
        Mon, 19 Sep 2022 19:58:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WItrrpK/XKgsZuQ3OiIaR+lVuoX76XelGI5CsJTAcY/tpJTzW+KZOVc+V7rBYtzhnNa3gcY1PteCu0jqXH6KNnDnbd5rg4NnuGTr842Za4Axq5Tiwq7xE+gg23+Xi/9L4bh5y1cNRBO8SwxV/2QPSk+bgB5/LBxzsMs/Mtx6F1fgBlT2TFZHKfgWoYRmmZcg4XMcyGv5x67j9Ei9Lzw05Bh4uXQfPMsH9NnW00kyD8GjzWi4XpJVhP9zuNyO1k/Djbnvx2e782/981yR+vwGw2/4XbtDvTdRerp7aJf1VhBAlNypNUW4RvES8A3SCk2gkJ2EuHBJ219S6roselHs1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3MwJC3Mk7JJ6X4NnpZbP1Bd4XOEuvQfS2zDsydtxlU=;
 b=GFzhzgecszdRB5SSdYXZ6wUhbl4G+IdwTXSm0C8MBxKLnxQTyOTpdZLxtwHCynogmjfQWJATsl9vf5pCU1zVm5HYwX7Tsz9cqUIWpoetaehpHqwwI+g8bkhOWnr1naRINLXmJD8Dlm32d4cTPP5nvjgUY2iAKAjFDUuWAM1Q22VJ1XQ+gy4I/uPGrXhv6K/nUx+U4iuQJynTiT3LGrSbe2vCO13kKYHJwM1tKIbXv1hc3PqYwZ0P9HkjRfcG7J68tLsEK6GJqElyp+I14x7+KMmx0VoTwD7VopJBZCeL8exdYD7iAKlzfGC1g3Yw7dxgs/3Sd9PIqgTYDXD/VCJnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3MwJC3Mk7JJ6X4NnpZbP1Bd4XOEuvQfS2zDsydtxlU=;
 b=pMVVUKyfVD4s5TkxUy2/jUou5aMaCNDYZPaX0H5yj0PYPFsOmO9x1XA8eqYmNX3ZxctlCPHyiesnG8n+naBHaAHC/x5WpkSZiNdIkRZnzTle5v7yvX6V5o+5RYWICtWwIByQ9uGkn5PWK1zErXPAtun41m45IlQ2fYjzumW6O0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5104.namprd10.prod.outlook.com
 (2603:10b6:5:3a1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 02:58:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 02:58:14 +0000
Date:   Mon, 19 Sep 2022 19:58:09 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <YyksQQrXb0xDuksE@euler>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220912172109.ezilo6su5w6dihrk@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912172109.ezilo6su5w6dihrk@skbuf>
X-ClientProxiedBy: BYAPR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::41) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 85d19c14-97ec-4a4b-c246-08da9ab3f588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSk/kCRNL7gmLI8AlYRI2YbGh4gMvIwxt52KMsR62PAfLhzVM5M+3cKXlMsZb3G8jqZ1W/yvLlKe0wHQjdOa6Fzto9uJm+WCQT9vRK7sDkUds0RWPakjPsbynYmEHNuHg14psMlWqbMtAmo3bsQAXGSKTzHw9n3Pj6IJyhDD51lhENsPnStjGUxLM1Om425nnl3Zkme5FckxghCkPeIuMJqxdRILRqdd6+xPgcpTXk4gXRBGtcceoIpak0JDkZwKsejk/7LYP5GzOYz+9V4ZshdaGem6dilCDpZYQuG6G53nKay8OCiLE8uu9B6vf9VnjF7te3RICds5eBrc0JwLJCxCGi7JR9ic4OAcdpIV9w6qRcoIFjWctuwJnN3T0BQ6CR1rODwFUJuDJcLdgslVcOOh989Plz1TVucnfZtiQyqr1ZsTcVOVrjrllg5xL9p4oCBwKyjTcakyiTpzKWaC6jMk5i80EAaPs/r/x9/132zfVXOc9iwlfku9MB+n8Pom0QQHHJIWr/TB7vbkxOEDHZ42IRJqUg51RYKloQU8izze814lXY6T1uIstEDkcGhwxFMeAe5LGJH3nZYI2l/ZKyD/iiMR3Qsf3BpQXPntKFMsGiGV3qSoncj1vVG1/p+LxCxEBTwJiU4bf5thQrMx9K8HJ8P+B8z0Cvwp6ggwSNb+b2erliSpR/Tqq2AEMxx+5+0FzvQ0KrtMOrD18KDJVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(136003)(366004)(39840400004)(376002)(451199015)(5660300002)(8936002)(44832011)(38100700002)(86362001)(6512007)(26005)(54906003)(6916009)(316002)(6486002)(6506007)(2906002)(186003)(33716001)(9686003)(66476007)(66556008)(66946007)(7416002)(478600001)(4326008)(8676002)(41300700001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?If6PJODuv5+W3UdFgsNKu5g4RhldMW802D9+oA8RqxKKMxWxaOkhecIQi+DH?=
 =?us-ascii?Q?0WerVdNYWgkPYHO6q7gv3Z6cbHjD4mSD/qtKJ5EcrdANemXLzClu/Hu+zQow?=
 =?us-ascii?Q?rnHqS59FC/eHbqBE0bM7D2lbSTFi9n95R+znb9/nTiJDNphob73X8avQ6+bY?=
 =?us-ascii?Q?1zAZTHquvivxn+1nsWyOxoKV3Ur7f6T438idB8rlSXJDqoPQIJpBSL2GoHhg?=
 =?us-ascii?Q?SRP/BuszNSnkMLOWGUtr76RkYnIuOYGwyQ85gMhjvjbzldsgewulQqLyaT73?=
 =?us-ascii?Q?rQX/DLpGYUXq20cFNNzHRR0twnBPU/laokv7rFdlZiccieygiNJmHj7sbcyF?=
 =?us-ascii?Q?F05EBV73qyiMZeCCr8/vIBFj4uMA4eMV3PYbvOlhyBLELB5Fq43//9KCY3Dk?=
 =?us-ascii?Q?S1K6glnpohzLTV9zLS9wDG9vWr5fFtSHi9YkMfGXWfctb/W/4mByg8t7T9pb?=
 =?us-ascii?Q?WdwZodxUqHRup2/VS3aRbUzCH5xOI1re+UPCEijaL/O6vQDcgzu8k7QUjWop?=
 =?us-ascii?Q?8xIvBA48b2chKunBhU6/eXvfo6YJOgBAQhV5H6r0OayRJxGtw53SmR+vf8ss?=
 =?us-ascii?Q?AqnoDUtXgSGblw6vEFbgtgdCfBK6shFK35N9PjM4mCpm8eZUK87hUMoea9so?=
 =?us-ascii?Q?ZQ4tR5Jmn7eND0rEgXn/AWKBoOnqbKKY8GfUwEsrhydPgV3UoS8eyz8rfXEC?=
 =?us-ascii?Q?QnxT2xiLvZHsej+oBnSOyrN/8cmdsvOCUUUknrPDQw0lkjvpX8aUPKsynlqR?=
 =?us-ascii?Q?OXwBZmYjdtKbdmZAkCDzK6zf6oftNmaxqordZRa745bJneThmXMSOQEsuP5o?=
 =?us-ascii?Q?jR9E64FL+/Fgw2jlA5jAJNOssnhMuL26AyMGxi8SfFZndzFgQwqcwArRw3tA?=
 =?us-ascii?Q?mAZU6V6rIgjkIJjU//742JabUlKsGWVJUTjAcfeuDWBuVIXzmyGtMVOJH4RE?=
 =?us-ascii?Q?JWVV563SmnmJMVj9ZX+ZrvRVFKaJqYyIi/XQBahVdBh4/NC3k87F04NMQ20j?=
 =?us-ascii?Q?5mICw8/gJdioRsO7aOCnsjiD4NRd6RYZNo9InGQkwvLgfdU9iL20eHlVChWT?=
 =?us-ascii?Q?W1NP6x1TBG3N5kPJpOPjf3yaAT7RRZ5GPoOk+1ATvxwJzFj8w9Yz31s9XKiH?=
 =?us-ascii?Q?odFfKRvsQheCq3TxByvY26QYmO5KsaZuKBnjVdr9kvsKxiBIL8GFMfg2XMcc?=
 =?us-ascii?Q?IB68QqmeddaIUg8lKcx535cz7Ttw+ve0reqkHd5W59CLQtlA2D2qkTabSOi0?=
 =?us-ascii?Q?k15qXSMcCzgWiPF4nnDM32C6nwy67V0FcJbLUK1JrWuEQI/B/JfoK8M+BHQZ?=
 =?us-ascii?Q?V/b43N6jN9/ANKZ58QAfg/Q6zEBy/Vpzfz8ZMnhad+u/bLMibNZNCEixcwEl?=
 =?us-ascii?Q?hIA3hHm1EeY+WHjIDjaTJJLvNn8CZikk+ALYVf5tXbdChfEJZIuoUhuv0/hY?=
 =?us-ascii?Q?JnmZ7swhez3fM7K02xelgQOEiO73j3poa8bOzhknZ5VxGFdrGWYEzgcNpPCA?=
 =?us-ascii?Q?ccPxc/hljP3aIROUf7xMMLwtcZFMJ7iRPHljhjGTZS6RgPTTJnSRbnvfGs6K?=
 =?us-ascii?Q?ZCHqZGHFooI+Dw9gWGwkRSto7Me5dPwuh7bRmPpsoqEuQ7MFRInPHSutxv5+?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d19c14-97ec-4a4b-c246-08da9ab3f588
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 02:58:13.9144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: La653umvMtGovyiionsntINNvzAvflUuzqXrCtt/gHfZDkevG2Gl7GURtOs+M5OBa7QSgbtfktJDEoiEi7kjzexeiJ/J85do6Ac//CqgG1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5104
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 05:21:10PM +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 01:02:44PM -0700, Colin Foster wrote:
> > +#include <linux/iopoll.h>
> > +#include <linux/mfd/ocelot.h>
> > +#include <linux/phylink.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <soc/mscc/ocelot_ana.h>
> > +#include <soc/mscc/ocelot_dev.h>
> > +#include <soc/mscc/ocelot_qsys.h>
> > +#include <soc/mscc/ocelot_vcap.h>
> > +#include <soc/mscc/ocelot_ptp.h>
> > +#include <soc/mscc/ocelot_sys.h>
> > +#include <soc/mscc/ocelot.h>
> > +#include <soc/mscc/vsc7514_regs.h>
> > +#include "felix.h"
> > +
> > +#define VSC7512_NUM_PORTS		11
> > +
> > +#define OCELOT_EXT_MEM_INIT_SLEEP_US	1000
> > +#define OCELOT_EXT_MEM_INIT_TIMEOUT_US	100000
> > +
> > +#define OCELOT_EXT_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
> > +					 OCELOT_PORT_MODE_QSGMII)
> 
> There are places where OCELOT_EXT doesn't make too much sense, like here.
> The capabilities of the SERDES ports do not change depending on whether
> the switch is controlled externally or not. Same for the memory init
> delays. Maybe OCELOT_MEM_INIT_*, OCELOT_PORT_MODE_SERDES etc?
> 
> There are more places as well below in function names, I'll let you be
> the judge if whether ocelot is controlled externally is relevant to what
> they do in any way.
> 
> > +static int ocelot_ext_reset(struct ocelot *ocelot)
> > +{
> > +	int err, val;
> > +
> > +	ocelot_ext_reset_phys(ocelot);
> > +
> > +	/* Initialize chip memories */
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
> > +	 * 100us) before enabling the switch core
> > +	 */
> > +	err = readx_poll_timeout(ocelot_ext_mem_init_status, ocelot, val, !val,
> > +				 OCELOT_EXT_MEM_INIT_SLEEP_US,
> > +				 OCELOT_EXT_MEM_INIT_TIMEOUT_US);
> > +
> 
> I think you can eliminate the newline between the err assignment and
> checking for it.

In my upcoming v2 set, "ocelot_ext_reset" is moved to the shared
"ocelot_reset" routine. As such, iopoll.h isn't needed. And all
soc/mscc/ocelot_*.h includes aren't necessary either, since there are
literally zero register writes in ocelot_ext.c now.

I'll wait a couple days for everyone to go through their backlog. If
my "clean up ocelot_reset()" and your Documentation yaml patches get
approved, I'll be ready to send this out.
