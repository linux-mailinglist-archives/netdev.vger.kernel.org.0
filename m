Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036D06C6DD3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjCWQis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCWQia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:38:30 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F4A32510;
        Thu, 23 Mar 2023 09:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IehItXnEbRpEbz62tkAeCxRw8l1BS3qwI4yH3SxPmfyqZQNylTOh1llKhWxx/8bQpGBOgDIaTJkWlnVjhZ25Qks/NIrt8A6b6StLsOzrgw0qP1I7BzvnIbEtDNYSjmFF1q9T9Zrw2RkNhm/wsWJqjUhL1Btc3tCUPcM61I/QpttMcwGz7sCm42XeOAD+vzuaMa8MCeUHyvcO0JtYmhzYfsOwzvY/H51MuhOm7TYAo/E0pCTrOprRt17QRonOj01oKGLVYW/AUT4MG2QUbP6WRPVNYDrFB213RTg3qXoeMhTPv0t8k9qJXC672e8mlfeajWjCnkX/7u9IqYdgpoIp6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6lyw78nmdhTHacVNGpVrgwGwkb8uCAIqraSj5x3S/c=;
 b=FQtOAOgowMkkoneLZ97K64TEjkc59AEuHCAYmxzHvcQwa/oMtCnrMEeULmgj2WxtRZXEwJisIzdmLzJHHZxRKZznYckOroHrTqG9DsDNSC3dyaURnmngkIm40tWzIrHjT+3SMEqpAmuVvKozc6WDIK1OwoRJSvURD0ZPpGXbTiFBeSYUZia4iLsC56eDqWRN8IFChQvB7QEgfZkfETL7uoKWZSeXIBvfrmPxuPja/RE7jYfIaXOFwA/ryoM/0UjWF1qH2qSBby0/F/fSZh1c8sxrN1kZe/+CLBN7hNHwJKwDHOTvrflpgC986PWJksOh8Qih3GArEUHhjhFTYgt5CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6lyw78nmdhTHacVNGpVrgwGwkb8uCAIqraSj5x3S/c=;
 b=Lrp/QHx9kl22RZQCnb7KJrjy37AM50wCmXpLW+OZ+/ZkYNW9APUR7/zHkcG3ajNmo7ZuJeSgph4lo9umnmuvfdw17KbgWiCO18UqRHTIOsjYpenNZ2KbiTsJzXYBBwaiBYyCBNiw2hmm6ZuOhF85aZJRJIFXfcdBorSjxblapIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB7191.eurprd04.prod.outlook.com (2603:10a6:20b:11c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:36:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:36:10 +0000
Date:   Thu, 23 Mar 2023 18:36:07 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] Remove skb_mac_header() dependency in DSA
 xmit path
Message-ID: <20230323163607.l2eqqpyq32hjhfow@skbuf>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <CANn89iKOrYUjY=aNkFFoDnq_XTQMGOajACMyd9+_gp8NNgz=-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKOrYUjY=aNkFFoDnq_XTQMGOajACMyd9+_gp8NNgz=-g@mail.gmail.com>
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB7191:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d843d8-1d93-4147-0824-08db2bbcb5d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8aLVXLbBJMsCPmF81zwiuxtK4o/084EUYoaC+QFZBkYPcRTKqsXc/dU4kU1BIYiv4svfs49Ou1Su4No6wME6UGCvLBAgu03Y0tQr+NZxFJYU/5I6FVbiMPK/f9CeaxUFtXeZdQceJDixz+nvySm9EssfC8YBPLy7OIUqywueYY1dOmpMxsWrRqbNtAW7wm04EFvT6V/otGVqTsfvQzUqt/4ZoptHbLcpSJBvGw3khCmpZvm1hcDM5OhMrKtQoqmOjVvpYOWl3kk9eZLv+3ln42FEJwInJqj5toNQhy+TcsyG4Tf9D6QAqNG423gk3hE4PpKiJxyhb4Fl0z9HweYfQUTVYdziPlK+klkIgUdHqgPpRzeCdufv0iMoT4Q4CnVQK5PXdt2KAKY0VvAs0TMxvRgwfk2TnYpttrIz9d+IlN3fWYjBczl7+HpkTcFEyAZos43YGoDM1iDMlvlHUM/0k1CPhQqlpyqRU29m88p1nJ/eFKcNd4DmXDYtMC5pTmjL4aoU6RNdS7WdEgxOE2vOy69VqzCmC7x9QW6tnB/yF8wAhdMEreMf0leEWnpiNLWSP+/nWpJbZ1w2mRv8HEWwS0EjkMqmAScYJfJ7R1DfmJrAVSX2U9g6/deDC7J44vye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199018)(66899018)(8936002)(66946007)(66476007)(66556008)(41300700001)(4326008)(6916009)(86362001)(8676002)(38100700002)(6512007)(53546011)(6506007)(1076003)(9686003)(26005)(83380400001)(186003)(6666004)(33716001)(316002)(478600001)(6486002)(966005)(54906003)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm9vQkZ6K0R6aDdvVnBBclBTMlRyaUwzR3dSMGtYRkh0Q05oa01EeDZGMmg0?=
 =?utf-8?B?bnVNVjNnNFU0SW1RQ3dWNVlLV1o2eG0zL0tMbUNtODlVYXBTNWVYdXBGN1RH?=
 =?utf-8?B?S0NrWkM4YnMwTmQ1WkRnLzQwQmlXdEEzRFpyK002ZWUrNk1ObjhVSG01V0FS?=
 =?utf-8?B?TWhnbExnME9sR0FxWlhTaGJhYlhGQTJXSkFJVjJlZVIyeThYZHI5RnFJNWZO?=
 =?utf-8?B?QzQyMEptRzFxOElRUzFQbFk5bzFXanE5dWdhRURrMmNzWjJ1VnphcnljVnNL?=
 =?utf-8?B?UForNFNINCtGc3ZQRENFSC9sL2F5YTVhVnljeWJPK3hURm9Zcy83dXJaU016?=
 =?utf-8?B?THRidi8xcnNMNlpOM3JPVUR3VEhDZ1AvYnhKSk9kS0NZcE9ZN0pWWjZxZ2gv?=
 =?utf-8?B?TmM5VU56ZkFEQjlDdHNmTzJTak56UjMzcnVtaWczcEdGekxkYmp4K0lFOTMz?=
 =?utf-8?B?bkdBWFIzbUNRTlpvWmZzM1N6MDh1eEt0aHYrUlk4bUNtQk9GWEpWcEUwUGov?=
 =?utf-8?B?R3FTV0cxcENDYW9Md2N2Y3BXQllVL2lwckhyVjhaMHd5Y3ZSUjdGZ0l3RXBS?=
 =?utf-8?B?eDdEQnU3YlVlZXhXaU9LMmRlZi92U3JyRmZtNnhCS1ZuYmZmLzVSdGMwYXE5?=
 =?utf-8?B?MUV3Y2U2MEIrNFI1Vm4zbG9YM0xOM2dVTm04SklmazZFTkM3aGc3K0o4cmUv?=
 =?utf-8?B?aGhjcEhlTFBDWkNoUStZNkpudEo1LzdaV1MwRkpuVHVCK3RFMVNVd3l0dFlI?=
 =?utf-8?B?Wlh4SE5qTG9YRk9HWVdSMnIySGpqNkZHRlIwU2tkeW1zM2NJNmZMRForQWoz?=
 =?utf-8?B?NkF1MjAxT0lxdGtPQ29YUnhBckhkdDk4dTBXWXYxVmdaMDBDL0hYV1JydllE?=
 =?utf-8?B?ZUh4UEdzRE4rLzZpZUViVkpxakFINjBoNENrZXp1bWh2SVlhQ3dpU1FDcTEv?=
 =?utf-8?B?aHQ1ZGhGeHNtdVluUkRpdjdaZ0Z6TElMZlkvSmw3cGU2NThYd0V1clNLVTRW?=
 =?utf-8?B?ZHFlMkdiQlJqaXQvdTlkYkhTQ1dieDhrRUtWSEJTZStCc0JXNDJKU0dkVVAv?=
 =?utf-8?B?U21rRXFUbjBlTThmRjhqMlhGZGZkK1orUWYrN0gwaEc1VkNlSE8zT1BPRnhB?=
 =?utf-8?B?RW0vSFFCK3FaaUJxOGdXVS9nY2p2cDREUHJNb01Ebk5aWkREMk0wVUwyNWkv?=
 =?utf-8?B?OS9TM0pUM1NaT2FrejhJN0dTaWZDUWpxYWlmZ2dYOGtWVys5M2d3ZEN3WXgy?=
 =?utf-8?B?ZVZrNlF5VkFJMW9rUENzWStCZkNqaysxYUJZemJ4NFpCTndNT0FFVzBtWFVh?=
 =?utf-8?B?TnRYQWlNOHhNUXEzb211WWhDUUlZS1Z6REdxenlXdmVtWDZTQytXQUlxVjU3?=
 =?utf-8?B?cXdKYkdCRkJweFNKUXNQNWl6MStmY1c3NGFtU2pIRVlCcnNVcUdzL2hUVlQy?=
 =?utf-8?B?dGg0WW5kTnJlcVFNeThsZVJFRExpV1RIcFlPUys5dVkvcFdsQVNxL0FTYzI2?=
 =?utf-8?B?aTBSRVFXWm1kSEwxK2gxeTNDbERFbmFERHlTQ0hGSGVPMC9BNFAwYk1KQjlk?=
 =?utf-8?B?NWFRcTlQS1dTanBqR3Jtb1VPRnpoSVBpR3FXL3BTTmVWdUcvdVRITi91SzNr?=
 =?utf-8?B?SHR4RlFYK0l2WjR5TUp4dTRSOWJtVzZqTmhDMEFNNVlzN1dOTk1Edm1KeWpx?=
 =?utf-8?B?YzQrVmI1WGhhOVBvNm82S0tXK2w3RCtxZXBsTWw1ZHBMZTh4YnZWSEpKZVpB?=
 =?utf-8?B?QVhaTDh3SmhlSStiT0ZPSlpqOGJkQm4vd0ZSUS9md2o2NnY1Y2owcjFvQTZD?=
 =?utf-8?B?N24xV292Y2s3RUZ0UUZkcVJGVGgzQjNsUmQvd2d4Yk9ibVBCY3lOejgzUGd5?=
 =?utf-8?B?ZUFNbmhrYmdzQ0MzMkQxbWZLUEl4VndCZ3MrOUVHcTdxckxubmQxUm9CaEc4?=
 =?utf-8?B?NE1sbGVCSFA5VkVDTktzS0FMdGpmQzVqRVFYcjcvNmUyV254SitEVjBSTzBa?=
 =?utf-8?B?blVnVlVJZklsS2NQdjBkWUhLM2FUZDRZZXlnS0xHUG5LdncxekhDSHJScnhZ?=
 =?utf-8?B?THF0aE9xdWZodDMzYU9mQmdsb0lSYm12UGJrV1B5N0YxTGVHSHp1L2d4K0Nk?=
 =?utf-8?B?TVJSbzYyNWI3WjNEUE5UNjR3MjJkZnRrN3htenMrbytRN2p1L1NZU09tNjRp?=
 =?utf-8?B?UGc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d843d8-1d93-4147-0824-08db2bbcb5d4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:36:10.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pxBjkdLGtYIKG9lkjlCHHFD2vMvVZ1r6uJSIrf/skd1q+09+RyJi9rnVrHSTxmgwlUFMIWyKdQQ1pN1rfmCsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7191
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Mar 23, 2023 at 09:24:28AM -0700, Eric Dumazet wrote:
> On Wed, Mar 22, 2023 at 4:38 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >
> > Eric started working on removing skb_mac_header() assumptions from the
> > networking xmit path, and I offered to help for DSA:
> > https://lore.kernel.org/netdev/20230321164519.1286357-1-edumazet@google.com/
> >
> > The majority of this patch set is a straightforward replacement of
> > skb_mac_header() with skb->data (hidden either behind skb_eth_hdr(), or
> > behind skb_vlan_eth_hdr()). The only patch which is more "interesting"
> > is 9/9.
> >
> 
> SGTM, thanks a lot !
> 
> For the whole series :
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

I'd have to resend this patch set anyway, due to the kdoc warning from
the last patch:
https://patchwork.hopto.org/static/nipa/732927/13184745/kdoc/stderr
(and also probably to CC the driver maintainers where I'm refactoring
stuff; didn't want to do that for what I was sure would only be the
initial patch set)

Have you seen my dilemma from patch 9/9 and from the cover letter -
__skb_vlan_pop() potentially being called from not just one xmit code
path? I took a different approach for vlan_insert_tag() (patch 1/9)
compared to __skb_vlan_pop() (patch 9/9). If we look at the larger
picture with the tc-vlan action, it would be a valid alternative to also
use skb_mac_header_was_set() in __skb_vlan_pop().
