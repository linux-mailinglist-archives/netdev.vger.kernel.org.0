Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9336878D5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBBJ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjBBJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:29:35 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D22E751A1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:29:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNrseJrKqWXA0kjxMaWpLSirOFHRdUcvNdmbYcj7ucPG5OxP6x4FCIZhGx2BpDx2QpA3lMz3pKukr8nziPk4GYl+2aonXDsZqCH/JZLFi+STObgG4MYdI7AmyofmsLLWkOUklAfwrq92TMVfqtkp5QQxgghexbJKkTNa/CxItTZ0OsUChzYVOKMVx3SPP1xDN7rkUa8ccLezzpqh9lVLvvi7MaCTkd+ydJ9ciObzbYQtjxoRP6T3hPGSn0uUhR1Ick9HYl0q6lx1NU0lK5Hvt1cdEIwy3BBaINc7XRjjnlIM9jt9cPZ6FkY767v1+RKxO5a5mSHQJi0n2u4V0Z8e2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75afrxMGTTkex5FpOypZJ6I8UPIkZvYHN2AZz2e/7qI=;
 b=AQVby34RDOdW0c3Z7gzh2fo7GHztBvkEid0ku+VK8FFgt2bnkPK2c7CGwvXPtCKMVi6LszeLbpHiB5YynOBgodiwIDUXylrZUzkEd+gga7tZkXtza2QI515dgWaB4mYObYVXXW+Dtv1tcXDNkMFut8qwe0ZHN6BpwfIMCN4QBfKV/sPpD8/FkSEc3pa8kabhxeEBdy/3Qzf6TtmShggoWNuaN7kEPiVB5ACoQZJl6lM0vrFwLD64JmULBJGmKyFQGf0vWb9vNwm9BPMSV4niPhe8zzn8fPJ7ct0/8wLx2tEF8dNTjujeTZrm//tKHn6sCXaZ3mHjFWJbHHLx2oMSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75afrxMGTTkex5FpOypZJ6I8UPIkZvYHN2AZz2e/7qI=;
 b=JsufH5IezcM5kNX2Xd0PGQiqR9+sDllSocWwup07rW1uxXpwZiI/SEqLWPOdtJf7fHlm68bgtJ2dLZ5J+6yFVItWRi16kay4g9j7hDSeUGuG8MvYLARG++RzyC3N5yB/zst/R0DplzWMiE6NyCEp0xVrxz2XCnVthnHjlvtLPNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5993.namprd13.prod.outlook.com (2603:10b6:303:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Thu, 2 Feb
 2023 09:29:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 09:29:13 +0000
Date:   Thu, 2 Feb 2023 10:29:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 04/15] net: enetc: ensure we always have a
 minimum number of TXQs for stack
Message-ID: <Y9uCYlPUq96DIhbs@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-5-vladimir.oltean@nxp.com>
 <Y9pskMNnHKFAROIl@corigine.com>
 <20230201184652.fvlb6kgwcnfwknxh@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201184652.fvlb6kgwcnfwknxh@skbuf>
X-ClientProxiedBy: AM0PR10CA0094.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ad3628-fc61-4303-622c-08db04fff251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: blc1/M5hVPmfx+zKJzxKGg6U9NwEni5LEvcs8law9UJ+9Mpl10Fi/CkeGcjJmH+UhAPoMh2KSSmdSxLcT3RH5yDMLHyc29DdOb5RwOrI1Dyis58vj4Uw0Vq2Rf1r2zwuOH+1+0NyZBnRx6XajQvWfUagdbzXSOWvzyrzgBxUuuTKI0BTHAa9JxPGUXY6O0Urf5peZ6WlR4QiN3jeaRP5ph5+lhTIYEeigUMA0RvtzKV9dXWyT0qzAnF1K0sN0aCM5aaUJb+Yr7d8oAXpU/JFOumyjiJID3WnhYTCGooFnJU8S2uxzf95qFyCELzu9YOdM3gp9hTP9KoUe9A+A22FWOHW13xGI0efW7kH5Tpw0rRvySV037QuQlzBMzEBBcmfUBnf+HDUa9A4DTH+DyrT52Fn22Z983VdSFlxiAeslULdJkZMfTp04Pe+fVjBCDYaJm/5ICEWx0kRCilmn4e3tvdBJKCeD7/bTjvCWKcXAhqgAVsB92WaM1bQcD2QnUPxg+vXp7pIoWCu8NGRpF//oak866Y3tTlnXvsq7yd4324IxX9nNfiRtPjiEXneCIHtwznZMwrC/JsWTfinDmhRgzJF+MLHXV+MZik69QVk+GGU5fmeDVudkiIqVdfChzbRgckCwEujuhveeZo5drCWbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(136003)(346002)(366004)(396003)(451199018)(44832011)(6506007)(83380400001)(6486002)(38100700002)(86362001)(2906002)(36756003)(6512007)(186003)(7416002)(478600001)(2616005)(66476007)(8676002)(66556008)(8936002)(66946007)(6916009)(4326008)(41300700001)(54906003)(5660300002)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JGCxdFWhhVDELNLG+p2cjxayOtywkLqd2z4ZcxHbPPFwHgWZjZ4NjF8VxoVu?=
 =?us-ascii?Q?vciTfJkT1a+t9U27dL8wIEAVaZytFwJdwb1MeIKyDXplvAQi7zbYUcmQ7JcX?=
 =?us-ascii?Q?/Gy4P6Ot3w6q3xONTnrvCi/9QO+687QuJsenhdqOFEyuOr6EVXbxX/bccFAe?=
 =?us-ascii?Q?3TxCIbnEDLmZxXScqOqRoZhFD+uYnENA3oiQxmOzQCj9xpp2WTFkygqxJe9+?=
 =?us-ascii?Q?G0rizD8o60SMCa4DwKY3oUghHVXvI8xxFFJQzGPSL4I9q0B0kZPHFSKDkV7y?=
 =?us-ascii?Q?WfA1YmnlCElaMxy0FNXIxP6A55gkH2WzmS/1RcEyj7zcFf0ZV70FuuVF4aJA?=
 =?us-ascii?Q?AJg4eMn8r+Y4COIczxWt6OJHQ8jFDQWYRbhza3hkQfzybCx6p5sY9spx0enz?=
 =?us-ascii?Q?Qcf1K/+IRcddn45LzqhGAr3zzvsPo0ww1FNWnDtg7V2Lpxc2xgaDAmuresSN?=
 =?us-ascii?Q?1XMp7EtNPBiCWIcOsOXDxxoKMSHYh59miPtk/rp1+Y7+idDc8b2chRE+eT50?=
 =?us-ascii?Q?diCzrpQ6MgBJXIJnqlbHJnW8XcuZVmJuAbRn6cMa8tFMJt25Gs5lyyGpTjl+?=
 =?us-ascii?Q?2JWSWhfPMsOIwdll3u2iSkdKtO+hK8dzqriOPybizPPJ4xZHdCO75HUGXm0g?=
 =?us-ascii?Q?/dvqgWtMqSVpQoVTbqz6GYMf8f6tL6BoAp4KBjeor2Wp2DAZ/IN2DaHwXDE6?=
 =?us-ascii?Q?khiGbuO2vLme76P88un/Flm/ZCpbAKPueuog6QbUAULTiuch4fVrrYB25RxA?=
 =?us-ascii?Q?k0BGdMYPH8DF5dFSk/9O8zmfBGh7MOXxXfprbvcr1hBIgjT50UVpAo8jUQhk?=
 =?us-ascii?Q?BoBZxxMj4Ts3jH+/YYl7ONGPJCLyUZE725KLDRt6VAHWsxbU1iOs6Oa2VaC+?=
 =?us-ascii?Q?BDAAl7KThMP6VM9jsX8W8bWlTA/A+8NBHKhc0P671bY+kTwydvhXWWdejSyt?=
 =?us-ascii?Q?SNzh0mKhUa0C5L/pTPSdABF+bGqXbBLf1AkT0UyDvzKCxxvSnNTSd/JI5k9Q?=
 =?us-ascii?Q?ZQ56aPz455+AMr4HiacbQYOl6/VAPETuNBYpX4FulAVdjkkDYilEr7W7R1Cf?=
 =?us-ascii?Q?nUfDRPgwF5zoiguqpypdMbqaYiLw55Ye6AYT+80AWf9nvvddtFcQMeB444eo?=
 =?us-ascii?Q?ouMMRUgIybgLKSs77I0AsdDzBFUImhn3SeKcEYxAiiIqR/i7YjmgqCAuWfel?=
 =?us-ascii?Q?iRzwrr+3mRuE8vUJz1/VZFauMIRAnYsijUvJ0Fl2aHHt4MZnaZ4f+VBdvXKf?=
 =?us-ascii?Q?3FhWrU8GEeA5EZ9F2de5MNIXod5xesROr84k1+Jw2NnUTEOmGrk/1ruWkyCf?=
 =?us-ascii?Q?t2yLwQjiJmJWj1qoONQnCYJG0NBA2Hw5OwcNi4flim9ElXA2cb6xs7FeRDkV?=
 =?us-ascii?Q?qDyr5cmtCb6kAvgBlvBjXNpLDTHEDgYfRntcvtIaR1rVtlXCaB+fE97vCXYc?=
 =?us-ascii?Q?jQvxDsLGV32OAKORHcaC7QLFh1Djog4RIVUDPxOmYmg2AqKNGeY1DIrJJbvu?=
 =?us-ascii?Q?skAPqxOQ6/n71+SEKICRkk1nshqCX1PpVK3wCy6HW4c4HnBV8bxwdRyYzc//?=
 =?us-ascii?Q?6AXOCHcQwA54UbrDKNfgJNWgixHOuGQHOb5jWBZPRfGg/YcthhAKBmv86Agg?=
 =?us-ascii?Q?U6VEyk1wfKxt6nvZ88hjBSe21mwV5Fb55Gwg8WOhi8sdIGDCqMPVQsiKk/nn?=
 =?us-ascii?Q?zRohMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ad3628-fc61-4303-622c-08db04fff251
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 09:29:13.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4ol8f/mhVS/NyDKhWa9GU9Ifpdy2+dzI9kadeGFx6NNUOSDH1kxLVahhXrRG6mF9kS0FV/4qlOwAfvPAxAQvUgsMQ1RDQZF9Mx0usjsou4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 08:46:52PM +0200, Vladimir Oltean wrote:
> Hi Simon,
> 
> On Wed, Feb 01, 2023 at 02:43:44PM +0100, Simon Horman wrote:
> > The nit below notwithstanding,
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I appreciate your time to review this patch set.
> 
> > > diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> > > index 1fe8dfd6b6d4..e21d096c5a90 100644
> > > --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> > > +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> > > @@ -369,6 +369,9 @@ struct enetc_ndev_priv {
> > >  
> > >  	struct psfp_cap psfp_cap;
> > >  
> > > +	/* Minimum number of TX queues required by the network stack */
> > > +	unsigned int min_num_stack_tx_queues;
> > > +
> > 
> > It is probably not important.
> > But I do notice there are several holes in struct enetc_ndev_priv
> > that would fit this field.
> 
> This is true. However, this patch was written taking pahole into
> consideration, and one new field can only fill a single hole :)

Yes, indeed. Silly me.
