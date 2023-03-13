Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970156B80F0
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCMSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCMSnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:43:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8346F35BC;
        Mon, 13 Mar 2023 11:42:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvvxnTDhBgGXTe/hOPjTtxKiGP71FtmpP9eYHtY0kWxtY7a0M7f+SwJF9MoGL7Amd3jiAT6HzDMsbEleJct0/6btfNPznF5hP7jsSymb367w7d9u+IK7vHo11JalaC+VouW95NOMzSXZhomTPRR2FwxkZF5x7POr5+Pm/2rfgnJj6NUgaoeCH/pY4xZ5d2jXwuMGXfRyJFRHGS14DyKf+7G+RIM/BlVkEYkBiJVgF2eeM0rF3bTFBTFYwgZUKx5NSGpGDn4RO/wEbu7Z+J8KCGB6R1NGw3/n/+agoVoUyybNykK78BoRlBqIymadOjAS8V/9DwlTlm50biuNJ0xPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORL59DGFjquWOg8VOmXWnl962iXErGiiaPD68FKQAR4=;
 b=FV4f7rS8r+JdkzBNa+J8MN2aRTdJcZi9uBIPXFObHhl9oKZc43u7kCGRC8MjngmnhJHMUxjnHrlQhfqQOZU1D6w9NYu01/E9ElP0XhF7250bKyLMOzUaAr2b8MABF7Z1N7ZDebqSAQ6ZgTyrdBZPFiUmQJlFELhkCiKMCQB+0mf9L9Oj2Po5R5WkO/uQQR75alTtbocGiwTO8SUaL4wouDcUyadHJ7zq9sXoLZLRK6TTw1dTdps/2U1XOmkWJqbEcrTcX0RVQWAX6u0DtGUDvJ0yHAkp/hX60/F17x58NXwDmuOZFANLYIRGKBJe8vXjMI5RKNg8OioUNX7dK8ZqGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORL59DGFjquWOg8VOmXWnl962iXErGiiaPD68FKQAR4=;
 b=n6kx/IXMqxOvqxFQB3xsm22koy/3dMLx6Ey+p6XQw3J5YcDjw2lURPRshYXpBl0ZOezVgYzV9tS3COMguuLqT4HiHzBa+TpiN3izDXNyflhn49boGwpUxcVLs645EaHDlRqtLHU3t/VgnJioUgapvELSulYCnhNpV6DxeNFat2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5443.namprd13.prod.outlook.com (2603:10b6:806:232::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 18:35:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 18:35:12 +0000
Date:   Mon, 13 Mar 2023 19:35:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH net-next] net: geneve: accept every ethertype
Message-ID: <ZA9s2Ti9PlUzsq/m@corigine.com>
References: <ZA9T14Ks66HOlwH+@corigine.com>
 <20230312163726.55257-1-josef@miegl.cz>
 <57238dfc519a27b1b8d604879caa7b1b@miegl.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57238dfc519a27b1b8d604879caa7b1b@miegl.cz>
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5443:EE_
X-MS-Office365-Filtering-Correlation-Id: a1eb04c8-2784-4f12-59e5-08db23f1ae31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 211LH8Fama2dT6r+U13miXRDn2LkHZkU0QU5hh6ILSLwqhkhVSnBrN9tor4RUAOkIPVgom1ZV/7w/D83olonng6tycc/FTxwpYl29JzXDSZCAWvYKhtyKU/1Bqt50oDGU5PBMkmG1tt//n2oDILjsOJD65z0pruxsT+0vdGFxvFxCoFqxUacllxKu1N4OCLBXUUyuI/b+N2j7cD9M4BuOW1h8A7l3HJ0YfiqJ3IFiPCmJqptHCq2vG7RQyyY18Fp3pgeYkJbuYvxmMJqkmYUMyuKxefavRPiksUxxGadMgjVyAUTpdeO+VKR48VP+M8QH5QAs01i6/7ym+HPVIALspFb5SlAQBER4P+NO79CvdMWxYQU+7tr5K7+hZi9XPF8j+ER+CK9eWD631Mw4q+lrArAUXCMvtINyRo+zmv9BICKK/BT4R03G6GwLShkxOtWbs35iXC6fREOePPO+/5jABjDQ2An+x877qhOErEAoMgVGHgSRlisJhcYsbWG6PDBqtba6gohbDSOJLBgUxQfHQ0LT+HQs38R6aevEmxo1bL/U4kSvPS+yWiFc5IOIihH2seNLKibY6vJhFWcycta9uKjd2ixBUbX2Z7GpmEMjW09rwkQyfO/p2lqfWmk6hN9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(39840400004)(136003)(396003)(451199018)(54906003)(41300700001)(478600001)(66476007)(8676002)(4326008)(66556008)(66946007)(8936002)(6916009)(86362001)(38100700002)(36756003)(966005)(6512007)(6666004)(186003)(6486002)(44832011)(5660300002)(2906002)(316002)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KKsqVUTeRJHyarRA2LwgXjYEx81y41Yx5c3Q6AXEaiq+wPdhsKQXjNrYBce2?=
 =?us-ascii?Q?Pz70feZ2gUpAgDh8QqeM2UoSKONq4Ut2/MZTe/md+e0Ae6vcm4aQXDoZLye4?=
 =?us-ascii?Q?cdDQ2msChFJdDYCvJMgz0kQbdNitz7b9Ur8V9nzsdDxtN/7Hto1L+fz4yOB8?=
 =?us-ascii?Q?Q2bjoEJ06f5yU5dDHXmyh6Vb01oV2NB2kEriKDPOKRcj42VMjfybk/jDN6QJ?=
 =?us-ascii?Q?PIXcPATACA0FqBNGQpL6HlbDVwM1MzDq6a2U+89tkhUamw7VHqzXixWZtGrU?=
 =?us-ascii?Q?DocNADVWLigLmWWcvGwrvfb0zUQoJaIpjS6vtbEqmkd/jJm1laWqr2kdJhoA?=
 =?us-ascii?Q?tbMUoGdMuaih2Jq9LgDPsGV6VdWAGZKU75CxySHuRco+wiVrWiRc6QcIlkDc?=
 =?us-ascii?Q?pWXTikyWeTmS8Mzwv9ii4EbeIRXSpIFAi+ak1phz7oH98u7bMgvvEWs8+3bZ?=
 =?us-ascii?Q?EXZ7NQAC5VZG0An70bGrLxmceZgvPAONbF9FbfZhQeClfBqL/1fUABISg4vR?=
 =?us-ascii?Q?ciXp6PqL9gHmQx0P/uG881NFpzLzinr8vZntZdy8UYfPHpDIaJAhUcPWmuA8?=
 =?us-ascii?Q?AeffL0nR6pcYr/1bp7dcgzNLjiwz50vmHzLMaZakTLJZcvL6YlCAqLbQEJ+l?=
 =?us-ascii?Q?9FaJrm/f/CZAzd4Pq75KzBN0chfZn+r3VEEgCxt+fgOH0wPmbpoPNfvJXt9Z?=
 =?us-ascii?Q?nsfjmH3NmrmCAB3DAlEn+oHXcl55bl04SMCnhBIeTe5R2P7nc37DkSwUXLDB?=
 =?us-ascii?Q?+HruEFBPUX2HVSU1zd0+Jomr4mNVF5THPq+6lAxcg6X9VzL3ns2tTFpdpXPx?=
 =?us-ascii?Q?aS9z3NOJJwSHvvnCfN0RQVwxu7HeVDPpvxU8PD5Bpc1uHl6CleIBH253b9b9?=
 =?us-ascii?Q?cCFD7hufdvouh4opHM5L6atblv3VwLJNkbXJDQHSJekAyqDFMW4AhI/tis3t?=
 =?us-ascii?Q?jD+7ZYoO7HTn2IdZj3+XCiFEcE7wl8MChqtIo8GN9U4LW976A/QV8vHxS2XY?=
 =?us-ascii?Q?jkDxunlT4NgcW/Ktx7cKYtL7o6l9tjeamBJM9/CaPzUuvWrSWQT64TV5zyWE?=
 =?us-ascii?Q?sPNAjuBxQ1lisQBXkXnVGvigpgwv5fuSODcZbR2QWr5+dAKIFLkeQ3nuxnBb?=
 =?us-ascii?Q?bOipZhMfbkJaty+rnB5K6kzaJImBs4MmXfE9gH0CXvXv08jxMttu6DdLy/YR?=
 =?us-ascii?Q?Lnr3EjE/IJrUlNZGHMLQMBF1ZtKOfrKQdysJJp+EEoUOKiUwa9bXdEG9Drgp?=
 =?us-ascii?Q?x2O56WUCphENeDl2psZMdWFtatGiB/xI8k5Mgu43JXylFp0W4PZF/0pD15pX?=
 =?us-ascii?Q?sBw8minpuFso5zFaaSnRmyl2Ev/MQaKEcC2NOK5fGWKJsuqryzwO17p16XfA?=
 =?us-ascii?Q?FoGVIs9MeLqYo8QC9KqwmoIB6wcfLf5ybIScZQCYGtxtiaNhB3P0JESLIfGA?=
 =?us-ascii?Q?nEyPcNqSpfGWsS97wWk+CmF7D6Bml5SDE79ILfXMQr6GC2KX5Iyr+adJpUps?=
 =?us-ascii?Q?B8CAdaz3MEHYoEhijgZT5sdjBDQSF9QHzGSh69MvWUomzsIT1XQ5Nj4UF4qi?=
 =?us-ascii?Q?N2h5ErFRIpUpd2MMX+JqUX8BCoWaw0LqY4b68FzuJT+ujZj6EsJdTOqlU1In?=
 =?us-ascii?Q?ZIWSUy25OBHvE7i8jYF2olPnWQGAo2brnYjxuYhAc1dVreG1h1LuA2PYZmkN?=
 =?us-ascii?Q?48YqnA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1eb04c8-2784-4f12-59e5-08db23f1ae31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 18:35:12.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLezDyrG/dB3ScZBrL3jiBcruk2fW5rUru+f6bjc5hvlAaWAdpc6f3b8gtK/7dNx8sK84FnXvWG7f7qZurTe3W1DQCd9DsL61trDNAUF8j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5443
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:14:58PM +0000, Josef Miegl wrote:
> March 13, 2023 5:48 PM, "Simon Horman" <simon.horman@corigine.com> wrote:
> 
> > +Pravin
> > 
> > On Sun, Mar 12, 2023 at 05:37:26PM +0100, Josef Miegl wrote:
> > 
> >> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> >> field, which states the Ethertype of the payload appearing after the
> >> Geneve header.
> >> 
> >> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> >> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> >> use of other Ethertypes than Ethernet. However, it imposed a restriction
> >> that prohibits receiving payloads other than IPv4, IPv6 and Ethernet.
> >> 
> >> This patch removes this restriction, making it possible to receive any
> >> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> >> set.
> >> 
> >> This is especially useful if one wants to encapsulate MPLS, because with
> >> this patch the control-plane traffic (IP, IS-IS) and the data-plane
> >> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> >> lightweight overlay networks a possibility.
> > 
> > Hi Josef,
> > 
> > I could be mistaken. But I believe that the thinking at the time,
> > was based on the idea that it was better to only allow protocols that
> > were known to work. And allow more as time goes on.
> 
> Thanks for the reply Simon!
> 
> What does "known to work" mean? Protocols that the net stack handles will
> work, protocols that Linux doesn't handle will not.

Yes, a good question. But perhaps it was more "known to have been tested".

> > Perhaps we have moved away from that thinking (I have no strong feeling
> > either way). Or perhaps this is safe because of some other guard. But if
> > not perhaps it is better to add the MPLS ethertype(s) to the if clause
> > rather than remove it.
> 
> The thing is it is not just adding one ethertype. For my own use-case,
> I would need to whitelist MPLS UC and 0x00fe for IS-IS. But I am sure
> other people will want to use GENEVE` for xx other protocols.

Right, so the list could be expanded for known cases.
But I also understand your point,
which I might describe as this adding friction.

> The protocol handling seems to work, what I am not sure about is if
> allowing all Ethertypes has any security implications. However, if these
> implications exist, safeguarding should be done somewhere down the stock.

Yes, I believe that the idea was to limit the scope of such risks.
(Really, it was a long time ago, so I very likely don't recall everything.)

As I said in my previous email, I'm somewhat ambivalent towards this.
My main purpose in mentioning it is to make sure any changes
made in this area are made deliberately with due consideration.

> > This would be after any patches that enhance the
> > stack to actually support this (I'm thinking of [1], though I haven't
> > looked at it closely).
> > 
> > [1] [PATCH net-next] net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
> > Link: https://lore.kernel.org/netdev/20230312164557.55354-1-josef@miegl.cz
> 
> This patch just adds IFF_POINTOPOINT to a GENEVE device, it is unrelated.

Understood.

> >> Signed-off-by: Josef Miegl <josef@miegl.cz>
> >> ---
> >> drivers/net/geneve.c | 9 ++-------
> >> 1 file changed, 2 insertions(+), 7 deletions(-)
> >> 
> >> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> >> index 89ff7f8e8c7e..32684e94eb4f 100644
> >> --- a/drivers/net/geneve.c
> >> +++ b/drivers/net/geneve.c
> >> @@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >> if (unlikely(geneveh->ver != GENEVE_VER))
> >> goto drop;
> >> 
> >> - inner_proto = geneveh->proto_type;
> >> -
> >> - if (unlikely((inner_proto != htons(ETH_P_TEB) &&
> >> - inner_proto != htons(ETH_P_IP) &&
> >> - inner_proto != htons(ETH_P_IPV6))))
> >> - goto drop;
> >> -
> >> gs = rcu_dereference_sk_user_data(sk);
> >> if (!gs)
> >> goto drop;
> >> @@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >> if (!geneve)
> >> goto drop;
> >> 
> >> + inner_proto = geneveh->proto_type;
> >> +
> >> if (unlikely((!geneve->cfg.inner_proto_inherit &&
> >> inner_proto != htons(ETH_P_TEB)))) {
> >> geneve->dev->stats.rx_dropped++;
> >> --
> >> 2.37.1
