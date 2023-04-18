Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4F76E6221
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDRMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDRMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:30:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2FECC3E;
        Tue, 18 Apr 2023 05:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITi8+dsvXC8gtnCSbnXAg7uB04lS5vO4dZkSvSKqk8bRXvPu7KhbYFBDmyqeO0FWuO0TSdx7+Wci1RysIXq3JWjhdZzkk7wKg5swhqp3sRFvoJqAZiwINZU4sKoPEPucfxly89wksqxNCG6NrkE1B3IBC/dy+IkGpXE8nUpIEHcNPqemrqaxLxiKbAnMZrG6IRwroZuP+ar7hBIOvAheoekY4FTxMtbqmUEy5H4ZbUfa1puTWoP3PEmothZQHUYucitocGL5E0Z67uBiMaqj96le/1x92d1n34k/bPGa+CQpAzzmSbZXBDMrF+ks6suDmtJuarl4XFOtFNcRjtIbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ez5eQoRm4ZpJwgwTBcmocn8dQeIxdtgXmHJ116KA6fE=;
 b=HoJYxmsCgfBLC6mByWwVoq25dLxjvMKOLiBnsggi5TTglX2iQhiaOjAwI3mmVeGMY3ChBvyuTJloKTl7nLn3E9pgvqozocyHPvTQ8cYk8vKl9nLGe9CdP4TtCvVHrV0mzyXB2FWWEUnnsk8GK7fNJ6mmX7ExVVEK23ijBGaEnAGLc8amImeH3IrjcOQ7siSXt0Jzd3IMAMsF8bi8Vveg08HN6sRDM1s2WBRpO0IUOb8oOyJsTXIZ5rNvvxOfOJIbyst0iAHI3l6oWBy5AXKa4f+wKeFq91v8Yc5lMvbs62Y84qhAtUQNdzsYCal7nnKcgSQflCA5Q1fa3FwquJqZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ez5eQoRm4ZpJwgwTBcmocn8dQeIxdtgXmHJ116KA6fE=;
 b=HkEiviaRDoW+VHjKv+hpRz9CkilgMnsgDNMPU9XHgjoufTLN3DdtHLzL8yxWlx2WwVhZEmm2HsLiXqABsfTMiW9zI1KvWUkG4a//681B5cSSs8Kg8Y0qU4UpgNrQOIr/ts06cg2amVfZo9TnVPS/C7MLzAjeD7ZAeKWxyIhiaC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6056.namprd13.prod.outlook.com (2603:10b6:806:330::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:29:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:29:21 +0000
Date:   Tue, 18 Apr 2023 14:29:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/6] crypto: hash - Add crypto_clone_ahash/shash
Message-ID: <ZD6NGchekDuquh1s@corigine.com>
References: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
 <E1pmqNX-00FNVU-KA@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pmqNX-00FNVU-KA@formenos.hmeau.com>
X-ClientProxiedBy: AM4PR07CA0006.eurprd07.prod.outlook.com
 (2603:10a6:205:1::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: e208a1e8-689f-489b-f2c2-08db4008898b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P63MsTrt5NVIQhK+7jMQ+9deFpsSkkPbtOUQ1SPiNhSa+6w9qelOUwN4RgLmS28TKxHztbFX7KViblIeFS0cUytQDmvwzhR0tsGYaE73k6LgItiiXaDxyDhpqKcUfboikdSK05J30wl5SZk42ROgmwnUgo0a+ZPKE8ER7V8Iw07YnxrINZ/Im1G1fTAeaCGSmqNEhld31Z7segwFkiDMBoy6GBu4TkEvOOBYkha0xqJsz9TNq/14MDMUjZAQfT4VErum2plMaBGZWzdGNtNOOgmkPKqGMeBqQ2r2k3Y8Cd5CY0zuEsjKCl0fnXVBuk59R+uUGQUluVBu4oLRyVWTPyoin4l+e3GcSMC3Pvaff1Bi6UjVB3jBouoIWmRBg6hrA3r//lzr/5ZBDAx5aLDz7aPQl/6YYYQzthZNbQKaoe3VpT67H45GsiNKEh9OCk5UIw1dM3J7gKpaP2VuaDWD+oR8M7qTJAQ+cmOwmE7uRXxKOKdH9pfeB4vSAPz4yC85nZtWyM+bxtBr880C/bzF/Z898Zhca9HfD95YigFA8BrxCp6+gMOUKwM3VpX09XSa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(396003)(346002)(39840400004)(451199021)(6916009)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(41300700001)(4326008)(66476007)(66556008)(66946007)(54906003)(186003)(2906002)(4744005)(36756003)(6506007)(6512007)(86362001)(2616005)(5660300002)(6486002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ozj0CCx+gs0r4wI/v91t7UmUmG/9XfQM0yYeuWLXwI51Xx1A1sDcu/rbUI2O?=
 =?us-ascii?Q?gsmtfyWzcMjSdsgSInb0cQlJSTattjPc7vFDG3b5H19/NcOdIZUtWSDelieT?=
 =?us-ascii?Q?FppK4faB9FBcZGbxVoiWU8/2IPpTtb3U84x9O/TKxWB0UQkXw66XDB039qQQ?=
 =?us-ascii?Q?ptpOvG49RUxljFBL2ECqcoq5Fhdw35rjKHv6be6keFps6odQ3WE5Db7QcOzk?=
 =?us-ascii?Q?M6RSQUGqNpszFX/L+wjv6tufkE4gujd0aF4tbtcKkjJOhfD+ESiFoBZuXB8I?=
 =?us-ascii?Q?dZAM2V6KCYGfd6zP3yNhxTTID8VcVaM+aPoihqjfiiFA0toTRye19EY/FKHC?=
 =?us-ascii?Q?uLu65L1ldjWWFqOn8Ir9InQkCI/8eyBVwsgp9f2yKBAMhH/VC+5Npzt6y1kH?=
 =?us-ascii?Q?VBjg6BF1+FYTSCWcJLNyn/BXUWm4a1TTNl6xbyNtKrcm4XU8B1QyFckP1TTg?=
 =?us-ascii?Q?JB646RXCMfy2UaDU1cgRL1BmfwL4KfrfZNCT0KRC2LS+UafaZUJtSOxWsAZC?=
 =?us-ascii?Q?s7aBdg0MpdPYfclhUni2BYeWwE6mZrUTQuXaCN1aGGbO5mek0LB9+itsT+op?=
 =?us-ascii?Q?u8oJ3tRCRyAwFwxbICs3Vx0BU7OZJZgKa2OwC3iC/PINX9Skf6eszcTwVvZS?=
 =?us-ascii?Q?jKLhoCnNXJ9lYSfhIpEjmN3KrZkbkYwg5T9JPsI0cuKu0NpwZL7bDvJ28rQp?=
 =?us-ascii?Q?7H0n7lsVVc4BlPC6A3wOZ/usklD6fDrdNRz9rZr1kVfb+3XO9oO9T+tW5USQ?=
 =?us-ascii?Q?8hwCe+Q1S6GXaYfuI04e9Ea5AerGCZ2eaUUizeY9sxdDsUYWe0xX6iMlkb4a?=
 =?us-ascii?Q?ZyXhQusQ3znnES/cpPrdYfdWq2mhAopXM0UTgoZn0HQFCRjyN3CWTrtGgWpD?=
 =?us-ascii?Q?MtyIPGfZX68k9fy+kNOeOQNZC7+/ZyIq63PkmJW90h0jatHPw9fLxBWAV74E?=
 =?us-ascii?Q?hiGfdXLrBhLytSUdDnvQqsgZ0LNdYNNG4Dy4AGGqRz1jMLvO70LwIotR0pQ+?=
 =?us-ascii?Q?AqYxVQApK6xyRoPcmhx9KqlP9dH/mE7yufsCleBY/8RCFPx/H+Ah0axRrU12?=
 =?us-ascii?Q?vmodHYaZcaXd3kVrnsauFGC6WGHZeoKNCLlyr4+Nml5c8+lGxSnJF3FTivyj?=
 =?us-ascii?Q?Fqg/jQh/Q6OyJgTRbW50cG5xV9LYZkfo2PR0SbnxBkupMU8ub96QcU+YQ8rE?=
 =?us-ascii?Q?KLJ9iJRJ+RdOrzD7jKP2c60rG6y/NjnyI7DVe4NP6ze8oxylD/WGmq0w7s8O?=
 =?us-ascii?Q?Zbf0i6C7gp1Bf6YTTLL93w9Y5h6XUhPktOUAlmpRv4GdoIjw/U4Xh9KZpJr3?=
 =?us-ascii?Q?XldTJ1QsUpw91ggedW11VXKCeTm/XWa7QZewl4gChbx4PDocs+SKgA/8Y00g?=
 =?us-ascii?Q?WZ/JxftQyt4Yd4vtVhqNSJApL/Pk2+Otv4A4kZYXUEoKR+VFsU4j5MuNbIly?=
 =?us-ascii?Q?9TSb/ITrYF09ivDl2z2yPxhtEQY7WeRjzwSckreEpzbQ+64v0fo12bkHXRww?=
 =?us-ascii?Q?yVysudxWvFZSMbvqgPkT1hxFTCxRQFfu+7Y0PDTYui37n4NktTboScGd+Rqo?=
 =?us-ascii?Q?1IpfoO0zv3Nf/sniDeAI7XObF67tQlVfDqHjGA0XUGAI3S+iQuBInqmcI/8L?=
 =?us-ascii?Q?xoVlZbuEVmWYyVjdLlpAgYasPZmz2dW/B5wWTTR6kepeItoT1SL7Vi1qFGgW?=
 =?us-ascii?Q?rYtZgQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e208a1e8-689f-489b-f2c2-08db4008898b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:29:21.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pG/I2rL+maQMRIx/1sOBlJpNZKkZ1lbOvs6ctx/pCSJqcJg2LMp+UJK6syx2HgAe0DAZOIa3/0NinnAbTHG5QzmLskrzQrCxCWxWTXU5L/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6056
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:24:19PM +0800, Herbert Xu wrote:
> This patch adds the helpers crypto_clone_ahash and crypto_clone_shash.
> They are the hash-specific counterparts of crypto_clone_tfm.
> 
> This allows code paths that cannot otherwise allocate a hash tfm
> object to do so.  Once a new tfm has been obtained its key could
> then be changed without impacting other users.
> 
> Note that only algorithms that implement clone_tfm can be cloned.
> However, all keyless hashes can be cloned by simply reusing the
> tfm object.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

