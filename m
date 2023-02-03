Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A506891CB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBCIR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjBCIRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:17:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BAF30FF;
        Fri,  3 Feb 2023 00:17:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAG4zvHqLHiCLRITKN9yA+o2rimG11NcU6GjSLSBXqgCWG0WMu34uLM978I3GJNLyS20lBhh7D3dNob8ziVQ72awNSzaGH/XCWj7dJQ99c+oQcykzzI8pe3GuvEa9XBW2ss3gTlffX0IN6o+Hc0rJnPOxa6Dgu5HhIMP8S1LoCbRe0qkExv0TILtdIkBW1g7Tonqf5bLsymtpBbI3LzEqjCQv2Oz+mcJeWUp+tj3KPADLcBWDa8blUGoiyUO7jNc7a561ZO18j217alLerW9lRLaoAVwi3yAGoVlwQ6y2a2t7JdpofjvkBqDDfT7bcqu47L6ZcHKO8aM4ab2mnxCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqGXl5Wv3G9fLahc+geuWHLtMDU+xGZqI0CTVLVftUI=;
 b=KfcaBpB75cgaDDXrKOZbd8B+EHHqdaY4k+bLV62haiL9WnCbKJegxH+VUaSyxhE0tq6TuUacpbo+K3JndeGfMLDXLi6FmUToHe5vtt4pptn2Ahe/F4NCrQ/uZ4Q1ELS7oiJ6yX8nU9Lj8NIl8DYpnNAxvTADmWMRxDtkgianS6qY2T+0N7TK35P8EQdt16M1i1xr/nZGUKYfUXkLtXZSrVgMlKHolZwgK8pSax1a9gdvMs/UZxPyd9Qb1i7o7077o0wiS8We86/pjbgWWQNJ/naNu3qtCKRMgbbW/kpAfAL6pxdLh+Hcqc3PDDXM7npY4S7A1oT5DZNu9TCFhUQx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqGXl5Wv3G9fLahc+geuWHLtMDU+xGZqI0CTVLVftUI=;
 b=mJeB1OpnUjI7OWkrAwmikHMCogbxeVpoXsY8gRWSYvbvgjxD+0hWRn1do61XeJxw68FbV7JpRNB1Q34iXwisczewQ0ZnQ/bfU7j3zqOGOsJbsE6oRFXeOfHRW7kENz5T0ovFYDLzNJ8MuuHHjQJpK40EVBzRL9AThmoLe2Qzfp0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4654.namprd13.prod.outlook.com (2603:10b6:5:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Fri, 3 Feb
 2023 08:17:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 08:17:21 +0000
Date:   Fri, 3 Feb 2023 09:17:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 3/5] drivers: net: dsa: add fdb entry flags
 incoming to switchcore drivers
Message-ID: <Y9zDApc6nDO2RzOb@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-4-netdev@kapio-technology.com>
 <Y9lj7RJgyMJfjtGp@corigine.com>
 <0b021777dfc1825b6565c0d9dbd6dbef@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b021777dfc1825b6565c0d9dbd6dbef@kapio-technology.com>
X-ClientProxiedBy: AM3PR07CA0138.eurprd07.prod.outlook.com
 (2603:10a6:207:8::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: ca453dc9-6b20-448b-cfb4-08db05bf12a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vs7c+kQ9oaiekn4X2Rjbic2Q0BA2JviQYKXtcbxDGGU2ieCHKPBV7k2ZJihL2DCKgLi85PDkAP1NCuFmUtHfPfitxFO8OETnZwS8H9sXs6kTyWuHNvjy5W1I/lgM2no+9KeFnqizVPgOhWSST6ZG4IA9rpbjAAEBQoHISYiO+hxqF9HA3D7t9iDM6+g0G7gA0BzXxF9f20RN6hoOLA98CI0JNEoM+kiRo+XxMTayU5+9bKII17KeQM/I8+UT5oTM3AUpqFyJ73Di+xJ9J7hrzdhpD7dQnXs0UWZcDMYw1/lRdT+w/JCKsCb14a46l4dKdPaqt0iOjNeb6rHGDcecZBTRrTFDDtmBV203W2YaCyw+qWI3SaDT3vLErag7gutG2S+7De0h+gXEbu6Gj7i7U/VHP6WaKTJnTjX0ohaHiNjjKHWr6ZvUpHne5T+6XxmOvdTDHAOASK6D1Fzm9CUqRH6JPczwt7hzmqgR92lxp5YSKRWBOLBjeI0pLgRB2YZA0NvTRKXAsHuJu86OrP1nDwxTAN1UMkCa9yfcxitKuRHt/3BG3IXT2nyZ0wFiswgI/lLeQ75uFNs+ptoNfGfOrrmWyY2d7W/8JP4ry5G6lQ/o/tAd7dz2z6L3mEUeY4B4JsPvR3R6ImJTo9GRnAvmYxSP6m0vfjMmn0UnFClk1zVBB+QOKMfh34sgEX1tLGep
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(376002)(366004)(346002)(136003)(451199018)(6666004)(53546011)(6506007)(38100700002)(86362001)(5660300002)(6512007)(36756003)(2616005)(41300700001)(44832011)(7406005)(186003)(6486002)(7416002)(2906002)(316002)(8936002)(66946007)(4326008)(54906003)(66556008)(66476007)(478600001)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+N4SqAH3LoXLXhdV4Dq6/lXyOfaqsFinmCQeC7JuTZ8qnvniAorA5z6+Kk/C?=
 =?us-ascii?Q?YG6rmVcOQTq62hX40WrdLRbkuelGT6e2VuTFupGmN+npGtVVInlr1/OHKncU?=
 =?us-ascii?Q?6Yfru3IiCONJLU7/NuVAfOZEOKpHgB6wm6ei1uvPVDw0Zc6vFwKRzC3O48ev?=
 =?us-ascii?Q?qzh63xHxihqkDleGM5OQzRs+UMzEPEoY7+pjMAX0WM44nlSnl7EjYPnQntN3?=
 =?us-ascii?Q?NesFvra4RE7H8UI/acREWikkbsnzdPmLzq6mhqBbRFY7AJnv99Lpdh3NrUlX?=
 =?us-ascii?Q?1MS3atSRuESrwBUQEbh/v4YY11ZNo0CCfTfQ7XgcmJjqRyFANEVqKdvAELJO?=
 =?us-ascii?Q?b4hoZkT1pniTKoQjbkshmxhPnO6/6BAi8XFI4xbwENzrr2iSpUBEO5jcPmqx?=
 =?us-ascii?Q?Sc/pAQMoDFTk/qAh+4yVEBu2Q6zcnVrfQQsymSEcSxG0rxxt5OW75Gh1gl2Y?=
 =?us-ascii?Q?6xAs7HiCTFyNnp2rPjSkMAsSqLEbljlMj+DpBzGJnacKNZSr9JV4VMqySJ9E?=
 =?us-ascii?Q?7LlxxgZX3Esr4qtEGn1E69iw05lByrO0u7R/EmZQ4GfF5UjWyOUuUVefCd42?=
 =?us-ascii?Q?iRzyR3xc8QuLwPau7L0RdsyFkohn6IUWmv4tAviefoSeu93/RJcReJpBwpDt?=
 =?us-ascii?Q?iDhgugHwiUpStJ7XB/0N7F0RZmnjheyRI2GQYTIFDOeNxV3GfS3C2HU9O/k0?=
 =?us-ascii?Q?ROj5ZbYIevZOjh3UqwQcc20KVlU+TeSEg5w17yCiKLqslaW6yHB3nqOiznT1?=
 =?us-ascii?Q?CoRzyaD06QbLOTgzbo4pKuDDzgzo9qajTaE18yJ05wm1k/yqRHxrXpmLxGNx?=
 =?us-ascii?Q?arnFNTzDI4txx4n3zjzqp9+TpFXAMOTmfL2mmyoySUlrHPefl/UCSceHrXCp?=
 =?us-ascii?Q?s+R2QVrN5J91n5+LL5LoswjJCw/Hz/0KGzzNizZ3SWsblC/as8bA8FIfdSCF?=
 =?us-ascii?Q?/a3t6Lvh77/B0M7dVtCdfhMjkpg4fkshhFr2EBY0pH68ZdbTgOj/yGoOA0Fr?=
 =?us-ascii?Q?s48L6KoRn/1Nz2oShORfxfu0jocuCdr1847jzr7s6y1bmMEgV/uXAaFz7P+n?=
 =?us-ascii?Q?Zak6h6FQ6Te9CRooR0RlSvUYGW7UdzPOEsHq5IYYWIFDycqaOyTTYdBQWL3L?=
 =?us-ascii?Q?KE0eHlRDcrBKK53GGDsFqsYrZfembYr8ip60tr8VOy8E3TN53ehhYnWXHvb5?=
 =?us-ascii?Q?xbJQrF4E7PtKSMEvrh7dd4WwanLZW1kE8s5NhgRC/QL5ckr1IEqd0XNIVyW+?=
 =?us-ascii?Q?4g3bo9paQvuDKCP1SzlQGNUvtii772cWf0OO/2gFcJTb9MfhSbhQKsMr9fzg?=
 =?us-ascii?Q?nach4qr/C3JA3Pt1a0KE5DfwhFTYduy6bkw0B7Wzk3FkzUFbIcEPigZSnl9u?=
 =?us-ascii?Q?unjHVMKkak36vam8KX4GHwfjRIZY4dkYUT7in3hResexwRfO+F8tbp3PwHYH?=
 =?us-ascii?Q?1q/4u5Sg/aZkzQsr3+gh1YB0KhWQGV7U8V+IF6unqd/woUXiNSyDWzRum/n5?=
 =?us-ascii?Q?bBXPJFH930YkpmYzIiYZZYXzst0kXBkUL+pZkhpf3d7L/cjwH17HStPKFQlk?=
 =?us-ascii?Q?R0I8f0T8JInajI7S0e284Eiz9LwUIT4ktfzJpA/4OaRlmFuNFO/af+WLzXbO?=
 =?us-ascii?Q?dx0NOQox70genbDfdm2orE4vcuDDyUCafOvps44Dy+OObabVjdBAaztJBIqu?=
 =?us-ascii?Q?fLmeXg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca453dc9-6b20-448b-cfb4-08db05bf12a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:17:21.5083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jyyP0bBMILBC+GqfNMEGViAr9Y7thRwar4WZnDVYTwTJeNvb553rkcpTALvS1uLKv88K7dIxXJm/VV2NBs6aP9Ez+SWtz0R+G+d4yhGnKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4654
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:45:56PM +0100, netdev@kapio-technology.com wrote:
> On 2023-01-31 19:54, Simon Horman wrote:
> > > --- a/drivers/net/dsa/b53/b53_common.c
> > > +++ b/drivers/net/dsa/b53/b53_common.c
> > > @@ -1684,11 +1684,15 @@ static int b53_arl_op(struct b53_device
> > > *dev, int op, int port,
> > > 
> > >  int b53_fdb_add(struct dsa_switch *ds, int port,
> > >  		const unsigned char *addr, u16 vid,
> > > -		struct dsa_db db)
> > > +		u16 fdb_flags, struct dsa_db db)
> > >  {
> > >  	struct b53_device *priv = ds->priv;
> > >  	int ret;
> > > 
> > > +	/* Ignore entries with set flags */
> > > +	if (fdb_flags)
> > > +		return 0;
> > 
> > 
> > 	Would returning -EOPNOTSUPP be more appropriate?
> > 
> > ...
> 
> I don't think that would be so good, as the command
> 
> bridge fdb replace ADDR dev <DEV> master dynamic
> 
> is a valid command and should not generate errors. When ignored by the
> driver, it will just install a dynamic FDB entry in the bridge, and the
> bridge will age it.

Sure, I agree that it's not necessarily an error that needs
to propagate to the user.

My assumption, which I now see is likely false, is that drivers
could return -EOPNOTSUPP, to indicate to higher layers that the operation
is not supported. But the higher layers may not propagate that.

But it seems that is not the case here. So I think return 0 is fine
after all. Sorry for the noise.
