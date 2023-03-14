Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963DE6B9BA1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCNQeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCNQeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:34:36 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C879A2C2E;
        Tue, 14 Mar 2023 09:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecMFa5c0kAupOxFbOSB8EMTscxS/Wvs0Iv+BVVT0JwXLR9jxTLjLLHQWaKmsVjIiaqvYd8EacSD83UMIcQVu2bsL9WFE/ftr7Pr3eBZdL7p1B0Glmjd/SkfwSRuHlcCBnLk+ZYPwVKCsYpTbxeYCbSHvBzLp5M1ujzWKnjmHtXJrrH3xWlDGQYxaguHhqzIGkt80vs08wXh0GBeseS6BCYu0NdwG1BroRxoCwZrLjJ59hdRTWvTGhV6KA6aIH+K6idROKH1AvbQ66qQDN7iq4qS+T7xLSwK/MKOqwzTK3FvOIb7sqKBeYrAGXitLUmJgPlmmpONQUohRp0WTXWsOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrKn5aGROGOID2IiNHgBMWDyOJatysnoEKt2I96HMNs=;
 b=Zm0CWN3Inl7FdfdPRA7kTxTRn+J1jhV0bEow0Bvx9MfJmGG15gggHj/mWGN1SwTYlAMaFuuv+O2dRm9qi4/idLl/Y26UwjSY1nWBLiW5znYybsc6G/wyd1nZ11ak8/dSNvXIhwn579WjQXoYxvn4P0OCL36jdEbF7R8TfCkzD33m33WhTblMRDS0CmhWjsJf44wSxdq/J4xOVowV/qfO6Fjon0Zp4QeUfOE4x8eb8QOzt10DEnPeWksuaMFOO4OC8EZNJzioymsa9DiEOJyzcEhq4oqLP5p1fohWtn72uM+mHUDQgvc2poOns34h8ASeDNGarJzSf8QDepAeCqW4wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrKn5aGROGOID2IiNHgBMWDyOJatysnoEKt2I96HMNs=;
 b=AAC1Q+IDbvYNGyJw/XAxlb7VFQB0Y7z/2ccDLcArlD2poTrog8mz3GijSWcOkpzS1NxU1yoVVi4c0xkLo3fNOPO0BpUni1l8IRF0fJCAuMcYJl9MHBFoQRhQsB7zGwlCGT9DqFAr3PelkVXFs0VnlxhWHKzznieVQMKWD2bKcfc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 16:34:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:34:08 +0000
Date:   Tue, 14 Mar 2023 17:33:59 +0100
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
Subject: Re: [PATCH v10 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <ZBCh98lGvhlMKQQp@corigine.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-4-neeraj.sanjaykale@nxp.com>
 <ZBBUYDhrnn/udT+Z@corigine.com>
 <AM9PR04MB8603E3F3900DB13502CFCB8DE7BE9@AM9PR04MB8603.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8603E3F3900DB13502CFCB8DE7BE9@AM9PR04MB8603.eurprd04.prod.outlook.com>
X-ClientProxiedBy: AM3PR04CA0140.eurprd04.prod.outlook.com (2603:10a6:207::24)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3957:EE_
X-MS-Office365-Filtering-Correlation-Id: aff92754-da93-4fb2-1809-08db24a9eede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8My7SARv5O1sHSoxU6wIy/JJx9vfyhQr1FFdbeEGlnrpR9HT7ifRTZKMMtSV74xRM2wSbSnoVFvPpaloIbPVh69hxNop9dyt92cedBjqTDKd4lZfeGjhxnC+DDo9enaKqae8c9PzlHX4driRiT41pJQarOUGpmxvUugqtb/omAIRWiS0nqzccHVsFTgHPHTRRZUkZnqP98K2pWFzD5sM+ZUbC0UWTonIMN3H6kAXq5cXWZt1WNwKRNWHCkmSw0r9XqC80wToKZP5LYcMvhVy+Qle58ocTcBj5H3eX64AmSSvZFFcRMmHPmYfSMp/wxhxf8C6d83BM5dCDm0GHXJcU3CiOSvA7ghwwUAnGFHPxW2djLl4kdKjYFYrwHbqo/yTvZE8uJQdeGls8JnwiBJqv0F+JAbeJh8iEvrnea/DCNDKBEJDA5VEFT7+M5Y8nODoeUOjvKWFwXIhs+5pFnAyc6LtEwaR2jGZL+UcEiAE5R2387xc28qZkOimZRoXlkk52fSsWusIQHpPTii0l9nK66mee6VcKde+XjWZq6s0nQ+e72TS7XNvykkiG+1gvrmj5+VBnEJ/QhbiFgaIG2k6FKs8JKjQiA/YLJIhi9wqy+tOAEXMOKz/RCQYySdaf5pCiYUj12phnFomugFrIJJeNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199018)(86362001)(36756003)(38100700002)(8936002)(41300700001)(2906002)(44832011)(7416002)(5660300002)(4326008)(6916009)(6512007)(2616005)(186003)(6506007)(83380400001)(54906003)(316002)(66946007)(66556008)(66476007)(6666004)(6486002)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZOmY02ePl13XyutcQGyciJcajIULofEGKW7bS+ZvGkE3I7r2v+rLkQxKf28?=
 =?us-ascii?Q?ADUcQhytOp6RfBXTtHBhoBs8PLRZeZ0ZXYoJo0uPcZKqzWGhzpwU5u+ako7R?=
 =?us-ascii?Q?lNyvLnGvRGzMMLlgGNYbmtT4bILjSwUUBY9biVjlFs6pAFjvn+IFZ944eGN8?=
 =?us-ascii?Q?AFPfsWNz4nue7r22askICyGgMXfS/1wyWyVm4HXHy8b/E6YXvUzYjq0zwtu1?=
 =?us-ascii?Q?+HnHdsMi2TsOdkFJJN41DVm5dbzZ2ZnyC2zyvedtBDC5VZwPx3r/9razRaB+?=
 =?us-ascii?Q?vFw8eO6ThldrzF+uXkV8OxZ20BnZ2VfF+AmGXDBIWqSU4JEsLk4M5nbG268g?=
 =?us-ascii?Q?lTbHNgu+2UZoTXgdRThPII5JCVdTv8CUIBHZ4xVKnjKe9cBhuMzAfWIiT/VO?=
 =?us-ascii?Q?/Y1CnZpxfniKr2xzm1MO6yDiBsma+hdHiuIvTkzOdfH7dTB3lGUC/PUBP1yQ?=
 =?us-ascii?Q?JPUoxSR5XUfqBOTw55jeMj/X1BnlY7viE7rtTDTIe2slN6ibFIzHNP9gNOLq?=
 =?us-ascii?Q?5AQldmcMm4DAVDBo0jay/E36ERS2zUhMZQIWetAx9fa2RO/kQDyBO8+m8WJg?=
 =?us-ascii?Q?sMVvnUBPuf95XsyAsP46Fipj10OvzM9K/IX3/2/Y6gkjb2eZyYrmLS78B3+h?=
 =?us-ascii?Q?1QSwU6cmXRxe6xkcmom5F1CSWighgeyyL/5OG3ZtrWkHOPJFwxrRlqOafmXD?=
 =?us-ascii?Q?jmeuC6XGGAeyHbH+EDJG724V4qqRQwARNZQFTmdOZcOzZ5mXTSq4ypoNnM43?=
 =?us-ascii?Q?l/SyOsB9p2Em2sBc45xihyqBbnGcG2O2CWHQxsFMmPsjLaKCi88+Ksi7HnRU?=
 =?us-ascii?Q?IOJw+OkSO5pEsTLtUJCjBsjldwk/DNrnxGYi62aOCJh4yT1yIOQb2THesp3z?=
 =?us-ascii?Q?Sd6NJZTRmvmxwV6u1D82/3saKO7lW422XHvi4XfmkqIwcKUhewXIjpUb0dzc?=
 =?us-ascii?Q?fCDk1Tq+F29rdT78lYYmPVDbFBnlG2GBLl0sEt4LjiXI99rVfX1nCjoV4AvL?=
 =?us-ascii?Q?+ncXy3LlDrjNGIVA4Yc4QwXO/PF3PPZZvSVUro5gERCB5qPCxUD+2TgJL/I4?=
 =?us-ascii?Q?RHpTA9O8zFMlJwTz8aviZzgTqKu/XRL6q0+Od54PkVA+v+0m+hliSMbgP4hY?=
 =?us-ascii?Q?nMlmf8KAwCwxyIH5Faq57NqXE/Fs80UGIPGp2rUBhSFJR/tmSKHS5WJzekSd?=
 =?us-ascii?Q?HIcmrLA+VVW46afW+q1XjNL8zcNEVi+VkL56Sq0ecEkrKmZpPCxj0QY1eOWA?=
 =?us-ascii?Q?B6LoAqzfUbxgtuZltUTsXQOrnluiBSrSbbxl+l2tl5QXU5x5sH2bOAF9XVpG?=
 =?us-ascii?Q?ANP0vJqqSg4JbQdSKSgrjdZ2WgmMxnAfENshCVp4gyGBZq0UnhQ7BpeQPrJs?=
 =?us-ascii?Q?i/9u901cyrUZJolqg/AjOruDJUQZmNIJ6DB85aDUaSU7RlV/NXgH++aTV1FT?=
 =?us-ascii?Q?E+9UdpdNmDCei+Z1hEhoeGaP2mZ+eM7ERtbEgLkqJw1sO+29DyC6CyXi8u+T?=
 =?us-ascii?Q?/ke736Mjjbm/lLQvOfZXP48DC5/ZMbJod6ce6FZQcQ0Hdv9ubcq91aWWqwq6?=
 =?us-ascii?Q?oLx1c9CPniFTPnle2RsKHxUxMh4NCrlINWkwZiVUmrskPytdJHdA7CgrqLtG?=
 =?us-ascii?Q?n4uGL4g3sXp5RqgmRM0y4B1eSRY8iZBKFX6Ro1zW3cUy7gH8WWl0mN4vyu35?=
 =?us-ascii?Q?KqBLsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff92754-da93-4fb2-1809-08db24a9eede
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:34:08.0068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wzO6CVuOwaD6JKO/qIok7SmO0WTieZ899ZH5fL1nSdhiV/8DV0X6gU9z/cS/7DMtv3SurUJWZ+uwQEu40J55DMHUR4OBCaziugHjgPsJHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3957
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:40:34PM +0000, Neeraj sanjay kale wrote:
> Hi Simon
> 
> Thank you for reviewing the patch. I have a comment below:
> 
> > 
> > > +send_skb:
> > > +     /* Prepend skb with frame type */
> > > +     memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> > > +     skb_queue_tail(&nxpdev->txq, skb);
> > > +
> > > +     btnxpuart_tx_wakeup(nxpdev);
> > > +ret:
> > > +     return 0;
> > > +
> > > +free_skb:
> > > +     kfree_skb(skb);
> > > +     goto ret;
> > 
> > nit: I think it would be nicer to simply return 0 here.
> >      And remove the ret label entirely.
> > 
> > > +}
> > 
> We need to return from this function without clearing the skbs, unless "goto free_skb" is called.
> If I remove the ret label and return after kfree_skb() it causes a kernel crash.
> Keeping this change as it is.
> 
> Please let me know if you have any further review comments on the v11 patch.

I'll look over v11.

But for the record, I meant something like this:

send_skb:
     /* Prepend skb with frame type */
     memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
     skb_queue_tail(&nxpdev->txq, skb);

     btnxpuart_tx_wakeup(nxpdev);
     return 0;

free_skb:
     kfree_skb(skb);
     return 0;
}

> We need to return from this function without clearing the skbs, unless "goto free_skb" is called.
> If I remove the ret label and return after kfree_skb() it causes a kernel crash.
> Keeping this change as it is.
> 
> Please let me know if you have any further review comments on the v11 patch.
