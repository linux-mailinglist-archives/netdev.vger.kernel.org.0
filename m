Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A736D83AE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjDEQ3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDEQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:29:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58C6173E
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCgbeJu2sB8szEIMZi3NuoIJyVUH3SPipsSPPbIt2bM4/swrEymT/gi/I0io6DW3FTIM18ypkGlBVEV9csXzZzX7lspT8wg+lpEW1rlMbMYkBouRjxQsC1BXN12tXrR89CY2plVViHArNdUuAb4sLgJzCNvn2E0f7wJjg7BD65BbZNjPzzNXr75tZHteaYdlFny3Du6qwNegYkxR08VxK4U9mWRN9p/sBtChmHy/KiyUoPhap+dZGssEYSmUlvC3R2sWO4srOe46tCGoa/AdGUEeuWwTHBDjwhAtcgiOiUcMFM390nVf/FF709ZmBL4jx7FNC4q4qKsWYh/X2IA8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcN8cXSvbqXCTSSfRPFgLLAXynB/hHubAUMLr5TxhOE=;
 b=QHWhOKqlDBno20Z/KlISvEi3WiQkok8hOOQJx8fj5eMY7OTgUsinLBr4+XHVT5I4Y5R3qhZuhylw/vlOvMaSmzhd1m0xQOAPwcNX0CdkL+vt7b+/Wmk6+r4NN/1J6M4RdROW5Nw+FSBlI/jzCVhh1gt7XfbFyObwaH7yjaV+GPLXA3x06EVd6NLy8evhsrXjJA4vvylQuaEL1YdtBf0lwf7E7U4e7iI5pI5JL+c08cDDKCYkRMlrca3BIQPO8R2z5AJHw+C+XYCIa8IHFEGP8RFmBHq0tGPSvM23ETu/PvDHOdv4fqp7aWnBG4lWeVKyTKYkluHId3a5X5q4RbvTaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcN8cXSvbqXCTSSfRPFgLLAXynB/hHubAUMLr5TxhOE=;
 b=k3kdIJXag8zuxg1O1ZbjqhAbsZ9ctQEYUQTkS3Q4gN7oen3MyOEHpMvPpPGewKdiDInuIH2gognrK3nUbP01QyA9ZPh1yxMAwJ8Y4vYlwKXX7FCqjUm0hLSoc8dARah3bUbshtWfdQ+wA6y52kK0ANofJgcW6DKOWkdVzffUo/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7283.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Wed, 5 Apr
 2023 16:29:02 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 16:29:02 +0000
Date:   Wed, 5 Apr 2023 19:28:58 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405162858.hu5qqq6lebmo2d3u@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405122628.4nxnja3hts4axzt5@skbuf>
 <CAP5jrPEcO8Xdjby=BHwPjBdCHaY1ajg6EZch=ZMx40DTFV0gLA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPEcO8Xdjby=BHwPjBdCHaY1ajg6EZch=ZMx40DTFV0gLA@mail.gmail.com>
X-ClientProxiedBy: VI1PR06CA0168.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::25) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d9f29f-3ae9-46da-05d9-08db35f2dd83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZjnn1Hb/oPqA39+QkIq/AGZihwAjehX16mB8kucrMXhLQwsbFu2pL+h/nHfYe5N3Z08s6tmJUbda+QaBPkk15GoEk7p2zeBzHlQNdzfB1i7oBkMkAlQHNGuCy5pxqSDBF6VegGuXp4jkH/iiknI0xo+1H63r79boain7gc3Je5elXbVSUClt5j3fUDcJ0X2JgSBpb0FWn/LUJrrUXXHSHjft6syH6M65Vwv0R8kzjrv6KYaKr90FofP22anw3ABIYoPa6Ify1D7qC3TafbEvxMrF5rXsmxWqQtMqGM7W6qgaByO9VR15iTmnLJGQjS8qtCa5pOoW6+8ExHazLMi9fL9IJgjNOzFsfydV5lLImtxrnHyFNM7Nb2/pifg3FQJY3wxR84iGUztzhpqvHBP2icy04OofOUdh7nGfOEn2X0qRCCV+5uBKr14DKTx6XuROTRDqik2MJaNdnBrhg6gIize/rSnubTYAXplfG50/9d8U9yL65HWe2E/TD/iFnEyWcW2v0LMPF766QRirnQhCgWeFb59czHkMwn9Qb4cLOTtJSaJDlO5taRgZ1pqVIBD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199021)(5660300002)(26005)(8936002)(1076003)(33716001)(44832011)(9686003)(6506007)(6512007)(6486002)(186003)(8676002)(6916009)(4326008)(86362001)(41300700001)(6666004)(66476007)(83380400001)(66946007)(66556008)(316002)(2906002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?518fqeQyyJy8VlPVZPcm9sI0T57mOAerfiKaykxzXBaznOaFjDULAjkZWly0?=
 =?us-ascii?Q?HmBDm8GJBrZ61HhaiZ73RsqBk5vkmgy2ToqMyo49BnAkB1YaPVLEm+oe7tVu?=
 =?us-ascii?Q?XN51aI1+an49ZQiFDvX/kg3RNKkNJM5V0A+lDK3HWznyIjGj9h59/2gE6wV3?=
 =?us-ascii?Q?eOrIoCyae6OOdRcqo1VRoaj8ibL0uGO1nwaxDU6H+SUFpsVpW6uJ2uCAQMln?=
 =?us-ascii?Q?Sz7A1ky54w1xYvaWWrnex1oa1WhJZzvzahua/SGf/TL8izJhe2YaIoEuaY7+?=
 =?us-ascii?Q?3FtVcbwtN6BAtQI7Z1mVNBg0zO6cjEA5Atiw9RFrTjxRBfJWT4zS324JB1EX?=
 =?us-ascii?Q?NLtATw8s4njloFChYZ2Fn4O/gK4XhJyUHObY3OLoIHj0qTDQjrSvwaOfIUve?=
 =?us-ascii?Q?NgdluLzy5aZ8kuTmdV6d5dfdWU0w0a3h652WHmQfSkQs6eIcGrTnUMVQL7FO?=
 =?us-ascii?Q?SMYG0e04r63e0t+46ycrhT5MrY0L/a57tPVjnnY439aaKMLit48OUfeR0x0/?=
 =?us-ascii?Q?aj3jdkp/4oYa3XpvP8FWahsxT5ZtZkf92as5aYbtMIk3KKGIwvk2s5YwJNvJ?=
 =?us-ascii?Q?FIPzsSB7GKVMhrNAudTQLH4e8DvarBjWOG2y3jR7WPSoQrOyDA/ob1a95hns?=
 =?us-ascii?Q?+6RiVWWZL59KwBIHqU32Xy5xM43WvSKBIafbMu2jAQrQfir+3Uyg1tl6XejO?=
 =?us-ascii?Q?VfZw51TcHaRb+LtgDMtyp7bLjmSm1zTqdMM4mBF1J2P6cSh3sV3gwhm7rn8q?=
 =?us-ascii?Q?1RHXuDp6H/Y7VDF+r0ZW+GfMivZLXg0kzKlfmLcDF077yIwWoqtcbx16QHiB?=
 =?us-ascii?Q?2k6hNdULr4xP9epd/PmUOXBrwX9VcBtwYcYxMFR8ufyYJIIZw6OBsBCTfwRU?=
 =?us-ascii?Q?YvG+f6aBw25Rn+xFWg4micT39HoY7J8vRtuVTFurxyC6pFpthkysDreYv1Vj?=
 =?us-ascii?Q?H2H7wXdvPghk1XjaTAE4+633Fq2OrugloSdusJrFGihie8zlI8jzVvHlyx+n?=
 =?us-ascii?Q?A/71wZ7P55TeA6Wgn0rIPFi3yNabt7+zH46BOiEa7kr6+xEYjMpwE4FgQ/+G?=
 =?us-ascii?Q?WlvFubfD3d6tx0D+eud39GomYCaxV4cctNxQyyxTIAwxfa1rJ2de4pYEQukh?=
 =?us-ascii?Q?huIeq1IcN7w4nM3/O8qvJfVfuBA8T8HGscYbQuX1U5Cpio5VVdhDHraLqgdR?=
 =?us-ascii?Q?sd/7liBv+EUG8YXPWArq7lgy52MiLPBfipv76gM3OpQlc2J8pjy0sdyWlj6E?=
 =?us-ascii?Q?T+y1XfKoXAoLZdxS85cicS0ZOFuCPYeKSUVcSwGc8UJ17ofUvXh+/USUZO4d?=
 =?us-ascii?Q?VyKt1dFavVyua6rDXEh2AO8To08c5DM0lrIH9M85IwaAUE2VDIJ2Q9yOGvrY?=
 =?us-ascii?Q?fMSIxGs7ytCqp4q0230a9HlrsouGwCBB2BkTZNbTsotpQE2HyC23Q5iDtVHw?=
 =?us-ascii?Q?1xfvv5Do6HRJxh/4sSRUYX48DxB1ELFF4tCfvrqZ/mJdWvezAuMtjZyZtfBQ?=
 =?us-ascii?Q?g/pOvT2/2Ezvr07JGyl7zQgY27Gz9I0VYertl/orY5X9cR9qxM/yroXMvXg/?=
 =?us-ascii?Q?nvG/0xO5AlwknArZh4TM2e8GfrBQ7e5vFn2+shHght5leVsw07Viarq+jPUy?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d9f29f-3ae9-46da-05d9-08db35f2dd83
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:29:02.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdTtmWn5UNbvcmPzIFV3WDZ+ThQ1ibHO4Lli8k3EvqMlytV/mGHBOEgVXSyYCJNllp0xrDtBHQ+UdVy27ylCBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7283
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:19:11AM -0600, Max Georgiev wrote:
> > I would recommend also making vlan_dev_hwtstamp() be called from the
> > VLAN driver's ndo_hwtstamp_set() rather than from ndo_eth_ioctl().
> 
> Vladimir, could you please elaborate here a bit?
> Are you saying that I should go all the way with vlan NDO conversion,
> implement ndo_hwtstamp_get/set() for vlan, and stop handling
> SIOCGHWTSTAMP/SIOCSHWTSTAMP in vlan_dev_ioctl()?

Yes, sorry for being unclear.

> > My understanding of Jakub's suggestion to (temporarily) stuff ifr
> > inside kernel_config was to do that from top-level net/core/dev_ioctl.c,
> > not from the VLAN driver.
> 
> [RFC PATCH v3 2/5] in this patch stack changes net/core/dev_ioctl.c
> to insert ifr inside kernel_config. I assumed that I should do it here too
> so underlying drivers could rely on ifr pointer in kernel_config being
> always initialized.
> If the plan is to stop supporting SIOCGHWTSTAMP/SIOCSHWTSTAMP
> in vlan_dev_ioctl() all together and move the hw timestamp handling
> logic to vlan_get/set_hwtstamp() functions, then this ifr initialization
> code will be removed from net/8021q/vlan_dev.c anyway.

Yes, correct, dev_set_hwtstamp() should provide it.

There's a small thing I don't like about stuffing "ifr" inside struct
kernel_hwtstamp_config, and that's that some drivers keep the last
configuration privately using memcpy(). If we put "ifr" there, they will
practically have access to a stale pointer, because "ifr" loses meaning
once the ioctl syscall is over.

Since we don't know how long it will take until the ndo_hwtstamp_set()
conversion is complete (experience says: possibly indefinitely), it
would be good if this wasn't possible, because who knows what ideas
people might get to do with it.

Options to avoid it are:
- keep doing what you're doing - let drivers memcpy() the struct
  hwtstamp_config and not the struct kernel_hwtstamp_config.
- pass the ifr as yet another argument to ndo_hwtstamp_set(), and don't
  stuff it inside struct kernel_hwtstamp_config.

Neither of these is particularly great, because at the end of the
conversion, some extra cleanup will be required to fix up the API again
(either to stop all drivers from using struct hwtstamp_config, or to
stop passing the argument which is no longer used by anybody).

I think, personally, I'd opt for the first bullet, keep doing what
you're doing. It should require a bit less cleanup, since not all
drivers do the memcpy() thing.
