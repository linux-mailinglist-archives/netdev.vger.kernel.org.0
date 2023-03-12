Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B5D6B6A90
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 20:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCLTMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 15:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjCLTMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 15:12:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2111.outbound.protection.outlook.com [40.107.244.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD7932CC8;
        Sun, 12 Mar 2023 12:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8ekD5LindiVKkPvy7HN2GFMUJA2xzPu3/J1r+HY/oE/nMRDy1Y9Osk9iVsuvhhVMX9TRcdxH1XhZKEKg/WbEHQlEmiVLQ4j7YuujouSIJ/Rkuf6DAfVsEVSXSf8X+fuImckPwnysCX09UQpv+lIOHwDFtOvn02a/Jwr0p+9u6Rr3RjYfMBQbMcFhQC1EbsbgaBHQDNoVMj85Xmbk3Tse9t9Fqj8ZSOj7G4mh5TYZ/wL15AXKgd6masXeelPlXyXoeVsTfY9PYLcrzps2oDQ8g4csodkQOhCrvspvMPRfZxMnBTAWgZeOA3Kki+N+0UuG8ZPBfLoSs7UlZ2GuwbPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4gaFmXahdKmhvcrbJRJgZumv3CDLanDZr61Ufxp5nY=;
 b=Ui/Or095hsWlbKoQZwJwbgn22ZQ5+uPa3j52ZaQ2zqIWTakm/m+JevvUYT9ouj6HEsAfvsRBXLNEprn7vpnzt928mHGAPOEULBTLClfu4g4zwWRb+Ct4Pd0edlR6bLDYww/Ctho3c7jzLRBy+I6bVBCnl/M0J1IxNhw5Ak+8c4TXFHHauHJ8JD2iIVBkpKJVEish6DK7Wa+R2lYNB6RSIfUORa/zaEpTuvPNcrKZxPFiH3U0nfGZ5qA/2U0AoVcgbjKYkRSmPzEUV6JaCBU8+d3HexL7WZYxowvtZLjYD2J9WszcF1bInCG91aqsqmhaA+JC++PZqMe9WLeuzFYJtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4gaFmXahdKmhvcrbJRJgZumv3CDLanDZr61Ufxp5nY=;
 b=qzY7VDBcIydTF3qrudrww4/HiANPOn4bHfDE5cHQ2W+M4Gl10jXVuIeoWVWX35PdEBtbissTdxzx6+yNCls+T7AWcNlCAL4l0+zkp89rSWV/LdvgpaDds/8YKe6UWfKfndls0A1+F7vGcDpEkRINdsH4JljyOazm1jdp5m0/uN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5719.namprd13.prod.outlook.com (2603:10b6:303:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sun, 12 Mar
 2023 19:12:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 19:12:37 +0000
Date:   Sun, 12 Mar 2023 20:12:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v8 1/3] serdev: Add method to assert break signal over
 tty UART port
Message-ID: <ZA4kG1gG2qoEGZLK@corigine.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
 <ZAx1JOvjgOOYCNY9@corigine.com>
 <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
X-ClientProxiedBy: AS4P195CA0046.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: dae4faed-9f6e-454d-3504-08db232dbe28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbIYy3Hze0MQqf9MGcBIR/E76Jc0m7HCUXbEq7+35rUrK4PRggRFaYDbFweJhbk3/CHiI57pgNA5oxz89cMKrYhYsdvGaBcc5AAPPiOwOfT5j7e9sD4TsUhwL0JgfwKbPGw4eqO4nGLmVgDYvMMFolJfrDqBo9GV/OrGAKGNDnfK6fmg8pfO9m3Wszi/LiIo1yDOUD9PIjgFte9EOegy9l+BRO857atxOi3hWSfkR1bG7aa+QO3RwBhOzzeiCMUdfy7nOM3VI/gfdnHihrzUnL6N1N2f0NNC4iXoh9cPvDjCBnOHE+f1EoT+DgT5pBxKOz3deAdXgTkh4hDl/4PJ/JLQbU8JjABJkYxXNk+bmjD4I8ynNJIWEZCmHQFtmVX6H53qet9CavvvcXynPVVsl4Aznth2MRdFSlKXlQKPyeEOqpeppkjHA+ilDvilphxrsqYvlaXW4TeuIpTaJ9lsp0GYpToH2N04qjdsZfVOr2Vyz74QbiwCyXMJLiDYsDy6a750mWHdnECE4hqJm9hVgKQKkS8R2E3CcDZYBHgP1+utwuo2poP79Vo2fZydVSln26mzJKPaAVvHA+1XHTveGarCu6Kn6OLPkqyrdJwARdTzqL2a3S/J1731D8/yJPdRFDn2AMIc6wLDRSPLAAFQ2suHEujajjTMOEkjDidurW7KEFGC1NVBcVfSOUZ+PK4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199018)(6486002)(966005)(2906002)(83380400001)(6666004)(36756003)(44832011)(6512007)(6506007)(5660300002)(8936002)(186003)(86362001)(41300700001)(2616005)(6916009)(8676002)(4326008)(7416002)(66476007)(66556008)(66946007)(478600001)(38100700002)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wd/nhwDOENbx9Avb/zOT/Zc9OpcQzaaZHOzgjdir6zAlrWm5x8IvsXyruZIj?=
 =?us-ascii?Q?I2e1/S5OqagPHY7EabLmP3TTSElSluAvu0tEkCPXnP2vCysEQOmE3dt+KrkC?=
 =?us-ascii?Q?3mweETVAUfi3vvF8lNq8Fcgrhh6iAzrZEWS9Xf+EHcyd/IeaC2RvGaNm/yi3?=
 =?us-ascii?Q?lVLbycfBwVt64KuvavMnfmqpx0ImIwIFc5c7IUrD0KfLavdw2mkPDp+DSLJ6?=
 =?us-ascii?Q?su5ozRZzHUtLHGE5VQXUh28Y0q+89SYgxtjnrjQqAou3w6WMjFWeJQAjw0Pc?=
 =?us-ascii?Q?Xr5PjBlq/8ukZp4LsgZOKSpb5URHZAfLm6ktEYy2hUm55JjqBjq2KuINP8jq?=
 =?us-ascii?Q?kDcjI+JNmoSmzMQqgU88tpZuDJyRZIpoEdQrKW+adUpS4agFCFYqZ9UstHkd?=
 =?us-ascii?Q?yvE51p7NsaZio5FlKZmIROAqhB8a0T4NLNDqSCwh61WJsdBw/CzpWYTorQKM?=
 =?us-ascii?Q?YDtg0YU4B/+6Yus36d0bXG5Pw4q/UK9XIBgw/A4GTB1m5TQPTPf72DV09rvh?=
 =?us-ascii?Q?bA1pN6/PPZjwynZH3JfNdMbOmP+e6HlC/KNZOhc8HaFgXF+TIr6e4ax+hF26?=
 =?us-ascii?Q?duydL86CQBWiaD8zamhV+DPscUSwANGw5B/5uiaaGttms2TymTQNP1dxc8Wt?=
 =?us-ascii?Q?WI1WiAS0Kn/Edgb+Ujjcf98JvMOXshSolb/TlRvX2P6VySfpulHYLnHekSzA?=
 =?us-ascii?Q?e+bCwm7IzeimApLD0BnsWXlJ5iu6Q7VIYQX1Ds6MP1jX6yGkpL9OzqaTF+Nq?=
 =?us-ascii?Q?Y7/lxI2N2O084ItBGPW2wi5ELHTUyslcCYKcsuj9LHYVn7KeLYLloV57f6XA?=
 =?us-ascii?Q?Ij1apuc36Y0meqfMdQyfCYLASxfCUKUvPT/zjQDDTN19SeABo3w7DoHGbykD?=
 =?us-ascii?Q?qOAr4oD1PLhmBtInw8/hdfS1GhEqiWTtnz8V0jlz9XaPh35zHh0eMD0TgRPI?=
 =?us-ascii?Q?ClQkrfMW30Z+U5LIPUJm862HmWiMqSCA40uu1vLPzuzvSPlA93tRq8fkbRvd?=
 =?us-ascii?Q?ot5ZE9ka4JmsBzMuyHt4g0JxMj8Ywl3IL7lTJ5aljUwSqpmL44E3mfkjHgtj?=
 =?us-ascii?Q?fA2Cru6V6f03oL/NLSuR9wCtwFJpIUPj8gp5rObP978qScOEQHuBzcST38QM?=
 =?us-ascii?Q?HkyGvOlxldZUgayn/XxO74VXTiitCPEtLi439bVk/yN3XVei55Yl//4E1k3e?=
 =?us-ascii?Q?XXU2LINvuoUWJONhYQsrvv+vI/07cASWaK1NobEkk8reiphtk5sWFu7cye5H?=
 =?us-ascii?Q?8iA1IXSxi4GdWbZ8+YJwyJPVfvPLZ6vwfgSQh2h9aGTz/GrHpAkpe+hUOSjL?=
 =?us-ascii?Q?k0eBxzKofK583W8XTjEBW98xL+eXnfkQWbKF7IgjZGUtebIm0ePniL9PVrqA?=
 =?us-ascii?Q?iGbzuvEdMXkS80hwzCpxNpdzz/Cwjnxl1sb72L59saJLcRpetYONEnkAS9fX?=
 =?us-ascii?Q?gyZ1BTSqZPvXNbQETXBmgIM2811PseRhfTwhf1Z22pbJN48itMbsTyL8jKcR?=
 =?us-ascii?Q?p+EuRDioFi1CpNeDlf0XMwc00GVEGhkhjXf9o5RGo42iciUJ27b8fmW/5mKX?=
 =?us-ascii?Q?2S/cTx/h97Ea0sbw3kvD66blbA/ljiTzWzwArXqThqeWv13z3p9grnYCxI/Z?=
 =?us-ascii?Q?fe/jUmgShcFqBC/Gv38fz7BmB74gEOBHI5F53Y0ZTinT7a1skJ+apFmVMxP2?=
 =?us-ascii?Q?WPqAfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae4faed-9f6e-454d-3504-08db232dbe28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 19:12:37.6831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxbe8AFEHRowhE8kLHC4iRoiXfOT3dQwGEVfq91oR/OzOISMkvSH+8XHJVDWdP5si3FEMx2vD4D0uT2S4NAYtm63jrvEOG7mDGxpIjRbl9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 07:01:17AM +0000, Neeraj sanjay kale wrote:
> Hi Simon
> 
> > 
> > On Fri, Mar 10, 2023 at 11:49:19PM +0530, Neeraj Sanjay Kale wrote:
> > > Adds serdev_device_break_ctl() and an implementation for ttyport.
> > > This function simply calls the break_ctl in tty layer, which can
> > > assert a break signal over UART-TX line, if the tty and the underlying
> > > platform and UART peripheral supports this operation.
> > >
> > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > ---
> > > v3: Add details to the commit message. (Greg KH)
> > 
> > ...
> > 
> > > diff --git a/include/linux/serdev.h b/include/linux/serdev.h index
> > > 66f624fc618c..c065ef1c82f1 100644
> > > --- a/include/linux/serdev.h
> > > +++ b/include/linux/serdev.h
> > 
> > ...
> > 
> > > @@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct
> > > serdev_device *serdev, int set,  {
> > >       return -ENOTSUPP;
> > >  }
> > > +static inline int serdev_device_break_ctl(struct serdev_device
> > > +*serdev, int break_state) {
> > > +     return -EOPNOTSUPP;
> > 
> > Is the use of -EOPNOTSUPP intentional here?
> > I see -ENOTSUPP is used elsewhere in this file.
> I was suggested to use - EOPNOTSUPP instead of - ENOTSUPP by the check patch scripts and by Leon Romanovsky.
> https://patchwork.kernel.org/project/bluetooth/patch/20230130180504.2029440-2-neeraj.sanjaykale@nxp.com/
> 
> ENOTSUPP is not a standard error code and should be avoided in new patches.
> See: https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/

Thanks.

I agree that EOPNOTSUPP is preferable.
But my question is if we chose to use it in this case,
even if it is inconsistent with similar code in the same file/API.
If so, then I have no objections.
