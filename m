Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D8745ABFB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 20:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhKWTHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 14:07:22 -0500
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:3056
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237867AbhKWTHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 14:07:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIG0NHnk/LwEPveQXXrBf32cgqWUouOyAmp/w66YaTShXfnbZt0o9m3TdNjFoQpOiaLzrKi52QY0BrJ3ir0ovXdPcQWXDPIzAPri36zAbT3OuCqRUAeT/kEy4t9u1Cvbj4RnLrrG+tARtVBnAIZy0J/wa0cfauUjWV5y7bUY9opW8tivyYqP/iQhRhuIda/PCmEQNDbuGoqxG89L2LCQOUsaC40cD1GDLFYurC+RCgktnsDpch+w7Jv2AniARn5mQmdGN6G/np0inmDx/RS8haM3WkXoILyUtgFX3UQghoB4SEKFOcRldibp/hHEXI8408RjXHVa0YkTk+YqNk7//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFXrwl50ll8PZVFuF7YNvMTSMMe9Wk0IjOQh74AqY8U=;
 b=K7Ec4uULHVC+cRbn2SRiN8MHC67KxA1yMPhyVET4+9/N3+x4ZebO9whaK3SMsud+5nvqRYP62y3pkht2rYMaqc+qJlrazG5oH7PEduRzj6ocyWNsVE1eiNMKO3sFAkaldWQSoI9AXKCTGCtslLSuTDPN9gugfexKNY+Wjvs4GqkW38+nJDJbsZIMkAdAzFTdZsVIUVXRIh7nbJDYl9KV3SkdSDKIaaG1dIy1axh9DB4sJi3q1KRaVcfvfER2BuT/EOThBeEe9xjUFNtnKJCC3CEhhpO1XK8JiEefjT24nhkLl5ubp+XNVvmYZK6tpSH9zo6mZyoySoB/yxcT+nqV6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFXrwl50ll8PZVFuF7YNvMTSMMe9Wk0IjOQh74AqY8U=;
 b=A16pD+h+ePylUw9/qpBagvF4HdjHxkJGQDIRaP8m+9kDcrsBeVx7sZube2GLHYkAnLLhvcX1PH0itJZMMgn7+r3lz3md07eKN54/8FPfXvgdb0+B/Rrpt/lgX06J7s4eiGvZyo6EJjjYvCqPIcipDkOVW4Wfgre54w8iNsnA8Zc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBAPR03MB6470.eurprd03.prod.outlook.com (2603:10a6:10:19f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 19:04:10 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 19:04:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Chris Snook <chris.snook@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
 <20211123120825.jvuh7444wdxzugbo@skbuf>
 <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
 <90262b1c-fee2-f906-69df-1171ff241077@seco.com>
 <20211123181515.qqo7e4xbuu2ntwgt@skbuf>
Message-ID: <472ce8f0-a592-ce5b-0005-7d765b2d0e93@seco.com>
Date:   Tue, 23 Nov 2021 14:04:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211123181515.qqo7e4xbuu2ntwgt@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0431.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0431.namprd13.prod.outlook.com (2603:10b6:208:2c3::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Tue, 23 Nov 2021 19:04:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48d3485c-c2d5-4cb1-70bb-08d9aeb407ee
X-MS-TrafficTypeDiagnostic: DBAPR03MB6470:
X-Microsoft-Antispam-PRVS: <DBAPR03MB64709D821CC4E75C0545F93796609@DBAPR03MB6470.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3vY0KArdi6MazWwZKUr75BaxhMnHRXAenb2Ta1pexM7/7f7YX8nXdvY1SIRfrxfzidXcT74w9XhAzw3AIHENZIjI3XSvDFgrw8ofTMQM0rlt6lfH+vZ9LoDa0ZD6tiqtf2htv62Gc/HGqGJL8Mx6Nfrh5AAAeQ7Sp3gjSEdvw7u/T+sn6LbeSPWBK4ff4eCRuHc4tKKGDQxgsgVulVkV5DlXGnwgUzSO2rUKcs2zuDtHzFFs6c1qaPUEMD3DAU0CMeye53WGgpa41ORQbvO1xNt4INJCcBMdrOzrwbJEy7SOY89zWIveeeSuaB+dr3OSKVQ1yf4MlWLP/gzE8YKntMyEB8T8GNR3/0Hk060tr1HnBPVIe8WpaDXH2kV1A4fmyJv+2oK3WISq6ggUyCk4VlXSt/xPdvaCe3rX4So6CYs7Ak1/CBKAboN/ExEF8x/CuAgme0MTMp9vN9MkjOoAPPduNY7bY1DTNn988OCUHLv/cqUaJDuHe5C793KWLEpTP+aF5SAliv3rncYAzqW6uwUCB+u0lgQjGEE/wEDbGfIcx32XK4pF49sMcR8vJfi4kq6Jw8uR9A1BcOw5HyHacKTMSs9vGpWDX7JxNN5RqeKBTserF/WR1l+woPIqwBYQN+cJe2otnaHUNrmbk37bmSq22yS+0niMrS/ZnYBNi6hBImlx4wrxo7PF1Z48XtJrTKxY8lpgVYSHYVacTTtg7ajDaPfcGw7y2ftizRg2JX8U3W32D9y9q73AcTmw7aYVDoohIRbC/uj5S96a/fnsOG8ubO6cF2fI4mpu3uY1gQev+eWN2jY37dQCI5rYBRz50yL9SnAfMsbucDqCpXMZl/J0adKWfSooBWvyHEpIqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(66556008)(66946007)(53546011)(26005)(36756003)(52116002)(6486002)(31686004)(8936002)(8676002)(31696002)(2906002)(83380400001)(186003)(54906003)(6916009)(38350700002)(38100700002)(4326008)(16576012)(966005)(508600001)(5660300002)(2616005)(956004)(44832011)(7416002)(316002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlJYdnAxTEFyd2tKRjBNZlhtS05HR0o4WXE5ZFFkUXF6TU5rUThOWWU5WVM2?=
 =?utf-8?B?N3pUSnZGdTd2NXZMYzE5VHAyczBHd3ovRnFqS3AxaXN0K0h4eTJVT1pUVnUr?=
 =?utf-8?B?dG56UlZzNDZEc0JLUDVaanVJa2Z3MjM1WHRheDJuSEFBY0tHdi9WaVVYUXZW?=
 =?utf-8?B?REs5ZEN5a2FucXVoMk9sM0xyanRGRTMxdHVuQWJFRkhUaEtYbTBQOE5qWVhi?=
 =?utf-8?B?cWZSODhYcGxQcjE4SUh6b1hyVGhNNHB6NHhaWUc3eE9MMmhVTVVtc3F3NWpQ?=
 =?utf-8?B?SWJ5aC9NbkVoME1sSEhZUXF6VityTWFTM2dMTitRakFvSXovWVZEKzk2T3Ez?=
 =?utf-8?B?WGlINVRDSzRVVGdvTGRUM3dBSmFBZXZDQkJZeG96OFJQVE81bWxjaG1SQ2dR?=
 =?utf-8?B?YUszQm9Bb1FQRERPWHN1NkcydXdlVld1QzZvalhIeFB3ZnZHNzJyZWtTbjlS?=
 =?utf-8?B?MnJvellGNHpuZStsUFJpOUhNcElxRHZhZy9vWk16Um9yM1hEbjlwN2VNT1pp?=
 =?utf-8?B?M0EzMzhHRmlyVndVS2REWVZhMFRCVXdIQTlQa1VuUWcxVlhKLzdQeFVCNjRn?=
 =?utf-8?B?MXZKRml4WkkwUFlvT09vNk9ZaHlHb2I2NVhnbUVUV2pNOWVpMXh4N3hkNlpt?=
 =?utf-8?B?cDNwM0w1K0V3N0EzRFhVeStwNzI2ajRKelcxOSs2THhTZGhyYzUvMVZwSzJE?=
 =?utf-8?B?NmUxOVcyWmNtY3ZkV2NVcmk1TDFLVThLdklrV0V0RnJSVGltc1h0aEd5YlFm?=
 =?utf-8?B?cWpNNjF5Y01iekhzWklESExCdXF5UEpVU0lNYThpNnNRNWJLMmdOMnhzMUM4?=
 =?utf-8?B?dTNSN01FSXM5S3hmd3R6blVhb3lPSUhQUHlXMTNZcjcra0FTWXRJUW9YaW9R?=
 =?utf-8?B?a29DejBNVHRiUitZayswVC9TUlloeUpoL2pCc0hySDVEb1ZjOTlQOHE3aE5R?=
 =?utf-8?B?NUJ4dUZzeGt1NHcxMFp0UUExaVViOGUxTDdwZmI1K1FoTXBYU2FmWlJ3ZWU0?=
 =?utf-8?B?K1UzdmVSTUJkN2J1VmI1ZTdXam5NZ0dYb0FDOW5acDJwNVhqTmNQRlZSR2Vk?=
 =?utf-8?B?Y1NxQmZ2MFJXWVA2aG0yb1VPcGIrTzU2a2E4TEgxVGVQQTVWTHQrWE5YdUR3?=
 =?utf-8?B?YVNMdlc3YUtmRTRTRzluVjM0QUlTZ1dKL3MwcnlhWEd1MHJyWGtxcW9nWFRr?=
 =?utf-8?B?M04yaEd2eFVQc1NvckZQaUhCTHB0UVdVOG9sdzVFZ2FVVUJTOU80UUl2d0Na?=
 =?utf-8?B?bnp2QisvTW94ajFKL25yWHpKUWVWQmZGOVNIenVnZkpPSlBPR2VVclM2NXJj?=
 =?utf-8?B?MDBnay9qNjdtZDZCNmlJZ01XRldqZHFUbnZqTFhBUlZuV05LOGRicUZpb05k?=
 =?utf-8?B?dXJuWlNWUnNkMWl6OEJiV1hWcllTYzU4ZGNLeG9JVVU5WVg3Ukp0T0NaUGY5?=
 =?utf-8?B?bmIwaWNxeC91c1UxdjJkK01ERnhKMGJNeXdMem1ITU9WaU1rZDVBa3RRcUFz?=
 =?utf-8?B?OVJkVGk0VEVHandhNllyVE9neFBsaVY0cURkNFVpRHZFRjgrdWlRanhzVm5i?=
 =?utf-8?B?dGd3bytSNC9aMU5XM2hMRTVlV2lUdzJxUU94cTArNmNCNHVVWXEraUU4SGNi?=
 =?utf-8?B?dk42d21JVk9mV0dhL2luOEZQUnFhZzhPYjgxZ25iS1BrbWkvcFYxbWVUM1Uv?=
 =?utf-8?B?aVhhaEQzOFBoMDhzT1hiOFRCUXNBalZoVmdwYTNUWStaRXpuR0tONUNGb2FH?=
 =?utf-8?B?c2M1bWluV0xUK215aVVSQ2laa1UwcDQzMFNCMzVPQUY5VTFvYjNYSENmOGdG?=
 =?utf-8?B?NDZuSUZHYnQwZTFLYVRveitiSXQyK2JBOW9LdlIwTEQ1TE1KSzRjZzZub2N1?=
 =?utf-8?B?VmVmanQxbGJFeWVBYncvMkNSLzAraTliYWd6aEpuRmk1djE4L2JucDUzeE93?=
 =?utf-8?B?MEVveW5uMXlsVGdpVHp2UmcvRVBzY3NSczRlOWtNa1FHTnYzZnJjdlBqSm1u?=
 =?utf-8?B?SHdkN2pQUkNXWU53QWQwYmFkYlQ1MWwxWDd0bHBDS1FhRVoxNGdlZ1lzM2gz?=
 =?utf-8?B?M2NkTktNZ2IwNGhjTzVobW45VUhMNXpZdG15MEVKdVY4UzhvNkxMeXJYOFlN?=
 =?utf-8?B?dlhYVHF3VUJ1TDFqZFg2VTc5aU5wWUlPdktyMWlMRUFHOXpaSzlKMWlpcjho?=
 =?utf-8?Q?aE81tZjIHL/fCToRkm4ugOM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d3485c-c2d5-4cb1-70bb-08d9aeb407ee
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 19:04:10.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APkLzHTDTVNG+lAEukx0FDYdEG842F9dWIWD+3yvd5SSOJaeOiFvtASOlRWEcyKobcyR69+r6r+A2TBAt6uR/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/21 1:15 PM, Vladimir Oltean wrote:
> On Tue, Nov 23, 2021 at 12:30:33PM -0500, Sean Anderson wrote:
>> On 11/23/21 11:08 AM, Russell King (Oracle) wrote:
>> > On Tue, Nov 23, 2021 at 02:08:25PM +0200, Vladimir Oltean wrote:
>> > > On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
>> > > > Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
>> > > > the PCS from phylink. This is only supported on non-legacy drivers
>> > > > where doing so will have no effect on the mac_config() calling
>> > > > behaviour.
>> > > >
>> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > > > ---
>> > > >  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
>> > > >  1 file changed, 15 insertions(+), 5 deletions(-)
>> > > >
>> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> > > > index a935655c39c0..9f0f0e0aad55 100644
>> > > > --- a/drivers/net/phy/phylink.c
>> > > > +++ b/drivers/net/phy/phylink.c
>> > > > @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
>> > > >   * in mac_prepare() or mac_config() methods if it is desired to dynamically
>> > > >   * change the PCS.
>> > > >   *
>> > > > - * Please note that there are behavioural changes with the mac_config()
>> > > > - * callback if a PCS is present (denoting a newer setup) so removing a PCS
>> > > > - * is not supported, and if a PCS is going to be used, it must be registered
>> > > > - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
>> > > > + * Please note that for legacy phylink users, there are behavioural changes
>> > > > + * with the mac_config() callback if a PCS is present (denoting a newer setup)
>> > > > + * so removing a PCS is not supported. If a PCS is going to be used, it must
>> > > > + * be registered by calling phylink_set_pcs() at the latest in the first
>> > > > + * mac_config() call.
>> > > > + *
>> > > > + * For modern drivers, this may be called with a NULL pcs argument to
>> > > > + * disconnect the PCS from phylink.
>> > > >   */
>> > > >  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
>> > > >  {
>> > > > +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
>> > > > +		phylink_warn(pl,
>> > > > +			     "Removing PCS is not supported in a legacy driver");
>> > > > +		return;
>> > > > +	}
>> > > > +
>> > > >  	pl->pcs = pcs;
>> > > > -	pl->pcs_ops = pcs->ops;
>> > > > +	pl->pcs_ops = pcs ? pcs->ops : NULL;
>> > > >  }
>> > > >  EXPORT_SYMBOL_GPL(phylink_set_pcs);
>> > > >
>> > > > --
>> > > > 2.30.2
>> > > >
>> > >
>> > > I've read the discussion at
>> > > https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
>> > > and I still am not sure that I understand what is the use case behind
>> > > removing a PCS?
>> >
>> > Passing that to Sean to answer in detail...
>>
>> My original feedback was regarding selecting the correct PCS to use. In
>> response to the question "What PCS do you want to use for this phy
>> interface mode?" a valid response is "I don't need a PCS," even if for a
>> different mode a valid response might be "Please use X PCS."
>
> Yes, but that is not a reason why you'd want to _remove_ one. Just don't
> call phylink_set_pcs() in the first place, there you go, no PCS.

Yeah.

>> Because this function is used in validate(), it is necessary to
>> evaluate "what-if" scenarios, even if a scenario requiring a PCS and
>> one requiring no PCS would never actually be configured.
>
> Yes, but on the same port on the same board? The MAC-side PCS is an
> integral part of serial Ethernet links, be it modeled as a discrete part
> by hardware manufacturers or not. We are effectively talking about a
> situation where a serial link would become parallel, or the other way
> around. Have you seen such a thing?

I have not. It's certainly possible to create (since the serial link
often uses different physical pins from the parallel link). I think
we can cross that bridge if/when we ever come to it.

>> Typically the PCS is physically attached to the next layer in the link,
>> even if the hardware could be configured not to use the PCS. So it does
>> not usually make sense to configure a link to use modes both requiring a
>> PCS and requiring no PCS. However, it is possible that such a system
>> could exist. Most systems should use `phy-mode` to restrict the phy
>> interfaces modes to whatever makes sense for the board. I think Marek's
>> series (and specifically [1]) is an good step in this regard.
>>
>> --Sean
>>
>> [1] https://lore.kernel.org/netdev/20211123164027.15618-5-kabel@kernel.org/
>
> Marek's patches are for reconfiguring the SERDES protocol on the same
> lanes. But the lanes are still physically there, and you'd need a PCS to
> talk to them no matter what you do, they won't magically turn into RGMII.
> If you need to switch the MAC PCS you're configuring with another MAC
> PCS (within the same hardware block more or less) due to the fact that
> the SERDES protocol is changing, that doesn't count as removing the PCS,
> does it? Or what are you thinking of when you say PCS? Phylink doesn't
> support any other kind of PCS than a MAC-side PCS.

I mean that with that patch applied, phylink will no longer try and
validate modes which aren't supported on a particular board (see
phylink_validate_any). Although, it looks like set_pcs never was called
in the validate path in the first place (looks like I misremembered).

--Sean
