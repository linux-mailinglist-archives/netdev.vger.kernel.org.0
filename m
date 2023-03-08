Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A576B12B6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjCHUNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCHUNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:13:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE7461A9F;
        Wed,  8 Mar 2023 12:13:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtCuqPAPCA7tvQmqZzzUvqxRzJIyheki7hjzEVstX5yukOaN1ELY3o4Bt7W8FTU+fgPykaGF62Z4iBdOAlJW2FfF3aNMVUt1vES6AnV7cQXqVz4X1k0ttnb5B7rE5yCgP2W+EAm2l/jMMa1N/YmB9tYsVB8cf1be33fWefYWef4bUweU2E+wOFtiARu/ImE22e/3eoi8OO2ywSX4qi7s/1b6mMuU8XfCs2eLZt1wFZcQbt8MGbl01gAQnJUj85wzUdXA+/SPHEd/OZTE8UiLrZkzht6G7GJy16Mq27DdjNfqzHfm2NYaBC82bLzj1//7j9ZhiW0my9hJ2/YjOEOvCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woIBgvcqwKFlqVqMtvl1T53IJgFRrb4fL6j5LgmnmUw=;
 b=i+HrZOmxpredW7Sgv7FinEke2Ja3BCdmrICw/hQnckHNIBMlq7HjdVBvjG1ONBFcz7vUb1xEdIjIH7hzWkM9nUFReYn/x66pbVGJVoHEuYgs8PtSYw9dC9I6NBf1ae3bB0inqJSdeD64ZjXqLhQPfhnsV4yOlTnfWGMaWHC6obR5FTM9T1B0eyc8Xc1FKiwsDGpy7d8tjd7UCV3bnqFCKpufAqrw6y3JBunRSaAvoAXaE4FHX1jrfCbtn2K6vBOWWXnDvQ0my+YpUAw/vt3SlkSHX5ir3T/LjeI9z1Q4xaTWNtWPKrs20oiXavjoKwMA6F7Ry87D7TlCeJnQ5in5sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woIBgvcqwKFlqVqMtvl1T53IJgFRrb4fL6j5LgmnmUw=;
 b=ouMONSnqNo3rEFOejV+odZpkZuZotojjhyr0nF6nmzO87uTn0Smx5+9qy6qnlMV/NsseNL/r5QPFrACo30x9/Px7PWureZ5rRar6C1ayyH/N/+sh928SBOgAoaakOXb3ZrG9XdzXDA3EhAcEBkxnlj3D/l8VYIhAtwrtGTrCDMY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6282.namprd13.prod.outlook.com (2603:10b6:806:302::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 20:13:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 20:13:39 +0000
Date:   Wed, 8 Mar 2023 21:13:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Gavin Li <gavinl@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gavi@nvidia.com, roid@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
Message-ID: <ZAjsa538mpnEQ/QI@corigine.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
 <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
 <7612377e-1dd0-1350-feb3-3a737710c261@intel.com>
 <3ed82f97-3f92-8f61-d297-8162aaf823c6@nvidia.com>
 <531bac44-23ba-d4f3-f350-8146b6fb063a@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531bac44-23ba-d4f3-f350-8146b6fb063a@intel.com>
X-ClientProxiedBy: AM0PR03CA0038.eurprd03.prod.outlook.com (2603:10a6:208::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 00193acd-6857-439c-6cf7-08db20119ab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clXbwE21w3iHTnnC+93h+ViPdMI00YHPw5Xxc6xR6S6iJrke7cF6KAVT3Pmx9GHuFvP9Usgmjk7MSwln4wrxNhBifM2lGSOxN4xzrwkXgSdf70FPwzZZPXrKUeuhQkPP3JwNMxQvypELTlBOrzJiIxayEAtx6R8DBLVc8eGtE+JB8jKnQWRuOpcMWrN62mUuAqRZmL8Ao71iskHWlkNRkFuBP67i3ZZuphin01lVm4gLVgAyGniy5TS1695VWzoTawr92u1N3MyoOpyW9H9lgfnt4diCzG+UQLaNuwTZ+J3HXhMhfpY0AZcNWqlPWscNIau8Wk9UF3BpOaPsg95LDUes4z2QLy3LlOAVO0LB2CvdOaUHgx6xQZX0ZTReAkQD83hf1JNYgaCr+Xr70+WtkH8tps3v0SGiKwEA3MvsyfGlEr531Agx3qkGU9I7HFnXBn+6Rib1ee2qljgXtVUgRfmtX/IlKjjRtayqfCefY0EchA8z/DG++oSHUWWBolxRFnccxDlldYTacWi3wMCEXF1h1TDRwX1a0NaGgaQNSxtjX5VP6sfxnMyqxSC9CEJOiGT5T4ugp3gDJ4Bk/vzkETHB3MN6x0bWq0C9NYUY9dL7zBb62tPDU+QoYPyYPJp5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39830400003)(396003)(346002)(136003)(451199018)(8936002)(5660300002)(44832011)(7416002)(6916009)(66476007)(66556008)(4326008)(8676002)(478600001)(316002)(2906002)(66946007)(6666004)(36756003)(53546011)(6506007)(966005)(6486002)(6512007)(41300700001)(2616005)(86362001)(83380400001)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE9yVi9iUW9wRlRoNmNZUjk2WkZHT1MwemhNQm1pdjdqd2NqUzNuZW9RejNk?=
 =?utf-8?B?WHB0dUEwcGpxL3QvbmREZ2dwNmFmWExWdlQwL1lKejFMWkpNdG1mQlg2Qml3?=
 =?utf-8?B?aWVmZ2tlK2E1eU9QaHFuVVBUaEJTUnhmTngrdGF6M0VQMjRZT3ROa0h6STY4?=
 =?utf-8?B?VTJaN1VKT2Zma2pjMHFvTkcxK1EzaTE2SDZ6bCtzaVlvUFNvUzBvUUl3eXB1?=
 =?utf-8?B?Qy9ucFNPVzRWakZZMkV5Q1dqUzJtWGF4eGczSFlrTDFJQkk2L0hjL2R1aDR2?=
 =?utf-8?B?dGlEaWJXWEVIR3FqbEo2eVVMd3ZpNSswNklhd0R6blFRbHNkaWxFZGNucThs?=
 =?utf-8?B?M2c1NDdIdVZsZHZVR1Q3RzV3eURGRFNicCtUeVZIY2NJblpPUlVJVm8zSHBm?=
 =?utf-8?B?bUUrWWpIbUxZcHQzRGx2bGtFanZZRVp1UERKZlNkOENrMG5VaWkzMFNaQ3pl?=
 =?utf-8?B?cFhpNXBkalZralJYeEs2b1piTGRxMW9hVlR4VHl1RWN2eXIvOFM5MURMN0NP?=
 =?utf-8?B?eFpQcmJhOERmUTZEYWw5ZzNvaG1nWGI0MUM2ODlSOWpOUlI4RWFyb3pwUWIw?=
 =?utf-8?B?SzJla1NjS1N1bW1ac2R1U3p2L0JVQWhwcyt4dmZCd21oTHEyNU1qaEQyZXZp?=
 =?utf-8?B?Ym5CT0V3S3RiYmVuZnVYNVFyeXhJbjVSOVVnVTEwSUJyNFUyK3IreEJXczRx?=
 =?utf-8?B?UFIyTVB1Z0RZaDNZSjNTclc4R3ZOVnZ4MEtZOFU1aURMSTJuU090c25wWXFz?=
 =?utf-8?B?Q2JBZHhSUHpqZ3oxNVUrb2N0TUxLS2ttdVp3akg1bkpVL0JHZHh3bTJ3bDdD?=
 =?utf-8?B?Y1RWYlBMSFJWQ2xrV3BmMnA0aDBFRlFPOEtmMEZrL1BlMnBwdUk5Zm1Qa1Ir?=
 =?utf-8?B?cG9wMWpadkNRQklpV2RxRUw0d1l0S2Y3VlZscDU2REZrUHBwNCtyYkhKbDZB?=
 =?utf-8?B?VHNNSE5oV2NnbzJUMXVpeGtIMW5tbkhKeHIzUmtWSFkvWGpZNk1RS1RrRlRj?=
 =?utf-8?B?SmdhVHhUeitialBxdUM3OFpkN3JwUXZQRkVObFNxa0VWZFA2Z2NEZlV4eU9S?=
 =?utf-8?B?WTRxclRFNWV5dzVvcGJzRU5HaCs1bjdxdk9ZazB4VjQyU0pnOG5COHp3a0M3?=
 =?utf-8?B?VWxUYWRjSEIwc1JjVWRNSHVnZk9jejBMTU11dUZBamVIK0orem1NWXdGd0p1?=
 =?utf-8?B?ZGJaa0MxWERFS0JpTDFXUXBNbzhWWjBNaG1vdzRBNElpaUFhUlN5RVcyaWJk?=
 =?utf-8?B?ZFY1WE4zWXNxaHlZQzFCdm1mNHhmUEhXZlNiMXM4VEVNZkVaYTRSNmRtcW5l?=
 =?utf-8?B?WWxjRnF3Z1ZFalIxb2R6Q1FRcVRUZ2RHY295M052Ym1qTnBtVXNqZmZScWNR?=
 =?utf-8?B?N0hiQXUvQTJRU1JuUGwwaGxLWlkyNTFqQ2kyc1Q4N0FnQlNOQ2lCT2dTM0RS?=
 =?utf-8?B?cGxEMEtBRElGRGtPY3NGVXJWbjBRNUpNZE1jaFJOYWxLZzlINjNEeU4vaDNS?=
 =?utf-8?B?UkRwUWMvQXRDMTFKVWo1bWR6c0RLZ05DZ1dycGFKMlFQdHl4UUlWdVdJbFJD?=
 =?utf-8?B?Ukk4eitkb09ybzV4MVRpK0FuZHNmeTNML0Q0WFVsbEIzYWZ4aVRsbytmbXR1?=
 =?utf-8?B?YktuUlNYZ2tWUlFlRVN0Skg4TTJyNGcwU1NkM090dlk0SlNwTThsWUNXN2Ux?=
 =?utf-8?B?QXE2NzZFVzdGMEM1bTI0TDFEdnh1K3V2aDNEYkJTWWc0SERCeEo0TGFlNjBZ?=
 =?utf-8?B?R3grTVhpMy9nK01SdTVyNnUxTUlTMmhjdCtkaVlQbCtwTXdkbUFxdmxCU2Ri?=
 =?utf-8?B?K2dBRFZiaUcySFJLR1RXUU12S1c3WXJkazlSMWU4OWZ2cDE3amdYYXlNWmVl?=
 =?utf-8?B?OFNRTXJwYy92eVI5RVoybXIrOU1MZmhPU2phY1Fhb01iaUxITTkrM0J3NmdJ?=
 =?utf-8?B?aGE4b0NSR2NFSSs3endUVUNZeFlrRFhDZlFLZU9tMjJGelpUVnNtR3dHaTho?=
 =?utf-8?B?R1pjM28zejVWTFFMVDEvQ1dyM1lVYkhEcS9rRXNBK1pQdzFYaldyVWdvTFFz?=
 =?utf-8?B?ajVxNmNEaGJ0dkJPTWt4cWgwSVpLMkVRbHR3YUhCQkt6S3J5NlkxaTlpSU16?=
 =?utf-8?B?T2NJODAwandET1l1Zlo0NTVVY3FEZlJYQVYwcTZaUUtyWVdKM1lXeUpTRVAz?=
 =?utf-8?B?d1FoNnZLeS9OSG83cnpaODZZQnAxbmgrT0FlT1Z1T05DM2F1aTloaU9IdDNP?=
 =?utf-8?B?blFvZkJjSHdzUm41UDVxU1FRR0h3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00193acd-6857-439c-6cf7-08db20119ab0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 20:13:38.8592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTVRDIOeCJ9bXDs9mZlTrrwygJf7bQO1BQvRyBlKIX/vp8yUn3Expre3TkTPSYGROyergPhQwMZmDymvWY1T+MVbTnc3vjyFBbfAlZ4CcNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6282
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 02:34:28PM +0100, Alexander Lobakin wrote:
> From: Gavin Li <gavinl@nvidia.com>
> Date: Wed, 8 Mar 2023 10:22:36 +0800
> 
> > 
> > On 3/8/2023 12:58 AM, Alexander Lobakin wrote:
> >> External email: Use caution opening links or attachments
> >>
> >>
> >> From: Gavin Li <gavinl@nvidia.com>
> >> Date: Tue, 7 Mar 2023 17:19:35 +0800
> >>
> >>> On 3/6/2023 10:47 PM, Alexander Lobakin wrote:
> >>>> External email: Use caution opening links or attachments
> >>>>
> >>>>
> >>>> From: Gavin Li <gavinl@nvidia.com>
> >>>> Date: Mon, 6 Mar 2023 05:02:58 +0200
> >>>>
> >>>>> Patch-1: Remove unused argument from functions.
> >>>>> Patch-2: Expose helper function vxlan_build_gbp_hdr.
> >>>>> Patch-3: Add helper function for encap_info_equal for tunnels with
> >>>>> options.
> >>>>> Patch-4: Add HW offloading support for TC flows with VxLAN GBP
> >>>>> encap/decap
> >>>>>           in mlx ethernet driver.
> >>>>>
> >>>>> Gavin Li (4):
> >>>>>     vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
> >>>>>       vxlan_build_gpe_hdr( )
> >>>>> ---
> >>>>> changelog:
> >>>>> v2->v3
> >>>>> - Addressed comments from Paolo Abeni
> >>>>> - Add new patch
> >>>>> ---
> >>>>>     vxlan: Expose helper vxlan_build_gbp_hdr
> >>>>> ---
> >>>>> changelog:
> >>>>> v1->v2
> >>>>> - Addressed comments from Alexander Lobakin
> >>>>> - Use const to annotate read-only the pointer parameter
> >>>>> ---
> >>>>>     net/mlx5e: Add helper for encap_info_equal for tunnels with
> >>>>> options
> >>>>> ---
> >>>>> changelog:
> >>>>> v3->v4
> >>>>> - Addressed comments from Alexander Lobakin
> >>>>> - Fix vertical alignment issue
> >>>>> v1->v2
> >>>>> - Addressed comments from Alexander Lobakin
> >>>>> - Replace confusing pointer arithmetic with function call
> >>>>> - Use boolean operator NOT to check if the function return value is
> >>>>> not zero
> >>>>> ---
> >>>>>     net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
> >>>>> ---
> >>>>> changelog:
> >>>>> v3->v4
> >>>>> - Addressed comments from Simon Horman
> >>>>> - Using cast in place instead of changing API
> >>>> I don't remember me acking this. The last thing I said is that in order
> >>>> to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
> >>>> "Ack" and that was the last message in that thread.
> >>>> Now this. Without me in CCs, so I noticed it accidentally.
> >>>> ???
> >>> Not asked by you but you said you were OK if I used cast-aways. So I did
> >>> the
> >>>
> >>> change in V3 and reverted back to using cast-away in V4.
> >> My last reply was[0]:
> >>
> >> "
> >> You wouldn't need to W/A it each time in each driver, just do it once in
> >> the inline itself.
> >> I did it once in __skb_header_pointer()[0] to be able to pass data
> >> pointer as const to optimize code a bit and point out explicitly that
> >> the function doesn't modify the packet anyhow, don't see any reason to
> >> not do the same here.
> >> Or, as I said, you can use macros + __builtin_choose_expr() or _Generic.
> >> container_of_const() uses the latter[1]. A __builtin_choose_expr()
> >> variant could rely on the __same_type() macro to check whether the
> >> pointer passed from the driver const or not.
> >>
> >> [...]
> >>
> >> [0]
> >> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/skbuff.h#L3992
> >> [1]
> >> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/container_of.h#L33
> >> "
> >>
> >> Where did I say here I'm fine with W/As in the drivers? I mentioned two
> >> options: cast-away in THE GENERIC INLINE, not the driver, or, more
> >> preferred, following the way of container_of_const().
> >> Then your reply[1]:
> >>
> >> "ACK"
> >>
> >> What did you ack then if you picked neither of those 2 options?
> > 
> > I had fixed it with "cast-away in THE GENERIC INLINE" in V3 and got
> > comments and concern
> > 
> > from Simon Horman. So, it was reverted.
> > 
> > "But I really do wonder if this patch masks rather than fixes the
> > problem."----From Simon.
> > 
> > I thought you were OK to revert the changes based on the reply.
> 
> No I wasn't.
> Yes, it masks, because you need to return either const or non-const
> depending on the input pointer qualifier. container_of_const(), telling
> this 4th time.
> 
> > 
> > From my understanding, the function always return a non-const pointer
> > regardless the type of the
> > 
> >  input one, which is slightly different from your examples.
> 
> See above.
> 
> > 
> > Any comments, Simon?
> > 
> > If both or you are OK with option #1, I'll follow.

I'd like suggest moving on from the who said what aspect of this conversation.
Clearly there has been some misunderstanding. Let's move on.

Regarding the more technical topic of constness.
Unless I am mistaken function in question looks like this:

static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
{
     return info + 1;
}

My view is that if the input is const, the output should be const;
conversely, if the output is non-const then the input should be non-const.

It does seem to me that container_of_const has this property.
And from that perspective may be the basis of a good solution.

This is my opinion. I do understand that others may have different opinions.
